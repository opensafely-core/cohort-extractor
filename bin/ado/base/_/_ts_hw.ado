*! version 1.3.1  19feb2019
program define _ts_hw, rclass byable(recall, noheader)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 8.1

/* syntax is _ts_hw type new old, a(real in [0,1]) touse(byte varname)
	s0samp(integer) fcast(integer) s10(real) s20(real) diff noLog
	init(numlist) 

This is the work program for Holt-Winters Non-Seasonal 
forecasting
*/
	gettoken vars left : 0 , parse(",") 
	tokenize `vars'
	local type "`1'"
	local newvar "`2'"
	local oldvar "`3'"

	local 0 "`left'"
	syntax , touse(varlist)	 			/*
		*/ a(string) 				/*
		*/ [ s0samp(string) 			/*
		*/ fcast(string) 			/*
		*/ NOLOg LOg				/*
		*/ init(numlist max=2 min=2 >0 <1)	/*
		*/ s10(string) 				/*
		*/ s20(string) 				/*
		*/ noDIsplay				/*
		*/ diff					/*
		*/ * ]
	

	if "`display'" != "" {
		local log nolog
	}	

	mlopts mlopts, `options' `log' `nolog'

	if "`init'" != "" {
		tokenize `init'
		local y1 = ln(`1') - ln1m(`1')
		local y2 = ln(`2') - ln1m(`2')
		local init2 "init( `y1' `y2' , copy) "
		local init3 "init( T_p1=`y1', T_p2=`y2' ) "
	}
	tokenize `a'
	capture confirm number `1'
	if _rc >0 {
		local 0, `a'
		syntax , [opt ]
		if "`opt'" == "" {
			di as err "specify smoothing parameters, " /*
				*/ "opt in hwsa()"
			drop `varlist'
			exit 198
		}	
	}	
	else {
		local 0 ", a(`a')"
		local atmp "`a'"
		capture syntax , a(numlist min=2 max=2 >=0 <=1)
		if _rc > 0 {
			di as err "hw(`atmp') invalid "
			exit 198
		}
		tokenize `a'
		local alpha = `1'
		local beta  = `2'
	}

	local 0 " `newvar', oldvar(`oldvar')" 
	syntax varname , oldvar(varname)  


	tempvar touse2
	if _by() {
		qui gen byte `touse2'=(`touse' & `_byindex' == _byindex() )
	}	
	else {
		qui gen byte `touse2'=`touse' 
	}

	qui count if `touse2' ==1 
	if r(N)==0 {
		exit 
	}	

	tempvar bcount
	qui gen `bcount' = (`oldvar' < . & `touse2' )
	qui replace `bcount' = sum(`bcount')
	qui replace `touse2' = `touse2' & `bcount' > 0

	if "`fcast'" != "" {
		capture confirm integer number `fcast'
		if _rc > 0 {
			di as err "fcast() must specify a positive integer"
			drop `varlist'
			exit 198
		}	
		if `fcast' < 0 {
			di as err "fcast() must specify a positive integer"
			drop `varlist'
			exit 198
		}	
		local fcastmac " fcast(`fcast') "
	}
	else {
		local fcast 0
	}
