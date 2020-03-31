*! version 1.0.0  11dec2014

program define power_cmd_cmh_parse
	version 14.0
	syntax [anything], [ test * ]

	_power_cmh_test_parse `anything', `options'

	c_local lhs `"`s(lhs)'"'
	c_local rest `"`s(rhs)'"'
end

program define _power_cmh_test_parse, sclass
syntax [anything(name=args)], [NPERGroup(string) *] 	
if (`"`npergroup'"' != "") {
	di as err "{p}option {bf:npergroup(`npergroup')} not " ///
	"allowed {p_end}" 
	exit 198	
}	
syntax [anything(name=args)], [GRWeights(string) *] 
if (`"`grweights'"' != "") {
	di as err "{p}option {bf:grweights(`grweights')} not " ///
	"allowed {p_end}" 
	exit 198
}
	
	syntax [anything(name=args)], pssobj(string) [ * ]
	local 0, `options'

	mata: st_local("solvefor", `pssobj'.solvefor)

	if ("`solvefor'"=="n") local sflab sample size
	else if ("`solvefor'"=="esize") local sflab effect size
	else local sflab `solvefor'
	_pss_chk_multilist `args', option(strata probabilities) ///
		levels(strata) range(>0 <1)
	local nstrat = `s(nlevels)'
	forvalues i=1/`nstrat' {
		local nlist `s(numlist`i')'
		local k : list sizeof nlist
		if (`k'>1) local plist `"`plist' (`nlist')"'
		else local plist `"`plist' `nlist'"'
	}

	_pss_syntax SYNOPTS : multitest
	syntax, [ `SYNOPTS' ORatio(numlist) grratios(string) CONTINuity ///
		DIRection(string) ONESIDed * NOSHOWGRSTRSIZES SHOWGRSTRSIZES ///
		transpose showasmatrix]

	if ("`showasmatrix'" !="" & "`showgrstrsizes'"!="") {
		opts_exclusive "showasmatrix showgrstrsizes"
		exit 198
	}
	if ("`noshowgrstrsizes'" !="" & "`showgrstrsizes'"!="") {
		opts_exclusive "showgrstrsizes noshowgrstrsizes"
		exit 198
	}
		
	/* ignore -direction- option, parsed as a main option		*/
	if ("`continuity'"!="") local rhs cc

	/* parse/validate options grweights() npercel() n#() -n()	*/
	local options `"`options' n(`n')"'
	local options `"`options' `nfractional' groupname(stratum)"'
	_pss_chk_multisample `nstrat' 2 strata `solvefor' : `"`options'"'
	local options `r(options)'
	local which `r(which)'
	local rhs "`rhs' `r(nlist)'"
	if ("`which'"!="" & "`which'"!="n") local ngroup `which'
	else local ngroup balanced

	if "`solvefor'"=="esize" | "`solvefor'"=="n" {
		if ("`solvefor'"=="esize") local validate OR

                _pss_chk_iteropts `validate', `options' pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'

		if "`solvefor'"=="n" & "`options'"!="" & ///
			("`onesided'"!=""|"`direction'"!="") {
			di as err "{p}iteration options are only allowed "  ///
				"for effect size or the two-sided test " ///
				"when computing sample size{p_end}"
			exit 198
		}
        }
	else if "`options'" != "" {
		_pss_error iteroptsnotallowed , `options' ///
			txt(when computing `sflab')

		_pss_error optnotallowed "`options'" 
	}
	if "`oratio'" != "" {
		if "`solvefor'" == "esize" {
			di as err "{p}nothing to compute; all parameters "   ///
			 "have been provided: {bf:oratio()}, " ///
			 "{bf:power()}, and {bf:n()}{p_end}"
			exit 198
		}
		cap numlist "`oratio'", range(>0)
		if (_rc) {
			di as err "{bf:oratio()} must contain positive numbers"
			exit 198
		}	
	
		local orlist `r(numlist)'
		local kor : list sizeof orlist
		if `kor' == 1 {
			if `orlist' == 1 {
				di as err "{p}{bf:oratio()} must contain " ///
				   "positive numbers different from 1{p_end}" 
				exit 198
			}
		}	
		local rhs `"`rhs' oratio(`r(numlist)')"'
	}
	else if "`solvefor'" != "esize" {
		di as err "{p}option {bf:oratio()} is required when solving " ///
		 "for `sflab'{p_end}"
		exit 198
	}
	if "`grratios'" != "" {
		_pss_chk_multilist `grratios', option({bf:grratios()}) ///
			levels(strata) nlevels(`nstrat') range(>0 <1)
		forvalues i=1/`nstrat' {
			local slist `"`slist' grratio`i'(`s(numlist`i')')"'
		}
		local rhs `"`rhs' `slist'"'
		local grrat grratios
	}

	sreturn local lhs `"`plist'"'
	sreturn local rhs `"`rhs'"'
	
	/* initialize the number of strata in pss_multitest object	*/
	mata: `pssobj'.initonparse(`nstrat',"`grrat'","`ngroup'", ///
					("`continuity'" !=""), 	///
					("`showasmatrix'" != ""), ///
					("`showgrstrsizes'" !=""), ///
					("`noshowgrstrsizes'" !=""), ///
					"`transpose'" != "") 
end

