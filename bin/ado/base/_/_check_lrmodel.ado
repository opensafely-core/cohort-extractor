*! version 1.0.5  24apr2019
program define _check_lrmodel
	version 15

	syntax [name(name=cmdname)], [ NOSKIP noCONstant ///
		CONSTraints(string) prefix(string) vcetype(string) ///
 	 	VCE(passthru) Robust Cluster(varname) options(string) ///
		INDEPvar(varlist ts fv) * ]

	local cmdlist biprobit etregress heckprobit heckprob hetprobit hetprob
	local cmdlist `cmdlist' heckman truncreg xtcloglog xtintreg xtlogit
	local cmdlist `cmdlist' xtnbreg xtpoisson xtprobit xtstreg xttobit
	local cmdlist `cmdlist' xtologit xtoprobit hetregress hetreg

	if ("`cmdname'"!="") {
		if !`: list cmdname in cmdlist' {
			di as err "option {bf:lrmodel} not allowed"
			exit 198
		}
	}

	opts_exclusive "lrmodel `noskip'"
	
	// vcetype() is set by _vce_parserun.ado
	local vcelist robust cluster bootstrap jackknife
	if "`vcetype'"!="" & `:list vcetype in vcelist' {
		di as err "{p}option {bf:lrmodel} may not be combined with " ///
			  "option {bf:vce(`vcetype')}{p_end}" 
		exit 198
	}

	// prefix() is set by jackknife.ado, bootstrap.ado, or u_mi_estimate.ado
	// also see _svy_check_cmdopts.ado
	local prefixlist jackknife bootstrap svy "mi estimate"
	if "`prefix'"!="" & (`:list prefix in prefixlist' | ///
			     "`prefix'"=="mi estimate") {
		di as err "{p}option {bf:lrmodel} not allowed with " ///
			  "the {bf:`prefix'} prefix{p_end}"
		exit 198
	}

	if "`constant'" != "" {
		di as err "{p}option {bf:noconstant} may not be combined " ///
			"with option {bf:lrmodel}{p_end}"
		exit 198
	}

	if `"`options'"' != "" {
		gettoken option : options, bind
		di as err `"{p}option {bf:`option'} may not be combined "' ///
			"with option {bf:lrmodel}{p_end}"
		exit 198
	}

	if `"`constraints'"' != "" {
		di as err "{p}option {bf:constraints()} may not be " ///
			"combined with option {bf:lrmodel}{p_end}"
		exit 198
	}

	// also see _vce_parserun.ado for additional vce checks with -lrmodel-
	if `"`vce'"' != "" {
		_vce_parse , argopt(CLuster) opt(Robust oim opg) : , `vce'
		if "`r(cluster)'" != "" {
			di as err ///
			    "{p}option {bf:vce(cluster `r(cluster)')} may " ///
			    "not be combined with option {bf:lrmodel}{p_end}"
			exit 198
		}
		else if "`r(robust)'" != "" {
			di as err "{p}option {bf:vce(robust)} may not be " ///
				"combined with option {bf:lrmodel}{p_end}"
			exit 198
		}
	}
	// old options
	if `"`cluster'"' != "" {
		di as err ///
			    `"{p}option {bf:cluster(`cluster')} may "' ///
			    "not be combined with option {bf:lrmodel}{p_end}"
		exit 198
	}
	if "`robust'" != "" {
		di as err "{p}option {bf:robust} may not be " ///
				"combined with option {bf:lrmodel}{p_end}"
		exit 198
	}

	if "`indepvar'" == ""  & "`cmdname'" == "" {
		di as err "{p}likelihood-ratio model test is not available " ///
			"because a constant-only model has been fit{p_end}"
		exit 198
	}

end
