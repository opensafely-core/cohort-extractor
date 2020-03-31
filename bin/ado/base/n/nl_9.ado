*! version 2.1.9  24mar2015
program define nl_9, eclass byable(recall) sortpreserve
	version 9, missing
	local myopts "Level(cilevel)"
	if "`1'"=="" | bsubstr("`1'",1,1)=="," { 
		if "`e(cmd)'"!="nl" { 
			error 301 
		} 
		if _by() { 
			error 190 
		}
		syntax [, `myopts']
		NLout `level'
		exit
	}

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
			syntax varlist(min=1) [if] [in] [aw fw iw] , 	/*
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
	syntax [if] [in] [aw fw iw] [, /*
		*/ DELta(real 4e-7) EPS(real 0) INitial(string)		/*
		*/ ITERate(integer 0) LEAve LNlsq(real 1e20) noLOg 	/*
		*/ TITLE(string) TITLE2(string) TRace 			/*
		*/ Hasconstant(string) noConstant			/*
		*/ VAriables(varlist numeric) Robust			/*
		*/ CLuster(varname) hc2 hc3 `myopts' * ]
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
	else {
		tokenize `vars'
		local yname `1'
		mac shift
		local t3rhs `*'
	}
	
	tempname parmvec mnlnwt sumwt meany vary gm2 old_ssr ssr f sstot 
	confirm numeric variable `yname'

	ereturn local cmd
	ereturn local depvar `"`yname'"'
	ereturn local wtype `"`weight'"'
	ereturn local wexp `"`exp'"'

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
			capture nl`expr' `t3rhs' `wtexp' if `touse', /*
				*/ `options' at(`parmvec')
		}
		else {
			capture nl`expr' `junk' `t3rhs' `wtexp' if `touse', /*
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
		tempvar s
		gen double `s' `exp' if `touse'
		sum `s' `wtexp' if `touse', meanonly 
		if "`weight'" != "iweight" {
			noi di in gr "(sum of wgt is " r(N)*r(mean) ")"
		}
		replace `s' = ln(`s'/r(mean))
		sum `s' `wtexp' if `touse', meanonly
		scalar `mnlnwt' = r(mean)
		drop `s'
	}
	else {
		qui count if `touse'
		di in gr "(obs = " r(N) ")"
	}
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
	qui sum `YVAR' `wtexp' if `touse'
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
			capture nl`expr' `YHAT' `t3rhs' `wtexp' if `touse', /*
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
					capture nl`expr' `YHATi' `t3rhs' /*
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
					capture nl`expr' `YHAT' `t3rhs' /*
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
				*/ in ye %9.0g `old_ssr' `trnl'
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
				qui sum `J`j'' if `touse'
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
			summ `yvarsq' `wtexp' if `touse'
			scalar `sstot' = r(sum)
			if "`weight'" == "iweight" {
				local dftot = r(sum_w)
			}
			else {
				local dftot = r(N)
			}
		}
		else {
			summ `YVAR' `wtexp' if `touse'
			if "`weight'" == "iweight" {
				local dftot = r(sum_w) - 1
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
		qui reg `RESID' `Jnames' `wtexp' if `touse',	/*
			*/ `robust' cluster(`cluster') `hc2' `hc3' nocons
		local dfm = e(df_m)-`const'
		tempname bvec VCE
		matrix `bvec' = get(_b)
		matrix `VCE' = get(VCE)
* matrix `VCE' = (e(df_r) / (e(df_r)+1)) * `VCE'

		matrix rownames `VCE' = `params'
		matrix colnames `VCE' = `params'
		matrix colnames `bvec' = `params'
		tempname Fstat
		if "`robust'`cluster'`hc2'`hc3'" != "" {
			/* Do a robust Wald test.  The prev. reg gave us
			   the cov matrix, and the estimated betas from
			   that reg are (virtually) zero.  Thus, we can
			   test if those reg coeffs. equal the NL betas */
			local j 1
			while `j' <= `np' {   
				if `j' != `consj' {
					loc jn : word `j' of `Jnames'
					local parn : word `j' of `params'
					local parmcol = /*
						*/ colnumb(`parmvec',"`parn'")
					qui test `jn' = /*
						*/ `=`parmvec'[1, `parmcol']',/*
						*/ not accum
				}
				local j = `j'+1
			}
			test
			sca `Fstat' = r(F)
		}
		else {
			sca `Fstat' = ( (`sstot'-`ssr') / `dfm' ) / /*
				*/    ( `ssr' / (`dftot' - `dfm') )
		}
		
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
		ereturn post `bvec' `VCE', /*
			*/ obs(`nobs') dof(`tdf') dep(`yname') esamp(`touse')
		

		ereturn scalar df_m = `dfm'
		ereturn scalar df_r = `tdf'
		ereturn scalar df_t = `dftot'
		ereturn scalar mss  = `sstot'-`ssr'
		ereturn scalar mms  = e(mss)/e(df_m)
		ereturn scalar msr  = `msr'
		ereturn scalar rmse = sqrt(e(msr))
		ereturn scalar F    = `Fstat'
		ereturn scalar r2   = 1-`ssr'/`sstot'
		ereturn scalar r2_a = 1-(1-e(r2))*`dftot'/e(df_r)
/*
		calc -2(log likelihood) allowing for possible transformation
		(formula may need rechecking, esp when weights present)
*/
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
	ereturn scalar converge = `cnvrge'
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
	ereturn scalar k      = `np'
	ereturn local  options  "`options'"
	ereturn local  title    "`title'"
	ereturn local  title_2   "`title2'"
	ereturn scalar ic = `its'
	ereturn local type `type'
	if "`type'" == "3" {
		ereturn local rhs "`t3rhs'"
		ereturn local funcprog "nl`expr'"
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
	ereturn local predict nl_9_p
	ereturn local cmd "nl"		/* must be last	*/

	NLout `level'
end

program define NLout

	args level

	local robust
	local cluster
	if bsubstr("`e(vcetype)'", 1, 6) == "Robust" {
		local robust "robust"
	}
	if "`e(clustvar)'" != "" {
		local cluster "cluster"
	}
	#delimit ;
	di ;
	if `"`robust'"' != "" | `"`cluster'"' != "" {;
		di in gr "Nonlinear regression with robust standard errors" _c;
	};
	else {;
		di in gr "      Source {c |}       SS       df       MS" _c;
	};
	di in gr _col(54) "Number of obs = " in ye %9.0f e(N) ;
	if `"`robust'"' == "" & `"`cluster'"' == "" {;
		di in gr "{hline 13}{c +}{hline 30}" _c;
	};
	di in gr _col(54) "F(" %3.0f e(df_m) "," %6.0f e(df_r) 
		") = " in ye %9.2f e(F) ;
	if `"`robust'"' == "" & `"`cluster'"' == "" {;
		di in gr "       Model {c |} " in ye %11.0g e(mss) 
			" " %5.0f e(df_m) " " %11.0g e(mms) _c;
	};
	di in gr _col(54) "Prob > F      = " 
		in ye %9.4f Ftail(e(df_m),e(df_r),e(F)) ;
	if `"`robust'"' == "" & `"`cluster'"' == "" {;
		di in gr "    Residual {c |} " in ye %11.0g e(rss) " " 
			%5.0f e(df_r) " " %11.0g e(msr) _c;
	};
	di in gr _col(54) "R-squared     = " in ye %9.4f e(r2)    ;
	if `"`robust'"' == "" & `"`cluster'"' == "" {;
		di in gr "{hline 13}{c +}{hline 30}" _c;
		di in gr _col(54) "Adj R-squared = " in ye %9.4f e(r2_a) ;
	};
	if `"`robust'"' == "" & `"`cluster'"' == "" {;
		di in gr "       Total {c |} " in ye %11.0g e(tss) 
			" " %5.0f e(df_t) " " %11.0g e(tss)/e(df_t) _c;
	};
	di in gr _col(54) "Root MSE      = " in ye %9.0g e(rmse) ;
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
	ereturn di, level(`level')

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
