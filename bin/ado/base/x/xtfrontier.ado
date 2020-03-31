*! version 1.9.0  21jun2018
program define xtfrontier, eclass byable(onecall) prop(xt xtbs)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun xtfrontier, panel mark(I T) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtfrontier `0'"'
		exit
	}
	local vv : display "version " string(_caller()) ", missing:"
	version 8.1
				
        if replay() {
                if _by() { 
			error 190 
		}
                if "`e(cmd)'" != "xtfrontier" {
			error 301
		}
                Replay `0'
                exit
        }

	qui syntax varlist(fv ts) [fweight iweight] [if] [in] [,	///
		vce(passthru)						///
		Robust							///
		CLuster(passthru)					///
		ti tvd Level(cilevel) * ]

	if `"`vce'`robust'`cluster'"' != "" {
		_vce_parse, opt(OIM) old				///
			: [`weight'`exp'], `vce' `robust' `cluster'
	}

	local wc : word count `ti' `tvd' 
	if `wc' > 1 {
		di as err "ti and tvd cannot both be specified"
		exit 198
	}
	if `wc' == 0 {
		di as err "either ti or tvd must be specified"
		exit 198
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	if _by() {
		`vv' by `_byvars' `_byrc0': xtsfEST `0'
	}       
	else	`vv' xtsfEST `0'
	version 10: ereturn local cmdline `"xtfrontier `0'"'
end


program define xtsfEST, eclass byable(recall) sortpreserve
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local negh negh
	}
	version 8.1
        syntax varlist(fv ts) [fweight iweight] [if] [in] /*
                */ [, noCONStant COST /*
                */ I(varname num) T(varname num) /*
                */ FROM(string) Level(passthru) TI TVD /*
		*/ noDIFficult * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' & _caller() < 11 {
		local vv "version 11:"
	}
	local nocns "`constant'"

	local vn: di string(_caller())
	if `vn'<15	local gammaparm ilgtgamma
	else		local gammaparm lgtgamma

	if "`difficult'" == "" {
		local difficult difficult
	}

        marksample touse
                                                /* Parse variable list */
        gettoken lhs varlist : varlist
	_fv_check_depvar `lhs'
        if "`varlist'" == "" & "`constant'" != "" {
		error 102
        }
						/* put ts ops in canonical 	
						 * form
						 */
	tsunab lhs : `lhs'
					/* check `lhs' not constant */
	qui _rmcoll `lhs'
	if "`r(varlist)'" == "" {
		di as err "dependent variable cannot be constant"
		exit 198
	}
                                /* set panelvar and timevar */
	if "`ti'" != "" {
		_xt, i(`i') t(`t')
	}
	else {
		_xt, i(`i') t(`t') trequired
		tempname tsdelta
		scalar `tsdelta' = r(tdelta)
	}
	local ivar "`r(ivar)'"
	local tvar "`r(tvar)'"

	tempvar wvar
	if "`weight'"~="" {
		qui gen double `wvar' `exp' if `touse'

		sort `touse' `ivar'	/* sort to use _crcchkw */
		_crcchkw `ivar' `wvar' `touse'

		sort `ivar' `tvar'	/* restore order */
                local wtopt "[`weight'=`wvar']"
        }
	else {
		qui gen byte `wvar' = 1
	}

        markout `touse' `ivar' `tvar' `wvar' /* iis does not allow string */

	qui count if `touse' == 1
	if r(N) == 0 {
		error 2000
	}

        global S_XTby "`ivar'"
        global S_XTt "`tvar'"

	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local coll `s(collinear)'

					/* remove collinearity */
	if `fvops' {
		local rmdcoll "version 11: _rmdcoll"
		local vv "version 11:"
	}
	else	local rmdcoll _rmdcoll
	cap noi `rmdcoll' `lhs' `varlist' if `touse' `wtopt',	///
		`nocns' `coll'
	if _rc {
		di as err "some independent variables " /*
			*/ "collinear with the dependent variable"
		exit _rc
	}
	local varlist `r(varlist)'
	local names `varlist'


					/* time-series operator */
	local eq1 : subinstr local lhs "." "_", all
	if `fvops' {
		fvexpand `varlist' if `touse'
		local names `"`r(varlist)'"'
		fvrevar `varlist', tsonly
		local varlist `"`r(varlist)'"'
		// need to take omitted temp vars out of list
		local i 1
		foreach var of local names {
			_ms_parse_parts `var'
			if `r(omit)' & "`r(type)'"=="variable" {
				local xname `var'
			}
			else {
				local xname : word `i' of `varlist'
			}
			local xnames `xnames' `xname'
			local ++i
		}
		local varlist `xnames'
	}
	else {
		tsrevar `varlist'
		local varlist `"`r(varlist)'"'
	}
	local lhsname `lhs'
	tsrevar `lhs'
	local lhs `r(varlist)'
	markout `touse' `varlist' `lhs'

        if "`cost'"~="" { 
                global S_COST=-1 
                local function "cost"
                if "`constant'"~="" {
                        local costopt "cost"
                }
                else local costopt ", cost" 
        }
        else {
                global S_COST=1
                local function "production"
        } 

	`vv' ///
        qui _regress `lhs' `varlist' `wtopt' if `touse', `nocns'

                                        /* starting values */
        if "`from'"=="" {       
	               	/* Searching for starting values using MOM " */
                if "`ti'" == "" {
                        tempname T
                        qui summ `tvar' if `touse', meanonly
			local Tmax = r(max)
                        local nobs = r(N)
                                                /* time dummies */
                        qui tab `tvar' if `touse', gen(`T')
                        local Tnum = r(r)
 
                                        /* there is no constant term in OLS */
			`vv' ///
                        qui _regress `lhs' `names' `T'1-`T'`Tnum' ///
				`wtopt', nocons
                        tempvar olsres olsres2 olsres3 m3 interv etai y
                        tempname b0 m2 m3T ou2 ov2 eta cons0
                        matrix `b0'=e(b) 
                        qui predict double `olsres' if `touse', res

                        qui gen double `olsres2'=`olsres'^2 if `touse' 
                        qui sum `olsres2' `wtopt' if `touse', meanonly
                        scalar `m2' = r(mean)

                        qui gen double `olsres3'=`olsres'^3 if `touse'
                        qui gen double `m3'=.
                        forvalues i=1/`Tnum' {
                                qui sum `olsres3' `wtopt' if `T'`i', meanonly
                                qui replace `m3' = /*
                        		*/ cond($S_COST*r(sum)<0, /*
					*/ r(mean), -.0001*$S_COST) /*
                       			*/ if `T'`i'
                                if `i'==`Tnum' { 
                                        scalar `m3T' = /*
                       				*/ cond($S_COST*r(sum)<0, /*
						*/ r(mean), -.0001*$S_COST)
                                }
                        }
                        scalar `ou2'=($S_COST*`m3T'/sqrt(2/_pi) /*
				*/ /(1-4/_pi))^(2/3)

                        qui gen double `etai' = ($S_COST*`m3'/sqrt(2/_pi) /*
                                */ /(1-4/_pi))^(1/3)/sqrt(`ou2') if `touse'
                        qui gen double `y' = ln(`etai') if `touse' 
                        qui gen `interv' = -(`tvar'-`Tmax')/`tsdelta' if `touse'
			`vv' ///
                        qui _regress `y' `interv' `wtopt', nocons
                        scalar `eta' = _b[`interv']
                        local etaopt ", `eta'"
                        qui replace `etai' = `etai'^2
                        qui sum `etai' `wtopt' if `touse', meanonly
                        scalar `ov2' = `m2'-`ou2'*(1-2/_pi)*r(mean)
                        scalar `ov2' = cond( `ov2'>0, `ov2', .0001)

						/* adjust constant term */
			local num : word count `varlist'
                	if "`constant'" == "" {
                        	scalar `cons0'=0
                        	forvalues i=1/`Tnum' {
                                	local j = `i'+`num'
					tempvar uitemp
                                	qui gen double `uitemp' = /*
						*/ sqrt(`ou2') /*
                                		*/ *exp(`eta'*`interv')/*
						*/ if `T'`i'
					summ `uitemp' if `T'`i', meanonly
					scalar `cons0' = `b0'[1,`j'] /*
                                		*/ + $S_COST*sqrt(2/_pi) /*
						*/ *r(mean) /*
						*/ +`cons0'
                        	}
                        	scalar `cons0'=`cons0'/`Tnum'
				if `num' > 0 {
					mat `b0' = (`b0'[1,1..`num'],`cons0')
				}
				else {
					mat `b0' = (`cons0')
				}
                	}
			else {
				mat `b0' = `b0'[1,1..`num']
			}
                }

					/* time-invariant TE effects */
                else {                  
                        tempname b0 ou2 ov2 cons0
					/* weights won't work with -xtreg, re-
					   -noconstant- is not allowed */
                        qui `vv' xtreg `lhs' `varlist' if `touse', /* 
				*/ i(`ivar') fe

                        matrix `b0'=e(b)
			scalar `ov2' = e(sigma_e)^2
			scalar `ou2' = e(sigma_u)^2/(1-2/_pi)

						/* adjust constant term */
			local num : word count `varlist'
                	if "`constant'" == "" {
				scalar `cons0' = `b0'[1,`num'+1] /*
					*/ + $S_COST*sqrt(2/_pi)*sqrt(`ou2')
				if `num' > 0 {
					mat `b0' = (`b0'[1,1..`num'],`cons0')
				}
				else {
					mat `b0' = (`cons0')
				}
			}
			else {
				mat `b0' = `b0'[1,1..`num']
			}

                        local etaopt
                }

		tempname lnsigS2 gamma mu ltgamma cons0
                scalar `lnsigS2' = ln(`ou2'+`ov2')
                scalar `gamma' = `ou2'/(`ou2'+`ov2')
                scalar `ltgamma' = ln(`gamma'/(1-`gamma'))
                scalar `mu' = 0

                mat `b0' = (`b0', `lnsigS2', `ltgamma', `mu' `etaopt')

                local start "init(`b0', copy)"
        }
        else  {
                local start "init(`from')"
        }
        if "`ti'" ~= "" {
                local prog "xtsf_llti"
		local model "ti"
                local effect "Time-invariant"
                local eq_eta
        }
        else {
                local prog "xtsf_ll"
		local model "tvd"
                local effect "Time-varying decay"
                local eq_eta "(eta:)"
        }
	`vv' ///
        ml model d2 `prog' (`eq1': `lhs'=`varlist', `nocns') /*
                */ (lnsigma2:) (`gammaparm':) (mu:) `eq_eta' /*
                */ `wtopt' if `touse', collinear /* 
                */ max miss `start' search(off) nopreserve /*
                */ `mlopts' `constr' `difficult' /*
                */ title("`effect' inefficiency model") `negh'

	tempname b
	mat `b' = e(b)

	local bnames : colnames `b'
	if `"`varlist'"' != "" {
		local i = 1
		foreach var of local varlist {
			local orig: word `i' of `names'
			local bnames : subinstr local bnames `"`var'"' /*
			*/ `"`orig'"', word
			local i = `i' + 1
		}
	}
	version 11: mat colnames `b' = `bnames'
					/* constraints */
	eret repost b=`b' [`weight'`exp'], ///
			rename esample(`touse') buildfvinfo

					/* for header display */
	qui {
		tempvar Ti touse1
		qui gen byte `touse1' = e(sample)
		sort `touse1' `ivar'
		if "`weight'" == "iweight" {
			replace `wvar' = 1 if `touse1'
		}
		by `touse1' `ivar': gen double `Ti' = sum(`touse1'*`wvar')
		by `touse1' `ivar': replace `Ti' = . if _n~=_N 
		count if `Ti'~=0 & `Ti'<.
		local N = r(N)			/* # of panels */
		summ `Ti' if `Ti'>0, meanonly
		eret scalar N_g = `N'
		eret scalar g_min = r(min)
		eret scalar g_avg = r(mean)
		eret scalar g_max = r(max)
		eret scalar Tcon = ( r(min) == r(max) )
	}

	if `fvops' {
		_prefix_model_test, minimum
	}

	eret hidden local depname "`lhsname'"
	eret local depvar "`lhsname'"
	eret local wexp "`exp'"		/* repost weight expression */
        eret local predict "xtfront_p"
        eret local function "`function'"
        eret local model "`model'"
        eret local ivar "`ivar'"
        eret local tvar "`tvar'"

        eret scalar sigma2 = exp([lnsigma2]_cons)
        eret scalar gamma = exp([`gammaparm']_cons)/(1+exp([`gammaparm']_cons))
        eret scalar sigma_u = sqrt(`e(gamma)'*`e(sigma2)')
        eret scalar sigma_v = sqrt((1-`e(gamma)')*`e(sigma2)')

	if "`e(model)'" == "tvd" {
		eret hidden scalar k_eq_skip = 4
	}
	else eret hidden scalar k_eq_skip = 3
	local i 0
        eret hidden local diparm`++i' mu
	if "`e(model)'" == "tvd" {
        	eret hidden local diparm`++i' eta
	}
        eret hidden local diparm`++i' lnsigma2
        eret hidden local diparm`++i' `gammaparm'
        eret hidden local diparm`++i' __sep__
        eret hidden local diparm`++i' lnsigma2, exp label(sigma2)
        eret hidden local diparm`++i' `gammaparm', ilogit label(gamma)
        eret hidden local diparm`++i' lnsigma2 `gammaparm', /*
                */ func( exp(@1)*exp(@2)/(1+exp(@2)) ) /*
                */ der( exp(@1)*exp(@2)/(1+exp(@2)) /*
                */ exp(@1)*(exp(@2)/(1+exp(@2))-(exp(@2)/(1+exp(@2)))^2) ) /*
                */ label(sigma_u2)
        eret hidden local diparm`++i' lnsigma2 `gammaparm', /*
                */ func( exp(@1)*(1-exp(@2)/(1+exp(@2))) ) /*
                */ der( exp(@1)*(1-exp(@2)/(1+exp(@2)))  /*
                */ (-exp(@1))*(exp(@2)/(1+exp(@2))-(exp(@2)/(1+exp(@2)))^2))/*
                */ label(sigma_v2) 

        eret local cmd "xtfrontier"                    /* last eret */

        Replay, `level' `diopts'
	mac drop S_COST
end


/* ---------------------------DISPLAY------------------------------------- */

program define Replay
        syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
						/* Header */
	cap confirm integer number `e(g_avg)'
	if _rc == 0 {
		local avgfmt "%10.0fc"
	}
	else {
		local avgfmt "%10.1fc"
	}

		/* for time invariant model, t irrelevant; don't display */
	if `"`e(tvar)'"' != "" & `"`e(model)'"' != "ti" {
		local disp_t /*
	*/ as txt "Time variable: " as res abbrev("`e(tvar)'",12)
	}

	di as txt _n "`e(title)'" _col(49) "Number of obs" _col(67) "=" /*
		*/ _col(70) as res %9.0g e(N)
	di as txt "Group variable: " as res abbrev("`e(ivar)'",12) /*
		*/ _col(49) as txt "Number of groups" _col(67) "=" /*
		*/ _col(70) as res %9.0g e(N_g) _n

	di `disp_t' as txt _col(49) "Obs per group:"

	di as txt _col(63) "min" _col(67) "=" _col(69) as res %10.0gc e(g_min)
	di as txt _col(63) "avg" _col(67) "=" _col(69) as res `avgfmt' e(g_avg)
	di as txt _col(63) "max" _col(67) "=" _col(69) as res %10.0gc e(g_max)

	if !missing(e(df_r)) {
		local model as txt _col(49) "F(" ///
			as res %4.0f e(df_m) as txt "," ///
			as res %7.0f e(df_r) as txt ")" ///
			_col(67) "=" _col(70) as res %9.2f abs(e(F))
		local pvalue _col(49) as txt "Prob > F" _col(67) "=" ///
			as res _col(73) %6.4f Ftail(e(df_m),e(df_r),e(F))
	}
	else {
		local model as txt _col(49) "`e(chi2type)' chi2(" ///
			as res e(df_m) as txt ")" ///
			_col(67) "=" _col(70) as res %9.2f abs(e(chi2))
		local pvalue _col(49) as txt "Prob > chi2" _col(67) "=" ///
			as res _col(73) %6.4f chiprob(e(df_m),abs(e(chi2)))
	}

	di as txt _n `model'

	if "`e(ll)'" != "" {
		di as txt "Log likelihood  = " as res %10.0g e(ll) `pvalue'
	}
	else {
		di `pvalue' 
	}
	di
						/* end header */

	_coef_table, level(`level') `diopts'
end
