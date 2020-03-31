*! version 1.0.0  10jan2015

program define _stteffects_lnormal_moments
	version 14.0
	syntax varlist(numeric) [if], xb(varname) zg(varname) ti(varname) ///
		to(varname) do(varname) [ bt(name) pomeans ate atet cot   ///
		tr(varname) deriv(varlist) ]

	gettoken e varlist : varlist
	gettoken s varlist : varlist
	gettoken a varlist : varlist
	local bderiv = ("`deriv'"!="")
	local stat `pomeans'`ate'`atet'`cot'
	if `bderiv' {
		gettoken debt deriv : deriv
		gettoken dexb deriv : deriv
		gettoken dezg deriv : deriv
		gettoken dsxb deriv : deriv
		gettoken dszg deriv : deriv
		gettoken daxb deriv : deriv
		gettoken dazg deriv : deriv
	}

	tempvar sig sig2 ex lt z nz sz

	local mu `xb'
	qui gen double `sig' = exp(`zg') `if'
	qui gen double `sig2' = `sig'^2 `if'
	qui gen double `lt' = log(`to') `if'
	qui gen double `z' = (`lt'-`mu')/`sig' `if'
	qui gen double `nz' = normalden(`z') `if'
	qui gen double `sz' = 1-normal(`z') `if'

	qui replace `s' = cond(`ti',cond(`do',`z'/`sig',`nz'/(`sig'*`sz')), ///
			0) `if'

	qui replace `a' = cond(`ti',cond(`do',`z'*`z'-1,`z'*`nz'/`sz'),0) `if'
	if `bderiv' {
		qui replace `dsxb' = cond(`ti',cond(`do',-1/`sig2', ///
			`s'*(`z'/`sig'-`s')),0) `if'
		qui replace `dszg' = cond(`ti',cond(`do',-2*`s', ///
			`s'*(`z'*(`z'-`nz'/`sz')-1)),0) `if'
		qui replace `dazg' = cond(`ti',cond(`do',-2*`z'*`z', ///
			`a'*(`z'*`z'-`a'-1)),0) `if'
		qui replace `daxb' = cond(`ti',cond(`do',-2*`z'/`sig', ///
			`nz'/(`sig'*`sz')*(`z'*(`z'-`nz'/`sz')-1)),0) `if'
	}
	if "`stat'" == "" {
		/* censoring weights; do = censor indicator		*/
		qui replace `e' = `sz' `if'
		if `bderiv' {
			qui replace `dexb' = `nz'/`sig' `if'
			qui replace `dezg' = `nz'*`z' `if'
		}
		exit
	}
	qui gen double `ex' = exp(`mu'+`sig2'/2) `if'
	if "`stat'" == "atet" {
		qui replace `e' = cond(`tr',`ex'-scalar(`bt'),0) `if'
		if `bderiv' {
			qui replace `debt' = cond(`tr',-1,0) `if'
			qui replace `dexb' = cond(`tr',`ex',0) `if'
			qui replace `dezg' = cond(`tr',`sig2'*`ex',0) `if'
		}
	}
	else {  // POmeans, ATE, or COT
		qui replace `e' = `ex' - scalar(`bt') `if'
		if `bderiv' {
			qui replace `debt' = -1 `if'
			qui replace `dexb' = `ex' `if'
			qui replace `dezg' = `sig2'*`ex' `if'
		}
	}
end

exit
