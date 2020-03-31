*! version 1.0.7  01may2019
program probit_estat, rclass
	local vcaller = string(_caller())
	version 9

	if "`e(cmd)'" != "probit" & "`e(cmd)'" != "dprobit" &	///
		"`e(cmd)'" != "ivprobit" & "`e(cmd)'" != "fracreg" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if "`e(cmd)'" == "ivprobit" {
		local vv version `vcaller':
	}
	if `"`key'"' == bsubstr("classification",1,max(4,`lkey')) {
		if ("`e(cmd)'" == "fracreg"){
			di in red as smcl /*
			*/ "not available after {bf:`e(cmd)'}"
			exit 321
		}
		CheckForBad `rest'
		`vv' ///
		lstat `rest'
	}
	else if `"`key'"' == bsubstr("gof",1,max(3,`lkey')) {
		if ("`e(cmd)'" == "ivprobit"|"`e(cmd)'" == "fracreg"){
			di as error /*
			*/ "not available after {bf:`e(cmd)'}"
			exit 321
		}
		CheckForBad `rest'
		`vv' ///
		lfit `rest'
	}
	else if `"`key'"' == bsubstr("auc",1,max(3,`lkey')) {
		CheckForBad `rest'
		`vv' ///
		lroc, nograph, `rest'
	}
	else {
		estat_default `0'
	}
	return add
end


program CheckForBad
	capture syntax varlist [fw] [if] [in] [, * ]
	if _rc == 0 {
		// it found a varname
		di as error "varlist not allowed"
		exit 101
	}
	capture syntax [fw] [if] [in] , beta(str) [ * ]
	if _rc == 0 {
		// it found a beta() option
		di as error "option beta() not allowed"
		exit 198
	}
	if "`e(cmd)'" == "ivprobit" {
		if "`e(method)'" == "twostep" {
			di as error /*
				*/ "not available after {cmd:ivprobit, twostep}"
			exit 321
		}
	}
end
