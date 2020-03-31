*! version 1.0.1  27oct2016
program _spivreg_init_coef
	version 15.0
	syntax , b_exog(string)		///
		lambdas(string)		///
		rhos(string)		
					// _spivreg_init_coef : reconstruct a
					// coefficient matrix b and lambdas .
					// For example, b_exog = (X ,_cons,  WX)
					// lambdas = (l1, l2) corresponding (W1,
					// W2)
	tempname b
	mata : invorder_b("`b'")
	_ms_eq_info, matrix(`b')
	local eq_k = r(k_eq)
	forvalues i=1/`eq_k' {
		local eq_name `r(eq`i')'	
		if (ustrregexm(`"`eq_name'"', "endog")) {
			matrix `lambdas' = 	///
				(nullmat(`lambdas'), `b'[1, `"`eq_name':"'])
		}
		else if (ustrregexm(`"`eq_name'"', "rho")) {
			matrix `rhos' = 	///
				(nullmat(`rhos'), `b'[1, `"`eq_name':"'])
		}
	}

	local indeps `e(indeps)'
	foreach var of local indeps {
		if (!(ustrregexm(`"`var'"', "endog") |		///
			ustrregexm(`"`var'"', "rho")) )  {
			matrix `b_exog' = 	///
				(nullmat(`b_exog'), `b'[1, `"`var'"'])
		}
	}

	cap qui confirm matrix `lambdas'
	if _rc matrix `lambdas'	= 0

	cap qui confirm matrix `rhos'
	if _rc matrix `rhos' = 0
end

mata :
void invorder_b(string scalar bs)
{
	real matrix p, b
	string matrix lb
	p	= st_matrix("e(perm)")
	lb	= st_matrixcolstripe("e(b_orig)")
	b	= st_matrix("e(b)")
	b	= b[1, invorder(p)]
	st_matrix(bs, b)
	st_matrixcolstripe(bs, lb)
}
end
