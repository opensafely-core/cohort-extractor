*! version 1.2.0  01mar2015
program define qreg_p
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
	local myopts "Residuals"


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
	local type "`residua'"


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/
	if "`type'"=="" {
		di in smcl in gr "(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', `offset'
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

	if "`type'"=="residuals" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		gen `vtyp' `varn' = `e(depvar)'-`xb' if `touse'
		label var `varn' "Residuals"
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
