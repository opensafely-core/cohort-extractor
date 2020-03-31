*! version 1.0.0  28jan2015

program define _stteffects_gamma_moments
	version 14.0
	syntax varlist(numeric) [if], xb(varname) zg(varname) ti(varname) ///
		to(varname) do(varname) [ bt(name) pomeans ate atet cot   ///
		tr(varname) deriv(varlist) ]

	gettoken e varlist : varlist
	gettoken s varlist : varlist
	gettoken sa varlist : varlist
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

	tempvar a lbd y dgdx dgda S dga_dgx alyda

	qui gen double `a' = exp(-2*`zg') `if' 
	qui gen double `lbd' = exp(`xb') `if'
	qui gen double `y' = `a'*`to'/`lbd' `if'

	qui gen double `dgdx' = dgammapdx(`a',`y') `if'
	qui gen double `dgda' = dgammapda(`a',`y') `if'
	qui gen double `S' = gammaptail(`a',`y') `if'
	qui gen double `dga_dgx' = `a'*`dgda' + `y'*`dgdx' `if'
	qui gen double `alyda' = `a'*(log(`y')-digamma(`a')+1) `if'

	qui replace `s' = cond(`ti',cond(`do',`y'-`a',`y'*`dgdx'/`S'),0) `if'
	qui replace `sa' = cond(`ti',2*cond(`do',`y'-`alyda',`dga_dgx'/`S'), ///
			0) `if'
	if `bderiv' {
		tempvar dgdxx dgdax
		/* dgammapdxdx returns missing for small y		*/
		qui gen `dgdxx' = cond(`y'>1e-10,dgammapdxdx(`a',`y'),0) `if'
		qui gen `dgdax' = dgammapdadx(`a',`y') `if'

		qui replace `dsxb' = cond(`ti',cond(`do',-`y',-`s'*(1+`s') - ///
			`y'^2*`dgdxx'/`S'),0) `if'

		qui replace `daxb' = cond(`ti',2*cond(`do',`a'-`y', ///
			-`y'*((`a'*`dgdax'+`dgdx'+`y'*`dgdxx')+     ///
			`dgdx'*`dga_dgx'/`S')/`S'),0) `if'

		qui replace `dazg' = cond(`ti',4*cond(`do',-`y'+`alyda'- ///
			`a'*(`a'*trigamma(`a')-1),                       ///
			(-`dga_dgx'-`a'*(`a'*dgammapdada(`a',`y')+       ///
			`y'*`dgdax')-`y'*(`y'*`dgdxx'+`a'*`dgdax')-      ///
			`dga_dgx'^2/`S')/`S'),0) `if'

		qui replace `dszg' = cond(`ti',cond(`do',2*(`a'-`y'), ///
			-2*`y'*(`dgdx'+`y'*`dgdxx'+`a'*`dgdax'+       ///
			`dgdx'*`dga_dgx'/`S')/`S'),0) `if'
	}
	if "`stat'" == "" {
		/* censoring weights; do = censor indicator		*/
		qui replace `e' = gammaptail(`a',`y') `if'
		if `bderiv' {
			qui replace `dexb' = dgammapdx(`a',`y')*`y' `if'
			qui replace `dezg' = 2*(`a'*dgammapda(`a',`y') + ///
				`y'*dgammapdx(`a',`y')) `if'
		}
	}
	else if "`stat'" == "atet" {
		qui replace `e' = cond(`tr',`lbd'-scalar(`bt'),0) `if'
		if `bderiv' {
			qui replace `debt' = cond(`tr',-1,0) `if'
			qui replace `dexb' = cond(`tr',`lbd',0) `if'
			qui replace `dezg' = 0 `if'
		}
	}
	else { // POmeans, ATE, or COT
		qui replace `e' = `lbd' - scalar(`bt') `if'
		if `bderiv' {
			qui replace `debt' = -1 `if'
			qui replace `dexb' = `lbd' `if'
			qui replace `dezg' = 0 `if'
		}
	}
end

exit

xb  	= X'b, lambda = exp(xb), scale = alpha/lambda
zg	= Z'g, alpha = exp(-2*zg), shape
ti	= treatment i indicator
to	= failure time
do	= failure indicator
bt	= treatment i pomean or treatment effect
tr	= treated indicator (ATET only)
