*! version 1.0.0  29nov2016

program _mcmc_definename, sclass
	
	args label
	
	local varname ""
	local i 0
	while "`varname'" == "" {
		capture confirm variable _lvar_`label'_`i'
		if (_rc==111) {
			local varname _lvar_`label'_`i'
			continue
		}
		local ++i
		if (`i'>=999) {
			di as err "{p 0 0 2}"
			di as err "could not find a name for temporary variable"
			di as err "{p_end}"
			di as err "{p 4 4 2}"
			di as err "I tried _lvar_`label'_0 through _lvar_`label'_`i'."
			di as err "{p_end}"
			exit 603
		}
	}

	sreturn local define `varname'
end
