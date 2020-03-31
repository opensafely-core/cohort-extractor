*! version 1.3.0  19feb2019
program etpoisson_p
	version 13.0
        if "`e(cmd)'" != "etpoisson" {
                error 301
        }
	syntax anything(id="newvarlist") [if] [in] [, POMean OMean  ///
		SCores xb 		///
		XBTreat pr(string) 	///
		cte			///
		te TIrr /* undoc 
		*/	*]
	
	if ("`pomean'`omean'`tirr'`te'`xbtreat'`pr'`cte'" == "" & ///
		("`scores'" != "" | "`xb'" != "")) {
		if ("`scores'" != "") {
			tempvar touse
			qui gen byte `touse' = 0
			qui replace `touse' = 1 `if' `in'
			qui markout `touse' `e(response)' ///
			`e(switch)' `e(swl)' `e(mlist)'
			tempvar lfy
			qui gen double `lfy' = lngamma(`e(response)'+1) ///
				if `touse'
			nobreak {	
				mata: _etpoisson_init("inits", ///
					"`lfy'","`e(intpoints)'", "`touse'")
				capture noisily break {
					ml_p `0' userinfo(`inits')
				}
				local erc = _rc
				capture mata: rmexternal("`inits'")
				if (`erc') {
					exit `erc'
				}
			}	
		}
		else {
			ml_p `0'
		}
		exit
	}
	
	syntax newvarlist(min=1 max=1 numeric) [if] [in], 	///
		[POMean OMean					///
		 TIrr te XBTreat pr(string) noOFFset cte	///
		 density(string) intpoints(string) ]  ///undoc

	tempvar touse
	qui gen `touse' = 0
	qui replace `touse' = 1 `if' `in'
	if ("`xbtreat'" != "" & ///
		"`pomean'`omean'`tirr'`pr'`te'`cte'" != "") {
		opts_exclusive "pomean omean cte tirr pr() xb xbtreat"
	}
	if ("`pr'" != "" & ///
		"`pomean'`omean'`tirr'`te'`cte'"!="") {
		opts_exclusive "pomean omean cte tirr pr() xb xbtreat"
	}
	if ("`omean'" != "" & ///
		"`pomean'`tirr'`te'`cte'" != "") {
		opts_exclusive "pomean omean cte tirr pr() xb xbtreat"
	}
	if ("`tirr'" != "" & ///
		"`pomean'`te'`cte'" != "") {
		opts_exclusive "pomean omean cte tirr pr() xb xbtreat"
	}
	if ("`pomean'" != "" & ///
		"`te'`cte'" != "") {
		opts_exclusive "pomean omean cte tirr pr() xb xbtreat"
	}
	if ("`te'" != "" & ///
		"`cte'" != "") {
		opts_exclusive "pomean omean cte tirr pr() xb xbtreat"
	}
	if ("`xbtreat'" != "") {
		ml_p `typlist' `varlist' if `touse', equation(#2) `offset'
		local trtname: word 2 of `e(depvar)'
		label variable `varlist' ///
			"Linear prediction for `trtname'"
		exit
	}
	if "`omean'`pomean'`tirr'`pr'`te'`cte'`density'" == "" {
		local pomean pomean
		di as text ///
		"(option {bf:pomean} assumed; potential-outcome mean)"
	}
	if `:colnfreeparms e(b)' {
		local lns _b[/lnsigma]
		local ath _b[/athrho]
	}
	else {
		local lns [lnsigma]_b[_cons]
		local ath [athrho]_b[_cons]
	}
	if ("`cte'" != "") {
		nobreak {	
			tempvar xb0 xb1 dorig za
			tempname sigma rho
			qui gen byte `dorig' = `e(switch)' if `touse'
			qui replace `e(switch)' = 0 if `touse'
			qui _predict double `xb0' if `touse', ///
				equation(#1)  `offset' 
			qui replace `e(switch)' = 1 if `touse'
			qui _predict double `xb1' if `touse', ///
				equation(#1)  `offset' 
			qui replace `e(switch)' = `dorig' if `touse'
			qui _predict double `za' if `touse', ///
				equation(#2) `offset'
			scalar `sigma' = exp(`lns')
			scalar `rho' =  (expm1(2*`ath')) / ///
					(exp(2*`ath')+1)
			tempvar onswitch
			qui gen double `onswitch' =  ///
				normal(`rho'*`sigma'+`za')/normal(`za')	///
				if `e(switch)' == 1 & `touse'
			qui replace `onswitch' = ///
				(1-normal(`rho'*`sigma'+`za'))/  ///
				(1-normal(`za')) if !`e(switch)' & `touse' 
				 
			gen `typlist' `varlist' =  	 ///
				exp(((`sigma'^2)/2))*	 ///
				(exp(`xb1')-exp(`xb0'))*`onswitch' ///
				if `touse'			
			label variable `varlist' ///
			"Conditional treatment effect"		
		}
	}
	if ("`omean'" != "") {
		tempvar xb za
		qui _predict double `xb' if `touse', equation(#1) `offset'
		qui _predict double `za' if `touse', equation(#2) `offset'
		tempname sigma rho
		scalar `sigma' = exp(`lns')
		scalar `rho' =  (expm1(2*`ath')) / ///
				(exp(2*`ath')+1)
		tempvar onswitch
		qui gen double `onswitch' =  ///
			normal(`rho'*`sigma'+`za')/normal(`za')	///
			if `e(switch)' == 1 & `touse'
		qui replace `onswitch' = ///
			(1-normal(`rho'*`sigma'+`za'))/  ///
			(1-normal(`za')) if !`e(switch)' & `touse' 
		gen `typlist' `varlist' =  		 ///
			exp(((`sigma'^2)/2) + `xb')*`onswitch' if `touse'
		label variable `varlist' "Observed mean"
	}
	if ("`pomean'" != "") {
		tempvar xb
		qui _predict double `xb' if `touse', equation(#1) `offset'
		tempname sigma
		scalar `sigma' = exp(`lns')
		gen `typlist' `varlist' = exp(((`sigma'^2)/2) + `xb')	
		label variable `varlist' "Potential-outcome mean"
	}
	if ("`tirr'" != "") {
		tempvar dorig tirr tirr0
		nobreak {	
			qui gen byte `dorig' = `e(switch)' if `touse'
			qui replace `e(switch)' = 1 if `touse'
			qui _predict double `tirr' if `touse', ///
				equation(#1)  `offset' 
			qui replace `e(switch)' = 0 if `touse'
	                qui _predict double `tirr0' if `touse', ///
				equation(#1) `offset'
			gen `typlist' `varlist' = exp(`tirr'-`tirr0') ///
				if `touse'
			qui replace `e(switch)' = `dorig' if `touse'
			label variable `varlist' "Treatment IRR"
		}
	}
	if ("`te'" != "") {
		tempvar xb0 xb1 za dorig
		nobreak {
			qui gen byte `dorig' = `e(switch)' if `touse'
			qui replace `e(switch)' = 1 if `touse'
			qui _predict double `xb1' if `touse', ///
				equation(#1)  `offset' 
			qui replace `e(switch)' = 0 if `touse'
	                qui _predict double `xb0' if `touse', ///
				equation(#1) `offset'
			qui replace `e(switch)' = `dorig' if `touse'
		}
		qui _predict double `za' if `touse', equation(#2) `offset'
		tempname sigma rho
		scalar `sigma' = exp(`lns')
		scalar `rho' =  (expm1(2*`ath')) / ///
				(exp(2*`ath')+1)
		gen `typlist' `varlist' =  		 ///
			(exp(`xb1') - exp(`xb0'))*	 ///
			exp(((`sigma'^2)/2)) if `touse'	
		label variable `varlist' "Treatment effect"		
	}
	if ("`pr'" != "") {
	        local predvar `varlist'
		local sto `typlist'
		tempvar meandat
		local prp `pr'
		gettoken pr1 prp: prp, parse(", ")
		capture confirm integer number `pr1'
		local pr1n = !_rc
		capture assert `pr1' >= 0
		local pr1n = `pr1n' & !_rc
		capture confirm numeric variable `pr1'
		local pr1v = !_rc
		if ("`prp'" == "") {
			if !`pr1n' & !`pr1v' {
				di as error ///
					"{p 0 1 2} argument to {bf:pr()}" ///
					" must be nonnegative integer" ///
					" or numeric variable{p_end}"
				exit 198
			}
			if `pr1v' {
				tempvar missmark
				qui gen `missmark' = !(round(`pr1') ///
					== `pr1' & `pr1' > 0) if `touse'
				qui replace `touse' = 0 if `missmark' == 1
			}
			if `"`intpoints'"' != "" {
				local intpoints intpoints(`intpoints')
			}
			if `"`condpr'"' != "" {
				qui predict double `meandat' ///
					if `touse' , omean `offset'
			}
			Pr1, pr1(`pr1') touse(`touse') sto(`sto')	///
				predvar(`predvar') mean(`meandat') 	///
				`intpoints' `condpr' `offset'
		}
		else if ("`prp'" != "") {
			gettoken junk prp: prp, parse(", ")
			capture assert "`junk'" == ","
			if (_rc) {
				di as error ///
				"invalid separator in {bf:pr()}, " ///
				"must use comma: ex. {bf:pr(1 , 3)}"
				exit 198
			}
			local pr2 `prp'
			capture confirm integer number `pr2'
			local pr2n = !_rc
			capture assert `pr2' == .
			local pr2m = !_rc
			capture confirm numeric variable `pr2'
			local pr2v = !_rc
			if !`pr1n' & !`pr1v' {
				di as error ///
				"{p 0 1 2} first argument to {bf:pr()}" ///
					" must be nonnegative integer" ///
					" or numeric variable{p_end}"
				exit 198
			}
			if (!`pr2n' & !`pr2m') & !`pr2v' {
				di as error ///
				"{p 0 1 2} second argument to {bf:pr()}" ///
					" must be missing, nonnegative " ///
					"integer, or numeric variable{p_end}"
				exit 198
			}
 			if `pr2v' {
				tempvar missmark
				qui gen `missmark' = !(round(`pr2') ///
					== `pr2' & `pr2' > 0) | ///
					(`pr1' >= `pr2') if `touse'
				qui replace `touse' = 0 if `missmark' == 1
			}
			if (`pr1n' & `pr2n') {
				capture assert `pr1' <= `pr2'
				if _rc {
					di as error ///
					"{p 0 1 2} upper bound " ///
					"`pr2' must be greater " ///
					"than or equal to the lower" ///
					" bound `pr1'{p_end}"
					exit 198
				}
			}
			if `"`intpoints'"' != "" {
				local intpoints intpoints(`intpoints')
			}
			if `"`condpr'"' != "" {
				qui predict double `meandat' ///
					if `touse' , omean `offset'
			}
			Pr1Pr2, pr1(`pr1') pr2(`pr2') touse(`touse')	///
				sto(`sto') predvar(`predvar')		///
				mean(`meandat') `condpr' `intpoints' `offset'
		}
	}
	if "`density'" != "" {
 		tempvar touse
		qui gen byte `touse' = 0
		qui replace `touse' = 1 `if' `in'
		qui markout `touse' `e(response)' ///
		`e(switch)' `e(swl)' `e(mlist)'
		tempvar tmpdensity
		qui gen double `tmpdensity' = .
		local w `e(depvar)'
		gettoken fw w: w
		gettoken fw w: w
		local d `fw'
		tempvar beta
		qui predict double `beta' ///
			if `touse', xb `offset'
		tempvar pi
		qui predict double `pi' ///
			if `touse', xbtreat `offset'
		tempname sigma rho
		scalar `sigma' = exp(`lns')
		scalar `rho' = tanh(`ath')
		if `"`intpoints'"' == "" {
			local intpoints = e(intpoints)
		}
		mata: _etpoisson_density("`tmpdensity'","`density'","`d'", ///
			"`beta'","`pi'","`sigma'","`rho'",		   ///
			`intpoints',"`touse'")
		gen `typlist' `varlist' =  `tmpdensity' if `touse'
	}
end

program Pr1
	syntax , 	[pr1(string)	///
			touse(string) 	///
			sto(string) 	///
			predvar(string)	///
			mean(string) condpr noOFFset intpoints(passthru) ]
	local w: word 1 of `e(depvar)'		
	local predvarlab  "Pr(`w'=`pr1')"
	if "`condpr'" != "" {
		gen `sto' `predvar' = poissonp(`mean',`pr1') ///
			if `touse'
	}
	else {
		tempvar density xbtreat tempy
		qui gen double `tempy' = `pr1' if `touse'
		qui predict double `density' if `touse', density(`tempy') ///
			`intpoints' `offset'
		qui predict double `xbtreat' if `touse', xbtreat `offset'
		gen `sto' `predvar' = `density'/(	///
			`e(switch)'*normal(`xbtreat') + ///
			(1-`e(switch)')*normal(-`xbtreat')) if `touse' 
	}	
	label variable `predvar' "`predvarlab'"
end

program qpoisson, sortpreserve
	syntax , 	[pr1(string)	///
			touse(string) 	///
			sto(string) 	///
			predvar(string)	///
			noOFFset intpoints(passthru) ]
	preserve
	capture break {
		tempvar order secorder ninp tempp
		qui gen double `order' = _n
		qui gen double `secorder' = .
		qui gen double `ninp' = `pr1'+1 if `touse'
		expand `ninp'
		sort `order', stable
		by `order': replace `secorder' = _n-1 if `touse'
		Pr1, pr1(`secorder') touse(`touse') sto(double) ///
			predvar(`tempp') `intpoints' `offset'		
		by `order': replace `tempp' = sum(`tempp')
		tempvar keep
		by `order': gen byte `keep' = _n == _N
		drop if !`keep' & `touse'
		gen `sto' `predvar' = `tempp' if `touse'		
	}
	if _rc {
		restore
	}
	else {
		restore, not
	}
end

program qpoissontail, sortpreserve
	syntax , 	[pr1(string)	///
			touse(string) 	///
			sto(string) 	///
			predvar(string)	///
			noOFFset intpoints(passthru)]
	tempvar pcdf atpoint
	qui qpoisson, pr1(`pr1') touse(`touse') sto(double) ///
		predvar(`pcdf') `offset' `intpoints'
	qui Pr1, pr1(`pr1') touse(`touse') sto(double)  ///
		predvar(`atpoint') `offset' `intpoints'
	gen `sto' `predvar' = 1 - `pcdf' + `atpoint' if `touse'
end



program Pr1Pr2
	syntax , 	[pr1(string)	///
			pr2(string)	///
			touse(string) 	///
			sto(string) 	///
			predvar(string)	///
			mean(string) noOFFset condpr intpoints(passthru)]
	local w: word 1 of `e(depvar)'
	local predvarlab  "Pr(`pr1'<=`w'<=`pr2')"		

	capture confirm numeric variable `pr2'
	if (_rc) {
		if ("`pr2'" == ".") {
			local predvarlab  ///
				`"Pr(`pr1'<=`w')"'
			// we only care about pr1 <= `mean'
			// so take the ceiling
			capture confirm numeric variable `pr1'
			if (_rc) {
				local pr1nu = `pr1'
			}
			else {
				tempvar pr1nu
				qui gen long `pr1nu' = `pr1'
			}
			if "`condpr'" != "" {
				gen `sto' `predvar' = ///
					poissontail(`mean',`pr1nu') ///
					if `touse'
			}
			else {
				qpoissontail, pr1(`pr1nu')		///
					touse(`touse') sto(`sto')	///
					predvar(`predvar') `offset' `intpoints'	
			}				
		}
		else {
			capture confirm numeric variable `pr1'
			if (_rc) {
				local pr1nu = `pr1'
			}
			else {
				tempvar pr1nu
				qui gen long `pr1nu' = `pr1'
			}
			if "`condpr'" != "" {
				gen `sto' `predvar' = ///
					poisson(`mean',`pr2') -  ///
					poisson(`mean',`pr1nu') + ///
					poissonp(`mean',`pr1nu') ///
					if `touse'
			}
			else {
				tempvar prob1 prob2 probden
				qui qpoisson, pr1(`pr1nu')		///
					touse(`touse') sto(`sto')	///
					predvar(`prob1') `offset' `intpoints'
				qui qpoisson, pr1(`pr2')		///
					touse(`touse') sto(`sto')	///
					predvar(`prob2') `offset' `intpoints'
				qui Pr1, pr1(`pr1nu')		/// 
					touse(`touse') `offset'		/// 
					sto(double) predvar(`probden')	///
					`intpoints'
				gen `sto' `predvar' = `prob2' - `prob1'	///
					+ `probden' if `touse'  	
			}			
		}
	}
	else {
		tempvar misspr2
		qui gen `misspr2' = `pr2' == .
		capture confirm numeric variable `pr1'
		if (_rc) {
			local pr1nu = `pr1'
		}
		else {
			tempvar pr1nu
			qui gen long `pr1nu' = `pr1'
		}
		tempvar predvarc	
		if "`condpr'" != "" {
			qui gen double `predvarc' = ///
				poissontail(`mean',`pr1nu') ///
				 if `touse' & `misspr2'
		}
		else {
			qui qpoissontail, pr1(`pr1nu')		///
				touse(`touse') sto(double)	///
				predvar(`predvarc') `offset' `intpoints'
		}
		tempvar predvar1
		if "`condpr'" != "" {
			qui gen double `predvar1' = ///
				poisson(`mean',`pr2') -  ///
				poisson(`mean',`pr1nu') + ///
				poissonp(`mean',`pr1nu') ///
				if `touse' & !`misspr2'
		}
		else {
			tempvar prob1 prob2 probden
			qui qpoisson, pr1(`pr1nu')		///
				touse(`touse') sto(`sto')	///
				predvar(`prob1') `offset' `intpoints'
			qui qpoisson, pr1(`pr2')		///
				touse(`touse') sto(`sto')	///
				predvar(`prob2') `offset' `intpoints'
			qui Pr1, pr1(`pr1nu')			/// 
				touse(`touse') sto(double)	///
				predvar(`probden') `offset'	///
				`intpoints'
			qui gen double `predvar1' =		/// 
				`prob2' - `prob1'		///
				+ `probden' if `touse'  	
		}
		qui replace `predvarc' = `predvar1' if !`misspr2' & `touse'
		gen `sto' `predvar' = `predvarc' if `touse'
	}
	label variable `predvar' "`predvarlab'"
end

exit
