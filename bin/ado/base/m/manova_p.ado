*! version 1.0.3  15apr2019
program manova_p, properties(default_xb)
	version 8

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options for MANOVA are:

				Equation(eqno [,eqno2]) Index XB STDP 
				Residuals STDDP noOFFset
		*/
	local myopts "Difference"


		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	_pred_me "`myopts'" `0'
	if `s(done)' {
		exit
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' Equation(string) noOFFset]

	if "`equation'" ==  "" { 
		if 0`e(version)' > 1 {
			local equation : word 1 of `e(depvar)'
		}
		else {
			local equation : word 1 of `e(depvars)'
		}
	}

		/* use following only if Equation(eq1, eq2) syntax
		 * is required for one or more options.  */

	tokenize "`equation'", parse(",")       /* sic, may have "," */
	local eq1 `1'
	local eq2 `3'

		/* Step 4:
			Concatenate switch options together
		*/
	local type "`difference'"
	local args 			/* manova_p takes no args options */


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/
	if "`type'"=="" & `"`args'"'=="" {
		di "{txt}(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', `offset' eq(`equation')
		label var `varn' "Linear prediction:  `equation'"
		exit
	}


		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse


		/* Step 7:
			handle options that take argument one at a time.

			o  Comment if restricted to e(sample).
			o  Be careful in coding that number of missing values
			   created is shown.
			o  Do all intermediate calculations in double.
			o  Use `equation' when the option should only
			   respond to a single, equation(eq), option and
			   `eq1' and `eq2' when the option requires two
			   equations, equation(eq1, eq2)

		*/

	* N/A


		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.

			o  Be careful in coding that number of missing values
			   created is shown.
			o  Do all intermediate calculations in double.
			o  Use `equation' when the option should only
			   respond to a single, equation(eq), option and
			   `eq1' and `eq2' when the option requires two
			   equations, equation(eq1, eq2)
		*/

	if "`type'"=="difference" {
		tempvar xb1  xb2
		qui _predict double `xb1' if `touse', `offset' eq(`eq1')
		qui _predict double `xb2' if `touse', `offset' eq(`eq2')
		gen `vtyp' `varn' = `xb1' - `xb2' if `touse'
		label var `varn' "Fitted diff.:  `eq1' - `eq2'"
		exit
	}

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	* N/A


		/* Step 10.
			Issue r(198), syntax error.
			The user specified more than one option
		*/
	error 198
end

