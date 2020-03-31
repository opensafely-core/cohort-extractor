*! version 2.0.2  26jan2012
*  (see documentation below)
program define bsampl_w /* bwt */ 
	version 6.0
	local w "`1'"
	tempvar r
	quietly {
		drop `w'
		gen double `r' = int(uniform()*_N + 1)
		gen double `w' = uniform()
		sort `r' `w'
		replace `w' = cond(`r'==`r'[_n-1], `w'[_n-1]+1, 1)
		replace `w'=0 if !(`w'[_n+1]==1 | _n==_N)
	}
end
exit

DOCUMENTATION:

	bsampl_w wvar

where wvar must be already exist but the contents of wvar are irrelevant.

Description:

-bsampl_w-  is logically equivalent to -bsample- without arguments; 
it draws a subsample of size _N from a sample of _N.  -bsampl_w-, however,
returns a weighting variable wvar and some of the weights might be zero.

-bsampl_w- is for use in bootstrapping situations where the command being
bootstrapped allows frequency weights.

Also see
--------

comments at the end of qreg_c.ado

<end>
