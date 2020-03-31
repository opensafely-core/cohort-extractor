*! version 1.0.1  30nov2018
program define xtdpd_p, sortpreserve

	version 10

        if "`e(cmd)'" != "xtdpd"      &	///
	   "`e(cmd)'" != "xtabond"    &	///
	   "`e(cmd)'" != "xtdpdsys"   & ///
	   "`e(engine)'" != "xtdpd"  {
	   	di "{err}last estimates not found"
                exit 301
        }

	syntax newvarname [if] [in],		///
		[				///
		DIfference 			///
		Level 				///
		xb 				///
		e				///
		stdp				///
		]


	local myopts "xb e stdp"	
	local spec "`xb' `e' `stdp'"

	local nopts : word count `spec'

	if `nopts' > 1 {
		if `nopts' == 3 {
			di "{err}specify only one of the options "	///
				"{cmd:xb}, {cmd:e}, or {cmd:stdp}"
			exit 198	
		}

		if `nopts' == 2 {
			local opt1 : word 1 of `spec'
			local opt2 : word 2 of `spec'
			di "{err}specify {cmd:`opt1'} or {cmd:`opt2'}, not both"
			exit 198
		}
	}

	if "`difference'" != "" & "`level'" != "" {
		di "{err}specify {cmd:difference} or {cmd:level}, not both"
		exit
	}	

	if "`e'`xb'`stdp'" == "" {
		di "{txt}(option {bf:xb} assumed; fitted values)"
		local xb xb
	}

	local func `xb'`e'`stdp'

	if "`difference'" == "" {
		local type level
	}
	else {
		local type difference
	}

	if "`type'" == "difference" {
		tempvar work
		local transform "difference"
		qui _predict double `work' , xb
		if "`func'" == "xb" {
			gen `typlist' `varlist' = D.`work' `if' `in'
			label variable `varlist' ///
			"First-differenced linear prediction"
		}
		else if "`func'" == "e" {
			tempvar work2 
			qui gen double `work2' = `e(depvar)' - `work' 
			gen `typlist' `varlist' = D.`work2' `if' `in'
			label variable `varlist' ///
			"First-differenced residuals"
		}
		else {  // "`func'" == "stdp"
			di "{err}{cmd:stdp} not allowed with "	///
				"{cmd:difference}"
			exit 198	
		}
	}
	else {
		local transform "level"
		if "`func'" == "xb" {
			_predict `typlist' `varlist' `if' `in' , xb
		}
		else if "`func'" == "e" {
			tempvar work
			qui _predict double `work' , xb
			gen `typlist' `varlist' = `e(depvar)' - `work' `if' `in'
			label variable `varlist' "Residuals"
		}
		else {  // "`func'" == "stdp"
			_predict `typlist' `varlist' `if' `in' , stdp
		}
	}

end
