*! version 3.0.8  05sep2001
program define rvpplot_7 /* residual vs. predictor */
	version 6
	_isfit cons anovaok
	syntax varname [, L1title(string) *]

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
	if "`l1title'"=="" {
		local l1title "e( `lhs' | X,`varlist' )"
	}
	gr7 `resid' `varlist', l1("`l1title'") `options'
end
