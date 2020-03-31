*! version 1.1.3  16feb2015
program define meqparse
	version 6
	gettoken cmd 0 : 0 
	syntax [, roles(string) eqopts(string)]

	local eq   1
	local more 1
	while `more' & "`cmd'" != "" {
		GetEqn `eq' `cmd' 
		local eq = `eq' + 1
	}
	local eq = `eq' - 1

	local i 1
	while `i' <= `eq' { 
		local elst `elst' `eqn`i'' 
		local i = `i' + 1
	}

	if `eq' == 0 { 
		exit 
	}

	OptParse eqopt eqlc eqnam "`eqopts'"
	tokenize `"`roles'"'
	while "`1'" != "" {
		local lc = lower("`1'")
		local rslc  "`rslc' `lc'"
		local rstrs "`rstrs' `1'(string)"
		mac shift
	}

	local i 1
	while `i' <= `eq' {
		Eq "`elst'" "`roles'" "`rslc'" "`rstrs'" "`eqopt'" /*
			*/ "`eqlc'" "`eqnam'" "`eqn`i''" "`eqc`i''" "`i'"
		local i = `i'+1
	}

	local i 1
	while `i' <= `eq' {
		c_local e_`i'   `"`eqn`i''"'
		c_local e_y`i'  `"`e_y`i''"'
		c_local e_x`i'  `"`e_x`i''"'
		c_local e_re`i' `"`e_re`i''"'
		c_local e_ro`i' `"`e_ro`i''"'

		tokenize `"`eqnam'"'
		local j 1
		while "``j''" != "" {
			c_local ``j''`i' `"```j''`i''"'
			local j = `j'+1
		}
		local i = `i'+1
	}
	c_local e_n `eq'
	c_local 0 `"`cmd'"'
end


program define GetEqn
	local cmd `"`0'"'

	gettoken eqn cmd : cmd , parse(" ")
	gettoken tok cmd : cmd , parse(" ,([")

	if "`tok'" == "if" | "`tok'" == "in" | "tok" == "[" | "`tok'" == "," {
		c_local eq = `eqn'-1
		c_local cmd `tok'`cmd'
		c_local more 0
		exit
	}

	if "`tok'" != "(" {
		capture eq ?? `tok'
		if _rc {
			c_local eq = `eqn'-1
			c_local cmd `tok'`cmd'
			c_local more 0
			exit
		}
		local eqname `r(eqname)'
		local eq     `r(eq)'
	}
	else {
		local eq
		local flag 1

		gettoken tok cmd : cmd , parse("()")

		if index("`tok'",":") {
			tokenize "`tok'", parse(":")
			local eqname "`1'"
			mac shift 2
			local cmd `"`*'`cmd'"'

			gettoken tok cmd : cmd , parse("()")
		}
		while `flag' & `"`tok'"' != "" {
			if `"`tok'"' == "(" { local flag = `flag' + 1 }
			if `"`tok'"' == ")" { local flag = `flag' - 1 }
			if `flag' {
				local eq `"`eq'`tok'"'
				gettoken tok cmd : cmd , parse("()")
			}
		}
		if `flag' {
			di in red "unbalanced parentheses"
			exit 198
		}
	}
	if "`eqname'" != "" {
		c_local eqn`eqn' `"`eqname'"'
	}
	/* else    c_local eqn`eqn' `"eq`eqn'"' */
	c_local eqc`eqn' `"`eq'"'
	c_local cmd `"`cmd'"'
end


program define OptParse
	args optnam lc namnam
	mac shift 3
	tokenize "`*'"
	while "`1'" != "" {
		if index("`1'","(") & ~index("`1'",")") {
			local arg1 "`1'`2'"
			local arg2 "`3'"
			local ns 3
		}
		else {
			local arg1 "`1'"
			local arg2 "`2'"
			local ns 2
		}

		if "`arg2'" == "" {
			di in red "eqopts missing name"
			exit 198
		}
		local name = bsubstr("`arg2'",1,4)
		local opts `opts' `arg1'
		local nams `nams' `name'
		local arg  = lower("`arg1'")
		local beg 1
		if index("`arg'","(") { 
			local arg  = bsubstr("`arg'",1,index("`arg'","(")-1)
		}
		else {
			if bsubstr("`arg'",1,2) == "no" {
				local beg 3
			}
		}
		local arg = bsubstr("`arg'",`beg',`beg'+6)
		local lcopt `lcopt' `arg'
		mac shift `ns'
	}
	c_local `optnam' "`opts'"
	c_local `lc'     "`lcopt'"
	c_local `namnam' "`nams'"
end


program define Eq
	args eqnlist roles rslc rstrs eqopts eqlc eqnam eqn eqc index

	tokenize "`eqc'", parse("=")
	args p1 p2 p3

	if "`p1'" == "=" {
		local cmd "`p2'"
		if "`eqn'" == "" {
			local eqn "eq`index'"
		}
	}
	else if "`p2'" == "=" { 
		unabbrev `p1'
		local dv  "`s(varlist)'"
		local cmd "`p3'"  
		if "`eqn'" == "" {
			local eqn "`dv'"
		}
	}
	else { 
		local cmd "`eqc'" 
		if "`eqn'" == "" {
			local eqn "eq`index'"
		}
	}

	local 0 `"`cmd'"'
	capture syntax [varlist(default=empty)] [, `roles' `eqopts' ]
	if _rc == 0 {
		if "`varlist'" != "" {
			unabbrev `varlist'
			local iv "`s(varlist)'"
		}
	}
	else {
		local 0 `"`cmd'"'
		capture syntax [varlist(default=empty)] [, `rstrs' `eqopts'] 
		if _rc == 0 {
			if "`varlist'" != "" {
				unabbrev `varlist'
				local iv "`s(varlist)'"
			}
		}
		else {
			local varlist "opt"
			local options "`rstrs' `eqopts'"
			noi parse "`cmd'"
		}
	}

	c_local e_y`index' "`dv'"
	c_local e_x`index' "`iv'"
	local n : word count `eqlc'
	local i 1
	while `i' <= `n' {
		local val : word `i' of `eqlc'
		local nam : word `i' of `eqnam'
		c_local `nam'`index' "``val''"
		local i = `i'+1
	}
	
	local nroles 0
	local n : word count `roles'	
	local i 1
	while `i' <= `n' {
		local rol : word `i' of `rslc'
		if "``rol''" != "" {
			local nroles = `nroles'+1
			if "``rol''" != "`rol'" {
				local refrol "``rol''"
				local refind `i'
				ChkRef "`index'" "`refrol'" "`eqnlist'"
			}
			local role `rol'
		}
		local i = `i'+1
	}

	if `nroles' > 1 {
		noi di in red "equation `index' takes more than one role"
		exit 198
	}

	c_local e_ro`index' "`role'"
	c_local e_re`index' "`refind'"
	c_local eqn`index'  "`eqn'"
end


program define ChkRef
	args index role list

	tokenize "`list'"
	local i 1
	while "``i''" != "" {
		if "`role'" == "``i''" { exit } 
		local i = `i'+1
	}
	noi di in red "equation `index' refers to unknown equation: `role'"
	exit 198
end
