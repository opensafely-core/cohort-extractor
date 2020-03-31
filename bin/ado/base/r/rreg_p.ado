*! version 1.3.1  21oct2019
program define rreg_p 
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

	local myopts XB Index STDP REsiduals Hat 
	local notopts Cooksd RSTAndard RSTUdent STDF STDR
					/* Cooksd RSTAndard RSTUdent STDF
					 * STDR intercepted and disallowed */


		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
			/* takes advantage that -myopts- produces error
			 * if -eq()- specified w/ other that xb and stdp */

	_pred_se "`myopts' `notopts'" `0'
        if `s(done)' { exit }
        local vtyp  `s(typ)'
        local varn `s(varn)'
        local 0 `"`s(rest)'"'



		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' NOOFFset OFFset *]
	if "`nooffset'`offset'" != "" {
		if "`offset'" != "" {
			version 7: di as err "option {bf:offset} not allowed"
		}
		else version 7: di as err "option {bf:nooffset} not allowed"
		exit 198
	}

		/* Step 4:
			Concatenate switch options together
		*/

	local type  `xb'`index'`stdp'`residua'`hat'`options'
	local args


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/

	if "`args'" == "" {
		if "`type'" == "" | "`type'" == "index" | "`type'" == "xb" {
			if "`type'" == "" {
				version 7: di in gr "(option {bf:xb} assumed; fitted values)"
			}
			_predict `vtyp' `varn' `if' `in', `offset'
			label var `varn' "Fitted values"
			exit
		}
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

	if "`hat'" ~= "" {
		if "`e(genwt)'" == "" {
			version 7: noi di in red "command {bf:rreg} must be run with " /*
				*/ "option {bf:genwt()} first"
			exit 198
		}
		unabbrev `e(genwt)'
		if "`e(genwt)'" != "`s(varlist)'" {
			version 7: noi di in red "variable {bf:`e(genwt)'} missing from dataset;"
			version 7: noi di in red "{p 4 4 2}Command {bf:rreg} must be run with option {bf:genwt()}{p_end}"
			exit 198
		}
		tempvar ww hh
		qui summ `e(genwt)'
		qui gen double `ww' = `e(genwt)'/r(mean)
                qui _predict double `hh' `if' `in', `offset' hat
		gen `vtyp' `varn' = `ww'*`hh' `if' `in'
                label var `varn' "corrected (for `e(genwt)') hat diagonals"
		exit
	}


		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	if "`type'" == "residuals" {
                _predict `vtyp' `varn' `if' `in', `offset' residuals
                label var `varn' "residuals"
		exit
	}
	if "`type'" == "stdp" {
                _predict `vtyp' `varn' `if' `in', `offset' stdp
                label var `varn' "S.E. of prediction of `e(depvar)'"
		exit
	}


		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/


			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	opts_exclusive "`xb' `index' `stdp' `residua' `hat' `options'"
	if `"`type'"' != "" {
		version 7: di in red `"option {bf:`type'} invalid"'
		exit 198
	}
	error 198
end

