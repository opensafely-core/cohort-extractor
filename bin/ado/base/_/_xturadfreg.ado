*! version 1.0.0  17feb2009

// Runs a series of augmented Dickey-Fuller regressions, selecting
// the lag structure that minimizes the specified IC
// on exit, the regression results of the best ADF regression
// are in e()

// When choosing lag length, restricts estimation sample to the 
// sample of the ADF reg w/ most lags
// Final model, however, is fitted on all available obs from
// first to last.
// obvar is a variable that numbers obs. 1 .. T
// first = first obs. in series to use
// last = last obs. in series to use

program _xturadfreg

	args	diffvar				///	differenced var
		lagvar				///	lagged var
		trend				/// 	trend var or ""
		noconstant			/// 	... or ""
		maxlags				///	max lags to use
		obvar				///	= _n for dataset
		first				///	first obs #
		last				///	last obs #
		criterion			///	aic, bic, or hqic
		touse				///
		lagused

	local firstb = `first'
	local lastb = `last'
	local minic = .
	local p_i = `maxlags'
	forvalues p=`maxlags'(-1)0 {
		if `p' == 0 {
			qui regress `diffvar' `lagvar' `trend'	///
			        in `firstb'/`lastb', `noconstant'
		}
		else {
			qui regress `diffvar' `lagvar'		///
			        L(1/`p').(`diffvar') `trend'	///
			        in `firstb'/`lastb', `noconstant'
		}
		if `p' == `maxlags' {
			tempvar obvar2
			qui gen `obvar2' = cond(e(sample),	///
			        `obvar', .) in `first'/`last'
			qui sum `obvar2' in `first'/`last'
			local firstb = r(min)
			local lastb  = r(max)
		}
		_xtur_getic `criterion'
		local icval = r(ic)

		if `icval' < `minic' {
			local minic = `icval'
			local p_i = `p'
		}
	}

	if `p_i' == 0 {
		qui regress `diffvar' `lagvar' `trend'		///
			in `first'/`last', `noconstant'
	}
	else {
		qui regress `diffvar' `lagvar'			///
			L(1/`p_i').(`diffvar') `trend'		///
			in `first'/`last', `noconstant'
	}

	c_local `lagused' `p_i'

end
