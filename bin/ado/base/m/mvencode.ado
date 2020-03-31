*! version 4.0.5  01oct2004
program define mvencode
	version 8, missing
	syntax varlist [if] [in], MV(str) [ Override ]

	marksample touse, novarlist
	quietly count if `touse'
	if r(N) == 0 {
		exit
	}

	/*
		parse the rules into

		n            #rules
		lhs<n>       mv type, condition part of rule <n>
		rhs<n>       numeric value, action part of rule <n>

		else_rule    #  numeric value for "all other mv types"
	*/

	local spec `"`mv'"'
	capt confirm number `spec'
	if !_rc {
		local n 0
		local else_rule `spec'
	}
	else {
		local n 0
		gettoken tok spec : spec, parse(" =\")
		while `"`tok'"' != "" & `"`tok'"' != "else" {
			local ++n
			ConfirmMissCode `tok'
			local lhs`n' `tok'

			gettoken tok spec : spec, parse(" =\")
			if `"`tok'"' != "=" {
				Error 198 "= expected"
			}

			gettoken tok spec : spec, parse(" =\")
			confirm number `tok'
			local rhs`n' `tok'

			gettoken tok spec : spec, parse(" =\")
			if !inlist(`"`tok'"', "", "\") {
				Error 198 `"`tok' found, where \ expected"'
			}
			gettoken tok spec : spec, parse(" =\")
		}

		if `"`tok'"' == "else" {
			gettoken tok spec : spec, parse(" =\")
			if `"`tok'"' != "=" {
				Error 198 "= expected"
			}

			gettoken tok spec : spec, parse(" =\")
			confirm number `tok'
			local else_rule `tok'

			if `"`spec'"' != "" {
				Error 198 `"`spec' found, where nothing expected"'
			}
		}
	}

	/*
		forvalues i = 1/`n' {
			di as txt "[`i'] `lhs`i''  -->  `rhs`i''"
		}
		di as txt "[else] `else_rule'"
	*/


	// check whether new values already exist in data

	if "`override'" == "" {
		local newvalues `else_rule'
		forvalues i = 1/`n' {
			local newvalues `newvalues' `rhs`i''
		}

		foreach var of local varlist {
			capt confirm string var `var'
			if _rc == 0 {
				di as txt %12s abbrev(`"`var'"',12) ":" ///
				   _col(15) `"string variable ignored"'
				continue
			}

			foreach value of local newvalues {
				qui count if `var'==`value' & `touse'==1
				if r(N) > 0 {
					di as txt %12s abbrev("`var'",12) ":" ///
					   _col(15) "already `value' in "     ///
					   as res %4.0f r(N) " " as txt       ///
					   plural(r(N),"observation")
					local bad "yes"
				}
			}
		}
		if "`bad'" == "yes" {
			Error 9 "no action taken"
		}
	}


	// apply the rules

	tempname nch
	foreach var of local varlist {
		capt confirm string var `var'
		if _rc == 0 {
			continue
		}

		local vtype : type `var'
		scalar `nch' = 0

		forvalues rule = 1/`n' {
			qui count if `touse' & `var'==`lhs`rule''
			if r(N) > 0 {
				scalar `nch' = `nch' + r(N)
				qui replace `var' = `rhs`rule'' ///
				    if `touse' & `var'==`lhs`rule''
			}
		}
		if "`else_rule'" != "" {
			qui count if `touse' & missing(`var')
			if r(N) > 0 {
				scalar `nch' = `nch' + r(N)
				qui replace `var' = `else_rule' ///
				    if `touse' & missing(`var')
			}
		}

		if `nch' > 0 {
			local s = cond(`nch'>1, "s", "")
			di as txt %12s abbrev("`var'",12) ":" /*
			   */ _col(15) as res `nch' /*
			   */ as txt " missing value`s' recoded"
		}

		local newvtype : type `var'
		if "`vtype'" != "`newvtype'" {
			di in txt _col(15) "(recast to `newvtype')"
		}
	}
end


/* ConfirmMissCode s
   confirms that the string s is a valid missing value code (., .a, ..., .z)
*/
program define ConfirmMissCode
	args s

	capt assert `"`s'"' == "." | ///
		( (length(`"`s'"')==2 & inrange(`"`s'"',".a",".z")) )
	if _rc {
		Error 198 `"`s' is not a missing value code"'
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
4.0.4  change in rule-separator
4.0.1  code polish
4.0.0  totally new version, dealing with extended missing values
3.1.0  ported to version7
       fixed singular/plural messages
