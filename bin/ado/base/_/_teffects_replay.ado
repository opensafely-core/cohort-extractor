*! version 1.1.0  16jan2015
program define _teffects_replay
	version 13

	syntax, [ AEQuations * ]

	_get_diopts diopts, `options'


	if "`e(subcmd)'" == "ra" {
		local estimator "regression adjustment"
		mata: _teffects_omtitle("`e(omodel)'", "omodel")
		local tmodel "none"
	}
	else if "`e(subcmd)'" == "ipw" {
		local estimator "inverse-probability weights"
		local omodel "weighted mean"
		mata: _teffects_tmtitle("`e(tmodel)'", `e(k_levels)', "tmodel")
	}
	else if "`e(subcmd)'" == "ipwra" {
		local estimator "IPW regression adjustment"
		mata: _teffects_omtitle("`e(omodel)'", "omodel")
		mata: _teffects_tmtitle("`e(tmodel)'", `e(k_levels)', "tmodel")
	}
	else if "`e(subcmd)'" == "aipw" {
		if "`e(cme)'" == "nls" {
			local omest " by NLS"
		}
		else if "`e(cme)'" == "wnls" {
			local omest " by WNLS"
		}
		else {		// must be ml
			local omest " by ML"
		}
		local estimator "augmented IPW"
		mata: _teffects_omtitle("`e(omodel)'", "omodel")
		mata: _teffects_tmtitle("`e(tmodel)'", `e(k_levels)', "tmodel")
	}

	di as txt _n "`e(title)'"	///
		"{col 49}Number of obs {col 67}= " as res %10.0fc e(N)
	di "{txt:Estimator}{col 16}:{res: `estimator'}"
	di "{txt:Outcome model}{col 16}:{res: `omodel'`omest'}"
	di "{txt:Treatment model}{col 16}:{res: `tmodel'}"

	if "`aequations'" == "" {
		if ("`e(stat)'"=="pomeans") local neq neq(1)
		else local neq neq(2)
	}

	_coef_table, versus `neq' `diopts' 
	ml_footnote
end

mata:

void _teffects_tmtitle(string scalar model,	///
	real scalar k_levels,			///
	string scalar mname)			///
{

	if (model=="hetprobit")	{
		st_local(mname, "heteroskedastic probit")
	}
	else if (model=="logit" & k_levels>2)	{
		st_local(mname, "(multinomial) logit")
	}
	else {
		st_local(mname, model)
	}

}

void _teffects_omtitle(string scalar model,	///
	string scalar mname)			///
{

	if (model=="hetprobit")	{
		st_local(mname, "heteroskedastic probit")
	}
	else if (model=="poisson")	{
		st_local(mname, "Poisson")
	}
	else {
		st_local(mname, model)
	}

}

end

