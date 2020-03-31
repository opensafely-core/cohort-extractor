*! version 1.0.3  23mar2017
// _spivreg is used by both spregress.ado and spivregress.ado, it only provides
// estimation and post results

program define _spivreg
	version 15.0
	
	tempname SPREG MLOPT
	capture noi Estimate `SPREG' `MLOPT' : `0'
	local rc = _rc
	capture mata : rmexternal("`SPREG'")
	capture mata : rmexternal("`MLOPT'")
	capture drop `SPREG'*
	if (`rc'!=0) exit `rc'
end
					//-- Estimate --//
program Estimate
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'
	
	local SPREG : word 1 of `before'
	local MLOPT : word 2 of `before'
	
	local 0 `after'
	syntax anything [if] [in] [,*]
	marksample touse
						// parse syntax
	_spivreg_parse `SPREG' `MLOPT', 	///
		touse(`touse') 			///
		: `0'
						// Fit the model
	mata : _st_SPREG__fit("`SPREG'", "`MLOPT'")
						// post results
	_spivreg_ereturn `SPREG'
						// compute pseudo R-squared and
						// test statistics
 	_spreg_pseudor2
end
