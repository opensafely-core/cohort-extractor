*! version 3.0.7  05sep2001
program define cprplot_7
	version 6
	_isfit cons anovaok
	syntax varname [, Symbol(string) Connect(string) L1title(string) /*
	*/ BWidth(real .8) *]

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
	}

	local wgt `"[`e(wtype)' `e(wexp)']"'
	tempvar touse 
	qui gen byte `touse' = e(sample)

	local lhs "`e(depvar)'"
	capture local beta=_b[`varlist']
	if _rc { 
		di in red `"`varlist' is not in the model"'
		exit 398
	}
	tempvar resid hat lest ksm
	quietly { 
		_predict `resid' if `touse', resid
		replace `resid'=`resid'+`varlist'*_b[`varlist']
	}
	estimate hold `lest'
	capture { 
		regress `resid' `varlist' `wgt' if `touse'
		_predict `hat' if `touse'
	}
	local rc=_rc 
	estimate unhold `lest'
	if `rc' { error `rc' } 
	if "`l1title'"=="" { 
		local l1title `"e( `lhs' | X,`varlist' ) + b*`varlist'"'
	}
	if `"`symbol'"'=="" { local symbol "s(Oii)" }
	else local symbol `"s(`symbol'ii)"'
	if `"`connect'"'=="" { local connect "c(.l)" }
	else {
		if `"`connect'"'=="k" { 
			if `"`e(wtype)'"'!="" { 
				di in red "not possible with weighted fit"
				exit 398
			}
			estimate hold `lest'
			capture { 
				ksm `resid' `varlist' if `touse', /*
				*/ gen(`ksm') lowess nograph bwidth(`bwidth')
			}
			local rc=_rc
			estimate unhold `lest'
			if `rc' { error `rc' } 
			gr7 `resid' `hat' `ksm' `varlist', `symbol' /*
			*/ c(.ll) l1("`l1title'") sort `options'
			exit
		}
		else local connect `"c(`connect'l)"'
	}
	gr7 `resid' `hat' `varlist', `symbol' `connect' l1(`"`l1title'"') /*
		*/ sort `options'
end
