*! version 2.7.0  09apr2018
program define nl, eclass byable(onecall) properties(svyb svyj svyr)

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	
	if _caller() < 9.1 {
		`BY' nl_9 `0'
		exit
	}

	if !replay() {
		// Do quietly to avoid two "(analytic weights assumed)"
		// msgs. if you specify [w = <wtvar>]
		qui syntax anything [if] [in] [aw fw pw iw] , [vce(string) *]
		if "`weight'" != "" & "`vce'" != "" {
			local vcelen = length("`vce'")
			if "`vce'" != bsubstr("robust", 1, `vcelen') {
				di as error "weights not allowed with vce()"
				exit 101
			}
		}
	}
	
	`BY' _vce_parserun nl, noeqlist : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"nl `0'"'
		exit
	}
	
	version 9.1, missing
	
	if replay() {
		if "`e(cmd)'"!="nl" { 
			error 301 
		} 
		if _by() { 
			error 190 
		}
		NLout `0'
		exit
	}
	`BY' Estimate `0'
	ereturn local cmdline `"nl `0'"'
end
	
program define Estimate, eclass byable(recall) sortpreserve

	version 9.1, missing
	
	local zero `0'		/* Backup copy */

	/* type = 1 : inline ftn, type = 2 : sexpprog, type = 3 : funcprog */
	local type
	gettoken expr 0 : 0 , match(paren)
	if "`paren'" == "(" {
		local type 1
	}
	else {
		local 0 `zero'
		local expr
		/* Parse on : and @ to see if we are called with a 
		   new-style user-defined function.  	*/
		gettoken part 0 : 0 , parse(" :@") quotes
		while `"`part'"' != ":" & `"`part'"' != "@" & `"`part'"' != "" {
			local expr `"`expr' `part'"'
			gettoken part 0 : 0 , parse(" :@") quote
		}
		if `"`part'"' == ":" {
			local type 2
		}
		else if `"`part'"' == "@" {
			local type 3
		}
		if `"`0'"' != "" {
			syntax varlist(min=1) [if] [in] [aw fw pw iw] ,	/*
				*/ [ PARAMeters(namelist) 		/*
				*/   NPARAMeters(integer 0) * ]
			local vars `varlist'
			local params `"`parameters'"'   /* short name */
			local nparams `"`nparameters'"' /* short name */
			local 0 `"`if' `in' [`weight'`exp'] , `options'"'
		} 
		if "`type'" == "3" {	/* type may be empty ; treat as str*/
			if "`params'" == "" & `nparams' == 0 {
di as error "must specify parameters() or nparameters()"
				exit 198
			}
		}
	}
	if "`type'" == "" {
		local 0 `zero'
		gettoken a b : 0, parse(",") quotes
		if _by() {
			nl_7 `a' if `_byindex'==`=_byindex()' `b'
		}
		else {
			nl_7 `0' 
		}
		exit
	}
	local expr `expr'	/* Remove leading and trailing whitespace*/
	syntax [if] [in] [aw fw iw pw] [, /*
		*/ DELta(real 4e-7) EPS(real 0) INitial(string)		/*
		*/ ITERate(integer 0) LEAve LNlsq(real 1e20) NOLOg LOg 	/*
		*/ TITLE(string) TITLE2(string) TRace 			/*
		*/ Hasconstant(string) noConstant			/*
		*/ VAriables(varlist numeric ts) Robust			/*
		*/ CLuster(passthru) hc2 hc3 VCE(passthru) 		/*
		*/ Level(cilevel) MSE1 * ]

	_get_diopts diopts options, `options'
	_vce_parse, argopt(CLuster HAC) opt(GNR Robust HC2 HC3) old	/*
		*/ : [`weight'`exp'], `vce' `robust' `cluster'
	local cluster `r(cluster)'
	local robust `r(robust)'
	if bsubstr("`r(vce)'",1,2) == "hc" {
		local `r(vce)' `r(vce)'
	}
	if "`r(vce)'" == "hac" {
		local vce `"`r(vce)' `r(vceargs)'"'
	}
	else	local vce
	local vce2 = cond("`r(vce)'" != "", "`r(vce)'", "gnr")
	/* Syntax checking */
	if "`cluster'" != "" & "`hc2'" != "" {
		di as error "cannot use hc2 with cluster()"
		exit 198
	}
	if "`cluster'" != "" & "`hc3'" != "" {
		di as error "cannot use hc3 with cluster()"
		exit 198
	}
	if "`hc2'" != "" & "`hc3'" != "" {
		di as error "cannot specify both hc2 and hc3"
		exit 198
	}
	if `type' == 1 & "`options'" != "" {
		di as error "`options' not allowed"
		exit 198
	}
	if "`hasconstant'" != "" & "`constant'" != "" {
di as error "cannot combine hasconstant() and noconstant"
		exit 198
	}
	if "`cluster'`hc2'`hc3'" != "" & "`weight'" == "iweight" {
		if "`cluster'" != "" {
			local opt cluster()
		}
		else {
			local opt `hc2'`hc3'
		}
		di as error "option {bf:`opt'} not available with iweights"
		exit 101
	}
	if `"`vce'"' != "" {
		if "`hc2'" != "" {
			di as error "cannot specify both vce() and hc2"
			exit 198
		}
		if "`hc3'" != "" {
			di as error "cannot specify both vce() and hc3"
			exit 198
		}
		if "`robust'" != "" {
			di as error "cannot specify both vce() and robust"
			exit 198
		}
		if `"`vce'"' == /*
		*/	bsubstr("robust", 1, max(1, `=length(`"`vce'"')')) {
			local robust "robust"
		}
		else {
			CheckVCE `"`vce'"'
			qui tsset , noquery
			local hac "yes"
			local hactype `s(hactype)'
			local haclags `s(lags)'
		}
	}
	marksample touse
	if "`cluster'" != "" {
		markout `touse' `cluster', strok
	}
	if "`variables'" != "" {
		markout `touse' `variables'
	}
	if "`vars'" != "" {
		markout `touse' `vars'
	}
	local wtexp
	if "`weight'`exp'" != "" {
		local wtexp "[`weight'`exp']"
	}
	if `type' == 2 {
		if "`options'" != "" {
			capture nl`expr' `vars' `wtexp' if `touse', `options'
		}
		else {
			capture nl`expr' `vars' `wtexp' if `touse'
		}
		if _rc {
			di as error "nl`expr' returned " _rc
di as error "verify that nl`expr' is a substitutable expression program"
di as error "and that you have specified all options that it requires"
			exit _rc
		}
		local expr `"`r(eq)'"'
		if "`title'" == "" & "`r(title)'" != "" {
			local title `"`r(title)'"'
		}
	}
	if `type' < 3 {
		gettoken yname expr : expr , parse("= ")
		gettoken equal expr : expr , parse("= ")
		if "`equal'" != "=" {
			local expr `equal' `expr'
		}
	}
	if `type' == 2 | `type' == 3 {
		tokenize `vars'
		if `type' == 3 {
			local yname `1'  /* if type 2, based on subst expr */
		}
		mac shift
		local t23rhs `*'
	}
	
	tempname parmvec mnlnwt sumwt meany vary gm2 old_ssr ssr f sstot 
	tsunab yname : `yname'
	confirm numeric variable `yname'

						/* set up expression for
						   evaluation and iteration */
	if `type' < 3 {
		_parmlist `expr'
		local expr `r(expr)'
		local params `r(parmlist)'
		matrix   `parmvec' = r(initmat)
		local np = r(k)
		if `np' == 0 { 
			di in red "no parameters in expression"
			exit 198
		}
		local origexp `"`expr'"'
						/* set up initial values */
		foreach parm of local params {
			local j = colnumb(`parmvec', "`parm'")
			local expr : subinstr local expr /*
				*/ "{`parm'}" "\`parmvec'[1,`j']", all
		}
	}
	else {
		if "`params'" != "" {
			local params : list retok params
			local np : word count `params'
			if `nparams' > 0 & `nparams' != `np' {
				di as error ///
"number of parameters in parameters() does not match nparameters()"
				exit 198
			}
		}
		else {
			if `nparams' <= 0 {
				di as error "no parameters declared"
				exit 198
			}
			local params "b1"
			forvalues i = 2/`nparams' {
				local params "`params' b`i'"
			}
			local np   `nparams'	/* rest of code uses np */
		}
		matrix `parmvec' = J(1, `np', 0)
		matrix colnames `parmvec' = `params'
	}
	
	/* Initial() option overrides other initial values.  */
	if "`initial'" != "" {
		if `:word count `initial'' == 1 {	/* matrix */
			capture confirm matrix `initial'
			if _rc {
				di as error "matrix `initial' not found"
				exit 480
			}
			if `=colsof(`initial')' != `np' {
				di as error /*
*/ "initial matrix must have as many columns as parameters in model"
				exit 480
			}
			matrix `parmvec' = `initial'
			matrix colnames `parmvec' = `params'
		}
		else {				/* Must be <parm> # ... */
			if mod(`:word count `initial'', 2) != 0 {
				di as error "invalid initial() option"
				exit 480
			}
			tokenize `initial'
			while "`*'" != "" {
				capture local col = colnumb(`parmvec', "`1'")
				if _rc | `col' == . {
		di as error "invalid parameter `1' in initial()"
					exit 480
				}
				else {
					matrix `parmvec'[1, `col'] = `2'
				}
				mac shift 2
			}
		}
	}
	/* Check hasconstant() option */
	if "`hasconstant'" != "" {
		if `:word count `hasconstant'' > 1 {
			di as error "option hasconstant() incorrectly specified"
			exit 198
		}
		local junk : subinstr local /*
			*/ params "`hasconstant'" "", word all count(local j)
		if `j' != 1 {
			di as error "`hasconstant' not found among parameters"
di as error "check hasconstant() option or try using nl without it"
			exit 498
		}
	}

	/* Now that we have initial values, verify type 3 or type 3
	   program is appropriate */
	if `type' == 3 {
		tempvar junk
		gen double `junk' = `yname' if `touse'
		if "`options'" != "" {
			capture nl`expr' `junk' `t23rhs' `wtexp' if `touse', /*
				*/ `options' at(`parmvec')
		}
		else {
			capture nl`expr' `junk' `t23rhs' `wtexp' if `touse', /*
				*/ at(`parmvec')
		}
		if _rc {
			di as error "nl`expr' returned " _rc
di as error "verify that nl`expr' is a function evaluator program"
			exit _rc
		}
	}
	
	tempname initvec		/* For saving later */
	matrix `initvec' = `parmvec'

	if "`leave'" != "" { /* confirm `params' are not currently variables */
		confirm new var `params'
	}

	local funcerr "error #\`rc' occurred in evaluating expression"
/*
		If lnlsq(k) is specified y and yhat are effectively (though
		not computationally) transformed to g*ln(y-k) and g*ln(yhat-k)
		where g = geometric_mean(y-k).
*/
	local logtsf 0
	if `lnlsq' < .999e20 { 
		local logtsf 1 
	}
