*! version 1.0.0  08dec2016
program power_cmd_pcorr
	version 15

	syntax [anything] [, test * ]
	local type `test'
	pss_pcorr_`test' `anything', `options'
end

program pss_pcorr_test

	_pss_syntax SYNOPTS : onetest
	syntax [anything] , pssobj(string)                              ///
                                        [       `SYNOPTS'               ///
                                                NTESTed(string)         ///
					        NControl(string)        ///
                                                *                       ///
                                        ]
	gettoken arg1 anything : anything

	if ("`arg1'"=="") 	local arg1 .
	if ("`ntested'"=="")	local ntested .	
	if ("`ncontrol'"=="")	local ncontrol .	

	local rsqdiff .
	local arg2 .
	
	mata:   `pssobj'.init(`alpha', "`power'", "`beta'", "`n'",	///
				`arg1', `arg2', `rsqdiff', `ntested', ///
				`ncontrol'); 			///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
