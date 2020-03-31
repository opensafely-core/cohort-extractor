*! version 1.0.0  10dec2018

program _mcmc_definereplace, sclass
	
	args expr
	// replace xbdefines and redefines
	local lablist $MCMC_xbdeflabs
	local varlist $MCMC_xbdefvars
	gettoken nextlab lablist : lablist
	gettoken nextvar varlist : varlist
	while `"`nextlab'"' != "" {
		while regexm(`"`expr'"', `"{`nextlab':}"') {
			local expr = ///
			regexr(`"`expr'"', `"{`nextlab':}"', `"`nextvar'"')
		}
		gettoken nextlab lablist : lablist
		gettoken nextvar varlist : varlist
	}

	sreturn local expr = `"`expr'"'
end