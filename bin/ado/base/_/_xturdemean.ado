*! version 1.0.0  17feb2009

// Removes cross-sectional means from a panel dataset
// utility for -xtunitroot-
// newvar should not be -generated- before calling this
// gets delta from _dta[_TSdelta]

program _xturdemean

	args	newvar					///
		colon					///
		oldvar					///
		timevar					///
		touse
	
	if "`colon'" != ":" {
		di as error "_xturdemean called improperly" 
		exit 198
	}
	
	qui gen double `newvar' = .
	tempname ctime maxtime
	su `timevar', mean
	sca `ctime' = r(min)
	sca `maxtime' = r(max)
	while (`ctime' <= `maxtime') {
		su `oldvar' if `timevar' == `ctime' & `touse', mean
		qui replace `newvar' = `oldvar' - r(mean)	///
			if `timevar' == `ctime' & `touse'
		sca `ctime' = `ctime' + `=`:char _dta[_TSdelta]''
	}	

end
