*! version 1.1.2  22sep2004
program define kap_3 /* utility for kap, 3 or more raters */
	version 6.0, missing
	syntax varlist(min=3) [if] [in] [fweight] [, Absolute Tab Wgt(string)]

	if "`absolut'" != "" {
		di in red "Option absolute not allowed with 3 or more raters"
		exit 198
	}
	if "`tab'"!="" {
		di in red "option tab not allowed with 3 or more raters"
		exit 198
	}
	if "`wgt'"!="" {
		di in red "option wgt() not allowed with 3 or more raters"
		exit 198
	}

	tempvar touse
	mark `touse' [`weight'`exp'] `if' `in'
	quietly count if `touse'
	if r(N) < 1 { 
		error 2000
	}

	parse "`varlist'", parse(" ")
	local i 1 
	while "``i''" != "" {
		capture assert ``i''>=. if `touse'
		if _rc==0 {
			di in gr /*
		*/ "note:  ``i'' contains all missing values; variable ignored"
			local `i' " " 
		}
		local i = `i' + 1
	}
	local varlist "`*'"
	local n : word count `varlist'
	if `n'==0 | `n'==1 { 
		if `n' {
			di in red "only one rating variable remains"
		}
		else	di in red "no rating variables remain"
		exit 498
	}
	if `n'==2 { 
		di _n in gr "There are 2 identified raters per subject:"
		kap `varlist' [`weight'`exp'] if `touse'
		exit
	}

	preserve 
	quietly { 
		if "`weight'"!="" {
			tempvar pop
			gen double `pop' `exp' `if' `in'
			compress `pop'
			local wgt "[`weight'=`pop']"
		}
		keep if `touse'
		keep `pop' `varlist'


		tempvar cat sum
		tempname res nres
		gen long `sum' = 0

		Getcats `res' `nres' = `varlist'

		parse "`varlist'", parse(" ")
		local i 1
		while `i' <= `nres' { 
			tempvar new
			local catlist "`catlist' `new'"
			gen long `new' = 0 
			local j 1
			while "``j''" != "" { 
				replace `new' = `new' + /*
					*/ (float(``j'')==float(`res'[1,`i']))
				local j = `j' + 1
			}
			replace `sum' = `sum' + `new'
			compress `new'
			local lbl = string(`res'[1,`i'], "%12.0g")
			label var `new' "`lbl'"
			local i = `i' + 1
		}
		keep `catlist' `pop' `sum'
	}
	capture assert `sum'==`sum'[1]
	if _rc { 
		quietly summ `sum', detail
		local med : di %9.2f r(p50)
		local med `med'
		di in gr _n "There are between " r(min) " and " /*
		*/ r(max) " (median = `med') raters per subject:"
	}
	else	di in gr _n "There are " `sum'[1] " raters per subject:"
	kappa `catlist' `wgt'
end
		

program define Getcats /* newvecname newscalarname = varlist */
	local res "`1'"
	local nres "`2'"
	mac shift 3
	tempfile new
	quietly {
		preserve
		drop _all
		set obs 1
		tempvar cat 
		gen double `cat' = .
		save `"`new'"', replace

		while "`1'" != "" {
			restore, preserve
			drop if `1'>=.
			gen double `cat' = `1'
			keep `cat'
			if _N { 
				sort `cat' 
				by `cat': keep if _n==1
				append using `"`new'"'
				save `"`new'"', replace
			}
			mac shift
		}
		use `"`new'"', clear
		sort `cat'
		by `cat': keep if _n==1
		drop if `cat'>=.

		scalar `nres' = _N
		local mynres = _N
		matrix `res' = J(1,`mynres',0)

		local i 1
		while `i' <= _N { 
			matrix `res'[1,`i'] = `cat'[`i']
			local i = `i' + 1
		}
	}
end
