*! version 1.0.1  16nov2017
program _bayesmhpost_paramlist
	version 15.0
	args toparams colon paramlist showreffects showreffects1
	
	if (`"`paramlist'"' == "_all" | `"`paramlist'"' == "*") {
		 local paramlist
	}
	local simulparams `e(parnames)' `e(predictnames)'
	if `"`paramlist'"' != "" {
		// label:i.factorvar must be called as {label:i.factorvar} 
		// in order to expand properly
		_mcmc_expand_paramlist `"`paramlist'"' `"`simulparams'"'
		local thetas `s(thetas)'
		if `"`thetas'"' == "" {
			_mcmc_paramnotfound `"`paramlist'"'
		}
	}
	else {
		if `"`e(parnames)'"' == "" {
			di as err "last estimates not found"
			exit 301
		}
		local thetas `e(parnames)'
	
	if `"`e(latparams)'"' != "" {
		// don't ashow REs by default
		local latparams `"`e(latparams)'"'
		_mcmc_expand_paramlist `"{`latparams'}"' `"`simulparams'"'
		local latparams `s(thetas)'
		if "`showreffects'" != "" {
			local latparams
			local showreffects1
		}
		else if "`showreffects1'" != "" {
			_mcmc_expand_paramlist `"`showreffects1'"' `"`latparams'"'
			local showreffects `s(thetas)'
			local showreffects1 : list showreffects - latparams
			local latparams : list latparams - showreffects
		}
		if "`latparams'" != "" {
			local thetas : list thetas - latparams
		}
		if "`showreffects1'" != "" {
			_mcmc_expand_paramlist `"`showreffects1'"' `"`e(parnames)'"'
			local showreffects1 `s(thetas)'
			local thetas `thetas' `s(thetas)'
			local thetas : list uniq thetas
		}
	}

	}
	c_local `toparams' "`thetas'"
end
