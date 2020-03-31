*! version 6.0.5  09jun2011
program define md0_, rclass
	version 8.0
	ml_technique `0'
	local techlist 	`s(techlist)'
	local numlist	`s(numlist)'
	local vce 	`s(vce)'
	if "`vce'" == "opg" {
		di in red "option vce(`vce') not valid with method d0"
		exit 198
	}
	local bhhh bhhh bhhhq
	local hasbhhh = "`:list techlist - bhhh'" != "`techlist'"
	if `hasbhhh' {
		di as err "option technique(bhhh) not valid with method d0"
		exit 198
	}

	// common settings
	return local method "d0"
	return local opt "ml_opt"
	return local evali "ml_e0i"
	return local techlist "`techlist'"
	return local score "ml_eds"
	return local vce "`vce'"
	return scalar preserve = .

	// cycling through techniques
	if `:word count `techlist'' > 1 {
		return local numlist `numlist'
		return local eval "ml_e0_cycle"
		return scalar preserve = .
		if "`vce'" == "native" {
			di as err ///
"option vce(native) is not allowed when switching optimization techniques"
			exit 198
		}
		else	return local evalf "ml_e0"	// oim
		exit
	}
	// only used with cycling techniques
	local numlist

	if "`techlist'" == "nr" {
		return local eval "ml_e0"
		// default vce is oim
		exit
	}

	if "`techlist'" == "bfgs" {
		return local eval "ml_e0_bfgs"
		return local noinv "noInvert"
		if "`vce'" == "native" {
			return local noinf "noInvert"
			return local vce2 "BFGS"
		}
		else {	// default is oim
			return local evalf "ml_e0"
		}
		exit
	}

	if "`techlist'" == "dfp" {
		return local eval "ml_e0_dfp"
		return local noinv "noInvert"
		if "`vce'" == "native" {
			return local noinf "noInvert"
			return local vce2 "DFP"
		}
		else {	// default is oim
			return local evalf "ml_e0"
		}
		exit
	}

	di in red "option technique(`techlist') not valid with method d0"
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

