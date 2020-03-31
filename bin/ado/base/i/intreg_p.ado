*! version 1.2.0  01mar2015
program define intreg_p
	version 7, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		marksample touse
		local xvars : colna e(b)
		local USCONS _cons _cons
		local xvars : list xvars - USCONS
		if `:length local xvars' {
			markout `touse' `xvars'
		}
		ml score `anything' if `touse', `options' missing
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

	syntax [if] [in] [, `myopts' noOFFset ]

	if "`e(prefix)'" == "svy" {
		_prefix_nonoption after svy estimation, `stdf'
	}

		/* Step 4:
			Concatenate switch options together
		*/

	local type "`stdf'"
	local args `"`pr'`e'`ystar'`pr0'`e0'`ystar0'"'

		/* Step 5:
			quickly process default case if you can
			Do not forget -nooffset- option.
		*/

	if "`type'"=="" & `"`args'"'=="" {
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

	if `"`args'"'!="" {
		if "`type'"!="" { error 198 }
		tempvar rmse
		qui _predict double `rmse', xb eq(lnsigma)
		qui replace `rmse' = exp(`rmse')
		regre_p2 "`vtyp'" "`varn'" "`touse'" "`offset'"           /*
			*/ `"`pr'`pr0'"' `"`e'`e0'"' `"`ystar'`ystar0'"'  /*
			*/ "`rmse'"
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
		tempvar rmse
		qui _predict double `rmse', xb eq(lnsigma)
		qui replace `rmse' = exp(`rmse')
		gen `vtyp' `varn' = sqrt(`stdp'^2 + `rmse'^2) if `touse'
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

/* ------------------------ DELETED -------------------------------------
program define GetRMSE, sclass
	sret clear
	if "`e(cmd)'"=="intreg2" {
		tempvar rmse
		qui _predict double `rmse', xb eq(lnsigma)
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
------------------------------------------------------------------------*/
