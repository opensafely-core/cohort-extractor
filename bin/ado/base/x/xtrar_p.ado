*! version 1.0.7  30nov2018
program define xtrar_p, sortpreserve
	version 7.0, missing
	syntax newvarname [if] [in] , [XB U E UE]

	tempname touse
	mark `touse' `if' `in'

	tempvar touse2
	gen byte `touse2' = e(sample) 

	local stat "`xb'`u'`e'`ue'"

	if "`stat'"=="" {
		local stat "xb"
		version 16: display as text ///
			"(option {bf:xb} assumed; fitted values)"
	}

	if "`stat'"!="xb" & "`stat'"!="u" & "`stat'"!="e" & "`stat'" !="ue"  {
		di as err "you can only predict one statistic at a time"
		exit 198 
	}

	if "`stat'"=="xb" {
		_predict `typlist' `varlist' if `touse'
	}	

	if "`stat'"=="ue" {
		tempname xb
		qui _predict double `xb' if `touse'
		gen `typlist' `varlist'=`e(depvar)'-`xb' if `touse'
	}	

	if "`stat'"=="u" {
		
		mku `typlist' `varlist'

		qui count if `varlist'>=.
		if r(N)>0 {
		 	di as txt "(" r(N) " missing values generated) "
		}
		
		exit
	}	


	if "`stat'"=="e" {
		tempname xb xb_m dep_m u Ti

		qui _predict double `xb' if e(sample)

		mku double `u'
		
		qui gen `typlist' `varlist'=`e(depvar)'-`xb'-`u'
		qui count if `varlist'>=.
		if r(N)>0 {
		 	di as txt "(" r(N) " missing values generated) "
		}
	}
end	

program define mku
	version 7.0
	syntax newvarname 
	
	tempname xb xb_m Ti dep_m rho lxb dep ldep
	qui _predict double `xb' if e(sample) 
	qui sort `e(ivar)' `e(tvar)'
	qui scalar `rho'=e(rho_ar)
	qui gen double `lxb'=l.`xb'	
	qui replace `xb'=`xb'-`rho'*`lxb'
	qui by `e(ivar)': gen `xb_m'=sum(`xb')
	qui gen `Ti'=( `xb' <. )
	qui by `e(ivar)': replace `Ti'=sum(`Ti') 

	qui by `e(ivar)': replace `xb_m' = `xb_m'[_N]/`Ti'[_N] 
	qui replace `xb_m' = .  if `xb' >=. 

	gen double `dep'=`e(depvar)' if e(sample)
	gen double `ldep'=l.`dep'
	qui replace `dep' = `dep'-`rho'*`ldep' 
	qui by `e(ivar)': gen `dep_m'=sum(`dep')
	qui by `e(ivar)': replace `dep_m'=`dep_m'[_N]/`Ti'[_N] 
	qui replace `dep_m' = .  if `xb' >=. 

	qui gen double `varlist'=(`dep_m'-`xb_m')/(1-`rho') 
end	

