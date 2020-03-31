*! version 1.0.5  13may2019
program dspoisson
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

	if ("`e(cmd)'"! = "dspoisson") {
		di as err "results for {bf:dspoisson} not found"
		exit 301
	}
	else {
		_dslasso_display `0'
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
	local cmd cmd(dspoisson)
	local model model(poisson)
	local zero zero(`0')

	_dsregress_parse `eq' 	///
		`if' `in' 	///
		, `controls' 	///
		`vce' 		///
		`constant' 	///
		`selection'	///
		`grid'		///
		`sqrtlasso'	///
		`debug'		///
		`cmd'		///
		`model'		///
		`zero'		///
		`tolerance'	///
		`options'
	local opts `s(opts)'

	/*----------------- estimation ------------------------------*/
	_dslasso `eq' `if' `in', `opts'
end

