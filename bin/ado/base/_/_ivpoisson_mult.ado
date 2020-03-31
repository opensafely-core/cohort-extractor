*! version 1.0.1  03jun2012
program _ivpoisson_mult
	version 13.0
	syntax varlist if [aw fw iw pw], at(name) ///
		lhs(varlist ts) [offset(varlist ts) noconstant ///
		rhs(varlist ts)] [derivatives(varlist)]
	qui {
		tempvar mu
		gen double `mu' = 0 `if'
		local j = 1
		if ("`rhs'" != "") {
			foreach var of varlist `rhs' {
				replace `mu' = `mu' + `var'*`at'[1,`j'] `if'
				local j = `j' + 1
			}
		}
		if ("`offset'" != "") {
			replace `mu' = `mu' + `offset' `if'
		}	
		if ("`constant'" != "noconstant") {
			replace `mu' = `mu' + `at'[1,`j'] `if'
		}
		replace `varlist' = `lhs'/exp(`mu') - 1 `if'
		if "`derivatives'" == "" {
			exit
		}
		local wc: word count `derivatives'
		if ("`constant'" != "noconstant") {
			local wc1 = `wc'-1
		}
		else {
			local wc1 = `wc'
		}
		// loop through coefficients, leave constant for later
		if (`wc1' >= 1) {
			forvalues j=1/`wc1' {
				local d`j': word `j' of `derivatives'
				local v`j': word `j' of `rhs'
				replace `d`j'' = -`lhs'*`v`j''*exp(-`mu') `if'
			}
		}
		if (`wc' > `wc1') {
			local d`wc': word `wc' of `derivatives'
			replace `d`wc'' = -`lhs'*exp(-`mu') `if'
		}
	}			
end
exit
