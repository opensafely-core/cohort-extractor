*! version 1.0.1  10feb2020
program _lasso_check_weight
	version 16.0

	cap syntax [anything] [if] [in] [fw iw/] [, *]
	local wgt1 = `"`weight'"'

	cap syntax [anything] [if] [in] [iw fw/] [, *]
	local wgt2 = `"`weight'"'
	local rc = _rc

	if (`rc') {
		cap noi syntax [anything] [if] [in] [iw fw/] [, *]
		exit `rc'
		// NotReached
	}

	if (`"`wgt1'"' != `"`wgt2'"') {
		di as err "default weights are not supported: you must " ///
			"specify one of {bf:fweight} or {bf:iweight}"
		exit 198
	}
end
