*! version 1.0.3  29jan2019

program define menl_tsset, sclass
	syntax varlist(numeric min=1 max=2), touse(varname) tsvar(varname) ///
		timevar(name) [ quietly ]

	gettoken sorder panels: varlist

	tempvar group

	qui gen byte `group' = 1-`touse'
	if "`panels'" != "" {
		sort `group' `panels' `tsvar'
	}
	else {
		sort `group' `tsvar'
	}
	CheckTSvarRepeated `tsvar', touse(`touse' `group') panels(`panels') ///
		timevar(`timevar') `quietly'

	/* generate integer valued time variable, group prevents
	 *  gaps in timevar						*/
	qui by `group' `panels' (`tsvar'): gen long `timevar' = _n if `touse'
	char define `timevar'[name] "`tsvar'"

	sort `panels' `timevar'
	cap tsset `panels' `timevar'

	local rc = c(rc)
	if `rc' {
		/* should not happen					*/
		if "`panels'" != "" {
			local msg " hierarchy panels and"
		}
		local errmsg `"failed to {bf:tsset} data base on `msg' "'
		local errmsg `"`errmsg'{bf:tsorder} variable `tsvar'"'
		if "`quietly'" != "" {
			sreturn local errmsg `"`errmsg'"'
		}
		else {
			di as err `"{p}`errmsg'{p_end}"'
		}
		exit `rc'
	}
end

program define CheckTSvarRepeated, sclass
	syntax varname, touse(string) timevar(name) [ panels(varname) quietly ]

	local tsvar `varlist'

	tempvar eql check

	gettoken touse group : touse
	qui gen long `check' = 0
	qui by `group' `panels' (`tsvar'): replace `check' = ///
		reldif(`tsvar'[_n],`tsvar'[_n-1])<c(epsfloat) if `touse' & _n>1
/*
set more on
cap noi list `group' `panels' `tsvar' `check' `touse', sepby(`panels')
set more off
*/
	qui count if `check'>0
	if r(N) {
		if "`panels'" != "" {
			local msg " within panels {bf:`panels'"
		}
		local errmsg `"repeated values in {bf:tsorder} variable "'
		local errmsg `"`errmsg'{bf:`tsvar'}`msg'; this is not allowed"'
		if "`quietly'" != "" {
			sreturn local errmsg `"`errmsg'"'	// dialog
		}
		else {
			di as err `"{p}`errmsg'{p_end}"'
		}
		exit 451
	}
end

exit
