*! version 1.0.8  28mar2017
program define export_dbase
	version 15

	capture syntax [varlist] using/ [if] [in] [, *]
	if _rc {
		local orig0 `"`0'"'
		local 0 `"using `0'"'
		capture syntax using/ [if] [in] [, *]
		if _rc {
			if (_rc == 111) {
				dis as err `"variable(s) not defined"'
				exit 111
			}
			local 0 `"`orig0'"'
			syntax [varlist] using/ [if] [in]		///
				[, REPLACE VERsion(string) DATAFmt ORIGDBFDATE]
		}
		else {
			syntax using/ [if] [in]				///
				[, REPLACE VERsion(string) DATAFmt ORIGDBFDATE]
		}
	}
	else {
		syntax [varlist] using/ [if] [in]			///
				[, REPLACE VERsion(string) DATAFmt ORIGDBFDATE]
	}

	// Check for dBase file limits
	// 2 gig file limit
	// 1,000,000,000 observation limit
	// 255 variable limit
	// 10 character variable names
	// 4000 observation width limit
	// maximum length of a str var is 254

	export_dbase_check_dataset
	export_dbase_check_variables "`varlist'"

	// cannot marksample because we must produce header based on
	// data in memory.  We could make a subset in mata, but that
	// would eat memory
	if (`"`if'"' != "" || "`in'" != "" || "`varlist'" != "") {
		preserve
		if "`in'" != "" {
			qui keep `in'
		}
		if `"`if'"' != "" {
			qui keep `if'
		}
		if "`varlist'" != "" {
			qui keep `varlist'
		}
	}

	export_dbase_check_size

	mata: export_dbase_export_file()

	if (`"`if'"' != "" || "`in'" != "" || "`varlist'" != "") {
		restore
	}
end
	
program export_dbase_check_dataset
	if (`c(k)' == 0 & _N==0) {
		error 3
	}
	if (`c(k)' == 0) {
		error 102
	}
	if (_N == 0) {
		error 2000
	}
end

program export_dbase_check_variables
	args varlist

	if ("`varlist'" != "") {
		unab varlist : `varlist'
		local vcount : word count `varlist'
		if (`vcount' > 255) {
			di as err "too many variables specified"
			di as err "    Number of variables must be less than 255."
			exit(103)
		}
	}

	if (`c(k)'>255) {
		di as err "too many variables specified"
		di as err "    Number of variables must be less than 255."
		exit(103)
	}

	if ("`varlist'" == "") {
		unab varlist : _all
	}

	foreach var of local varlist {
		local len = strlen("`var'")
		if (`len' > 10) {
di as err "`var': variable name must be less than 10 characters"
			exit(693)
		}
		local type : type `var'
		if (strpos("`type'", "str")>0) {
			if ("`type'" == "strL") {
				di as err "variable `var' cannot be a strL"
				exit(693)
			}
			local len = substr("`type'", 4, .)
			if (`len' > 254) {
di as err "variable `var' cannot exceed 254 characters in length"
				exit(108)
			}
			
		}
	}
end

program export_dbase_check_size
	if (_N > 1000000000) {
		di as err "too many observations specified"
		di as err "    Number of observations must be less than 1,000,000,000."
		exit(901)
	}

	if (`c(width)'>4000) {
		di as err "invalid observation width"
		di as err "    Observation width must be less than 4000."
		exit(902)
	}
end

