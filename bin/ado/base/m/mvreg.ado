*! version 3.6.2  07nov2018
program define mvreg, eclass byable(recall) properties(mi bayes)
	version 6, missing

	local myopt "Level(cilevel) noTable noHeader CORr"
	local domano 0 // whether to act as a manova coefficient replayer
	tempname sigma tsig
	tempname rcv
	if !replay() {
		local cmdline : copy local 0
		gettoken word 0 : 0, parse(" =:,")
		while `"`word'"' != ":" & `"`word'"' != "=" { 
			if `"`word'"' == "," | `"`word'"'=="" { 
				error 198
			}
			local eqnames `eqnames' `word'
			gettoken word 0 : 0, parse(" =:,")
		}

		local roc `"`0'"'
		_fv_check_depvar `eqnames'
		tsunab depvars : `eqnames'
		local eqnames : subinstr local depvars "." "_" , all
		syntax varlist(fv ts) [if] [in] [aw fw] [, ///
			`myopt' noCONstant *]

		_get_diopts diopts, `options'
		local fvops = "`s(fvops)'" == "true" | _caller() >= 11

		if `fvops' {
			local fexp "expand"
			local vv : di "version " ///
			string(max(11,_caller())) ", missing:"
		}
		local neq : word count `eqnames'
		local i 1
		while (`i'<=`neq') {
			local eqn : word `i' of `eqnames'
			local junk : subinstr local eqnames "`eqn'" "", /*
				*/ word all count(local j)
			if `j' > 1 {
				di as error /*
*/	"cannot specify the same dependent variable more than once"
				error 498
			}
			eq `eqn' `varlist'
			local i = `i' + 1
		}
		tempvar touse
		mark `touse' `if' `in' [`weight'`exp']
		markout `touse' `depvars' `varlist'
		if  "`vv'" != "" {
			`vv'  _rmcoll `varlist' if `touse', `fexp' `constant'
			local varlist `r(varlist)' 
		}
		tempname ee xx xy yy bb xxi cxxi b idfe
		qui mat accum `ee' = `depvars' `varlist' /*
			*/ if `touse' [`weight'`exp'], `constant'
		local nobs = r(N)
		local neqp1 = `neq' + 1
		mat `xx' = `ee'[`neqp1'...,`neqp1'...]
		mat `xy' = `ee'[`neqp1'...,1..`neq']
		mat `yy' = `ee'[1..`neq',1..`neq']
		mat drop `ee'
		mat `xxi' = syminv(`xx')
		mat `bb' = `xy'' * `xxi'
		mat `rcv' = `yy' - `bb'*`xx'*`bb''

		local knum = rowsof(`xx') - diag0cnt(`xxi')
		local dfe = `nobs' - `knum'
		if `dfe' < 1 {
			di as err "insufficient residual degrees of freedom"
			exit 2001
		}
		scalar `idfe' = 1/`dfe'
		mat `rcv' = `rcv' * `idfe'
		mat `cxxi' = `rcv' # `xxi'
		local i 1
		while (`i' <= `neq') {
			mat `xx' = `bb'[`i',1...]
			local eqn : word `i' of `eqnames'
			local dep : word `i' of `depvars'
			mat coleq `xx' = `eqn'
			mat `b' = nullmat(`b') , `xx'
			local t : display string(sqrt(`rcv'[`i',`i']), "%9.0g")
			local sd "`sd' `t'"
			qui summ `dep' if `touse' [`weight'`exp']
			if ("`constant'"=="") {
				local t = 1 - `rcv'[`i',`i']*`dfe' /*
					     */ /(r(N)-1)/r(Var)
			}
			else local t = 1 - `rcv'[`i',`i']*`dfe'/`yy'[`i',`i']
			local t : display string(`t', "%6.4f") 
			local r2 "`r2' `t'"
			local i = `i' + 1
		}
		local stripe : colfullnames `b'
		version 11: mat colnames `cxxi' = `stripe'
		version 11: mat rownames `cxxi' = `stripe'
		est post `b' `cxxi' [`weight'`exp'], ///
			dof(`dfe') esample(`touse') buildfvinfo fvinfoeq(1)
		local i 1
		while (`i' <= `neq') {
			local eqn : word `i' of `eqnames'
			qui test [`eqn']
			local t : display string(r(F), "%9.0g") 
			local f "`f' `t'"
			local t : display /*
				*/ string(fprob(r(df),r(df_r),r(F)), "%6.4f")
			local prv "`prv' `t'"
			local i = `i' + 1
		}

		est local r2 "`r2'"
		est local p_F "`prv'"
		est local rmse "`sd'"
		est local F "`f'"
		est local eqnames "`eqnames'"
		est local depvar  "`depvars'"
		est scalar k  = `knum'
		est scalar df_r = `dfe'
		est scalar k_eq = `neq'
		est scalar N    = `nobs'
		est local predict "reg3_p"
		est local marginsnotok stdp Residuals stddp
		est local marginsok "XB default"
		foreach eq of local eqnames {
			local mdflt `mdflt' predict(xb equation(`eq'))
		}
		est local marginsdefault `"`mdflt'"'
		if `"`weight'`exp'"' != "" {
			est local wtype `"`weight'"'
			est local wexp `"`exp'"'
		}
		est local estat_cmd "mvreg_estat"
		version 10: ereturn local cmdline `"mvreg `cmdline'"'
		est local cmd "mvreg"

		/* Double saves */
		global S_E_r2    "`e(r2)'"
		global S_E_pv    "`e(p_F)'"
		global S_E_sd    "`e(rmse)'"
		global S_E_f     "`e(F)'"
		global S_E_elis  "`e(eqnames)'"
		global S_E_par   "`e(k)'"
		global S_E_tdf   "`e(df_r)'"
		global S_E_neq   "`e(k_eq)'"
		global S_E_nobs  "`e(N)'"
		global S_E_cmd   "`e(cmd)'"
		if _caller()<6 {
			matrix S_E_rcv = `rcv'
		}
		est matrix Sigma `rcv'
		_post_vce_rank		

		mat drop `xx' `yy' `xy' `bb'
	}
	else {	// replay (mvreg is also used to show/replay coefficients
		//	   from manova as long as e(version) is 2)
		if (("`e(cmd)'"!="mvreg")&("`e(version)'`e(cmd)'"!="2manova")) {
			error 301
		}
		if _by() { error 190 }
		syntax [, `myopt' *]
		_get_diopts diopts, `options'
		if "`e(version)'`e(cmd)'"=="2manova" {
			local domano 1
		}
	}
	if ("`header'"=="") {
		local i 1
		di
		di in gr "Equation             Obs   Parms        RMSE    " _quote "R-sq" _quote "          F        P"
		di in smcl in gr "{hline 74}"
		while (`i'<=e(k_eq)) {
			if `domano' {
				local myword : word `i' of `e(depvar)'
			}
			else {
				local myword : word `i' of `e(eqnames)'
			}
			local sd : word `i' of `e(rmse)'
			local r2 : word `i' of `e(r2)'
			local f  : word `i' of `e(F)'
			local pv : word `i' of `e(p_F)'
			local parms "`e(k)'"
			local nobs e(N)     
			local myword = abbrev("`myword'",12)
			di in ye "`myword'" _col(15) %10.0fc `nobs' /*
				*/ %8.0f `parms' /*
				*/ "   " %9.0g `sd' %10.4f `r2' "  " /*
				*/ %9.0g `f' %9.4f `pv'
			local i = `i' + 1
		}
	}
	if ("`table'"=="") {
		di
		_coef_table, level(`level') `diopts'
	}
	if ("`corr'"!="") {
		di
		if `domano' {
			mat `sigma' = corr(e(E))
		}
		else {
			mat `sigma' = corr(e(Sigma))
		}
		di in gr "Correlation matrix of residuals:"
		mat list `sigma', nohead format(%9.4f)
		mat `sigma' = `sigma' * `sigma' '
		local tsig = (trace(`sigma') - e(k_eq))*e(N)/2
		local df = e(k_eq)*(e(k_eq)-1)/2
		di
		di in gr "Breusch-Pagan test of independence: chi2(`df') = " /*
		*/ in ye %9.3f `tsig' in gr ", Pr = " %6.4f /* 
		*/ in ye chiprob(`df',`tsig')

		est scalar df_chi2 = `df'
		est scalar chi2 = `tsig'

		/* Double saves */
		global S_3 "`e(df_chi2)'"
		global S_4 "`e(chi2)'"
	}
end

exit
