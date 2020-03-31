*! version 1.0.4  30nov2018
program define xtivp_1, sortpreserve
	version 7.0, missing
        syntax newvarname [if] [in] , [XB  E U UE XBU ]

	tempname touse
	mark `touse' `if' `in'

	local stat "`xb'`e'`u'`ue'`xbu'"
	
	if "`stat'"=="" {
		local stat "xb"
		di as txt "(option {bf:xb} assumed; fitted values)"
	}

	if "`stat'"!="xb" & "`stat'"!="e" & "`stat'" != "u" & /* 
		*/ "`stat'" != "ue" &  "`stat'" != "xbu"  { 
		di as err "you can only predict one statistic at a time"
		exit 198 
	}


	if "`stat'"=="xb" {
		_predict `typlist' `varlist' if `touse'
		exit
	}	

	if "`stat'"=="ue" {
		tempname xb
		qui _predict double `xb' if `touse'
		qui gen `typlist' `varlist'=`e(depvar)'-`xb' if `touse'
		label variable `varlist' "u[idcode] + e[idcode,t]"
		exit
	}	

	if "`stat'"=="u" {
		
		qui mku `typlist' `varlist' 
		label variable `varlist' "u[idcode]"
		exit
	}	

	if "`stat'"=="e" {
		tempname u dep xb
		qui mku double `u'
		qui _predict double `xb' if `touse'
		qui gen `typlist' `varlist'=`e(depvar)'-`xb'-`u'
		label variable `varlist' "e[idcode,t]"	
		exit
	}	

	if "`stat'"=="xbu" {
		sort `e(ivar)' `e(tvar)'
		tempname xb xb_m Ti dep_m u
		qui _predict double `xb' if e(sample) 
		
		qui mku double `u'
		qui gen `typlist' `varlist'=`xb' + `u'
		label variable `varlist' "Xb + u[idcode]"
		exit
	}	

	di as err "statistic requested not recognized"
	exit 198

end	


program define mku
	syntax newvarname
		sort `e(ivar)' `e(tvar)'
		tempname xb xb_m Ti dep dep_m u t
		qui _predict double `xb' if e(sample) 
		qui by `e(ivar)': gen `xb_m'=sum(`xb')
		qui gen int `t'=( e(sample) )
		qui by `e(ivar)': gen `Ti'=sum(`t') 
		
		qui by `e(ivar)': replace `xb_m' = `xb_m'[_N]/`Ti'[_N] 
		replace `xb_m'=. if !e(sample)

		qui gen double `dep' = `e(depvar)' if e(sample)
		qui by `e(ivar)': gen double `dep_m'=sum(`dep')
		qui by `e(ivar)': replace `dep_m'=`dep_m'[_N]/`Ti'[_N] 
		replace `dep_m'=. if !e(sample)

		qui gen `typlist' `varlist'=`dep_m'-`xb_m' 
end		
