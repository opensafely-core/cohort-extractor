*! version 4.1.2  18feb2015
program define dfbeta_10
	local vv : display "version " string(_caller()) ", missing:"
	version 6.0
	_isfit cons newanovaok

	if "`*'"=="" { 
		GetRhs varlist
	}
	else {
		syntax varlist
		GetRhs rhs
		tokenize `rhs'
		local i 1
		while "``i''"!="" { 
			local v`i' "``i''"
			local i=`i'+1
		}
		tokenize `varlist'
		while "`1'"!="" { 
			local found
			local j 1
			while "`v`j''"!="" & "`found'"=="" {
				if "`1'"=="`v`j''" { local found true }
				local j=`j'+1
			}
			if "`found'"=="" { 
				di in red "`1' not in model"
				exit 111
			}
			mac shift
		}
	}

	local len = cond(_caller()<7, 8, 32) - 2

	tokenize `varlist'
	local i 0
	while "`1'"!="" {
		if _caller()<7 {
			local new ="DF"+bsubstr("`1'",1,`len')
		}
		else {
			local new ="DF"+usubstr("`1'",1,`len')		
		}
		capture confirm new var `new'
		while _rc { 
			local i=`i'+1
			local new "DF`i'"
			capture confirm new var `new'
		}
		`vv' ///
		predict float `new', dfbeta(`1')
		di in gr %32s "`new'" ":  DFbeta(`1')"
		mac shift 
	}
end

program define GetRhs /* name */ 
	version 11
	args where
	local rhs : colnames e(b)
	local uscons _cons
	local 0 : list rhs - uscons
	foreach var of local 0 {
		if !strpos("`var'", ".") {
			local vlist `vlist' `var'
		}
	}
	c_local `where' "`vlist'"
end

