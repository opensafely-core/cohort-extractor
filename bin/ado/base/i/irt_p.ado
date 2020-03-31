*! version 1.1.0  21mar2017
program irt_p, eclass
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	
	if "`e(cmd)'" != "irt" & "`e(cmd2)'" != "irt" {
		di "{err}last estimates not found"
		exit 198
	}
	
	_irtrsm_check
	local hasrsm `r(hasrsm)'
	
	syntax  anything(id="stub* or newvarlist") 	///
		[if] [in] [,				///
		pr					///
		xb					///
		latent					///
		SCores					///
		outcome(passthru)			///
		CONDitional1(string)			///
		CONDitional				///
		UNCONDitional				/// undocumented
		MARGinal				///
		EBMEANs					///
		EBMODEs					///
		se(passthru)				///
		INTPoints(passthru)			///
		TOLerance(passthru)			///
		ITERate(passthru)			///
	]

	local empty = missing("`pr'`xb'`latent'`scores'")
	if `empty' {
		di "{txt}(option {bf:pr} assumed)"
		syntax anything(id="stub* or newvarlist") [if] [in] [, *]
		local 0 `anything' `if' `in', `options' pr
	}
	
	if `hasrsm' {
		preserve, changed
		_irtrsm_one
		capture noi `vv' gsem_p `0'
		local rc = _rc
		capture drop _one
		if `rc' {
			exit `rc'
		}
	}
	else {
		`vv' gsem_p `0'
	}

end

exit

