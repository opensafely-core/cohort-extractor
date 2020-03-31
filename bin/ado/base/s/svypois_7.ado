*! version 2.0.2  29sep2004
program define svypois_7
	version 6, missing

	args flag query

	if "`flag'"!="0" {
		svy_est_7 svypois_7 `0'
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

	/* When here, poisson has just been called. */

		exit
	}
	if "`query'"=="footnote" { /* do nothing */
		exit
	}

	di in red "0 invalid name"
	exit 198
end

program define Syntax, sclass
	sret clear
	sret local title    "Survey Poisson regression"
	sret local cmd      "poisson"
	sret local k_depvar "1"
	sret local dopts    "IRr"  /* special display option */
	sret local okopts   "OFFset(varname numeric) EXPosure(varname numeric)"
				   /* additional allowed options */
	sret local mlopts   "yes"  /* ml options are allowed */
end

program define HowMany, rclass
	ret scalar k_scores = 1 /* one score index */
	ret scalar cmdcando = 1 /* poisson can compute it */
end

program define Save, eclass
	est local predict "poisso_p"
	exit
end
