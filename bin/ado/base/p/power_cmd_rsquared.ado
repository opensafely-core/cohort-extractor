*! version 1.0.0  19oct2016
program power_cmd_rsquared
	version 15

	syntax [anything] [, test NControl(string) * ]
	local type `test'
	if ("`ncontrol'"=="") {
		pss_regrsqall_`test' `anything', `options' 
	}
	else {
		pss_regrsqsub_`test' `anything', `options'  ncontrol(`ncontrol')
	}	
	
end

program pss_regrsqsub_test

	_pss_syntax SYNOPTS : onetest

    syntax [anything] , pssobj(string)                              ///
                                        [       `SYNOPTS'               ///
                                                diff(string)      ///
                                                NTESTed(string)         ///
                                                NControl(string)        ///
                                                *                       ///
                                        ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	if ("`diff'"=="")	local diff .
	if ("`arg1'"=="") 	local arg1 .
	if ("`arg2'"=="") 	local arg2 .

	if ("`ntested'"=="")	local ntested .
	if ("`ncontrol'"=="")	local ncontrol .
	

	mata:   `pssobj'.init(`alpha', "`power'", "`beta'", "`n'",	///
				`arg1', `arg2', `diff', `ntested', ///
				`ncontrol'); 			///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end


program pss_regrsqall_test

	_pss_syntax SYNOPTS : onetest
	syntax [anything] , pssobj(string)                              ///
                                        [       `SYNOPTS'               ///
                                                NTESTed(string)         ///
                                                *                       ///
                                        ]
	gettoken arg1 anything : anything



	if ("`arg1'"=="") 	local arg1 .
	if ("`ntested'"=="")	local ntested .	

	local diff .
	local arg2 .
	local ncontrol .
	
	mata:   `pssobj'.init(`alpha', "`power'", "`beta'", "`n'",	///
				`arg1', `arg2', `diff', `ntested', ///
				`ncontrol'); 			///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
