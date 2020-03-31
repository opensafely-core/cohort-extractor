*! version 1.0.0  04jul2018
program _cm_vcepanel, sclass
	version 16
	
	syntax varname(numeric) , CMD(string) [			 ///
						VCE(string asis) ///
						ALLOWED(string)  ///
					      ] 
	local origpanelvar `varlist'
	
	ParseVCE `vce'
	
	if ("`s(cluster)'" != "") {
		sreturn local vce `"vce(`vce')"'
		exit
	}
	
	local vcetype `s(vcetype)'
	
	if ("`allowed'" != "" & "`vcetype'" != "") {
		local found : list vcetype in allowed
		
		if (!`found') {
			ErrorVCEtype `vcetype'
		}
	}
					
	// If user did not specify vce() or specified vce(robust), then 
	// vce(cluster origpanelvar) is used.

	if ("`vcetype'" == "") {
		local vce "vce(cluster `origpanelvar')"

di as text "{p 0 6 2}note: data were {bf:cmset} as panel data, and the " ///
	   "default {it:vcetype} for panel data is {bf:{bind:`vce'}}; "  ///
	   "see {helpb `cmd'}{p_end}"
	   
	   	sreturn local vce `vce'
	   	exit
	}

	if ("`vcetype'" == "robust") {
		local vce "vce(cluster `origpanelvar')"

di as text "{p 0 6 2}note: data were {bf:cmset} as panel data, and " ///
	   "{bf:vce(robust)} for panel data is {bf:{bind:`vce'}}; "  ///
	   "see {helpb `cmd'}{p_end}"

	   	sreturn local vce `vce'
	   	exit
	}

	// If vce(bootstrap, ...) or vce(jackknife, ...) is specified, vce 
	// becomes 
	//
	//		vce(bootstrap, cluster(origpanelvar) 
	// 	or
	//		vce(jackknife, cluster(origpanelvar)
	//
	// unless user specified cluster(varname).

	if (   "`vcetype'" == "bootstrap"   ///
	     | "`vcetype'" == "jackknife" ) {

	   	local vce "vce(`vcetype', cluster(`origpanelvar'))"
	
di as text "{p 0 6 2}note: data were {bf:cmset} as panel data, `vcetype' " ///
	   "replications are based on clusters in {bf:`origpanelvar'}, "   ///
	   "and vce is {bf:{bind:`vce'}}; see {helpb `cmd'}{p_end}"

		sreturn local vce `"vce(`vcetype', cluster(`origpanelvar') `s(vceopts)')"'
		exit
	}
	
	sreturn local vce `"vce(`vcetype')"'  // oim or opg
end

// vce(vcetype)
//
//	oim                               observed information matrix (OIM)
//	opg                               outer product of the gradient (OPG) vectors
//
//	Robust                            Huber/White/sandwich estimator
//	CLuster clustvar                  clustered sandwich estimator
//	
//	BOOTstrap [, bootstrap_options]   bootstrap estimation
//	JACKknife [, jackknife_options]   jackknife estimation
 
program ParseVCE, sclass	
	if (`"`0'"' == "") {
		exit
	}
	
	syntax [anything] [, CLuster(string asis) * ]
	
	gettoken vcetype clustvar : anything
	
	if (`"`vcetype'"' == "") {
		ErrorVCE
	}
	
	unabVCEtype , `vcetype'
	local vcetype `s(vcetype)'
	
	// Is it vce(cluster clustvar)?
	
	if (`"`clustvar'"' != "") {
		if ("`vcetype'" == "cluster") {
			confirm variable `clustvar'
		}
		
		if (`"`cluster'"' != "") {
			ErrorVCE
		}
	}
	
	// Is it vce(bootstrap, cluster(varname) or 
	//       vce(jackknife, cluster(varname)?
	
	if (`"`cluster'"' != "") {
		if (  "`vcetype'" == "bootstrap" ///
		    | "`vcetype'" == "jackknife" ) {
			
			confirm variable `cluster'
		}
		else {
			ErrorVCE
		}
	} 
		
	if (  `"`options'"' != ""		///
	    & "`vcetype'" != "bootstrap"	///
	    & "`vcetype'" != "jackknife" ) {
			
		ErrorVCE
	} 
		
	sreturn local cluster `cluster' `clustvar'
	sreturn local vceopts `"`options'"'
end

program unabVCEtype, sclass
	syntax [, OIM OPG Robust CLuster BOOTstrap JACKknife JACKNife * ]
	
	if ("`jacknife'" != "" & "`jackknife'" == "") {
		local jackknife jackknife
	}
	
	if (`"`options'"' != "") {
		ErrorVCEtype `options'
	}
	
	local vcetype "`oim' `opg' `robust' `cluster' `bootstrap' `jackknife'"
	
	local ntype : list sizeof vcetype
	
	if (`ntype' > 1) {
		ErrorVCE
	}
	
	sreturn local vcetype `vcetype'
end

program ErrorVCEtype
	di as error "{it:vcetype} {bf:`0'} not allowed"
	exit 198
end

program ErrorVCE
	di as error "option {bf:vce()} incorrectly specified"
	exit 198
end

