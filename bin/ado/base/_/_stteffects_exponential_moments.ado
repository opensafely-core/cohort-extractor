*! version 1.0.0  11jan2015

program define _stteffects_exponential_moments
	version 14.0
	syntax varlist(numeric) [if], xb(varname) ti(varname) to(varname) ///
		do(varname) [ bt(name) pomeans ate atet cot tr(varname)   ///
		deriv(varlist) ]

	gettoken e s : varlist
	local bderiv = ("`deriv'"!="")
	local stat `pomeans'`ate'`atet'`cot'
	if `bderiv' {
		gettoken debt deriv : deriv
		gettoken dexb deriv : deriv
		gettoken dsxb deriv : deriv
	}
	tempvar lbd

	qui gen double `lbd' = exp(-`xb') `if'  // E[to|x,b]

	qui replace `s' = cond(`ti',`lbd'*`to'-`do',0) `if'
	if `bderiv' {
		qui replace `dsxb' = cond(`ti',-`lbd'*`to',0) `if'
	}
	if "`stat'" == "" {
		/* censoring for weights, do is the censor indicator	*/
		qui replace `e' = exp(-`lbd'*`to') `if'
		if `bderiv' {
			qui replace `dexb' = `to'*`lbd'*`e' `if'
		}
	}
	else if "`atet'" != "" {
		qui replace `e' = cond(`tr',1/`lbd'-scalar(`bt'),0) `if'
		if `bderiv' {
			qui replace `dexb' = cond(`tr',1/`lbd',0) `if'
			qui replace `debt' = cond(`tr',-1,0) `if'
		}
	}
	else {	// POmeans, ATE, or COT
		qui replace `e' = 1/`lbd'-scalar(`bt') `if'
		if `bderiv' {
			qui replace `dexb' = 1/`lbd' `if'
			qui replace `debt' = -1 `if'
		}
	}
end

exit

xb  	= X'b
ti	= treatment i indicator
to	= failure time
do	= failure indicator
bt	= treatment i pomean or treatment effect
tr	= treated indicator (ATET only)
