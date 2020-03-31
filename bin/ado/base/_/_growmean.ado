*! version 1.0.0  04oct2004
program define _growmean
	version 6, missing
	gettoken type 0 : 0
	gettoken h    0 : 0 
	gettoken eqs  0 : 0

	syntax varlist(min=1) [if] [in] [, BY(string)]
	if `"`by'"' != "" {
		_egennoby rowmean() `"`by'"'
		/* NOTREACHED */
	}


	tempvar NOBS touse g
	mark `touse' `if' `in'
	quietly { 
		gen double `g' = 0 if `touse'
		gen long `NOBS' = 0 if `touse'
		tokenize `varlist'
		while "`1'"!="" {
			replace `g' = `g' + cond(`1'>=.,0,`1') if `touse'
			replace `NOBS' = `NOBS' + (`1'<.) if `touse'
			mac shift 
		}
		gen `type' `h' = `g'/`NOBS' if `touse'
	}
end
