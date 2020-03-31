*! version 1.0.3  15oct2019
program define glm_p
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
	local myopts "Deviance Mu Pearson"


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
	local type "`devianc'`mu'`pearson'"


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

	/* all statistics require MU below */
	quietly {
		tempvar eta MU
		_predict double `eta' if `touse', xb `offset'
		gen double `MU' = .
		_crcglil `eta' `MU' `e(power)' `e(m)' `e(k)' `e(bernoul)'
		drop `eta'
	}


	if "`type'"=="" | "`type'"=="mu" {
		if "`type'"=="" {
			version 7: di in gr /*
			*/ "(option {bf:mu} assumed; predicted mean {bf:`e(depvar)'})"
		}
		gen `vtyp' `varn' = `MU' if `touse'
		label var `varn' "Predicted mean `e(depvar)'"
		exit
	}

	if "`type'"=="deviance" {
		quietly {
			tempvar dresq
			gen double `dresq' = 0
			_crcgldv `e(depvar)' `e(family)' `e(bernoul)' /*
				*/ `e(m)' `e(k)' `MU' 1 `dresq'
		}
		gen `vtyp' `varn' = sign(`e(depvar)'-`MU')*sqrt(`dresq') /*
			*/ if `touse'
		lab var `varn' "Deviance residual"
		exit
	}

	if "`type'"=="pearson" {
		tempvar V
		qui pearson `V' <- `MU' `touse'
		gen `vtyp' `varn' = (`e(depvar)'-`MU')/sqrt(`V') if `touse'
		label var `varn' "Pearson residual"
		exit
	}
	error 198
end



program define pearson /* V <- mu touse */
	args V skip mu touse

	if "`e(family)'"=="bin" {
		gen double `V' = `mu'*(1-`mu'/`e(m)') if `touse'
	}
	else if "`e(family)'"=="gam" {
		gen double `V' = `mu'^2 if `touse'
	}
	else if "`e(family)'"=="gau" {
		gen double `V' = 1 if `touse'
	}
	else if "`e(family)'"=="ivg" {
		gen double `V' = `mu'^3 if `touse'
	}
	else if "`e(family)'"=="nb" {
		gen double `V' = (`mu'+`e(k)'*`mu'^2) if `touse'
	}
	else if "`e(family)'"=="poi" {
		gen double `V' = `mu' if `touse'
	}
end
