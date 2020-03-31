*! version 1.0.1  15jun2007
program define ml_elf_cycle, rclass
	version 8.0
	args calltype
	// no need to check memory requirements
	if (`calltype' == -1) exit

	local i  = $ML_tnqi		// index for current technique
	local ti : word `i' of $ML_tnql	// current technique name
	local ki : word `i' of $ML_tnqk	// max steps in current technique
	local k  : word count $ML_tnql	// number of techniques
	local j  = $ML_tnqj		// step in current technique

	if inlist("`ti'","bfgs","dfp") {
		global ML_noinv "noInvert"
	}
	else	global ML_noinv
	if "`ti'" == "nr" {
		local eval ml_elf
		local name = "Newton-Raphson"
	}
	else {
		local eval ml_elf_`ti'
		local name = upper("`ti'")
	}
	if $ML_trace != 0 & `calltype' > 0 & `j' == 1 {
		if $ML_ic == 0 {
			di as txt "(setting optimization to `name')"
		}
		else	di as txt "(switching optimization to `name')"
	}

	// call likelihood evaluator for the current technique
	`eval' `calltype'

	// next step
	if `calltype' > 0 {
		global ML_tnqj = mod(`j',`ki')+1
		if $ML_tnqj == 1 {
			// next technique
			global ML_tnqi = mod(`i',`k')+1
		}
	}

					/* Save current Beta and gradient */
	if "$ML_noinv" == "" & `calltype' > 0 & !missing(scalar($ML_f)) {
		matrix $ML_dfp_b = $ML_b
		matrix $ML_dfp_g = $ML_g
	}
end
exit

