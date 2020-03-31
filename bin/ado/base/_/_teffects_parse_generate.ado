*! version 1.0.3  13feb2015 

program define _teffects_parse_generate, sclass
	version 13
	syntax, generate(string) nvars(passthru)
	
	/* strip out any wild card *					*/
	gettoken gen star : generate, parse("*")
	if "`star'"!="" & "`star'"!="*" {
		di as err "{p}{bf:generate(`generate')} prefix " ///
		 "improperly specified{p_end}"
		exit 198
	}
	/* _stubstar2names to check newvarlist				*/
	cap noi _stubstar2names `gen'*, `nvars'
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:generate(`generate')}"
		exit `rc'
	}
	local type : word 1 of `s(typlist)'
	if "`type'" == "float" {
		local tmp : subinstr local gen "`type'" "`type'", ///
			count(local k)
		if `k' == 0 {
			/* default type is long, not float		*/
			local type long
		}
	}
	local stub : word 1 of `s(varlist)'
	local k = ustrlen("`stub'")
	if `k' > 1 {
		local `--k'
		local stub = usubstr("`stub'",1,`k')
	}
	sreturn local stub `stub'
	sreturn local type `type'
end
exit
