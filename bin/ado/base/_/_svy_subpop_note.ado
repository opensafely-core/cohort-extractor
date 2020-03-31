*! version 1.1.2  07apr2011
program _svy_subpop_note
	version 9
	
	if ("`e(mi)'"=="mi") {
		local mi _mi
	}
	syntax [, linesize(int 79) ]
	if ("`e(mi)'"=="mi") {
		local cmd `e(cmd_mi)'
	}
	else {
		local cmd `e(cmd)'
	}
	if !missing(e(N_strata_omit`mi')) {
		if e(N_strata_omit`mi') != 0 {
			local omit = e(N_strata_omit`mi')
			if ("`e(N_strata_vs_mi)'"=="matrix") {
				//varying omitted strata with MI
				local ss "strata"
				local cc "they contain"
				local diomit "`ss' omitted in some imputations"
			}
			else if `omit' == 1 {
				local ss "stratum"
				local cc "it contains"
			}
			else {
				local ss "strata"
				local cc "they contain"
			}
			if ("`diomit'"=="") {
				local diomit "`omit' `ss' omitted"
			}
			is_svysum `cmd'
			if r(is_svysum) {
				local over `"`e(over)'"'
			}
			if `"`e(subpop)'`over'"' != "" {
				di as txt "{p 0 6 0 `linesize'}" ///
"Note: `diomit' because `cc' no subpopulation members.{p_end}"
			}
			else {
				di as txt "{p 0 6 0 `linesize'}" ///
"Note: `diomit' because `cc' no population members.{p_end}"
			}
		}
	}
end
exit
