*! version 1.0.0  05jun2013
program power_cmd_onevar
	version 13

	syntax [anything] [, test * ]
	local type test
	pss_onevar_`type' `anything', `options'
end

program pss_onevar_test

	_pss_syntax SYNOPTS : onetest
	syntax [anything] ,	pssobj(string) 		///
			    [	`SYNOPTS'		///
				ratio(string)		///
				sd			///
				NORMAL			/// //undoc.
				*			///
			    ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	if ("`arg2'"=="") {
		local arg2 .
	}
	if ("`ratio'"=="") {
		local ratio .
	}

	mata: `pssobj'.init(`alpha', "`power'", "`beta'", "`n'", 	///
			    `arg1', `arg2', `ratio');			///
	      `pssobj'.compute();					///
	      `pssobj'.rresults()
end
