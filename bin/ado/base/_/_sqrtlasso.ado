*! version 1.0.8  10feb2020
program _sqrtlasso
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

	if ("`e(cmd)'"! = "sqrtlasso") {
		di as err "results for {bf:sqrtlasso} not found"
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
	local cmd cmd(sqrtlasso)
						//  cmdline
	gettoken tmp zero : 0
	local cmdline cmdline(sqrtlasso `zero')
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
	local options `options' `selection' `cmd' sqrt `cmdline' `rngstate' ///
		`seldefault'

	/*------------------------- Estimation -----------------------------*/
	_pglm `anything' `if' `in' `wgt', `options'
end
					//----------------------------//
					// Check options
					//----------------------------//
program CheckOpts
	syntax [, ALPHAS		///
		ALPHAS1(passthru)	///
		CV			///
		CV1(passthru)		///
		PLUGIN			///
		PLUGIN1(passthru)	///
		CDUPDATE		///
		CDUPDATE1(passthru)	///
		*]
	
	local extra `alphas' `alphas1' 		///
		`plugin' `plugin1' 		///
		`cdupdate' `cdupdate1'		///
		`cv' `cv1' 			

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
