*! version 1.0.3  26feb2019

program ucm_p, rclass
	version 12

	syntax anything(name=vlist id="varlist") [if] [in] [, xb TRend ///
			SEAsonal CYCles rmse(string) * ]

	TrapJunk, `options'

	local version = cond(missing(e(version)),1,e(version))
	local wc = `:word count `xb' `trend' `seasonal' `cycles'' 
	if `wc' > 1 { 
		di as err "{p}options {bf:xb}, {bf:trend}, and " ///
		 "{bf:seasonal} may not be combined{p_end}"
		exit 184 
	}
	if "`xb'"!="" | `wc'==0 {
		_sspace_p `vlist' `if'`in', `xb' rmse(`rmse') `options'

		exit
	}
	if "`cycles'" != "" {
		if e(k_cycles) == 0 {
			di as err "{p}{bf:cycles} is invalid; there are " ///
			 "no cycles in the model{p_end}"
			exit 322
		}
		local nvar = e(k_cycles)
	}
	else local nvar = 1

	_stubstar2names `vlist', nvars(`nvar') 

	local vlist `s(varlist)'
	local vtype : word 1 of `s(typlist)'

	if "`rmse'" != "" {
		sreturn clear

		_stubstar2names `rmse', nvars(`nvar') 
		local rvlist `s(varlist)'
		local rtype : word 1 of `s(typlist)'
	}
	local state_deps `e(state_deps)'
	if `version' < 2 {
		/* var(<component>):_cons				*/
		local eqnames `e(eqnames)'
	}
	else {
		/* /:var(<component>)					*/
		local eqnames : colnames e(b)
	}
	if "`seasonal'" != "" {
		if `:list posof "seasonal" in state_deps' == 0 {
			di as err "there is no seasonal component in the model"
			exit 322
		}
		if "`rvlist'" != "" {
			if `:word count `rvlist'' > 1 {
				di as err "{p}invalid {bf:rmse()}; only " ///
				 "one variable name allowed{p_end}"
				exit 198
			}
			local rmseopt rmse(`rtype' `rvlist')
		}
		_sspace_p `vtype' `vlist' `if'`in', state eq(seasonal) ///
			`rmseopt' `options'

		ParseSMethod, `options'
		local smethod `s(smethod)'

		if !`:list posof "var(seasonal)" in eqnames' {
			local fix "fixed "
		}
		label variable `vlist' "`fix'seasonal`smethod'"

		if "`rvlist'" != "" {
			label variable `rvlist' "`fix'seasonal RMSE`smethod'"
		}
		exit
	}
	else if "`cycles'" != "" {
		ParseSMethod, `options'
		local smethod `s(smethod)'

		forvalues ic=1/`=e(k_cycles)' {
			local vari : word `ic' of `vlist'
			local eqopt eq(cycle`ic'_1_1)
			if "`rvlist'" != "" {
				local rvari : word `ic' of `rvlist'
				local rmseopt rmse(`rtype' `rvari')
			}
			_sspace_p `vtype' `vari' `if'`in', state `eqopt' ///
				`rmseopt' `options'

			if !`:list posof "var(cycle`ic')" in eqnames' {
				local fix "fixed "
			}
			label variable `vari' "`fix'cycle`ic'`smethod'"

			if "`rvlist'" != "" {
				label variable `rvari' ///
					"`fix'cycle`ic' RMSE`smethod'"
			}
		}
		exit
	}
	if `:list posof "level" in state_deps' {
		local eq level
		tempvar trend
		if ("`rvlist'"!="") tempvar rmsel
	}
	if "`eq'" == "" {
		di as err "there is no trend component in the model"
		exit 198
	}
	if ("`rmsel'" != "") local rmseopt rmse(double `rmsel')

	_sspace_p double `trend' `if'`in', state eq(`eq') `rmseopt' `options'

	ParseSMethod, `options'
	local smethod `s(smethod)'


	qui gen `vtype' `vlist' = `trend'
	if ("`rmsel'"!="") qui gen `rtype' `rvlist' = `rmsel'

	label variable `vlist' "trend`smethod'"

	if ("`rmsel'"!="") label variable `rvlist' "trend RMSE`smethod'"
end

program define TrapJunk
	version 12
	syntax [, EQuation(string) STates * ]

	local opts equation states

	foreach opt of local opts {
		if "``opt''" != "" {
			di as err `"{p}option {bf:`opt'} is not allowed{p_end}"'
			exit 198
		}
	}
end

program define ParseRMSE, sclass
	version 12
	syntax [newvarlist(numeric max=1)] [, rmse(string) * ]

	if "`rmse'" != "" {
		ParseRMSE `rmse', `options'
		exit
	}
	sreturn local options `options'
	sreturn local varlist `varlist'
	sreturn local typlist `typlist'
end

program define ParseSMethod, sclass
	version 12
	syntax [, SMETHod(string) ONEstep FIlter SMooth * ]

	if "`smethod'" != "" {
		ParseSMethod, `smethod'
		exit
	}
	if ("`onestep'`filter'`smooth'"=="") sreturn local smethod ", onestep"
	else sreturn local smethod ", `onestep'`filter'`smooth'"
end

exit

