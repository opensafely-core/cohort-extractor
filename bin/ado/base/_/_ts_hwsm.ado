*! version 1.4.0  30mar2018
program define _ts_hwsm, rclass byable(recall, noheader) 
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 8.1

/* syntax is _ts_hwsm type new old, a(real in [0,1]) touse(byte varname)
	s0samp(integer) fcast(integer) s10(real) s20(real) init(numlist) 
	sn0_0(varname) sn0_v(newvarname) snt_v(newvarname)

This is the work program for Holt-Winters Seasonal Multiplicative forecasting
*/
	gettoken vars left : 0 , parse(",") 
	tokenize `vars'
	local type "`1'"
	local newvar "`2'"
	local oldvar "`3'"

	
	local 0 "`left'"
	syntax , touse(varlist) 			/*
		*/ a(string) 				/*
		*/ period(integer) 			/*
		*/ init(numlist max=3 min=3 >0 <1) 	/*
		*/ [ s0samp(string) 			/*
		*/ fcast(string) 			/*
		*/ sn0_v(string) 			/*
		*/ noDIsplay				/*
		*/ s10(string) 				/*
		*/ s20(string) 				/*
		*/ sn0_0(varname) 			/*
		*/ snt_v(string) 			/*
		*/ Normalize 				/*
		*/ ALTstarts 				/*
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
		syntax , [ opt ]
		if "`opt'" == "" {
			di as err "specify smoothing parameters, " /*
				*/ " or opt"
			drop `varlist'
			exit 198
		}	

	}	
	else {
		local 0 ", a(`a')"
		local atmp "`a'"
		capture syntax , a(numlist min=3 max=3 >=0 <=1)
		if _rc > 0 {
			di as err "parms(`atmp') invalid "
			exit 198
		}
		tokenize `a'
		local alpha = `1'
		local beta  = `2'
		local gamma = `3'
	}

	local 0 " `newvar', oldvar(`oldvar')" 
	syntax varname , oldvar(varname)  


	tempvar touse_hlp

	qui gen `touse_hlp' = (`oldvar'<.)
	qui replace `touse_hlp' = sum(`touse_hlp')

	qui replace `touse' = `touse' & `touse_hlp' > 0
	
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
			di as err "forecast() must specify a positive integer"
			drop `varlist'
			exit 198
		}	
		if `fcast' < 0 {
			di as err "forecast() must specify a positive integer"
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
			di as err  "_ts_hwsm only works on one " /*
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

	qui gen `obsnum' = _n
	if "`panel'" != "" {
		qui sum `obsnum' if `pvar'==`panelid'
	}
	else {
		qui sum `obsnum' 
	}
	scalar `lastx' = r(max)                          /* this is the ob
							number of last ob
							that exists in panel
							in touse2 sample */
	qui sum `obsnum' if `touse2'  & `oldvar' < .
	
	local firstin = r(min)
	local lastin  = r(max)
	

	
	tempvar m l ym 
	tempname ym_M ym_1 M 

