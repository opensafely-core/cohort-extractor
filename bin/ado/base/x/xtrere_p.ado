*! version 1.2.1  04apr2019
program define xtrere_p, sort		/* predict after xtreg, re */
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

	local myopts "UE E U XBU"
	/* note that UE is full sample, rest are estimation subsample only */
	/* default is XB */



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
	local type  "`e'`u'`ue'`xbu'"


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/
	if "`type'"=="" {
		version 8: ///
		di "({txt}option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', xb `offset'
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

	if "`type'" =="ue" {
		tempvar xb
		quietly _predict double `xb' if `touse', xb `offset'
		gen `vtyp' `varn' = `e(depvar)' - `xb' if `touse'
		label var `varn' "u[`e(ivar)'] + e[`e(ivar)',t]"
		exit
	}
			

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	qui replace `touse'=0 if !e(sample)

	if "`type'"=="e" {
		tempvar xb u
		quietly {
			_predict double `xb' if `touse', xb `offset'
			predict double `u' if `touse', u `offset'
		}
		gen `vtyp' `varn' = `e(depvar)' - `xb' - `u' if `touse'
		label var `varn' "e[`e(ivar)',t]"
		exit
	}

	/* for the remaining, we also need to know the full estimation 
	   subsample
	*/
	tempvar smpl
	qui gen byte `smpl' = e(sample)

	if "`type'"=="u" | "`type'"=="xbu" {
		tempvar xb u 
		quietly {
			_predict double `xb' if `smpl', xb `offset'
			capture xtset
			if "`r(timevar)'" != "" {
				tsrevar `e(depvar)'
				local depvar `r(varlist)'
			}
			else {
				local depvar `e(depvar)'
			}
			sort `e(ivar)' `smpl'
			if e(Tcon)==0 {
				tempvar ratio
				qui by `e(ivar)' `smpl': /*
				*/ gen double `ratio' = /*
				*/ scalar(e(sigma_u)^2/(_N*e(sigma_u)^2+e(sigma_e)^2)) /*
				*/ if `smpl'
			}
			else {
				tempname ratio
				scalar `ratio' = /*
				*/ scalar(e(sigma_u)^2/(e(Tbar)*e(sigma_u)^2+e(sigma_e)^2))
			}
			by `e(ivar)': gen double `u' = /*
			*/ `ratio'*sum(`depvar'-`xb') if `smpl'
			by `e(ivar)': replace `u' = `u'[_N] if `touse' /* sic */
		}
		if "`type'"=="u" {
			gen `vtyp' `varn' = `u' if `touse'
			label var `varn' "u[`e(ivar)']"
		}
		else {
			gen `vtyp' `varn' = `xb' + `u' if `touse'
			label var `varn' "Xb + u[`e(ivar)']"
		}
		exit
	}
	error 198
			
end
