*! version 1.0.0  02may2019

program meta__validate_fixed, sclass
	version 16
	syntax, [ meth(string) MHaenszel INVVARiance IVariance *]
	
	sreturn clear
	
	local which `mhaenszel' `invvariance' `ivariance'
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:`meth'()} specification: "  ///
		 "only one of {bf:mhaenszel}, {bf:invvariance}, "   ///
		 "or {bf:ivariance} can be specified{p_end}"
		exit 184
	}
	if !`k' {
		if "`options'" != "" {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:`meth'()} specification: " ///
		 	 "estimation method {bf:`op'} not allowed{p_end}"
			exit 198
		}
	}
	else {
		local which : list retokenize which
	}
	
	local dtatyp : char _dta[_meta_datatype]
	
	if ("`which'" == "mhaenszel" & "`dtatyp'" == "Generic") {
		di as err "invalid option {bf:`meth'(mhaenszel)}"
		di as err "{p 4 4 2}Mantel-Haenszel method cannot be applied "
		di as err "with generic effect sizes.{p_end}"
		exit 198
	}
	if ("`which'" == "mhaenszel" & "`dtatyp'" == "continuous") {
		di as err "invalid option {bf:`meth'(mhaenszel)}"
		di as err "{p 4 4 2}Mantel-Haenszel method cannot be applied "
		di as err "with continuous data.{p_end}"
		exit 198
	}
	sreturn local femodel `which'
end
