*! version 1.1.0  15feb2007
program define xt_tis, sclass /* [varname] */
	version 6.0
	sret clear 
	if `"`*'"'=="" {
		sret local timevar : char _dta[tis]
		global S_1 `s(timevar)'     /* double save in s() and S_1 */
		if `"`s(timevar)'"'=="" {
			di in red "t() required"
			exit 198
		}
		exit
	}
	syntax varname
	if "`_dta[tis]'" == "`varlist'" { 
        	sret local timevar "`_dta[tis]'"
		global S_1 `s(timevar)'
		exit
	}

	if "`_dta[_TStvar]'" != "" { 
		di in red /*
*/ "time and panel variables previously xtset -- may not be changed by"
		di in red /* 
*/ "options t() and i() -- use xtset to change them"
		exit 198
	}

	tis `*'
	sret clear
        sret local timevar : char _dta[tis]
	global S_1 `s(timevar)'             /* double save in s() and S_1 */
end
