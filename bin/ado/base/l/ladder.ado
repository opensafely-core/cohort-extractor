*! version 3.3.0  23apr2007
program define ladder, byable(recall) rclass
	version 6, missing
	syntax varname [if] [in] [, Generate(string) noAdjust ]
	if "`generat'"!="" { 
		if _by() {
			di in red /*
			*/ "option generate() may not be specified with by"
			exit 198
		}
		confirm new var `generat'
	}
	local v `varlist'

	marksample touse
	tempvar V
	quietly gen `V' = `v' if `touse'

	quietly count if `V'< .
	if r(N)<8 { 
		error 2001
	}
	tempvar bst
	#delimit ;
	di _n in smcl in gr "Transformation" _col(24) "formula"
		_col(46) "chi2(2)" _col(60) "P(chi2)" _n
		"{hline 66}" ;
	#delimit cr

	local abv = abbrev("`v'",8)
	global S_9 .	/* min, used by _crcldr */

	_crcldr `V' cubic "`abv'^3" "`V'^3" `bst' `adjust'
	return scalar P_cube = r(P_chi2)
	return scalar cube = r(chi2)

	_crcldr `V' square "`abv'^2" "`V'^2" `bst' `adjust'
	return scalar P_square = r(P_chi2)
	return scalar square = r(chi2)

	_crcldr `V' identity "`abv'" "`V'" `bst' `adjust'
	if _caller() < 10 {
		return scalar P_raw  = r(P_chi2)
		return scalar raw  = r(chi2)
	}
	else {
		return scalar P_ident  = r(P_chi2)
		return scalar ident  = r(chi2)
	}

	_crcldr `V' "square root" "sqrt(`abv')" "sqrt(`V')" `bst' `adjust'
	return scalar P_sqrt = r(P_chi2)
	return scalar sqrt = r(chi2)

	_crcldr `V' log "log(`abv')" "log(`V')" `bst' `adjust'
	return scalar P_log = r(P_chi2)
	return scalar log = r(chi2)

	_crcldr `V' "1/(square root)" "1/sqrt(`abv')" "1/sqrt(`V')" `bst' `adjust'
	return scalar P_invsqrt = r(P_chi2)
	return scalar invsqrt = r(chi2)

	_crcldr `V' inverse "1/`abv'" "1/`V'" `bst' `adjust'
	return scalar P_inv = r(P_chi2)
	return scalar inv = r(chi2)

	_crcldr `V' "1/square" "1/(`abv'^2)" "1/(`V'^2)" `bst' `adjust'
	return scalar P_invsq = r(P_chi2)
	return scalar invsq = r(chi2)

	_crcldr `V' "1/cubic" "1/(`abv'^3)" "1/(`V'^3)" `bst' `adjust'
	return scalar P_invcube = r(P_chi2)
	return scalar invcube = r(chi2)

	quietly count if `V'< .
	ret scalar N = r(N)

	if "`generat'"!="" { 
		rename `bst' `generat'
		local lbl : var label `generat'
		di _n in gr `"(`generat' = `lbl' `if' `in' generated)"'
	}
	global S_9
end


program define _crcldr, rclass
	args realv words lblxf realxf best adjust

	tempvar TRY
	quietly gen `TRY' = `realxf'
	capture assert `TRY'< . if `realv'< .
	if _rc {
		di in gr "`words'" _col(24) "`lblxf'" in ye /*
			*/ _col(51) "." _col(64) "." 
	}
	else {
		quietly sktest `TRY', `adjust'
		di in gr "`words'" _col(24) "`lblxf'" in ye /*
			*/ _col(43) %9.2f r(chi2) _col(60) %5.3f r(P_chi2) 
		return scalar chi2 = r(chi2)
		return scalar P_chi2 = r(P_chi2)
		if r(chi2)<$S_9 { 
			global S_9 `r(chi2)'
			capture drop `best'
			rename `TRY' `best'
			label var `best' `"`lblxf'"'
		}
	}
end
exit
/*
Transformation         formula               Chi-sq(2)      P(Chi-sq)
---------------------------------------------------------------------
reciprocal square      1/(longlong^2)        123456789        12345
1234567890123456789012345678901234567890123456789012345678901234567890
         1         2         3         4         5         6
*/
