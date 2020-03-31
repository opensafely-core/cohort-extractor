*! version 1.0.1  15jan2012
program _ivpoisson_cmult
	version 13.0
	syntax varlist if [aw fw iw pw], at(name) 	///
		lhs(varlist ts) endog(varlist ts) 	///
		[offset(varlist ts) noconstant		///
		exog(varlist ts) zinst(varlist ts)	///
		derivatives(varlist)]
	qui {
		tempvar estendog
		gen double `estendog'=.
		local forendog `exog' `zinst'
		local forlhs `exog' `endog'
		local forlhs2 
		local rj = 2
		local pcnt: word count `exog' `endog'
		if ("`constant'" != "noconstant") {
			local pj = `pcnt' + 2
		}
		else {
			local pj = `pcnt' + 1
		}	
		if ("`endog'" != "") {
			foreach endogvar of varlist `endog' {
				replace `estendog' = 0 `if'
				foreach var of varlist `forendog' {
					replace `estendog' = `estendog' + ///
						`var'*`at'[1,`pj'] `if'
					local pj = `pj'+1
				}
				replace `estendog' = ///
					`estendog'+`at'[1,`pj'] `if' 
				local pj = `pj'+1
				local momeq: word `rj' of `varlist'
				replace `momeq' = `endogvar'-`estendog' `if'
				local forlhs2 `forlhs2' `momeq'
				local rj = `rj'+1	
			}
		}
		local pj = 1
		tempvar estlhs
		gen double `estlhs' = 0
		foreach var of local forlhs {
			replace `estlhs' = `estlhs' + ///
				`var'*`at'[1,`pj'] `if'
			local pj = `pj' + 1
		}
		if ("`offset'" != "") {
			replace `estlhs' = `estlhs' + ///
			`offset' `if'
		}
		if ("`constant'" != "noconstant") {
			replace `estlhs' = `estlhs'+`at'[1,`pj'] `if'
			local pj = `pj' + 1
		}
		local endogcnt: word count `endog'
		local pj = colsof(`at')- `endogcnt'+1
		foreach var of local forlhs2 {
			replace `estlhs' = `estlhs' + ///
				`var'*`at'[1,`pj'] `if'
			local pj = `pj' + 1
		} 
		local momeq: word 1 of `varlist'
		replace `momeq' = `lhs'/exp(`estlhs') - 1 `if'
		local momcnt: word count `varlist'
		forvalues i=`rj'/`momcnt' {
			local momeq`i': word `i' of `varlist'
			replace `momeq`i'' = `momeq' `if'
		}
		if "`derivatives'" == "" {
			exit
		}

		//moment 1, lhs
			// exog, endog
		local dcnt: word count `forlhs'
		forvalues i = 1/`dcnt' {
			local derv: word `i' of `derivatives'
			local var: word `i' of `forlhs'
			replace `derv' = -`lhs'*`var'*exp(-`estlhs') `if'
		}
			// constant
		if ("`constant'" != "noconstant") {
			local dcnt = `dcnt'+1
			local derv: word `dcnt' of `derivatives'
			replace `derv' = -`lhs'*exp(-`estlhs') `if'
		}
		local dcnt = `dcnt' + 1
			// endogenous regression parameters
		if ("`endog'" != "") {
			local endogcnt: word count `endog'
			local endogind = 1
			foreach endogvar of varlist `endog' {
				local cindex=colsof(`at') 
				local cindex=`cindex'-(`endogcnt'-`endogind')
				foreach var of varlist `forendog' {
					local derv: word `dcnt' of ///
						`derivatives'
					replace `derv' = `lhs'* ///
						`at'[1,`cindex']* ///
						`var'*exp(-`estlhs') `if'
					local dcnt = `dcnt'+1
				}	
				local derv: word `dcnt' of `derivatives'
				replace `derv' = `lhs'* ///
					`at'[1,`cindex']* ///
					exp(-`estlhs') `if'
				local dcnt = `dcnt' + 1
				local endogind = `endogind' + 1
			}
		}
			// control parameters
		foreach var of local forlhs2 {
			local derv: word `dcnt' of `derivatives'
			replace `derv' = -`lhs'*`var'*exp(-`estlhs') `if'
			local dcnt = `dcnt'+1
		}

		// endogenous regressor moments
		if ("`endog'" != "") {
			local endogind = 1
			local endogcnt: word count `endog'

			foreach endogvar of varlist `endog' {
				local zerocnt: word count `forlhs'
				forvalues i = 1/`zerocnt' {
					local derv: word `dcnt' of ///
						`derivatives'
					replace `derv' = 0 `if'
					local dcnt = `dcnt' + 1
				}
				if ("`constant'" != "noconstant") {
					// now constant
					local derv : ///
					word `dcnt' of `derivatives'
					replace `derv' = 0 `if'
					local dcnt = `dcnt' + 1	
				}
				
				//zero out ols before
				local forendogcnt: word count `forendog'
				local zerocnt = (`endogind'-1)*`forendogcnt'
				if (`zerocnt' > 1) {
					local dcntlast = `dcnt'
					local dcntlastp1 = `dcntlast'+`zerocnt'
					forvalues i=`dcntlast'/`dcntlastp1' {
						local derv: word `dcnt' of ///
							`derivatives'
						replace `derv' = 0 `if'
						local dcnt = `dcnt' + 1
					}							
				}
				// now onto regular ols coefficients
				foreach var of varlist `forendog' {
					local derv: word `dcnt' of ///
						`derivatives'
					replace `derv' = -`var' `if'
					local dcnt = `dcnt' + 1
				}
				// and ols constant
				local derv: word `dcnt' of `derivatives'
				replace `derv' = -1 `if'
				local dcnt = `dcnt' + 1

				// zero out ols after
				local zerocnt = ///
					(`endogcnt'-`endogind')*`forendogcnt'
				if (`zerocnt' > 1) {
					local dcntlast = `dcnt'
					local dcntlastp1 = `dcntlast'+`zerocnt'
					forvalues i=`dcntlast'/`dcntlastp1' {
						local derv: word `dcnt' of ///
							`derivatives'
						replace `derv' = 0 `if'
						local dcnt = `dcnt' + 1
					}			
				}
				// now control parameters
				foreach var of local forlhs2 {
					local derv: word `dcnt' ///
						of `derivatives'
					replace `derv' = 0 `if'
					local dcnt = `dcnt'+1
				}				
				local endogind = `endogind'+1
			}
		}
		// control moments
		if ("`endog'" != "") {
			local nparams = colsof(`at')
			foreach endogvar of varlist `endog' {
				forvalues i = 1/`nparams' {
					local derivold: ///
						word `i' of `derivatives'
					local derv: ///
						word `dcnt' of `derivatives'
					replace `derv' = `derivold'
					local dcnt = `dcnt' + 1
				}
			}
		}
	}
end		
exit
