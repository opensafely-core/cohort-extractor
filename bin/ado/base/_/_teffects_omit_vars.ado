*! version 1.0.0  26jan2013

program define _teffects_omit_vars, rclass
	syntax, klev(integer) [						///
		fvdvlist(string) fvdrevar(string) dconst(string) 	///
		fvhdvlist(string) fvhdrevar(string)			///
		fvtvlist(string) fvtrevar(string) tconst(string)	///
		fvhtvlist(string) fvhtrevar(string) ]

	/* indices for means						*/
	local komit = 0
	numlist "1/`klev'"

	local index `"`r(numlist)'"'
	local k = `klev'

	if "`fvdvlist'`dconst'" != "" {
		/* indices for depvar equations				*/
		OmitVarExpand `"`fvdvlist'"' `"`fvdrevar'"' "`dconst'" ///
			`klev' `klev'
		local komit = `r(komit)'
		local fvodrevar `"`r(varlist)'"'
		local index `"`index' `r(index)'"'
		local k = `k' + `r(k)'
	}
	if "`fvhdvlist'" != "" {
		/* indices for hetprobit variance equation		*/
		local hrep = `klev'

		OmitVarExpand `"`fvhdvlist'"' `"`fvhdrevar'"' "" `hrep' `k'
		local komit = `komit' + `r(komit)'
		local fvohdrevar `"`r(varlist)'"'
		local index `"`index' `r(index)'"'
		local k = `k' + `r(k)'
	}
	if "`fvtvlist'`tconst'" != "" {
		/* indices for treatment equations			*/
		OmitVarExpand `"`fvtvlist'"' `"`fvtrevar'"' "`tconst'" ///
			`=`klev'-1' `k'
		local komit = `komit' + `r(komit)'
		local fvotrevar `"`r(varlist)'"'
		local index `"`index' `r(index)'"'
		local k = `k' + `r(k)'
	}
	if "`fvhtvlist'" != "" {
		/* indices for hetprobit variance equation		*/
		local hrep = `klev'-1

		OmitVarExpand `"`fvhtvlist'"' `"`fvhtrevar'"' "" `hrep' `k'
		local komit = `komit' + `r(komit)'
		local fvohtrevar `"`r(varlist)'"'
		local index `"`index' `r(index)'"'
		local k = `k' + `r(k)'
	}
	local index : list retokenize index

	return local index `"`index'"'
	return local komit `komit'
	/* omodel covariates						*/
	return local fvodrevar `"`fvodrevar'"'
	/* tmodel covariates						*/
	return local fvotrevar `"`fvotrevar'"'
	/* variance covariates, if omodel = hetprobit			*/
	return local fvohdrevar `"`fvohdrevar'"'
	/* variance covariates, if tmodel = hetprobit			*/
	return local fvohtrevar `"`fvohtrevar'"'
	return local k = `k'
end

program OmitVarExpand, rclass
	args fvvlist fvrevar const klev offset

	local kvar : list sizeof fvrevar

	local komit = 0
	local k = 0
	if "`fvvlist'" != "" {
		if "`fvrevar'" == "" {
			/* programmer error				*/
			di as err "{bf:_teffects_omit_var}: missing fvrevar"
			exit 198
		}
		OmitVariables `"`fvvlist'"' `"`fvrevar'"'
		local komit = `r(komit)'
		local index `"`r(index)'"'
		local varlist `"`r(varlist)'"'
		local k = `r(k)'
	}
	if "`const'" != "" {
		/* constant						*/
		local index `"`index' `++k'"'
		local varlist `"`varlist' `const'"'
		local `++kvar'
	}
	/* rep the index out klev times offsetting by offset		*/
	ExpandIndex `"`index'"' `kvar' `klev' `offset'

	return add
	return local komit = `komit'
	return local varlist `varlist'
end

program define OmitVariables, rclass
	args fvvlist fvrevar 

	local j = 0
	local k = 0
	local komit = 0
	foreach vi of local fvvlist {
		local tv : word `++j' of `fvrevar'
		local `++k'
		_ms_parse_parts `vi'
		if r(omit) {
			local `++komit'
		}
		else {
			local ind `"`ind' `k'"'
			local fvorevar `"`fvorevar' `tv'"'
		}
	}
	local fvorevar : list retokenize fvorevar
	local ind : list retokenize ind

	return local k = `k'
	return local komit = `komit'
	return local index `"`ind'"'
	return local varlist `"`fvorevar'"'
end

program define ExpandIndex, rclass
	args index k rep offset

	numlist "`index'"
	local index `"`r(numlist)'"'
	if `offset' {
		foreach i of numlist `index' {
			local ind `"`ind' `=`i'+`offset''"'
		}
		local index `"`ind'"'
	}
	else local ind `"`index'"'

	local k1 = `k'
	forvalues i=2/`rep' {
		foreach j of numlist `ind' {
			local index `"`index' `=`j'+`k''"'
		}
		local k = `k' + `k1'
	}

	return local index `"`index'"'
	return local k = `k'
end	

exit
