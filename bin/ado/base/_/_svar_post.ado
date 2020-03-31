*! version 1.0.0  16sep2002
program define _svar_post, eclass
	version 8.0

	tempname bsvar vsvar 

	mat `bsvar' = e(b_var)
	mat `vsvar' = e(V_var)
	local dfr   = e(df_r_var)

	eret post `bsvar' `vsvar'
	
	if "`dfr'" != "" {
		ereturn scalar df_r = `dfr'
	}	
end		

exit 

_svar_post post is a helper routine for VAR/SVAR programs.
This program gets the coef and VCE information, and df_r
from svar estimates and makes them the active results so that test will work
on the underlying VAR estimates


