*! version 1.0.10  15oct2019
program define regriv_p
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		GenScores `0'
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
	/* in this case we want to intercept some of the LR standard options
	   to turn them off */
		      /* ---------- turn off -------- */
	local xopts Cooksd Hat RSTAndard RSTUdent		///
		STDR E(string) Pr(string) YStar(string)
	if "`e(prefix)'" == "svy" {
		local svyopts Residuals
	}
	local myopts `xopts' `svyopts'

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

	if "`e(prefix)'" != "" | "`e(vcetype)'" == "Robust" {
		if "`e(vcetype)'" == "Robust" {
			local msg after robust estimation
		}
		else	local msg after `e(prefix)' estimation
		if "`e(prefix)'" == "svy" | "`e(vcetype)'" == "Robust" {
			if `"`e'"' != "" {
				local eopt e(`e')
			}
			if `"`pr'"' != "" {
				local propt pr(`pr')
			}
			if "`ystar'" != "" {
				local ysopt ystar(`ystar')
			}
		}
		_prefix_nonoption `msg', `cooksd' `hat' `rstandard'	///
			`rstudent' `stdr' `eopt' `propt' `ysopt'
	}

		/* Step 4:
			Concatenate switch options together
		*/
	local type "`cooksd'`hat'`rstanda'`rstuden'`stdr'`residua'"
	local args `"`pr'`e'`ystar'"'


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/
	if "`type'"=="" & "`args'"=="" {
		version 7: di in gr "(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', `offset'
		label var `varn' "Fitted values"
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

	if "`residua'" != "" {
		if `"`residua'"' != `"`type'`args'"' {
			error 198
		}
		GenScores `vtyp' `varn' if `touse'
		exit
	}

	if `"`args'"'!="" {
		if "`type'"!="" { error 198 }
		regre_p2 "`vtyp'" "`varn'" "`touse'" "`offset'" /*
			*/ `"`pr'"' `"`e'"' `"`ystar'"' "e(rmse)"
		exit
	}


		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/


		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	* qui replace `touse'=0 if !e(sample)


			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end

program GenScores, rclass
	version 9, missing
	syntax [anything] [if] [in] [, * ]
	marksample touse
	_score_spec `anything', `options'
	local varn `s(varlist)'
	local vtyp `s(typlist)'
	tempvar xb
	quietly _predict double `xb' if `touse'
	gen `vtyp' `varn' = `e(depvar)' - `xb'
	label var `varn' "Residuals"
	return local scorevars `varn'
end
