*! version 1.0.2  24jan2019

program define _stteffects_ipwra_init, rclass
	version 14.0
	syntax varname, touse(varname) tmodel(string) stat(string)        ///
		levels(string) control(integer) tlevel(integer)           ///
		pstol(passthru) [ survdist(string) treatvars(string)      ///
		treat2vars(string) survvars(passthru) survshape(passthru) ///
		censordist(string) censorvars(passthru) fuser             /// 
		censorshape(passthru) osample(passthru) verbose * ]

	/* fuser macro indicates user specified from()			*/
	local tvar `varlist'

	local hprob = ("`tmodel'"=="hetprobit")
	local censor = ("`censordist'"!="")

	if "`verbose'" != "" {
		local noi noi
	}
	else {
		local qui qui
		local nolog nolog
	}
	_stteffects_split_vlist, vlist(`treatvars')
	local treatvars `"`s(vlist)'"'
	local constant `s(constant)'

	/* assumption: stset with failure event 			*/
	local to : char _dta[st_t]
	local do : char _dta[st_d]
	local wtype : char _dta[st_wt]
	if "`wtype'" != "" {
		local wvar : char _dta[st_wv]
		local wts [`wtype'=`wvar']
	}
	local iff if `touse'

	local klev : list sizeof levels
	local kaux = 0
	local kc : list posof "`control'" in levels
	local kt : list posof "`tlevel'" in levels

	if "`verbose'" != "" {
		di as txt _n "Fitting the treatment model"
	}
	tempvar tr
	qui gen byte `tr' = `tlevel'.`tvar' if `touse'
	if `klev' == 2 {
		if "`treatvars'" != "" {
			_rmcoll `treatvars' `wts' if `touse', `constant'
			local treatvars `r(varlist)'
		}
		if `hprob' {
			if "`treat2vars'" != "" {
				CheckHetVars `treat2vars', touse(`touse') ///
					wts(`wts')
				local treat2vars `r(varlist)'
			}
			cap `noi' hetprobit `tr' `treatvars' `wts'       ///
				if `touse', `constant' het(`treat2vars') ///
				`options'
		}
		else {
			cap `noi' `tmodel' `tr' `treatvars' `wts' ///
				if `touse', `constant' `options'
		}
	}
	else {
		cap `noi' mlogit `tvar' `treatvars' `wts' if `touse',  ///
			base(`control') `constant' `options'
	}
	local rc = c(rc)
	if `rc' {
		di as err "{p}treatment-model estimation has failed; " ///
		 "computations cannot proceed{p_end}"
		exit `rc'
	}
	tempname tb b1
	tempvar ipw ptr
	mat `tb' = e(b)
	if `klev' == 2 {
		local tstripe : colfullnames `tb'
		local tstripe : subinstr local tstripe "`tr':" ///
			"TME`tlevel':", all

		if `hprob' {
			if c(userversion) >= 16 {
				local heteq lnsigma
			}
			else {
				local heteq lnsigma2
			}
			local tstripe : subinstr local tstripe "`heteq':" ///
				"TME`tlevel'_lnsigma:", all
		}
		qui predict double `ptr' if `touse', pr
		qui gen double `ipw' = cond(`tr',`ptr',1-`ptr') if `touse'
	}
	else {
		tempname b0
		tempvar pr
		qui gen double `ipw' = .
		local lab : value label `tvar'
		local eqnames `"`e(eqnames)'"'

		forvalues i=1/`klev' {
			local lev : word `i' of `levels'
			local eq : word `i' of `eqnames'
			qui predict double `pr' `if', outcome(`lev') pr
			qui replace `ipw' = `pr' if `touse' & `lev'.`tvar'
			if "`lev'" == "`control'" {
				qui drop `pr'
				continue
			}
			else if "`lev'" == "`tlevel'" {
				qui gen double `ptr' = `pr'
			}
			qui drop `pr'
			mat `b0' = `tb'[1,"`eq':"]
			local str : colfullnames `b0'
			local str : subinstr local str "`eq':" "TME`lev':", all
			
			mat `b1' = (nullmat(`b1'),`b0')
			local tstripe `"`tstripe' `str'"'
		}
		mat `tb' = `b1'
	}
	mat colnames `tb' = `tstripe'
	local converged = e(converged)
	if !`converged' & "`fuser'"=="" {
		di as txt "{p 0 6 2}note: propensity-score-model " ///
		 "estimation, convergence not achieved{p_end}"
	}

	local what propensity score
	if `censor' {
		tempname cb
		tempvar sv
		_stteffects_censor_init `sv', touse(`touse')                ///
			censordist(`censordist') `censorvars' `censorshape' ///
			`fuser' `verbose' `options'
		local converged = (`converged'&r(converged))
		mat `cb' = r(b)
		qui replace `ipw' = `ipw'*`sv' if `touse'
		local dsv /`sv'
		local what probability weight

		local fopt failure(`do')
	}
	if `converged' & "`fuser'"=="" {
		_stteffects_check_overlap `ipw', what(`what') touse(`touse') ///
			`fopt' `pstol' `osample'
	}
	if `censor' {
		if "`stat'" == "atet" {
			qui replace `ipw' = cond(`do',cond(`tr',1/`sv', ///
					`ptr'/`ipw'),0) if `touse'
		}
		else {
			qui replace `ipw' = cond(`do',1/`ipw',0) if `touse'
		}
	}
	else {
		if "`stat'" == "atet" {
			qui replace `ipw' = cond(`tr',1,`ptr'/`ipw') if `touse'
		}
		else {
			qui replace `ipw' = 1/`ipw' if `touse'
		}
	}
	if "`wvar'" != "" {
		qui replace `ipw' = `ipw'*`wvar' if `touse'
	}		

	tempname b mb
	if "`survdist'" != "" {
		if "`stat'" == "atet" {
			local stat0 cot
		}
		else {
			local stat0 `stat'
		}
		/* IPWRA						*/
		_stteffects_surv_init `tvar', touse(`touse')                ///
			survdist(`survdist') stat(`stat0') levels(`levels') ///
			control(`control') tlevel(`tlevel') `survvars'      ///
			`survshape' `survscale' wvar(`ipw') `fuser'         ///
			`verbose' `options'
		mat `b' = r(b)
		mat `mb' = r(mb)
	}
	else {
		/* IPW							*/
		tempname rb est
		cap `noi' regress `to' ibn.`tvar' if `touse' [pw=`ipw'], ///
			noconstant
		mat `mb' = e(b)

		local k = colsof(`mb')
		if "`stat'" != "pomeans" {
			tempname m0
			local kc : list posof "`control'" in levels
			scalar `m0' = `mb'[1,`kc']
			local k = 0
			local ustat = strupper("`stat'")
			forvalues i=1/`klev' {
				if `i' == `kc' {
					continue
				}
				local lev : word `i' of `levels'
				mat `mb'[1,`++k'] = `mb'[1,`i']-scalar(`m0')
				local stripe `"`stripe' `ustat':"'
				local stripe `"`stripe'r`lev'vs`control'"'
				local stripe `"`stripe'.`tvar'"'
			}
			mat `mb'[1,`klev'] = scalar(`m0')
			local stripe `"`stripe'  POmean:`control'.`tvar'"'
			mat colnames `mb' = `stripe'
		}
		else {
			mat coleq `mb' = POmeans
		}
	}
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
	cap noi _stteffects_concat_matrices, mat1(`b') mat2(`tb')
	local rc = c(rc)
	if `rc' {
		/* factor variable specification conflict		*/
		if ("`cb'"!="") local more " and/or the censoring"

		di as txt "{phang}There is a conflict between the " ///
		 "treatment and the survival `more' models.{p_end}"
		exit `rc'
	}
	mat `b' = r(cmat)
	/* update varlist for matrix stripe canonical form		*/
	ExtractVarlist, b(`b') eq(TME`tlevel')
	local treatvars `"`s(varlist)'"'
	if `hprob' {
		ExtractVarlist, b(`b') eq(TME`tlevel'_lnsigma)
		local treat2vars `"`s(varlist)'"'
	}

	if "`survdist'" != "" {
		ExtractVarlist, b(`b') eq(OME`tlevel')
		local survvars `"`s(varlist)'"'

		if "`survdist'" != "exponential" {
			ExtractVarlist, b(`b') eq(OME`tlevel'_lnshape)
			local survshape `"`s(varlist)'"'
		}
		else local survshape
	}
	if `censor' {
		local anc
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
		/* factor variable specification conflict		*/
		/* not sure we can tickle this one			*/
		di as txt "{phang}There is a conflict between the " ///
		 "treatment effects and one or more of the other models.{p_end}"
		exit `rc'
	}
	cap noi mat `b' = r(cmat)
	if "`verbose'" != "" {
		mat li `b', title(initial estimates)
	}
	return mat b = `b'
	return local treatvars `"`treatvars'"'
	return local treat2vars `"`treat2vars'"'
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

program define CheckHetVars, rclass
	syntax varlist(numeric fv default=none), touse(varname) [ wts(string) ]

	fvexpand `varlist' if `touse'

	local vlist `r(varlist)'
	local kt2 : list sizeof vlist
	if !`kt2' {
		exit
	}
	_rmcoll `varlist' `wts' if `touse'

	if r(k_omitted) >= `kt2' {
		di as err "{p}all variables specified in option " ///
		 "{bf:hetprobit()} have been omitted; this is not " ///
		 "allowed{p_end}"
		exit 498
	} 
	return add
end

exit
