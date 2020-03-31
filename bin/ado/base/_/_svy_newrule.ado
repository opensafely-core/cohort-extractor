*! version 1.0.3  11aug2005
program define _svy_newrule
	version 8
	local version : di "version " string(_caller()) ":"
	syntax [, pweight iweight strata(string) psu(string) fpc(string) * ]
	if `"`pweight'"' != "" | `"`iweight'"' != "" {
	di as err "weights can only be supplied to {help svyset##|_new:svyset}"
		exit 198
	}
	if `"`strata'"' != "" {
	di as err "strata() can only be supplied to {help svyset##|_new:svyset}"
		exit 198
	}
	if `"`psu'"' != "" {
	di as err "psu() can only be supplied to {help svyset##|_new:svyset}"
		exit 198
	}
	if `"`fpc'"' != "" {
	di as err "fpc() can only be supplied to {help svyset##|_new:svyset}"
		exit 198
	}
	quietly `version' svyset
	if _caller() < 9 {
		local is_set = `"`r(_svy)'"' == "set"
	}
	else	local is_set = `"`r(settings)'"' != ", clear"
	if !`is_set' {
		if c(stata_version) >= 9 & `"`r(settings)'"' == ", clear(all)" {
			di as err "{p 0 0 2}"	///
"data not set up for the old survey estimation commands; " ///
"use {cmd:svyset} under version control "	///
"or use the new {helpb svy##|_new:svy} prefix{p_end}"
		}
		else	di as err	///
		"data not set up for svy, use {helpb svyset##|_new:svyset}"
		exit 119
	}
end

exit
