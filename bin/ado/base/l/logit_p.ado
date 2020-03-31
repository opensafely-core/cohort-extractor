*! version 1.6.0  07aug2019
program define logit_p, sort
	version 6, missing

	quietly syntax [anything] [if] [in] [iw] [, SCores * ]
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
	local xopts ///
	DEviance DX2 DDeviance RStandard DBeta Hat Number Residuals
	local oopts Pr d1(string) d2(string)
	local jopts 	j1(passthru)	///
			j2(passthru)	///
			dydx(passthru)	///
			dyex(passthru)	///
			eydx(passthru)	///
			eyex(passthru)
	if `"`e(prefix)'`e(opt)'"' != "" {
		local oopts `oopts' RULEs asif xb index stdp
	}
	local myopts `xopts' `oopts' `jopts'

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	if "`weight'" == "" {
		_pred_se "`myopts'" `0'
		if `s(done)' { exit }
		local vtyp  `s(typ)'
		local varn `s(varn)'
		local 0 `"`s(rest)'"'
	}
	else if `"`j1'`j2'"' == "" {
		di as err "weights not allowed"
		exit 101
	}
	else {
		quietly syntax newvarname [if] [in] [iw] [, *]
		local vtyp : copy local typlist
		local varn : copy local varlist
		local WEIGHT : copy local weight
		local EXP : copy local exp
		local 0 `if' `in' , `options'
	}


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]
	if `:length local index' {
		local xb xb
	}
	opts_exclusive "`asif' `rules'"

	if `"`d1'"' != "" {
		opts_exclusive `"d1() `j1'"'
		opts_exclusive `"d1() `j2'"'
	}
	opts_exclusive `"`j1' `j2'"'
	if `"`j1'"' != "" {
		ParseName j1 , `j1'
	}
	if `"`j2'"' == "" {
		OptionNotAllowed, `dydx' `dyex' `eydx' `eyex'
	}
	else {
		local j2extra `dydx' `dyex' `eydx' `eyex'
		if `"`j2extra'"' == "" {
			di as err ///
			"option {bf:j2()} requires option {bf:dydx()}"
			exit 198
		}
		else {
			opts_exclusive `"`j2extra'"'
		}
		ParseName j2 , `j2'
		ParseVarname dydx , `dydx'
		ParseVarname dyex , `dyex'
		ParseVarname eydx , `eydx'
		ParseVarname eyex , `eyex'
		local j2xvar `dydx' `dyex' `eydx' `eyex'
	}

	if "`e(prefix)'" != "" {
		_prefix_nonoption after `e(prefix)' estimation,		///
			`deviance' `dx2' `ddeviance' `rstandard'	///
			`dbeta' `hat' `number' `residuals'
	}

		/* Step 4:
			Concatenate switch options together
		*/
	local type /*
*/"`dbeta'`devianc'`dx2'`ddevian'`hat'`number'`pr'`residua'`rstanda'`xb'`stdp'"
/*         1234567       1234567       123456      1234567  1234567*/

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
			if "`j1'" != "" {
				di as err "option j1() not allowed"
				exit 198
			}
			if "`j2'" != "" {
				di as err "option j2() not allowed"
				exit 198
			}
			if "`d1'" != "" {
				di as err "option d1() not allowed"
				exit 198
			}
			_predict `vtyp' `varn' `if' `in', `offset'
			label var `varn' "Pr(`e(depvar)')"
			exit
		}
		tempname xb
		qui _predict double `xb' `if' `in', `offset' xb
		_pred_rules `xb' `if' `in', `rules' `asif'

	if `"`d2'"' != "" {
		local p `varn'
		local q `xb'
		gen `vtyp' `varn' = invlogit(`xb') `if' `in'
		qui replace `q' = invlogit(-`xb') `if' `in'
		qui replace `varn' = `p'*`q'*(`q'-`p')
		label var `varn' "d2 Pr(`e(depvar)') / d xb d xb"
	}
	else if `"`d1'"' != "" {
		gen `vtyp' `varn' = ///
			invlogit(`xb')*invlogit(-`xb') `if' `in'
		label var `varn' "d Pr(`e(depvar)') / d xb"
	}
	else if `"`j2'"' != "" {
		tempname p q dp dz
		gen double `p' = invlogit(`xb') `if' `in'
		qui gen double `q' = invlogit(-`xb') `if' `in'
		qui gen double `dp' = `p'*`q' `if' `in'
		local d2p `xb'
		qui replace `d2p' = `dp'*(`q'-`p') `if' `in'
		if "`eydx'`eyex'" != "" {
			qui replace `dp' = `dp'/`p'
			qui replace `d2p' = `d2p'/`p' - `dp'*`dp'
		}
		if "`dyex'`eyex'" != "" {
			qui replace `dp' = `dp'*`j2xvar'
			qui replace `d2p' = `d2p'*`j2xvar'
		}

		_ms_dzb_dx `j2xvar', matrix(b) eclass
		matrix `dz' = r(b)
		qui matrix score `vtyp' `varn' = `dz' `if' `in'
		qui replace `d2p' = `d2p'*`varn' `if' `in'
		qui replace `varn' = `dp'*`varn' `if' `in'

		if "`WEIGHT'" != "" {
			local wt [iw`EXP'*`d2p']
		}
		else {
			local wt [iw=`d2p']
		}
		_ms_means b `if' `in' `wt', eclass sumonly
		matrix `j2' = r(means)

		if "`WEIGHT'" != "" {
			local wt [iw`EXP'*`dp']
		}
		else {
			local wt [iw=`dp']
		}
		_ms_means `dz' `if' `in' `wt', sumonly
		mata: logit_p_dp_d2z("`dz'")
		matrix `j2' = `j2' + `dz'
	}
	else {
		if `"`j1'"' != "" {
			tempname dp
			qui gen double `dp' = ///
				invlogit(`xb')*invlogit(-`xb') `if' `in'
			if "`WEIGHT'" != "" {
				local wt [iw`EXP'*`dp']
			}
			else {
				local wt [iw=`dp']
			}
			_ms_means b `if' `in' `wt', eclass sumonly
			matrix `j1' = r(means)
		}
		gen `vtyp' `varn' = invlogit(`xb') `if' `in'
		label var `varn' "Pr(`e(depvar)')"
	}

		exit
	}

	if "`d1'" != "" {
		di as err "option d1() not allowed with option `type'"
		exit 198
	}
	if "`d2'" != "" {
		di as err "option d2() not allowed with option `type'"
		exit 198
	}
	if "`j1'" != "" {
		di as err "option j1() not allowed with option `type'"
		exit 198
	}
	if "`j2'" != "" {
		di as err "option j2() not allowed with option `type'"
		exit 198
	}
	if "`WEIGHT'" != "" {
		di as err "weights not allowed"
		exit 101
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
		label var `varn' "Linear prediction (log odds)"
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
	qui replace `touse'=0 if !e(sample)

	if "`type'"=="rstandard" {
		tempvar resid hat
		qui predict double `resid' if `touse', resid `offset'
		qui predict double `hat' if `touse', hat `offset'
		gen `vtyp' `varn' = `resid'/sqrt(1-`hat') if `touse'
		label var `varn' "standardized Pearson residual"
		exit
	}
	
	if "`type'"=="dbeta" {
		tempvar resid hat 
		qui predict double `resid' if `touse', resid `offset'
		qui predict double `hat' if `touse', hat `offset'
		gen `vtyp' `varn' = `resid'^2*`hat'/(1-`hat')^2
		label var `varn' "Pregibon's dbeta"
		exit
	}

	if "`type'"=="dx2" {
		tempvar rstd
		qui predict double `rstd' if `touse', rstandard `offset'
		gen `vtyp' `varn' = `rstd'^2
		label var `varn' "H-L dX^2"
		exit
	}

	if "`type'"=="ddeviance" {
		tempvar dev hat 
		qui predict double `dev', deviance `offset'
		qui predict double `hat', hat `offset'
		gen `vtyp' `varn' = `dev'^2/(1-`hat')
		label var `varn' "H-L dD"
		exit
	}


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
	unopvarlist `rhs'
	local rhs `r(varlist)'
	tempvar keep
	qui gen byte `keep' = e(sample)
	sort `keep' `rhs'

	if "`type'"=="number" { 
		tempvar n
		qui {
			by `keep' `rhs': gen `c(obs_t)' `n' = 1 if _n==1 & `keep'
			replace `n' = sum(`n')
		}
		gen `vtyp' `varn' = `n' if `n'>0 & `touse'
		label var `varn' "covariate pattern"
		exit
	}

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
			quietly replace `p' = invlogit(`p')
		}
		else {
			_predict double `p' if `keep', `offset'
		}
		_pred_rules `p' if `keep', `rules' `asif'
		by `keep' `rhs': gen `c(obs_t)' `m'=cond(_n==_N,sum(`w'),.)
		by `keep' `rhs': gen `c(obs_t)' `y'=cond(_n==_N, /*
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
			by `keep' `rhs': replace `s' = cond(`keep',`s'[_N],.)
		}
		gen `vtyp' `varn' = `s' if `touse'
		label var `varn' `"`lab'deviance residual"'
		exit
	}

	if "`type'"=="hat" {
		tempvar s
		quietly {
			_predict double `s' if `keep', stdp `offset'
			replace `s' = `m'*`p'*(1-`p')*`s'*`s' if `keep'
			by `keep' `rhs': replace `s' = cond(`keep',`s'[_N],.)
		}
		gen `vtyp' `varn' = `s' if `touse'
		label var `varn' `"`lab'leverage"'
		exit
	}

	if "`type'"=="residuals" {
		tempvar s
		quietly {
			gen double `s' = (`y'-`m'*`p')/sqrt(`m'*`p'*(1-`p'))
			by `keep' `rhs': replace `s' = cond(`keep',`s'[_N],.)
		}
		gen `vtyp' `varn' = `s' if `touse'
		label var `varn' `"`lab'Pearson residual"'
		exit
	}

			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end

program OptionNotAllowed
	syntax [, NULLOPT]
end

program ParseName
	gettoken id 0 : 0, parse(", ")
	syntax [, `id'(name)]
	c_local `id' `"``id''"'
end

program ParseVarname
	gettoken id 0 : 0, parse(", ")
	syntax [, `id'(varname)]
	c_local `id' `"``id''"'
end

program define GetRhs /* name */ 
	args where
	local rhs : colnames e(b)
	local uscons _cons
	local 0 : list rhs - uscons
	syntax [varlist(fv default=none)]
	c_local `where' "`0'"
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
	`varn' = -invlogit(`xb') if `e(depvar)' == 0
	quietly replace ///
	`varn' = invlogit(-`xb') if `e(depvar)' != 0
	local cmd = cond("`e(prefix)'"=="svy","svy:","")+"`e(cmd)'"
	label var `varn' "equation-level score from `cmd'"
	return local scorevars `varn'
end

mata:

void logit_p_dp_d2z(string scalar mdz)
{
	real	rowvector	dz	
	real	rowvector	rmeans	
	real	rowvector	eb	
	real	scalar		dim
	real	scalar		i

	dz	= st_matrix(mdz)
	rmeans	= st_matrix("r(means)")
	eb	= st_matrix("e(b)")

	dim = cols(dz)
	for (i=1; i<=dim; i++) {
		if (eb[i]) {
			dz[i] = rmeans[i]*dz[i]/eb[i]
		}
		else {
			dz[i] = 0
		}
	}
	st_matrix(mdz, dz)
}

end

exit
