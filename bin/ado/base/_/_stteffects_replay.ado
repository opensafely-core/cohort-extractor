*! version 1.0.0  09feb2015

program define _stteffects_replay

        syntax, [ AEQuations * ]

        _get_diopts diopts, `options'

	local tmodel "none"
	local cmodel "none"
	if "`e(subcmd)'" == "ra" {
		local estimator "regression adjustment"
		MTitle, model(`e(omodel)')
		local omodel "`s(title)'"
	}
	else if "`e(subcmd)'" == "wra" {
		local estimator "weighted regression adjustment"
		MTitle, model(`e(omodel)') 
		local omodel "`s(title)'"
		MTitle, model(`e(cmodel)') 
		local cmodel "`s(title)'"
	}
	else if "`e(subcmd)'" == "ipw" {
		local estimator "inverse-probability weights"
		local omodel "weighted mean"
		MTitle, model(`e(tmodel)')
		local tmodel "`s(title)'"
		if "`e(cmodel)'" != "" {
			MTitle, model(`e(cmodel)') 
			local cmodel "`s(title)'"
		}
	}
	else if "`e(subcmd)'" == "ipwra" {
		local estimator "IPW regression adjustment"
		MTitle, model(`e(omodel)')
		local omodel "`s(title)'"
		MTitle, model(`e(tmodel)')
		local tmodel "`s(title)'"
		if "`e(cmodel)'" != "" {
			MTitle, model(`e(cmodel)')
			local cmodel "`s(title)'"
		}
	}
	di as txt _n "`e(title)'"	///
		"{col 49}Number of obs {col 67}= " as res %10.0fc e(N)
	di "{txt:Estimator}{col 16}:{res: `estimator'}"
	di "{txt:Outcome model}{col 16}:{res: `omodel'}"
	di "{txt:Treatment model}{col 16}:{res: `tmodel'}"
	if "`cmodel'" != "" {
		di "{txt:Censoring model}{col 16}:{res: `cmodel'}"
	}
	if "`aequations'" == "" {
		if ("`e(stat)'"=="pomeans") local neq neq(1)
		else local neq neq(2)
	}
	_coef_table, versus `neq' `diopts'
	ml_footnote
end


program define MTitle, sclass
	syntax, model(string)

	if "`model'" == "hetprobit" {
		sreturn local title "heteroskedastic probit"
	}
	else if "`model'" == "weibull" {
		sreturn local title "Weibull"
	}
	else {
		sreturn local title "`model'"
	}
end


exit
