*! version 1.0.1  03may2007
program glmixed_b0r
	version 10
	args b 

	tempname theta beta

	mat `beta'  = `b'[1, 1..`=${ML_k1}']
	mat `theta' = `b'[1, `=${ML_k1}+1'...]

	mata:   _xtgm_update_b0_st("`beta'", "`theta'")
	if `r(b0_rc)' {				// error
		scalar $ML_f = . 
	}
	mata:  _xtgm_glmixed_ll_st("`beta'", "`theta'") 

	scalar $ML_f = r(ll)
end
