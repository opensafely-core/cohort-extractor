*! version 1.3.9  16feb2015
program lowess, sortpreserve
	version 8.0, missing
	if _caller() < 8 {
		lowess_7 `0'
		exit
	}

	syntax varlist(min=2 max=2 numeric ts)	///
		[if] [in] [,			///
		noGraph				///
		GENerate(string)		///
		Adjust				///
		LOgit				///
		Sort				/// [overridden]
		BWidth(real 0)			/// _LOWESS opts
		Mean				///
		noWeight			///
		*				/// graph opts
	]

	_gs_by_combine by options : `"`options'"'
	_get_gropts , graphopts(`options' `by') grbyable	///
		getbyallowed(TItle SUBTItle note legend)	///
		getallowed(PLOTOPts LINEOPts RLOPts plot addplot)
	local by `s(varlist)'
	local byopts `"`s(byopts)'"'
	local bytitle `"`s(by_title)'"'
	local bysubtitle `"`s(by_subtitle)'"'
	local bynote `"`s(by_note)'"'
	local bylegend `"`s(by_legend)'"'
	local options `"`s(graphopts)'"'
	// -lineopts()- and -rlopts()- are synonyms; -lineopts()- overrides
	local rlopts `"`s(rlopts)' `s(lineopts)'"'
	local rlopts : list retok rlopts
	local plopts `"`s(plotopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')
	_check4gropts lineopts, opt(`lineopts')
	_check4gropts plotopts, opt(`plopts')

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
	tsrevar `y' `x'
	local yuse : word 1 of `r(varlist)'
	local xuse : word 2 of `r(varlist)'
	markout `touse' `y' `x'
	tempvar grp
	if "`by'" != "" {
		sort `touse' `by', stable
		qui by `touse' `by': gen `c(obs_t)' `grp'=1 if _n==1 & `touse'
		qui replace `grp'=sum(`grp') if `touse'
		local n = `grp'[_N]
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

	tempvar subuse ys sm
	qui gen byte `subuse' = .
	qui gen double `ys' = .
	qui gen double `sm' = .

	/* Compute smooth for each group */
	forval i = 1/`n' {
		qui replace `subuse'=`touse' & `grp'==`i'
		summ `xuse' if `subuse', mean
		if r(N) >= 3 & r(max)-r(min) >= 1e-30 {
			noi _LOWESS `yuse' `xuse' if `subuse',	///
				lowess(`ys')			///
				bwidth(`bw')			///
				`lopts'

			qui ADJ_LOGIT `yuse' `ys' if `subuse',	///
				`adjust' `logit'

			qui replace `sm' = `ys' if `subuse'
		}
	}
	
	/* Graph (if required) */
	if "`graph'" == "" { 
		if `"`bytitle'"' == "" {
			if "`mean'" == "mean" {
				local title title("Running mean smoother")
			}
			else if "`weight'" == "noweight" {
				local title title("Running line smoother")
			}
			else	local title title("Lowess smoother")
		}
		if `"`bysubtitle'"' == "" {
			if `"`logit'"' != "" {
				local subttl1 ///
				subtitle(`"Logit transformed smooth"')
				local yttl `"logit of `yttl'"'
				local suffix suffix
			}
			if `"`adjust'"' != "" {
				local subttl2 ///
				subtitle(`"Mean adjusted smooth"', `suffix') 
			}
		}
		GetTSTitle `y'
		local yttl `"`r(lab)'"'
		GetTSTitle `x'
		local xttl `"`r(lab)'"'
		if `"`bynote'"' == "" {
			local bwd : di %9.0g `bw'
			local note note(`"bandwidth = `=string(`bwd')'"')
		}
		if "`logit'" == "" {
			local symbol .
			local linestyle p2
		}
		else {
			local symbol none
			local linestyle p1
		}
		if _caller() < 10 {
			local linestyle p1
		}
		if `"`plot'`addplot'"' == "" & `"`bylegend'"' == "" {
			local legend legend(nodraw)
		}
		label var `sm' "lowess: `yttl'"
		local titles				///
			`title'				///
			`subttl1'			///
			`subttl2'			///
			`note'				///
			`legend'			///
			// blank
		if `"`by'"' != "" {
			local byopt by(			///
				`by',			///
				`bytitle'		///
				`bysubtitle'		///
				`bynote'		///
				`bylegend'		///
				`titles'		///
				`byopts'		///
			)
			local titles
		}
		sort `xuse', stable
		graph twoway				///
		(scatter `yuse' `xuse' if `touse',	///
			msymbol(`symbol')		///
			`titles'			///
			ytitle(`"`yttl'"')		///
			xtitle(`"`xttl'"')		///
			`byopt'				///
			`options'			///
			`plopts'			///
		)					///
		(line `sm' `xuse' if `touse',		///
			pstyle(`linestyle')		///
			`rlopts'			///
			`lineopts'			///
		)					///
		|| `plot' || `addplot'			///
		// blank
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

program define GetTSTitle , rclass

	args fullname
	tsunab fullname : `fullname'
	local base = cond( match("`fullname'", "*.*"),                 /*
			*/ bsubstr("`fullname'",                        /*
			*/        (index("`fullname'",".")+1),.),      /*
			*/ "`fullname'")

	local ts 
	if `"`base'"' != `"`fullname'"' {
		local ts : subinstr local fullname "`base'" ""
		local ts : subinstr local ts "." ""
	}
			
	local lab : var label `base'
	if `"`lab'"' == "" {
		local lab `base'
	}
	if "`ts'" != "" {
		local lab `"`ts'.`lab'"'
	}
	
	return local lab `"`lab'"'
	
end

exit

