*! version 1.0.1  15oct2019
program vwls_p

	version 10
	syntax [anything] [if] [in] , [ XB STDP ]

	if "`xb'`stdp'" == "" {
		di as text "(option {bf:xb} assumed; linear prediction)"
	}
	_predict `anything' `if' `in' , `xb' `stdp'
	
end

