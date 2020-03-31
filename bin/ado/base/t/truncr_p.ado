*! version 1.3.1  15oct2019
program define truncr_p
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		global TRUNCREG_a `e(llopt)'
		global TRUNCREG_b `e(ulopt)'
		if `"`e(llopt)'"' != "" & `"`e(ulopt)'"' != "" {
			global TRUNCREG_flag 0
		}
		else if `"`e(llopt)'"' != "" {
			global TRUNCREG_flag 1
		}
		else if `"`e(ulopt)'"' != "" {
			global TRUNCREG_flag -1
		}
		else	global TRUNCREG_flag 2
		ml score `0'
		macro drop TRUNCREG_a TRUNCREG_b TRUNCREG_flag
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

	local myopts "STDF E(string) Pr(string) YStar(string)"
	local myopts "`myopts' Residuals"

		/* Step 2:
			call _pred_se, exit if done,
			else collect what was returned.
		*/

	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' noOFFset]

	if "`e(prefix)'" == "svy" {
		_prefix_nonoption after svy estimation, `stdf'
	}

		/* Step 4:
			Concatenate switch options together
		*/

	local type "`stdf'`residua'"
	local args `"`pr'`e'`ystar'"'

		/* Step 5:
			quickly process default case if you can
			Do not forget -nooffset- option.
		*/

	if "`type'"=="" & `"`args'"'=="" {
		version 7: di in gr "(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', `offset'
		exit
	}

	if "`type'"=="residuals" {
		tempvar xb
		qui _predict double `xb' `if' `in', `offset'
		gen `vtyp' `varn' = `e(depvar)' - `xb'
		label var `varn' "Residuals"
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
        
	if `"`args'"'!="" {
		if "`type'"!="" { error 198 }
		GetRMSE
		regre_p2 "`vtyp'" "`varn'" "`touse'" "`offset'" /*
			*/ `"`pr'"' `"`e'"' `"`ystar'"' "`s(rmse)'"
		exit
	}

		/* Step 8:
			handle switch options that can be used in-sample or
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	if "`type'"=="stdf" {
		tempvar stdp
		qui _predict double `stdp' if `touse', stdp `offset'
		GetRMSE
		gen `vtyp' `varn' = sqrt(`stdp'^2 + `s(rmse)'^2) if `touse'
		label var `varn' "S.E. of the forecast"
		exit
	}

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/

	/*qui replace `touse'=0 if !e(sample)*/

		/* Step 10.
			Issue r(198), syntax error.
			The user specified more than one option
		*/

	error 198
end

program define GetRMSE, sclass
	sret clear
	if "`e(cmd)'"=="tobit" | "`e(cmd)'"=="cnreg" {
		sret local rmse "_b[_se]"
		exit
	}
	if "`e(cmd)'"=="intreg" | "`e(cmd)'"=="svyintreg" /*
		*/ | "`e(cmd)'"=="truncreg" {
		if `:colnfreeparms e(b)' {
			sret local rmse "_b[/sigma]"
		}
		else {
			sret local rmse "[sigma]_b[_cons]"
		}
		exit
	}
	if "`e(cmd)'"=="eivreg" | "`e(cmd)'"=="cnsreg" {
		sret local rmse "e(rmse)"
		exit
	}

	capture di _b[_se]
	local rc1 = _rc
	capture di e(sigma)
	local rc2 = _rc
	if `rc1' & `rc2' {
		capture di e(rmse)
		if _rc { error 301 }
		sret local rmse "e(rmse)"
		exit
	}
	if `rc1'==0 & `rc2'==0 {
		capture assert reldif(_b[_se],e(sigma))<1e-10
		if _rc { error 301 }
		sret local rmse "e(sigma)"
		exit
	}
	if `rc1'==0 {
		sret local rmse "_b[_se]"
		exit
	}
	sret local rmse "e(sigma)"
end
