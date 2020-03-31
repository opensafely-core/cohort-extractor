*! version 2.0.2  29sep2004
program define svyintreg_7
	version 6, missing

	args flag query

	if "`flag'"!="0" {
		svy_est svyintreg `0'
		exit
	}
	if "`query'"=="syntax" {
		Syntax
		exit
	}
	if "`query'"=="how_many_scores" {
		HowMany
		exit
	}
	if "`query'"=="save" {
		Save
		exit
	}
	if "`query'"=="scores" {

	/* Save results from intreg. */

		global S_VYNunc = e(N_unc)
		global S_VYNlc  = e(N_lc)
		global S_VYNrc  = e(N_rc)
		global S_VYNint = e(N_int)
		exit
	}
	if "`query'"=="footnote" {
		Footnote
		exit
	}

	di in red "0 invalid name"
	exit 198
end

program define Syntax, sclass
	sret clear
	sret local title    "Survey interval regression"
	sret local cmd      "intreg"
	sret local k_depvar "2"
	sret local okopts   "OFFset(varname numeric)"
				  /* additional allowed options */
	sret local mlopts   "yes" /* ml options are allowed */
end

program define HowMany, rclass
	ret scalar k_scores = 2 /* two score indexes */
	ret scalar cmdcando = 1 /* intreg can compute them */
end

program define Save, eclass
	tempname b V
	mat `b' = e(b)
	mat `V' = e(V)
	local dim = colsof(`b')
	est scalar sigma = `b'[1,`dim']
	est scalar se_sigma = sqrt(`V'[`dim',`dim'])
	est scalar k_aux = 1 /* # of auxiliary parameters */
	est scalar k_eq  = 2 /* # of equations */
	est scalar N_unc = $S_VYNunc
	est scalar N_lc  = $S_VYNlc
	est scalar N_rc  = $S_VYNrc
	est scalar N_int = $S_VYNint
	est local predict "tobit_p"
end

program define Footnote
	di _n in gr "Obs. summary: " /*
	*/ _col(16) in ye %9.0g e(N_unc) /*
	*/ in gr " uncensored observations" _n /*
	*/ _col(16) in ye %9.0g e(N_lc) /*
	*/ in gr " left-censored observations" _n /*
	*/ _col(16) in ye %9.0g e(N_rc) /*
	*/ in gr " right-censored observations" _n /*
	*/ _col(16) in ye %9.0g e(N_int) /*
	*/ in gr " interval observations" _n
end
