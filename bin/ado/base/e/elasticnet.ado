*! version 1.0.10  10feb2020
program elasticnet
	version 16.0

	if replay() {
		Playback `0'
	}
	else {
		Estimate `0'
	}
end

					//----------------------------//
					// play back result
					//----------------------------//
program Playback 
	syntax [, *]

	if ("`e(cmd)'"! = "elasticnet") {
		di as err "results for {bf:elasticnet} not found"
		exit 301
	}
	else {
		_pglm_display `0'
	}
end
					//----------------------------//
					// Estimate
					//----------------------------//
program Estimate
						// if weight, must specify type	
	_lasso_check_weight `0'

	syntax anything			///
		[if] [in]		///
		[fw iw]			///
		[, SELection(passthru)	///
		ALPHAs(passthru)	///
		reestimate(string)	///
		rseed(passthru)		///
		*]

	if (`"`reestimate'"' != "") {
		_lasso_repost, `reestimate'
		exit
		// NotReached
	}

	/*------------------------- syntax parsing -------------------------*/
						// rseed
	_lasso_rseed, `rseed'
						// rngstate
	_lasso_rngstate 
	local rngstate `s(rngstate)'
						//  parse alphas 	
	_pglm_parse_enpenalty, `alphas' 
	local n_alpha = `r(n_alpha)'
	local enp `r(enp)'
						//  cmd
	local cmd cmd(elasticnet)
	local cmdline cmdline(elasticnet `0')
						//  check options
	CheckOpts , `options'
						//  parse weights	
	ParseWgt , wgt_type(`weight') wgt_exp(`exp')
	local wgt `s(wgt)'
						//  parse selection
	_lasso_parse_selection, `selection' `cmd'
	local selection `s(selection)'
	local seldefault `s(seldefault)'
						//  adding options
	local options `options' `selection' `cmd' `cmdline' `rngstate'	///
		`seldefault'

	/*------------------------- Estimation -----------------------------*/

	if (`n_alpha' == 1) {
		_pglm `anything' `if' `in' `wgt', alphas(`enp') `options'
	}
	else {
		_mult_enet `anything' `if' `in' , wgt(`wgt') 	///
			enp(`enp') `options' 
	}

end
					//----------------------------//
					// Check options
					//----------------------------//
program CheckOpts
	syntax [,sqrt			///
		CV			///
		CV1(passthru)		///
		PLUGIN			///
		PLUGIN1(passthru)	///
		*]
	
	local extra `sqrt' `cv' `cv1' `plugin' `plugin1'

	local extra = subinstr(`"`extra'"', "1(", "(", .)
	
	if (`"`extra'"' != "") {
		di as err "option {bf:`extra'} not allowed"
		exit 198
	}
end

					//----------------------------//
					// parse weight
					//----------------------------//
program ParseWgt, sclass
	syntax [, wgt_type(string) wgt_exp(string)]

	if (`"`wgt_type'"' != "") {
		local wgt [`wgt_type'`wgt_exp']
	}

	sret local wgt `wgt'
end
