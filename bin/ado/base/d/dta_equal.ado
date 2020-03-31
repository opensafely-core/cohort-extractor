*! version 1.0.2  16may2009
/*
	dta_equal {<filename> | .}  <filename> [, <options>]

	<options> :=
			exclude(string)		variables to exclude
			uniq1
			uniq2
			noneok
			RELdiff()	* not documented in the help file

	Returns:
		macros:
		r(common)	common variables
		r(uniq1)	variables unique to filename1
		r(uniq2)	variables unique to filename2

*/

program dta_equal, rclass
	version 11

	gettoken fn1 0 : 0, parse(" ,")
	gettoken fn2 0 : 0, parse(" ,")

	if ("`fn1'"==".") {
		local hold "`c(filename)'"
		tempfile fn1
		qui save "`fn1'"
		global S_FN "`hold'"
		local fn1_msg "memory"
	}
	else {
		local fn1_msg "`fn1'"
	}

	syntax [, EXclude(string) UNIQ1 UNIQ2 NONEok RELdiff(real 0) ]

	// confirm file "`fn1'.dta"
	// confirm file "`fn2'.dta"

	preserve

	quietly {
		use "`fn1'", clear 
		dta_equal_vars vl1 
		local vl1 : list vl1 - exclude
		local N1 = _N

		use "`fn2'", clear
		dta_equal_vars vl2
		local vl2 : list vl2 - exclude
		local N2 = _N
	}

	if (`N1'!=`N2') { 
		di as err "`fn1_msg' has `N1' obs."
		di as err "`fn2' has `N2' obs."
		exit 9
	}

	local dl : list vl1 - vl2 
	if ("`dl'"!="") {
		local dl : list sort dl
		di as smcl as txt "{p 0 4 2}"
		di as smcl "variables unique to `fn1_msg':"
		di as smcl "`dl'"
		di as smcl "{p_end}"
		if ("`uniq1'"=="") {
			exit 9
		}
		return local uniq1 `dl'
		local dl
	}
	local dl : list vl2 - vl1 
	if ("`dl'"!="") {
		local dl : list sort dl
		di as smcl as txt "{p 0 4 2}"
		di as smcl "variables unique to `fn2':"
		di as smcl "`dl'"
		di as smcl "{p_end}"
		if ("`uniq2'"=="") {
			exit 9
		}
		return local uniq2 `dl'
		local dl
	}

	local vl : list vl1 & vl2
	if ("`vl'"=="") {
		di as txt "(no variables in common)"
		if ("`noneok'"=="") { 
			exit 9
		}
		exit
	}
	local vl : list sort vl
	return local common `vl'

	di as smcl as txt "{p 0 4 2}"
	di as smcl "common variables:"
	di as smcl "`vl'"
	di as smcl "{p_end}"

	tempname secondvar
	tempfile temp2
	local bad 0
	foreach v of local vl {
		quietly { 
			use "`fn2'", clear
			keep `v'
			rename `v' `secondvar'
			save "`temp2'", replace

			use "`fn1'", clear 
			keep `v'
			merge 1:1 _n using "`temp2'"
		}
		capture count if `v'!=`secondvar'
		if (_rc) { 
			di as err "`v':  type mismatch"
			local ++bad
		}
		else if (`reldiff'>0) {
			capture count if reldif(`v',`secondvar')>=`reldiff'
			if (r(N)) {
				di as err "`v':  `r(N)' obs. not within" ///
					  %8.7e `reldiff' " rel. diff."
				local ++bad
			}
		}
		else if (r(N)) {
			di as err "`v':  `r(N)' mismatches"
			local ++bad
		}
	}
	if (`bad') { 
		di as err "`bad' variables mismatch"
		exit 9
	}
	di as txt "variables match"
end

program dta_equal_vars
	args uservl

	local 0 "_all"
	syntax varlist 
	c_local `uservl' `varlist'
end
