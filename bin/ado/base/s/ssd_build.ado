*! version 1.0.3  08mar2012
program ssd_build
	version 12

	syntax varlist(numeric) [if] [in]	///
		[,	group(varname numeric)	///
			noMEANs			///
			CORrelations		///
			clear			///
		]

	local K : list sizeof varlist
	if (`K'<2) {
	  di as err "syntax error"
	  di as err "{p 4 4 2}"
	  di as err "Syntax is {bf:ssd build} {it:varlist}{break}"
	  di as err "You must specify two or more variables."
	  di as err "{p_end}"
	  exit 198
	}
	if "`clear'" == "" {
		if c(changed) {
			error 4
		}
	}
	preserve
	marksample touse

	if "`group'" != "" {
		tempname gvar
		local varlist : list varlist - group
		markout `touse' `group', strok
		quietly egen `gvar' = group(`group') if `touse', lname(`gvar')
		sum `gvar', mean
		local Ng = r(max)
		local byvar : copy local group
		local vlabby : var label `group'
		local savlab = "`:val lab `group''" != ""
		if !`savlab' {
			capture assert `gvar' == `group' if `touse'
			if c(rc) {
				local savlab 1
			}
		}
		if `savlab' {
			tempfile gfile
			quietly label save `gvar' using `"`gfile'"'
		}
	}
	else {
		local gvar : copy local touse
		local Ng = 1
	}
	local corr : length local correlations

	quietly count if `touse'
	if r(N) == 0 {
		error 2000
	}

	local nvars : list sizeof varlist
	local vlist : copy local varlist
	forval i = 1/`nvars' {
		gettoken var vlist : vlist
		local vlab`i' : var label `var'
	}

	forval i = 1/`Ng' {
		tempname S`i' m`i'
		quietly matrix accum `S`i'' = `varlist'	///
			if `gvar' == `i', dev nocons mean(`m`i'')
		local nobs`i' = r(N)
		matrix `S`i'' = `S`i''/(`nobs`i'' - 1)
		if `corr' {
			matrix `S`i'' = corr(`S`i'')
		}
	}
	local fname `"`c(filename)'"'

	drop _all
	quietly ssd init `varlist'
	forval i = 1/`Ng' {
		if `i' > 1 {
			quietly ssd addgroup `byvar'
			local byvar
		}
		quietly ssd set obs `nobs`i''
		if "`means'" == "" {
			quietly ssd set means (stata) `m`i''
		}
		if `corr' {
			quietly ssd set cor (stata) `S`i''
		}
		else {
			quietly ssd set cov (stata) `S`i''
		}
	}
	if `:length local fname' {
		local fname `"from '`fname''"'
	}
	notes :	summary statistics data built `fname' on		///
		`c(current_date)' `c(current_time)' using		///
		-ssd build `0'-
	if "`group'" != "" {
		if "`gfile'" != "" {
			run `"`gfile'"'
			label copy `gvar' `group', replace
			label drop `gvar'
			label values `group' `group'
		}
		label var `group' `"`vlabby'"'
	}
	local vlist : copy local varlist
	forval i = 1/`nvars' {
		gettoken var vlist : vlist
		label var `var' `"`vlab`i''"'
	}
	restore, not
	di as txt "{p 1 2 2}"
	di as txt " (data in memory now summary statistics data;"
	di as txt "you can use {bf:ssd describe} and {bf:ssd list}"
	di as txt "to describe and list results.)"
	di as txt "{p_end}"
end
exit
