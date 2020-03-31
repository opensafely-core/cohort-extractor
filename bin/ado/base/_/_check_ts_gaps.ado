*! version 1.0.2  12jan2011

program  define _check_ts_gaps, sortpreserve
	version 11
	syntax varname, touse(varname)

	local timevar `varlist'
	tempname tsdelta
	if "`: char _dta[_TSdelta]'" != "" {
		scalar `tsdelta' = `: char _dta[_TSdelta]'
	}
	else scalar `tsdelta' = 1

	tempvar del chk

	local ty : type `timevar'
	qui by `touse' (`timevar'), sort: gen `ty' `del' = `timevar'- ///
		`timevar'[_n-1]
	gen byte `chk' = 0
	qui replace `chk' = `del'==0 if `touse' 
	qui count if `chk' 
	/* repeated dates						*/ 
	if r(N) > 0 {
		di as err "detected " r(N) " replicated " ///
		 plural(r(N),"date") "; this is not allowed"
		exit 459
	}
	qui replace `chk' = 0
	qui replace `chk' = `del'!=`tsdelta' if `touse' 
	qui count if `chk'
	/* first difference is missing					*/ 
	if r(N) > 1 {
		qui count if `touse'
		if r(N) < _N {
			di as err "{p}gaps in the time series are not "   ///
			 "allowed; the gaps may be due to dropping "      ///
			 "observations because of missing values{p_end}"
		}
		else di as err "gaps in the time series are not allowed"

		exit 459
	}
end

exit
