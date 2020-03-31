*! version 1.0.2  12feb2010
program define _vecmktrend
	version 8.2

	syntax [if] [in], [ allowdrop nvecyet tvar(varname) tmin(string)]

	if "`nvecyet'" == "" {
		_ckvec _vecmktrend
	}	
	

	if "`if'`in'" != "" {
		marksample touse
	}
	else {
		tempvar touse
		qui gen byte `touse' = e(sample)
	}


	if "`nvecyet'" == "" {
		local tvar "`e(tvar)'"
		if "`tvar'" == "" {
			di as err "no time variables saved in vec e-results"
			exit 498
		}

		capture confirm variable `tvar'
		if _rc {
			di as err "time variable (`tvar') used for vec " ///
				"estimation not found"
			exit 498	
		}
		local tmin = e(tmin)
	}
	else {
		if "`tvar'" == "" {
			di as err "tvar must be specified in call to "	///
				"_vecmktrend when nvecyet is specified"
			exit 498
		}

		capture confirm variable `tvar'
		if _rc {
			di as err "tvar specified in call to "	///
				"_vecmktrend (`tvar') not found"
			exit 498
		}

		if "`tmin'" == "" {
			di as err "tmin() must be specified in call to " ///
				"_vecmktrend when nvecyet is specified"
			exit 498
		}
		capture confirm integer number `tmin'
		if _rc {
			di as err "tmin() dos not specify an integer " ///
				"in call to _vecmktrend"
			exit 498
	
		}
	}

//  call to tsset assures that the dataset is tsset and sorted by t
	qui tsset, noquery

// this method of generating _trend assumes no gaps in the data		   
//  no gaps condition is checked by vec

	if "`e(trend)'" == "rtrend" |			///
	   "`e(trend)'" == "trend"  |			///
	   "`nvecyet'" != ""        {
	   	   capture drop _trend
		   qui gen _trend = (`tvar' >= `tmin')
		   qui replace _trend = sum(_trend)
	}   

end

exit

	similar to _vecmkce, the allowdrop drop option specifies that
	_vecmktrend should check to see if there already exists a variable
	called _trend and drops it if it does exist.  Note:  _vecmktrend
	does not preserve the data. 
