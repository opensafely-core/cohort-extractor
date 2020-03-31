*! version 1.1.0  12nov2016
program power_cmd_onemean
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_onemean_`type' `anything', `options'
end

program pss_onemean_test

	local clu_opt cluster k(string) m(string) rho(string) CVCLuster(string)
	
	_pss_syntax SYNOPTS : onetest
	syntax [anything] ,	pssobj(string) 		///
			    [	`SYNOPTS'		///
				diff(string)		///
				sd(real 1)		///
				KNOWNSD			///
				NORMAL			/// //undoc.
				fpc(string)		///
				`clu_opt'		///
				*			///
			    ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	if ("`diff'"=="") local diff .
	else if ("`arg1'"=="") local arg1 0

	if ("`arg2'"=="") local arg2 .

	if ("`fpc'"=="") local fpc .
	
	// cluster specific options
	if ("`k'"=="") local k .
	if ("`m'"=="") local m .
	if ("`rho'"=="") local rho .
	if ("`cvcluster'"=="") local cvcluster .
	

	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", "`n'",	///
				`arg1',`arg2', `diff',`sd',`fpc', ///
				`k', `m', `rho', `cvcluster');    	///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
