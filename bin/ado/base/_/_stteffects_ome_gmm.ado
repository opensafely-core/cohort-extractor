*! version 1.0.0  18nov2014

program define _stteffects_ome_gmm, sclass
	syntax, dist(string)  [ vlist(passthru) avlist(string) levels(string) ]

	if "`levels'" != "" {
		/* survival						*/
		local klev : list sizeof levels
		local k = `klev'
		local eq OME
		local what surv
	}
	else {
		/* censoring						*/
		local k = 1
		local klev = 0
		local eq CME
		local what censor
	}
	_stteffects_split_vlist, `vlist'
	local vlist `"`s(vlist)'"'
	local constant = ("`s(constant)'"=="")

	if `"`avlist'"' != "" {
		_stteffects_split_vlist, vlist(`avlist')
		local avlist `"`s(vlist)'"'
		local aconst = ("`s(constant)'"=="")
	}
	forvalues j=1/`k' {
		if (`klev') local lev : word `j' of `levels'

		local seqs "`seqs' `eq'`lev'"
		local eqs "`eqs' `eq'`lev'"
		local param `"`param' {`eq'`lev':`vlist'"'
		if (`constant') local param `"`param' _cons"'
		local param `"`param'}"'

		if "`dist'" != "exponential" {
			local eqs "`eqs' `eq'`lev'_lnshape"
			local aeqs "`aeqs' `eq'`lev'_lnshape"
			local param `"`param' {`eq'`lev'_lnshape:`avlist'"'
			if (`aconst') local param `"`param' _cons"'
			local param `"`param'}"'
		}
	}
	if `constant' {
		local opts `"`what'dist(`dist') instr(`seqs': `vlist')"'
	}
	else {
		local opts `"`what'dist(`dist') instr(`seqs': `vlist'"'
		local opts `"`opts',noconstant)"'
	}
	if "`dist'" != "exponential" {
		if `aconst' {
			local opts `"`opts' instr(`aeqs': `avlist')"'
		}
		else {
			local opts `"`opts' instr(`aeqs': `avlist',"'
			local opts `"`opts' noconstant)"'
		}
	}
	local seqs : list retokenize seqs
	local aeqs : list retokenize aeqs
	local eqs : list retokenize eqs
	local param : list retokenize param
	local opts : list retokenize opts

	sreturn local seqs `"`seqs'"'
	sreturn local aeqs `"`aeqs'"'
	sreturn local eqs `"`eqs'"'
	sreturn local param `"`param'"'
	sreturn local options `"`opts'"'
end

exit
