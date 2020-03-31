*! version 3.2.2  07mar2005
program define cprplot
	version 6
	if _caller() < 8 {
		cprplot_7 `0'
		exit
	}

	_isfit cons anovaok
	syntax varname [, LOWess MSPline *]

	_get_gropts , graphopts(`options') 			///
		getallowed(RLOPts LSOPts MSOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local lsopts `"`s(lsopts)'"'
	local msopts `"`s(msopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')
	_check4gropts lsopts, opt(`lsopts')
	_check4gropts msopts, opt(`msopts')
	if `"`lsopts'"' != "" {
		local lowess lowess
	}
	if `"`msopts'"' != "" {
		local mspline mspline
	}

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
	tempvar resid hat lest
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
	if `rc' {
		error `rc'
	}
	local yttl "Component plus residual"
	local xttl : var label `varlist'
	if `"`xttl'"' == "" {
		local xttl `varlist'
	}
	if `"`lowess'"' != "" {
		if `"`e(wtype)'"'!="" { 
			di in red "not possible with weighted fit"
			exit 398
		}
		local grlow				///
		(lowess `resid' `varlist'		///
			if `touse',			///
			sort				///
			yvarlabel("Lowess smooth")	///
			`lsopts'			///
		)
	}
	if `"`mspline'"' != "" {
		local grmsp				///
		(mspline `resid' `varlist'		///
			if `touse',			///
			sort				///
			yvarlabel("Spline smooth")	///
			`msopts'			///
		)
	}
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	version 8: graph twoway				///
	(scatter `resid' `varlist' 			///
		if `touse',				///
		sort					///
		ytitle(`"`yttl'"')			///
		xtitle(`"`xttl'"')			///
		`legend'				///
		`options'				/// graph opts
	)						///
	(line `hat' `varlist' 				///
		if `touse',				///
		sort					///
		lstyle(refline)				///
		`rlopts'				/// graph opts
	)						///
	`grlow'						///
	`grmsp'						///
	|| `plot' || `addplot'				///
	// blank
end
