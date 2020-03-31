*! version 3.0.1  29sep2004
program define svyregress
	version 8, missing

	args flag query doit score

	if "`flag'"!="0" {
		if _caller() < 8 {
			svy_est_7 svyreg `0'
		}
		else {
			svy_est svyreg `0'
		}
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

	/* Save R^2. */

		global S_VYr2 `e(r2)'

	/* Compute score. */

		qui _predict double `score' if $S_VYsub, residual
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
	sret local title    "Survey linear regression"
	sret local cmd      "regress"
	sret local k_depvar "1"
end

program define HowMany, rclass
	ret scalar k_scores = 1 /* one score index */
	ret scalar cmdcando = 0 /* regress cannot compute it */
end

program define Save, eclass
	eret scalar r2 = $S_VYr2
	eret local predict "svyreg_p"
	global S_E_r2 = e(r2) /* double save */
end
