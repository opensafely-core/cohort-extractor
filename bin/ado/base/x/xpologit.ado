*! version 1.0.5  13may2019
program xpologit
	version 16.0

	syntax [anything(everything)] [, reestimate *]

	if (replay() & `"`reestimate'"' == "") {
		Playback `0'	
	}
	else  {
		Estimate `0'
	}
end
					//----------------------------//
					// play back result
					//----------------------------//
program Playback 
	syntax [, *]

	if ("`e(cmd)'"! = "xpologit") {
		di as err "results for {bf:xpologit} not found"
		exit 301
	}
	else {
		_polasso_display `0'
	}
end
					//----------------------------//
					// estimate
					//----------------------------//
program Estimate
	syntax [anything(name=eq)]	///
		[if] [in]		///
		[, CONTrols(passthru)	///	
		vce(passthru)		///
		noconstant		///	common_opts
		SELection(passthru)	///
		grid(passthru)		///
		SQRTlasso		///
		TOLerance(passthru)	///
		debug			///	NotDoc
		*]			//	advanced options
	
	/*----------------- parsing -------------------------------*/
	local cmd cmd(xpologit)
	local model model(logit)
	local zero zero(`0')

	_dsregress_parse `eq' 		///
		`if' `in' 		///
		, `controls' 		///
		`vce' 			///
		`constant' 		///
		`selection'		///
		`grid'			///
		`sqrtlasso'		///
		`debug'			///
		`cmd'			///
		`model'			///
		`zero'			///
		`tolerance'		///
		gmm			///
		`options'
	local opts `s(opts)'

	/*----------------- estimation -------------------------------*/
	_polasso `eq' `if' `in' , `opts'
end
