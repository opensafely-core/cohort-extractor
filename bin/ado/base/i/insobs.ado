/*
   insobs [nobs] [, Before(pos) After(pos)]
*/
*! version 1.0.2  10mar2015
program define insobs, rclass
	version 14.0 
	
	syntax anything(id="number of inserted observations") ///
		[, Before(string) After(string)]
		
	gettoken nobs 0 : 0, parse(",")
	local 0 `nobs'
	gettoken nobs 0 : 0, parse(" ")
	
	if `"`0'"' != "" {
		di as err "too many arguments specified"
		exit 198
	}
	
	if `"`nobs'"' != "" & `"`nobs'"' != "," {
		capture confirm integer number `nobs' 
		if _rc {
			di as err "number of inserted observations must be a positive integer"
			exit 198 
		}
		if `nobs' <= 0 {
			di as err "number of inserted observations must be a positive integer"
			exit 198 
		}
	}
	
	if _N == 0 {
		if `"`before'"' != "" | `"`after'"' != "" {
			di as err "options before() and after() are not allowed when dataset is empty"
			exit 198
		}
	}
	
	if `"`before'"' != "" & `"`after'"' != "" {
		di as err "options before() and after() may not be specified together"
		exit 198
	}
	if `"`before'"' != "" {
		local bpos = `before'
		capture confirm integer number `bpos' 
		if _rc {
			di as err "insert position must be a positive integer"
			exit 198
		}
		if `bpos' <=0 {
			di as err "insert position must be a positive integer"
			exit 198			
		}
		if `bpos' > _N {
			di as err "insert position must not be greater than total number of observations in dataset"
			exit 198
		}
	}
	if `"`after'"' != "" {
		local apos = `after'
		capture confirm integer number `apos' 
		if _rc {
			di as err "insert position must be a positive integer"
			exit 198
		}
		if `apos' <=0 {
			di as err "insert position must be a positive integer"
			exit 198			
		}
		if `apos' > _N {
			di as err "insert position must be less than total number of observations in dataset"
			exit 198
		}
	}

	quietly des
	if r(k) == 0 | _N == 0 {
		quietly {
			set obs `= _N + `nobs''
			noisily {
				if `nobs' == 1 {
					di as txt "(1 observation added)"
				}
				else {
					di as txt "(`nobs' observations added)"
				}
			}
		}
	}
	else {
		tempvar order
		gen double `order' = _n
		quietly {
			set obs `= _N + `nobs''
			local inspos = _N - `nobs' + 1 

			if `"`before'"' != "" | `"`after'"' != "" {
				if `"`before'"' != "" {
					replace `order' = `bpos' - 0.5 in `inspos'/l
					sort `order' in `bpos'/l
				}
				if `"`after'"' != "" {
					replace `order' = `apos' + 0.5 in `inspos'/l
					sort `order' in `apos'/l
				}
			}
			noisily {
				if `nobs' == 1 {
					di as txt "(1 observation added)"
				}
				else {
					di as txt "(`nobs' observations added)"
				}
			}
		}
	}
end
