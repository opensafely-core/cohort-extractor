*! version 1.2.0  30mar2018
program _me_parse, sclass
	version 14
	
	_parse expand eq opt : 0
	local gopts `opt_op'
	
	forvalues i=1/`=`eq_n'-1' {
		local 0 `eq_`i''
		syntax [anything] [if] [in] [fw pw iw] [, ///
			Family(passthru) Link(passthru) Dispersion(string) *]
		if `"`dispersion'"' != "" {
			di as err "option {bf:dispersion()} not allowed"
			exit 198
		}
		if `i' == 1 {
			if `"`opt_if'"' != "" {
				local if `if' `opt_if'
			}
			if `"`opt_in'"' != "" {
				local if `in' `opt_in'
			}
		}
		if "`weight'" != "" local wopt [`weight'`exp']
		else local wopt
		
		local fam `fam' `family'
		local lin `lin' `link'
		
		mlopts mls options, `options'
		local mlopts `mlopts' `mls'
		
		_get_diopts dis options, `options'
		local diopts `diopts' `dis'
		
		_getmore_diopts, `options'
		local dixtra `dixtra' `s(dixtra)'
		local diopts `diopts' `s(more)'
		local options `s(options)' `family' `link'
		
		local eqs `eqs' `anything' `if' `in' `wopt', `options' ||
	}
	
	local 0 `eq_`eq_n''
	syntax [anything] [if] [in] [fw pw iw] [, ///
		Family(passthru) Link(passthru) *]
	if `eq_n' == 1 {
		if `"`opt_if'"' != "" {
			local if `if' `opt_if'
		}
		if `"`opt_in'"' != "" {
			local if `in' `opt_in'
		}
	}
	if "`weight'" != "" {
		local eqn `anything' `if' `in' [`weight'`exp']
	}
	else {
		local eqn `anything' `if' `in'
	}
	
	local fam `fam' `family'
	local lin `lin' `link'
	
	local options `options' `gopts'

	mlopts mls options, `options'
	local mlopts `mlopts' `mls'

	_get_diopts dis options, `options'
	local diopts `diopts' `dis'

	_getmore_diopts, `options'
	local dixtra `dixtra' `s(dixtra)'
	local diopts `diopts' `s(more)'
	local options `s(options)' `family' `link'

	local diopts : list uniq diopts	

	local dixtra : list uniq dixtra
	opts_exclusive "`dixtra'"

	local 0 `eqs' `eqn' , `options' `mlopts' `diopts' `dixtra'

	sreturn local newsyntax `0'
	sreturn local diopts `diopts' `dixtra'
	sreturn local family `fam'
	sreturn local link `lin'
end

program _getmore_diopts, sclass
	syntax [, noTABle noLRtest noGRoup noHEADer noESTimate ///
		COEFLegend or irr eform EFORM1(passthru) *]
	sreturn clear
	sreturn local more `table' `lrtest' `group' `header' ///
		`estimate' `coeflegend'
	sreturn local dixtra `or' `irr' `eform' `eform1'
	sreturn local options `options'
end

