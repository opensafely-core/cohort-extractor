*! version 1.11.3  04may2018
program areg_11, eclass byable(onecall) sort prop(mi)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ",missing :"
	}
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	syntax [anything] [aw fw pw] [if] [in],	[	///
		VCE(passthru)				///
		*					///
		]
	if `"`vce'"' != "" {
		`BY' _vce_parserun areg, mark(Absorb CLuster) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"areg `0'"'
			exit
		}
	}

	version 10, missing

	local call = string(_caller())

	if replay() {
		if `"`e(cmd)'"' != "areg" {
			error 301
		}
		if _by() { 
			error 190 
		}
		Replay `0'
		exit
	}
	qui syntax varlist(ts fv) [aw fw pw] [if] [in], Absorb(varname) [*]

	`vv' ///
	`BY' Estimate `varlist' [`weight'`exp'] `if' `in',	///
		absorb(`absorb') caller(`call') `options'
	ereturn local cmdline `"areg `0'"'
end

program Estimate, eclass byable(recall)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ",missing :"
	}
	version 10, missing
	syntax varlist(ts fv) [aw fw pw] [if] [in], Absorb(varname) /*
		*/ caller(real) [Level(cilevel) * ]

	_get_diopts diopts options, `options'
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if `fvops' {
		if _caller() < 11 {
			local vv "version 11: "
		}
	}
	gettoken y xvars : varlist
	_fv_check_depvar `y'
	tsunab y : `y'

	if `fvops' {
		`vv' _rmcoll `xvars' [`weight'`exp'] `if' `in', expand
		local xvars `"`r(varlist)'"'
	}
	local xnames : copy local xvars

	tsrevar `y'
	local yuse `r(varlist)'
	fvrevar `xvars'
	local xuse `r(varlist)'
	_vce_parse, argopt(CLuster) opt(OLS Robust) old	///
		: [`weight'`exp'], `options'
	local cluster `r(cluster)'
	local robust `r(robust)'
	local vce = cond("`r(vce)'" != "", "`r(vce)'", "ols")

	if `"`absorb'"'==`""' {
		di in red `"absorb() required"'
		exit 100
	}
	if `"`cluster'"'!=`""' {
		local clopt  `"cluster(`cluster')"'
		local robust `"robust"'
	}
	local wt `"`weight'"'
	if `"`weight'"'==`"pweight"' {
		local weight `"aweight"'
		local robust `"robust"'
	}
	if `"`robust'"'!=`""' {
		local mse1 `"mse1"'
	}

	tempvar touse x c
	tempname vadj b V
	quietly {

	/* Do mark/markout. */

		mark `touse' [`weight'`exp'] `if' `in'
		markout `touse' `yuse' `xuse'
		markout `touse' `absorb' `cluster', strok
		count if `touse'
		if      r(N) == 0 { 
			noisily error 2000 
		}
		else if r(N) == 1 { 
			noisily error 2001 
		}

	/* Preserve and keep. */

		if `"`weight'"'!=`""' {
			local wexp `"`exp'"'
			tempvar w
			gen double `w' `exp'
			local exp `"=`w'"'
		}

		preserve
		keep if `touse'

		keep `yuse' `xuse' `absorb' `cluster' `w'

		if `"`weight'"'==`""' { 
			local w 1 
		}

	/* Sort and count number of groups. */

		sort `absorb'
		count if `absorb'!=`absorb'[_n-1]
		local dfa = r(N) - 1

	/* If not robust, get R^2 from regression without fixed-effects.
	   This is used for test of fixed-effects.
	*/
		if `"`robust'"'==`""' {
			`vv' ///
			_regress `yuse' `xuse' [`weight'`exp']
			local r2c = e(r2)
			local dfe = e(df_r) - `dfa'
		}

	/* Remove means from varlist. */

		summ `yuse' [`weight'`exp']
		local sst = (r(N)-1)*r(Var)

		by `absorb': gen double `x' = sum(`w'*`yuse')/sum(`w')
		by `absorb': replace `x' = `yuse'-`x'[_N]+r(mean)
		drop `yuse'
		rename `x' `yuse'

		if `"`xuse'"' != "" {
			local pos : list posof "`absorb'" in xuse
			if `pos' {
				tempvar i
				gen `i' = 0
				local xuse : subinstr ///
					local xuse "`absorb'" "`i'", all word
			}
			foreach i of varlist `xuse' {
				summ `i' [`weight'`exp']
				by `absorb': gen double `x' = ///
 						sum(`w'*`i')/sum(`w')
				by `absorb': replace `x' = `i'-`x'[_N]+r(mean)
				drop `i'
				gen double `i' = `x'
				drop `x'
				// following code sets vars with no within-
				// grp variation to zero; without doing this,
				// these vars can appear to have std. devs.
				// on the order of 1e-12 or less (but not
				// zero), causing _reg to give param estimate
				// with virtually infinite variance
				count if `i' != `i'[1]
				if r(N) == 0 {
					replace `i' = 0
				}
			}
		}

	/* Do regression. */

		`vv' ///
		_regress `yuse' `xuse' [`weight'`exp'], `mse1'

		tempname fullv zero_cnt
		mat `fullv' = e(V)
		scalar `zero_cnt' = diag0cnt(`fullv')
		if `"`robust'"' == "robust" {
			scalar `zero_cnt' = 0
		}
		if `zero_cnt' > 0 {
			local coln : colnames `fullv'
			if "`vv'" == "" {
				local i 1
				foreach var of local coln {
					if `fullv'[`i',`i'] !=0 {
						local xred "`xred' `var'"
					}
					local ++i
				}
			} 
			else {
				local xred `coln'
			}
		}
		local nobs = e(N)
		local nvar = e(df_m)	/* # ind. variables in model */

		local mdf  = e(df_m) + `dfa'	/* regress model df */
/*
		if "`cluster'" == "" | `caller' < 9.1 {
			local mdf  = e(df_m) + `dfa'	/* true model df */
		}	
		else {
			local mdf  = e(df_m)            /* true model df */
		}
