*! version 6.2.1  02may2007
program define tsfill, rclass
	version 6

	syntax [, Full ]

	
	_ts timevar panel, sort panel 
	local tsdel `:char _dta[_TSdelta]'
	tempname delta
	if "`tsdel'" == "" {
		scalar `delta' = 1
	}
	else {
		scalar `delta' = `=`tsdel''
	}

	/* No missings if "full" specified */
	if "`full'" != "" {
		capture assert `timevar' != .
		if _rc {
			di in red "timevar (`timevar') may not contain " /*
			*/  "missing values when option full is specified"
			exit 451
		}
	}


	/* Check that time data is valid */

	if "`panel'" != ""   {
		local bypfx "qui by `panel': "
	}
	else    local bypfx "qui "  

	tempvar timedif
	`bypfx' gen double `timedif' = `timevar'[_n+1] - `timevar'
	qui sum `timedif'
	if r(min) == 0 {
		if "`panel'" == "" {
			di in red "repeated time values within panel"  
		}
		else    di in red "repeated time values in sample"  
		exit 451
	}

	/* Fill-in missing values of the time variable */
	/* Fill-in the data in place.  No saves or preserves required */

	tempvar numreps

				/* find # of missing times
				 * between each pair of obs */
	if "`full'" != "" {
				/* special case if expanding
				 * to full panels */
		tempvar realtim
		qui sum `timevar'
		`bypfx' replace `timedif' = r(max) - `timevar' + /*
			*/ `delta' if _n == _N
		`bypfx' replace `timedif' = /*
			*/ `timedif' + `timevar' - r(min) if _n == 1
		`bypfx' gen double `realtim' = `timevar' /*
			*/ if _n == 1 & `timevar' != r(min)
		`bypfx' replace `timevar' = r(min)  if _n == 1
		/* ChkIntvl `timedif' `delta' `detail' */
	}
	else    `bypfx' replace `timedif' =  0 if _n == _N

	`bypfx' gen double `numreps' = `timedif' / `delta'
	qui replace `numreps' = 0 if `numreps' == .

				/* add an obs to the bottom of the data for 
				 * each point that requires filling in.  Put 
				 * obs requiring filling at the bottom of 
				 * the data. */
	local orign = _N

	qui count if  `numreps'  > 1
	local addns `r(N)'

	if `addns' > 0 {
		local newobs = `orign' + `addns'

		qui replace `numreps' = - `numreps'
		sort `numreps'
		qui replace `numreps' = - `numreps'

		qui set obs `newobs'

					/* copy down the time, replication,
					 * and panel info.  */
		local orign1 = `orign' + 1
		qui replace `numreps' = `numreps'[_n-`orign']  in `orign1'/l
		qui replace `timevar' = `timevar'[_n-`orign']  in `orign1'/l
		if "`panel'" != "" {
			qui replace `panel' = `panel'[_n-`orign']  in `orign1'/l
		}
		qui replace `numreps' = 0  in 1/`orign'

					/* expand the remain required
					 * observations */
		qui replace `numreps' = `numreps' - 1  if `numreps'
		qui expand `numreps'

					/* compute the times for the
					 * expanded observations */
		sort `panel' `timevar' `numreps'
		qui by `panel' `timevar': replace `timevar' = `timevar' + /*
			*/ `delta' * (`numreps' - _n + 2)  if `numreps' > 0
		/* qui replace `timevar' = round(`timevar', `delta') */
		drop `timedif' `numreps'

					/* get sort order back */
		sort `panel' `timevar'

					/* must get original data back on its
					 * observation for initial obs 
					 * expansion */
		if "`full'" != "" {
			qui count if `realtim' != .
			if r(N) > 0 {
				tempvar tmp1 tmp2
				qui gen double `tmp1' = `realtim'
				qui by `panel': replace `tmp1' = `tmp1'[_n-1] /*
					*/ if `tmp1'==.
				qui gen double `tmp2' = `timevar'	/*
					*/ if `realtim' != .
				qui by `panel': replace `tmp2' = `tmp2'[_n-1] /*
					*/ if `tmp2'==.
				qui replace `timevar' = `tmp2'		/*
					*/ if `timevar' == `tmp1'
				qui replace `timevar' = `realtim'  	/*
					*/ if `realtim' != .
				sort `panel' `timevar'
			}
		}
	}

end


program define ChkIntvl				/* not currently used */
	args timedif intrval report

	capture assert abs(`timedif' / `intrval' - /*
		*/ round(`timedif' / `intrval', 1))  < .01  if `timedif' != .
	if _rc != 0 {
di in red "differences in the time variable disagree with the time interval"
		if "`report'" != "" {
			list `timedif' if abs(`timedif' / `intrval' - /*
				*/ round(`timedif' / `intrval', 1))  < .01  /*
				*/ & `timedif' != .
		}

		exit 451
	}
end



exit


----------------------------------------------------------------------------
	fillin if x[_n+#] = works:

qui count if `numreps' > 0
qui sum `numreps' 
local addns `r(sum)'
local newobs = `orign' + `addns'

gen int offset[_n+1] = _n + sum(`numreps')
replace offset = 0 in 1/1
set obs newobs

replace `numreps'[`offset'] = `numreps'  if `numreps' > 0
replace `timevar'[`offset'] = `timevar'  if `numreps' > 0

replace `numreps' = `numreps'[_n-1]   if _n > `orign' * `numreps' == .
replace `timevar' = `timevar' + `delta' * `numreps'  if _n > `orign'

