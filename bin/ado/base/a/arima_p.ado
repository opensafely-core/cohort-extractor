*! version 6.1.7  11apr2019
program define arima_p, properties(notxb)
	version 6, missing

	if "`e(cond)'" != "" {
		qui tsset
		if "`r(panelvar)'" != "" {
			arch_p `0'
			exit
		}
	}

	local str_it 1000	/* iters to get structural mse */

		/*  Note, offset not allowed by arima, do not use this ado as 
		 *  the basis for a predict that requires noOFFset.
		 */

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat 
				Residuals RSTAndard RSTUdent
				STDF STDP STDR noOFFset
			SE:
				Index XB STDP noOFFset
		*/

	local myopts XB Y MSE Residuals Structural Dynamic(string) /*
		*/ T0(string) YResiduals


		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
			/* takes advantage that -myopts- produces error
			 * if -eq()- specified w/ other that xb and stdp */

	/* If there is no conditional mean equation, can't get stdp */

	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' ]

	if "`stdp'" == "stdp" & e(k1) == 0 {
		di in smcl as error /*
*/ "cannot predict standard error of prediction without "
		di in smcl as error /*
*/ "regressors or a constant term in mean equation"
		exit 498
	}

		/* Step 4:
			Concatenate switch options together
		*/

	local type  `xb'`y'`mse'`residuals'`yresiduals'
	local args 


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/


		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse

			/* Set up one-step and dynamic samples */

	_ts timevar panvar if `touse', sort onepanel
	qui tsset, noquery
	local tfmt `r(tsfmt)'
	markout `touse' `timevar' `panvar'
	tempname touseS touseD
	gen byte `touseS' = `touse'
	gen byte `touseD' = 0
	if "`t0'" != "" { 
		qui replace `touseS' = 0 if `timevar' < `t0' 
		local t0opt "t0(`t0')"
	}
	if "`dynamic'" != "" { 
		if missing(`dynamic') {
			/* 
			   Let j = max(ar lags) + max(ma lags).
			   
			   Start dyn j periods after the start of the
			   estimation sample, which would be at date
			   (minperiod + j) if we observed every date.
			
			   To control for the 'delta' of the time variable,
			   we need to go to (minperiod + d*j), where d
			   is the delta.
			   
			   Use scalars, not locals, in case user has millisecond
			   data and need to store time in more precision than
			   locals provide.
			*/
				
			tempname tsdelta dynamic
			scal `dynamic' = cond(`e(ar_max)'<., `e(ar_max)', 0) ///
				+ cond(`e(ma_max)'<., `e(ma_max)', 0)
			sca `tsdelta' = `:char _dta[_TSdelta]'
			sca `dynamic' = `e(tmin)' + `tsdelta'*`dynamic'
di as text "Note: beginning dynamic predictions in period " `tfmt' `dynamic' "."
		}
		qui replace `touseD' = `touseS' & `timevar' >= `dynamic' 
		local dynopt "dyn(`dynamic')"
	}

			/* special priming for , mse structural */


		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/



		/*  Step 7-kalman.
			arima/Kalman special processing.  Really computes
			all the predicted values and we just pull off
			the one wanted in step 8
		*/
		 

			/* process the Beta matrix */
	tempname b
	mat `b' = e(b)
	mat coleq `b' = `e(eqnames)'

			/* all that is needed to implement structural */
	if "`structural'" != "" {
		if "`e(ar)'`e(ma)'" != "" {
			if "`type'" == "mse" {
				local prime "primeiter(`str_it')"
				local dynamic "dynamic"
				qui replace `touseD' = 1 if `touseS'
			}
			else {
				mat `b'[1, e(k1)+1] =  /*
					*/ 0 * `b'[1, e(k1)+1..colsof(`b')-1]
			}
		}
	}

			/* set up for Kalman */

	
	tempname sigma2 F v1 Q Ap H XI R w P Qvec Pvec sumRho
	tempvar y_pred y_mse llvar depvar
	qui gen double `depvar' = `e(depvar)'		/* expand ops */
	qui gen double `y_pred' = . in 1
	qui gen double `y_mse' = . in 1
	qui gen double `llvar' = . in 1

	if index("`e(depvar)'", ".") {
		local dep `e(depvar)'
		gettoken op name : dep, parse(".")
		local name : subinstr local name "." ""
		global Tdepvar `name'
	}
	else	global Tdepvar `e(depvar)'
	
	global Tseasons `e(seasons)'

	if "`e(cond)'" == "" {
		scalar `sigma2' = `b'[1, colsof(`b')]^2
	}
	else	scalar `sigma2' = `b'[1, colsof(`b')]
	
	kalarma1 `F' `v1' `Q' `Ap' `H' `XI' `R' `w' : `b' `sigma2'

	if "`e(Xi0)'" != "" { mat `XI' = e(Xi0) }
	if "`e(P0)'" == "" {
		mat `sumRho' = `F'[1,1...] * J(colsof(`F'), 1, 1)
		local m = rowsof(`F')
		_mvec `Qvec' : `Q'
		mat `Pvec' = inv( I(`m'^2) - `F' # `F' ) * `Qvec'
		_mfrmvec `P' : `Pvec' , rows(`m')
	}
	else	mat `P' = e(P0)



			/* Kalman filtering */
	// Create temporary time variable with delta=1; _kalman needs this
	if `=`: char _dta[_TSdelta]'' != 1 {
		qui tsset, noquery
		local tsspanv  `r(panelvar)'
		local tssvar   `r(timevar)'
		local tssdelt  `r(tdelta)'
		local tssfmt   `r(tsfmt)'

		tempvar normt
		summ `tssvar', mean
		gen double `normt' = (`tssvar' - r(min)) / `tssdelt'
		qui tsset `tsspanv' `normt', noquery
	}
	
	_kalman1 `y_pred' `y_mse' `llvar' : `depvar'	 	    /*
		*/ `F' `v1' `Q' `Ap' `H' `XI' `w' `R' `P'  /*
		*/ if `touseS' & !`touseD' , p0 

	if "`dynamic'" != "" {
		tempvar y_predd			      /* to handle l#.y rhs */
		qui gen double `y_predd' = `e(depvar)'
		op_colnm `Ap' `e(depvar)' `y_predd'
		_kalman1 `y_predd' `y_mse' `llvar' : `depvar'		/*
			*/ `F' `v1' `Q' `Ap' `H' `XI' `w' `R' `P'	/*
			*/ if `touseD', stateonly `prime'
		qui replace `y_pred' = `y_predd' if `touseD'
	}

	// Restore user's -tsset-tings
	if `"`tssdelta'"' != "" {
		qui tsset `tsspanv' `tssvar', delta(`tssdelt') ///
			format(`tssfmt') noquery
	}

			/* predicted variable labeling */

	if "`structural'" != "" { local postlab `structural' }
	if "`dynamic'" != "" { 
		local postlab = ltrim(`"`postlab' `dynopt'"')
	}
	else	local postlab = ltrim("`postlab' one-step")
	if "`t0'" != "" { local postlab = ltrim("`postlab' t0(`t0')") }

		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	if "`type'" == "xb" | "`type'" == "" {
		if "`type'" == "" {
			version 8: ///
			di "{txt}(option {bf:xb} assumed; predicted values)"
		}
		gen `vtyp' `varn' = `y_pred'
		label var `varn' `"xb prediction, `postlab'"'
		exit
	}

	if "`type'" == "y" {
		drop `llvar'				/* borrow llvar */
		op_inv `e(depvar)' `y_pred', gen(`llvar') `dynopt', /*
			*/ if `touseS' | `touseD'
		gen `vtyp' `varn' = `llvar'
		label var `varn' `"y prediction, `postlab'"'
		exit
	}

	if "`type'" == "mse" {
		gen `vtyp' `varn' = `y_mse'
		label var `varn' `"MSE of xb, `postlab'"'
		exit
	}

	if "`type'" == "residuals" {
		gen `vtyp' `varn' = `e(depvar)' - `y_pred'
		label var `varn' `"residual, `postlab'"'
		exit
	}


	if "`type'" == "yresiduals" {
		drop `llvar'				/* borrow llvar */
		op_inv `e(depvar)' `y_pred', gen(`llvar') `dynopt', /*
			*/ if `touseS' | `touseD'
		tsrevar `e(depvar)', list
		gen `vtyp' `varn' = `r(varlist)' - `llvar'
		label var `varn' `"y residual, `postlab'"'
		exit
	}


		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	*qui replace `touse'=0 if !e(sample)


			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end


exit


