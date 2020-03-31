*! version 1.4.0  30mar2018
program define _ts_hwsa, rclass byable(recall, noheader)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 8.1

/* syntax is _ts_hwsa type new old, a(real in [0,1]) touse(byte varname)
	s0samp(integer) fcast(integer) s10(real) s20(real) init(numlist) 
	sn0_0(varname) sn0_v(newvarname) noLog snt_v(newvarname)

This is the work program for Holt-Winters Seasonal Additive forecasting
*/
	gettoken vars left : 0 , parse(",") 
	tokenize `vars'
	local type "`1'"
	local newvar "`2'"
	local oldvar "`3'"

	
	local 0 "`left'"
	syntax , touse(varlist) 			/*
		*/ a(string) 				/*
		*/ period(integer)  			/*
		*/ init(numlist max=3 min=3 >0 <1) 	/*
		*/ [ s0samp(string) 			/*
		*/ fcast(string) 			/*
		*/ sn0_v(string) 			/*
		*/ s10(string) 				/*
		*/ s20(string) 				/*
		*/ sn0_0(varname) 			/*
		*/ snt_v(string)			/*
		*/ ALTstarts 				/*
		*/ Normalize 				/*
		*/ noDISplay				/*
		*/ * ]
		
	mlopts mlopts, `options'		

	if "`sn0_v'" != "" {
		confirm new variable `sn0_v'
	}	
		
	if "`snt_v'" != "" {
		confirm new variable `snt_v'
	}	


	local i = 1
	foreach x of local init {
		local y = ln(`x') - ln(1-`x')
		local init2 "`init2' `y' "
		if `i' < 3 {
			local init3 "`init3' T_p`i'=`y', "
		} 
		else {
			local init3 "`init3' T_p`i'=`y' "
		}
		local i = `i' + 1
	}
	local init2 "init( `init2' , copy) "
	local init3 "init( `init3' ) "


	tokenize `a'
	capture confirm number `1'
	if _rc >0 {
		local 0, `a'
		syntax , [opt optnl]
		if "`opt'`optnl'" == "" {
			di as err "specify smoothing parameters, " /*
				*/ "opt or optnl in hwsa()"
			drop `varlist'
			exit 198
		}	
	}	
	else {
		local 0 ", a(`a')"
		syntax , a(numlist min=3 max=3 >=0 <=1)
		tokenize `a'
		local alpha = `1'
		local beta  = `2'
		local gamma = `3'
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
			di as err  "_ts_hwms only works on one " /*
				*/ "panel at a time"			
			drop `varlist'
			exit 198	
		}
		local panelid = r(max)
		if _by() {
			di
			di as txt "{hline}"
			di as txt "-> `pvar' = `panelid'"
		}	
	}

	sort `pvar' `tvar'

	tempvar s1 j obsnum j
	tempname lastx lastin firstin
	
	tempvar m l  
	tempname M 

