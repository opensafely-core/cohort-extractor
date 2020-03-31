*! version 1.4.1  04apr2019
program define tobit_p, properties(default_xb)
	local vv : di "version " string(_caller()) ", missing:"	
	version 6, missing
	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		if ("`e(cmd)'" == "eivreg") {
			version 16: di as error ///
				"{bf:scores} not allowed with {bf:eivreg}"
			exit 198
		}
		if "`e(cmd)'" == "cnsreg" {
			GenCnsregScores `0'
		}
		else {
			GenTobitScores `0'
		}
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

	local myopts "STDF"
	if "`e(cmd)'"=="xttobit" | "`e(cmd)'"=="xtintreg" {
		if _caller() <= 14 { local ZERO 0 }
		local xtp E`ZERO'(string) Pr`ZERO'(string) YStar`ZERO'(string)
		local myopts "`myopts' `xtp'"
	}
	else	local myopts "`myopts' E(string) Pr(string) YStar(string)"
	if "`e(cmd)'"=="cnsreg" | "`e(cmd)'"=="eivreg" {
		local myopts "`myopts' Residuals"
	}

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
	local args `"`pr'`e'`ystar'`pr0'`e0'`ystar0'"'

		/* Step 5:
			quickly process default case if you can
			Do not forget -nooffset- option.
		*/

	if "`type'"=="" & `"`args'"'=="" {
		version 8: ///
		di "{txt}(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', `offset'
		exit
	}

	if "`type'"=="residuals" {
		_predict `vtyp' `varn' `if' `in', xb `offset'
		quietly replace `varn' = `e(depvar)' - `varn'
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
		`vv' ///
		regre_p2 "`vtyp'" "`varn'" "`touse'" "`offset'"           /*
			*/ `"`pr'`pr0'"' `"`e'`e0'"' `"`ystar'`ystar0'"'  /*
			*/ "`s(rmse)'"
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
	if "`e(cmd)'"=="tobit" {
		if missing(e(version)) {
			sret local rmse "_b[_se]"
		}
		else if `e(version)'==3 {
			sret local rmse "sqrt(_b[/var(e.`e(depvar)')])"
		}
		else {
			sret local rmse "_b[/sigma]"
		}
		exit
	}
	if "`e(cmd)'"=="cnreg" {
		if missing(e(version)) {
			sret local rmse "_b[_se]"
		}
		else {
			sret local rmse "_b[/sigma]"
		}
		exit
	}
	if "`e(cmd)'"=="intreg" | "`e(cmd)'"=="svyintreg" {
		sret local rmse "_b[/sigma]"
		exit
	}
	if "`e(cmd)'"=="eivreg" | "`e(cmd)'"=="cnsreg" {
		sret local rmse "e(rmse)"
		exit
	}
	if "`e(cmd)'"=="xttobit" | "`e(cmd)'"=="xtintreg" {
		if `:colnfreeparms e(b)' {
			sret local rmse "sqrt(_b[/sigma_u]^2+_b[/sigma_e]^2)"
		}
		else {
			sret local rmse ///
			"sqrt([sigma_u]_b[_cons]^2+[sigma_e]_b[_cons]^2)"
		}
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

program GenCnsregScores, rclass
	version 9, missing
	syntax [anything] [if] [in] [, noOFFset * ]
	marksample touse
	_score_spec `anything', `options'
	local varn `s(varlist)'
	local vtyp `s(typlist)'
	tempvar xb
	quietly _predict double `xb' if `touse', xb `offset'
	gen `vtyp' `varn' = `e(depvar)' - `xb'
	label var `varn' "Residuals"
	return local scorevars `varn'
end

program GenTobitScores, rclass
	version 9, missing
	if inlist("`e(cmd)'","xttobit","xtintreg") {
		di as err "option {bf:scores} not allowed"
		exit 198
	}
	syntax [anything] [if] [in] [, noOFFset * ]
	marksample touse
	_score_spec `anything', `options'
	local varn `s(varlist)'
	gettoken varn1 varn2 : varn
	local vtyp `s(typlist)'
	gettoken vtyp1 vtyp2 : vtyp
	tempvar z sigma
	if `:colnfreeparms e(b)' {
		scalar `sigma' = sqrt(_b[/var(e.`e(depvar)')])
	}
	else {
		scalar `sigma' = [sigma]_b[_cons]
	}
	_predict double `z' if `touse', xb `offset'
	if "`e(cmd)'" == "tobit" {
		tempvar y cens
		if "`e(llopt)'" == "" & "`e(ulopt)'" == "" {
			quietly gen byte `cens' = 0 if `touse'
			local llopt .
			local ulopt .
		}
		else if "`e(llopt)'" != "" & "`e(ulopt)'" != "" {
			quietly gen byte `cens' =		///
				(`e(depvar)' >= `e(ulopt)')	///
				- (`e(depvar)' <= `e(llopt)')	///
				if `touse'
			local llopt `e(llopt)'
			local ulopt `e(ulopt)'
		}
		else if "`e(llopt)'" != "" {
			quietly gen byte `cens' =		///
				- (`e(depvar)' <= `e(llopt)')	///
				if `touse'
			local llopt `e(llopt)'
			local ulopt .
		}
		else {
			quietly gen byte `cens' =		///
				(`e(depvar)' >= `e(ulopt)')	///
				if `touse'
			local llopt .
			local ulopt `e(ulopt)'
		}
		quietly gen double `y' = cond(`cens' == 0, `e(depvar)',	///
			cond(`cens' == -1, `llopt',			///
			cond(`cens' == 1, `ulopt', .))) if `touse'
		quietly replace `z' = (`y' - `z')/`sigma'
		drop `y'
		local xbeq model
	}
	else if "`e(cmd)'" == "cnreg" {
		quietly replace `z' = (`e(depvar)' - `z')/`sigma'
		local cens = e(censored)
	}
	else {
		di as err "option {bf:scores} not allowed"
		exit 198
	}
	if "`e(prefix)'" == "svy" {
		local pre "svy:"
	}


	// scores for equation: xb
	quietly gen `vtyp1' `varn1' =					///
		cond(`cens' == 0,					///
			`z'/`sigma',					///
		cond(`cens' == -1,					///
			-normalden(`z')/(`sigma'*normal(`z')),		///
		cond(`cens' == 1,					///
			normalden(`z')/(`sigma'*normal(-`z')),		///
			.						///
		)))
	label var `varn1' "equation-level score for model from `pre'`e(cmd)'"
	if `:colnfreeparms e(b)' {
		quietly gen `vtyp2' `varn2' =				///
			cond(`cens' == 0,				///
				-.5/(`sigma'^2) + (.5*(`z'/`sigma')^2),	///
			cond(`cens' == -1,				///
				-.5*(`sigma'^(-1))*`z'*normalden(`z')/	///
				(`sigma'*normal(`z')),			///
			cond(`cens' == 1,				///
				.5*(`sigma'^(-1))*`z'*normalden(`z')/	///
				(`sigma'*normal(-`z')),			///
				.					///
			)))
	}
	else {
		quietly gen `vtyp2' `varn2' =				///
			cond(`cens' == 0,				///
				`z'*`z'/`sigma' - 1/`sigma',		///
			cond(`cens' == -1,				///
				-`z'*normalden(`z')/			///
				(`sigma'*normal(`z')),			///
			cond(`cens' == 1,				///
				`z'*normalden(`z')/			///
				(`sigma'*normal(-`z')),			///
				.					///
			)))
	}
	label var `varn2' "equation-level score for sigma from `pre'`e(cmd)'"
	// scores for equation: sigma
	return local scorevars `varn'
end

exit
