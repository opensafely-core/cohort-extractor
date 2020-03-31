*! version 1.0.0  15mar2015
program _bayesmh_chk_corropts
	args corrlag corrtol
	cap confirm integer number `corrlag'
	local rc = _rc
	if (!`rc') {
		if (`corrlag' < 0) {
			local rc 198
		}
	}
	if `rc' {
		di as err "option {bf:corrlag()} must contain a " ///
			"nonnegative integer"
		exit `rc'
	}
	cap confirm number `corrtol'
	local rc = _rc
	if !`rc' {
		if (`corrtol' < 0 | `corrtol' > 1) {
			local rc 198
		}
	}
	if `rc' {
		di as err "option {bf:corrtol()} must contain a number " ///
			"between 0 and 1"
		exit `rc'
	}
end
