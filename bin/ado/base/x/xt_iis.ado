*! version 1.1.0  15feb2007
program define xt_iis /* [varname] */, sclass 
	version 6.0
	sret clear 
	if `"`*'"'=="" {
		sret local ivar : char _dta[iis]
		global S_1 `s(ivar)'		/* double saves */
		if `"`s(ivar)'"'=="" {
			di in red "i() required"
			exit 198
		}
		exit
	}
	syntax varname
	if "`_dta[iis]'" == "`varlist'" { 
		sret local ivar : char _dta[iis]
		global S_1 `s(ivar)'
		exit
	}
	if "`_dta[_TStvar]'" != "" { 
		di in red /*
*/ "time and panel variables previously xtset -- may not be changed by"
		di in red /* 
*/ "options t() and i() -- use xtset to change them"
		exit 198
	}

	iis `*'
	sret local ivar : char _dta[iis]
	global S_1 `s(ivar)'			/* double saves */
end
