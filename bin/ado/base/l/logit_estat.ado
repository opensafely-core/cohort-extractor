*! version 1.0.3  01may2019
program logit_estat, rclass
	version 9

	if "`e(cmd)'" != "logit" & "`e(cmd)'" != "logistic" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("classification",1,max(4,`lkey')) {
		CheckForBad `rest'
		lstat `rest'
	}
	else if `"`key'"' == bsubstr("gof",1,max(3,`lkey')) {
		CheckForBad `rest'
		lfit `rest'
	}
	else if `"`key'"' == bsubstr("auc",1,max(3,`lkey')) {
		CheckForBad `rest'
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
end
