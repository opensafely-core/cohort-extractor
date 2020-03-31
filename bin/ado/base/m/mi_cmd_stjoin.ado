*! version 1.0.1  07may2009

/*
	mi stjoin ...
*/

program mi_cmd_stjoin
	version 11

	syntax [if], [noUPdate *]

	u_mi_assert_set
	check_assumptions

	u_mi_certify_data, acceptable proper `update'

	u_mi_xeq_on_tmp_flongsep: ///
		mi_sub_stjoin_flongsep `if', `options'
end

program check_assumptions
	capture noi novarabbrev confirm var _st
	if (_rc) {
		error_rest
		exit 111
	}
	if ("`_dta[st_id]'" == "") {
		di as err "id variable not {bf:stset}"
		error_rest
		exit 459
	}
	capture novarabbrev confirm var `_dta[st_id]'
	if (_rc) {
		di as err "{mf:stset} id variable `_dta[st_id]' not found"
		error_rest
		exit 111
	}
	capture novarabbrev confirm var _t0
	if (_rc) {
		di as err "{bf:stset} starting time variable _t0 not found"
		error_rest
		esit 111
	}
end

program error_rest
	di as err "{p 4 4 2}"
	di as err "data not {bf:stset} or not {bf:stset}"
	di as err "appropriately for use with {bf:stjoin}"
	di as err "{p_end}"
end
