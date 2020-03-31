*! version 1.0.8  10feb2020
program lasso
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

	if ("`e(cmd)'"! = "lasso") {
		di as err "results for {bf:lasso} not found"
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
						//  cmd
	local cmd cmd(lasso)
	local cmdline cmdline(lasso `0')
						//  check options
	CheckOpts , `options'
						//  parse weights	
	ParseWgt , wgt_type(`weight') wgt_exp(`exp')
	local wgt `s(wgt)'
						//  parse selection
	_lasso_parse_selection, `selection' `cmd'
	local selection `s(selection)'
	local alasso `s(alasso)'
	local seldefault `s(seldefault)'

						//  adding options
	local options `options' `selection' `cmd' `cmdline' `rngstate' ///
		`seldefault'

	/*------------------------- Estimation -----------------------------*/

	if ("`alasso'" == "") {			
						// case 1: non-adaptive lasso
		_pglm `anything' `if' `in' `wgt', `options'
	}
	else {					
						// case 2: adaptive lasso
		_adapt_pglm `anything' `if' `in', wgt(`wgt')	///
			alasso(`alasso') `options' 
	}
end
					//----------------------------//
					// Check options
					//----------------------------//
program CheckOpts
	syntax [, ALPHAs		///
		ALPHAs1(passthru)	///
		sqrt			///
		CV			///
		CV1(passthru)		///
		PLUGIN			///
		PLUGIN1(passthru)	///
		*]
	
	local extra `alphas' `alphas1' 	///
		`sqrt' `cv' `cv1' `plugin' `plugin1'
	
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
