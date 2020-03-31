*! version 3.0.1  29sep2004
program define svyologit
	version 8, missing

	args flag query doit score

	if "`flag'"!="0" {
		if _caller() < 8 {
			svy_est_7 svyologit `0'
		}
		else {
			svy_est svyologit `0'
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
		if "$S_VYindv"=="" { /* no first equation */
			drop `score'
		}
		matrix $S_VYtmp1 = e(cat) /* save category matrix */
		Relabel /* relabel b and V with equation names */
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
	sret local title    "Survey ordered logistic regression"
	sret local cmd      "ologit"
	sret local k_depvar "1"
	sret local okopts   "OFFset(varname numeric)"
				   /* additional allowed options */
	sret local mlopts   "yes"
end

program define HowMany, rclass
	qui tab $S_VYdepv if $S_VYsub
	global S_VYncat = r(r)     /* # of categories */
	ret scalar k_scores = r(r) /* # of score indexes */
	ret scalar cmdcando = 1    /* ologit can compute them */
end

program define Save, eclass
	eret local predict "ologit_p"
	eret scalar k_cat = $S_VYncat    /* # of categories */
	eret scalar k_aux = e(k_cat) - 1 /* # of auxiliary parameters */
	eret scalar k_eq  = e(k_aux) + (e(df_m)!=0)
					/* # of equations */
	eret matrix cat $S_VYtmp1        /* categories */

	capture matrix list e(V_msp)
	if _rc == 0 {
		tempname V Vmsp
		matrix `V' = e(V)
		matrix `Vmsp' = e(V_msp)
		_cpmatnm `V', square(`Vmsp' S_E_Vmsp)
		eret matrix V_msp `Vmsp'
	}

/* Double save. */

	global S_E_ncat = e(k_cat)
end

program define Relabel /* relabel `b' and `V' */
	tempname cuts

	local dim = colsof($S_VYb)
	local cut1 = colnumb($S_VYb,"_cut1")
	matrix `cuts' = $S_VYb[1,`cut1'...]
	local ncut = colsof(`cuts')
	local mdf = `dim' - `ncut'

	local i 1
	while `i' <= `ncut' {
		local names "`names' cut`i'"
		local i = `i' + 1
	}

	matrix coleq    `cuts' = `names'
	matrix colnames `cuts' = _cons

	if `mdf' > 0 {
		matrix $S_VYb = $S_VYb[1,1..`mdf']
		matrix coleq $S_VYb = $S_VYdepv
		matrix $S_VYb = $S_VYb , `cuts'
	}
	else	matrix $S_VYb = `cuts'

	local names : colnames($S_VYb)
	matrix colnames $S_VYV = `names'
	matrix rownames $S_VYV = `names'
	local names : coleq($S_VYb)
	matrix coleq $S_VYV = `names'
	matrix roweq $S_VYV = `names'
end
