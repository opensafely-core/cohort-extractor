*! version 1.0.2  29sep2004
program define svyset_7
/*
   Syntax:

	svyset key varname    [sets key to varname]
	svyset key            [displays key]
	svyset key, clear     [clears key]
	svyset                [displays all set keys]
	svyset, clear         [clears all set keys]
*/
	version 6, missing
	local keylist "pweight strata psu fpc"
	tokenize "`0'", parse(" ,")
	if "`1'"=="" | ("`1'"=="," & "`2'"=="") {
		disp_key `keylist'
		exit
	}
	if "`1'"=="," {
		if "`2'"=="clear" & "`3'"=="" {
			clr_key `keylist'
			exit
		}
		error 198
	}
	local key "`1'"
	macro shift
	chk_key `key' `keylist'
	if "`1'"=="" {
		disp_key `key'
		exit
	}
	if "`1'"=="," {
		if "`2'"=="clear" & "`3'"=="" {
			clr_key `key'
			exit
		}
		error 198
	}

	local 0 `*'
	syntax varname [, CLEAR ]
	if "`clear'"!="" {
		clr_key `key'
		exit
	}
	local notstr : word `s(WhichKey)' of 1 0 0 1
	capture confirm string variable `varlist'
	if _rc==0 & `notstr' {
		di in red "`key' may not be a string variable"
		exit 109
	}
	char _dta[`key'] `varlist'
end

program define disp_key  /* display set key(s) */
	local i 1
	while "``i''"!="" {
		local varname : char _dta[``i'']
		if "`varname'"!="" {
			local someset 1
			di in gr "``i'' is `varname'"
		}
		local i = `i' + 1
	}
	if "`someset'"!="" { exit }

	if `i' == 2 {
		di in gr "`1' has not been set"
		exit
	}
	di in gr "no variables have been set"
end

program define clr_key  /* clear key(s) */
	local i 1
	while "``i''"!="" {
		char _dta[``i'']
		local i = `i' + 1
	}
end

program define chk_key, sclass /* checks syntax of key */
	args key
	local i 2
	while "``i''"!="" {
		if "`key'"=="``i''" {
			sret local WhichKey = `i' - 1
			exit
		}
		local i = `i' + 1
	}
	di in red "keyword incorrect"
	error 198
end