/*
		iterate is the max iterations allowed.
		eps and tau control parameter convergence, see Gallant p 28.
		delta is a proportional increment for calculating derivatives,
		appropriately modified for very small parameter values.
*/
	local iterate = cond(`iterate'<=0, c(maxiter), `iterate')
	local eps = cond(`eps'<=0, 1e-5, `eps')
	local tau 1e-3

/*
		Set up y-variate (YVAR)
*/
	tempvar YVAR Z tmp dbeta 	/* dbeta for _est hold */
	qui gen double `Z' = 0 if `touse' 

/*
	Update touse for observations for which depvar is missing 
*/
	qui gen double `YVAR' = `yname' if `touse'
	qui replace `touse' = 0 if `YVAR' >= .
	scalar `mnlnwt' = 0 /* mean log normalized weights */
	qui if `"`exp'"' != "" { 
		/* Get sum of weights for output and deviance.
		   Do not use user's weight expression in -summ- */
		tempvar s
		gen double `s' `exp' if `touse'
		summ `s' if `touse', meanonly 
		if "`weight'" != "iweight" {
			noi di in gr "(sum of wgt is " r(N)*r(mean) ")"
		}
		replace `s' = ln(`s'/r(mean))
		summ `s' if `touse', meanonly
		scalar `mnlnwt' = r(mean)
		drop `s'
	}
	else {
		qui count if `touse'
		di in gr "(obs = " string(r(N), "%12.0fc") ")"
	}
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"=="" { 
		di 
	}

	if `logtsf' {
		capture assert (`YVAR'-`lnlsq')>0 if `touse'
		if _rc {
			di in red /*
 */ "nonpositive value(s) among `yname'-`lnlsq', cannot log transform"
			exit 482
		} 
		qui replace `YVAR' = ln(`YVAR'-`lnlsq') if `touse'
	}
	qui count if `touse'
	if r(N) < `np' {
		di in red "cannot have fewer observations than parameters"
		exit 2001
	}
	if "`weight'" == "pweight" {
		qui summ `YVAR' [aw`exp'] if `touse'
	}
	else {
		qui summ `YVAR' `wtexp' if `touse'
	}
	if "`weight'" == "iweight" {
		local nobs = round(r(sum_w),1)
	}
	else {
		local nobs = round(r(N), 1)
	}
	if r(min) == r(max) {
		di in red "`yname' has zero variance"
		exit 498
	}
	scalar `sumwt' = r(sum_w)
	scalar `meany' = r(mean)
	scalar `vary' = r(Var)
	
	
/*
		Initializations.

		Set up derivative vectors.
*/
	capture {		/* to handle dropping derivs	*/
		forvalues j = 1/`np' {
			* name is ``j''
			tempvar J`j'
			local Jnames "`Jnames' `J`j''"
			gen double `J`j'' = . 
		}
		tempvar RESID YHAT YHATi
		qui gen double `YHAT' = . 
		qui gen double `YHATi' = .
		if `type' < 3 {
			capture replace `YHAT' = `expr'
			if _rc {
				local rc = _rc
				noisily di in red "`funcerr'"
				capture noisily replace `YHAT' = `expr'
			}
		}
		else {
			capture nl`expr' `YHAT' `t23rhs' `wtexp' if `touse', /*
				*/ at(`parmvec') `options'
			if _rc {
				local rc = _rc
				noisily di as error "nl`expr' returned " _rc
			}
		}
		if `logtsf' {
			capture assert ln(`YHAT'-`lnlsq')!= . if `touse'
		}
		else {
			capture assert `YHAT'<. if `touse'
		}
		if _rc { 
			noi di in red /*
	*/ "starting values invalid or some RHS variables have missing values"
			exit 480
		}