/* make season l and year m  */

	qui gen int `j'=1 if `touse2'
	qui replace `j' = sum(`j') if `touse2'
	qui replace `j' = . if !`touse2'

	qui gen int `m' = int( (`j'-1)/`period' +1 ) if `touse2'
	sort `m' `tvar' `touse2'
	qui by `m': gen int `l'=_n if `touse2'

	qui sum `m' if `touse2' & `oldvar' <. 
	local tseas = r(max)

	if "`s0samp'"  == "" {
		local s0samp = max(int(`tseas'/2),2)
	}

	if `s0samp' > `tseas' {
		di as err "there are `tseas' in sample which is smaller "/*
			*/ "than the `s0samp' specified in s0samp()"
		drop `varlist'
		exit 198
	}	


	sort `pvar' `tvar'
		
/* do regression with seasonal dummies for a0, b1, and St 
 * starting values
 */

	tempname a0_0 b1_0

	if "`s10'`s20'" == "" | "`sn0_0'" == "" {
		tempname dstub
		qui tab `l' , gen(`dstub')
		if int(r(r)) != `period' {
			di as err "number of seasons differs from number" /*
				*/ " of periods"
			drop `varlist'
			exit 198
		}	

		if "`altstarts'" == "" {
			qui regress `oldvar' `j' `dstub'2-`dstub'`period' /*
				*/ if `m' <= `s0samp'  /*
				*/  & `touse2'
			if e(N) <= `period' {
				di as err "sample for starting value " /*
					*/ "regression is too small"
				di as err "specify a larger samp0() or " /*
					*/ provide starting values"
			}		
			if "`s10'`s20'" == "" {
				scalar `b1_0'	= _b[`j'] 
				scalar `a0_0'	= _b[_cons] 
			}
			if "`sn0_0'" == "" {
				tempvar sn_bar snt_sum sn0 St
		
				qui gen double `sn0' =0 if `m'==1 & `l'==1

				forvalues i=2(1)`period' {
					qui replace `sn0'=_b[`dstub'`i'] /*
						*/ if `m' == 1  & `l'==`i' 
				}
			}

		}		
		else {
			if "`s10'`s20'" == "" {
				qui regress `oldvar' `j' if `m' <= `s0samp'  /*
					*/  & `touse2'
				scalar `b1_0'	= _b[`j'] 
				scalar `a0_0'	= _b[_cons] 
			}
			if "`sn0_0'" == "" {
				tempvar sn_bar snt_sum sn0 St old_d
				
				qui sum `oldvar' if `m'<=`s0samp' & 	/*
					*/ `touse2'
				qui gen double `old_d' = 		/*
					*/ `oldvar' -r(mean) if 	/*
					*/ `m' <= `s0samp' & `touse2'
				
				qui regress `old_d' `dstub'1-`dstub'`period' /*
					*/ if `m' <= `s0samp'  /*
					*/  & `touse2', nocons

				qui gen double `sn0' =_b[`dstub'1] 	/*
					*/ if `m'==1 & `l'==1

				forvalues i=2(1)`period' {
					qui replace `sn0'=_b[`dstub'`i'] /*
						*/ if `m' == 1  & `l'==`i' 
				}
			}
			
		}
		
	}	
	
	scalar `M' = `s0samp'
	

	
	
				/* compute starting values or use 
					s10 and s20 */

	if "`s10'`s20'" != "" {
		scalar `a0_0'= `s10'
		scalar `b1_0'= `s20'
	}

	if "`sn0_0'" != "" {
		tempvar sn0 
		qui gen double `sn0' = `sn0_0'
	}

	qui count if `sn0' >=. & `m'==1 & `touse2'
	if r(N) > 0 {
		di as err "{p 0 4}At least one observation of the "/*
			*/ "seasonal starting value variable " /*
			*/ "is missing{p_end}"
		di as err "{p 0 4}missing is not a valid value in "/*
			*/ "the seasonal starting value variable{p_end}"
		exit 498	
	}
	
	qui gen `obsnum' = _n
	qui sum `obsnum' if `touse2'  & `oldvar' < .
	
	scalar `firstin' = r(min)
	scalar `lastin'  = r(max)
	
						/* firstin is ob number of
						first ob in touse2 sample
						lastin is ob number of last
						ob in touse2 sample */


/* Find optimal parameters */
	

	if "`opt'" != "" {
		if "`display'" == "" {
			di as txt "computing optimal weights"
		}	
		else {
			local qui qui
		}

		tempname oldest
		capture _est hold `oldest', restore

		tempname temp_sm

		local a0_0r = `a0_0'
		local b1_0r = `b1_0'
		
		`qui' _hwsa_ml `oldvar' if `touse2'  & _n <= `lastin' 	/*
			*/ , a0_0(`a0_0r') 				/*
			*/ b1_0(`b1_0r') `init2' 			/*
			*/ period(`period') sn0(`sn0')			/*
			*/ first(`firstin') mvar(`m')			/*
			*/ last(`lastin') `mlopts'
		
		tempname eb
		mat `eb' = e(b)

		local alpha = `eb'[1,1]
		local beta  = `eb'[1,2]
		local gamma = `eb'[1,3]

		local prss  = e(prss)

		if "`display'" == "" {
			di 
			di as txt "Optimal weights:" 
			di as txt _col(30) "alpha = " as res %5.4f `alpha'
			di as txt _col(31) "beta = " as res %5.4f `beta'
			di as txt _col(30) "gamma = " as res %5.4f `gamma'
			di  as txt "penalized sum-of-squared residuals = " /*
				*/ as res  %-9.7g e(prss) 
			di  as txt _col(11) "sum-of-squared residuals = " /*
				*/ as res %-9.7g e(rss) 
			di as txt _col(11) " root mean squared error = " /*
				*/ as res %-9.7g e(rmse)
		}	

	}

	tempvar snt
	
	local a0i  `a0_0'
	local b1i  `b1_0'
	local firstinl = `firstin'
	local lastinl  = `lastin'

	_hwsa_comp `varlist' , oldvar(`oldvar') alpha(`alpha') 	/*
		*/ beta(`beta') gamma(`gamma') sn0(`sn0') a0i(`a0i') 	/*
		*/ b0i(`b1i') snt(`snt') firstin(`firstinl') 		/*
		*/ lastin(`lastinl') period(`period') m(`m') 		/*
		*/ pvar(`pvar') tvar(`tvar') replace `normalize'

	if "`sn0_v'" != "" {
		qui gen double `sn0_v'=`sn0'
	}

/* save off final values for prediction */

	tempname a0T b1T

	scalar `a0T' = r(a0T)
	scalar `b1T' = r(b1T)

	if "`snt_v'" != "" {
		qui gen double `snt_v'=`snt' if `m' == `tseas'
	}
		

	tempname linear constant
	tempvar tau err err2

	qui gen `tau'		= _n - `lastin'
	qui replace `snt' 	=  L`period'.`snt' /*
		*/ if _n > `lastin' & _n <= `lastin' + `fcast'

	qui replace `varlist' = (`a0T'+`b1T'*`tau') + L`period'.`snt'  /*
		*/ if _n > `lastin' & _n <= `lastin' + `fcast'

	

	qui gen double `err'=`oldvar'-`varlist' if `touse2'
	qui gen `err2'=`err'^2 if `touse2'

	qui sum `err2' if `touse2'

	ret scalar N 		= r(N)
	ret scalar rss		= r(sum)
	local rssd 		= r(sum)
	if "`opt'" != "" {
		ret scalar prss = `prss'
	}
	ret scalar rmse		= sqrt(r(mean))
	local rmsed		= sqrt(r(mean))
	ret scalar constant  	= `a0T'
	ret scalar linear 	= `b1T'
	ret scalar s1_0   	= `a0_0' 
	ret scalar s2_0   	= `b1_0' 
	if "`s0samp'" != "" {
		ret scalar N_pre  = `s0samp'
	}
	return scalar alpha	= `alpha'
	return scalar beta 	= `beta'
	return scalar gamma    	= `gamma'

	if "`display'" == "" & "`opt'" == ""  {
		di 
		di as txt "Specified weights:"
		di as txt _col(20) "alpha = " as res %5.4f `alpha'
		di as txt _col(21) "beta = " as res %5.4f `beta'
		di as txt _col(20) "gamma = " as res %5.4f `gamma'
		di  as txt "sum-of-squared residuals = " /*
			*/ as res %-9.7g `rssd' 
		di as txt " root mean squared error = " /*
			*/ as res %-9.7g `rmsed'
	}



	local alpha : display %4.3f `alpha'
	local beta : display %4.3f `beta'
	local gamma : display %4.3f `gamma'

	local vlab : variable label `oldvar'
	label variable `varlist' "shw-add parms(`alpha' `beta' `gamma') `vlab'"
	
end

program define _hwsa_ml, eclass 
	version 8.0
/* this program will find optimal smoothing parameters */

	syntax varname [if],				/*
		*/ a0_0(real) 				/*
		*/ b1_0(real) 				/*
		*/ sn0(varname) 			/*
		*/ period(integer) 			/*
		*/ init(passthru)			/*
		*/ first(string) 			/*
		*/ mvar(varname) 			/*
		*/ last(string) 			/*
		*/ [noDISplay 				/*
		*/  * ]

	mlopts mlopts , `options'

	/* syntax is name of oldvar 
		if statement ,
		a0_0 is real start value for a0
		b1_0 is real start value for b1
		sn0 is variable that holds starts for seasonals
	*/
	
	global T_a0 = `a0_0'
	global T_b1 = `b1_0'
	global T_sn0 = "`sn0'"
	global T_per = `period'
	global T_oldvar = "`varlist'" 
	global T_firstin = `first'
	global T_lastin = `last'
	global T_m  `mvar'

	tempvar touse

	mark `touse' `if'

	global T_touse "`touse'"

	tempname b V rss rmse prss alpha beta gamma
	tempvar err new

	if "`display'" != "" {
		local qui qui
	}	
		
	`vv' ///
	`qui' ml model d0 _hwsa_opt_d0 (alpha: `varlist' = ) /beta 	/*
		*/ /gamma if `touse', max 				/*
		*/ noout `init' search(off) 			/*
		*/ nopreserve `mlopts' crittype("penalized RSS")

	mat `b' = e(b)
	mat `V' = e(V)

	mat `b'[1,1] = exp(`b'[1,1])/(1+exp(`b'[1,1]))
	mat `b'[1,2] = exp(`b'[1,2])/(1+exp(`b'[1,2]))
	mat `b'[1,3] = exp(`b'[1,3])/(1+exp(`b'[1,3]))

	scalar `prss' = -1*e(ll)

	scalar `alpha' = `b'[1,1]
	scalar `beta'  = `b'[1,2]
	scalar `gamma' = `b'[1,3]

	qui _hwsa_comp `new', oldvar($T_oldvar) alpha(`alpha') 	/*
		*/ beta(`beta') gamma(`gamma') sn0($T_sn0) a0i($T_a0)	/*
		*/ b0i($T_b1) firstin($T_firstin) lastin($T_lastin)	/*
		*/ m($T_m) period($T_per) 

	qui gen double `err' = ($T_oldvar - `new')^2 if $T_touse
	qui sum `err'

	scalar `rss'  = r(sum)
	scalar `rmse' = sqrt(`rss'/e(N)) 

	eret post `b' `V'	

	eret scalar prss = `prss'
	eret scalar rss  = `rss'
	eret scalar rmse = `rmse'

	macro drop T_a0 T_b1 T_sn0 T_per T_oldvar T_firstin T_lastin 	/*
		*/ T_m T_touse 

end

exit 

/* globals used to pass information to likelihood evaluator

	
	T_a0 	  =  starting value for constant term a0
	T_b1 	  =  starting value for linear term b1
	T_sn0 	  =  name of variable that contains the starting values for 
		     the seasonals
	T_per 	  =  period of seasonality 
	T_oldvar  =  name of series to be smoothed
	T_firstin =  first observation in sample
	T_lastin  =  last observation in sample
	T_m 	  =  name of variable that holds years (mvar)
	T_touse   =  name of touse variable

*/

