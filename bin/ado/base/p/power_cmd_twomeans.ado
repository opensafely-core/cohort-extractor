*! version 1.1.0  09dec2016
program power_cmd_twomeans
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_twomeans_`type' `anything', `options'
end

program pss_twomeans_test

	local clu_opt cluster k1(string) k2(string) kratio(string) ///
		m1(string) m2(string) mratio(string) ///
			rho(string) CVCLuster(string)
	_pss_syntax SYNOPTS : twotest	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				diff(string) 	///
				sd1(string)	///
				sd2(string)	///
				sd(string)	///
				KNOWNSDs	///
				NORMAL		/// //undoc.
				welch		/// //undoc.
				`clu_opt'		///
				*		///
			   ]
	if ("`knownsds'"!="") local normal normal
	
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	if ("`arg1'"=="") {
		local arg1 = .
	}
	if ("`diff'"=="") {
		local diff = .
	}
	if ("`arg2'"=="") {
		local arg2 = .
	}

	if ("`sd'"=="") {
		if ("`sd1'"=="" & "`sd2'"=="") {
			local sd 1
			local sd1 .
			local sd2 .
		}
		else local sd .	
	}
	else {
		local sd1 .
		local sd2 .
	}
	
	// cluster specific options 
	if ("`k1'"=="") local k1 .
	if ("`m1'"=="") local m1 .
	if ("`k2'"=="") local k2 .
	if ("`m2'"=="") local m2 .
	if ("`kratio'" == "") local kratio .
	if ("`mratio'" == "") local mratio .
	if ("`rho'"=="") local rho .
	if ("`cvcluster'"=="") local cvcluster .
	
	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", 		///
				"`n'","`n1'","`n2'", "`nratio'", 	///
				`arg1',`arg2',`diff',`sd',`sd1',`sd2',  ///
				`k1', `k2', `kratio', `m1', `m2', `mratio', ///
				 `rho', `cvcluster'			); ///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
