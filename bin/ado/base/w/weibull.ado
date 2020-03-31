*! version 8.2.2  04dec2015
program define weibull, byable(onecall) eclass prop(ml_score)
	version 7

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}

	if replay() {
		if `"`e(cmd)'"' != "weibull" { 
			error 301 
		} 
		if "`e(by_weibull_c)'"!="" { 
			`by' weibull_c `0'
		}
		else	`by' weibull_s `0'
		exit
	}
	syntax [varlist(fv)] [if] [in] [fweight pweight iweight] /*
		*/ [, ANCillary(string) STrata(string) noCONstant    /*
		*/ OFFset(string) hazard * ]

	mlopts mlopts rest, `options'
	local cns `s(constraints)'

	local vv : di "version " string(_caller()) ", missing:"
	if "`ancillary'"=="" & "`strata'"=="" & "`constant'"=="" &    /*
		*/ ("`cns'" == "" | ("`cns'" != "" & "`hazard'" != "")) & /*
		*/ `"`offset'"'=="" {
		`vv' `by' weibull_s `0'
	}
	else	`vv' `by' weibull_c `0'
end
