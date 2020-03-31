*! version 1.0.1  08nov2013

program define power_cmd_oneway_parse
	version 13
	syntax [anything], [ test * ]

	_power_oneway_test_parse `anything', `options'

	c_local lhs `"`s(lhs)'"'
	c_local rest `"`s(rhs)'"'
end

program define _power_oneway_test_parse, sclass
	syntax [anything(name=args)], pssobj(string) [ * ]

	local 0, `options'

	mata: st_local("solvefor", `pssobj'.solvefor)

	local ngrps = 0
	local veffect Var_m
	if "`args'" != "" {
		_pss_chk_multilist `args', option({red:group means}) ///
			levels(groups)
		local ngrps = `s(nlevels)'
		forvalues i=1/`ngrps' {
			local nlist `s(numlist`i')'
			local k : list sizeof nlist
			if (`k'>1) local mlist `"`mlist' (`nlist')"'
			else local mlist `"`mlist' `nlist'"'
		}
		/* display means, by default				*/
		local means default
	}
	_pss_syntax SYNOPTS : multitest
	syntax, [ `SYNOPTS' VARERRor(string) VARMeans(string)  ///
		delta(string) NGroups(string) contrast(string) * ]

	/* option delta() is undocumented				*/

	/* rewrite right hand side, rhs macro; no abbreviations,	*/
	/* otherwise pssobj will ignore pssobj.numopts built in 	*/
	/* call psobj.initonparse() below				*/
	if "`ngroups'" != "" {
		cap confirm integer number `ngroups'
		local rc = c(rc)
		if !c(rc) {
			local rc = (`ngroups'<2)
		}
		if `rc' {
			di as err "{p}invalid {bf:ngroups(`ngroups')}: " ///
			 "integer greater than or equal to 2 is required{p_end}"
			exit 198
		}
		if `ngrps' & `ngrps'!=`ngroups' {
			di as err "{p}option {bf:ngroups(`ngroups')}, but " ///
			 "`ngrps' means are specified{p_end}"
			exit 198
		}
		local ngrps = `ngroups'
		local rhs `"`rhs' ngroups(`ngroups')"'
	}

	local ngroup balanced

	if "`args'" != "" {
		if "`solvefor'" == "esize" {
			di as err "{p}group means cannot be specified when " ///
			 "solving for effect size{p_end}"
			exit 198
		}
		if ("`varmeans'"!="") local opt varmeans()
		else if ("`delta'"!="") local opt delta()

		if "`opt'" != "" {
			di as err "{p}option {bf:`opt'} cannot be " ///
			 "specified when cell means are specified{p_end}"
			exit 184
		}
	}
	else if "`contrast'" != "" {
		di as err "{p}group means must be specified with option " ///
		 "{bf:contrast()}{p_end}"
		exit 198
	}
	else if "`solvefor'"=="n" | "`solvefor'"=="power" {
		local what `solvefor'
		if ("`solvefor'"=="n") local what "sample size"

		if  "`varmeans'"=="" & "`delta'"=="" {
			/* delta is undocumented			*/
			di as err "{p}option {bf:varmeans()} is required " ///
			 "when computing `what' and group means are not "  ///
			 "specified{p_end}"
			exit 198
		}
		if  "`varmeans'"!="" & "`delta'"!="" {
			di as err "{p}options {bf:varmeans()} and " ///
			 "{bf:delta()} cannot be specified together{p_end}"
			exit 184
		}
		local opt = cond("`varmeans'"!="","varmeans","delta")

		local list "`varmeans'`delta'"
		cap numlist "`list'", range(>0)
		local rc = c(rc)
		if `rc' {
			di as err "{p}invalid {bf:`opt'(`list')}: " ///
			 "values must be greater than 0{p_end}"
			exit `rc'
		}
		local rhs `"`rhs' `opt'(`r(numlist)')"'
	}
	else { // solvefor == esize
		if "`varmeans'"!="" | "`delta'"!="" { 
			local opt = cond("`varmeans'"!="","varmeans","delta")

			di as err "{p}option {bf:`opt'()} is not allowed " ///
			 "when solving for effect size{p_end}"
			exit 198
		}
        }
	/* parse/validate -grweights()- -n#()- -npergroup()-		*/
	local options `"`options' n(`n') grweights(`grweights')"'
	local options `"`options' npergroup(`npergroup') `nfractional'"'
	_pss_chk_multisample `ngrps' 0 groups `solvefor' : `"`options'"'

	local ngrps = `r(nlevels)'
	if (!`ngrps') {
		di as err "{p}option {bf:ngroups(}{it:#}{bf:)} is required " _c
		if "`solvefor'"=="n" | "`solvefor'"=="power" {
			di as err "with option {bf:`opt'()}{p_end}"
		}
		else if "`solvefor'" == "esize" {
                        di as err "when solving for effect size{p_end}"
                }
		else di as err "{p_end}"

		exit 198
	}

	local options `r(options)'
	/* grweights, n#, or npergroup					*/
	if ("`r(which)'"!=""&"`r(which)'"!="n") local ngroup `r(which)'

	local rhs "`rhs' `r(nlist)'"

	if "`solvefor'"=="esize" | "`solvefor'"=="n" {
		local validate = cond("`solvefor'"=="esize","effect","N")

                _pss_chk_iteropts `validate', `options' pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
        }
	else if "`options'" != "" {
		_pss_error iteroptsnotallowed , `options' ///
			txt(when computing `solvefor')

		_pss_error optnotallowed "`options'" 
	}
	if "`contrast'" != "" {
		ParseContrast `ngrps' : `contrast'
		local contrast `r(contrast)'
		local onesided `r(onesided)'
		local null `r(null)'

		local rhs `"`rhs' contrast(`contrast')"'
		if "`null'" != "" {
			local rhs `"`rhs' nullcontrast(`null')"'
		}
		local null `""`null'" "`onesided'""'

		local veffect Var_Cm
	}
	if "`varerror'" != "" {
		if "`delta'" != "" {
			di as err "{p}options {bf:delta()} and " ///
			 "{bf:varerror()} cannot be specified together{p_end}"
			exit 184
		}
		cap numlist "`varerror'", range(>0)
		local rc = c(rc)
		if `rc' { 
			di as err "{p}invalid {bf:varerror(`varerror')}: " ///
			 "error variances must be greater than 0{p_end}"
			exit `rc'
		}
		local rhs `"`rhs' varerror(`r(numlist)')"'
	}
	sreturn local lhs `"`mlist'"'
	sreturn local rhs `"`rhs'"'

	/* initialize the number of groups in pss_multitest object	*/
	mata: `pssobj'.initonparse(`ngrps',"`means'","`veffect'", ///
		`"`null'"',"`ngroup'")
