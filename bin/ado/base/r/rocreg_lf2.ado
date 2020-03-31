*! version 1.0.1  11may2011
program rocreg_lf2
	version 12
	args todo b lnfj dcasecov dcasesd dctrlcov dctrlsd H

	local y $ML_y1
	local d $ML_y2

	tempvar casecov casesd ctrlcov ctrlsd
	mleval `casecov' = `b', eq(1)
	mleval `casesd' = `b', eq(2) 
	mleval `ctrlcov' = `b', eq(3)
	mleval `ctrlsd' = `b', eq(4)

	qui replace `lnfj' = ///
		ln(normalden(`y',`ctrlcov',`ctrlsd')) if `d' == 0
	qui replace `lnfj' = ///
		ln(normalden(`y',`ctrlcov'+`casecov',`casesd')) if `d' == 1
	
	if (`todo'==0) {
		exit
	}

	qui replace `dcasecov' = 0 if `d' == 0
	qui replace `dcasesd' = 0 if `d' == 0
	qui replace `dctrlcov' = ///
		(`y' - `ctrlcov')/(`ctrlsd'^2) if `d' == 0
	qui replace `dctrlsd' = ///
		((`y'-`ctrlcov')^2)/(`ctrlsd'^3) - 1/`ctrlsd' if `d' == 0
	qui replace `dcasecov' = ///
		(`y'-`ctrlcov'-`casecov')/(`casesd'^2) if `d' == 1
	qui replace `dcasesd' = ///
		((`y'-`ctrlcov'-`casecov')^2)/(`casesd'^3) - 1/`casesd' ///
		if `d' == 1
	qui replace `dctrlcov' = ///
		(`y'-`ctrlcov'-`casecov')/(`casesd'^2) if `d' == 1
	qui replace `dctrlsd' = 0 if `d' == 1

	if (`todo' == 1) {
		exit
	}

	tempname ///
		d_casecov_casecov d_casesd_casesd d_ctrlcov_ctrlcov ///
		d_ctrlsd_ctrlsd ///
		d_casecov_casesd d_casecov_ctrlcov d_casecov_ctrlsd ///
		d_casesd_ctrlcov d_casesd_ctrlsd d_ctrlcov_ctrlsd 
		
	mlmatsum `lnfj' `d_casecov_casecov' = (-1/(`casesd'^2)) ///
		if `d'==1, eq(1,1)
	mlmatsum `lnfj' `d_casesd_casesd' = ///
		(-3*((`y'-`ctrlcov'-`casecov')^2)/ ///
		(`casesd'^4)+1/(`casesd'^2)) ///
		if `d'==1,eq(2)
	tempname dcca dccb
	mlmatsum `lnfj' `dcca' = (-1/(`casesd'^2)) if `d'==1, eq(3)
	mlmatsum `lnfj' `dccb' = (-1/(`ctrlsd'^2)) if `d'==0, eq(3)
	matrix `d_ctrlcov_ctrlcov' = `dcca'+`dccb'
	mlmatsum `lnfj' `d_ctrlsd_ctrlsd' = ///
		(-3*((`y'-`ctrlcov')^2)/(`ctrlsd'^4)+1/(`ctrlsd'^2)) ///
		if `d'==0,eq(4)
	mlmatsum `lnfj' `d_casecov_casesd' = ///
		-2*(`y'-`ctrlcov'-`casecov')/(`casesd'^3) /// 
		if `d'==1, eq(1,2)
	mlmatsum `lnfj' `d_casecov_ctrlcov' = (-1/(`casesd'^2)) ///
		if `d' == 1,eq(1,3)
	mlmatsum `lnfj' `d_casecov_ctrlsd' = 0 if `d' == 1, eq(1,4)
	mlmatsum `lnfj' `d_casesd_ctrlcov' = ///
		(-2*((`y'-`ctrlcov'-`casecov'))/(`casesd'^3)) ///
		if `d' == 1, eq(2,3)
	mlmatsum `lnfj' `d_casesd_ctrlsd' = 0 if `d' == 1, eq(2,4)
	mlmatsum `lnfj' `d_ctrlcov_ctrlsd' = ///
		(-2*(`y' - `ctrlcov')/(`ctrlsd'^3)) if `d' == 0, eq(3,4)

	matrix `H' = ///
		(`d_casecov_casecov',`d_casecov_casesd', ///
		`d_casecov_ctrlcov',`d_casecov_ctrlsd' \ ///
		`d_casecov_casesd'',`d_casesd_casesd', ///
		`d_casesd_ctrlcov', `d_casesd_ctrlsd' \ ///
		`d_casecov_ctrlcov'',`d_casesd_ctrlcov'', ///
		`d_ctrlcov_ctrlcov', `d_ctrlcov_ctrlsd' \ ///
		`d_casecov_ctrlsd'' , `d_casesd_ctrlsd'', ///
		`d_ctrlcov_ctrlsd'', `d_ctrlsd_ctrlsd')
end

exit
