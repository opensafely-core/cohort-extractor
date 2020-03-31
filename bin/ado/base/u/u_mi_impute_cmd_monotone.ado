*! version 1.0.2  13oct2015
program u_mi_impute_cmd_monotone, eclass
	version 12
	args impobj keq estfile ivars force
	local k $MI_IMPUTE_kgroup
	if ("`k'"=="") {
		local k 1
	}	
	tokenize `ivars'
	local haserr 0
	forvalues i=1/`keq' {
		qui estimates use `estfile', number(`i')
		// resets conditional sample after conditioning variables 
		// are imputed
		cap noi u_mi_impute_cmd__uvmethod_init 		///
				${MI_IMPUTE_uvinit`k'_`i'}	///
				"monotone" "" "" "setuponly"
		local rc = _rc
		if `rc' {
			global MI_IMPUTE_badivars ``i''
			mata: `impobj'.updateNimp()
			exit `rc'
		}
		// performs imputation
		cap noi u_mi_impute_cmd__uvmethod ${MI_IMPUTE_uvimp`k'_`i'}
		local rc = _rc
		if (`rc'==504 | `rc'==459) { 
			if ("`force'"=="") {
				mata: `impobj'.updateNimp()
				global MI_IMPUTE_badivars ``i''
				exit 459
			}
			local ++haserr
		}
		else if `rc' {
			exit `rc'
		}
	}
	mata: `impobj'.updateNimp()
	if (`haserr') { 
		// so that imp. dots are displayed as x if imputed missing
		// values produced	
		exit 459
	}
end
