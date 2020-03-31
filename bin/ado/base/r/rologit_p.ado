*! version 1.1.1  06feb2019
program define rologit_p
	version 7

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

	local myopts "Pr dpdx(passthru)"

		/* Step 2:
			call _pred_se, exit if done,
			else collect what was returned.
		*/

	_pred_se "`myopts'" `0'
	if `s(done)' { 
		exit 
	}
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

	local type "`pr'`dpdx'"

		/* Step 5:
			mark sample (this is not e(sample)).
		*/

	marksample touse

		/* Step 6:
			handle options that take argument one at a time.
		*/

	if "`type'" == "" | "`type'" == "pr" {
		
		if "`type'" == "" {
			di as txt "(option {bf:pr} assumed; conditional probability that alternative is ranked first)"
		}
		
		tempvar p
		GetP `p' if `touse' , `offset'
		gen `vtyp' `varn' = `p' if `touse'
		label var `varn' "prob that alternative is most attractive"
		exit
	}

	if bsubstr("`type'",1,4) == "dpdx" {
		local 0 `", `dpdx'"'
		syntax , dpdx(varname)

		tempname b p
		capt scalar `b' = _b[`dpdx']
		if _rc {
			
			/* e(cmd) is either -rologit- or -cmrologit-. */
			
			di as err "{p}variable `varname' not included in `e(cmd)' model{p_end}"
			exit 198
		}
		
		GetP `p' if `touse' , `offset'
		gen `vtyp' `varn' = `p'*(1-`p')*`b' if `touse'
		label var `varn' "marginal effect of `varname'-self-"
		exit
	}

		/* Step 7.
			Issue r(198), syntax error.
			The user specified more than one option
		*/

	error 198
end

program define GetP
	syntax newvarname if/ [, noOFFSET ]
	
	local touse `if'

	tempvar xb denom

	qui _predict double `xb' if `touse', xb `offset'
	qui bys `touse' `e(group)': gen double `denom'   = sum(exp(`xb')) if `touse'
	qui bys `touse' `e(group)': gen double `varlist' = exp(`xb')/`denom'[_N] if `touse'
end

exit
