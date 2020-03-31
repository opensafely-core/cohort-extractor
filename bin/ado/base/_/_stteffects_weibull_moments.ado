*! version 1.0.0  02feb2015

program define _stteffects_weibull_moments
	version 14.0
	syntax varlist(numeric) [if], xb(varname) zg(varname) ti(varname) ///
		to(varname) do(varname) [ bt(name) pomeans ate atet cot   ///
		tr(varname) deriv(varlist) ]

	gettoken e varlist : varlist
	gettoken s varlist : varlist
	gettoken sp varlist : varlist
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

	tempvar lbd p pp df lglt ltp mu pl

	qui gen double `p' = exp(`zg') `if' 
	qui gen double `lbd' = exp(-`xb') `if' 
	qui gen double `ltp' = cond(`ti',(`to'*`lbd')^`p',0) `if'
	qui gen double `lglt' = cond(`ti',log(`to')-`xb',0) `if' 
	qui gen double `pl' = `p'*`lglt' `if'

	qui replace `s' = cond(`ti',`p'*cond(`do',`ltp'-1,`ltp'),0) `if'
	
	qui replace `sp' = cond(`ti',cond(`do',1+`pl'*(1-`ltp'), ///
			-`pl'*`ltp'),0) `if'
	if `bderiv' {
		tempvar lpl ltp1
		qui gen double `ltp1' = cond(`ti',(`to'*`lbd')^(`p'-1),0) `if'
		qui replace `dsxb' = cond(`ti',-`p'^2*`ltp',0) `if'

		qui gen double `lpl' = `ltp'*(1+`pl') `if'
		qui replace `dszg' = cond(`ti',`p'*cond(`do',`lpl'-1,`lpl'), ///
				0) `if'
		qui replace `dazg' = cond(`ti',cond(`do',`pl'*(1-`lpl'), ///
				-`pl'*`lpl'),0) `if'
		qui replace `daxb' = `dszg' `if'
	}
	if "`stat'" == "" {
		/* censoring weights; do = censor indicator		*/
		qui replace `e' = exp(-`ltp') `if'
		if `bderiv' {
			qui replace `dexb' = `p'*`ltp'*`e' `if'
			qui replace `dezg' = -`dexb'*`lglt' `if'
		}
		exit
	}
	qui gen double `pp' = (`p'+1)/`p' `if'
	qui gen double `mu' = exp(lngamma(`pp'))/`lbd' `if'
	if "`stat'" == "atet" {
		qui replace `e' = cond(`tr',`mu'-scalar(`bt'),0) `if'
		if `bderiv' {
			qui replace `debt' = cond(`tr',-1,0) `if'
			qui replace `dexb' = cond(`tr',`mu',0) `if'
			qui replace `dezg' = cond(`tr', ///
				-`mu'*digamma(`pp')/`p',0) `if'
		}
	}
	else {  // POmeans, ATE, or COT
		qui replace `e' = `mu' - scalar(`bt') `if'
		if `bderiv' {
			qui replace `debt' = -1 `if'
			qui replace `dexb' = `mu' `if'
			qui replace `dezg' = -`mu'*digamma(`pp')/`p' `if'
		}
	}
end

exit

