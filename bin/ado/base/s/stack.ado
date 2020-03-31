*! version 3.2.3  15oct2019
program define stack
	version 6.0, missing
	syntax varlist(min=2) [if] [in] [, /*
			*/ Into(str) Group(integer 0) CLEAR WIde ]

	if (`"`into'"'=="") { 
		if `group'==0 { 
			error 198
		}
		Makeinto `group' `varlist'
	}
	else {
		if `group'!=0 { 
			version 7: di in red "options {bf:group()} and {bf:into()} may not be specified together"
			exit 198
		}
		Fixinto `into'
	}
	local into $S_1
	global S_1

					/* # of args in varlist */
	local vcnt : word count `varlist'
					/* # of args in into()	*/
	local icnt : word count `into'

	local grps = `vcnt'/`icnt'	/* # of groups		*/
	if (`grps' != int(`grps') | `grps'<=1) {
		di in red "incorrect number of variables specified"
		exit 198
	}

			/* present warning			*/
	if "`clear'"=="" {
		di in blu "Warning:  data in memory will be lost." /*
			*/ _n _col(10) /* 
			*/ "Press any key to continue, Ctrl-Break to abort."
		set more 0 
		more 
	}

	tempfile stacktp
			/* save data needed to stack		*/
	if (`"`if'"'!="" | `"`in'"'!="") {
		quietly keep `if' `in'
	}
	keep `varlist' 
	quietly save "`stacktp'", replace

			/* preserve varlist for wide option	*/
	local vlist "`varlist'"

			/* make temporary names once		*/
	local i 1
	while `i'<=`icnt' {
		tempname ti
		local tnames `tnames' `ti'
		local i = `i' + 1
	}
	local ti

			/* stack the data			*/
	local grp 1
	capture {
		while (`grp' <= `grps') { 
			tokenize `varlist'
			local i 1
			local touse 
			while (`i' <= `icnt') { 
				local touse "`touse' `1'"
				mac shift
				local i = `i' + 1 
			}
			local varlist "`*'"	/* reset varlist	*/
			use "`stacktp'", clear
			keep `touse' 

			gen int _stack = `grp'
			local i 1
			while `i' <= `icnt' { 
				local name1 : word `i' of `touse'
				local ti : word `i' of `tnames'
				local typ : type `name1'
				gen `typ' `ti' = `name1'
				local i = `i' + 1
			}
			drop `touse'
			local i 1
			while `i' <= `icnt' { 
				local new1 : word `i' of `into'
				local ti : word `i' of `tnames'
				rename `ti' `new1'
				local i = `i' + 1
			}
			tempfile tempfi
			local tf`grp' "`tempfi'"
			save "`tempfi'"
			local grp = `grp' + 1 
		}

		use `"`tf1'"', clear
		local grp 2
		while (`grp' <= `grps') { 
			append using `"`tf`grp''"'
			local grp = `grp' + 1 
		}				/* done		*/
		if ("`wide'"!="") { 		/* wide option	*/
			local grp 1
			while (`grp' <= `grps') { 
				tokenize `vlist'
				local i 1
				local touse
				while (`i' <= `icnt') { 
					local touse "`touse' `1'"
					mac shift 
					local i = `i' + 1 
				}
				local vlist "`*'"
				local i "1"
				while (`i' <= `icnt') { 
					local name1 : word `i' of `touse'
					capture confirm new variable `name1'
					if (_rc==0) {
						local name2 : word `i' of `into'
						local type : type `name2'
						gen `type' `name1' = /*
							*/ `name2' /*
							*/ if _stack==`grp'
					}
					local i = `i' + 1 
				}
				local grp = `grp' + 1
			}
		}
		global S_FN
		global S_FNDATE
		exit
	}
				/* error-abort code	*/
	if (_rc) { 
		local rc = _rc 
		drop _all
		di in red "(memory cleared)"
		error `rc'
	}
	global S_FN
	global S_FNDATE
end


program define Fixinto /* newvarlist */
	tokenize "`*'", parse("- ")
	while "`1'" != "" { 
		if "`2'"=="-" { 
			Split "`1'" "`1' `2' `3'"
			local stub "$S_1"
			local n1 $S_2
			Split "`3'" "`1' `2' `3'"
			local n2 "$S_2"
			if "`stub'" != "$S_1" | `n1'>`n2' {
				Fixerr "`1' `2' `3'"
				/*NOTREACHED*/
			}
			local i `n1'
			while `i' <= `n2' { 
				local res "`res' `stub'`i'"
				local i = `i' + 1
			}
			mac shift 3
		}
		else {
			local res "`res' `1'"
			mac shift 
		}
	}
	global S_2
	global S_1 "`res'"
end


program define Split /* "varname#" "string for error message" */
	if "`1'"=="" { 
		Fixerr "`2'"
		/*NOTREACHED*/
	}
	local l = length("`1'")
	while index("0123456789",bsubstr("`1'",`l',1)) {
		local l = `l' - 1 
		if `l' == 0 { 
			Fixerr "`2'"
			/*NOTREACHED*/
		}
	}
	global S_1 = bsubstr("`1'",1,`l')
	global S_2 = bsubstr("`1'",`l'+1,.)
	if "$S_1"=="" | "$S_2"=="" { 
		Fixerr "`2'"
		/*NOTREACHED*/
	}
end

program define Fixerr
	di in red _quote "`1'" _quote " invalid"
	exit 198
end

program define Makeinto /* # varnames */
	local g "`1'"
	if `g' <= 0 { 
		version 7: di in red "option {bf:group(`g')} invalid"
		exit 198
	}
	mac shift 
	local n : word count `*'
	local v = `n' / `g'
	if `v' != int(`v') | `v'==0 { 
		di in red "`n' variables cannot be stacked into `g' groups;"
		di in red "there would be " `v' " variables/group."
		exit 198
	}
	local i 1
	global S_1
	while `i' <= `v' { 
		global S_1 $S_1 ``i''
		local i = `i' + 1
	}
end
exit
