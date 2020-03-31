*! version 2.0.4 PR 06Aug96.  modified last 10sep2019 
program define for5_0
	version 5.0, missing
	/*
		Note: $FOR_* used instead of $S_* macros internally
		to avoid messing up access to $S_* via %%*.
	*/
	split ":" "`*'"
	if "$FOR_1"=="" {
		global FOR_2
		di in red "for-list empty"
		exit 198
	}
	if "$FOR_2"=="" { errexit "command" }
	/*
		Substitute hashes for spaces in the stata_cmd(s)
	*/
	parse "$FOR_2", parse(" ")
	while "`1'"!="" {
		local cmdhash "`cmdhash'`1'"
		if "`2'"!="" { local cmdhash "`cmdhash'#" }
		mac shift
	}
	/*
		Extract for optionlist, heralded by the first single comma
	*/
	split "," "$FOR_1"
	local optlist "$FOR_2"
	/*
		Get the forlist(s).
		"\" is a reserved char here; double \ does not work.
	*/
	local nlist 0
	if "$FOR_1"!="" {
		local i 1
		parse "$FOR_1", parse(" \")
		while "`1'"!="" {
			if "`1'"=="\" {
				local i=`i'+1
			}
			else {
				local forl`i' "`forl`i'' `1'"
			}
			mac shift
		}
		if trim("`forl`i''")=="" { errexit "$FOR_1" }
		local nlist `i' /* no. of lists */
	}
	* The cmdsep, macro() and mstub() options, inherited from -forx-,
	* are not documented in the help file, nor is the multiple stata_cmd
	* facility. These features still work.
	local options "Any noHeader noStop Pause Ltype(str) Cmdsep(str) Quote(str) MAcro(str) MStub(str)" 
	parse ", `optlist'"
	if `nlist'==0 & "`ltype'"!="" { errexit "ltype, no forlist(s) specified" }
	if "`ltype'"=="" {
		if "`any'"!="" { local ltype a }
		else local ltype v
	}
	else {
		if "`any'"!="" { errexit "options, any not allowed with ltype" }
	}
	local tlen : word count `ltype'
	if `tlen'>`nlist' & `nlist'>0 {
		errexit "ltype(`ltype'), number of items should be <=`nlist'"
	}
	if length("`cmdsep'")>1 | "`cmdsep'"=="\" { errexit "cmdsep(`cmdsep')" }
	if "`cmdsep'"=="" { local cmdsep "/" }
	if "`macro'"=="" { local sub "%%" }
	else local sub `macro'
	if "`mstub'"=="" { local mstub "S_" }
	local sublen=length("`sub'")
	if length("`quote'")>1 { errexit "quote(`quote')" }
	local ll 1
	local i 1
	local prev v
	while `i'<=`nlist' {
		local w : word `i' of `ltype'
		local t `w'
		if "`t'"=="" { local t `prev' } /* pad with most recent list type */
		local t=bsubstr("`t'",1,1)
		if "`t'"!="v" & "`t'"!="a" & "`t'"!="n" { errexit "`w'" }
		local any`i'=("`t'"=="a")
		if "`t'"=="n" {
			lexp `forl`i''
			local forl`i' $FOR_1
			local t "a"
		}
		if "`t'"!="a" {
			local varlist "req ex" 
			parse "`forl`i''"
			local forl`i' "`varlist'"
		}
		local ll : word count `forl`i''
		if `i'>1 {
			if `ll'!=`ll0' {
				errexit "`forl`i'', inconsistent list lengths"
			}
		}
		local ll0 `ll'
		local prev `t'
		local i=`i'+1
	}
	/*
		Break up `cmdhash' into component Stata cmds
		according to double `cmdsep'
	*/
	local s
	local slash 0
	local i 0
	parse "`cmdhash'", parse("`cmdsep'")
	while "`1'"!="" {
		if "`1'"=="`cmdsep'" {
			if `slash' {
				local i=`i'+1
				local cmd`i' `s'
				local s
				local slash 0
			}
			else local slash 1
		}
		else {
			if `slash' {
				local s "`s'`cmdsep'"
				local slash 0
			}
			local s "`s'`1'"
		}
		mac shift
	}
	if "`s'"!="" {
		if `slash' { local s "`s'`cmdsep'" }
		local i=`i'+1
		local cmd`i' "`s'"
	}
	local ncmd `i'
	/*
		pos indexes the position reached in each forlist
	*/
	local pos 1
	while `pos'<=`ll' {
		local i 1
		while `i'<=`nlist' {
			parse "`forl`i''", parse(" ")
			local f "``pos''" /* pos'th item in i'th list */
			if `any`i'' {
				parse "`f'", parse("#")
				local f
				while "`1'"!="" {
					if "`1'"=="#" { local f "`f' " }
					else local f "`f'`1'"
					mac shift
				}
			}
			local for`i' "`f'"
			local i=`i'+1
		}
		/*
			Run thru the Stata cmds (indexed by j)
		*/
		local j 0
		while `j'<`ncmd' {
			local j=`j'+1
			parse "`cmd`j''", parse("@#")
			local cmd
			local a 0
			while "`1'"!="" {
				if "`1'"=="#" {
					if "`2'"!="" { local 1 " " }
					else local 1 /* chop trailing space */
				}
				if "`1'"=="@" {
					local a 1
					if "`2'"=="@" { local 1 1 }
					if "`2'"==""  { local 2 1 }
				}
				if "`1'"!="@" {
					if !`a' {
						local cmd "`cmd'`1'"
					}
					else {
						local arg=bsubstr("`1'",1,1)
						cap confirm integer num `arg'
						if _rc { 	/* @<nondigit> found */
							local arg 1
							local p1 1
						}
						else local p1 2
						if `arg'==0 { local arg 10 }
						if `arg'>`nlist' { errexit "@`arg'" }
						plsp "`1'" `p1' /* preserve ld space */
						local c=bsubstr("`1'",`p1',.)
						local cmd "`cmd'`for`arg''${FOR_1}`c'"
						local a 0
					}
				}
				mac shift
			}
			local c "`cmd'"
			local c2
			local s=index("`cmd'","`sub'")
			while `s'>0 {
				local s2=`s'+`sublen'
	*			plsp "`c'" `s2'
	*			if "$FOR_1"!="" { errexit "macro name in `c'" }
				local fchar=bsubstr("`c'",`s2',1)
				plsp "`c'" 1
				local c1=bsubstr("`c'",1,`s'-1)+"\${`mstub'`fchar'}"
				local c2 "`c2'${FOR_1}`c1'"
				local s2=`s2'+1
				local csp=bsubstr("`c'",`s2',1)==" "
				plsp "`c'" `s2'
				local c=substr("`c'",`s2',.)
				local c "${FOR_1}`c'"
				local s=index("`c'","`sub'")
			}
			local cmd "`c2'`c'"
			if "`header'"=="" {
				di
				if `ncmd'==1 { di in bl "-> `cmd'" }
				else di in bl "-> [`j'] `cmd'"
			}
			local iq 0
			if "`quote'"!="" {
				local iq=index("`cmd'","`quote'")
				if `iq'>0 {
					local Cmd1=bsubstr("`cmd'",1,`iq'-1)
					local Cmd2=bsubstr("`cmd'",`iq'+1,.)
					local iq2=index("`Cmd2'","`quote'")
					if `iq2'==0 {
						errexit "`cmd', unmatched quotes"
					}
					local Cmd3=bsubstr("`Cmd2'",`iq2'+1,.)
					local Cmd2=bsubstr("`Cmd2'",1,`iq2'-1)
				}
			}
			if "`stop'"!="" {
				if `iq'>0 {
					capture noisily `Cmd1'"`Cmd2'"`Cmd3'
				}
				else capture noisily `cmd'
				if _rc {
					if _rc==1 {
						global FOR_1
						global FOR_2
						exit 1
					}
					di in blue "r(" _rc ");"
				}
			}
			else {
				if `iq'>0 {
					cap noi `Cmd1'"`Cmd2'"`Cmd3'
				}
				else `cmd'
			}
			if "`pause'"!="" { more }
		}
		local pos=`pos'+1
	}
	if "`quote'"!="" & "`header'"=="" {
		di in bl _n "[Quote character is " in ye "`quote'" in bl "]"
	}
	global FOR_1
	global FOR_2
