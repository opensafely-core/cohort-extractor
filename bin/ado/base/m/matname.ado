*! version 1.0.0  25 Jan 1995
program define matname
	version 4.0
	parse "`*'", parse(",")
* Save stuff before ",".
	local A "`1'"
	macro shift
* Parse options.
	local options "Rows(string) Columns(string) Explicit"
	parse "`*'"
* Parse stuff before ",".
	parse "`A'", parse(" ")
* `A' is matrix name.
	local A "`1'"
	capture di matrix(`A'[1, 1])
	if _rc {
		di in red "matrix `A' not found"
		exit 111
	}
* Put list of names in `names'.
	macro shift
	local names "`*'"
* Expand `names' if explicit not specified.
	if "`explici'" == "" {
		if "`names'" == "" {
			local varlist "ex opt"
			parse "`names'"
			local names "`varlist'"
		}
		else {
* Check for "_cons" in `names'.
* Unabbreviate preceding `names' whenever "_cons" is encountered.
			local i 1
			local name : word 1 of `names'
			while "`name'" ~= "" {
				if "`name'" == "_cons" {
					if "`n1'" ~= "" {
						local varlist "ex req"
						parse "`n1'"
						local n1 /* zero `n1' */
						local n2 "`n2' `varlist' _cons"
					}
					else local n2 "`n2' _cons"
				}
				else local n1 "`n1' `name'" 
				local i = `i' + 1
				local name : word `i' of `names'
			}	
			if "`n1'" ~= "" {
				local varlist "ex req"
				parse "`n1'"
				local names "`n2' `varlist'"
			}
			else local names "`n2'"
		}
	}
* Construct new row and/or column names.
	if "`rows'" == "" & "`columns'" == "" {
		local rows    "."
		local columns "." 
	}
	local count : word count `names'
	if "`rows'" ~= "" {
		global S_3 = rowsof(matrix(`A'))
		place `rows'
		if $S_2 - $S_1 + 1 ~= `count' {
			di in red "number of names and rows() or columns()" /*
			*/ " ranges do not match"
			error 503
		}
		local oldname : rownames(`A')
		local i 1
		while `i' < $S_1 {
			local nam : word `i' of `oldname'
			local newname "`newname' `nam'"
			local i = `i' + 1
		}
		local newname "`newname' `names'"
		local i = $S_2 + 1
		while `i' <= $S_3 {
			local nam : word `i' of `oldname'
			local newname "`newname' `nam'"
			local i = `i' + 1
		}
		matrix rownames `A' = `newname'
	}
	if "`columns'" ~= "" {
		global S_3 = colsof(matrix(`A'))
		place `columns'
		if $S_2 - $S_1 + 1 ~= `count' {
			di in red "number of names and rows() or columns()" /*
			*/ " ranges do not match"
			error 503
		}
		local oldname : colnames(`A')
		local newname
		local i 1
		while `i' < $S_1 {
			local nam : word `i' of `oldname'
			local newname "`newname' `nam'"
			local i = `i' + 1
		}
		local newname "`newname' `names'"
		local i = $S_2 + 1
		while `i' <= $S_3 {
			local nam : word `i' of `oldname'
			local newname "`newname' `nam'"
			local i = `i' + 1
		}
		matrix colnames `A' = `newname'
	}
end

program define place  /* input: 2, 2..4, 2..., or . */
	version 4.0
	parse "`*'", parse(" .")
	if "`1'" == "." & "`2'" == "" {
		global S_1 1
		global S_2 $S_3
		exit
	}
	capture {
		confirm integer number `1' 	
		global S_1 `1'
		if "`2'" == "" { global S_2 $S_1 }
		else if "`2'" == "." & "`3'" == "." & "`5'" == "" {
			if "`4'" == "." { global S_2 $S_3 }
			else {
				confirm integer number `4'
				global S_2 `4'
			}
		}
		else assert 0  /* error if here */
	}
	if _rc {
		di in red "invalid syntax in rows() or columns() options"
		exit 198
	}
	if ~(1 <= $S_1 & $S_1 <= $S_2 & $S_2 <= $S_3) {
		di in red "invalid rows() or columns() ranges"
		error 503
	}
end
