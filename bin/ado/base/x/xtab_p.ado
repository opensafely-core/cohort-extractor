*! version 1.0.4  30sep2004
program define xtab_p
	version 7.0, missing
        syntax newvarname [if] [in] , [XB  E ]

	tempname touse
	mark `touse' `if' `in'

	local stat "`xb'`e'"
	
	if "`stat'"=="" {
		local stat "xb"
	}

	if "`stat'"!="xb" & "`stat'"!="e"  {
		di as err "you can only predict one statistic at a time"
		exit 198 
	}


	if "`stat'"=="xb" {
		_predict `typlist' `varlist' if `touse'
	}	

	if "`stat'"=="e" {
		tempname xb
		qui _predict double `xb' if `touse'
		gen `typlist' `varlist'=`e(depvar)'-`xb' if `touse'
	}	

end	
