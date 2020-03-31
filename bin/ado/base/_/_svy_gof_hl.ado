*! version 1.0.1  12apr2010
program _svy_gof_hl, rclass
	version 11
	if !inlist(`"`e(prefix)':`e(cmd)'"',	///
			"svy:logistic",		///
			"svy:logit",		///
			"svy:probit") {
		error 301
	}
	if "`e(vce)'" != "linearized" && e(k_extra) != 0 {
		error 301
	}
	local df = e(df_r)
	if !missing(`df') {
		local max "<=`df'"
	}
	syntax [if] [in] [, Group(numlist int >1 `max') total all]

	marksample touse
	if `:length local all' == 0 {
		quietly replace `touse' = 0 if !e(sample)
	}
	if `:length local group' == 0 {
		if `df' < 2 {
			di as err ///
"not enough degrees of freedom to perform the test"
			exit 322
		}
		if 10 > `df' {
			local group `df'
		}
		else {
			local group 10
		}
	}
	if `:length local total' == 0 {
		local total mean
	}

	local model = cond("`e(cmd)'" == "probit", "Probit", "Logistic")
	local y "`e(depvar)'"

	tempname ehold z d X
	_est hold `ehold', copy restore

	quietly predict double `z' if `touse', p
	if "`e(wtype)'" != "" {
		local wgt "[pw`e(wexp)']"
	}
	xtile `d' = `z' `wgt', nquantiles(`group')
	quietly replace `z' = `y'-`z'
	quietly svy `e(vce)', `e(mse)': `total' `z', over(`d')
	local df1 = `group' - 1
	if missing(`df') {
		matrix `X' = syminv(e(V))
		matrix `X' = (e(b)*syminv(e(V))*e(b)')
		scalar `X' = `X'[1,1]

		return scalar chi2 = `X'
		return scalar p = chi2tail(`df1', `X')
		return scalar df = `df1'
	}
	else {
		local df2 = `df' - `group' + 2
		matrix `X' = syminv(e(V))
		matrix `X' = (e(b)*syminv(e(V))*e(b)')*`df2'/(`df'*`group')
		scalar `X' = `X'[1,1]

		return scalar F = `X'
		return scalar p = Ftail(`df1', `df2', `X')
		return scalar df1 = `df1'
		return scalar df2 = `df2'
	}

	// output
	di
	di as txt "{title:`model' model for `y', goodness-of-fit test}"
	di
	if missing(`df') {
		local skip = 29 - length(`"chi2(`df1')"')
		di as txt _skip(`skip')				///
			"chi2("	as res `df1' as txt ") = "	///
				as res %12.2f `X'
		di as txt _skip(18) "Prob > chi2 = " as res %14.4f return(p)
	}
	else {
		local skip = 29 - length(`"F(`df1',`df2')"')
		di as txt _skip(`skip')				///
			"F("	as res `df1' as txt ","		///
				as res `df2' as txt ") = "	///
				as res %12.2f `X'
		di as txt _skip(21) "Prob > F = " as res %14.4f return(p)
	}
end
exit
