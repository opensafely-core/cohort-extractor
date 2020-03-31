*! version 1.5.4  29jan2015
program define nl_7, eclass byable(recall) sort
	version 7, missing
	local options "Level(cilevel)"
	if "`1'"=="" | bsubstr("`1'",1,1)=="," { 
		if "`e(cmd)'"!="nl" { error 301 } 
		if _by() { error 190 }
		syntax [, `options']
		NLout `level'
		exit
	}
	gettoken func 0 : 0
	syntax varlist [if] [in] [aw fw] [, /*
		*/ DELta(real 4e-7) EPS(real 0) Init(string) 		/*
		*/ ITerate(integer 0) LEAve LNlsq(real 1e20) noLOg 	/*
		*/ TRace noDisp `options' robust cluster(varname) hc2 hc3 * ]

	/* In case someone with version 9 calls me with robust VCE, get out */
	if "`robust'" != "" {
		di as txt "robust " as error "not allowed"
		exit 198
	}
	if "`cluster'" != "" {
		di as txt "cluster() " as error "not allowed"
		exit 198
	}
	if "`hc2'" != "" {
		di as txt "hc2 " as error "not allowed"
		exit 198
	}
	if "`hc3'" != "" {
		di as txt "hc3 " as error "not allowed"
		exit 198
	}
	
	tokenize `varlist'
	local yname "`1'"
	mac shift 
	local fargs "`*'"

	marksample touse

	local version : di "version " string(_caller()) ", missing:"

	tempname mnlnwt sumwt meany vary gm2 old_ssr ssr f sstot 

/*
	Obtain information on parameters (returned in S_1)
*/

	/* Following is for version control */
	if "`func'" == "exp2" | "`func'" == "exp2a" | "`func'" == "exp3" | /*
		*/ "`func'" == "log4" | "`func'" == "log3" | /*
		*/ "`func'" == "gom4" | "`func'" == "gom3" {
		local func "`func'_7"
	}

	* The following is a phony set up of an estimation result for 
	* nl`func' on the query call:
	tempvar cpy
	tempname b v 
	mat `b' = (1)
	mat `v' = (0)
	mat rownames `v' = c1
	qui gen byte `cpy' = `touse'
	est post `b' `v', esample(`cpy')

	est local cmd
	est local depvar `"`yname'"'
	est local wtype `"`weight'"'
	est local wexp `"`exp'"'

	/* Double saves in case nl`func' is version 5 */
	global S_E_cmd
	global S_E_depv "`e(depvar)'"
	global S_E_if "if `touse'"
	global S_E_wgt "`e(wtype)'"
	global S_E_exp "`e(wexp)'"


	/* where nl`func' returns its results after query */
	global S_1 /* parameters */
	global S_2 /* title */
	global S_3 /* title 2 */

	/* call nl`func' */
	if _caller() < 7 { 
		local iffor6 "if `touse'"
	}
	capture noi qui `version' nl`func' ? `fargs' `iffor6' , `options'
	local iffor6
	local rc = _rc
	est clear
	if `rc' { 
		di in red "nl`func' refused query, rc=" `rc'
		exit `rc'
	}
	if "$S_2"=="" { 
		local title "(`func')"
	}
	else	local title "$S_2"
	local title2 "$S_3"
	local params "$S_1"

	local np : word count `params'
	if `np' == 0 { 
		di in red "no parameters returned by nl`func'"
		exit 198
	}

	if "`leave'" ~= "" { /* confirm `params' are not currently variables */
		confirm new var `params'
	}

/*
	Parse the init() option
*/
	if "`init'"!="" {
		tokenize `"`init'"', parse(" =,")
		while "`1'"!="" { 
			if "`1'" == "," { mac shift }
			capture confirm number `3'
			if _rc | ("`2'" != "=") {
				di in red "option init() invalid"
				exit 198
			}
			global `1' `3'
			mac shift 3
		}
	}

/*
	setup so that `1', `2', ..., contain the names of the parameters
*/
	tokenize `"`params'"'

/*
		`func' holds the name of the user program that calculates the
		non-linear function value, returning it in argument 1 (S_1).
		A non-zero return code from `func' is trapped, causing nl
		to abort with that return code.

		But nl can be made to exit more gracefully.  If the global 
		macro T_nlferr is specified, then an error in nl\`func' will
		display the message contained in T_nlferr and exit with 498.
		
*/
	local funcerr "error #\`rc' occurred in program nl\`func'"
