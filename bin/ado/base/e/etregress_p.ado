*! version 1.1.1  15oct2019
program define etregress_p 
	version 14
	syntax [anything] [if] [in] [, SCores * ]

	if `"`scores'"' != "" {
		if `"`e(method)'"' == "twostep" {
			di as err ///
			"option {bf:scores} is not allowed with the two-step method"
			exit 322
		}
		tempvar touse
		qui gen byte `touse' = 0
		qui replace `touse' = 1 `if' `in'
		qui markout `touse' `e(depvar)' `e(ind)' `e(trtind)'

		if `"`e(method)'"' == "ml" {
			nobreak {
			mata: _etregress_init("inits","`e(trtdep)'","`touse'") 
			capture noisily break {
				`vv' ml_p `0' userinfo(`inits')
			}
			local erc = _rc
			capture mata: rmexternal("`inits'")
			if (`erc') {
				exit `erc'
			}
			}
			exit
		}
		else if `"`e(method)'"' == "cfunction" {
			`vv' CfuncScores `anything' if `touse'
			exit
		}
	}

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat 
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR noOFFset
			SE:
				Index XB STDP noOFFset
		*/

	local myopts YCTrt YCNTrt PTrt XBTrt STDPTrt STDF CTE XBI


		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
			/* takes advantage that -myopts- produces error
			 * if -eq()- specified w/ other that xb and stdp */

	_pred_se "`myopts'" `0'
	if `s(done)' { 
		exit 
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' CONstant(varname numeric) ]

	if "`e(prefix)'" == "svy" {
		_prefix_nonoption after svy estimation, `stdf'
	}


		/* Step 4:
			Concatenate switch options together
		*/

	local type  `yctrt'`ycntrt'`ptrt'`xbtrt'`stdptrt'`stdf'`cte'`xbi'
	local args

		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/

	if "`constan'" != "" { 
		local constan "constant(`constan')" 
	}

	if "`type'"=="" & `"`args'"'=="" {
		di in gr "(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', `offset' `constan'
		exit
	}
		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse


		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/



		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/



				/* Set up varnames and select constant
				 * option. */
	tokenize `e(depvar)'
	local depname "`1'"
	local trtname  "`2'"
	if "`trtcons'" != "" { 
		local trtcons "constant(`trtcons')" 
	}

				/* Selection index standard error */
	if "`type'" == "stdptrt" { 
		_predict `vtyp' `varn', stdp eq(#2) `trtcons', /*
			*/ if `touse'
		label var `varn' "S.E. of prediction of `trtname'"
		exit
	}

				/* Get selection model index, required 
				 * for all remaining options */

	tempvar Xbprb Xb 
	qui _predict double `Xbprb', xb eq(#2) `trtcons', if `touse'  

				/* Selection index */
	if "`type'" == "xbtrt" { 
		gen `vtyp' `varn' = `Xbprb'
		label var `varn' "Linear prediction of `trtname'"
		exit
	}


				/* Probability observed, from selection 
				 * equation */
	if "`type'" == "ptrt" {
		gen `vtyp' `varn' = normal(`Xbprb')
		label var `varn' "Pr(`trtname')"
		exit
	}

	if "`e(method)'"=="ml" | bsubstr("`e(cmd)'",1,3) == "svy" |	///
	   `"`e(prefix)'"' == "svy" | "`e(method)'" == "cfunction" {
		if ("`e(poutcomes)'" == "") {
			tempname sigma rho
			if `:colnfreeparms e(b)' {
				scalar `sigma' = exp(_b[/lnsigma])
				scalar   `rho' = tanh(_b[/athrho])
			}
			else {
				scalar `sigma' = exp(_b[lnsigma:_cons])
				scalar   `rho' = tanh(_b[athrho:_cons])
			}
		}
		else {
			tempname sigma1 rho1 sigma0 rho0		
			if `:colnfreeparms e(b)' {
				scalar `sigma0' = exp(_b[/lnsigma0])
				scalar   `rho0' = tanh(_b[/athrho0])
				scalar `sigma1' = exp(_b[/lnsigma1])
				scalar   `rho1' = tanh(_b[/athrho1])
			}
			else {
				scalar `sigma0' = exp([lnsigma0]_b[_cons])
				scalar   `rho0' = tanh(_b[athrho0:_cons])
				scalar `sigma1' = exp(_b[lnsigma1:_cons])
				scalar   `rho1' = tanh(_b[athrho1:_cons])
			}
		}
	}
	else {
		tempname sigma rho
		scalar `sigma' = e(sigma)
		scalar   `rho' = e(rho)
	}


				/* Get the model index (Xb), 
				 * required for all remaining options */

	qui _predict double `Xb', xb `constan', if `touse'

	
	nobreak {
		tempvar orig Xb0 Xb1
		qui gen `orig' = `trtname' if `touse'
		qui replace `trtname' = 0 if `touse'
		qui _predict double `Xb0' if `touse'
		qui replace `trtname' = 1 if `touse'
		qui _predict double `Xb1' if `touse'
		qui replace `trtname' = `orig' if `touse'
	}


				/* E(y)|treatment */
	if "`type'" == "yctrt" {
		if ("`e(poutcomes)'" == "") {
			gen `vtyp' `varn' = `Xb1' + ///
			`sigma'*`rho'*normalden(-`Xbprb')/(1-normal(-`Xbprb'))
			label var `varn' "e(`depname'|c=1)"
		}
		else {
			gen `vtyp' `varn' = `Xb1' + ///
			`sigma1'*`rho1'*normalden(-`Xbprb')/(1-normal(-`Xbprb'))
			label var `varn' "e(`depname'|c=1)"
		}
		exit
	}

				/* E(y)|nontreatment */
	if "`type'" == "ycntrt" {
		if ("`e(poutcomes)'" == "") {
			gen `vtyp' `varn' = `Xb0' + ///
			-`sigma'*`rho'*normalden(-`Xbprb')/(normal(-`Xbprb'))
			label var `varn' "E(`depname'|C=0)"
			exit
		}
		else {
			gen `vtyp' `varn' = `Xb0' + ///
			-`sigma0'*`rho0'*normalden(-`Xbprb')/(normal(-`Xbprb'))
			label var `varn' "E(`depname'|C=0)"
			exit
		}
	}

	if "`type'" == "cte" {
		if ("`e(poutcomes)'" == "") {
			gen `vtyp' `varn' = `Xb1' -`Xb0' if `touse'
			label var `varn' "Conditional treatment effect"
		}
		else {
			tempvar brbit
//			tempvar diff
//			gen double `diff' = `Xb1' - `Xb0' if `touse'
//			noi sum `diff' if `touse'
//			noi sum `Xb1' if `touse'
//			noi sum `Xb0' if `touse'
	
			qui gen double `brbit' = (`Xb1'+`sigma1'*`rho1'* ///
					normalden(-`Xbprb')/    ///
					(1-normal(-`Xbprb')))- ///
				    (`Xb0' + `sigma0'*`rho0'* ///
					normalden(-`Xbprb')/	///
					(1-normal(-`Xbprb'))) ///
					if `trtname' == 1 & `touse'
			qui replace `brbit' = (`Xb1'+`sigma1'*`rho1'* ///
					-normalden(-`Xbprb')/    ///
					(normal(-`Xbprb')))- ///
				    (`Xb0' + `sigma0'*`rho0'* ///
					-normalden(-`Xbprb')/	///
					(normal(-`Xbprb'))) ///
					if `trtname' == 0 & `touse'
			gen `vtyp' `varn' = `brbit' if `touse'
			label var `varn' "Conditional treatment effect"
		}
		exit
	}


	if "`type'"=="stdf" {
		tempvar stdp
		qui _predict double `stdp' if `touse', stdp `constan'
		if "`e(poutcomes)'" == "" { 
			gen `vtyp' `varn' = sqrt(`stdp'^2 + `sigma'^2) ///
				if `touse'
		}
		else {
			tempvar stdfregime
			qui gen double `stdfregime' = ///
				sqrt(`stdp'^2+`sigma0'^2) ///
				if `touse' & `trtname' == 0
			replace `stdfregime' = ///
				sqrt(`stdp'^2+`sigma1'^2) ///
				if `touse' & `trtname' == 1
			gen `vtyp' `varn' = `stdfregime' if `touse'
		}
		label var `varn' "S.E. of the forecast"
		exit
	}

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	*qui replace `touse'=0 if !e(sample)


			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end

program CfuncScores
	version 13.0
	syntax [anything] [if] [in]
	marksample touse
	if ("`e(poutcomes)'" != "") {
		if `:colnfreeparms e(b)' {
			local lns0 _b[/lnsigma0]
			local ath0 _b[/athrho0]
			local lns1 _b[/lnsigma1]
			local ath1 _b[/athrho1]
		}
		else {
			local lns0 [lnsigma0]_b[_cons]
			local ath0 [athrho0]_b[_cons]
			local lns1 [lnsigma1]_b[_cons]
			local ath1 [athrho1]_b[_cons]
		}
		_stubstar2names `anything', nvars(6)
	        local typlist `s(typlist)'
	        local varlist `s(varlist)'

		tempvar lambda0 lambda1 m m0 m1 s0 s1 l0 l1
		qui predictnl double `l0' = ///
			-normalden(xb(`e(trtdep)'))/ ///
			normal(-xb(`e(trtdep)')) if `e(trtdep)' == 0 & `touse'
		qui replace `l0' = 0 if `e(trtdep)' == 1 & `touse'
		qui predictnl double `lambda0' = ///
			exp(`lns0')* ///
			tanh(`ath0')*`l0' ///
			if `e(trtdep)' == 0 & `touse'
		qui replace `lambda0' = 0 if `e(trtdep)' == 1 & `touse'
		qui predictnl double `l1' = ///
			normalden(-xb(`e(trtdep)'))/ ///
			(1-normal(-xb(`e(trtdep)'))) if `e(trtdep)'==1 & `touse'
		qui replace `l1' = 0 if `e(trtdep)' == 0 & `touse'
		qui predictnl double `lambda1' = ///
			exp(`lns1')* ///
			tanh(`ath1')*`l1' if `e(trtdep)'==1 ///
			& `touse'
		qui replace `lambda1' = 0 if `e(trtdep)' == 0 & `touse'
		qui predictnl double `m' = `e(dep)' - xb(`e(dep)') - ///
			`lambda0' -`lambda1' if `touse'
		qui gen double `m0' = `m' * `l0' if `touse'
		qui gen double `m1' = `m' * `l1' if `touse'
		qui predictnl double `s0' = ///
			(`m')^2 - ///
			(1-(tanh(`ath0')^2)*`l0'* ///
			(`l0'+xb(`e(trtdep)')))*exp(`lns0')^2 ///
			if `e(trtdep)' == 0 & `touse'
		qui replace `s0' = 0 if `e(trtdep)' == 1 & `touse'
		qui predictnl double `s1' = ///
			(`m')^2 - ///
			(1-(tanh(`ath1')^2)*`l1'* ///
			(`l1'+xb(`e(trtdep)')))*exp(`lns1')^2 ///
			if `e(trtdep)' == 1 & `touse'
		qui replace `s1' = 0 if `e(trtdep)'==0 & `touse'
		local typ: word 1 of `typlist'
		local vare: word 1 of `varlist'
		gen `typ' `vare' = `m' if `touse'
		label variable `vare' ///
			"equation-level score for [`e(dep)'] from etregress"
		local typ: word 2 of `typlist'
		local vare: word 2 of `varlist'
		gen `typ' `vare' = `l0' + `l1' if `touse'
		label variable `vare' ///
		"equation-level score for [`e(trtdep)'] from etregress"			
		local typ: word 3 of `typlist'
		local vare: word 3 of `varlist'
		gen `typ' `vare' = `m0' if `touse'
		label variable `vare' ///
			"equation-level score for /athrho0 from etregress"
		local typ: word 4 of `typlist'
		local vare: word 4 of `varlist'
		gen `typ' `vare' = `s0' if `touse'
		label variable `vare' ///
			"equation-level score for /lnsigma0 from etregress"
		local typ: word 5 of `typlist'
		local vare: word 5 of `varlist'
		gen `typ' `vare' = `m1' if `touse'
		label variable `vare' ///
			"equation-level score for /athrho1 from etregress"
		local typ: word 6 of `typlist'
		local vare: word 6  of `varlist'
		gen `typ' `vare' = `s1' if `touse'	
		label variable `vare' ///
			"equation-level score for /lnsigma1 from etregress"
	}
	else {
		if `:colnfreeparms e(b)' {
			local lns _b[/lnsigma]
			local ath _b[/athrho]
		}
		else {
			local lns [lnsigma]_b[_cons]
			local ath [athrho]_b[_cons]
		}
		_stubstar2names `anything', nvars(4)
	        local typlist `s(typlist)'
        	local varlist `s(varlist)'
		tempvar lambda0 lambda1 m m0 s0 l0 l1
		qui predictnl double `l0' = ///
			-normalden(xb(`e(trtdep)'))/ ///
			normal(-xb(`e(trtdep)')) if `e(trtdep)'== 0 & `touse'
		qui replace `l0' = 0 if `e(trtdep)' == 1 & `touse'
		qui predictnl double `lambda0' = ///
			exp(`lns')* ///
			tanh(`ath')*`l0' ///
			if `e(trtdep)' == 0 & `touse'
		qui replace `lambda0' = 0 if `e(trtdep)' == 1 & `touse'
		qui predictnl double `l1' = ///
			normalden(-xb(`e(trtdep)'))/ ///
			(1-normal(-xb(`e(trtdep)'))) if `e(trtdep)'==1 & `touse'
		qui replace `l1' = 0 if `e(trtdep)' == 0 & `touse'
		qui predictnl double `lambda1' = ///
			exp(`lns')* ///
			tanh(`ath')*`l1' if `e(trtdep)'==1 & `touse'
		qui replace `lambda1' = 0 if `e(trtdep)' == 0 & `touse'
		qui predictnl double `m' = `e(dep)' - xb(`e(dep)') - ///
			`lambda0' -`lambda1' if `touse'
		qui gen double `m0' = `m' * (`l0'+`l1')
		qui predictnl double `s0' = ///
			(`m')^2 - ///
			(1-(tanh(`ath')^2)*(`l0'+`l1')* ///
			(`l0'+`l1'+xb(`e(trtdep)')))* ///
			exp(`lns')^2 ///
			if `touse'
		local typ: word 1 of `typlist'
		local vare: word 1 of `varlist'
		gen `typ' `vare' = `m' if `touse'
		label variable `vare' ///
			"equation-level score for [`e(dep)'] from etregress"			
		local typ: word 2 of `typlist'
		local vare: word 2 of `varlist'
		gen `typ' `vare' = `l0' + `l1' if `touse'
		label variable `vare' ///
			"equation-level score for [`e(trtdep)'] from etregress"
		local typ: word 3 of `typlist'
		local vare: word 3 of `varlist'
		gen `typ' `vare' = `m0' if `touse'
		label variable `vare' ///
			"equation-level score for /athrho from etregress"
		local typ: word 4 of `typlist'
		local vare: word 4 of `varlist'
		gen `typ' `vare' = `s0' if `touse'
		label variable `vare' ///
			"equation-level score for /lnsigma from etregress"
	}
end
