*! version 1.0.1  31aug2017

program define menl_parse_ehierarchy, sclass
	syntax, [ COVSTRUCTures ]

	if "`e(cmd)'" != "menl" {
		return(301)
	}
	if !e(k_hierarchy) {
		sreturn local klevels = 0
	}
	local hier `"`e(hierarchy)'"'

	sreturn clear
	local k = 0
	while "`hier'" != "" {
		gettoken hi hier : hier, match(paren)
		gettoken path hi : hi, parse(":")
		gettoken colon hi : hi, parse(":")
		if "`colon'" != ":" {
			/* should not happen				*/
			di as err "{p}{bf:e(hierarchy)} is invalid"
			exit 322
		}
		gettoken cov hi : hi, parse(":")
		gettoken colon lvs : hi, parse(":")
		if "`colon'" != ":" {
			/* should not happen				*/
			di as err "{p}{bf:e(hierarchy)} is invalid"
			exit 322
		}
		if `k' > 0 & "`covstructures'"=="" {
			/* want path hierarchy and associated LVs	*/
			if "`path'" == "`path`k''" {
				/* multiple covariance specifications
				 *  for this level			*/
				local lvs`k' `lvs`k'' `lvs'
				local lvs`k' : list retokenize lvs`k'
				local k1 : word count `lvs`k''
				local klv`k' = `k1'
				continue
			}
		}
		local `++k'
		local path`k' `path'
		local lvs`k' `lvs'
		local k1 : word count `lvs'
		local klv`k' = `k1'
		if "`covstructures'" != "" {
			sreturn local covstruct`k' `cov'
		}
		local hier : list retokenize hier
	}
	forvalues i=1/`k' {
		sreturn local path`i' `path`i''
		sreturn local lvs`i' `lvs`i''
		sreturn local klv`i' = `klv`i''
	}
	if "`covstructures'" != "" {
		/* kcovstruct >= klevels				*/
		sreturn local kcovstruct = `k'
	}
	else {
		sreturn local klevels = `k'
	}
end
exit
