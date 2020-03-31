*! version 1.1.0 PR 30Apr98.
program define frac_dis
	version 6
	* Disentangle varlist:string clusters---e.g. for DF.
	* Returns values in $S_*.
	* If `4' is null, `3' is assumed to contain rhs
	* and lowest and highest value checking is disabled.

	local target "`1'"		/* string to be processed */
	local tname "`2'"		/* name of option in calling program */
	if "`4'"=="" {
		local rhs "`3'"		/* complete set of covariates */
	}
	else {
		local low "`3'"		/* lowest permitted value */
		local high "`4'"	/* highest permitted value */
		local rhs "`5'"		/* complete set of covariates */
	}
	unabbrev `rhs'
	local rhs `s(varlist)'
	local nx: word count `rhs'
	local j 0
	while `j'<`nx' {
		local j=`j'+1
		local n`j': word `j' of `rhs'
	}

	parse "`target'", parse(",")
	local ncl 0 			/* # of comma-delimited clusters */
	while "`1'"!="" {
		if "`1'"=="," { mac shift }
		local ncl=`ncl'+1
		local clust`ncl' "`1'"
		mac shift
	}
	if "`clust`ncl''"=="" { local ncl=`ncl'-1 }
	if `ncl'>`nx' {
		di in red "too many `tname'() values specified"
		exit 198
	}
	/*
		Disentangle each varlist:string cluster
	*/
	local i 1
	while `i'<=`ncl' {
		parse "`clust`i''", parse("=:")
		if "`2'"!=":" & "`2'"!="=" {
			if `i'>1 {
				noi di in red /*
				*/ "invalid `tname'() value `clust`i''" /*
			 	*/ ", must be first item"
				exit 198
			}
			local 2 ":"
			local 3 `1'
			local j 0
			local 1
			while `j'<`nx' {
				local j=`j'+1
				local 1 `1' `n`j''
			}
		}
		local arg3 `3'
		if "`low'"!="" & "`high'"!="" {
			cap confirm num `arg3'
			if _rc {
				di in red "invalid `tname'() value `arg3'"
				exit 198
			}
			if `arg3'<`low' | `arg3'>`high' {
				di in red /*
				*/ "`tname'() value `arg3' out of allowed range"
				exit 198
			}
		}
		unabbrev `1'
		tokenize `s(varlist)'
		while "`1'"!="" {
			frac_in `1' "`rhs'"
			local v`s(k)' `arg3'
			mac shift
		}
		local i = `i'+1
	}
	local j 0
	while `j'<`nx' {
		local j=`j'+1
		if "`v`j''"!="" { global S_`j' `v`j'' }
		else global S_`j'
	}
end