/* check that data is tsset */

	qui tsset, noquery
	local tvar `r(timevar)'

	if "`r(panelvar)'" != "" {
		local pvar "`r(panelvar)'"
		local panel "panel"
		qui sum `pvar' if `touse2'
		if r(max) > r(min) {
			di as err  "_ts_hwm only works on one " /*
				*/ "panel at a time"			
			drop `varlist'
			exit 198	
		}
		local panelid = r(max)
		di
		di as txt "{hline}"
		di as txt "-> `pvar' = `panelid'"
	}

	sort `pvar' `tvar'

	tempvar obs
	tempvar  ob ob1 obN

	qui gen `obs'=_n if `touse2'
	
	qui sum `obs'
	local first =r(min)
	local last =r(max)

	tempvar s1 j obsnum j
	tempname lastx lastin firstin
	
	sort `pvar' `tvar' 

	qui gen `j'=1 if `touse2'
	qui replace `j' = sum(`j') if `touse2'

	qui qui gen `obsnum' = _n
	if "`panel'" != "" {
		qui sum `obsnum' if `pvar'==`panelid'
	}
	else {
		qui sum `obsnum' 
	}
	scalar `lastx' = r(max)                          /* this is the ob
							  * number of last ob
							  * that exists in 
							  * panel in touse2 
							  * sample 
							  */
	qui sum `obsnum' if `touse2' & `oldvar' < . 
	
	scalar `firstin' = r(min)
	scalar `lastin'  = r(max)
	
						/* firstin is ob number of
						 * first ob in touse2 sample
						 * lastin is ob number of last
						 * ob in touse2 sample 
						 */

						/* compute starting values 
						 * or use s10 and s20 
						 */


	tempname a0_0 b1_0

	tempname s01 s02
	tempvar s2

	if "`s10'`s20'" != "" {
		scalar `a0_0'= `s10'
		scalar `b1_0'= `s20'
	}
	else {
		if "`diff'" != "" {
			tempvar bcount2
			qui gen `bcount2' = (d.`oldvar' < . & `touse2' )
			qui replace `bcount2' = sum(`bcount2')

			if "`s0samp'" != "" {
				qui sum d.`oldvar' /*
					*/ if `bcount2' <=  `s0samp' & `touse2'
			}
			else {
				local s0samp = int(.5*(`lastin'-`firstin'+1 ) ) 
				qui sum d.`oldvar'  /*
					*/ if `bcount2' <=  `s0samp'  & `touse2'
			}
			scalar `b1_0' = r(mean)
			scalar `a0_0' = `oldvar'[`firstin'] - `b1_0'
		}
		else {
			if "`s0samp'" != "" {
				qui regress `oldvar' `j' /* 
					*/ if `bcount' <=  `s0samp' & `touse2'
			}
			else {
				local s0samp = int(.5*(`lastin'-`firstin'+1 ) ) 
				qui regress `oldvar' `j' /*
					*/ if `bcount' <=  `s0samp'  & `touse2'
			}
			scalar `a0_0' = _b[_cons]
			scalar `b1_0' = _b[`j']
		}
	}

/* do opt here */
	if "`opt'" != "" {
		
		if "`display'" == "" {
			di as txt "computing optimal weights"
		}	

		tempname oldest
		capture _est hold `oldest', restore


		_hw_ml `oldvar' if `touse2' & _n<=`lastin' 	/*
			*/ , a0(`a0_0') 			/*
			*/ b1(`b1_0') `init2'		/*
			*/ first(`firstin') last(`lastin')	/*
			*/ `mlopts'
		
		tempname eb prss
		mat `eb' = e(b)

		local alpha = `eb'[1,1]
		local beta  = `eb'[1,2]
		
		scalar `prss' = e(prss)

		if "`display'" == "" {
			di 
			di as txt "Optimal weights:" 
			di as txt _col(30) "alpha = " as res %5.4f `alpha'
			di as txt _col(31) "beta = " as res %5.4f `beta'
			di  as txt "penalized sum-of-squared residuals = " /*
				*/ as res %-9.7g e(prss) 
			di  as txt _col(11) "sum-of-squared residuals = " /*
				*/ as res %-9.7g e(rss) 
			di as txt _col(12) "root mean squared error = " /*
				*/ as res %-9.7g e(rmse)
		}		

	}


/* begin compute new */

	local firstinl = `firstin' 
	local lastinl = `lastin' 
	local a0l      = `a0_0'
	local b1l      = `b1_0'


	qui _hw_comp `varlist', oldvar(`oldvar') alpha(`alpha') 	/*
		*/ beta(`beta') a0i(`a0_0') b0i(`b1_0') 		/*
		*/ firstin(`firstinl') replace /*
		*/ lastin(`lastinl')

/* end compute new */		

/* save off final values for prediction */

	tempname a0T b1T

	scalar `a0T' = r(aT)
	scalar `b1T' = r(bT)

	tempname linear constant
	tempvar tau err err2

	qui gen `tau'=_n - `lastin'

	qui replace `varlist' = (`a0T'+`b1T'*`tau')  /*
		*/ if _n > `lastin' & _n <= `lastin' + `fcast'

	qui gen double `err'=`oldvar'-`varlist' if `touse2'
	qui gen `err2'=`err'^2 if `touse2'

	qui sum `err2' if `touse2'

	
	local rssd 		= r(sum)
	local rmsed 		=sqrt(r(mean))

	if "`opt'" != "" {
		ret scalar prss = `prss'
	}	
	ret scalar N 		= r(N)
	ret scalar rss		= r(sum)
	ret scalar rmse		= sqrt(r(mean))
	ret scalar constant 	= `a0T'
	ret scalar linear 	= `b1T'
	ret scalar s1_0   	= `a0_0' 
	ret scalar s2_0   	= `b1_0' 
	if "`s0samp'" != "" {
		ret scalar N_pre  = `s0samp'
	}
	return scalar alpha    	= `alpha'
	return scalar beta    	= `beta'

	local alpha : display %4.3f `alpha'
	local beta : display %4.3f `beta'
	local vlab : variable label `oldvar'
	label variable `varlist' "hw parms(`alpha' `beta') `vlab'"

	if "`display'" == "" & "`opt'" == "" {
		di 
		di as txt "Specified weights:" 
		di as txt _col(20) "alpha = " as res %5.4f `alpha'
		di as txt _col(21) "beta = " as res %5.4f `beta'
		di  as txt "sum-of-squared residuals = " /*
			*/ as res %-9.7g `rssd' 
		di as txt " root mean squared error = " /*
			*/ as res %-9.7g `rmsed'
	}		
	
