*! version 1.0.0  11sep2012

program define _teffects_count_obs, rclass
	version 13
	syntax varname(numeric), [ why(string) min(integer 4) freq(varname) ///
			tabulate(string) ]

	local touse `varlist'
	if "`freq'" != "" {
		summarize `freq' if `touse', meanonly
		local fw [fw=`freq']
	}
	else qui count if `varlist'

	if !r(N) {
		if "`why'" != "" { 
			di as err "{p}no observations after dropping " ///
			 "`why'{p_end}"
			exit 2000
		}
		else error 2000
	}
	if r(N) < `min' {
		if "`why'" != "" { 
			di as err "{p}insufficient observations after " ///
			 "dropping `why'{p_end}"
			exit 2001
		}
		error 2001
	}
	return add

	if ("`tabulate'"=="") exit

	local 0 `tabulate'
	syntax varname, levels(integer)
	tempname k lev

	qui tabulate `varlist' `fw' if `touse', matcell(`k') matrow(`lev') 
	local r = r(r)
	if r(r) != `levels' {
		di as err "{p}the number of treatment levels has decreased " ///
		 "from `levels' to `r'" _c
		if "`why'" != "" {
			di as err " after dropping `why'" _c
		}
		di as err "{p_end}"

		exit 459
	}
	forvalues i=1/`r' {
		local levi = `lev'[`i',1]
		local ki = `k'[`i',1]
		return local n`levi' = `ki'
		local levels `levels' `levi'
	}
	return local levels `"`levels'"'
	return scalar r = `r'
end
exit
