*! version 1.0.0  12jan2015

program define _stteffects_gmm_var, rclass
	syntax varlist(numeric), eqs(string) [ eq(string) req(string) ///
		ceq(string) ]
	
	if "`eq'" != "" {
		/* moment variable					*/
		local i : list posof "`eq'" in eqs
		if !`i' {
			/* programmer error				*/
			di as err "{p}equation `eq' is not one of the " ///
			 "moment equations{p_end}"
			exit 198
		}
		local var : word `i' of `varlist'

		return local varname `var'
		exit
	}
	/* derivative variable 						*/
	local i : list posof "`req'" in eqs
	local j : list posof "`ceq'" in eqs
	if !`i' | !`j' {
		if (!`i') local eq `req'
		else local eq `ceq'
		/* programmer error				*/
		if "`eq'" == "" {
			if (!`i') local what req()
			else local what ceq()

			di as err "option {bf:`what'} required"
		}
		else {
			di as err "{p}equation `eq' is not one of the " ///
			 "moment equations{p_end}"
		}
		exit 198
	}
	local keq : list sizeof eqs
	local k = (`i'-1)*`keq' + `j'

	local var : word `k' of `varlist'

	return local varname `var'
end

exit
