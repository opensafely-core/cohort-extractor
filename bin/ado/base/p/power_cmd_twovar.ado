*! version 1.0.0  05jun2013
program power_cmd_twovar
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_twovar_`type' `anything', `options'
end

program pss_twovar_test

	_pss_syntax SYNOPTS : twotest	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				ratio(string) 	///
				sd		///	
				*		///
			   ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything
	if ("`arg2'"=="") {
		local arg2 .
	}
	if ("`ratio'"=="") {
		local ratio .
	}
	
	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'",		///
				 "`n'","`n1'","`n2'", "`nratio'", 	///
				`arg1', `arg2' , `ratio');		///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
