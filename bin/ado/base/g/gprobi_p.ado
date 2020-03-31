*! version 1.0.2  15oct2019
program define gprobi_p
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

			glogit is done with regression, the options we 
			do not want to work have been added.
		*/
	local myopts "N Pr Cooksd Hat REsiduals RSTAndard RSTUdent STDF STDR"
		


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
	local type "`n'`pr'`cooksd'`hat'`residua'`rstanda'`rstuden'`stdf'`stdf'"
	/*                               1234567  1234567  1234567 */

		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/

	marksample touse
	if "`type'"=="" | "`type'"=="n" {
		if "`type'"=="" {
			version 7: di in gr "(option {bf:n} assumed; E(cases))"
		}
		tempvar p
		quietly _predict double `p' if `touse', xb `offset'
		local pop : word 2 of `e(depvar)'
		gen `vtyp' `varn' = normprob(`p')*(`pop') if `touse'
		label var `varn' "E(cases)"
		exit
	}

	if "`type'"=="pr" {
		tempvar p
		quietly _predict double `p' if `touse', xb `offset'
		gen `vtyp' `varn' = normprob(`p') if `touse'
		label var `varn' "Pr(outcome)"
		exit
	}

	error 198
end
