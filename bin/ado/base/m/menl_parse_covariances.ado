*! version 1.0.0  09jan2017

program define menl_parse_covariances, sclass
	_on_colon_parse `0'
	local kcov = `s(before)'
	local 0, `s(after)'

	syntax, [ COVariance(string) * ]

	if `"`covariance'"' == "" {
		sreturn local kcov = `kcov'
		sreturn local options `"`options'"'
		exit
	}
	local more `options'
	local 0 `covariance'
	cap noi syntax anything(name=renames id="random effect names"),  ///
		[ INDependent EXChangeable IDentity UNstructured ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:covariance()})"
		exit `rc'
	}
	local renames : list retokenize renames
	local k : word count `independent' `exchangeable' `identity' ///
			`unstructured' 
	if `k' > 1 {
		di as err "{p}invalid {bf:covariance()} specification for " ///
		 "random effects {bf:`renames'}; only one of "              ///
		 "{bf:independent}, {bf:exchangeable}, {bf:identity}, or "  ///
		 "{bf:unstructured} can be specified{p_end}"
		exit 184
	}
	if `k' == 0 {
		local vtype identity
	}
	else {
		local vtype "`independent'`exchangeable'`identity'"
		local vtype "`vtype'`unstructured'"
	}
	local `++kcov'
	sreturn local path`kcov' "`path'"
	sreturn local renames`kcov' "`renames'"
	sreturn local vartype`kcov' `vtype'
	
	menl_parse_covariances `kcov' : `more'
end

exit