/*
		If a (shifted) log transformation is used, the y-data are
		scaled by g = geom mean(y-k) to make the residual deviances
		comparable between untransformed and log transformed data.
		This is done by scaling the residual and model sums of squares
		and variances by gm2 = g^2.
*/
		if `logtsf' {
			gen double `RESID'=`YVAR'-ln(`YHAT'-`lnlsq') if `touse'
			scalar `gm2' = exp(2*`meany')
			local scaled "(scaled) "
		}
		else {
			gen double `RESID' = `YVAR'-`YHAT' if `touse'
			scalar `gm2' = 1
			local scaled ""
		}
		reg `RESID' `Z' `wtexp' if `touse', nocons
		scalar `old_ssr' = e(rss)*`gm2'
/*
		Iterative (Gauss-Newton) loop
*/
		local done 0	/* finished (cnvrgd or out of iters) */
		local its 0	/* current iteration count */
		tempname hest	/* for holding estimation results */
		tempname old_pj /* holds parm val while calc'ing derivs. */
		tempname incr	/* increment value for derivatives	 */
		local j 1
		foreach parm of local params {
			tempname op`j'
			local j = `j' + 1
		}
		while ~`done' {
			* Calc partial deriv of func w.r.t. parameters:
			if "`log'" == "" {
				noi di in gr /*
				*/ "Iteration " `its' ":  " _c
				if "`trace'"!="" { 
					noi di 
				}
			}
			local j 1
			foreach parm of local params {
							* name is `parm'
							* value is ${`param'}
				local parmcol = colnumb(`parmvec', "`parm'")
				sca `old_pj' = `parmvec'[1,`parmcol']
				if "`trace'" != "" {
					noi di in gr _col(12) "`parm' = " /*
					*/ in ye %9.0g `old_pj'
				}
				scalar `incr' = `delta'*(abs(`old_pj')+`delta')
				matrix `parmvec'[1, `parmcol'] = `old_pj'+`incr'
				if `type' < 3 {
					capture replace `YHATi' = `expr'
					if _rc {
						local rc = _rc
						noi di in red "`funcerr'"
						capture noisily replace /*
							*/ `YHATi' = `expr'
					}
				}
				else {
					capture nl`expr' `YHATi' `t23rhs' /*
						*/ `wtexp' if `touse', /*
						*/ at(`parmvec') `options'
					if _rc {
						local rc = _rc
						noisily di as error /*
						*/ "nl`expr' returned " _rc
					}
				}
				cap assert `YHATi'<. if `touse'
				if _rc { 
					noi di in red /*
					*/ "cannot calculate derivatives"
					exit 481
				}
				if `logtsf' {
					* could use dln(f(x))/dx = 
					* (1/f(x)) df(x)/dx here
					replace `J`j''=ln( /*
					*/ (`YHATi'-`lnlsq')/(`YHAT'-`lnlsq') /*
					*/  ) / `incr' if `touse'
				}
				else replace `J`j''= (`YHATi'-`YHAT')/`incr' /*
					*/ if `touse'
				* replace param j with nonincremented value
				matrix `parmvec'[1,`parmcol'] = `old_pj'
				local j = `j' + 1
			}
/*
			Update parameter estimates and test for convergence
			by max proportional iterative change in each param.
			See Gallant p 29.
*/
			reg `RESID' `Jnames' `wtexp' if `touse', nocons
			scalar `ssr' = .
			scalar `f' = 1
			while (`ssr' > `old_ssr') {	/* backup loop */
				local cnvrge 1 	/* parameter convergence flag */
				if (`f'!=1) {
					local j 1
					foreach parm of local params {
						local parmcol = /*
						 */ colnumb(`parmvec', "`parm'")
						mat `parmvec'[1,`parmcol'] = /*
							*/ `op`j''
						local j=`j'+1 
					}
				}
				local j 1
				foreach parm of local params {
					local parmcol = /*
						*/ colnumb(`parmvec', "`parm'")
					scalar `op`j''=`parmvec'[1,`parmcol']
					matrix `parmvec'[1,`parmcol'] = /*
						*/ `op`j''+`f'*_coef[`J`j'']
					if `f'*abs(_coef[`J`j'']) > /* 
					*/ `eps'*(abs(`op`j'')+`tau') {
						local cnvrge 0
					}
					local j=`j'+1
				}
				cap _estimates hold `hest'
				if `type' < 3 {
					capture replace `YHAT' = `expr'
					if _rc {
						local rc = _rc
						noi di as error "`funcerr'"
						capture noisily replace /*
							*/ `YHAT' = `expr'
						cap _estimates unhold `hest'
					}
				}
				else {
					capture nl`expr' `YHAT' `t23rhs' /*
						*/ `wtexp' if `touse', /*
						*/ at(`parmvec') `options'
					if _rc {
						local rc = _rc
						noi di as error /*
						*/ "nl`func' returned " _rc
						cap _estimates unhold `hest'
					}
				}
				cap _estimates unhold `hest'
				cap assert `YHAT'<. if `touse'
				if _rc==0 {
					if `logtsf' {
						replace `RESID' = `YVAR' - /*
							*/ log(`YHAT'-`lnlsq')/*
							*/ if `touse'
					}
					else replace `RESID' = `YVAR'-`YHAT' /*
						*/ if `touse'
					_est hold `dbeta'
					reg `RESID' `Z' `wtexp' if `touse', nocons
					scalar `ssr' = e(rss)*`gm2'
					_est unhold `dbeta'
					if "`ssr'"=="" { 
						scalar `ssr' = .  /* bug fix */
					}
				}
				scalar `f'=`f'/2
			} /* backup loop */
			if "`log'"=="" {
				if "`trace'"!="" {
					local trcol "_col(42)"
					local trnl "_n"
				}
				noi di in gr `trcol' /* 
				*/ "`scaled'residual SS = " /* 
				*/ in ye %9.0g `ssr' `trnl'
			}


			if abs(`old_ssr'-`ssr') > /*
			*/ `eps'*(`old_ssr'+`tau') {
				local cnvrge 0
			}
			scalar `old_ssr' =  `ssr'
			local done `cnvrge'
			local its = `its'+1
			if `its' >= `iterate' { 
				local done 1 
			}
		}
/*
		End of main loop.
*/

/*
		Check if sd(any derivative vector) = 0, i.e. that
		parameter is a 'regression constant'
		to reasonable accuracy.
*/
		if "`constant'" != "" {
			local const 0
		}
		else if "`hasconstant'" != "" {
			local const 1 /* Syntax parsing above ==> know true */
			local j 1
			while `j' <= `np' {
				if "`hasconstant'" == /*
					*/ "`:word `j' of `params''" {
					local consj `j'
				}
				loc j = `j'+1
			}
		}
		else {
			local const 0	/* Until we find one, assume no */
			local j 1
			local consj 0
			while `j' <= `np' {
				* name is ``j''
				* value is ${``j''}
				if "`weight'" == "pweight" {
					qui sum `J`j'' [aw`exp'] if `touse'
				}
				else {
					qui sum `J`j'' `wtexp' if `touse'
				}
				if sqrt(r(Var)) < `eps'*(abs(r(mean))+`tau') {
					local const 1
					local consj `j'
				}
				local j = `j'+1
			}
		}
/*
		Total sum of squares
*/
		if `const' == 0 {
			tempvar yvarsq
			gen double `yvarsq' = `YVAR'^2
			if "`weight'" == "pweight" {
				summ `yvarsq' [aw`exp'] if `touse'
			}
			else {
				summ `yvarsq' `wtexp' if `touse'
			}
			scalar `sstot' = r(sum)
			if "`weight'" == "iweight" {
				local dftot = round(r(sum_w))
			}
			else {
				local dftot = r(N)
			}
		}
		else {
			if "`weight'" == "pweight" {
				summ `YVAR' [aw`exp'] if `touse'
			}
			else {
				summ `YVAR' `wtexp' if `touse'
			}
			if "`weight'" == "iweight" {
				local dftot = round(r(sum_w)) - 1
			}
			else {
				local dftot = r(N) - 1
			}
			scalar `sstot' = r(Var)*`dftot'
		}
		scalar `sstot' = `sstot'*`gm2'	/* Undo lnlsq() */

/*
		Perform reg using final residuals (last ssr is still valid),
		calc ANOVA table and display results.
*/
		tempname bvec VCE
		if "`hac'" == "yes" {
			/* This is the same d.f. adjustment newey uses 	*/
			qui count if `touse'
			local dfadj = r(N) / (r(N) - `np')
			if `haclags' < 0 {
				local haclags = r(N)-2
			}
			qui glm `RESID' `Jnames' `wtexp' if `touse', 	/*
				*/ fam(gau) link(iden) noconstant	/*
				*/ vce(hac `hactype' `haclags')		/*
				*/ vfactor(`dfadj')
			matrix `VCE' = get(VCE)
		}
		local clustexp ""
		if "`cluster'" != "" {
			local clustexp "cluster(`cluster')"
		}
		qui reg `RESID' `Jnames' `wtexp' if `touse',	/*
			*/ `robust' `clustexp' `hc2' `hc3' nocons
		local dfm = e(df_m)-`const'
		matrix `bvec' = get(_b)
		if "`hac'" != "yes" {
			matrix `VCE' = get(VCE)
			if (`"`robust'`clustexp'"' != "") {
				tempname V_mb
				matrix `V_mb' = e(V_modelbased)
			}
		}

		matrix rownames `VCE' = `params'
		matrix colnames `VCE' = `params'
		matrix colnames `bvec' = `params'
		
		local k 1
		foreach parm of local params {
			local parmcol = colnumb(`parmvec', "`parm'")
			matrix `bvec'[1,`k'] = `parmvec'[1,`parmcol']
			local k=`k'+1
		}
		tempname msr
		local tdf = `dftot' - `dfm'
		scalar `msr' = `ssr' / `tdf'
		if "`cluster'" != "" {	
			local tdf = e(N_clust) - 1
			local dftot = e(N_clust)
		}
		/* Rename e(b) and e(V) -- each param an eq */
		local parnames ""
		foreach x of local params {
			local parnames `"`parnames' `x':_cons"'
		}
		if "`mse1'" != "" {
			mat `VCE' = `VCE'/`ssr'*(`dftot' - `dfm')
                        local V_mb
		}
		mat rownames `VCE' = `parnames'
		mat colnames `VCE' = `parnames'
		mat colnames `bvec' = `parnames'
		ereturn post `bvec' `VCE', /*
			*/ obs(`nobs') dof(`tdf') dep(`yname') esamp(`touse')
		
		if ("`V_mb'" != "") {
		        matrix rownames `V_mb' = `parnames'
                	matrix colnames `V_mb' = `parnames'
			ereturn matrix V_modelbased `V_mb'
		}

		ereturn scalar df_m = `dfm'
		ereturn scalar df_r = `tdf'
		ereturn scalar df_t = `dftot'
		ereturn scalar mss  = `sstot'-`ssr'
		ereturn scalar mms  = e(mss)/e(df_m)
		ereturn scalar msr  = `msr'
		ereturn scalar rmse = sqrt(e(msr))

		local sigsq = `ssr'/`nobs'	/* For likelihood, no df adj.*/
		ereturn scalar ll   = -1*`nobs'/2*ln(2*_pi) - /*
			*/ `nobs'/2*ln(`sigsq') - 1/(2*`sigsq')*`ssr'
		ereturn scalar r2   = 1-`ssr'/`sstot'
		ereturn scalar r2_a = 1-(1-e(r2))*`dftot'/e(df_r)
		ereturn scalar dev = `nobs'*(1+log(2*_pi*`ssr'/`nobs')-`mnlnwt')
	} 	/* capture */
	if _rc { 
		local rc=_rc
		capture _est unhold `dbeta'
		error `rc'
	} 
	if "`leave'"~="" {
		tokenize `params'
		local j 1
		while "``j''"~="" {
			rename `J`j'' ``j''
			local j = `j' + 1
		}
	}
	ereturn matrix init   = `initvec'
	ereturn hidden scalar converge = `cnvrge'
        ereturn scalar converged = `cnvrge'
	ereturn scalar N      =  `nobs'
	ereturn scalar rss    =   `ssr'
	ereturn scalar df_t   = `dftot'
	ereturn scalar tss    = `sstot'
	ereturn local  depvar   "`yname'"
	if "`consj'" != "" {
		ereturn scalar cj = `consj'
	}
	else {
		ereturn scalar cj = 0
	}
	ereturn local  params   "`params'"
	ereturn local  sexp "`origexp'"
	ereturn scalar gm_2   = `gm2'
	ereturn scalar delta  = `delta'
	ereturn scalar k      = `np'
	ereturn hidden scalar k_aux  = `np'	// for _coef_table
	ereturn local  options  "`options'"
	ereturn local  title    "`title'"
	ereturn local  title_2   "`title2'"
	ereturn scalar ic = `its'
	ereturn local type `type'
	local rhsvars : list variables | t23rhs
	local rhsvars : list retok rhsvars
	if `:length local rhsvars' {
		/* empty if type==1 and variables() not spec'ed*/
		ereturn local rhs "`rhsvars'"
		ereturn hidden local covariates "`rhsvars'"
	}
	else {
		ereturn hidden local covariates _NONE
	}
	if "`type'" == "3" {
		ereturn local funcprog "nl`expr'"
	}
	if "`hac'" == "yes" {
		ereturn local vce "hac"
		ereturn local vcetype "HAC"
		ereturn local hac_lag = `haclags'
		if "`hactype'" == "nwest" {
			ereturn local hac_kernel "Newey-West"
		}
		else if "`hactype'" == "gallant" {
			ereturn local hac_kernel "Gallant"
		}
		else {
			ereturn local hac_kernel "Anderson"
		}
	}
	if `"`robust'`cluster'"' != "" {
		ereturn local vcetype "Robust"
	}
	if `"`hc2'"' != "" {
		ereturn local vcetype "Robust HC2"
	}
	if `"`hc3'"' != "" {
		ereturn local vcetype "Robust HC3"
	}
	if `"`cluster'"' != "" {
		ereturn local clustvar "`cluster'"
		ereturn scalar N_clust = `dftot'
	}
	ereturn scalar log_t = `logtsf'
	if `logtsf' == 1 {
		ereturn scalar lnlsq  = `lnlsq'
	}
	if "`weight'`exp'" != "" {
		ereturn local wtype "`weight'"
		ereturn local wexp  "`exp'"
	}
	_post_vce_rank
	ereturn local vce "`vce2'"
	ereturn scalar k_eq_model = 0	/* do not do model test */
	ereturn local marginsok default Yhat
	ereturn local marginsnotok SCores Residuals
	ereturn hidden local marginsprop noeb minus
	ereturn local predict nl_p
	ereturn local cmd "nl"		/* must be last	*/

	NLout, level(`level') `diopts'
end

program Header2
	args hac hactype haclags
	di
	di in gr "Nonlinear regression" _c
	di in gr _col(53) "Number of obs = " in ye %10.0fc e(N) 
	if `"`hac'"' == "yes" {
		di "HAC kernel (lags): `hactype' (`haclags')" _c
	}
	di in gr _col(53) "R-squared     = " in ye %10.4f e(r2)
	di in gr _col(53) "Adj R-squared = " in ye %10.4f e(r2_a)
	di in gr _col(53) "Root MSE      =  " in ye %9.0g e(rmse)
	di in gr _col(53) "Res. dev.     =  " in ye %9.0g e(dev)
end

program Header
	#delimit ;
	di;
	di in gr "      Source {c |}      SS            df       MS";
	di in gr "{hline 13}{c +}{hline 34}" _c;
	di in gr _col(53) "Number of obs = " in ye %10.0fc e(N) ;
	di in gr "       Model {c |} " in ye %10.0g e(mss) 
		" " %10.0f e(df_m) " " %11.0g e(mms) _c;
	di in gr _col(53) "R-squared     = " in ye %10.4f e(r2);
	di in gr "    Residual {c |} " in ye %10.0g e(rss) " " 
		%10.0f e(df_r) " " %11.0g e(msr) _c;
	di in gr _col(53) "Adj R-squared = " in ye %10.4f e(r2_a) ;
	di in gr "{hline 13}{c +}{hline 34}" _c;
	di in gr _col(53) "Root MSE      =  " in ye %9.0g e(rmse) ;
	di in gr "       Total {c |} " in ye %10.0g e(tss) 
		" " %10.0f e(df_t) " " %11.0g e(tss)/e(df_t) _c;
	di in gr _col(53) "Res. dev.     =  " in ye %9.0g e(dev) ;
	#delimit cr
end

program define NLout
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	local robust
	local hac
	local bs
	if bsubstr("`e(vcetype)'", 1, 6) == "Robust" {
		local robust "yes"
	}
	if `"`e(vcetype)'"' == "HAC" {
		local hac "yes"
		local hactype `e(hac_kernel)'
		local haclags `e(hac_lag)'
	}
	if inlist(`"`e(prefix)'"',"bootstrap","jackknife") {
		local bs "yes"
	}
	di
	if `"`robust'"' != "" | `"`hac'"' == "yes" | `"`bs'"' == "yes" {
		Header2 `hac' `hactype' `haclags'
	}
	else {
		Header
	}
/*
	Display coefficients, standard errors and ci's
*/

	di
	if "`e(title)'" != "" {
		di in gr "`e(title)'" 
	}
	if "`e(title_2)'" != "" { 
		di "`e(title_2)'"
	}
	_coef_table, level(`level') `diopts'

	if e(cj) ~= 0 {
		local word : word `e(cj)' of `e(params)'
		di in gr "  Parameter `word' taken as constant term in model" _c
	 	if "`robust'`hac'`bs'" == "" {
	 		di in gr " & ANOVA table"
		}
		else {
			di
		}
	}
	if e(converge) ~= 1 {
		error 430
	}
end

program define CheckVCE, sclass

	args input
	
	tokenize `input'
	
	if `"`4'"' != "" {
		di as error "option vce() incorrectly specified"
		exit 198
	}
	
	if `"`1'"' != "hac" {
		di as error "unrecognized VCE type in vce() option"
		exit 198
	}

	local typelen = length(`"`2'"')
	if `"`2'"' == bsubstr("nwest", 1, max(2, `typelen')) {
		local hactype "nwest"
	}
	else if `"`2'"' == bsubstr("gallant", 1, max(2, `typelen')) {
		local hactype "gallant"
	}
	else if `"`2'"' == bsubstr("anderson", 1, max(2, `typelen')) {
		local hactype "anderson"
	}
	else {
		di as error "unrecognized HAC kernel in vce() option"
		exit 198
	}
	
	local lag = real(`"`3'"')
	if (`lag' < 1 | mi(`lag')) & `"`3'"' != "" {
		di as error "incorrect lag specification in vce() option"
		exit 198
	}
	if `"`3'"' == "" {
		local lag = -1
	}
	
	sret local hactype `hactype'
	sret local lags = `lag'
	
end