*/
		local sse  = e(rss)
		local ll = e(ll)
		local ll_0 = e(ll_0)

		local r2   = 1 - `sse'/`sst'
		local dfe  = `nobs' - 1 - `mdf'
		if `dfe'<=0 | `dfe'>=. {
			noisily error 2001
		}
		local ar2 = 1 - (1-`r2')*(`nobs' - 1)/`dfe'

	/* Adjust covariance matrix for correct dfe and post. */

		matrix `b' = get(_b)
		matrix `V' = get(VCE)

		if `"`robust'"'==`""' {
			scalar `vadj' = e(df_r)/`dfe'
			matrix `V' = `vadj'*`V'
		}
		else { /* setup for robust variance */
			local k = `mdf' + 1
			tempvar res
			predict double `res', res
		}

		if `"`robust'"'~=`""' {
			tempname vmb
			matrix `vmb' = `V'
			_robust2 `res' [`weight'`exp'], minus(`k') /*
			*/	`clopt' variance(`V')
			local cn = r(N_clust)
			if "`cluster'"~="" {
				local dfe = r(N_clust) - 1
			}
		}
		eret post `b' `V', dof(`dfe') obs(`nobs') depn(`y')
		_post_vce_rank

		if `:length local vmb' {
			eret matrix V_modelbased `vmb'
		}
	
		if `"`xvars'"'!=`""' {
			test [#1]

			eret scalar df_m = r(df)
			if r(df)==`nvar' {
				eret scalar F = r(F)
			}
			else {
				eret scalar F = .
			}
		}
		else {
			eret scalar df_m = 0
			eret scalar F = .
		}
		global S_E_mdf = e(df_m)
		global S_E_f   = e(F)

		eret local vce `vce'
		if `"`robust'"'==`""' {
			if `zero_cnt' > 0 {
				tempname hold
				_est hold `hold', copy
				restore
				local xuse2 : subinstr local xred "_cons" "", word
				`vv' ///
				qui _regress `yuse' `xuse2' ///
				[`weight'`exp'] if `touse'
				local r2c = e(r2)
				_est unhold `hold'
			}
			eret scalar F_absorb = 		///
				((`r2'-`r2c')/`dfa')/((1-`r2')/`dfe')
			ereturn scalar p_absorb =       ///
                        	fprob(`dfa',`dfe',e(F_absorb))
			global S_E_f2 = e(F_absorb)
		}
		else {
			eret local vcetype `"Robust"'
			global S_E_vce `"Robust"'
			if `"`cluster'"' != "" {
				eret scalar N_clust = `cn'
				eret local clustvar `"`cluster'"'

				global S_E_cn  `"`cn'"'
				global S_E_cvn `"`cluster'"'
			}
		}
		eret scalar N = `nobs'
		eret scalar rss = `sse'

		eret scalar ll = `ll'
		eret scalar ll_0 = `ll_0'

		eret scalar tss  = `sst'
		eret scalar r2   = 1 - `sse'/`sst'
		eret historical(9.2) scalar ar2  = `ar2'
		eret scalar r2_a = `ar2'
		eret scalar df_r = `dfe'
		eret local absvar `"`absorb'"'
		eret scalar df_a = `dfa'
		eret scalar rmse = `=sqrt(e(rss)/(e(N)-e(df_a)-e(df_m)-1))'
		eret local wexp `"`wexp'"'
		eret local wtype `"`wt'"'
		eret local depvar `"`y'"'
		eret scalar k_absorb = e(df_a) + 1

		global S_E_nobs `"`nobs'"'
		global S_E_sse  `"`sse'"'
		global S_E_sst	`"`sst'"'
		global S_E_r2   `"`e(r2)'"'
		global S_E_tdf  `"`dfe'"'
		global S_E_abs	`"`absorb'"'
		global S_E_dfa  `"`dfa'"'
		global S_E_depv `"`y'"'

		eret local marginsnotok Residuals SCore
		eret local predict areg_p
		eret local title "Linear regression, absorbing indicators"
		ereturn hidden local title2 "Absorbed variable: `absorb'"
		eret local footnote areg_footnote
		eret local cmd  "areg"
		global S_E_cmd "areg"

		
		if `zero_cnt' == 0 {
			restore
		}
		local coln : colnames e(b)
		local XNAMES : copy local xnames
		local i 1
		foreach var of local coln {
			gettoken xname XNAMES : XNAMES
			_ms_parse_parts `var'
			if `r(omit)' {
				_ms_parse_parts `xname'
				if !`r(omit)' {
					noi di "{txt}note: `xname' omitted" /*
						*/ " because of collinearity"
				}
			}
		}
		matrix `b' = e(b)
		`vv' matrix colnames `b' = `xnames' _cons
		_ms_op_info `b'
		if r(tsops) {
			quietly tsset, noquery
		}
		eret repost b=`b' [`wt'`wexp'],	rename			///
						esample(`touse')	///
						buildfvinfo		///
						findomitted
	}
	mat `b' = e(b)
	_ms_omit_info `b'
	local cols = colsof(`b')
        if `r(k_omit)' {
		if `r(k_omit)' == `cols' {
			local varlist ""
               	}
               	else {
               	  mata : ///
           	  st_local("varlist",invtokens(select(st_matrixcolstripe ///
		  ("`b'")[.,2]',1:-st_matrix("r(omit)"))))
		  local varlist : subinstr local varlist "_cons" "", word
               	}
        }
	unopvarlist `y' `varlist'
	local varlist `r(varlist)'
	signestimationsample `varlist' `absorb' `e(clustvar)' 

	/* Display results. */

	Replay, level(`level') `diopts'
end

program Replay
	syntax [, *]

	_get_diopts diopts, `options'
	if "`e(prefix)'" != "" {
		_prefix_display, `diopts'
		exit
	}
	_coef_table_header
	di
	_coef_table, `diopts'
	_prefix_footnote
end
