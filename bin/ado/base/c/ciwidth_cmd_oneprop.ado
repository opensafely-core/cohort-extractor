*! version 1.1.0  11jan2019
program ciwidth_cmd_oneprop
	version 16

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	pss_oneprop_`type' `anything', `options'
end

program pss_oneprop_ci

	local clu_opt cluster k(string) m(string) rho(string) CVCLuster(string)
	
	_pss_syntax SYNOPTS : oneci
	syntax [anything] , 	pssobj(string)			/// 
			    [ 	`SYNOPTS'			///
				citype(string)			///
				CONTINuity			///
				`clu_opt'			///
    				*				/// 
			    ]
 
	gettoken arg1 anything : anything

	// cluster specific options
	if ("`k'"=="") local k .
	if ("`m'"=="") local m .
	if ("`rho'"=="") local rho .
	if ("`cvcluster'"=="") local cvcluster .

	if ("`width'"=="") local width .
	if ("`hwidth'"=="") local hwidth .
	
	mata:   `pssobj'.init( "`level'","`alpha'",`width', `hwidth', "`n'", ///
				`arg1',	///
				`k', `m', `rho', `cvcluster');    	///
		`pssobj'.compute();				     	///
		`pssobj'.rresults()
end


