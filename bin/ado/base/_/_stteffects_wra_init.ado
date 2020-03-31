*! version 1.0.0  04feb2015

program define _stteffects_wra_init, rclass
	version 14.0
	syntax varname, touse(varname) survdist(string) stat(string) ///
		[ survvars(passthru) survshape(passthru)             ///
		censordist(string) censorvars(passthru)              ///
		censorshape(passthru) control(string) tlevel(string) ///
		levels(string) pstol(passthru) osample(passthru)     ///
		fuser verbose * ]

	/* fuser macro indicates user specified from()			*/
	local tvar `varlist'

	if "`verbose'" != "" {
		local noi noi
	}
	else {
		local qui qui
		local nolog nolog
	}

	if `"`censordist'"' != "" {
		tempname cb
		tempvar wra

		/* assumption stset with failure event 			*/
		local d : char _dta[st_d]

		_stteffects_censor_init `wra', touse(`touse')               ///
			censordist(`censordist') `censorvars' `censorshape' ///
			`fuser' `verbose' `options'
		 mat `cb' = r(b)
		if r(converged) & "`fuser'"=="" {
			_stteffects_check_overlap `wra',                   ///
				what(censoring probability) touse(`touse') ///
				`pstol' `osample' failure(`d')
		}
		qui replace `wra' = cond(`d',1/`wra',0) if `touse'
		local wtype : char _dta[st_wt]
		if "`wtype'" != "" {
			local wvar : char _dta[st_wv]
			qui replace `wra' = `wvar'*`wra' if `touse'
		}
		local wopt wvar(`wra')
	}
	_stteffects_surv_init `tvar', touse(`touse') survdist(`survdist') ///
		stat(`stat') levels(`levels') control(`control')          ///
		tlevel(`tlevel') `survvars' `survshape' `wopt' `fuser'    ///
		`verbose' `options'

	tempname b mb
	mat `b' = r(b)
	mat `mb' = r(mb)

	if "`cb'" != "" {
		/* has censoring model					*/
		cap noi _stteffects_concat_matrices, mat1(`b') mat2(`cb')
		local rc = c(rc)
		if `rc' {
			/* factor variable specification conflict	*/
			di as txt "{phang}There is a conflict between the " ///
			 "survival and censoring models.{p_end}"
			exit `rc'
		}
		mat `b' = r(cmat)
	}
	/* update varlist for matrix stripe canonical form		*/
	ExtractVarlist, b(`b') eq(OME`tlevel')
	local survvars `"`s(varlist)'"'

	if "`survdist'" != "exponential" {
		ExtractVarlist, b(`b') eq(OME`tlevel'_lnshape)
		local survshape `"`s(varlist)'"'
	}
	else local survshape

	if "`censordist'" != "" {
		ExtractVarlist, b(`b') eq(CME)
		local censorvars `"`s(varlist)'"'

		if "`censordist'" != "exponential" {
			ExtractVarlist, b(`b') eq(CME_lnshape)
			local censorshape `"`s(varlist)'"'
		}
		else local censorshape
	}
	cap noi _stteffects_concat_matrices, mat1(`mb') mat2(`b')
	local rc = c(rc)
	if `rc' {
		if ("`censordist'"!="") local more " and/or censoring"

		/* factor variable specification conflict		*/
		/* not sure we can tickle this one			*/
		di as txt "{phang}There is a conflict between the " ///
		 "treatment effects and survival`more' models.{p_end}"
		exit `rc'
	}
	mat `b' = r(cmat)
	if "`verbose'" != "" {
		mat li `b', title(initial estimates)
	}
	return mat b = `b'
	return local survvars `"`survvars'"'
	return local survshape `"`survshape'"'
	return local censorvars `"`censorvars'"'
	return local censorshape `"`censorshape'"'

end

program define ExtractVarlist, sclass
	syntax, b(name) eq(string)

	tempname b1

	mat `b1' = `b'[1,"`eq':"]

	local vlist : colnames `b1'
	local cons _cons
	local vlist : list vlist - cons

	sreturn local varlist `"`vlist'"'
end

program define CheckOverlap
	syntax varname, what(string) touse(varname)

	local pw `varlist'

	qui count if `pw'<1e-5 & `touse'
	local ml = r(N)
	if `ml' > 0 {
		di as err "{p}overlap violation; there are `ml' " ///
		 "observations with a `what' weight less than 1e-5{p_end}"
		exit 498
	}
end

exit
