*! version 1.0.1  09dec2016
program power_cmd_logrank
	version 14

	syntax [anything] [, test * ]
	local type `test'
	pss_logrank_`type' `anything', `options'
end

program pss_logrank_test

	local clu_opt cluster k1(string) k2(string) kratio(string) ///
		m1(string) m2(string) mratio(string) ///
			rho(string) CVCLuster(string)
	_pss_syntax SYNOPTS : twotest	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				HRatio(string)	///
				LNHRatio(string) ///
				SCHoenfeld 	///
				WDProb(string) 	///
				effect(string)  ///
				p1(string)	///	//undocumented
				`clu_opt'		///
				*		///
			   ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything
	
	if (`"`arg1'"'=="") {
		local arg1 .
	}
	if (`"`arg2'"'=="") {
		local arg2 .
	}
	if (`"`hratio'"'=="") {
		local hratio .
	}
	if (`"`lnhratio'"'=="") {
		local lnhratio .
	}
	if ("`p1'"=="") {
		local p1 .
	}
	if ("`wdprob'"=="") {
		local wdprob .
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
				"`n'", "`n1'", "`n2'", "`nratio'", 	///
				`arg1', `arg2',	`hratio', `lnhratio',	///
				`p1', `wdprob',				///
				`k1', `k2', `kratio', `m1', `m2', `mratio', ///
				 `rho', `cvcluster');			///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