end

program define ParseContrast, rclass
	_on_colon_parse `0'
	local ngrps `s(before)'
	local 0 `s(after)'

	cap noi syntax anything(name=contrast) [, null(string) ONESIDed ]
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:contrast()}"
		exit `rc'
	}
	cap numlist "`contrast'"
	local contrast `r(numlist)'
	local k : list sizeof contrast
	if `k' != `ngrps' {
		di as err "{p}invalid {bf:contrast(`contrast')}: `ngrps' " ///
		 "values are required, one for each mean{p_end}"
		exit 198
	}
	local c0 = 0
	local zip = 1
	foreach ci of numlist `contrast' {
		local c0 = `c0' + `ci'
		local zip = `zip' & (abs(`ci')<1e-8)
	}
	if abs(`c0') > 1e-8 {
		di as err "{p}invalid {bf:contrast(`contrast')}; values " ///
		 "must sum to 0{p_end}"
		exit 121
	}
	if `zip' {
		di as err "{p}invalid {bf:contrast(`contrast')}; values " ///
		 "are all 0{p_end}"
		exit 121
	}
	if "`null'" != "" {
		cap confirm number `null'
		if c(rc) {
			di as err "{p}invalid "                           ///
			 "{bf:contrast(,null(`null'))}; a single number " ///
			 "is expected{p_end}"
			exit 198
		}
		return local null = `null'
	}
	return local contrast `contrast'
	return local onesided `onesided'
end
exit
