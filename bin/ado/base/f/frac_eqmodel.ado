*! version 1.0.0  19nov2009
/*
        -frac_eqmodel <mac>- returns the number of equations for the
        model test in <mac>.  It returns e(k_eq_model) or 1, if e(k_eq_model)
        is missing or 0.

	Note: -glm- does not report the model test and sets e(k_eq_model)=0;
              -qreg-, -regress-, -rreg-, -stcox-, and -xtgee- do not save
              e(k_eq_model).

*/
program frac_eqmodel
	version 11
	args k
	local neq = e(k_eq_model)
	if (mi(`neq') | `neq'==0) local neq = 1
	if ("`e(cmd)'"=="mlogit") local neq=`neq'-1 
	c_local `k' `neq'
end