end


/* this program will find optimal smoothing parameters */

program define _hw_ml, eclass 
	version 8.0

	syntax varname if , 			/*
		*/ a0(string) 			/*
		*/ b1(string)			/*
		*/ init(passthru) 		/*
		*/ first(string) 		/*
		*/ last(string)			/*
		*/ [				/*
		*/ *	]

	mlopts mlopts, `options'	

	/* syntax is name of oldvar 
		if statement ,
		a0(name of scalar that holds a0_0)
		b1(name of scalar that holds b0_0)
		other options
	*/
	
	global T_oldvar  "`varlist'"
	global T_firstin = `first'
	global T_lastin = `last'

	tempvar touse new err

	mark `touse' `if'

	global T_touse "`touse'"

	tempname b V rss rmse prss alpha beta
	
	global T_a0  `a0'
	global T_b1  `b1'

	`vv' ///
	ml model d0 _hw_opt_d0 (alpha: `varlist' = ) /beta  if `touse' /*
		*/, `init'  max noout		 			/*
		*/ search(off) nopreserve				/*
		*/ crittype("penalized RSS")	`mlopts'

	mat `b' = e(b)
	mat `V' = e(V)

	mat `b'[1,1] = 1/(1+exp(-1*`b'[1,1]))
	mat `b'[1,2] = 1/(1+exp(-1*`b'[1,2]))

	scalar `alpha' = `b'[1,1]
	scalar `beta'  = `b'[1,2]

	scalar `prss' = -1*e(ll)

	qui _hw_comp `new', oldvar($T_oldvar) alpha(`alpha') 	/*
		*/ beta(`beta') a0i($T_a0) b0i($T_b1) 		/*
		*/ firstin($T_firstin) lastin($T_lastin)  
	
	qui gen double `err' = ($T_oldvar - `new')^2 if $T_touse
	qui sum `err' if $T_touse 

	scalar `rss' = r(sum)
	scalar `rmse' = sqrt(r(mean)) 

	eret post `b' `V'	

	eret scalar prss = `prss'
	eret scalar rss = `rss'
	eret scalar rmse = `rmse'

	macro drop T_oldvar T_firstin T_lastin T_touse T_a0 T_b1

end

exit 
	
/* global use to pass information to likelihood evaluator 	

	T_oldvar 	: name of variable that holds series to smoothed
	T_firstin 	: first observation in sample
	T_lastin 	: last observation in sample
	T_touse 	: touse variable 
	T_a0  		: starting value for a0, constant, series
	T_b1  		: starting value for b1, linear, series

*/
