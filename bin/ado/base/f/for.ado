*! version 3.1.13  16feb2015
program define for
	if _caller()<6 { 
		for5_0 `0'
		exit
	}
	version 6.0, missing
	gettoken piece cmd: 0, parse(" :") quotes
	while `"`piece'"' != ":" & `"`piece'"' != "" {
		local for `"`for' `piece'"'
		gettoken piece cmd: cmd, parse(" :") quotes
	}

	if `"`piece'"' != ":" {
		error 198
	}

	local i 0
	gettoken su for: for, parse(" ,") 
	while `"`su'"' != "" & `"`su'"'!="," {
		local i = `i' + 1
		if `i' > 9 { 
			di in red "too many lists"
			exit 198 
		}
		gettoken in: for, parse(" ,")
		if `"`in'"' == "in" { 
			local from`i' "`su'"
			gettoken in for: for, parse(" ,")
			gettoken su for: for, parse(" ,")
		}
		else 	local from`i' = bsubstr("XYZABCDEF",`i',1)
		GetType `"`su'"'
		local type "`r(type)'"

		local j 0
		gettoken su for: for, parse(" ,")
		while `"`su'"'!="" & `"`su'"' != "\" & `"`su'"'!="," {
			if "`type'" =="any" {
				local j = `j' + 1
				local su`i'`j' `"`su'"'
			}
			else 	local su`i' `"`su`i'' `su'"'
			gettoken su for: for, parse(" ,")
		}
		if "`type'"!="any" {
			if "`type'"=="varlist" {
				if "`su`i''" != "" {
					unabbrev `su`i''
					local thesu "`s(varlist)'"
				}
				else	local thesu
			}
			else if "`type'"=="numlist" {
				numlist "`su`i''", min(0)
				local thesu "`r(numlist)'"
			}
			else if "`type'"=="newlist" {
				Fixnew `su`i''
				local thesu "`r(newlist)'"
			}
			else {
				di in red "type `type' not yet implemented"
				exit 198
			}
			parse "`thesu'", parse(" ")
			local su`i'
			local j 1
			while "``j''" != "" { 
				local su`i'`j' "``j''"
				local j = `j' + 1
			}
			local j = `j' - 1
		}

		if `i'>1 { 
			if `j' != `nj' { 
				di in red /*
				*/ "lists have unequal number of elements"
				exit 198
			}
		}
		else	local nj  `j'
		if `"`su'"' == "\" {
			gettoken su for: for
		}
	}
	local ni  `i' 

	local in
	local options "Dryrun noHeader noStop Pause"
	parse `", `for'"'


	if "`pause'"!="" {
		local pause more
	}

	if "`header'"=="noheader" {
		local qq *
	}
	if "`dryrun'" != "" {
		local xeq "*"
		local stop
	}

	/* 
	check that command (which may be a composite at this point)
	contains the necessary substitution parameters 
	*/

	local todo `"`cmd'"'
	local i 1
	while `i' <= `ni' { 
		local todo : subinstr local todo /*
				*/ `"`from`i''"' `"`su`i'1'"', /*
				*/ all count(local c)
		if `c'==0 { 
			di in red `"`from`i'' not in command"'
			exit 198
		}
		local i = `i' + 1
	}

	/* 
	breakout composite commands 
	*/
	local ncmd 1
	gettoken piece cmd: cmd, parse(" \") quotes
	while `"`piece'"'!="\" & `"`piece'"'!="" { 
		local cmd1 `"`cmd1' `piece'"'
		gettoken piece cmd: cmd, parse(" \") quotes
	}
	while `"`piece'"' == "\" { 
		local ncmd = `ncmd' + 1
		gettoken piece cmd: cmd, parse(" \") quotes
		while `"`piece'"'!="\" & `"`piece'"'!="" { 
			local cmd`ncmd' `"`cmd`ncmd'' `piece'"'
			gettoken piece cmd: cmd, parse(" \") quotes
		}
	}
	if `"`piece'"' != "" { 
		error 198 
	}

	/*
	execute
	*/

	local version = string(_caller())
	local j 1
	while `j' <= `nj' {  /* groups */
		local c 1
		while `c' <= `ncmd' { /* commands */
			local todo `"`cmd`c''"'
			local i 1
			while `i' <= `ni' {
				local todo : subinstr local todo /*
					*/ `"`from`i''"' `"`su`i'`j''"', all 
				local i = `i' + 1
			}
		
			`qq' di _n `"-> `todo'"'
			if "`stop'"=="nostop" { 
				version `version': capture noisily `todo'
				if _rc {
					if _rc==1 { exit 1 }
					di in ye "->  " in blue "r(" _rc "); "
				}
			}
			else {
				version `version': `xeq' `todo'
			}
			`pause'

			local c = `c' + 1
		} /* commands */
		local j = `j' + 1
	} /* groups */

end


program define GetType, rclass /* type */
	local typ `"`1'"'

	local l = length(`"`typ'"')
	if `l' == 0 { error 198 }

	if bsubstr("varlist",1,max(3,`l')) == `"`typ'"' {
		ret local type "varlist"
	}
	else if bsubstr("numlist",1,max(3,`l')) == `"`typ'"' {
		ret local type "numlist"
	}
	else if bsubstr("newlist",1,max(3,`l')) == `"`typ'"' {
		ret local type "newlist"
	}
	else if "any" == `"`typ'"' {
		ret local type "any"
	}
	else {
		di in red `""`typ'" invalid list type"'
		exit 198
	}
end


program define Fixnew, rclass
	parse "`*'", parse(" -")
	local i 1
	while "``i''" != "" {
		local j = `i' + 1
		if "``j''"=="-" {
			local k = `i' + 2
			if "``k''" == "" {
				di in red "``i''-``k'' invalid"
				exit 198
			}
			confirm new var ``i''
			confirm new var ``k''
			Split ``i'' 
			local bi `r(b)'
			local ni `r(n)'
			Split ``k''
			local bj `r(b)'
			local nj `r(n)'
			if "`bi'" != "`bj'" | `ni'>`nj' { 
				di in red "``i''-``k'' invalid"
				exit 198
			}
			while `ni' <= `nj' { 
				confirm new var `bi'`ni'
				local res `res' `bi'`ni'
				local ni = `ni' + 1
			}
			local i = `i' + 3
		}
		else {
			confirm new var ``i''
			local res `res' ``i''
			local i = `i' + 1
		}
	}
	ret local newlist `res'
end

program define Split, rclass /* varname# */
	local v "`1'"

	local c = bsubstr("`v'",-1, .)
	while "`c'">="0" & "`c'"<="9" {
		local num `c'`num'
		local v = bsubstr("`v'",1,length("`v'")-1)
		local c = bsubstr("`v'",-1,.)
	}
	ret local b `v'
	ret local n `num'
end

exit

