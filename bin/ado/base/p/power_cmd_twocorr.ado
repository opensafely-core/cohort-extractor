*! version 1.0.0  05jun2013
program power_cmd_twocorr
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_twocorr_`type' `anything', `options'
end

program pss_twocorr_test

	_pss_syntax SYNOPTS : twotest
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				diff(string)	///
				*		///
			   ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything
	if ("`diff'"=="") local diff .
	if ("`arg2'"=="") local arg2 .

	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", 		///
				"`n'","`n1'","`n2'", "`nratio'", 	///
				`arg1', `arg2', `diff');		///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
