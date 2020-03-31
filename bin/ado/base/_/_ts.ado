*! version 1.1.2  17dec2014
program define _ts
	version 6, missing

						/* set callers time and
						 * possibly panel macros */
	gettoken tok : 0, parse(" ,")
	if "`tok'" != "," & "`tok'" != "" { 
		gettoken tmac 0 : 0, parse(" ,")
		c_local `tmac' "`_dta[_TStvar]'"
		gettoken tok : 0, parse(" ,") 
		if "`tok'" != "," & "`tok'" != "" { 
			gettoken pmac 0 : 0, parse(" ,")
			c_local `pmac' "`_dta[_TSpanel]'"
		}
	}

						/* check error conditions */
	syntax [if] [in] [, Sort Panel Onepanel] 

	if "`_dta[_TStvar]'" == "" {
		di in smcl in red ///
		"time variable not set, use {bf:tsset varname ...}"
		exit 111
	}

	if "`_dta[_TSpanel]'"!="" & "`panel'"=="" & "`onepanel'"=="" {
		di in red "command may not be used with panel data"
		exit 459
	}

	if "`sort'"!="" { 
		qui sort `_dta[_TSpanel]' `_dta[_TStvar]'
	}

	if "`_dta[_TSpanel]'"!="" & "`panel'"=="" & "`onepanel'"!="" {
		sum `_dta[_TSpanel]' `if' `in' , meanonly
		if r(min) != r(max) {
			di in red "sample may not include multiple panels"
			exit 459
		}
	}
end
exit
