*! version 1.0.2  14feb2017
						//-- get spatial lag --//
program _spxtreg_get_splag
	syntax , 			///
		[id(string)]		///
		touse(string) 		///
		var(string) 		///
		w(string) 		///
		y(string)		///
		[timevar(string)	///
		timevalues(string)]
	
	_ms_parse_parts `y'
	local flag	= 0
	if ("`r(type)'"=="factor" & r(base)==1 ) {
		local flag	= 1
	}
	else if ("`r(type)'"=="interaction") {
		local k		= r(k_names)
		forvalues i = 1/`k' {
			if ( r(base`i')==1 & `flag' == 0 ) {
				local flag = 1
			}
		}
	}

	if (`flag' ==0) {
		if (`"`timevar'"'=="") {	
			spmatrix lag double `var' `w' `y' if `touse'
		}
		else {
			tempvar touse_time
			qui gen `touse_time' = 0
			qui gen double `var' = .
			foreach time of local timevalues {
				tempvar var_time
				qui replace `touse_time' = 0
				qui replace `touse_time' = 1 	///
					if `touse' & `timevar'== `time'	
				spmatrix lag double `var_time' `w' `y'	///
					if `touse_time', id(`id')
				qui replace `var' = `var_time' if `touse_time'
				capture drop `var_time'
			}
		}
	}
	else {
		qui gen byte `var'	= 0 if `touse'
	}
end
