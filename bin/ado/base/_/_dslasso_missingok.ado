*!version 1.0.0  04jun2019
program _dslasso_missingok
	version 16.0

	syntax , touse(string)		///
		[depvar(string)		///
		dvars(string)		///
		nuisance(string) 	///
		missingok]	
	

	if (`"`missingok'"' != "") {
		markout `touse' `depvar' `dvars'
	}
	else {
		markout `touse' `depvar' `dvars' `nuisance'
	}
end
