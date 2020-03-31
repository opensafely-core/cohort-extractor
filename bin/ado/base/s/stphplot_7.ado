*! version 6.0.7  15sep2004
/* Plot -ln(-ln) survival plots to assess proportional hazard assumption  */
program define stphplot_7
	version 6, missing
	st_is 2 analysis
	syntax [if] [, ADJust(varlist) BY(varname) Connect(string) /*
		*/  noLNTime L1title(string) L2title(string) noNEGative /*
		*/  STRata(varname) noSHow Zero B2title(string) * ]

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
	if `gensurv'==1 { sts gen `surv'=s, by(`x') }
	else if `gensurv'==2 { sts gen `surv'=s, by(`x') adjust(`adjust') }
	else /* `gensurv'==3 */ sts gen `surv'=s, strata(`x') adjust(`adjust') 
	tempvar time 
	if "`lntime'"!="" {
		qui gen `time'=_t
		label var `time' "_t"
		if "`b2title'"=="" {
			local b2title `"analysis time"'
		}
	}
	else {
		qui gen `time'=ln(_t)
		label var `time' "ln(_t)"
	}

	local cc 
	local i 1
	while `i'<=`numcat'  {
		tempvar survi
		local slist `slist' `survi'

		local vlbl`i' : variable label XCat`i'
		if "`negative'"=="" { 
			qui gen `survi'=-ln(-ln(`surv')) if XCat`i'==1
			if "`l1title'"=="" {
			   local l1title "-Ln[-Ln(Survival Probabilities)]"
			}
		}
		else {
			 qui gen `survi'=ln(-ln(`surv')) if XCat`i'==1 
			 local l1title "Ln[-Ln(Survival Probabilities)]"
		}

		tokenize "`vlbl`i''", parse("==")
		cap confirm number `3'
		if _rc==0 {
			if `3'==int(`3') {
				local int=int(`3')
				label var `survi' "`1' = `int'"
			}
		}
		else  	label var `survi' `"`1' = `3'"'
		local cc "`cc'l"
		local i=`i'+1
	}
	drop `surv'
 
	* gr7 the results
	if "`connect'"=="" { 
		local connect "c(`cc')" 
	}
	else local connect "c(`connect')"
	if "`show'"=="" { st_show }
	if "`l2title'"=="" { 
		local l2title `"by categories of `xlbl'"' 
	}
	if "`b2title'"=="" {
		local b2title `"ln(analysis time)"'
	}
	gr7 `slist' `time', l1(`"`l1title'"') l2(`"`l2title'"') /*
		*/ sort b2(`"`b2title'"') `connect' `options' 

end

