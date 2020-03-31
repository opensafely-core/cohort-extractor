*! version 1.0.1  07jul2003
program define _gs_default_bands
	args bmac colon bands

	if `bands' < 0 {
		local bands = round(					///
				min(					///
				   10 * log10(0`:serset N') , 		///
				   sqrt(0`:serset N') 			///
				)					///
			      , 1)

		local bands = max(`bands', min(`:serset N', 2))

		if `bands' >= . {
			local bands = 10
		}
	}

	c_local `bmac' `bands'
end
