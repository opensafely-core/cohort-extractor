*! version 1.0.1  03nov2014

/* parse power options -grweights()- -npergroup()- -n()- -n#()-		*/
program define _pss_chk_multisample, rclass
	args nlev minlev levtype solvefor colon options
	
	local 0, `options'
	syntax, [ n(string) GRWeights(string) NPERGroup(string) ///
			 STRWeights(string) NPERSTRatum(string) ///
			 		NFRACtional GROUPName(string) * ]	
	local 0, `options'
	if (`"`grweights'"' !="") local weight_name grweights
	else if (`"`strweights'"' !="") local weight_name strweights
	if (`"`npergroup'"' !="") local nper_name npergroup
	else if (`"`nperstratum'"' !="") local nper_name nperstratum
	if `nlev' {
		forvalues i=1/`nlev' {
			local nsyntax `"`nsyntax' n`i'(string)"'
		}
		syntax, [ `nsyntax' * ]
		local 0, `options'
	}
	else {
		local n0 = "x"
		while ("`n`nlev''"!="") {
			local nsyntax "n`++nlev'(string)"
			cap noi syntax, [ `nsyntax' * ]
			local 0, `options'
		}
		local nlev = `nlev'-1
		local n0
	}

	if ("`solvefor'"=="esize") local sflab effect size
	else local sflab `solvefor'

	local kn = 0
	forvalues i=1/`nlev' {
		if "`n`i''" != "" {
			local `++kn'
			local nlist `"`nlist' n`i'(`n`i'')"'
		}
	}
	if "`n'" != "" {
		if (`kn') local which {bf:n}{it:#}{bf:()} 	
		else if ("``nper_name''"!="") local which {bf:`nper_name'()}

		if "`which'" != "" {
			di as err "{p}options {bf:n()} and `which' cannot " ///
			 "be specified together{p_end}"
			exit 184
		}
		/* already checked in lower level parsing		*/
		numlist `"`n'"', range(>0) integer
		local which n
		local n `"`r(numlist)'"'
		local nlist n(`n')
	}
	if "``weight_name''" != "" {
		if `kn' > 0 {
			di as err "{p}options {bf:n}{it:#}{bf:()} and " ///
			 "{bf:`weight_name'()} cannot be specified " ///
			 "together{p_end}"
			exit 184
		}
		if "``nper_name''" != "" {
			di as err "{p}options {bf:`nper_name'()} and " ///
			 "{bf:`weight_name'()} cannot be specified " ///
			 "together{p_end}"
			exit 184
		}
		/* `weight_name'(multiple_lists)			*/
		if ("`nfractional'"=="") local integer integer

		local nlev0 = `nlev'
		/* set the minimum number of levels			*/
		if (!`nlev0') local nlev0 = -`minlev'

                _pss_chk_multilist ``weight_name'', ///
			option({bf:`weight_name'()}) ///
			levels(`levtype') nlevels(`nlev0') range(>0) `integer'

		if (!`nlev') local nlev = `s(nlevels)'

                forvalues i=1/`nlev' {
			if ("`weight_name'" == "grweights") {
				local grwgh `"grwgt`i'(`s(numlist`i')')"'
			}
			else if ("`weight_name'" == "strweights") {
				local grwgh `"strwgt`i'(`s(numlist`i')')"'
			}	
			local gwlist `"`gwlist' `grwgh'"'	
               	}
		local nlist `"`nlist' `gwlist'"'
		local nlist : list retokenize nlist
		local which `weight_name'
	}
	else if "``nper_name''" != "" {
		if `kn' {
			di as err "{p}options {bf:`nper_name'()} and "      ///
			 "{bf:n}{it:#}{bf:()} cannot be specified together" ///
			 "{p_end}"
			exit 184
		}
		cap numlist `"``nper_name''"', range(>0) integer
		local rc = c(rc)
		if `rc' {
			di as err "{p}invalid {bf:`nper_name'()}: a " ///
			 "{help numlist} of positive integers is "  ///
			 "required {p_end}"
			exit `rc'
		}
		local `nper_name' `"`r(numlist)'"'
		local nlist `nper_name'(``nper_name'')
		if (`"`nper_name'"'=="npergroup") local which npergr
		else if(`"`nper_name'"'=="nperstratum") local which nperstr
	}
	else if `kn' {
		local nlist
		forvalues i=1/`nlev' {
			if ("`groupname'" =="") {
				CheckNi, i(`i') nlev(`nlev') ni(`n`i'') 
			}
			else {	
				CheckNi, i(`i') nlev(`nlev') ni(`n`i'') ///
						groupname(`groupname')
			}				
			local n`i' `"`r(numlist)'"'
			local nlist `"`nlist' n`i'(`n`i'')"'
		}
		local nlist : list retokenize nlist
		local which n#
	}
	else if "`solvefor'"!="n" & "`n'"=="" {
		di as err "{p}one of {bf:n()} with, optionally, "         ///
		 "{bf:`weight_name'()}; {bf:`nper_name'()}; or "          ///
		 "{bf:n}{it:#}{bf:()}, {it:#}=1,...,`nlev', is required " ///
		 "when solving for `sflab'{p_end}"
		exit 198
	}
	return local which `which'
	return local options `"`options'"'
	return local nlist `"`nlist'"'
	return local nlevels = `nlev'
end

program define CheckNi, rclass
	syntax, i(integer) nlev(integer) [ ni(string) groupname(string)]

	if "`ni'" == "" {
		if ("`groupname'"=="") {
			di as err "{p}option {bf:n`i'()} is missing;{p_end}"
			di as err "{p 4 4 2}Sample size is specified " ///
				"using either option {bf:n()} with, " ///
				"optionally, {bf:grweights()}; "    ///
				"{bf:npergroup()}; or options " ///
				"{bf:n}{it:#}{bf:()} for "   ///
				"{it:#}=1,...,`nlev'.{p_end}"
			exit 198
		}
		else if ("`groupname'"=="stratum")  {
			di as err "{p}option {bf:n`i'()} is missing;{p_end}"
			di as err "{p 4 4 2}Sample size is specified " ///
				"using either option {bf:n()} with, " ///
				"optionally, {bf:strweights()}; "    ///
				"{bf:nperstratum()}; or options " ///
				"{bf:n}{it:#}{bf:()} for "   ///
				"{it:#}=1,...,`nlev'.{p_end}"
			exit 198
		}	
	}
	cap numlist `"`ni'"', range(>0) integer
	local rc = c(rc)
	if `rc' {
		di as err "{p}invalid {bf:n`i'()}: a {help numlist} of " ///
		 "positive integers is required{p_end}"
		exit `rc'
	}
	return add
end
exit
