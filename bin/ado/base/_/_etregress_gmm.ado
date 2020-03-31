*! version 1.0.1  25aug2015
program _etregress_gmm
	version 14.0
	syntax varlist if [aw fw iw pw], at(name) ///
	y(varlist ts) tvar(varlist ts fv) [treat(string) ///
	out(string) noconstant noconstantt ///
	derivatives(varlist)]
	qui {
		local j = 1
		tempvar outmu treatmu
		gen double `outmu' = 0 `if'
		gen double `treatmu' = 0 `if'
		if ("`out'" != "") {
			foreach var of local out {
				replace `outmu' = `outmu' + ///
				`var'*`at'[1,`j'] `if'
				local j = `j' + 1
			}
			if `"`constant'"' != "noconstant" {
				replace `outmu' = `outmu' + `at'[1,`j'] `if'
				local j = `j' + 1
			}			
		}
		if ("`treat'" != "") {
			foreach var of local treat {
				replace `treatmu' = ///
					`treatmu' + `var'*`at'[1,`j'] `if'
				local j = `j' + 1
			}
		}
		if `"`constantt'"' != "noconstantt" {
			replace `treatmu' = `treatmu' + `at'[1,`j']
			local j = `j' + 1
		}
		tempvar m
		gen double `m'= ///
		`tvar'*normalden(`treatmu')/normal(`treatmu') - ///
		 (1-`tvar')*normalden(`treatmu')/(normal(-`treatmu'))
		tempname athrho lnsigma
		scalar `athrho' = `at'[1,`j'] 
		scalar `lnsigma' = `at'[1,`j'+1]
		replace `outmu' = `outmu' + ///
		    tanh(`athrho')*exp(`lnsigma')*`m' 
		local outcome: word 1 of `varlist'
		replace `outcome' = `y' - `outmu' `if'
		local treatmom: word 2 of `varlist'
		replace `treatmom' = `m'
		local outm: word 3 of `varlist'
		replace `outm' = `outcome' `if'		
		local outs: word 4 of `varlist'
		replace `outs' = (`y'-`outmu')^2 - ///
			(1-(tanh(`athrho')^2)*`m'* ///
			(`m'+`treatmu'))*exp(`lnsigma')^2 `if'
		if "`derivatives'" == "" {
			exit
		}
		local nparams = colsof(`at')

//treatment equation
	//outcome parameters
		local wc: word count `out'
		if ("`constant'" != "noconstant") {
			local wc = `wc' + 1
		}
		local i = `nparams' + 1
		local j = 1
		while `j' < `wc' + 1 {
			local dervw: word `i' of `derivatives'
			replace `dervw' = 0 `if'
			local i = `i' + 1
			local j = `j' + 1
		}
	//treatment parameters
		if ("`treat'" != "") {
			local j = 1
			foreach varw of local treat {
				local dervw: word `i' of `derivatives'
				replace `dervw' = (1-`tvar')* 		///
				((normal(-`treatmu')*(-(normalden( 	///
				-`treatmu')*(`treatmu')*(-`varw'))) 	///
				- (-normalden(-`treatmu'))*(normalden( 	///
				-`treatmu')*(-`varw')))/(normal( 	///
				-`treatmu')^2)) + 			///
				(`tvar')*(((normal(`treatmu'))*( 	///
				normalden(-`treatmu')*(`treatmu')*( 	///
				-`varw'))-normalden(-`treatmu')*(-( 	///
				-`varw')*normalden(-`treatmu')))/(( 	///
				normal(`treatmu'))^2)) `if'
				local  dtreat`j' `dervw'
				local i = `i' + 1
				local j = `j' + 1
			}
		}	
		if ("`constantt'" != "noconstantt") {
			local dervw: word `i' of `derivatives'
			replace `dervw' = (1-`tvar')*((normal(-`treatmu' ///
			 )*(-(normalden(-`treatmu')*(`treatmu')*(-1))) - ///
			(-normalden(-`treatmu'))*(normalden(-`treatmu')* ///
			(-1)))/(normal(-`treatmu')^2)) + 		 ///
			(`tvar')*(((normal(`treatmu'))*(normalden(    ///
			-`treatmu')*(`treatmu')*(-1))-normalden(         ///
			-`treatmu')*(-(-1)*normalden(-`treatmu')))/((   ///
			normal(`treatmu'))^2)) `if'
			local dtreatc `dervw'
			local i = `i' + 1
		}
	//ancillary parameters
		local dervw: word `i' of `derivatives'
		replace `dervw' = 0 `if'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = 0 `if'
		local i = `i' + 1
		local oldi = `i'
	local i = 1
// outcome equation
	//outcome parameters
		if ("`out'" != "") {
			foreach varw of local out {
				local dervw: word `i' of `derivatives'
				replace `dervw' = -`varw' `if'
				local i = `i' + 1
			}				
		}
		if ("`constant'" != "noconstant") {
			local dervw: word `i' of `derivatives'
			replace `dervw' = -1 `if'
			local i = `i' + 1
		}
	// treatment parameters
		local ncol= colsof(`at')
		if ("`treat'" != "") {
			local j = 1
			foreach varw of local treat {
				local dervw: word `i' of `derivatives'
				replace `dervw' = -`dtreat`j''*( ///
				tanh(`athrho')*exp(`lnsigma')) `if'
				local dotreat`j' `dervw'
				local i = `i' + 1
				local j = `j' + 1
			}
		}
		if ("`constantt'" != "noconstantt") {		
			local dervw: word `i' of `derivatives'
			replace `dervw' = -`dtreatc'*( ///
			tanh(`athrho')*exp(`lnsigma')) `if'
			local dotreatc `dervw'
			local i = `i' + 1
		}
	// ancillary parameters
		local dervw: word `i' of `derivatives'
		replace `dervw' = -`m'*(1-tanh(`athrho')^2)* ///
			exp(`lnsigma') `if'
		local doathrho `dervw'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = -`m'*(tanh(`athrho'))* ///
			exp(`lnsigma') `if'
		local dolnsigma `dervw'
		local i = `i' + 1
		local i = `oldi'
//outm 		
	//outcome parameters
		if ("`out'" != "") {
			foreach varw of local out {
				local dervw: word `i' of `derivatives'
				replace `dervw' = -`varw' `if'
				local i = `i' + 1
			}				
		}
		if ("`constant'" != "noconstant") {
			local dervw: word `i' of `derivatives'
			replace `dervw' = -1 `if'
			local i = `i' + 1
		}
	// treatment parameters
		local ncol= colsof(`at')
		if ("`treat'" != "") {
			local j = 1
			foreach varw of local treat {
				local dervw: word `i' of `derivatives'
				replace `dervw' = `dotreat`j''
				local i = `i' + 1
				local j = `j' + 1
			}
		}
		if ("`constantt'" != "noconstantt") {		
			local dervw: word `i' of `derivatives'
			replace `dervw' = `dotreatc'
			local i = `i' + 1
		}
	// ancillary parameters
		local dervw: word `i' of `derivatives'
		replace `dervw' = `doathrho'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = `dolnsigma'
		local i = `i' + 1		
//outs
	//outcome parameters
		if ("`out'" != "") {
			foreach varw of local out {
				local dervw: word `i' of `derivatives'
				replace `dervw' = (1-`tvar')*2* ///
					(`y'-`outmu')*(-`varw') `if'
				local i = `i' + 1
			}
		}
		if ("`constant'" != "noconstant") {
			local dervw: word `i' of `derivatives'
			replace `dervw' = (1-`tvar')*2* ///
				(`y'-`outmu')*(-1) `if'
			local i = `i' + 1
		}

	//treatment parameters
		if ("`treat'" != "") {			 
			local j = 1
			foreach varw of local treat {
				local dervw: word `i' of `derivatives'
				replace `dervw' = 0
				replace `dervw' =  ///
				2*(`y'-`outmu')*`dotreat`j'' ///
				-(-(tanh(`athrho')^2)* ///
				(`dtreat`j''*(`m'+`treatmu') + ///
				`m'*(`dtreat`j''+`varw')))* ///
				exp(`lnsigma')^2  `if'
				local i = `i' + 1
				local j = `j' + 1
			}
		}
		if ("`constantt'" != "noconstantt") {
			local dervw: word `i' of `derivatives'
			replace `dervw' = 0
			replace `dervw' =  ///
			2*(`y'-`outmu')*`dotreatc' ///
			-(-(tanh(`athrho')^2)* ///
			(`dtreatc'*(`m'+`treatmu') + ///
			`m'*(`dtreatc'+1)))* ///
			exp(`lnsigma')^2  `if'
			local i = `i' + 1
		}

	// ancillary
		local dervw: word `i' of `derivatives'
		replace `dervw' = 2*(`y'-`outmu')*`doathrho' ///
			 - ((-2*(tanh(`athrho')* ///
			(1-tanh(`athrho')^2)))*`m'* ///
			(`m'+`treatmu'))*exp(`lnsigma')^2 `if'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = 2*(`y'-`outmu')*`dolnsigma' ///
			-(1-(tanh(`athrho')^2)*`m'* ///
			(`m'+`treatmu'))*(2)*exp(2*`lnsigma') `if'
		local i = `i' + 1
	}
end
