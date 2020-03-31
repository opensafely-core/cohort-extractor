*! version 1.0.6  13may2019
program popoisson
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

	if ("`e(cmd)'"! = "popoisson") {
		di as err "results for {bf:popoisson} not found"
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
		XFOLDs(integer 1)	///	NotDoc
		resample(integer 1)	///	NotDoc
		*]			//	advanced options
	
	/*----------------- parsing -------------------------------*/
	local cmd cmd(popoisson)
	local model model(poisson)
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
		xfolds(`xfolds')	///
		resample(`resample')	///
		gmm			///
		`options'
	local opts `s(opts)'

	/*----------------- estimation -------------------------------*/
	_polasso `eq' `if' `in' , `opts'
end
