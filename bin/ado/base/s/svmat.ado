*! version 2.1.1 17dec2003 
program define svmat
	version 4.0
	parse "`*'", parse(" ,")
	if "`2'" == "" | "`2'" == "," {
		local type "float"
		local A    "`1'"
		macro shift
	}
	else {
		local type "`1'"
		local A    "`2'"
		macro shift 2
	}
	capture local nc = colsof(matrix(`A'))
	if _rc {
		di in red "matrix `A' not found"
		exit 111
	}
	local options "Names(string)"
	parse "`*'"
	local j 1
	if "`names'"=="col"         { 
		local notc  "*"
	}
	else if "`names'"=="eqcol"  { 
		local noteq "*" 
	}
	else if "`names'"=="matcol" { 
		local notm  "*" 
	}
	else if "`names'"==""       {
		local nots  "*"
		local names "`A'"
	}
	else                        { 
		local nots  "*" 
	}
	`nots' local cnames : colnames(`A')
	`notc' `notm' `nots' local enames : coleq(`A')
	while `j' <= `nc' {
		`nots' local varnam : word `j' of `cnames'
		`notc' `notm' `nots' local pre : word `j' of `enames'
		`notc' `noteq' `nots' local pre "`A'"
		`notc' `nots' local varnam = substr("`pre'`varnam'",1,32)
		`nots' local vars "`vars' `varnam'"
		`notc' `noteq' `notm' local vars "`vars' `names'`j'"
		local j = `j' + 1
	}
	local varlist "new"
	local ck_cons = index("`vars'", " _cons")
	if `ck_cons' != 0 {
		di in red "_cons invalid varname"
		exit 198
	}
	capture parse "`type'(`vars')"
	if _rc == 110 {
		di in red /*
*/ "new variables cannot be uniquely named or already defined"
		exit _rc
	}
	if _rc == 900 | _rc == 902 { 
		noroom `type' `nc' _rc 
	}
	if _rc { 
		error _rc 
	}
	drop `varlist'
	
	parse "`varlist'", parse(" ")
	local nr = rowsof(matrix(`A'))
	local old_N = _N
	if `nr' > _N { 
		di in blu "number of observations will be reset to `nr'"
		di in blu "Press any key to continue, or Break to abort"
		more
		set obs `nr'
	}
	capture {
		local j 1
		while `j' <= `nc' {
			tempvar y`j'
			gen `type' `y`j'' = matrix(`A'[_n, `j']) in 1/`nr'
			local j = `j' + 1
		}
		local j 1
		while `j' <= `nc' {
			rename `y`j'' ``j''
			local j = `j' + 1
		}
	}
	if _rc {
		if _N > `old_N' { 
			quietly drop if _n > `old_N' 
		}
		error _rc
	}
end

program define noroom /* `type' `nc' _rc */
	version 4.0
	local type "`1'"
	local nc    `2'
	local rc    `3'
	if      "`type'"=="float"  { 
		local w 4
	}
	else if "`type'"=="double" { 
		local w 8 
	}
	else if "`type'"=="long"   { 
		local w 4 
	}
	else if "`type'"=="int"    { 
		local w 2 
	}
	else if "`type'"=="byte"   { 
		local w 1 
	}
	local w = `w'*`nc'
	di in red  "no room to add more variables" 
	di in blue /*
*/ "room for `nc' additional variables and additional width of `w' required"
	exit `rc'
end
