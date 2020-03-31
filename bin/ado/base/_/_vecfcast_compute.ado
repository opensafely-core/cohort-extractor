*! version 1.1.3  26sep2013
program define _vecfcast_compute, rclass
	version 8.2

	syntax name(name=prefix id="prefix")	///
		[,				/// 
		DIfferences			///
		*				///
		]
	
	
	_ckvec vecfcast

	local rank = e(k_ce)
	local endog "`e(endog)'"


	capture noi _vecfcast_compute_w `prefix'  , `options' `differences'
	local rc = _rc

	if `rc' > 0 {
		foreach v of global S_vecfcast_cr {
			capture drop `v'
		}	
	}

	capture macro drop S_vecfcast_cr 
	
	local created  `r(created)'

	forvalues i=1/`rank' {
		capture drop _ce`i'
	}
	
	capture drop _trend

	if "`differences'" == "" {
		foreach v of local endog {
			capture drop `prefix'D_`v'
		}
	}

	ret clear

	if `rc' > 0 {
		foreach v of local created {
			capture drop `v'
		}
		exit `rc'
	}


end
