*! version 3.5.0  17jun2009
program define avplot, rclass sort
	local vv : display "version " string(_caller()) ", missing:"
	version 6
	if _caller() < 8 {
		avplot_7 `0'
		return add
		exit
	}

	_isfit cons newanovaok
	_ms_op_info e(b)
	local fvops = r(fvops)
	local tsops = r(tsops)
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
	}

	syntax [anything(name=var id="varname")] [, *]

	if `"`var'"' == "" {
		syntax varname [, *]
		exit 100
	}
	if `:list sizeof var' > 1 {
		error 103
	}
	capture _ms_extract_varlist `var'
	if !c(rc) {
		local varlist `"`r(varlist)'"'
		if `:list sizeof varlist' > 1 {
			error 103
		}
		if _b[`varlist'] == 0 {
			di in gr "(`varlist' was dropped from model)"
			exit 399
		}
	}
	else {
		capture _msparse `var'
		if c(rc) {
			error 198
		}
		local varlist `"`r(stripe)'"'
	}

	_get_gropts , graphopts(`options') getallowed(RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')

	local v `varlist'
	local wgt "[`e(wtype)' `e(wexp)']"
	tempvar touse resid lest evx hat

			/* determine if v in original varlist	*/
	if "`e(depvar)'"=="`v'" { 
		di in red "cannot include dependent variable"
		exit 398
	}
	local lhs "`e(depvar)'"
	if "`e(vcetype)'"=="Robust" {
		local robust="robust"
	}
	_getrhs rhs
	gen byte `touse' = e(sample)
	if "`e(clustvar)'"~="" {
		tempname myest
		local cluster="cluster(`e(clustvar)')"
		estimates hold `myest'
		`vv' ///
		qui _regress `lhs' `rhs' if `touse', `robust'
		local ddof= e(df_r)
		estimates unhold `myest'
	}
	else {
		local ddof= e(df_r)
	}
	local inorig : list v in rhs
	quietly {
		_predict `resid' if `touse', resid
	}
	_ms_parse_parts `v'
	local isvar = r(type) == "variable"
	local hasts = "`r(ts_op)'" != ""
	if `isvar' {
		local x : copy local v
	}
	else {
		fvrevar `v'
		local x `r(varlist)'
	}
	if !`inorig' {	 		/* not originally in	*/
		capture assert `v'!=. if `touse'
		if _rc { 
			di in red "`v' has missing values" _n /*
		*/ "you must reestimate including `v'"
			exit 398
		}
		estimate hold `lest'
		capture { 
			`vv' ///
			regress `x' `rhs' `wgt' if `touse',		///
				`robust' `cluster'
			_predict `evx' if `touse', resid
			`vv' ///
			regress `resid' `evx' `wgt' if `touse',		///
				`robust' `cluster'
			ret scalar coef = _b[`evx']
			_predict `hat' if `touse'
			`vv' ///
			regress `lhs' `x' `rhs' `wgt' if `touse',	///
				`robust' `cluster'
			ret scalar se = _se[`x']
		}
		local rc=_rc
	}
	else {				/* originally in	*/
		drop `resid'
		if _b[`v']==0 { 
			di in gr "(`v' was dropped from model)"
			exit 399
		}
		estimate hold `lest'
		capture { 
			if `isvar' {
				local RHS : list rhs - v
			}
			else	local RHS : copy local rhs
			if `fvops' {
				fvrevar `RHS'
				local RHS `"`r(varlist)'"'
				local RHS : list RHS - x
			}
			`vv' ///
			regress `lhs' `RHS' `wgt' if `touse',	///
				`robust' `cluster'
			_predict double `resid' if `touse', resid
			`vv' ///
			regress `x' `RHS' `wgt' if `touse',	///
				`robust' `cluster'
			_predict double `evx' if `touse', resid
			`vv' ///
			regress `resid' `evx' `wgt' if `touse',	///
				`robust' `cluster'
			ret scalar coef = _b[`evx']
			local seevx=_se[`evx']
			_predict double `hat' if `touse'
			`vv' ///
			regress `lhs' `rhs' `wgt' if `touse',	///
				`robust' `cluster'
			ret scalar se = _se[`v']
		}
		local rc=_rc
	}
	estimate unhold `lest'
	if `rc' {
		error `rc'
	}

	/* double save in S_# */
	global S_1 = return(coef)
	global S_2 = return(se)

	version 2.1
	local t = round(return(coef)/return(se),.01)
	local coef=return(coef)
	local se=return(se)
	version 6

	if "`robust'"=="robust" {
		local note "coef = `coef', (robust) se = `se', t = `t'" 
	}
	else {
		local note "coef = `coef', se = `se', t = `t'" 
	}
	label var `resid' "e( `lhs' | X )"
	local yttl : var label `resid'
	label var `evx' "e( `v' | X )"
	local xttl : var label `evx'
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	sort `evx', stable
	version 8: graph twoway		///
	(scatter `resid' `evx'		///
		if `touse',		///
		ytitle(`"`yttl'"')	///
		xtitle(`"`xttl'"')	///
		note(`"`note'"')	///
		`legend'		///
		`options'		///
	)				///
	(line `hat' `evx',		///
		lstyle(refline)		///
		`rlopts'		///
	)				///
	|| `plot' || `addplot'		///
	// blank
end
