*! version 1.0.1  09feb2015
program lowess_7, sortpreserve
	version 8.0
	syntax varlist(min=2 max=2 numeric)	///
		[if] [in] [,			///
		noGraph				///
		GENerate(string)		///
		BY(varlist)			///
		Adjust				///
		LOgit				///
		Sort				/// [overridden]
		BWidth(real 0)			/// _LOWESS opts
		Mean				///
		noWeight			///
		T1title(string)			/// gr7 opts
		Symbol(string)			///
		Connect(string)			///
		*				///
	]

	if "`generate'" != "" {
		confirm new var `generate'
	}

	local lopts "`mean' `weight'"
	local weight 
	marksample touse

	local sort "sort"	/* Force -sort- */

	tokenize `varlist'
	local y `1'
	local x `2'

	tempvar grp
	if "`by'" != "" {
		sort `touse' `by' 
		qui by `touse' `by': gen `c(obs_t)' `grp'=1 if _n==1 & `touse'
		qui replace `grp'=sum(`grp') if `touse'
		local n = `grp'[_N]
		local byopt "by(`by')"
					/* check more than one groups */
		if `n' < 2 {
			di in red "by() variable takes on only one value"
			exit 198
		}
	}
	else {
		local n=1
		qui gen `grp'=1
	}
	local bw = `bwidth'
	if `bw' <= 0 | `bw' >= 1 {
		local bw .8
	}

	local smlist
	local lsymbol
	local lconnect

	tempvar subuse ys sm
	qui gen byte `subuse' = .
	qui gen double `ys' = .
	qui gen double `sm' = .

	/* Compute smooth for each group */
	forval i = 1/`n' {
		qui replace `subuse'=`touse' & `grp'==`i'
		summ `x' if `subuse', mean
		if r(N) < 3 {
			noisily error 2001
		}
		if r(max)-r(min) < 1e-30 {
			di in red "Range of `x' is too small"
			exit 499
		}

		noi _LOWESS `y' `x' if `subuse',	///
			lowess(`ys')			///
			bwidth(`bw')			///
			`lopts'

		qui ADJ_LOGIT `y' `ys' if `subuse',	///
			`adjust' `logit'

		qui replace `sm' = `ys' if `subuse'
		local lsymbol "`lsymbol'i"
		local lconnect "`lconnect'l"
	}

	/* Graph (if required) */
	if "`graph'" == "" { 
		if `"`t1title'"' == ""{
			if "`mean'" == "mean" {
				local t1title "Running mean smoother"
			}
			else if "`weight'" == "noweight" {
				local t1title "Running line smoother"
			}
			else	local t1title "Lowess smoother"
			local t1title `"`t1title', bandwidth = `bw'"'
		}
		if "`by'" != "" {
			sort `by'
		}
		if "`logit'" == "" {
			local symbol =	///
				cond("`symbol'" == "", "oi", "`symbol'")
			local connect =	///
				cond("`connect'" == "", ".l", "`connect'")
			gr7 `y' `sm' `x' if `touse', `options' /*
				*/ t1(`"`t1title'"') s(`symbol') /*
				*/ c(`connect') `sort' `byopt'
		}
		else {
			local symbol =	///
				cond("`symbol'" == "", "i", "`symbol'")
			local connect =	///
				cond("`connect'" == "", "l", "`connect'")
			gr7 `sm' `x' if `touse', `options' /*
				*/ t1(`"`t1title'"') s(`symbol') /*
				*/ c(`connect') `sort' `byopt'
		}
	}

	if "`generate'" != "" {
		rename `sm' `generate'
	}
end

program ADJ_LOGIT	/* ADJ_LOGIT y ys if ... , ... */
	syntax varlist(min=2 max=2 numeric) if [, adjust logit ]

	marksample touse
	tokenize `varlist'
	local y `1'		/* y values */
	local ys `2'		/* smoothed values */

	/* Adjust smooth so that mean of smoothed values equals mean of y
	 * values.  */

	if "`adjust'" == "adjust" {
		tempname mean
		summ `ys' , mean
		scalar `mean' = r(mean)
		summ `y' , mean
		replace `ys' = `ys'* r(mean)/`mean' if `touse'
	}

	/* Perform logit transform of smoothed values */

	if "`logit'" == "logit" {
		tempname adj small
		qui count if `touse'
		scalar `adj' = 1/r(N)
		scalar `small' = 0.0001
		replace `ys' = `adj' if `ys' < `small' & `touse'
		replace `ys' = 1-`adj' if `ys' > (1-`small') & `touse'
		replace `ys' = ln(`ys'/(1-`ys')) if `touse'
	}
end

exit

