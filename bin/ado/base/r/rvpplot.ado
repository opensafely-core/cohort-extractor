*! version 3.2.0  29sep2004
program define rvpplot /* residual vs. predictor */
	version 6
	if _caller() < 8 {
		rvpplot_7 `0'
		exit
	}

	_isfit cons anovaok
	syntax varname [, * ]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	if "`e(cmd)'" == "anova" {
		anova_terms
		local aterms `r(rhs)'
		local found 0
		foreach trm of local aterms {
			if "`trm'" == "`varlist'" {
				local found 1
				continue, break
			}
		}
		if !`found' {
			di in red "`varlist' is not in the model"
			exit 398
		}
	}
	else { /* regress */
		capture local beta=_b[`varlist']
		if _rc {
			di in red "`varlist' is not in the model"
			exit 398
		}
	}

	local lhs "`e(depvar)'"
	tempvar resid
	quietly _predict `resid' if e(sample), resid
	local yttl : var label `resid'
	local xttl : var label `varlist'
	if `"`xttl'"' == "" {
		local xttl `varlist'
	}
	version 8: graph twoway			///
	(scatter `resid' `varlist',		///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`options'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end
