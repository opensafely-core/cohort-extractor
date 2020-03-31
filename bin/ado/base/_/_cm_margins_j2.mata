*! version 1.0.0  09sep2019

mata:

mata set matastrict on

void _cm_margins_j2(string scalar objkey, string scalar wgts, 
		string scalar options, string scalar sb, string scalar sj2,
		string scalar sdx)
{
	real scalar rc
	real rowvector b, dx
	string matrix stripe, dxstripe
	transmorphic scalar D

	b = st_matrix(sb)
	stripe = st_matrixcolstripe(sb)
	dx = st_matrix(sdx)
	dxstripe = st_matrixcolstripe(sdx)

	D = deriv_init()
	deriv_init_evaluator(D, &__cm_margins_eval())
	deriv_init_evaluatortype(D, "t")
	deriv_init_params(D,b)
	deriv_init_argument(D,1,objkey)
	deriv_init_argument(D,2,wgts)
	deriv_init_argument(D,3,stripe)
	deriv_init_argument(D,4,options)
	deriv_init_argument(D,5,dx)
	deriv_init_argument(D,6,dxstripe)

	rc = _deriv(D,1)
	if (rc) {
		exit(deriv_result_returncode(D))
	}
	st_matrix(sj2,deriv_result_Jacobian(D))
}

void __cm_margins_eval(real rowvector b, string scalar objkey, 
		string scalar wgts, string matrix stripe, string scalar options,
		real rowvector dx, string matrix dxstripe, real vector pm)
{
	real scalar rc
	string scalar tb, tdx, cmd

	tb = st_tempname()
	st_matrix(tb,b)
	st_matrixcolstripe(tb,stripe)
	tdx = st_tempname()
	st_matrix(tdx,dx)
	st_matrixcolstripe(tdx,dxstripe)

	cmd = sprintf("_cm_margins_j2 %s %s, b(%s) dx(%s) %s",objkey,wgts,
			tb,tdx,options)
	rc = _stata(cmd)

	if (rc) {
		exit(rc)
	}
	pm = st_numscalar("r(b)")
}

end
exit
