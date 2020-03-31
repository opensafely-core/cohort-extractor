*! version 1.2.1  16jan2019
program define regres_p, properties(default_xb)
	local vv : display "version " string(_caller()) ", missing:"
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
	local xopts COVratio DFBeta(string) DFIts E(string)	///
		Hat Leverage Pr(string) Welsch YStar(string)
	if "`e(prefix)'" != "" {
		local svyopts Residuals Cooksd RSTAndard RSTUdent STDF STDR
	}
	else if "`e(vcetype)'" == "Robust" {
		local svyopts Cooksd RSTAndard RSTUdent STDF STDR
	}
	local myopts `xopts' `svyopts'

	if "`e(prefix)'" != "" | "`e(vcetype)'" == "Robust" {
		if "`e(vcetype)'" == "Robust" {
			local msg after robust estimation
		}
		else	local msg after `e(prefix)' estimation
		// trap invalid options and give an informative error msg
		syntax [anything] [if] [in] [, `myopts' *]
		if "`dfbeta'" != "" {
			local dfbopt dfbeta(`dfbeta')
		}
		if "`e(prefix)'" == "svy" | "`e(vcetype)'" == "Robust" {
			if "`e'" != "" {
				local eopt e(`e')
			}
			if "`pr'" != "" {
				local propt pr(`pr')
			}
			if "`ystar'" != "" {
				local ysopt ystar(`ystar')
			}
		}
		_prefix_nonoption `msg', `cooksd' `covrati' `dfbopt'	///
			`dfits' `eopt' `hat' `leverag' `propt'		///
			`rstandard' `rstudent' `stdf' `stdr' `welsch' `ysopt'
	}


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
	local type "`covrati'`dfits'`leverag'`welsch'`hat'`residua'"
	local args `"`dfbeta'`pr'`e'`ystar'"'


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/
	if "`type'"=="" & `"`args'"'=="" {
		di in smcl in gr "(option {bf:xb} assumed; fitted values)"
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

	if "`dfbeta'"!="" {		/* restricted to e(sample)	*/
		if "`type'"!="" { error 198 }
		if "`offset'"!="" {
			di in red "nooffset() with dfbeta not allowed"
			exit 198
		}
		`vv' ///
		DFbeta "`vtyp'" "`varn'" "`touse'" "`dfbeta'"
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

	if "`type'"=="leverage" || "`type'"=="hat" {
		_predict `vtyp' `varn' if `touse', hat `offset'
		exit
	}


		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	qui replace `touse'=0 if !e(sample)


	if "`type'"=="dfits" { 		/* restricted to e(sample)	*/
		tempvar hh t
		qui _predict double `hh' if `touse', hat `offset'
		qui _predict double `t' if `touse', rstudent `offset'
		gen `vtyp' `varn' = `t'*sqrt(`hh'/(1-`hh')) if `touse'
		label var `varn' "DFITS"
		exit
	}

	if "`type'"=="welsch" { 	/* restricted to e(sample)	*/
		tempvar hh t
		qui _predict double `hh' if `touse', hat `offset'
		qui _predict double `t' if `touse', rstudent `offset'
		gen `vtyp' `varn'=(`t'*sqrt(`hh'/(1-`hh')))* /*
			*/ sqrt((e(N)-1)/(1-`hh')) if `touse'
		label var `varn' "Welsch distance"
		exit
	}
		
	if "`type'"=="covratio" {	/* restricted to e(sample)	*/
		tempvar hh t
		qui _predict double `hh' if `touse', hat `offset'
		qui _predict double `t' if `touse', resid `offset'
		qui replace `t'=`t'/(e(rmse)*sqrt(1-`hh')) if `touse'
		gen `vtyp' `varn' = (( /*
			*/(e(N)-e(df_m)-`t'*`t'-1)/(e(N)-e(df_m)-2) /*
			*/)^(e(df_m)+1)) / (1-`hh') if `touse'
		label var `varn' "COVRATIO"
		exit
	}

			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end



program define DFbeta /* "`typ'" "`varn'" "`touse'" "`dfbeta'" */
	version 6, missing
	args type newvar touse var
	if "`e(wtype)'" != "" {
		di in red "not possible after weighted regression"
		exit 398
	}

	_ms_extract_varlist `var'
	local varlist `"`r(varlist)'"'
	if `:list sizeof varlist' > 1 {
		di as err "invalid dfbeta() option;"
		di as err "too many variables specified"
		exit 103
	}

	tempname b

	matrix `b' = e(b)
	local dim = colsof(`b')
	local pos = colnumb(`b', "`var'")

	local rhs : colnames `b'
	mat drop `b'
	local USCONS _cons
	if `:list USCONS in rhs' {
		local rhs : list rhs - USCONS
		local --dim
	}

	fvrevar `rhs'
	local rrhs `"`r(varlist)'"'
	forval i = 1/`dim' {
		gettoken X rhs : rhs
		if `i' == `pos' {
			gettoken y rrhs : rrhs
			local Y : copy local X
		}
		else {
			gettoken x rrhs : rrhs
			local xvars `xvars' `x'
		}
	}

	tempvar HAT RSTU lest RES SRES RESULT
	qui _predict double `HAT' if `touse' & e(sample), hat
	qui _predict double `RSTU' if `touse' & e(sample), rstud
	version 11: _est hold `lest', restore
	quietly _regress `y' `xvars' if `RSTU'<.
	quietly _predict double `RES' if `RSTU'<., res
	version 11: _est unhold `lest'
	quietly gen double `SRES'=sum(`RES'^2)
	gen `type' `newvar'=`RSTU'*`RES'/sqrt((1-`HAT')*`SRES'[_N])
	label var `newvar' "DFBETA `Y'"
end

program GenScores, rclass
	version 9, missing
	syntax [anything] [if] [in] [, * ]
	marksample touse
	_score_spec `anything', `options'
	local varn `s(varlist)'
	local vtyp `s(typlist)'
	tempvar xb
	quietly _predict double `xb' if `touse', xb
	gen `vtyp' `varn' = `e(depvar)' - `xb'
	label var `varn' "Residuals"
	return local scorevars `varn'
end
