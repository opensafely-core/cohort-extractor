*! version 1.0.0  05jun2013
program power_cmd_onecorr
	version 13

	syntax [anything] [, test * ]
	local type test
	pss_onecorr_`type' `anything', `options'
end

program pss_onecorr_test

	_pss_syntax SYNOPTS : onetest
	syntax [anything] ,	pssobj(string) 		///
			    [	`SYNOPTS'		///
				diff(string)		///
				*			///
			    ]
 
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything
	if ("`arg2'"=="") {
		local arg2 .
	}
	if ("`diff'"=="") {
		local diff .
	}
	mata:   							 ///
	  `pssobj'.init(`alpha', "`power'", "`beta'", "`n'",		 ///
			`arg1',`arg2',`diff');				 ///
	  `pssobj'.compute();						 ///
	  `pssobj'.rresults()
end
