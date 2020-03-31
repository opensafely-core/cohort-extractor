*! version 1.0.3  31jul2013
program define _vecmksi, rclass sortpreserve
	version 8.2

//This routine makes a set of season indicator variables. 

//	stype("q" | "m") defines the type of seasonality  
//  	noconstant specifies that there is noconstant in the model, 
//		in which case there are S indicators that must sum to 
//		year in each observation.  When there is a constant in 
//		the model, i.e. noconstant is not specified, there are
//		S-1 season indicators in the model.
//	timevar() specifies the name of the time variable set by tsset
//	touse() specifies touse varname from calling routine

// 	note this routine drops _SEASON*

	syntax , stype(string)		///
		timevar(varname)	///
		touse(varname)		///
		[			///
		noCONStant		///
		]
		 
	tempvar season year


	if "`stype'" == "q" {
		qui gen int `season' = quarter(dofq(`timevar'))
		qui gen int `year' = year(dofq(`timevar'))

		local S = 4
	} 
	else if "`stype'" == "m" {
		qui gen int `season' = month(dofm(`timevar'))
		qui gen int `year' = year(dofm(`timevar'))

		local S = 12

	}
	else {
		di as err "dataset is not tsset as quarterly nor "	///
			"monthly"
		di as err "{cmd:tsset} dataset as quarterly or " 	///
			"monthly or use {cmd:sindicators()}"
		exit 498

	}
		 
	if "`constant'" == "" {
		local ns  = `S' - 1
	}
	else {
		local ns  = `S' 
	}

	sort `year' `season'

	tempvar ns_var

	qui by `year': gen `ns_var' = sum(`touse')
	qui by `year': replace `ns_var' = `ns_var'[_N]

	forvalues i = 1/`ns' {
		capture drop _season`i'

		tempvar present`i'

//  because there is at most one observation per year in which
//  season `i' is observed, present`i' will be a 0/1 variable

		qui gen double `present`i'' = (`season'==`i' & `touse')
		qui by `year': replace `present`i'' = sum(`present`i'')
		qui by `year': replace `present`i'' = `present`i''[_N]

// (This should never happen) 
qui count if `present`i'' != 0 & `present`i'' != 1
if r(N) > 0 {
	di as err "error generating seasonal indicators"
	di as err "present`i' is not 0 nor 1"
	exit 498
}

	}
	
	forvalues i = 1/`ns' {
		qui gen double _season`i' = `present`i''*`touse' * 	///
			cond(`season'==`i', 				///
			(`ns_var'-1)/`ns_var', -1/(`ns_var') )

		local vlist "`vlist' _season`i'"
	}

	
	ret local vlist "`vlist'"
	ret scalar ns = `ns'
		
	

end
