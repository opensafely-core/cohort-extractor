*! version 1.0.0  25may2009

program define _sspace_covstructure_parse, rclass
	version 11

	syntax , [ IDentity iid DScalar DIagonal UNstructured ///
		opname(string) default(string) ]

	/* undocumented: iid is a synonym for dscalar			*/
	if ("`opname'"=="") local opname covstructure

	local specified `identity' `iid' `dscalar' `diagonal' `unstructured'

	local n_spec : word count `specified'
	if `n_spec' == 0 {
		if "`default'" != "" {
			_sspace_covstructure_parse, opname(`opname') `default'
			return add

			exit
		}
		local specified diagonal
	}
	else if `n_spec' > 1 { 		
		di as err "{p}{bf:`opname'(`specified')} is invalid; only " ///
		 "one of {bf:identity}, {bf:dscalar}, {bf:diagonal}, or "   ///
		 "{bf:unstructured} is allowed{p_end}"
		exit 198
	}
	if ("`specified'"=="iid") local specified dscalar

	local ops dscalar diagonal unstructured 
	/* k_spec = {0, 1, 2, 3} index used in mata code		*/
	local k_spec: list posof "`specified'" in ops		

	return local structure `specified'
	return local struct_code = `k_spec'
end

exit
