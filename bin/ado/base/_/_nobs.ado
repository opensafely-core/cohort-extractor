*! version 1.0.2  23sep2004
program define _nobs, rclass
	version 6, missing
	qui syntax varname(numeric) [fw pw iw aw] [if] [in] [, MIN(integer 1) /*
	*/ ZEROweight ]

	marksample touse, `zerowei'

	if "`weight'"!="fweight" {
		qui count if `varlist' & `touse'
		local nobs `r(N)'
	}
	else {
		qui summarize `varlist' [fweight`exp'] if `varlist' & `touse', meanonly
		local nobs `r(sum_w)'
	}

	if `nobs' < `min' {
		if `nobs' == 0 { error 2000 }

		di in blu "must have `min' or more observations"
		exit 2001
	}

	return scalar N = `nobs'
end
