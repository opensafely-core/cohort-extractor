*! version 3.2.2  15oct2019
program define treatr_p 
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		if `"`e(method)'"' == "twostep" {
			version 7: di as err ///
			"option {bf:scores} is not allowed with the two-step method"
			exit 322
		}
		ml score `0'
		exit
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

	local myopts YCTrt YCNTrt PTrt XBTrt STDPTrt STDF


		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
			/* takes advantage that -myopts- produces error
			 * if -eq()- specified w/ other that xb and stdp */

	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
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

	local type  `yctrt'`ycntrt'`ptrt' `xbtrt'`stdptrt'`stdf'
	local args

		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/

	if "`constan'" != "" { local constan "constant(`constan')" }

	if "`type'"=="" & `"`args'"'=="" {
		version 7: di in gr "(option {bf:xb} assumed; fitted values)"
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
	if "`trtcons'" != "" { local trtcons "constant(`trtcons')" }

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
		gen `vtyp' `varn' = normprob(`Xbprb')
		label var `varn' "Pr(`trtname')"
		exit
	}

	tempname sigma rho
	if "`e(method)'"=="ml" | bsubstr("`e(cmd)'",1,3) == "svy" |	///
	   `"`e(prefix)'"' == "svy" {
		scalar `sigma' = exp(_b[lnsigma:_cons])
		scalar   `rho' = tanh(_b[athrho:_cons])
	}
	else {
		scalar `sigma' = e(sigma)
		scalar   `rho' = e(rho)
	}


				/* Get the model index (Xb), 
				 * required for all remaining options */

	qui _predict double `Xb', xb `constan', if `touse'

				/* E(y)|treatment */
	if "`type'" == "yctrt" {
		gen `vtyp' `varn' =  `Xb'- `trtname'*[`depname']_b[`trtname'] /*
			*/ + [`depname']_b[`trtname'] + (normd(`Xbprb') /    /*
			*/ normprob(`Xbprb')) * `sigma' * `rho' 
		label var `varn' "E(`depname'|C=1)"
		exit
	}

				/* E(y)|nontreatment */
	if "`type'" == "ycntrt" {
		gen `vtyp' `varn' = `Xb'- `trtname'*[`depname']_b[`trtname'] /*
			*/ - (normd(`Xbprb')/normprob(-`Xbprb'))  /*
			*/ * `sigma' * `rho'
		label var `varn' "E(`depname'|C=0)"
		exit
	}


	if "`type'"=="stdf" {
		tempvar stdp
		qui _predict double `stdp' if `touse', stdp `constan'
		gen `vtyp' `varn' = sqrt(`stdp'^2 + `sigma'^2) if `touse'
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