end

program define lexp /* based on modified reshape.rsgroup program */
	parse "`*'", parse(" -")
	confirm integer number `1'
	global FOR_1 `1'
	if "`2'"=="" {
		exit			/* returns a single integer */
	}
	if "`3'"=="" {
		confirm integer number `2'
		global FOR_1 "`1' `2'"
		exit			/* returns integer1 integer2 */
	}
	local last `1'
	mac shift
	local j 1
	while "``j''"!="" {
		local arg`j' ``j''
		local j=`j'+1
	}
	local j 1
	while "`arg`j''"!="" {
		local aj `arg`j''
		if "`aj'"=="-" {
			local j=`j'+1
			parse "`arg`j''", parse(" /")
			local aj `1'
			confirm integer number `aj'
			mac shift
			local inc 1
			if "`1'"=="/" {
				mac shift
				confirm integer number `1'
				local inc `1'
				mac shift
			}
			if "`1'"!="" { errexit "syntax" }
			if `aj'<=`last' { errexit "syntax" }
			local i=`last'+`inc'
			while `i'<=`aj' {
				global FOR_1 "$FOR_1 `i'"
				local i=`i'+`inc'
			}
			local last `aj'
		}
		else {
			confirm integer number `aj'
			global FOR_1 "$FOR_1 `aj'"
			local last `aj'
		}
		local j=`j'+1
	}
end

program define split /* split splitchar string */
	* Also translates double schar to single schar.
	local schar "`1'"
	mac shift
	if index("`*'","`schar'`schar' ") { di in bl /*
 	*/ "[warning: trailing space(s) removed from `schar'`schar'<space(s)>]"
	}
	parse "`*'", parse("`schar'")
	local split 0
	local done 0
	while "`1'"!="" & !`done' {
		if "`1'"=="`schar'" {
			if `split' {
				local split 0
				local s "`s'`schar'" /* schar schar -> schar */
			}
			else local split 1 /* note schar */
		}
		else {
			if `split' { local done 1 } /* schar then not schar */
			else local s "`s'`1'"
		}
		if !`done' { mac shift }
		else {
			while "`1'"!="" {
				local c "`c'`1'"
				mac shift
			}
		}
	}
	global FOR_1 "`s'"
	global FOR_2 "`c'"
end

program define plsp /* preserve leading spaces */
	* 1=string, 2=position to scan from.
	global FOR_1
	local i `2'
	while bsubstr("`1'",`i',1)==" " {
		global FOR_1 " $FOR_1"
		local i=`i'+1
	}
end

program define errexit
	noi di in red "invalid `1'"
	global FOR_1
	global FOR_2
	exit 197
end
