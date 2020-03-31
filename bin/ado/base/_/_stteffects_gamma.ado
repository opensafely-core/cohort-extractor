*! version 1.0.0  30jan2015

program define _stteffects_gamma, eclass
	version 14.0
	syntax, touse(varname) vars(string) [ ancillary(string) ///
		wtype(string) wvar(varname) VERBose noconstant  ///
		noancconst * ]
	
	if "`verbose'" != "" {
		local cap cap noi
	}
	else local cap cap

	if `"`ancillary'"'=="" & "`ancconst'"!="" {
		/* programmer error					*/
		di as error "{p}there are no covariates or constant term " ///
		 "to model the gamma shape parameter{p_end}"
		exit 198
	}
	/* assumption stset						*/
	/* survival time variable					*/
	local y : char _dta[st_t]
	/* failure event variable					*/
	local f : char _dta[st_d]

	if "`wtype'" != "" {
		local wts [`wtype'=`wvar']
	}
	
	`cap' regress `y' `vars' `wts' if `touse' & `f', `constant'
	tempname b
	mat `b' = e(b)
	local vlist : colfullnames `b'
	local k = 0
	while `"`vlist'"' != "" {
		gettoken exp vlist : vlist, bind

		local exp _t:`exp'
		local bi = `b'[1,`++k']

		local from `"`from' `exp'=`bi'"'
		local stripe `"`stripe' `exp'"'
	}
	local mlopts `options'
	local mlcons `constant'
	if "`ancconst'" != "" {
		local 0 `ancillary'
		syntax [varlist(fv numeric default=none)], [ noconstant ]

		local ancillary `varlist', noconstant
	}
	ml model lf2 _stteffects_ml_gamma               ///
		(_t: `y' = `vars', `mlcons')            ///
		(lnshape:`ancillary') `wts' if `touse', ///
		maximize from(`from') `mlopts'

	local rc = c(rc)
	if (`rc') exit `rc'

	if "`verbose'" != "" {
		ml display
	}
		
	local rank = e(rank)
	local N = e(N) 
	local k0 = e(k)
	local k_eq = e(k_eq)
	local ll = e(ll)
	local df_m = e(df_m) 
	local conv = e(converged)

	tempname b V

	mat `b' = e(b)
	mat `V' = e(V)

	if "`e(V_modelbased)'" != "" {
		tempname V0
		mat `V0' = e(V_modelbased)
	}

	tempvar tu
	gen byte `tu' = `touse'
	ereturn post `b' `V', esample(`tu')

	ereturn local covariates `"`stripe'"'
	ereturn local predict _stteffects_gamma_p
	ereturn local cmd _stteffects_gamma
	ereturn local estat_cmd
	ereturn hidden local marginsprop `e(marginsprop)' nochainrule
	ereturn local marginsnotok
	if ("`V0'"!="") ereturn matrix V_modelbased = `V0'

	if "`wtype'" != "" {
		ereturn local wtype `wtype'
		ereturn local wexp `"=`wvar'"'
	}
	ereturn scalar rank = `rank'
	ereturn scalar N = `N' 
	ereturn scalar k = `k0'
	ereturn scalar k_eq = `k_eq'
	ereturn scalar ll = `ll'
	ereturn scalar df_m = `df_m'
	ereturn scalar converged = `conv'

	ereturn local dead _d
end

exit
