*! version 4.0.5  01oct2004
program define mvdecode
	version 8, missing
	syntax varlist [if] [in], mv(str)

	marksample touse, novarlist
	quietly count if `touse'
	if r(N) == 0 {
		exit
	}

	/* stores transformation rules as lhs<n> rhs<n>
	   where lhs<n> is an expanded numlist,
	   and rhs<n> is a missing value
	*/

	gettoken tok mv : mv, parse("=\")
	if `"`mv'"' == "" {
		// just a numlist; interpretation numlist = .
		capt numlist `"`tok'"'
		if _rc {
			Error 121 `"`tok' is not a valid numlist"'
		}
		local lhs1 `r(numlist)'
		local nlhs 1
		local rhs1 .
	}
	else {
		local nlhs 0
		while `"`tok'"' != "" {
			local ++nlhs
			capt numlist `"`tok'"'
			if _rc {
				Error 121 `"`tok' is not a valid numlist"'
			}
			local lhs`nlhs' `r(numlist)'

			// next token should be =
			gettoken tok mv : mv, parse("=\")
			if `"`tok'"' != "=" {
				Error 198 "= expected"
			}

			// next token should be mv-code
			gettoken tok mv : mv, parse("=\")
			MissCode `tok'
			local rhs`nlhs' `tok'

			// next token, if any, should be \
			gettoken tok mv : mv, parse("=\")
			if !inlist(`"`tok'"', "", "\") {
				Error 198 /*
				*/ `"`tok' found, where \ expected"'
			}
			gettoken tok mv : mv, parse("=\")
		}
	}

	/*
		forvalues i = 1/`nlhs' {
			di in gr `"[`i'] `lhs`i'' -> `rhs`i''"'
		}
	*/

	// apply rules

	tempname nmv
	foreach var of local varlist {
		capt confirm string var `var'
		if !_rc {
			di as txt %12s abbrev(`"`var'"',12) ":" ///
			   _col(15) `"string variable ignored"'
			continue
		}

		local ty : type `var'
		qui count if `touse' & missing(`var')
		scalar `nmv' = r(N)
		forvalues rule = 1/`nlhs' {
			foreach value of local lhs`rule' {
				if "`ty'" == "float" {
					local value float(`value')
				}
				qui replace `var' = `rhs`rule'' ///
					if `touse' & `var'==`value'
			}
		}
		qui count  if `touse' & missing(`var')
		scalar `nmv' = r(N) - `nmv'
		if `nmv' > 0 {
			local s = cond(`nmv' > 1, "s", "")
			noi di as txt %12s abbrev(`"`var'"',12) ":" ///
			       as res _col(15) `nmv'                ///
			       as txt `" missing value`s' generated"'
		}
	}
end


/* MissCode s
   confirms that the string s is a valid missing value code (., .a, ..., .z)
*/
program define MissCode
	args s

	capt assert `"`s'"' == "." | ///
	            ( (length(`"`s'"')==2 & inrange(`"`s'"',".a",".z")) )
	if _rc {
		di as err `"`s' is not a missing value code"'
		exit 198
	}
end


/* Error nr txt
   displays error message txt and exit with nr
*/
program define Error
	args nr txt

	di as err `"`txt'"'
	exit `nr'
end
exit

HISTORY

4.0.4  fix for string variables & rule separator
4.0.1  code polish
4.0.0  totally new version, dealing with extended missing values
3.3.1  singular/plural fix in report on #mv's
3.3.0  mv() may now be a numlist
