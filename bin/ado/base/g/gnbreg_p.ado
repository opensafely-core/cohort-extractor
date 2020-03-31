*! version 1.2.1  15oct2019
program define gnbreg_p
	version 9, missing

	syntax [anything] [if] [in] [, SCores SCORESLna * ]
	if `"`scores'`scoreslna'"' != "" {
		if "`scoreslna'" != "" {
			local scores scores
			local eq eq(#2)
		}
		ml score `anything' `if' `in', `scores' `eq' `options'
		exit
	}
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
	local myopts "N IR Alpha LNAlpha STDPLna Pr(string) "


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
	local type "`n'`ir'`alpha'`lnalpha'`stdplna'"
	local args `"`pr'`cpr'"'
	if "`pr'" != "" {
		local propt pr(`pr')
	}
	if "`cpr'" != "" {
			local propt pr(`cpr')
	}


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

	if ("`type'"=="" & `"`args'"'=="") | "`type'"=="n" {
		if "`type'"=="" {
			version 7: di in gr /*
			*/ "(option {bf:n} assumed; predicted number of events)"
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		gen `vtyp' `varn' = exp(`xb') if `touse'
		label var `varn' "Predicted number of events"
		exit
	}

	if "`type'"=="ir" {
		tempvar xb
		qui _predict double `xb' if `touse', xb nooffset
		gen `vtyp' `varn' = exp(`xb') if `touse'
		label var `varn' "Predicted incidence rate"
		exit
	}

	if "`type'"=="alpha" {
		tempvar xb2
		qui _predict double `xb2' if `touse', xb `offset' eq(#2)
		gen `vtyp' `varn' = exp(`xb2') if `touse'
		label var `varn' "Predicted alpha"
		exit
	}

	if "`type'"=="lnalpha" {
		tempvar xb2
		_predict `vtyp' `varn' if `touse', xb `offset' eq(#2)
		label var `varn' "Predicted ln(alpha)"
		exit
	}

	if "`type'"=="stdplna" {
		_predict `vtyp' `varn' if `touse', stdp `offset' eq(#2)
		label var `varn' "S.E. predicted ln(alpha)"
		exit
	}
	local type `type'
	if `"`args'"'!="" {
		if "`type'" != "" {
			error 198
		}
		tpredict_p2 "`vtyp'" "`varn'" "`touse'" "`offset'" /*
			*/ "`pr'" "`cpr'"
		exit
	}
	error 198
end

