*! version 1.0.0  10may2011
program mi_cmd_predict
	local version : di "version " string(_caller()) ":"

	version 12

	u_mi_assert_set

	_parse comma lhs rhs : 0
	u_mi_certify_data, acceptable	// ensure mi data are acceptable
	local 0 `rhs'
	syntax [, NOUPdate * ]
	if ("`noupdate'"=="") { 	// make mi data proper
		u_mi_certify_data, proper
	}

	local style `_dta[_mi_style]'
	if ("`style'"=="flongsep") {
		local mixeq u_mi_xeq_on_tmp_flongsep :
	}
	`mixeq' `version' u_mi_predictions `lhs', `options' predcmd(predict)

end
