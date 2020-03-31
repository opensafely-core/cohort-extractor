*! version 1.0.0  22jan2009
program stcrr_lf
	version 11
	args todo b lnf g H

	mata: _stcrr_lf_st("`b'")
	scalar `lnf' = r(ll)
	matrix   `g' = r(grad)
	matrix 	 `H' = r(hess)
end

