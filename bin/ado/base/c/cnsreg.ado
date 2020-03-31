*! version 3.8.0  30oct2017
program define cnsreg, eclass byable(onecall) properties(svyb svyj svyr mi)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun cnsreg, mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"cnsreg `0'"'
		exit
	}

	version 7.0, missing
	if replay() {
		if `"`e(cmd)'"'~="cnsreg" { 
			error 301
		}
		if _by() { 
			error 190 
		}
		Replay `0'
		exit
	}
	local vv : di "version " string(_caller()) ", missing:"
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"cnsreg `0'"'
end

program Estimate, eclass byable(recall)
	local vv : di "version " string(_caller()) ", missing:"
	version 7.0, missing
	syntax varlist(fv ts) [if] [in] [aw iw fw pw] [, /*
		*/ Level(cilevel) /*
		*/ Constraints(string) noCONStant MSE1 /*
		*/ VCE(passthru) Robust CLuster(passthru) /*
		*/ COLlinear * ]
	local usermcoll = _caller() >= 12
	if `"`constraints'"'=="" {
		di in red "constraints() required"
		exit 198
	}
	_get_diopts diopts, `options'

	if `"`constant'"' == "" {
		local cons "_cons"
	}

	if "`weight'" != "" {
		local wt [`weight'`exp']
	}

	marksample touse
	_vce_parse `touse', argopt(CLuster) opt(OLS Robust) old	///
		: `wt', `vce' `robust' `cluster'
	local robust `r(robust)'
	local cluster `r(cluster)'
	local vce = cond("`r(vce)'" != "", "`r(vce)'", "ols")
	if "`robust'" == "robust" {
		if "`cluster'" != "" {
			opts_exclusive "vce(cluster) `mse1'"
		}
		else	opts_exclusive "vce(robust) `mse1'"
	}

	tempname CP YY XY XX XXat Proj_M T Tt a b C TT TM1 /*
		*/ b_dummy V_dummy R r t con_det j k ll

	gettoken y xvars : varlist
	_fv_check_depvar `y'
	if `usermcoll' {
		`vv' _rmcoll `xvars' if `touse' `wt', expand `collinear'
	}
	else	fvexpand `xvars' if `touse'
	local xvars `"`r(varlist)'"'
	local numcols : word count `xvars' `cons'

	* create and post dummy matrices for mat makeCns
	mat `b_dummy' = J(1,`numcols',0)
	`vv' ///
	mat colnames `b_dummy'  = `xvars' `cons'
	mat `V_dummy' = J(`numcols',`numcols',0)
	`vv' ///
	mat colnames `V_dummy' = `xvars' `cons'
	`vv' ///
	mat rownames `V_dummy' = `xvars' `cons'
	mat post `b_dummy' `V_dummy'
	mat `V_dummy' = get(VCE)

	* create/access constraint matrices
	local constraints : subinstr local constraints "," " ", all
	version 11: makecns `constraints'
	local k_autoCns = r(k_autoCns)
	`vv' ///
	matcproc `T' `a' `C'

	if "`weight'" == "pweight" {
		quietly count if `touse'
		local nobs  = `r(N)'
	}
	qui mat accum `CP' = `y' `xvars' `wt' if `touse', `constant'
	if "`weight'" != "pweight" {
		local nobs  = `r(N)'
	}
	mat `YY' = `CP'[1,1]
	mat `XY' = `CP'[2...,1]
	mat `XX' = `CP'[2...,2...]
	mat `Tt' = `T''
	mat `XXat' = `XX'*`a''
	mat `TT' = `Tt'*(`XX'*`T')
	mat `TM1' = syminv(`TT')

	CheckDiag `TT' `TM1'
	if r(error) {
		di in red "constraints insufficient for unique estimate"
		error 412
	}
	local dropped = r(dropped)

	* compute T(T'X'WXT)^(-1)T'
	mat `Proj_M' = `T'*`TM1'*`Tt'

	* compute coefficient vector b
	mat `b' = (`Proj_M'*(`XY' - `XXat'))' + `a'
	* compute mse and VCE
	tempname MSE SSE VCE
	mat `SSE' = `YY' - 2*`b'*`XY' + `b'*`XX'*`b''
	scalar `MSE' = `SSE'[1,1]
	local cdim = colsof(`C')
	local cdim1 = `cdim' - 1
	if "`mse1'" == "" {
		local df = `nobs' - colsof(`b') + rowsof(`C') + `dropped'
		scalar `MSE' = `MSE'/`df'
	}
	else {
		local df = `nobs'
		scalar `MSE' = 1
	}
	if "`robust'" == "" {
		mat `VCE' = `MSE'*`Proj_M'
	}
	else {
		mat `VCE' = `Proj_M'
		local minus = colsof(`b') - rowsof(`C')
	}
	scalar `ll' = -0.5 * `nobs' * /*
		*/ ( ln(2*_pi) + ln(`SSE'[1,1]/`nobs') + 1 )

	/* create R and r before post */
	matrix `R' = `C'[1...,1..`cdim1'] 
	matrix `r' = `C'[1...,`cdim']
	local wgt "[`weight'`exp']"
	est post `b' `VCE' `C' `wgt', obs(`nobs') dof(`df') dep(`y') /*
		*/ esample(`touse') buildfvinfo

	est hidden scalar k_autoCns = `k_autoCns'

	/* Test model = 0 is only sensible when r = 0 or when there
	   is a single nonzero entry of r that corresponds to a
	   constraint: _cons = number
	*/
	matrix `t' = `r''*`r'  /* if t = 0, we will test model */
	if `t'[1,1] ~= 0 {
		/* Find nonzero entry of `r' and check that
		   there is only one
		*/
		scalar `j' = 1
		scalar `k' = 0
		while `j' <= rowsof(`r') {
			if `r'[`j',1] ~= 0 {
				if `k' == 0 { 
					scalar `k' = `j'
				}
				/* else two or more nonzeros */
				else scalar `k' = -1
			}
			scalar `j' = `j' + 1
		}
		if `k' > 0 & "`constant'" ~= "" {
			scalar `k' = -1
		}
		/* Look for constraint: _cons = number */
		if `k' > 0 {
			local kk = `k'
			matrix `t' = `R'[`kk',1...]
			local kc = colnumb(`V_dummy',"_cons")
			matrix `t'[1,`kc'] = 0
			matrix `t' = `t'*`t''
			/* if t = 0, we will test model */
		}
	}
	if `t'[1,1] == 0 {
		quietly test `xvars'
		est scalar df_m = r(df)
		est scalar F = r(F)
		est scalar p = Ftail(e(df_m),`df',e(F))
	}
	else {
		est scalar df_m = .
		est scalar F = .
		est scalar p = .
	}
	est scalar N = `nobs'
	est scalar df_r = `df'
	est scalar rmse = sqrt(`MSE')
	est scalar ll = `ll'
	est local vce "`vce'"
	est local marginsok default XB
	est local depvar `"`y'"'
	est local predict "tobit_p"
	est local wtype "`weight'"
	est local wexp "`exp'"
	est local title "Constrained linear regression"
	est local cmd "cnsreg"
	if "`robust'" != "" {
		_robust3 `wt', cluster(`cluster') minus(`minus')
	}
	_post_vce_rank

	/* double save in S_E_<stuff> and e()  */
	global S_E_mdf  `e(df_m)'
	global S_E_f    `e(F)'
	global S_E_nobs `e(N)'
	global S_E_tdf  `e(df_r)'
	global S_E_rms  `e(rmse)'
	global S_E_depv `e(depvar)'
	global S_E_cmd  "cnsreg"

	Replay, level(`level') `diopts'
end

program CheckDiag, rclass
	args TT TM1

	return scalar dropped = 0
	if diag0cnt(`TM1')  == 0 {
		return scalar error = 0
		exit
	}
	if diag0cnt(`TT')  == 0 {
		return scalar error = 1
		exit
	}
	local dim = colsof(`TT')
	forval i = 1/`dim' {
		if `TT'[`i',`i']==0 & `TM1'[`i',`i']!=0 {
			return scalar error = 1
			exit
		}
	}
	return scalar error = 0
	return scalar dropped = diag0cnt(`TT')
end

program Replay
	_prefix_display `0'
end
exit
