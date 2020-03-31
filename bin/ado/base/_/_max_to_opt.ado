*! version 1.1.0  17apr2018
program define _max_to_opt
	version 11

	syntax [, 	NOLOg LOg			///
			TRace 				///
			GRADient 			///
			HESSian 			///
			showstep 			///
			SHOWNRtolerance			///
			SHOWTOLerance			///
			TOLerance(numlist max=1 >0)	///
			LTOLerance(numlist max=1 >0)	///
			NRTOLerance(numlist max=1 >0)	///
			DIFFicult			///
			GTOLerance(numlist max=1 >0)	///
		]

// There is no option for NONRTOLerance
// because there is no corresponding option in Mata optimize()


	if "`nolog'" == "nolog" {
		local tlevel none
	}
	else if "`hessian'" != "" {
		local tlevel hessian
	}
	else if "`gradient'" != "" {
		local tlevel gradient
	}
	else if "`showstep'" != "" {
		local tlevel step
	}
	else if "`trace'" != "" {
		local tlevel params
	}
	else if "`shownrtolerance'" != "" | "`showtolerance'" != "" {
		local tlevel tolerance
	}
	else if ("`log'" == "" & c(iterlog)=="off") {
		local tlevel none
	}
	else {
		local tlevel value
	}

	c_local opts_tl `tlevel'

	if "`tolerance'" != "" {
		c_local opts_ptol "`tolerance'"
	}	

	if "`ltolerance'" != "" {
		c_local opts_vtol "`ltolerance'"
	}	

	if "`gtolerance'" != "" {
		di "{txt}{cmd:gtolerance()} ignored because it is "	///
			"not supported by {help mf_optimize:Mata optimize()}"
	}	

	if "`nrtolerance'" != "" {
		c_local opts_nrtol "`nrtolerance'"
	}	

	if "`difficult'" != ""  {
		c_local opts_shm   "hybrid"

	}

end
