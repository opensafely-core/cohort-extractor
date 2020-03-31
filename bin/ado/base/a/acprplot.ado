*! version 3.4.0  17jun2009
program define acprplot /* augmented component-plus-residual */
	version 6.0
	if _caller() < 8 {
		acprplot_7 `0'
		exit
	}

	local ver : di "version " string(_caller()) ", missing :"

	local oldano 0
	if "`e(cmd)'" == "anova" {
		if 0`e(version)' < 2 {		// old anova
			local oldano 1
			if _caller() >= 11 {	// force to old version
				local ver "version 10.1, missing :"
			}
		}
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

	local wgt `"[`e(wtype)' `e(wexp)']"'

	local lhs "e(depvar)"

	// treat new anova like regress; old anova needs special code
	if `oldano' {
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
	else { /* e(cmd) is regress (or new anova) */
		local a "*"
	}

	/* `r' and `a' at the beginning of a line indicate that the line will
	   only be run when regress and old anova respectively */

	capture local beta=_b[`varlist']
	if _rc { 
		di in red "`varlist' is not in the model"
		exit 398
	}
	tempvar resid hat lest v2 sifvar
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
`a'		`ver' anova `svl' `v2' `wgt' `sif' , cont(`acont' `v2')
`r'		`ver' _regress `svl' `v2' `wgt' `sif' 
		local b0=_b[`varlist']
		local b1=_b[`v2']
		_predict `resid' `sif', resid
		replace `resid'=`resid'+`b0'*`varlist'+`b1'*`v2'
		_regress `resid' `varlist' `sif'
		_predict `hat' `sif'
	}
	local rc=_rc
	estimate unhold `lest'
	if `rc' { error `rc' } 
	if `b0'==0 | `b1'==0 { 
		di in gr "`varlist'^2 is collinear with `varlist'"
		exit
	}
	local yttl "Augmented component plus residual"
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
			`sif',				///
			sort				///
			yvarlabel("Lowess smooth")	///
			`lsopts'			///
		)
	}
	if `"`mspline'"' != "" {
		local grmsp				///
		(mspline `resid' `varlist'		///
			`sif',				///
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
		`sif',					///
		sort					///
		ytitle(`"`yttl'"')			///
		xtitle(`"`xttl'"')			///
		`legend'				///
		`options'				///
	)						///
	(line `hat' `varlist' 				///
		`sif',					///
		sort					///
		lstyle(refline)				///
		`rlopts'				///
	)						///
	`grlow'						///
	`grmsp'						///
	|| `plot' || `addplot'				///
	// blank
end
