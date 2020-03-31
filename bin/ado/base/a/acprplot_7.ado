*! version 3.1.4  05sep2001
program define acprplot_7 /* augmented component-plus-residual */
	version 6.0
	_isfit cons anovaok
	syntax varname [, Symbol(string) Connect(string) L1title(string) /*
		*/ BWidth(real .8) *]

	local wgt `"[`e(wtype)' `e(wexp)']"'

	local lhs "e(depvar)"

	if "`e(cmd)'" == "anova" {
		anova_terms
		local cterms `r(continuous)'
		local found 0
		foreach trm of local cterms {
			if "`trm'" == "`varlist'" {
				local found 1
				continue, break
			}
		}
		if !`found' {
			di in red /*
			*/ "`varlist' is not a continuous variable in the model"
			exit 398
		}
		local r "*"
	}
	else { /* e(cmd) is regress */
		local a "*"
	}

	/* `r' and `a' at the beginning of a line indicate that the line will
	   only be run when regress and anova respectively */

	capture local beta=_b[`varlist']
	if _rc { 
		di in red "`varlist' is not in the model"
		exit 398
	}
	tempvar resid hat lest ksm v2 sifvar
`a'	anova_terms
`a'	local svl "`e(depvar)' `r(rhs)'"
`a'	local acont `r(continuous)'
`r'	_getrhs svl
`r'	local svl "`e(depvar)' `svl'"
	qui gen byte `sifvar' = e(sample)
	local sif "if `sifvar'"
	estimate hold `lest'
	capture { 
		gen `v2'=`varlist'*`varlist' `sif' 
`a'		anova `svl' `v2' `wgt' `sif' , cont(`acont' `v2')
`r'		reg `svl' `v2' `wgt' `sif' 
		local b0=_b[`varlist']
		local b1=_b[`v2']
		_predict `resid' `sif', resid
		replace `resid'=`resid'+`b0'*`varlist'+`b1'*`v2'
		reg `resid' `varlist' `sif'
		_predict `hat' `sif'
	}
	local rc=_rc
	estimate unhold `lest'
	if `rc' { error `rc' } 
	if `b0'==0 | `b1'==0 { 
		di in gr "`varlist'^2 is collinear with `varlist'"
		exit
	}
	if "`l1title'"=="" { 
		local l1title "Augmented component plus residual"
	}
	if "`symbol'"=="" { local symbol "s(Oii)" }
	else local symbol "s(`symbol'ii)"
	if "`connect'"=="" { local connect "c(.l)" }
	else {
		if "`connect'"=="k" { 
			if "`e(wtype)'"!="" { 
				di in red "not possible with weighted fit"
				exit 398
			}
			tempvar forksm
			qui gen byte `forksm' = e(sample)
			estimate hold `lest'
			capture { 
				ksm `resid' `varlist' if `forksm', lowess /*
					*/ gen(`ksm') nograph bwidth(`bwidth')
			}
			local rc=_rc
			estimate unhold `lest'
			if `rc' { error `rc' } 
			gr7 `resid' `ksm' `hat' `varlist', `symbol' /*
			*/ c(.ll) l1("`l1title'") sort `options'
			exit
		}
		else local connect "c(`connect'l)"
	}
	gr7 `resid' `hat' `varlist', `symbol' `connect' l1("`l1title'") /*
		*/ sort `options'
end
