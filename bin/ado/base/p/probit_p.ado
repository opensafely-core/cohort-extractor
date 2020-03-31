*! version 1.4.2  19feb2019
program define probit_p, sort
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
	local xopts DEviance
	local oopts Pr d1(string) d2(string)
	if `"`e(prefix)'`e(opt)'"' != "" {
		local oopts `oopts' RULEs asif xb index stdp
	}
	local myopts `xopts' `oopts'

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
	if `:length local index' {
		local xb xb
	}
	opts_exclusive "`asif' `rules'"

	if "`e(prefix)'" != "" {
		_prefix_nonoption after `e(prefix)' estimation,		///
			`deviance'
	}

		/* Step 4:
			Concatenate switch options together
		*/
	local type "`xb'`pr'`devianc'`stdp'"
		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/
	if "`type'"=="" | "`type'"=="pr" {
		if `"`d2'"' != "" & `"`d1'"' == "" {
			di as err "option d2() requires option d1()"
			exit 198
		}
		if "`type'"=="" {
			di in smcl in gr ///
			"(option {bf:pr} assumed; Pr(`e(depvar)'))"
		}
		if "`e(prefix)'`e(opt)'" == "" {
			_predict `vtyp' `varn' `if' `in', `offset'
			label var `varn' "Pr(`e(depvar)')"
			exit
		}
		tempname xb
		qui _predict double `xb' `if' `in', `offset' xb
		_pred_rules `xb' `if' `in', `rules' `asif'

	if `"`d2'"' != "" {
		gen `vtyp' `varn' = -`xb'*normalden(`xb') `if' `in'
		label var `varn' "d2 Pr(`e(depvar)') / d xb d xb"
	}
	else if `"`d1'"' != "" {
		gen `vtyp' `varn' = normalden(`xb') `if' `in'
		label var `varn' "d Pr(`e(depvar)') / d xb"
	}
	else {
		gen `vtyp' `varn' = normal(`xb') `if' `in'
		label var `varn' "Pr(`e(depvar)')"
	}

		exit
	}


		/* Step 6:
			mark sample (this is not e(sample)).
		*/


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
	if "`type'"=="xb" {
		quietly _predict `vtyp' `varn' `if' `in', `offset' xb
		_pred_rules `varn' `if' `in', `rules' `asif'
		_pred_missings `varn'
		label var `varn' "Linear prediction"
		exit
	}

	if "`type'"=="stdp" {
		opts_exclusive "stdp `rules'"
		quietly _predict `vtyp' `varn' `if' `in', `offset' stdp
		_pred_rules `varn' `if' `in', `asif'
		_pred_missings `varn'
		label var `varn' "S.E. of the prediction"
		exit
	}

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	marksample touse

		/* 
			For the remaining cases, we need the model 
			variables
		*/
	
	GetRhs rhs

		/*
			below we distinguish carefully between e(sample) 
			and `touse' because e(sample) may be a superset 
			of `touse'
		*/
	tempvar keep
	qui gen byte `keep' = e(sample)
	unopvarlist `rhs'
	local uorhs `"`r(varlist)'"'
	sort `keep' `uorhs'
	qui replace `touse'=0 if !`keep'


		/*
			remaining types require we know the weights, 
			if any.
		*/
	if `"`e(wtype)'"' != "" {
		if `"`e(wtype)'"' != "fweight" {
			di in red `"not possible with `e(wtype)'s"'
			exit 135
		}
		tempvar w
		qui {
			gen double `w' `e(wexp)'
			compress `w'
		}
		local lab "weighted "
	}
	else	local w 1

		/*
			remaining types require we know 
				p = probability of success
				m = # in covariate pattern
				y = # of successes within covariate pattern
		*/
	tempvar p m y
	quietly {
		if "`e(prefix)'`e(opt)'" != "" {
			quietly _predict double `p' if `keep', `offset' xb
			_pred_rules `p' if `keep', `rules' `asif'
			quietly replace `p' = norm(`p')
		}
		else {
			_predict double `p' if `keep', `offset'
		}
		_pred_rules `p' if `keep', `rules' `asif'
		by `keep' `uorhs': gen `c(obs_t)' `m'=cond(_n==_N,sum(`w'),.)
		by `keep' `uorhs': gen `c(obs_t)' `y'=cond(_n==_N, /*
			*/ sum((`e(depvar)'!=0 & `e(depvar)'<.)*`w'), .)
	}

	if "`type'"=="deviance" {
		tempvar s
		quietly {
			gen double `s' = sqrt(				/*
				*/ 2*(					/*
				*/ `y'*ln(`y'/(`m'*`p')) + 		/*
				*/ (`m'-`y')*ln((`m'-`y')/(`m'*(1-`p')))/*
				*/ )					/*
				*/ )
			replace `s'=-`s' if `y'-`m'*`p'<0
			replace `s'=-sqrt(2*`m'*abs(ln1m(`p'))) if `y'==0
			replace `s'= sqrt(2*`m'*abs(ln(`p'))) if `y'==`m'
			by `keep' `uorhs': replace `s' = cond(`keep',`s'[_N],.)
		}
		gen `vtyp' `varn' = `s' if `touse'
		label var `varn' `"`lab'deviance residual"'
		exit
	}

	error 198
end

program define GetRhs /* name */ 
	args where
	tempname b 
	mat `b' = get(_b)
	local rhs : colnames `b'
	mat drop `b'
	local n : word count `rhs'
	tokenize `rhs'
	if "``n''"=="_cons" {
		local `n'
	}
	c_local `where' "`*'"
end

program GenScores, rclass
	version 9, missing
	syntax [anything] [if] [in] [, * ]
	_score_spec `anything', `options'
	local varn `s(varlist)'
	local vtyp `s(typlist)'
	tempvar xb
	_predict double `xb' `if' `in', xb
	quietly gen `vtyp' ///
	`varn' = -normden(`xb')/norm(-`xb') if `e(depvar)' == 0
	quietly replace ///
	`varn' = normden(`xb')/norm(`xb') if `e(depvar)' != 0
	local cmd = cond("`e(prefix)'"=="svy","svy:","")+"`e(cmd)'"
	label var `varn' "equation-level score from `cmd'"
	return local scorevars `varn'
end

exit
