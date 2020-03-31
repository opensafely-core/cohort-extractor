*! version 1.2.0  19feb2019  
program define frac_pv, rclass /* P-value calculation */
	version 8
	* 1=normal (1=yes), 2=weight type, 3=nobs, 4=d (deviance),
	* 5=n1 (df for numerator), 6=n2 (df for denominator).
	* Returns P-value in r(P).

	args normal e nobs d n1 n2

	if (`normal' & bsubstr("`e'",2,2)=="iw") | !`normal' {
		return scalar P = chiprob(`n1',`d')
	}
	else 	return scalar P = fprob(`n1',`n2',(expm1(`d'/`nobs'))*`n2'/`n1')
end
