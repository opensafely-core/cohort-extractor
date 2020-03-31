*! version 6.0.3  09jun2011
program define md2_, rclass
	version 8.0
	ml_technique `0'
	local techlist 	`s(techlist)'
	local numlist	`s(numlist)'
	local vce 	`s(vce)'

	// common settings
	return local method "d2"
	return local opt "ml_opt"
	return local techlist "`techlist'"
	return local score "ml_eds"
	return local vce "`vce'"
	return scalar preserve = .

	// cycling through techniques
	if `:word count `techlist'' > 1 {
		return local eval "ml_e2_cycle"
		return local numlist `numlist'
		return scalar preserve = .
		if "`vce'" == "native" {
			di as err ///
"option vce(native) is not allowed when switching optimization techniques"
			exit 198
		}
		else if "`vce'" == "opg" {
			return local vce2 "OPG"
		}
		else	return local evalf "ml_e2"	// oim
		exit
	}
	// only used with cycling techniques
	local numlist

	if "`techlist'" == "nr" {
		return local eval "ml_e2"
		if "`vce'" == "opg" {
			return local vce2 "OPG"
		}
		// default vce is oim
		exit
	}

	if "`techlist'" == "bhhh" {
		return local eval "ml_e1_bhhh"
		if "`vce'" == "oim" {
			return local evalf "ml_e2"
		}
		else	return local vce2 "OPG"		// default & native
		exit
	}

	if "`techlist'" == "bfgs" {
		return local eval "ml_e1_bfgs"
		return local noinv "noInvert"
		if "`vce'" == "opg" {
			return local vce2 "OPG"
		}
		else if "`vce'" == "native" {
			return local vce2 "BFGS"
		}
		else {	// default is oim
			return local evalf "ml_e2"
		}
		exit
	}

	if "`techlist'" == "dfp" {
		return local eval "ml_e1_dfp"
		return local noinv "noInvert"
		if "`vce'" == "opg" {
			return local vce2 "OPG"
		}
		else if "`vce'" == "native" {
			return local vce2 "DFP"
		}
		else {	// default is oim
			return local evalf "ml_e2"
		}
		exit
	}

	di as err "option technique(`techlist') not valid with method d2"
	exit 198
end
exit

Saved results:

Scalars:
	r(preserve)	0, 1, or "." -- whether to -preserve- or not

Macros:
	r(method)	evaluator method for computing lnf, g, and negH
	r(opt)		"ml_opt"
	r(techlist)	list of specified optimization techniques
	r(eval)		program that calls evaluator, may compute g and/or negH
	r(noinv)	"noInvert" or empty -- e(eval) returns (-H)^-1
	r(evali)	program that initializes numeric deltas
	r(evalf)	program that calls evaluator for final call
	r(noinf)	"noInvert" or empty -- e(evalf) returns (-H)^-1
	r(score)	program that renames scores
	r(vscore)	"1" or empty -- scores computed by coefficient
	r(scvars)	"noscvars" or empty -- no scorevars

