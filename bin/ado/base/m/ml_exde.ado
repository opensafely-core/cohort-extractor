*! version 1.2.1  02feb2012
program define ml_exde
	version 7
	if `1'==0 { /* call d0 method and exit */
		ml_e0 `1' `2'
		exit
	}

/* Call d0 method with 2 (or 1), then call $ML_user with (or 1). */

	tempname b f g H
	mat `b' = $ML_b

	ml_e0 `1' `2' /* call d0 method */

	$ML_vers $ML_user `1' `b' `f' `g' `H' $ML_sclst
	ml_count_eval `f' `2'

/* Display beginning message. */

	if $ML_trace {
		if $ML_trace == 1 { di }
		di as txt /*
		*/ "$ML_meth:  Begin derivative-comparison report " /*
		*/ "{hline 33}"
	}

/* Check if coefficient vector damaged. */

	if mreldif(matrix($ML_b),`b') != 0 {
		di as txt "$ML_meth:  " as txt /*
		*/ "Warning: " as res "$ML_user" as txt /*
		*/ " damaged coefficient vector" _n(2) as txt  /*
		*/ "$ML_meth:  Coefficient vector was"
		mat list $ML_b, noheader format(%9.0g)
		di _n as txt  "$ML_meth:  After call to " as res "$ML_user" /*
		*/ as txt ", it is"
		mat list `b', noheader format(%9.0g)
		di
	}

/* Check if log-likelihoods (criteria) same. */

	if `f' != scalar($ML_f) {
		di as txt "$ML_meth:  " as txt /*
		*/ "Warning: " as res "$ML_user `1'" as txt " did not return " /*
		*/ "same $ML_crtyp as " as res "$ML_user 0" _n /*
		*/ as txt  "$ML_meth:  " as res "$ML_user 0" as txt /*
		*/ " $ML_crtyp = " as res %10.0g scalar($ML_f) _n /*
		*/ as txt "$ML_meth:  " as res "$ML_user `1'" as txt /*
		*/ " $ML_crtyp = " as res %10.0g `f'
	}

/* Display note if log-likelihood == . and exit. */

	if scalar($ML_f) == . & `f' == . & $ML_trace {
		di as txt "$ML_meth:  infeasible coefficient values, " /*
		*/ "$ML_crtyp = " as res "."
		di as txt /*
		*/ "$ML_meth:  End derivative-comparison report " /*
		*/ "{hline 35}" _n
		exit
	}

/* Display gradient if $ML_dider == 1 or 3. */

	capture di `g'[1,1]
	if _rc {
		di as txt "$ML_meth:  " as txt "Warning: " as res /*
		*/ "$ML_user `1'" as txt " did not compute gradient"
	}
	else if $ML_trace {
		MRelDif $ML_g `g' "gradient vector"

		if $ML_dider == 1 | $ML_dider == 3 {
			DiDiff $ML_g `g' "gradient"
		}
	}

	if `1' != 2 | "$ML_meth" == "d1debug" {
		if $ML_trace { DiEnd }
		exit
	}

/* Display negative Hessian if $ML_dider == 2 or 3. */

	capture di `H'[1,1]
	if _rc {
		di as txt "$ML_meth:  " as txt "Warning: " as res /*
		*/ "$ML_user 2" as txt " did not compute negative Hessian"
	}
	else if $ML_trace {
		MRelDif $ML_V `H' "negative Hessian"

		if $ML_dider > 1 {
			DiDiff $ML_V `H' "negative Hessian"
		}
	}

/* Display ending message. */

	if $ML_trace { DiEnd }
end

program define MRelDif
	args Numer User name

	if matrix( rowsof(`Numer')==rowsof(`User') /*
	*/ & colsof(`Numer')==colsof(`User') ) {
		di as txt "$ML_meth:  mreldif(`name') = " /*
		*/ as res %9.0g matrix(mreldif(`User',`Numer'))
		exit
	}

	local r1 = rowsof(matrix(`Numer'))
	local r2 = rowsof(matrix(`User'))
	local c1 = colsof(matrix(`Numer'))
	local c2 = colsof(matrix(`User'))

	di as txt "$ML_meth:  " as txt "Warning: " as res /*
	*/ "$ML_user" as txt " computed " as res "`r2' x `c2'" /*
	*/ as txt " `name'" _n "$ML_meth:  " as txt "`name' should be " /*
	*/ as res "`r1' x `c1'" " matrix"
end

program define DiDiff
	args Numer User name

	if matrix( rowsof(`Numer')==rowsof(`User') /*
	*/ & colsof(`Numer')==colsof(`User') ) {
		tempname diff
		local r = rowsof(matrix(`Numer'))
		local c = colsof(matrix(`Numer'))
		mat `diff' = J(`r',`c',0)
		local i 1
		while `i' <= `r' {
			local j 1
			while `j' <= `c' {
				mat `diff'[`i',`j'] = /*
				*/ reldif(`User'[`i',`j'],`Numer'[`i',`j'])
				local j = `j' + 1
			}
			local i = `i' + 1
		}

		if "`name'"=="gradient" {
			version 11: _cpmatnm $ML_b, vec(`User' `Numer' `diff')
		}
		else	version 11: _cpmatnm $ML_b, square(`User' `Numer' `diff')
	}
	else {
		if "`name'"=="gradient" {
			version 11: _cpmatnm $ML_b, vec(`Numer')
		}
		else	version 11: _cpmatnm $ML_b, square(`Numer')
	}

	di _n as txt "$ML_meth:  " as res "$ML_user" as txt "-calculated `name':"
	mat list `User', noheader format(%9.0g) noblank

	di _n as txt "$ML_meth:  numerically calculated `name' " /*
	*/ "(used for stepping):"
	mat list `Numer', noheader format(%9.0g) noblank

	if "`diff'"!="" {
		di _n as txt "$ML_meth:  relative difference:"
		mat list `diff', noheader format(%9.0g) noblank
	}

	di /* blank line */
end

program define DiEnd
	di as txt "$ML_meth:  End derivative-comparison report " /*
	*/ "{hline 35}"
	if $ML_trace > 1 | $ML_dider { di }
end
