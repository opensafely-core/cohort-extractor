*! version 1.0.0  17apr2019

program meta__gen_studylabel

	version 16
	
	syntax [, nobs(string) touse(string)]
	
	cap drop _meta_studylabel
	
	qui gen _meta_studylabel = "Study " + string(_n) if `touse'
	if `nobs' >= 1000 {
		qui replace _meta_studylabel = ///
			"Study  " + string(_n) if `touse' & _n < 1000
		qui replace _meta_studylabel = ///
			"Study   " + string(_n) if `touse' & _n < 100
		qui replace _meta_studylabel = ///
			"Study    " + string(_n) if `touse' & _n < 10	
	}
	else if `nobs' >= 100 {
		qui replace _meta_studylabel = ///
			"Study  " + string(_n) if `touse' & _n < 100
		qui replace _meta_studylabel = ///
			"Study   " + string(_n) if `touse' & _n < 10	
	}
	else if `nobs' >= 10 {
		qui replace _meta_studylabel = ///
			"Study  " + string(_n) if `touse' & _n < 10
	}	
end
