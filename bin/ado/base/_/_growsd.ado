*! version 1.0.0  04oct2004
program define _growsd
	version 6, missing
	gettoken type 0: 0
	gettoken h    0: 0
	gettoken eqs  0: 0		/* discard = sign */

	syntax varlist(min=2) [if] [in] [, BY(string)]
	if `"`by'"' != "" {
		_egennoby rowsd() `"`by'"'
		/* NOTREACHED */
	}


	tempvar NOBS MU touse g
	mark `touse' `if' `in'
	quietly { 
		gen double `g' = 0 if `touse'
		gen double `MU' = 0 if `touse'
		gen long `NOBS' = 0 if `touse'
		tokenize `varlist'
		local i 1
		while "``i''"!="" {
			replace `MU' = `MU' + cond(``i''>=.,0,``i'') if `touse'
			replace `NOBS' = `NOBS' + (``i''<.) if `touse'
			local i = `i' + 1
		}
		replace `MU' = `MU' / `NOBS' if `touse'
		local i 1
		while "``i''" != "" { 
			replace `g'=`g'+cond(``i''>=.,0,``i''-`MU')^2 `if' `in'
			local i = `i' + 1
		}
		drop `MU'
		gen `type' `h' = /*
			*/ cond(`NOBS'==0,.,sqrt(`g'/(`NOBS'-1))) if `touse'
	}
end
