*! version 1.0.0  21mar2017
program _irtrsm_check, rclass
	version 14
	local models `e(model_list)'
	local hasrsm : list posof "rsm" in models
	if `hasrsm' & missing(e(irt_version)) {
		di as err "Your model uses an outdated version of irt rsm."
		di as err "Re-estimate your irt model to obtain the " ///
			"updated results."
		exit 198
	}
	return scalar hasrsm = `hasrsm'
end

