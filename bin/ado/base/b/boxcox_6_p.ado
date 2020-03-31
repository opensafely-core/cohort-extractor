*! version 1.1.2  15oct2019
program define boxcox_6_p	/* predict after boxcox_6 */
	version 6, missing

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

	local myopts /*
*/ "Yhat TYhat Residual TResidual Cooksd Hat RSTAndard RSTUdent STDF STDR"



		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]


		/* Step 4:
			Concatenate switch options together
		*/
	local type  "`yhat'`tyhat'`residua'`tresidu'"


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/
				
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

	if "`type'"=="" | "`type'"=="yhat" {
		if "`type'"=="" {
			version 7: di in gr "(option {bf:yhat} assumed; fitted values)"
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		if "`e(center)'"=="" {
			if abs(`e(L)')>1e-10 { 
				gen `vtyp' `varn' = (e(L)*`xb'+1)^(1/e(L)) /*
							*/ if `touse'
			}
			else	gen `vtyp' `varn' = exp(`xb') if `touse'
		}
		else {
			tempvar sgn
			quietly {
				gen byte `sgn' = sign(`xb') if `touse'
				if abs(`e(L)')>1e-10 { 
					replace `xb' = /*
					*/ (`e(L)'*abs(`xb') + 1)^(1/e(L))-1 /*
					*/ if `touse'
				}
				else {
					replace `xb' =  expm1(abs(`xb')) /*
					*/ if `touse'
				}
			}
			gen `vtyp' `varn' = e(`e(center)')+`sgn'*`xb' `if' `in'
		}
		label var `varn' "Fitted values"
		exit
	}

	if "`type'"=="tyhat" {
		if "`e(center)'"=="" {
			if abs(e(L)) > 1e-10 { 
				gen `vtyp' `varn' = (`e(depvar)'^e(L)-1)/e(L) /*
				*/ if `touse'
			}
			else	gen `vtyp' `varn' = ln(`e(depvar)') if `touse'
		}
		else {
			if abs(e(L))>1e-10 {
				gen `vtyp' `varn' = /*
	*/ sign(`e(depvar)'-e(`e(center)')) * 				/*
	*/ ( 								/*
	*/ 	( (abs(`e(depvar)'-e(`e(center)'))+1)^e(L) - 1 ) / e(L)	/*
	*/ ) if `touse'
			}
			else {
				gen `vtyp' `varn' = /*
	*/ sign(`e(depvar)'-e(`e(center)')) * 				/*
	*/ ( 								/*
	*/	ln1p( abs(`e(depvar)'-e(`e(center)'))) 			/*
	*/ ) if `touse'
			}
		}
		label var `varn' "Transformed `e(depvar)'"
		exit
	}

	if "`type'"=="residual" { 
		tempvar yhat
		qui predict double `yhat', yhat `offset'
		gen `vtyp' `varn' = `e(depvar)'-`yhat' if `touse'
		label var `varn' "Residual"
		exit
	}

	if "`type'"=="tresidual" {
		tempvar ty xb
		qui predict double `ty', tyhat `offset'
		qui _predict double `xb', xb `offset'
		gen `vtyp' `varn' = `ty' - `xb' if `touse'
		label var `varn' "Transformed residual"
		exit
	}

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	* qui replace `touse'=0 if !e(sample)

	error 198
end
