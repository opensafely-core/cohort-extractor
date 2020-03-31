*! version 1.1.0  21jun2018
program xtstreg_p
	version 14
	local vv : di "version " string(_caller()) ", missing:"

	if "`e(cmd2)'" != "xtstreg" {
		di "{err}last estimates not found"
		exit 198
	}
	
	syntax  anything 				///
		[if] [in] [, 				///
		mean					///
		Surv					///
		HAzard					///
		mean0					///
		median0					///
		surv0					///
		hazard0					///
		xb					///
		stdp					///
		noOFFset				///
		]

	local	pred	`mean'		///
			`surv'		///
			`hazard'	///
			`mean0'		///
			`median0'	///
			`surv0'		///
			`hazard0'	///
			`xb'		///
			`stdp'
	opts_exclusive "`pred'"

	if "`mean0'" != "" {
		local pred mean
		local cond conditional(fixedonly)
	}
	if "`mean'" != "" {
		local pred mean
		local cond marginal
	}
	if "`median0'" != "" {
		local pred median
		local cond conditional(fixedonly)
	}
	if "`surv0'" != "" {
		local pred surv
		local cond conditional(fixedonly)
	}
	if "`surv'" != "" {
		local pred surv
		if _caller() > 14 local cond marginal
		else local cond conditional(fixedonly)
	}
	if "`hazard0'" != "" {
		local pred hazard
		local cond conditional(fixedonly)
	}
	if "`hazard'" != "" {
		local pred hazard
		if _caller() > 14 local cond marginal
		else local cond conditional(fixedonly)
	}

	if "`pred'" == "" {
		di "{txt}(option {bf:xb} assumed; linear prediction)"
		local pred xb
	}
	
	`vv' mestreg_p `anything' `if' `in' , `pred' `cond' `offset'
	
	gettoken sttyp newvar : anything
	if missing("`newvar'") local newvar `sttyp'

	if "`median0'" != "" {
		lab var `newvar' "Predicted median, assuming u_i=0"
	}
	if "`hazard0'" != "" {
		lab var `newvar' "Predicted hazard, assuming u_i=0"
	}
	if "`surv0'" != "" {
		lab var `newvar' "Predicted survival, assuming u_i=0"
	}
	if "`pred'"=="stdp" {
		lab var `newvar' "S.E. of the linear prediction"
	}

end
exit
