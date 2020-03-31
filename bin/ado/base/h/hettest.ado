*! version 3.4.2  10mar2010
program define hettest, rclass
	version 8

	_isfit cons anovaok
	_ms_op_info e(b)
	if r(tsops) {
		quietly tsset, noquery
	}

	syntax [varlist(default=none numeric fv ts)] 	///
		[, 					///
		Rhs 					///
		Mtest 					///
		Mtest2(passthru)			///
		NOrmal					///	// default
		IId					///
		FStat					///
		]
	local fvops = "`s(fvops)'" == "true"

	if "`e(wtype)'" == "pweight" {
		di as err "hettest not appropriate with pweighted data"
		//di as err "use testom instead"
		exit 101
	}
	if "`e(vcetype)'" == "Robust" {
		di as err "hettest not appropriate after robust cluster()"
		//di as err "use testom instead"
		exit 498
	}
		
	if "`normal'" != "" & "`iid'`fstat'" != "" {
		di as err "{cmd:normal} cannot be specified with "	///
			"{cmd:iid} or {cmd:fstat}"
		exit 498	
	}

								// set default
	if "`iid'`fstat'" == "" {
		if "`normal'" == "" {
			local normal normal
		}
	}	
		

	// check that mtest option has valid value
	// store the unabbreviated value in local method
	if `"`mtest'`mtest2'"' != "" {
		if "`iid'" != "" {
			di as err "{cmd:iid} may not be "		///
				"specified with {cmd:mtest} or "	///
				"{cmd:mtest2()}"
			exit 498
		}
		if "`fstat'" != "" {
			di as err "{cmd:fstat} may not be "		///
				"specified with {cmd:mtest} or "	///
				"{cmd:mtest2()}"
			exit 498
		}
		_mtest syntax, `mtest' `mtest2'
		local mtmethod `r(method)'
		local mtest
		local mtest2
	}

	// add rhs-variables (except _cons) to varlist
	if "`rhs'" != "" {
		local v : colnames e(b)
		local v : subinstr local v "_cons" "", word
		local varlist `varlist' `v'
		_ms_op_info e(b)
		local fvops = r(fvops)
	}
	local varlist : list uniq varlist
	local nvar : word count `varlist'

	if `fvops' {
		local vv "version 11:"
	}

	// check that depvar is not in varlist
	local tmp : subinstr local varlist "`e(depvar)'" "", ///
		word all count(local nch)
	if `nch' == 1 {
		if `nvar' == 1 {
			local varlist `e(depvar)'
		}
		else {
			di in err `"`e(depvar)' may not be specified"'
			exit 499
		}
	}


	// generate residuals and predicted values
	// ---------------------------------------

	tempvar ui touse
	tempname oldest

	if "`e(wtype)'" != "" {
		local wgt "[`e(wtype)' `e(wexp)']"
	}
	gen byte `touse' = e(sample)
	qui _predict double `ui' if `touse', resid
	qui replace `ui' = `ui'^2 / (e(rss)/e(N))    // ui = squared res

	if "`varlist'" == "" {    // use fitted values
		tempvar z
		qui _predict double `z' if `touse'
		local varlist `z'
		local tvarlist "fitted values of `e(depvar)'"
	}
	else {
		local tvarlist `varlist'
	}
	local nvar: word count `varlist'
	if `nvar' == 1 {
		local mtmethod
	}


	// compute tests
	// -------------

	_est hold `oldest', restore

	// multivariate test, stored in 3 scalars
	`vv' ///
	quiet _regress `ui' `varlist' `wgt'  if `touse'
	local varlist : colna e(b)
	local USCONS _cons
	local varlist : list varlist - USCONS
	local nvar : list sizeof varlist
	if "`iid'" != "" {
		return scalar chi2 = e(N)*e(r2)
		return scalar df   = e(df_m)
		return scalar p    = chi2tail(e(df_m),e(N)*e(r2))
	}
	else if "`fstat'" != "" {
		return scalar F    = e(F)
		return scalar df_m = e(df_m)
		return scalar df_r = e(df_r)
		return scalar p    = Ftail(e(df_m), e(df_r), e(F))
	}
	else {
		return scalar chi2 = e(mss)/2
		return scalar df   = e(df_m)
		return scalar p    = chi2tail(e(df_m),e(mss)/2)
	}

	if "`mtmethod'" != "" {

		// multiple tests are stored in nx3 matrix mtest
		//   column 1: test statistic
		//   column 2: df = 1
		//   column 3: chi2-based p-value

		tempname mtest
		mat `mtest' = J(`nvar',3,0)
		matrix colnames `mtest' = chi2 df p
		version 11: ///
		matrix rownames `mtest' = `varlist'
		local i 0
		foreach v of local varlist {
			local ++i
			`vv' ///
			qui _regress `ui' `v' `wgt'  if `touse'
			mat `mtest'[`i',1] = e(mss)/2
			mat `mtest'[`i',2] = e(df_m)
			mat `mtest'[`i',3] = chi2tail(e(df_m),e(mss)/2)
		}

		// obtain adjusted p-values using _mtest
		if "`mtmethod'" != "noadjust" {
			_mtest adjust `mtest', mtest(`mtmethod') pindex(3) append
			mat `mtest' = r(result)
			local indexp 4
		}
		else	local indexp 3

		_ms_build_info `mtest' if e(sample), row
		return matrix mtest    `mtest'
		return local  mtmethod `mtmethod'
	}

	_est unhold `oldest'


	// display tests
	// -------------

	di _n as txt `"Breusch-Pagan / Cook-Weisberg test for heteroskedasticity `tt'"'
	di    as txt  "         Ho: Constant variance"

	if "`mtmethod'" != "" {                      // multiple tests

		matrix `mtest' = return(mtest)
		di
		di as txt "{hline 13}{c TT}{hline 25}"
		di as txt "    Variable {c |}      chi2   df      p "
		di as txt "{hline 13}{c +}{hline 25}"

		local first
		local i 0
		foreach v of local varlist {
			local ++i
			_ms_display,	matrix(`mtest')	///
					row		///
					el(`i')		///
					`first'		///
					vsquish		///
					nobase		///
					noomit		///
					noempty
			if r(output) {
				local first
			}
			else {
				if r(first) {
					local first first
				}
				continue
			}
			di as txt " " as res                  ///
			  _col(16)  %9.2f  el(`mtest',`i',1)  ///
			  _col(24)  %5.0f  el(`mtest',`i',2)  ///
			  _col(33)  %6.4f  el(`mtest',`i',`indexp') " #"
		}

		di as txt  "{hline 13}{c +}{hline 25}"
		di as txt "simultaneous"         ///
		   _col(14) "{c |} " as res      ///
		   _col(16) %9.2f  return(chi2)  ///
		   _col(24) %5.0f  return(df)    ///
		   _col(33) %6.4f  return(p)
		di as txt  "{hline 13}{c BT}{hline 25}"

		_mtest footer 39 "`mtmethod'" "#"

	}
	else {                                       // only simult test

		if "`fstat'" != "" {
			di as txt "{p 9 20}Variables: `tvarlist'"
			di
			di as txt _col(10) "F(" as res return(df_m) 	///
			   as txt " , " as res return(df_r)		///
			   as txt ")" _col(23) "=" 			///
			   as res %9.2f return(F)
			di as txt _col(10) "Prob > F" _col(23) "=" ///
			   as res %9.4f return(p)
		}
		else {

			di as txt "{p 9 20}Variables: `tvarlist'"
			di
			di as txt _col(10) "chi2(" as res return(df) ///
			   as txt ")" _col(23) "=" as res %9.2f return(chi2)
			di as txt _col(10) "Prob > chi2" _col(23) "=" ///
			   as res %9.4f return(p)
		}   
	}


	// double save results
	// -------------------

	global S_3  `return(df)'   // degrees of freedom chi2 under H0
	global S_5
	global S_6  `return(chi2)' // test statistic
end

exit
