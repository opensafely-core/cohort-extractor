*! version 1.0.0  11jan2019
program ciwidth_cmd_onemean
	version 13

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	pss_onemean_`type' `anything', `options'
end

program pss_onemean_ci

	local clu_opt cluster k(string) m(string) rho(string) CVCLuster(string)
	
	_pss_syntax SYNOPTS : oneci
	syntax [anything],	pssobj(string) 		///
			    [	`SYNOPTS'		///
				sd(real 1)		///
				probwidth(string)	///
				KNOWNSD			///
				NORMAL			/// //undoc.
				fpc(string)		///
				`clu_opt'		///
				*			///
			    ]


	gettoken arg1 anything : anything
	
	if ("`fpc'"=="") local fpc .
	if ("`width'"=="") local width .
	if ("`hwidth'"=="") local hwidth .
	if ("`probwidth'"=="") local probwidth .
	
	// cluster specific options
	if ("`k'"=="") local k .
	if ("`m'"=="") local m .
	if ("`rho'"=="") local rho .
	if ("`cvcluster'"=="") local cvcluster .

	if ("`arg1'"=="") local arg1 .

	mata:   `pssobj'.init(  "`level'", "`alpha'", ///
		`width', `hwidth', `probwidth', `arg1', "`n'", ///
				`sd',`fpc', ///
				`k', `m', `rho', `cvcluster');    	///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
