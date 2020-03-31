*! version 3.0.6  23jan2015
program define svymlogit
	version 8, missing

	args flag query

	if "`flag'"!="0" {
		if _caller() < 8 {
			svy_est_7 svymlogit `0'
		}
		else {
			svy_est svymlogit `0'
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

	/* Save results from mlogit. */

	       	global S_VYibas  = e(ibasecat)
		global S_VYeqnames `"`e(eqnames)'"'
		scalar $S_VYtmp1 = e(basecat)
		matrix $S_VYtmp2 = e(cat)
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
	sret local title    "Survey multinomial logistic regression"
	sret local cmd      "mlogit"
	sret local k_depvar "1"
	sret local dopts    "RRr"  /* special display option */
	sret local okopts   "Basecategory(passthru) Constraints(passthru)"
				   /* additional allowed options */
	sret local mlopts   "yes"  /* ml options are allowed */
end

program define HowMany, rclass
	qui tab $S_VYdepv if $S_VYsub
	global S_VYncat = r(r)         /* # of categories */
	ret scalar k_scores = r(r) - 1 /* # of score indexes */
	ret scalar cmdcando = 1        /* mlogit can compute them */
end

program define Save, eclass
	eret local predict "mlogit_p"
	eret scalar k_cat    = $S_VYncat  /* # of categories */
	eret scalar k_eq     = e(k_cat)-1 /* # of equations */
	eret scalar basecat  = $S_VYtmp1  /* base category */
	eret scalar ibasecat = $S_VYibas  /* base category number */
	eret local baselab : label ($S_VYdepv) `e(basecat)'
					 /* base category label */
	eret local eqnames `"$S_VYeqnames"'

/* Label coleq of matrix of categories with equation names. */

	tempname b b1 b2
	mat `b' = e(b)
	local eqlen = colsof(`b')/e(k_eq)
	local i 1
	while `i' <= e(k_cat) {
		if `i' != e(ibasecat) {
*			local j = `eqlen'*(`i'-1)+1
			local j = (`i'-cond(`i'<e(ibasecat),1,2))*`eqlen'+1
			mat `b1' = nullmat(`b1') , `b'[1,`j'..`j']
		}
		else {
			mat `b2' = 0
			local temp = ustrtrim(usubstr(`"`e(baselab)'"',1,c(namelenchar)))			
			capture mat coleq `b2' = `"`temp'"'
			if _rc {
				mat coleq `b2' = `i'
			}
			mat `b1' = nullmat(`b1') , `b2'
		}
		mat `b1'[1,`i'] = $S_VYtmp2[1,`i']
		local cn = `"`cn' c`i'"'
		local i = `i' + 1
	}

	mat colnames `b1' = `cn'
	mat $S_VYtmp2 = `b1'
	eret matrix cat $S_VYtmp2 /* matrix of categories */

/* Double saves. */

	global S_E_ncat = e(k_cat)
	global S_E_base = e(basecat)
end

program define Footnote
	local base = ustrtrim(usubstr(`"`e(baselab)'"',1,c(namelenchar)))	
	di in blu `"(Outcome `e(depvar)'==`base' is the "' /*
	*/ "comparison group)"

	if "`e(fpc)'"!="" {
		di /* newline */
	}
end

