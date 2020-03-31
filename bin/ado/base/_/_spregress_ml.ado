*! version 1.0.5  28mar2017
program define _spregress_ml, eclass
	version 15.0

	tempname SPREG MLOPT
	capture noi Estimate `SPREG' `MLOPT' : `0'
	local rc = _rc
	capture mata : rmexternal("`SPREG'")
	capture mata : rmexternal("`MLOPT'")
	capture drop `SPREG'*
	if (`rc'!=0) exit `rc'

	eret local predict spregress_p
	eret local estat_cmd spregress_estat
	eret local cmdline spregress `0'
	eret local estimator ml
	eret local marginsok RForm xb direct indirect
	eret local marginsnotok LImited FULL NAive
	eret local cmd spregress
end

program Estimate, eclass
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'
	
	local SPREG : word 1 of `before'
	local MLOPT : word 2 of `before'
	
	local 0 `after'
	syntax anything [if] [in] [,*]
	marksample touse
						// parse syntax
	tempname cns 
	_spreg_ml_parse `SPREG' `MLOPT', 	///
		touse(`touse')  		///
		cns(`cns')			///
		: `0'
						// Fit and post results
	mata : _st_SPREG_ML__fit("`SPREG'")
						// compute pseudo R-squared and
						// test statistics
 	_spreg_pseudor2
end
