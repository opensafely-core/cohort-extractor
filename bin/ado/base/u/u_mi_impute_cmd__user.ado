*! version 1.0.0  26oct2015
program u_mi_impute_cmd__user
	local version : di "version " string(_caller()) ":"
	version 14.0
	local method $MI_IMPUTE_user_method
	local impobj $MI_IMPUTE_obj.Imp
	if ("$MI_IMPUTE_user_fillmissing"!="nofillmissing") {
		mata: `impobj'.fillmis()
	}
	cap noi `version' mi_impute_cmd_`method', $MI_IMPUTE_user_options
	local rc = _rc
	local nivars $MI_IMPUTE_user_k_ivarsinc
	forvalues i=1/`nivars' {
		local ivar ${MI_IMPUTE_user_ivar`i'}
		local missid ${MI_IMPUTE_user_miss`i'}
		 mata: ///
`impobj'.pImpClsInc[`i']->updateNimp(st_data(.,"`ivar'","`missid'"))
	}
	mata: `impobj'.updateNimp()
	if (`rc') {
		di as err "in program {bf:mi_impute_cmd_`method'}"
		exit `rc'
	}
	global MI_IMPUTE_badivars
	forvalues i=1/`nivars' {
		local ivar ${MI_IMPUTE_user_ivar`i'}
		local missid ${MI_IMPUTE_user_miss`i'}
		qui count if `ivar'==. & `missid'
		if (r(N)>0) {
			global MI_IMPUTE_badivars $MI_IMPUTE_badivars `ivar'
		}
	}
	if ("$MI_IMPUTE_badivars"!="") {
		exit 459
	}
end
