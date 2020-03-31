*! version 6.3.3  21sep2018
/* Plot observed vs. predicted survival curves by categories of X          */
program define stcoxkm
	if _caller() < 10 {
		stcoxkm_9 `0'
		exit
	}
	version 6, missing

	local vv : display "version " string(_caller()) ", missing:"

	st_is 2 analysis
	syntax [if] , BY(varname) [		///
		noSHow				///
		TIEs(string)			///
		SEParate			///
		USEOLDBASE			///  undocumented 
		*				///
	]

	_gs_byopts_combine byopts options : `"`options'"'

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
	local i 1
	while `i'<=`numcat' {
		if `i'>1 { 
			local xlist `xlist' XCat`i' 
		}
		local vlbl`i' : variable label XCat`i'
		local i=`i'+1
	}
	
	if "`separate'" != "" {
		// **** parse out obsopts	
		local 0 , `options'
		syntax [, OBSOPts(string asis) * ]
		local obsops `obsopts'
		while `"`obsopts'"' != "" {
		    local 0 `", `options'"'
		    syntax [, OBSOPts(string asis) * ]
		    if `"`obsopts'"' != "" {
			local obsops `"`obsops' `obsopts'"'
		    }
		}
		// ****
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

		if "`separate'" == "" {
			// **** parse out obs`i'opts	
			local 0 , `options'
			syntax [, OBS`i'opts(string asis) * ]
			local obsops `obs`i'opts'
			while `"`obs`i'opts'"' != "" {
			    local 0 `", `options'"'
			    syntax [, OBS`i'opts(string asis) * ]
			    if `"`obs`i'opts'"' != "" {
				local obsops `"`obsops' `obs`i'opts'"'
			    }
			}
			// ****
		}
		
		local obsplot `obsplot' (connected `obsi' _t, sort connect(stairstep) `obsops')
		local i=`i'+1
	}

	if "`e(cmd)'" != "" {
		local flag = 1
		tempname old
        	`vv' _estimates hold `old', copy restore
	}
	else {
		local flag = 0
	}

	* Run Cox model and create survival probabilities
	tempvar rh bsurv
	if "`show'"=="" { st_show }
	if "`useoldbase'"!="" {
		qui stcox `xlist', `ties' bases(`bsurv')
	}
	else {
		qui stcox `xlist', `ties'
		qui predict double `bsurv' if e(sample), basesurv 
	}
	qui predict double `rh', hr

	if ("`flag'" == "1") {
		`vv' _estimate unhold `old' 
	}
	else if ("`flag'" == "0") {
		`vv' eret clear
	} 

	if "`separate'" != "" {
		// **** parse out predopts	
		local 0 , `options'
		syntax [, PREDOPts(string asis) * ]
		local predops `predopts'
		while `"`predopts'"' != "" {
		    local 0 `", `options'"'
		    syntax [, PREDOPts(string asis) * ]
		    if `"`predopts'"' != "" {
			local predops `"`predops' `predopts'"'
		    }
		}
		// ****
	}
		
	local i 1
	while `i'<=`numcat'  {
		tempvar survi
		local svlist `svlist' `survi'
		quietly gen `survi'=`bsurv'^`rh' if XCat`i'==1
		format `survi' %3.2f
		label var `survi' `"Predicted: `vlbl`i''"'
		if "`separate'" == "" {
			// **** parse out pred`i'opts	
			local 0 , `options'
			syntax [, PRED`i'opts(string asis) * ]
			local predops `pred`i'opts'
			while `"`pred`i'opts'"' != "" {
			    local 0 `", `options'"'
			    syntax [, PRED`i'opts(string asis) * ]
			    if `"`pred`i'opts'"' != "" {
				local predops `"`predops' `pred`i'opts'"'
			    }
			}
			// ****
		}
		
		local predplt `predplt' (connected `survi' _t, sort `predops')
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
		`obsplot' `predplt',		///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`draw'				///
		`byopt'				///
		`options'			///
	// blank
	if `"`plot'`addplot'"' != "" {
		restore
		version 8: graph addplot `plot' || `addplot' || , norescaling
	}
end