/*
		If lnlsq(k) is specified y and yhat are effectively (though
		not computationally) transformed to g*ln(y-k) and g*ln(yhat-k)
		where g = geometric_mean(y-k).
*/
	local logtsf 0
	if `lnlsq' < .999e20 { local logtsf 1 }
/*
		iterate is the max iterations allowed.
		eps and tau control parameter convergence, see Gallant p 28.
		delta is a proportional increment for calculating derivatives,
		appropriately modified for very small parameter values.
*/
	local iterate = cond(`iterate'<=0, 10000, `iterate')
	local eps = cond(`eps'<=0, 1e-5, `eps')
	local tau 1e-3

/*
		Set up y-variate (YVAR)
*/
	tempvar YVAR Z tmp dbeta 	/* dbeta for est hold */
	qui gen double `Z' = 0 		/* vlw, double */

/*
	YVAR will contain missing for all unused observations (as will touse)
*/
	qui gen double `YVAR' = `yname' if `touse'

	scalar `mnlnwt' = 0 /* mean log normalized weights */
	qui if `"`exp'"' != "" { 
		tempvar s
		gen double `s' `exp' if `touse'		/* vlw, double */
		sum `s', meanonly 
		noi di in gr "(sum of wgt is " r(N)*r(mean) ")"
		replace `s' = ln(`s'/r(mean))
		sum `s', meanonly
		scalar `mnlnwt' = r(mean)
		drop `s'
		local exp "[`weight'`exp']"
	}
	else {
		qui count if `touse'
		di in gr "(obs = " r(N) ")"
	}
	if "`log'"=="" { di }

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
	qui sum `YVAR' `exp' if `touse'
	if r(min) == r(max) {
		di in red "`yname' has zero variance"
		exit 498
	}
	local nobs = round(r(N),1)
	scalar `sumwt' = r(sum_w)
	scalar `meany' = r(mean)
	scalar `vary' = r(Var)
/*
		Initialisations.

		Set up derivative vectors.
*/
	capture noi qui {		/* to handle dropping derivs	*/
		local j 1
		while `j' <= `np' {
			* name is ``j''
			tempvar J`j'
			local Jnames "`Jnames' `J`j''"
			gen double `J`j'' = . 
			local j = `j'+1
		}
		tempvar RESID YHAT YHATi
		gen double `YHAT' = .
		gen double `YHATi' = .
		capture noi qui `version' nl`func' `YHAT' `fargs' , `options'
		if _rc {
			local rc = _rc
			if "$T_nlferr" != "" {
				noi di
				noi di in red "$T_nlferr"
				exit 498
			}
			else {
				noisily di in red "`funcerr'"
			}	
			exit 196
		}
		capture assert `YHAT'<. if `touse'
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
		reg `RESID' `Z' `exp' if `touse', nocons
		scalar `old_ssr' = e(rss)*`gm2'
/*
		Iterative (Gauss-Newton) loop
			old_pj left as local since globals used for betas
*/
		local done 0	/* finished (cnvrgd or out of iters) */
		local its 0	/* current iteration count */
		tempname hest	/* for holding estimation results */
		while ~`done' {
			* Calc partial deriv of func w.r.t. parameters:
			if "`log'" == "" {
				noi di in gr /*
				*/ "Iteration " `its' ":" _c
				if "`trace'"!="" { noi di }
			}
			local j 1
			while `j' <= `np' {
				* name is ``j''
				* value is ${``j''}
				local old_pj = ${``j''}
				if "`trace'" != "" {
					noi di in gr _col(12) "``j'' = " /*
					*/ in ye %9.0g `old_pj'
				}
				local incr = `delta'*(abs(`old_pj')+`delta')
				global ``j'' = `old_pj'+`incr'
				cap `version' nl`func' `YHATi' `fargs' , /*
					*/ `options'
				if _rc {
					local rc = _rc
					if "$T_nlferr" != "" {
						noi di
						noi di in red "$T_nlferr"
						exit 498
					}
					else {
						noi di in red "`funcerr'"
					}	
					exit 196
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
				global ``j'' = `old_pj'
				local j = `j'+1
			}
/*
			Update parameter estimates and test for convergence
			by max proportional iterative change in each param.
			See Gallant p 29.
*/
			reg `RESID' `Jnames' `exp' if `touse', nocons
			scalar `ssr' = .
			scalar `f' = 1
			* name is ``j''
			* parameter value is ${``j''}
			while (`ssr' > `old_ssr') {	/* backup loop */
				local cnvrge 1 	/* parameter convergence flag */
				if (`f'!=1) {
					local j 1 
					while `j' <= `np' {
						global ``j'' `op`j''
						local j=`j'+1 
					}
				}
				local j 1
				while `j' <= `np' {
					local op`j' ${``j''}
					global ``j'' = `op`j''+`f'*_coef[`J`j'']
					if `f'*abs(_coef[`J`j'']) > /* 
					*/ `eps'*(abs(`op`j'')+`tau') {
						local cnvrge 0
					}
					local j=`j'+1
				}
				cap estimates hold `hest'
				cap `version' nl`func' `YHAT' `fargs' , /*
					*/ `options'
				if _rc {
					local rc = _rc
					if "$T_nlferr" != "" {
						noi di
						noi di in red "$T_nlferr"
						exit 498
					}
					else {
						noi di in red "`funcerr'"
					}	
					cap estimates unhold `hest'
					exit `rc'
				}
				cap estimates unhold `hest'
				cap assert `YHAT'<. if `touse'
				if _rc==0 {
					if `logtsf' {
						replace `RESID' = `YVAR' - /*
							*/ log(`YHAT'-`lnlsq')/*
							*/ if `touse'
					}
					else replace `RESID' = `YVAR'-`YHAT' /*
						*/ if `touse'
					est hold `dbeta'
					reg `RESID' `Z' `exp' if `touse', nocons
					scalar `ssr' = e(rss)*`gm2'
					est unhold `dbeta'
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
				noi di in gr _col(16) `trcol' /* 
				*/ "`scaled'residual SS = " /* 
				*/ in ye %9.0g `old_ssr' `trnl'
			}


			if abs(`old_ssr'-`ssr') > /*
			*/ `eps'*(`old_ssr'+`tau') {
				local cnvrge 0
			}
			scalar `old_ssr' =  `ssr'
			local done `cnvrge'
			local its = `its'+1
			if `its' >= `iterate' { local done 1 }
		}
/*
		End of main loop.
		Check if sd(any derivative vector) = 0, i.e. that
		that parameter is a 'regression constant'
		to reasonable accuracy.
*/
		local j 1
		local const 0
		local consj 0
		while `j' <= `np' {
			* name is ``j''
			* value is ${``j''}
			qui sum `J`j''
			if sqrt(r(Var)) < `eps'*(abs(r(mean))+`tau') {
				local const 1
				local consj `j'
			}
			local j = `j'+1
		}
/*
		If the non-linear model appears to have no constant,
		regress y on 0 thru the origin to calc its
		(uncorrected) SS as the residual SS, otherwise use
		the usual corrected SS.
*/
		if `const' == 0 {
			reg `YVAR' `Z' `exp' if `touse', nocons
			local dftot = `nobs'
			scalar `sstot' = e(rss)*`gm2'
		}
		else {
			local dftot = `nobs'-1
			scalar `sstot' = `dftot'*`vary'*`gm2'
		}
/*
		Perform reg using final residuals (last ssr is still valid),
		calc ANOVA table and display results.
*/
		qui reg `RESID' `Jnames' `exp' if `touse', nocons
		local dfm = e(df_m)-`const'
		tempname bvec VCE
		mat `bvec' = get(_b)
		mat `VCE' = get(VCE)
* mat `VCE' = (e(df_r) / (e(df_r)+1)) * `VCE'

		mat rownames `VCE' = `params'
		mat colnames `VCE' = `params'
		mat colnames `bvec' = `params'
		local k 1
		while `k'<=`np' { 
			mat `bvec'[1,`k'] = ${``k''}
			local k=`k'+1
		}
		local tdf = `dftot' - `dfm'
		est post `bvec' `VCE', /*
			*/ obs(`nobs') dof(`tdf') dep(`yname') esamp(`touse')
		

		est scalar df_m = `dfm'
		est scalar df_r = `tdf'
		est scalar df_t = `dftot'
		est scalar mss  = `sstot'-`ssr'
		est scalar mms  = e(mss)/e(df_m)
		est scalar msr  = `ssr'/e(df_r)
		est scalar rmse = sqrt(e(msr))
		est scalar F    = e(mms)/e(msr)
		est scalar r2   = 1-`ssr'/`sstot'
		est scalar r2_a = 1-(1-e(r2))*`dftot'/e(df_r)
/*
		calc -2(log likelihood) allowing for possible transformation
		(formula may need rechecking, esp when weights present)
*/
		est scalar dev = `nobs'*(1+log(2*_pi*`ssr'/`nobs')-`mnlnwt')


		/* Double saves */
		global S_E_dfm  "`e(df_m)'"
		global S_E_dfr  "`e(df_r)'"	/* Royston original */
		global S_E_tdf  "`e(df_r)'" /* new standard */
		global S_E_ssm  "`e(mss)'"
		global S_E_msm  "`e(mms)'"
		global S_E_msr  "`e(msr)'"
		global S_E_sdr  "`e(rmse)'" 
		global S_E_f    "`e(F)'" 
		global S_E_rsq  "`e(rsq)'" 
		global S_E_rsqa "`e(rsqa)'" 
		global S_E_devi "`e(dev)'"
	} 	/* capture */
	if _rc { 
		local rc=_rc
		capture est unhold `dbeta'
		exit `rc'
	} 

	if "`leave'"~="" {
		local j 1
		while "``j''"~="" {
			rename `J`j'' ``j''
			local j = `j' + 1
		}
	}

	est scalar converge = `cnvrge'
	est scalar N      =  `nobs'
	est scalar rss    =   `ssr'
	est scalar df_t   = `dftot'
	est scalar tss    = `sstot'
	est local  depvar   "`yname'"
	est scalar  cj     = `consj'
	est local  params   "`params'"
	est local  function "`func'"
	est local  version  "`version'"
	est scalar gm_2   = `gm2'
	est scalar k      = `np'
	est local  f_args   "`fargs'"
	est local  options  "`options'"
	est local  title    "`title'"
	est local  title_2  "`title2'"
	est scalar log_t   = `logtsf'
	est scalar lnlsq  = `lnlsq'
	est scalar ic = `its'-1
	est local predict nl_p_7
	est local cmd       "nl"		/* must be last	*/

	/* Double saves */
	global S_E_cnvr "`e(converge)'"
	global S_E_nobs "`e(N)'"
	global S_E_ssr  "`e(rss)'"
	global S_E_dft  "`e(df_t)'"
	global S_E_sst  "`e(tss)'"
	global S_E_depv "`e(depvar)'"
	global S_E_cj   "`e(cj)'"
	global S_E_rhs  "`e(params)'"
	global S_E_fcn  "`e(function)'"
	global S_E_np   "`e(k)'"
	global S_E_fvl  "`e(f_args)'"
	global S_E_fops "`e(options)'"
	global S_E_ttl  "`e(title)'"
	global S_E_ttl2 "`e(title_2)'"
	global S_E_lts  "`e(log_t)'"
	global S_E_lnl2 "`e(lnlsq)'"
	global S_E_gm2  "`e(gm_2)'"
	global S_E_cmd  "`e(cmd)'"		/* must be last	*/

	if "`disp'" == "" {
		NLout `level'
	}	
end


program define NLout
	args level

	global S_1 e(N)		/* Number of observations */
	global S_2 e(mss)	/* model sum of squares */
	global S_3 e(df_m) 	/* model degrees of freedom */
	global S_4 e(rss)   	/* residual sum of squares */
	global S_5 e(df_r) 	/* residual degrees of freedom */
	global S_6 e(F) 	/* model F-statistic */
	global S_7 e(r2)    	/* R-square */
	global S_8 e(r2_a) 	/* adjusted R-square */
	global S_9 e(rmse)  	/* residual root mean square */
	global S_10 e(dev)	/* residual deviance (-2 * log likelihood) */
	global S_11 e(gm_2)   	/* geom mean (y-k)]^2 if lnlsq(k), else 1 */
	global S_12 e(converge)	/* 0 if convergence failed, 1 otherwise */

	#delimit ;
	di in gr _n "      Source {c |}       SS       df       MS" 
		_col(54) "Number of obs = " in ye %9.0f e(N) ;
	di in gr "{hline 13}{c +}{hline 30}"
		 in gr _col(54) "F(" %3.0f e(df_m) "," %6.0f e(df_r) 
		") = " in ye %9.2f e(F) ;
	di in gr "       Model {c |} " in ye %11.0g e(mss) " " %5.0f e(df_m) 
		" " %11.0g e(mms)  
		in gr _col(54) "Prob > F      = " 
		in ye %9.4f Ftail(e(df_m),e(df_r),e(F)) ;
	di in gr "    Residual {c |} " in ye %11.0g e(rss) " " %5.0f e(df_r) 
		" " %11.0g e(msr)
		 in gr _col(54) "R-squared     = " in ye %9.4f e(r2)    ;

	di in gr "{hline 13}{c +}{hline 30}"
		 in gr _col(54) "Adj R-squared = " in ye %9.4f e(r2_a) ;

	di in gr "       Total {c |} " in ye %11.0g e(tss) " " %5.0f e(df_t)
		" " %11.0g e(tss)/e(df_t)
		in gr _col(54) "Root MSE      = " 
		in ye %9.0g e(rmse) ;
	di in gr _col(54) "Res. dev.     = " in ye %9.0g e(dev) ;
		#delimit cr
/*
	Display coefficients, standard errors and ci's
*/
	tempname invt
	scalar `invt' = invttail(e(df_r), (1-`level'/100)/2) 

	di in gr "`e(title)'" 
	if "`e(title_2)'" != "" { 
		di "`e(title_2)'"
	}
	est di, level(`level')

	if e(cj) ~= 0 {
		local word : word `e(cj)' of `e(params)'
		di in gr /*
	*/ "* Parameter `word' taken as constant term in model & ANOVA table"
		}
	di in gr /*
*/ " (SEs, P values, CIs, and correlations are asymptotic approximations)"
	if e(converge) ~= 1 {
		error 430
	}
end