/* make season l and year m */

	sort `obsnum'
	qui gen `j'=1 if _n >=`firstin' & _n<=`lastin' 
	qui replace `j' = sum(`j') if  _n >=`firstin' & _n<=`lastin' 


	qui gen `m' = int( (`j'-1)/`period' +1 ) in `firstin'/`lastin'

	sort `m' `tvar'
	qui by `m': gen `l'=_n  if `m' < . 

	qui sum `m' if `touse2' & `oldvar' <. 
	sort `pvar' `tvar'

	local tseas = r(max)
	if `tseas' < 2 {
		di as err "insufficient data, only one year in data"
		exit 498
	}

	if "`s0samp'"  == "" {
		local s0samp = max(int(`tseas'/2),2)
	}

	if `s0samp' > `tseas' {
		di as err "there are `tseas' in sample which is smaller "/*
			*/ "than the `s0samp' specified in s0samp()"
		drop `varlist'
		exit 198
	}	
		
	
	if "`s10'`s20'" == "" | "`sn0_0'" == "" {
		pmean double `ym' if `touse2', p(`m') oldvar(`oldvar') 
	}	

	scalar `M' = `s0samp'
	
	
	tempvar touse3
	qui gen byte `touse3'=(_n >= `firstin' & _n <= `lastin' )
						/* firstin is ob number of
						first ob in touse2 sample
						lastin is ob number of last
						ob in touse2 sample */



	tempname a0_0 b1_0
	
	
				/* compute starting values or use 
					s10 and s20 */

	if "`s10'`s20'" != "" {
		scalar `a0_0'= `s10'
		scalar `b1_0'= `s20'
	}
	else {
		if "`altstarts'" == "" {
			qui sum `ym' if `m' == `s0samp'  & `touse2'
					/* s0samp is number of seasons in
					presample in this program */
			if r(max) > r(min) {
				di as err "more than one group average " /*
					*/ "per season "
				drop `varlist'
				exit 198
			}
			scalar `ym_M' = r(mean) 

	
			qui sum `ym' if `m' == 1 & `touse2'
			if r(max) > r(min) {
				di as err "more than one group average " /*
					*/ "per season"
				drop `varlist'
				exit 198
			}
			scalar `ym_1'	= r(mean)

			scalar `b1_0'	= ( `ym_M' - `ym_1')/ ((`M'-1)*`period')
			scalar `a0_0'	= `ym_1'-.5*`period'*`b1_0'
		}
		else {
			tempvar t2
			qui gen `t2' = _n - `firstin' +1 if _n >= `firstin' /*
				*/ & _n <= `lastin' 
			qui regress `oldvar' `t2' if `m'<=`s0samp' & 	/*
				*/ `touse2'
			scalar `b1_0' = _b[`t2']
			scalar `a0_0' = _b[_cons]
		}
	}	


	if "`sn0_0'" == "" {
/* this is bowerman and oconnel method */
		if "`altstarts'" == "" {
			tempvar sn_bar snt_sum sn0 St

			qui gen double `St'=  `oldvar'/	/*
				*/ (`ym'-  ((`period'+1)*.5-`l')*`b1_0') /*
				*/ if `m' <= `s0samp' & `touse2'
			sort `l' 

			pmean double `sn_bar' if  `m' <= `s0samp' & `touse2', /*
				*/ p(`l') oldvar(`St')
		
			sort `pvar' `tvar'
	
			qui gen double `snt_sum'=sum(`sn_bar') 	/*
				*/ if `m' ==1 & `touse2' 

			qui sum `snt_sum'  if `m' ==1 & `touse2' 
			qui replace `snt_sum'=r(max)  if `m' ==1 & `touse2' 

			qui gen double `sn0'=`sn_bar'*(`period'/`snt_sum')  /* 
				*/ if `m' == 1 &  `touse2'
		}
		else {
			tempvar sn0
			tempname vld tmean
			qui tab `l' , gen(`vld')
			qui sum `oldvar' if _n >= `firstin' &		/*
				*/ _n <=`lastin' & `m'<=`s0samp' & 	/*
				*/ `touse2'
			scalar `tmean' = r(mean)
			qui regress `oldvar' `vld'1-`vld'`period' 	/*
				*/ if `m' <=`s0samp' & `touse2', nocons
			qui gen double `sn0' = _b[`vld'1]/`tmean'	/*
				*/ if _n == `firstin' 
			forvalues myj2 = 2/`period' {
				qui replace `sn0' = _b[`vld'`myj2']/`tmean'/*
					*/ if _n == `firstin'+`myj2' - 1 
			}
		}
	}
	else {
		tempvar sn0 zerock missck
		qui gen double `sn0' = `sn0_0'
		qui gen double `zerock' = reldif(0,`sn0') 	/*
			*/ if `sn0' <. & `m' ==1 & `touse2'
		qui sum `zerock'
		if r(min) < 1e-12 {
			di as err "{p 0 4}At least one observation of the "/*
				*/ "seasonal starting value variable " /*
				*/ "`sn0_0' is zero{p_end}"
			di as err "{p 0 4}zero is not a valid value in the "/*
				*/ "seasonal starting value variable{p_end}"
			exit 498	
		}	
		qui gen byte `missck' = (`sn0' >=. & `m' ==1 & `touse2')
		qui count if `missck' == 1
		if r(N) > 0 {
			di as err "{p 0 4}At least one observation of the "/*
				*/ "seasonal starting value variable " /*
				*/ "`sn0_0' is missing{p_end}"
			di as err "{p 0 4}missing is not a valid value in "/*
				*/ "the seasonal starting value variable{p_end}"
			exit 498	
		}	
	}
	
	qui count if `sn0' <. & `m' ==1 & `touse3'
	if r(N) < `period' {
		di as err "the pattern of missing values in the "/* 
			*/ "sample prohibits using "
		di as err"the standard calculation for the seasonal "/*
			*/ "starting values;"
		di as err "specify your own starting values with sn0_0() "
		drop `varlist'
		exit 498
	}	
