*! version 1.1.0  30sep2016
program power_cmd_twoprop
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_twoprop_`type' `anything', `options'
end

program pss_twoprop_test

	local clu_opt cluster k1(string) k2(string) kratio(string) ///
		m1(string) m2(string) mratio(string) ///
			rho(string) CVCLuster(string)
	_pss_syntax SYNOPTS : twotest	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				test(string)	///
				diff(string)	///
				RDiff(string)	///
				ratio(string)	///
				RRisk(string)	///
				ORatio(string)	///
				effect(string)  ///
				CHI2		///	// undoc.
				FISHER		///	// undoc.
				LRCHI2		///	// undoc.
				CONTINuity	///
				`clu_opt'		///
				*		///
			   ]

	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	if (`"`test'"'!="") {
		if (`"`test'"'=="lrchi2") local lrchi2 lrchi2
		else if (`"`test'"'=="fisher") local fisher fisher
		else if (`"`test'"'!="chi2") {
			di as err ///
			`"{p}{bf:test()}: invalid method {bf:`test'}{p_end}"'
			exit 198
		}
	}

	// handle effect
	if ("`arg1'"!="" & "`arg2'"!="") local nargs 2
	else if ("`arg1'"!="" & "`arg2'"=="") local nargs 1
	else local nargs 0
	_pss_twoprop_parseeffect effect : `"`effect'"' `nargs' ///
					  "`diff'" "`rdiff'"  ///
					  "`ratio'" "`rrisk'" "`oratio'"

	if ("`arg1'"=="") {
		local arg1 .
	}

	if ("`arg2'"=="") {
		local arg2 .
	}

	if ("`diff'"=="") {
		local diff .
	}

	if ("`rdiff'"=="") {
		local rdiff .
	}
	
	if ("`oratio'"=="") {
		local oratio .
	}
	
	if ("`rrisk'"=="") {
		local rrisk .
	}

	if ("`ratio'"=="") {
		local ratio .
	}
	local continuity = ("`continuity'"!="")

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
				`arg1', `arg2',	`diff', `rdiff', 	///
				`ratio', `rrisk' , `oratio', `continuity', ///
				`k1', `k2', `kratio', `m1', `m2', `mratio', ///
				 `rho', `cvcluster'			); ///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
