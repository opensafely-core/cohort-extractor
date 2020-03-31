*! version 1.3.4  30nov2018
program define reg3_p, properties(default_xb)
	version 6, missing

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options for ME estimators are
			ME:
				Equation(eqno [,eqno2]) Index XB STDP 
				STDDP noOFFset
		*/
	local myopts "Difference Residuals"


		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	_pred_me "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' Equation(string) NOOFFset OFFset]
	if "`nooffset'`offset'" != "" {
		if "`offset'" != "" {
			di as err "option offset not allowed"
		}
		else di as err "option nooffset not allowed"
		exit 198
	}

			/* mainly for labeling,
			 * usually e(eqnames) avail, but this always works */
	if "`equatio'" ==  "" { 
		tempname b
		mat `b' = get(_b)
		local eqnames : coleq `b'
		gettoken equatio : eqnames
	}

		/* use following only if Equation(eq1, eq2) syntax
		 * is required for one or more options.  */

	tokenize "`equatio'", parse(",")       /* sic, may have "," */
	local eq1 `1'
	local eq2 `3'

		/* Step 4:
			Concatenate switch options together
		*/
	local type "`differe'`residua'"
	local args 			/* reg3_p takes no args options */


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/
	if "`type'"=="" & `"`args'"'=="" {
		di in smcl in gr "(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', `offset' eq(`equatio')
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
			o  Use `equatio' when the option should only
			   hrespond to a single, equation(eq), option and
			   `eq1' and `eq2' when the option requires two
			   equations, equation(eq1, eq2)

		*/


	*if `"`args'"'!="" {
	*	if "`type'"!="" { error 198 }
	*	exit
	*}


		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.

			o  Be careful in coding that number of missing values
			   created is shown.
			o  Do all intermediate calculations in double.
			o  Use `equatio' when the option should only
			   respond to a single, equation(eq), option and
			   `eq1' and `eq2' when the option requires two
			   equations, equation(eq1, eq2)
		*/

	if "`type'"=="residuals" {
		tempvar xb 
		qui _predict double `xb' if `touse', `offset' eq(`equatio')
		Depname depname : `equatio'
		gen `vtyp' `varn' = `depname' - `xb' if `touse'
		label var `varn' "Residuals: `equatio'"
		exit
	}

	if "`type'"=="difference" {
		tempvar xb1  xb2
		if ("`eq2'"=="") {
			_diff_error 
		}
		qui _predict double `xb1' if `touse', `offset' eq(`eq1')
		qui _predict double `xb2' if `touse', `offset' eq(`eq2')
		gen `vtyp' `varn' = `xb1' - `xb2' if `touse'
		label var `varn' "Fitted diff.: `eq1' - `eq2'"
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

program define Depname	  /* <depname> : <equation name or number> */
	args	depname		/*  macro to hold dependent variable name
		*/  colon	/*  ":"
		*/  eqopt	/*  equation name or #number */


	if bsubstr("`eqopt'",1,1) == "#" {
		local eqnum =  bsubstr("`eqopt'", 2,.)
		local dep : word `eqnum' of `e(depvar)'
		c_local `depname' `dep'
		exit
	}

	tokenize `e(eqnames)'
	local i 1
	while "``i''" != "" {
		if "``i''" == "`eqopt'" {
			local dep : word `i' of `e(depvar)'
			c_local `depname' `dep'
			exit
		}
	local i = `i' + 1
	}

end

program define _diff_error
	version 16 
	displa as error "option {bf:difference} must be specified with" ///
		" option {bf:equation()}"
	di as err "{p 2 2 2}"           
	di as smcl as err " You should specify 2 equations"
	di as smcl as err " using the syntax {bf:equation(#a,#b)}"
	di as smcl as err " to obtain the {bf:difference} between the linear"
	di as smcl as err " predictions of {bf:equation(#a)} and"
	di as smcl as err " {bf:equation(#b)}."
	di as smcl as err "{p_end}"                     
	exit 198  
end
