*! version 1.0.2  12mar2019
program define moveup
	version 15.0

	syntax [varlist] [if] [in] [, MISSing Generate(namelist) REPLACE ///
				      OVERWRITE ]

	if ("`generate'" != "") {

		if ("`overwrite'" != "") {
			opts_exclusive "generate() overwrite"
		}

		local nvars    : list sizeof varlist
		local nnewvars : list sizeof generate

		if (`nvars' != `nnewvars') {
			di as error "{bf:generate()} must contain " ///
				    "as many names as there are variables"
			exit 198
		}

		if ("`replace'" == "") {
			foreach newvar of local generate {
				confirm new variable `newvar'
			}
		}
	}

	if ("`replace'" != "" & "`generate'" == "") {
		di as error "option {bf:replace} can only be used with " ///
			    "{bf:generate()}"
		exit 198
	}

	if ("`overwrite'" == "" & "`generate'" == "") {
		di as error "{bf:overwrite} or {bf:generate()} must be " ///
		            "specified"
		exit 198
	}

	if ("`missing'" == "") {
		marksample touse, strok
	}
        else {
        	marksample touse, strok novarlist
        }

	tempvar m mm

	quietly {
		gen double `mm' = cond(`touse'[_N], _N, .) in 1

		replace    `mm' = cond(`touse'[_N - _n + 1], _N - _n + 1, ///
		                       `mm'[_n - 1]) if _n > 1

		gen double `m' = `mm'[_N] in 1
		replace    `m' = `mm'[_N - `m'[_n - 1]] if _n > 1

		if ("`overwrite'" != "") {
			foreach x of local varlist {
				replace `x' = `x'[`m'] // `m' >= _n
			}
		}

		if ("`generate'" != "") {

			foreach x of local varlist {
				tempvar y
				gen `: type `x'' `y' = `x'[`m']
				local newvars `newvars' `y'
			}

			nobreak {
				tokenize `newvars'
				local i 1

				foreach x of local generate {

					if ("`replace'" != "") {
						cap confirm var `x'
						if (_rc == 0) {
							drop `x'
						}
					}

					rename ``i'' `x'
					local ++i
				}
			}
		}
	}
end

