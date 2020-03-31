*! version 6.2.3  07feb2012
/* Plot observed vs. predicted survival curves by categories of X          */
program define stcoxkm_9
	version 6, missing
	if _caller() < 8 {
		stcoxkm_7 `0'
		exit
	}

	local vv : display "version " string(_caller()) ", missing:"

	st_is 2 analysis
	syntax [if] , BY(varname) [		///
		noSHow				///
		TIEs(string)			///
		SEParate			///
		*				///
	]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	local wt: char _dta[st_wv]
	local wtopt: char _dta[st_w]
	local id: char _dta[st_id]

	tempvar touse
	st_smpl `touse' `"`if'"' `"`in'"'  
	markout `touse' `by', strok

	preserve
	qui keep if `touse'
	keep `by' _d _t `adjust' _t0 `wt' `id' _st
	local xlbl : variable label `by'
	if `"`xlbl'"'=="" { 
		local xlbl "`by'" 
	}
	local timelbl : variable label _t
 
	* Create dummy variables from X and create variable lists  

	quietly tab `by', gen(XCat)
	local numcat=r(r)
	local cc 
	local i 1
	while `i'<=`numcat' {
		if `i'>1 { 
			local xlist `xlist' XCat`i' 
		}
		local vlbl`i' : variable label XCat`i'
		local i=`i'+1
	}
 
	* Create observed survival curves for each category of x
	local i 1
	while `i'<=`numcat' {
		tempvar obsi
		local obslist `obslist' `obsi'
		quietly `vv' sts gen `obsi'=s if XCat`i'==1
		format `obsi' %3.2f
		tokenize `"`vlbl`i''"', parse("==")
                cap confirm number `3'
                if _rc==0 {
                        if `3'==int(`3') {
                                local int=int(`3')
                                local vlbl`i' "`1' = `int'"
                        }
                }
                else  	local vlbl`i' `"`1' = `3'"'
		label var `obsi' "Observed: `vlbl`i''"
		local cc "`cc' stairstep"
		local i=`i'+1
	}

	* Run Cox model and create survival probabilities
	tempvar rh bsurv
	if "`show'"=="" { st_show }
	quietly stcox `xlist', bases(`bsurv') `ties'
	qui predict double `rh', hr
	local i 1
	while `i'<=`numcat'  {
		tempvar survi
		local svlist `svlist' `survi'
		quietly gen `survi'=`bsurv'^`rh' if XCat`i'==1
		format `survi' %3.2f
		label var `survi' `"Predicted: `vlbl`i''"'
		local cc "`cc' direct"
		local i=`i'+1
	}
	label var _t `"`timelbl'"'

	// Plot results
	local yttl "Survival Probability"
	local xttl "analysis time"

	if "`separate'"!="" {
		local byopt by(`by', `byopts')
	}
	if `"`plot'`addplot'"' != "" {
		local draw nodraw
	}
	version 8: graph twoway			///
	(connected `obslist' `svlist' _t,	///
		sort				///
		connect(`cc')			///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`draw'				///
		`byopt'				///
		`options'			///
	)					///
	// blank
	if `"`plot'`addplot'"' != "" {
		restore
		version 8: graph addplot `plot' || `addplot' || , norescaling
	}
end
