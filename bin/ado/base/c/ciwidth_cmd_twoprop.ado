*! version 1.1.0  11jan2019
program ciwidth_cmd_twoprop
	version 16

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	pss_twoprop_`type' `anything', `options'
end


program pss_twoprop_ci

	local clu_opt cluster k1(string) k2(string) kratio(string) ///
		m1(string) m2(string) mratio(string) ///
			rho(string) CVCLuster(string)
	_pss_syntax SYNOPTS : twoci	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				parameter(string)	///
				citype(string)	///
				CONTINuity	///
				ADDHALF		///
				`clu_opt'		///
				*		///
			   ]

	gettoken arg1 anything : anything
	gettoken arg2 anything : anything


	if ("`arg1'"=="") {
		local arg1 .
	}

	if ("`arg2'"=="") {
		local arg2 .
	}
	
	if ("`width'"=="") local width .
	if ("`hwidth'"=="") local hwidth .
	
	// cluster specific options
	if ("`k1'"=="") local k1 .
	if ("`m1'"=="") local m1 .
	if ("`k2'"=="") local k2 .
	if ("`m2'"=="") local m2 .
	if ("`kratio'" == "") local kratio .
	if ("`mratio'" == "") local mratio .
	if ("`rho'"=="") local rho .
	if ("`cvcluster'"=="") local cvcluster .
	
	mata:   `pssobj'.init(  "`level'", "`alpha'", `width', `hwidth', ///
				"`n'","`n1'","`n2'", "`nratio'", 	///
				`arg1', `arg2', ///
				`k1', `k2', `kratio', `m1', `m2', `mratio', ///
				 `rho', `cvcluster'			); ///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end

