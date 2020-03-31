*! version 6.0.6  07feb2012
/* Plot observed vs. predicted survival curves by categories of X          */
program define stcoxkm_7
	version 6, missing
	st_is 2 analysis
	syntax [if], BY(varname) [Connect(string) L1title(string) /*
		*/ L2title(string) noSHow YLAbel(string) TIEs(string) /*
		*/ SEParate B2title(string) * ]

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
		quietly sts gen `obsi'=s if XCat`i'==1
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
		local cc "`cc'J"
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
		local cc "`cc'll"
		local i=`i'+1
	}
	label var _t `"`timelbl'"'

	* Plot results
	if "`l1title'"=="" {
		local l1title "Observed vs. Predicted Survival Probabilities"
	}
	if "`l2title'"=="" { 
		local l2title "By Categories of `xlbl'" 
	}
        if "`b2title'"=="" {
                local b2title "analysis time"
        }

	if "`ylabel'"=="" { 
		local ylabel "ylabel(0,.25,.50,.75,1)" 
	}
	else 	local ylabel "ylabel(`ylabel')"

	if "`connect'"=="" { 
		local connect "c(`cc')" 
	}
	else 	local connect "c(`connect')"

	if "`separate'"!="" {
		sort `by'
		gr7 `obslist' `svlist' _t, sort `ylabel' /*
			*/ b2(`"`b2title'"') l1(`"`l1title'"')/*
			*/ l2(`"`l2title'"') `connect' `options' by(`by')
	}
	else {
		gr7 `obslist' `svlist' _t, sort `ylabel' /*
			*/ b2(`"`b2title'"') l1(`"`l1title'"') /*
			*/ l2(`"`l2title'"') `connect' `options'
	}
end
