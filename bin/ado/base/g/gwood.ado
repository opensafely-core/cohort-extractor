*! version 3.1.2  03/01/93 updated 09sep2002
program define gwood
	ChkVer
	version 3.1
	local options "Title(string) BY(string) YLAbel(string) *"
	local varlist "req ex min(2) max(2)"
	local if "opt"
	local in "opt"
	parse "`*'"
	parse "`varlist'", parse(" ")
	if "`ylabel'"=="" { local ylabel "ylab(0,.25,.5,.75,1)" }
	else if "`ylabel'"=="." { local ylabel "ylab" } 
	else local ylabel "ylab(`ylabel')"

	if "`title'"=="" {
		local title /*
		*/ "Kaplan-Meier Survival with Greenwood Confidence Limits"
	}

	tempvar lci uci
	preserve

	quietly {
		if "`by'"!="" {
			local byy "by(`by')"
			drop if `by'==.
		}
		if "`if'`in'"~="" {
			keep `if' `in'
		}
		keep `1' `2' `by'
		_crcsrvc `1' `2' `by'
		replace _vlogs = exp(1.96*sqrt(_vlogs/log(_surv)^2))
		gen  `lci' = _surv^(1/_vlogs)
		label var `lci' "Lower Confidence Limits"
		gen  `uci' = _surv^_vlogs
		label var `uci' "Upper Confidence Limits"
		format _surv %9.2f
		noisily /*
		*/ gr7 _surv `uci' `lci' `1', s(oii) c(JJJ) ti("`title'")  /*
		*/  xsca(0,.) `ylabel' `options' `byy'
	}
end

program define ChkVer
	quietly version 
	if _result(1)<5 { exit }
	version 5.0
	#delimit ;
	di in ye "gwood" in gr 
	" is an out-of-date command.  Its replacement is " in ye "sts"
	in gr "." _n(2) in ye "gwood" 
	in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "gwood" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "sts"  in gr "." ;
	#delimit cr
	exit 199
end
exit

gwood is an out-of-date command.  Its replacement is sts.  

gwood will, however, work:

	. version 4.0
	. gwood ...
	. version 5.0

Better is to see help sts.
r(199);
