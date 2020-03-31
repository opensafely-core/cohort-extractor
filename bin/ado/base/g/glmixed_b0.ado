*! version 1.0.0  27apr2007
program glmixed_b0
	version 10
	args b 

	tempname theta beta

	mat `beta' = `b'[1, 1..`=${ML_k1}']
	mat `theta' = `b'[1, `=${ML_k1}+1'...]

	mata: _xtgm_update_b0_st("`beta'", "`theta'")
end

