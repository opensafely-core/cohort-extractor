*! version 1.0.1  03may2007
program glmixed_ll
	version 10
	args todo b lnf

	tempname theta beta

	mat `beta' = `b'[1, 1..`=${ML_k1}']
	mat `theta' = `b'[1, `=${ML_k1}+1'...]

	mata: _xtgm_estimate_re_st(`"`beta'"', `"`theta'"')
	if `r(re_rc)' {				// error
		scalar `lnf' = .
	}
	mata: _xtgm_glmixed_ll_st(`"`beta'"', `"`theta'"')
	scalar `lnf' = r(ll)
end

