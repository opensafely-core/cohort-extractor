*! version 1.0.3  12jul2017

program define _teffects_gmmopts, sclass
	version 13
	syntax, [ ITERate(string) conv_maxiter(passthru) conv_ptol(passthru) ///
		conv_vtol(passthru) conv_nrtol(passthru)  WINITial(passthru) ///
		tracelevel(passthru) NRTOLerance(string) 		     ///
		NONRTOLerance(passthru) TOLerance(string) TRace GRADient     ///
		showstep debug vce(string) * ]

	/* GMM does not accept SHOWTOLerance				*/
	local gmmopts `conv_maxiter' `conv_ptol' `conv_vtol' `conv_nrtol'
	local gmmopts `gmmopts' `tracelevel' `winitial' `debug' 
	if "`iterate'" != "" {
		if "`conv_maxiter'" != "" {
			di as err "{p}option {bf:iterate()} and " ///
			 "{bf:gmm} option {bf:conv_maxiter()} may not be " ///
			 "combined{p_end}"
			exit 184
		}
		cap confirm integer number `iterate'
		local rc = c(rc)
		if !`rc' {
			if (`iterate'<0) local rc = 198 
		}
		if `rc' {
			di as err "{p}{bf:iterate({it:#})} must be a " ///
			 "nonnegative integer{p_end}"
			exit 198
		} 
		local gmmopts `gmmopts' conv_maxiter(`iterate')
	}
	if "`nrtolerance'" != "" {
		di as err "{p}option {bf:nrtolerance()} is not allowed; " ///
		 "{bf:teffects} uses the Gauss-Newton algorithm{p_end}"
		exit 198
	}
	if "`conv_nrtol'" != "" {
		di as err "{p}{bf:gmm} option {bf:conv_nrtol()} is not " ///
		 "allowed; {bf:teffects} uses {bf:gmm} and the "         ///
		 "Gauss-Newton algorithm{p_end}"
		exit 198
	}
	if "`tolerance'" != "" {
		if "`conv_ptol'" != "" {
			di as err "{p}{bf:tolerance()} and {bf:gmm} " ///
			 "option {bf:conv_ptol()} may not be combined{p_end}"
			exit 184
		}
		cap confirm number `tolerance'
		local rc = c(rc)
		if !`rc' {
			if (`tolerance'<0) local rc = 198
		}			
		if `rc' {
			di as err "{p}{bf:tolerance()} must be a greater " ///
			 "than or equal to 0{p_end}"
			exit 198
		}
		local gmmopts `gmmopts' conv_ptol(`tolerance')
	}
	local trlevel `trace' `gradient' `showstep'
	if "`trlevel'"!= "" {
		if "`tracelevel'" != "" {
			di as err "{p}option {bf:tracelevel()} may not be " ///
			 "combined with {bf:trace}, {bf:gradient} or "///
			 "{bf:showstep}{p_end}"
			exit 184 
		}
		if ("`gradient'"!="") local trlevel gradient
		else if ("`showstep'"!="") local trlevel step
		else local trlevel params

		local gmmopts `gmmopts' tracelevel(`trlevel')
	}
	if "`winitial'" == "" {
		local gmmopts `gmmopts' winitial(unadjusted,indep)
	}
	/* vce(robust) or vce(cluster clusterv) only */
	ParseVCE , vce(`vce')
	local vce `s(vce)'
	local vcetype `s(vcetype)'
	local clustvar `s(clustvar)'
	local vceopts `s(vceopts)'
	local gmmopts `gmmopts' vce(`vceopts')
	local gmmopts `gmmopts' valueid(EE criterion)

	sreturn local gmmopts `"`gmmopts'"'
	sreturn local rest `"`options'"'
	sreturn local vce `"`vce'"'
	sreturn local vcetype `"`vcetype'"'
	sreturn local clustvar `clustvar'
end
					//-- Parse vce option --//
program define ParseVCE, sclass
	syntax [, vce(string) ]
	
	local w : word count `vce'

	if `w'==0 {
		sret local vce robust
		sret local vcetype Robust
		sret local vceopts 
		exit
		// NotReached
	}

	cap noi _vce_parse, argopt(CLuster) opt(Robust):, vce(`vce') 
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:vce()}"
		exit `rc'
	}

	if `"`r(cluster)'"' != "" {
		sreturn local clustvar `r(cluster)'
		sreturn local vce cluster
		sreturn local vcetype Robust  
		sret local vceopts `vce' `clustvar'
	}
	else if "`r(vce)'"=="robust" {
		sreturn local vce robust
		sreturn local vcetype Robust
		sret local vceopts `vce'
	}
end

exit
