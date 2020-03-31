*! version 6.2.4  04feb2015
/* Plot -ln(-ln) survival plots to assess proportional hazard assumption  */
program define stphplot_9
	version 6, missing
	if _caller() < 8 {
		stphplot_7 `0'
		exit
	}

	local vv : display "version " string(_caller()) ", missing:"

	st_is 2 analysis
	syntax [if] [, ADJust(varlist) BY(varname) Connect(string) /*
		*/  noLNTime noNEGative STRata(varname) noSHow Zero * ]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	local wt: char _dta[st_wv]  
	local wtopt: char _dta[st_w]       

	if "`by'"=="" & "`strata'"=="" {
		di in red "option by() or strata() required"
		exit 198
	}
	if "`by'"!="" & "`strata'"!="" {
		di in red "only one of by() and strata() may be specified"
		exit 198
	}

	local x "`by'`strata'"
	if "`by'"!="" {
		local gensurv = cond("`adjust'"=="", 1, 2)
	}
	else /* strata != "" */ { 
		if "`adjust'"=="" {
			di in red /*
			*/ "strata() requires adjust(); perhaps you mean by()"
			exit 198
		}
		
		local gensurv 3 
	}
	if "`zero'"!="" & "`adjust'"=="" {
		di in red /*
		*/ "adjust() required with zero option"
		exit 198
	}

 	tempvar touse
	st_smpl `touse' `"`if'"' "`in'" "`by'" "`strata'" "`adjust'"
	markout `touse'  `x', strok

	preserve
	qui keep if `touse'
	keep `x' _d _t `adjust' _t0 `wt' `_dta[st_id]' _st
	quietly tab `x', gen(XCat)
	local numcat=r(r)
	local xlbl : variable label `x'
	if "`xlbl'"=="" { 
		local xlbl "`x'" 
	}

	* If there are covariates, drop obs. with missing values, center
	tokenize `adjust'
	local i 1
	quietly {
		if "`zero'"=="" {
			while "``i''"~=""  {
				local cov`i' "``i''"
				drop if `cov`i''>=.     /* unnecessary */
				sum `wtopt' `cov`i''
				replace `cov`i''=`cov`i''- r(mean)
				local i=`i'+1
			}
		}
	}

	tempvar surv

	* generate loglog line for each level of class variable
	if `gensurv'==1 {
		`vv' sts gen `surv'=s, by(`x')
	}
	else if `gensurv'==2 {
		`vv' sts gen `surv'=s, by(`x') adjust(`adjust')
	}
	else /* `gensurv'==3
	*/	`vv' sts gen `surv'=s, strata(`x') adjust(`adjust') 
	tempvar time 
	if "`lntime'"!="" {
		qui gen `time'=_t
		label var `time' "_t"
		local xttl `"analysis time"'
	}
	else {
		qui gen `time'=ln(_t)
		label var `time' "ln(_t)"
		local xttl `"ln(analysis time)"'
	}

	local i 1
	while `i'<=`numcat'  {
		tempvar survi
		local slist `slist' `survi'

		local vlbl`i' : variable label XCat`i'
		if "`negative'"=="" { 
			qui gen `survi'=-ln(-ln(`surv')) if XCat`i'==1
			local yttl "-ln[-ln(Survival Probability)]"
		}
		else {
			qui gen `survi'=ln(-ln(`surv')) if XCat`i'==1 
			local yttl "ln[-ln(Survival Probability)]"
		}

		local index = strpos(`"`vlbl`i''"', "==")
		local lftSide = bsubstr(`"`vlbl`i''"', 1, `index' - 1)
		local rtSide = bsubstr(`"`vlbl`i''"', `index' + 2, .)
		cap confirm number `rtSide'
		if _rc==0 {
			if `rtSide'==int(`rtSide') {
				local int=int(`rtSide')
				label var `survi' "`lftSide' = `int'"
			}
		}
		else  	label var `survi' `"`lftSide' = `rtSide'"'
		local i=`i'+1
	}
	drop `surv'
 
	if "`show'"=="" {
		st_show
	}
	if `"`plot'`addplot'"' != "" {
		local draw nodraw
	}
	version 8: graph twoway		///
	(connected `slist' `time',	///
		sort			///
		ytitle(`"`yttl'"')	///
		xtitle(`"`xttl'"')	///
		`draw'			///
		`options'		///
	)				///
	// blank
	if `"`plot'`addplot'"' != "" {
		restore
		version 8: graph addplot `plot' || `addplot' || , norescaling
	}
end