/* Find optimal parameters */
	

	if "`opt'" != "" {
		
		if "`display'" == "" {
			di as txt "computing optimal weights"
		}	

		tempname oldest
		capture _est hold `oldest', restore

		tempname temp_sm

		local a0_0r = `a0_0'
		local b1_0r = `b1_0'

		_hwsm_ml `oldvar' if `touse2' & _n <= `lastin' 	/*
			*/ , a0_0(`a0_0') 			/*
			*/ b1_0(`b1_0') 			/*
			*/ period(`period') 			/* 
			*/ sn0(`sn0') 				/*
			*/ `init2'  				/*
			*/ first(`firstin') 			/*
			*/ mvar(`m') 				/*
			*/ last(`lastin')			/*
			*/ `display'				/*
			*/ `mlopts'
		
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
				*/ as res %-9.7g `prss' 
			di  as txt _col(11) "sum-of-squared residuals = " /*
				*/ as res %-9.7g e(rss) 
			di as txt  _col(11) "root mean squared error  = " /*
				*/ as res %-9.7g e(rmse)
		}		

	}

	tempvar a0 b1 yhat snt

	local firstinl = `firstin'
	local lastinl  = `lastin'


	_hwsm_comp `varlist', oldvar(`oldvar') alpha(`alpha') 	/*
		*/ beta(`beta') gamma(`gamma') sn0(`sn0') a0i(`a0_0')	/*
		*/ b1i(`b1_0')	firstin(`firstinl') lastin(`lastinl')	/*
		*/ mvar(`m') period(`period') snt(`snt') tvar(`tvar')	/*
		*/ replace `normalize' 

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

	qui gen `tau'=_n - `lastin'

	qui replace `snt' = L`period'.`snt' /*
		*/ if _n > `lastin' & _n <= `lastin' + `fcast'

	qui replace `varlist' = (`a0T'+`b1T'*`tau')*L`period'.`snt'  /*
		*/ if _n > `lastin' & _n <= `lastin' + `fcast'

	

	qui gen double `err'=`oldvar'-`varlist' if `touse2'
	qui gen `err2'=`err'^2 if `touse2'

	qui sum `err2' if `touse2'

	ret scalar N 		= r(N)
	ret scalar rss 		= r(sum)
	if "`opt'" != "" {
		ret scalar prss = `prss'
	}

	local rssd 		= r(sum)
	ret scalar rmse 	= sqrt(r(mean))
	local rmsed		= sqrt(r(mean))
	ret scalar constant 	= `a0T'
	ret scalar linear 	= `b1T'
	ret scalar s1_0    	= `a0_0' 
	ret scalar s2_0   	= `b1_0' 
	if "`s0samp'" != "" {
		ret scalar N_pre  = `s0samp'
	}
	return scalar alpha    	= `alpha'
	return scalar beta    	= `beta'
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
	label variable `varlist' "shw parms(`alpha' `beta' `gamma') `vlab'"
	
end


program define _hwsm_ml, eclass 
	version 8.0
/* this program will find optimal smoothing parameters */
	syntax varname [if], 			/*
		*/ a0_0(string) 		/*
		*/ b1_0(string) 		/*
		*/ sn0(varname)			/*
		*/ first(string)		/*
		*/ period(integer) 		/*
		*/ init(passthru) 		/*
		*/ mvar(varname) 		/*
		*/ last(string)			/*
		*/ [noDIsplay 			/*
		*/ * ]
		
	/* syntax is name of oldvar 
		if statement ,
		a0_0 is real start value for a0
		b1_0 is real start value for b1
		sn0 is variable that holds starts for seasonals
		mlopts 
	*/
	
	mlopts mlopts, `options'

	global T_a0  `a0_0'
	global T_b1  `b1_0'
	global T_sn0 = "`sn0'"
	global T_per = `period'
	global T_firstin = `first'
	global T_lastin = `last'
	global T_m    `mvar'

	global T_oldvar "`varlist'"

	tempvar touse
	mark `touse' `if'

	global T_touse "`touse'"

	tempname b V rss rmse  b1 b2 b3 prss alpha beta gamma
	tempvar new err
	
	if "`display'" != "" {
		local qui qui
	}	
	`vv' ///
	`qui' ml model d0 _hwsm_opt_d0 (alpha: `varlist' = ) /beta 	/*
		*/ /gamma if `touse', `init' max 			/*
		*/ noout nopreserve search(off)  `mlopts'		/*
		*/ crittype("penalized RSS")

	mat `b' = e(b)
	mat `V' = e(V)

	scalar `b1'= cond(abs(`b'[1,1]) < 100, `b'[1,1],sign(`b'[1,1])*100)
	scalar `b2'= cond(abs(`b'[1,2]) < 100, `b'[1,2],sign(`b'[1,2])*100)
	scalar `b3'= cond(abs(`b'[1,3]) < 100, `b'[1,3],sign(`b'[1,3])*100)

	mat `b'[1,1] = exp(`b1')/(1+exp(`b1'))
	mat `b'[1,2] = exp(`b2')/(1+exp(`b2'))
	mat `b'[1,3] = exp(`b3')/(1+exp(`b3'))


	scalar `prss' = -1*e(ll)

	scalar `alpha' = `b'[1,1]
	scalar `beta'  = `b'[1,2]
	scalar `gamma' = `b'[1,3]

	qui _hwsm_comp `new', oldvar($T_oldvar) alpha(`alpha') 	/*
		*/ beta(`beta') gamma(`gamma') sn0($T_sn0) a0i($T_a0)	/*
		*/ b1i($T_b1) firstin($T_firstin) lastin($T_lastin)	/*
		*/ mvar($T_m) period($T_per) 

	qui gen double `err' = ($T_oldvar - `new')^2 if $T_touse
	qui sum `err'
	scalar `rss'  = r(sum)
	scalar `rmse' = sqrt(r(mean))

	eret post `b' `V'	

	eret scalar prss = `prss'
	eret scalar rss = `rss'
	eret scalar rmse = `rmse'

	macro drop T_a0 T_b1 T_sn0 T_per T_firstin T_lastin 	/*
		*/ T_m T_oldvar T_touse

end

program define pmean , sortpreserve
	version 8.0
	syntax newvarlist [if] , p(varname) oldvar(varname)


	tempvar touse
	mark `touse' `if' 
	markout `touse' `oldvar'

	sort `p'
	tempvar num denom

	qui gen double `num'   = `oldvar' if `touse'
	qui by `p': replace `num'   = sum(`oldvar') 
	
	qui gen double `denom' = 1 if `touse' 
	qui by `p': replace `denom' = sum(`denom') 

	qui by `p': gen `typlist' `varlist' = `num'[_N] /`denom'[_N] /*
		*/ if `touse'
	

end

exit 

/* globals  used to pass information to ml evaluator

	global T_a0 	= starting value for constant term 
	global T_b1 	= starting value for linear term 
	global T_sn0 	= name of variable that holds seasonal starting values
	global T_per 	= period
	global T_firstin = first observation in sample
	global T_lastin = last = last observation in sample
	global T_m 	= name of variable that holds years m ( mvar) 
	global T_oldvar	= variable that holds series to be smoothed  
	global T_touse  = touse variable
*/


