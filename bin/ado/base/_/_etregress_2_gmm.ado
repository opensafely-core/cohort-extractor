*! version 1.0.1  25aug2015
program _etregress_2_gmm
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
		tempvar m0 m1
		gen double `m0'=-normalden(`treatmu')/normal(-`treatmu')
		gen double `m1'=normalden(-`treatmu')/(normal(`treatmu'))
		tempname athrho0 lnsigma0 athrho1 lnsigma1
		scalar `athrho0' = `at'[1,`j'] 
		scalar `lnsigma0' = `at'[1,`j'+1]
		scalar `athrho1' = `at'[1,`j'+2]
		scalar `lnsigma1' = `at'[1,`j'+3]
		tempvar outmuold 
		qui gen double `outmuold' = `outmu' `if'
		replace `outmu' = `outmu' + ///
		    (1-`tvar')*tanh(`athrho0')*exp(`lnsigma0')*`m0' + ///
		    `tvar'*tanh(`athrho1')*exp(`lnsigma1')*`m1'
		local outcome: word 1 of `varlist'
		replace `outcome' = `y' - `outmu' `if'
		local treatmom: word 2 of `varlist'
		replace `treatmom' = `tvar'*`m1' + (1-`tvar')*`m0'
		local outm0: word 3 of `varlist'
		replace `outm0' = `y' - `outmu' `if'
		local outs0: word 4 of `varlist'
		replace `outs0' = (1-`tvar')*(`y'-`outmu')^2 - ///
			(1-`tvar')*(1-(tanh(`athrho0')^2)*`m0'* ///
			(`m0'+`treatmu'))*exp(`lnsigma0')^2 `if'
		local outm1: word 5 of `varlist'
		replace `outm1' = `y' - `outmu' `if'			
		local outs1: word 6 of `varlist'
		replace `outs1' = (`tvar')*(`y'-`outmu')^2 - ///
			(`tvar')*(1-(tanh(`athrho1')^2)*`m1'* ///
			(`m1'+`treatmu'))*exp(`lnsigma1')^2 `if'

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
				replace `dervw' = (1-`tvar')*((normal(- ///
				`treatmu')*(-(normalden(-`treatmu')*( 	///
				`treatmu')*(-`varw'))) - (-normalden( 	///
				-`treatmu'))*(normalden(-`treatmu')*( 	///
				-`varw')))/(normal(-`treatmu')^2)) + 	///
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
			)*(-(normalden(-`treatmu')*(`treatmu')*(-1))) -  ///
			 (-normalden(-`treatmu'))*(normalden(-`treatmu'  ///
			)*(-1)))/(normal(-`treatmu')^2)) + 		 ///
			(`tvar')*(((normal(`treatmu'))*( 		 ///
			normalden(-`treatmu')*(`treatmu')*(-1)) 	 ///
			-normalden(-`treatmu')*(-(-1)*normalden( 	 ///
			-`treatmu')))/((normal(`treatmu'))^2)) `if'
			local dtreatc `dervw'
			local i = `i' + 1
		}
	//ancillary parameters
		local dervw: word `i' of `derivatives'
		replace `dervw' = 0 `if'
		forvalues j = 1/3 {
			local i = `i' + 1
			local dervw: word `i' of `derivatives'
			replace `dervw' = 0 `if'	
		}
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
		if ("`treat'" != "") {
			local j = 1
			foreach varw of local treat {
				local dervw: word `i' of `derivatives'
				replace `dervw' = -`dtreat`j''*( 	   ///
				tanh(`athrho0')*exp(`lnsigma0')*(1-`tvar') ///
				+ tanh(`athrho1')* 			   ///
				exp(`lnsigma1')*(`tvar')) `if'
				local dotreat`j' `dervw'
				local i = `i' + 1
				local j = `j' + 1
			}
		}
		if ("`constantt'" != "noconstantt") {		
			local dervw: word `i' of `derivatives'
			replace `dervw' = -`dtreatc'*( 			///
			tanh(`athrho0')*exp(`lnsigma0')*(1-`tvar') 	///
			+ tanh(`athrho1')*exp(`lnsigma1')*(`tvar')) `if'
			local dotreatc `dervw'
			local i = `i' + 1
		}
		
	// ancillary parameters
		local dervw: word `i' of `derivatives'
		replace `dervw' = -`m0'*(1-tanh(`athrho0')^2)* ///
			exp(`lnsigma0')*(1-`tvar') `if'
		local doathrho0 `dervw'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = -`m0'*(tanh(`athrho0'))* ///
			exp(`lnsigma0')*(1-`tvar') `if'
		local dolnsigma0 `dervw'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = -`m1'*(1-tanh(`athrho1')^2)* ///
			exp(`lnsigma1')*(`tvar') `if'
		local doathrho1 `dervw'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = -`m1'*(tanh(`athrho1'))* ///
			exp(`lnsigma1')*(`tvar') `if'
		local dolnsigma1 `dervw'
		local i = `i' + 1
		local i = `oldi'
//outm0		
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
		replace `dervw' = `doathrho0'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = `dolnsigma0'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = `doathrho1'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = `dolnsigma1'
		local i = `i' + 1
//outs0
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
				replace `dervw' =  ///
				(1-`tvar')*2*(`y'-`outmu')*`dotreat`j'' ///
				-(1-`tvar')*(-(tanh(`athrho0')^2)* 	///
				(`dtreat`j''*(`m0'+`treatmu') + 	///
				`m0'*(`dtreat`j''+`varw')))* 		///
				exp(`lnsigma0')^2  `if'
				local i = `i' + 1
				local j = `j' + 1
			}
		}
		if ("`constantt'" != "noconstantt") {
			local dervw: word `i' of `derivatives'
			replace `dervw' =  ///
			(1-`tvar')*2*(`y'-`outmu')*`dotreatc' 	///
			-(1-`tvar')*(-(tanh(`athrho0')^2)* 	///
			(`dtreatc'*(`m0'+`treatmu') + 		///
			`m0'*(`dtreatc'+1)))* 			///
			exp(`lnsigma0')^2  `if'
			local i = `i' + 1
		}
	// ancillary parameters
		local dervw: word `i' of `derivatives'
		replace `dervw' = (1-`tvar')*2*(`y'-`outmu')*`doathrho0' ///
			 - (1-`tvar')*((-2*(tanh(`athrho0')* 		 ///
			(1-tanh(`athrho0')^2)))*`m0'* 			 ///
			(`m0'+`treatmu'))*exp(`lnsigma0')^2 `if'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = (1-`tvar')*2*(`y'-`outmu')*`dolnsigma0' ///
			-(1-`tvar')*(1-(tanh(`athrho0')^2)*`m0'* 	  ///
			(`m0'+`treatmu'))*(2)*exp(2*`lnsigma0') `if'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = 0 `if' 
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = 0 `if' 
		local i = `i' + 1		
//outm1		
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
		replace `dervw' = `doathrho0'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = `dolnsigma0'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = `doathrho1'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = `dolnsigma1'
		local i = `i' + 1
	
//outs1
	//outcome parameters
		if ("`out'" != "") {
			foreach varw of local out {
				local dervw: word `i' of `derivatives'
				replace `dervw' = (`tvar')*2* ///
					(`y'-`outmu')*(-`varw') `if'
				local i = `i' + 1
			}
		}
		if ("`constant'" != "noconstant") {
			local dervw: word `i' of `derivatives'
			replace `dervw' = (`tvar')*2* ///
					(`y'-`outmu')*(-1) `if'
			local i = `i' + 1
		}
	//treatment parameters
		if ("`treat'" != "") {	
		 	local j = 1
			foreach varw of local treat {
				local dervw: word `i' of `derivatives'
				replace `dervw' =  ///
				(`tvar')*2*(`y'-`outmu')*`dotreat`j'' 	///
				-(`tvar')*(-(tanh(`athrho1')^2)* 	///
				(`dtreat`j''*(`m1'+`treatmu') + 	///
				`m1'*(`dtreat`j''+`varw')))* 		///
				exp(`lnsigma1')^2  `if'
				local i = `i' + 1
				local j = `j' + 1
			}
		}
		if ("`constantt'" != "noconstantt") {
			local dervw: word `i' of `derivatives'
			replace `dervw' =  			///
			(`tvar')*2*(`y'-`outmu')*`dotreatc' 	///
			-(`tvar')*(-(tanh(`athrho1')^2)* 	///
			(`dtreatc'*(`m1'+`treatmu') + 		///
			`m1'*(`dtreatc'+1)))* 			///
			exp(`lnsigma1')^2  `if'
			local i = `i' + 1
		}					
	//ancillary parameters
		local dervw: word `i' of `derivatives'
		replace `dervw' = 0 `if' 
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = 0 `if' 
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = (`tvar')*2*(`y'-`outmu')*`doathrho1'  ///
			 - (`tvar')*((-2*(tanh(`athrho1')* 		///
			(1-tanh(`athrho1')^2))))*`m1'* 			///
			(`m1'+`treatmu')*exp(`lnsigma1')^2 `if'
		local i = `i' + 1
		local dervw: word `i' of `derivatives'
		replace `dervw' = (`tvar')*2*(`y'-`outmu')*`dolnsigma1' ///
			-(`tvar')*(1-(tanh(`athrho1')^2)*`m1'* 		///
			(`m1'+`treatmu'))*(2)*exp(2*`lnsigma1') `if'
		local i = `i' + 1	
	}
end
