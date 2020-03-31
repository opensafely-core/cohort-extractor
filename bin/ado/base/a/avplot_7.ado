*! version 3.2.1  28aug2000
program define avplot_7, rclass
	version 6
	_isfit cons
	syntax varname [, Symbol(string) T1title(string) L1title(string) *]
	local v `varlist'
	local wgt "[`e(wtype)' `e(wexp)']"
	tempvar touse resid lest evx hat

			/* determine if v in original varlist	*/
	if "`e(depvar)'"=="`1'" { 
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
		qui regress `lhs' `rhs' if `touse', `robust'
		local ddof= e(df_r)
		estimates unhold `myest'
	}
	else {
		local ddof= e(df_r)
	}
	tokenize `rhs'
	local i 1
	while "``i''"!="" & "`inorig'"=="" { 
		if "``i''"=="`v'" { 
			local inorig "true"
			local `i' " "		/* zap it */
		}
		local i=`i'+1
	}
	quietly {
		_predict `resid' if `touse', resid
/* local ddof= e(df_r) */
	}
	if "`inorig'"=="" { 		/* not originally in	*/
		capture assert `v'!=. if `touse'
		if _rc { 
			di in red "`v' has missing values" _n /*
		*/ "you must reestimate including `v'"
			exit 398
		}
		estimate hold `lest'
		capture { 
			regress `v' `rhs' `wgt' if `touse', `robust' `cluster'
			_predict `evx' if `touse', resid
			regress `resid' `evx' `wgt' if `touse', `robust' `cluster'
			ret scalar coef = _b[`evx']
			_predict `hat' if `touse'
			reg `lhs' `v' `rhs' `wgt' if `touse', `robust' `cluster'
			ret scalar se = _se[`v']
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
			regress `lhs' `*' `wgt' if `touse', `robust' `cluster'
			_predict double `resid' if `touse', resid
			regress `v' `*' `wgt' if `touse', `robust' `cluster'
			_predict double `evx' if `touse', resid
			regress `resid' `evx' `wgt' if `touse', `robust' `cluster'
			ret scalar coef = _b[`evx']
			local seevx=_se[`evx']
			_predict double `hat' if `touse'
			regress `lhs' `rhs' `wgt' if `touse', `robust' `cluster'
			ret scalar se = _se[`v']
		}
		local rc=_rc
	}
	estimate unhold `lest'
	if `rc' { error `rc' }

	/* double save in S_# */
	global S_1 = return(coef)
	global S_2 = return(se)

	version 2.1
	local t = round(return(coef)/return(se),.01)
	local coef=return(coef)
	local se=return(se)
	version 6

	label var `evx' "e( `v' | X )"
	if "`symbol'"=="" { local symbol "s(Oi)" } 
	else local symbol "s(`symbol'i)"
	if "`t1title'"=="" {
		if "`robust'"=="robust" {
			local t1title "coef = `coef', (robust) se = `se', t = `t'" 
		}
		else {
			local t1title "coef = `coef', se = `se', t = `t'" 
		}
	}
	if "`l1title'"=="" { 
		local l1title "e( `lhs' | X)"
	}
	gr7 `resid' `hat' `evx', `symbol' c(.l) /*
		*/ t1("`t1title'") l1("`l1title'") sort `options'
end
