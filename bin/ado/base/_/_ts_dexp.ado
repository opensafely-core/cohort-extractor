*! version 1.1.13  16mar2016
program define _ts_dexp, rclass byable(recall, noheader)
	version 8.0

/* syntax is _ts_dexpsmooth type new old, a(real in [0,1]) touse(byte varname)
	s0samp(integer) fcast(integer) s10(real) s20(real)

*/
	gettoken vars left : 0 , parse(",") 
	tokenize `vars'
	local type "`1'"
	local newvar "`2'"
	local oldvar "`3'"

	
	local 0 "`left'"
	syntax , touse(varlist) 		/*
		*/ a(string) 			/*
		*/ [s0samp(string) 		/*
		*/ fcast(string) 		/*
		*/ s10(string) 			/*
		*/ s20(string) 			/*
		*/ noDIsplay			/*
		*/ fcomp			/*
		*/ ]

	capture confirm number `a'
	if _rc >0 {
		local 0, `a'
		syntax , opt
	}	

	local 0 " `newvar', oldvar(`oldvar')" 
	syntax varname , oldvar(varname)  

	if "`opt'" == "" {
		local a = bsubstr("`a'", 1, 14) 
		if "`s10'`s20'" == "" {
			if reldif(`a',1) < 1e-12 | reldif( `a', 0) < 1e-12 {
				di as err "cannot obtain starting values if " /*
					*/ "exponential coefficient is 0 or 1"
				drop `varlist'
				exit 198
			}	
		}

		if `a'>1 | `a'< 0 {
			di as err "exponential coefficient not in (0,1)"
			drop `varlist'
			exit 198
		}
	}
		
	

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
		local fcastmac " forecast(`fcast') "
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
			di as err  "_ts_dexpsmooth only works on one " /*
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

/* if opt doit now */

	if "`opt'" != "" {
		if "`display'" == "" {
di as txt "computing optimal double-exponential coefficient (0,1)"
		}

		local delta 1
		tempname temp_sm

		if "`s0samp'" != "" {
			local s0sampmac  "samp0(`s0samp')"
		}	

		if "`s10'`s20'" != "" { 
			local s0mac  "s0(`s10' `s20')"
		}	

		qui tssmooth dexp double `temp_sm'=`oldvar' if `touse2', /*
			*/ parms(.0001) replace `s0mac'			/*
			*/ `s0sampmac' `fcastmac' fcomp
		local xL = .0001
		local yL=r(rss)

		qui tssmooth dexp double `temp_sm'=`oldvar' if `touse2', /*
			*/ parms(.9999) `s0sampmac' `fcastmac' replace 	/*
			*/  `s0mac' fcomp
		local xR = .9999
		local yR=r(rss)

		qui tssmooth dexp double `temp_sm'=`oldvar' if `touse2' , /*
			*/ parms(.5) `s0sampmac' `fcastmac' replace 	/*
			*/ `s0mac' fcomp
		local xM = .5
		local yM=r(rss)

		while abs(`delta') > 1e-4 {
			local x_n=.5*(`xM'+`xR')
			qui tssmooth dexp double `temp_sm'=`oldvar' 	/*
				*/ if `touse2' , replace  `s0mac'	/*
				*/ parms(`x_n') `s0sampmac' `fcastmac'	/*
				*/ fcomp

			if `yM' < r(rss) {
				local xR = `x_n'
				local yR = r(rss)
			}
			else {
				local xL = `xM'	
				local yL = `yM'
		
				local xM = `x_n'	
				local yM = r(rss)
			}
			local x_n=.5*(`xL'+`xM')
			qui tssmooth dexp double `temp_sm'=`oldvar' 	/*
				*/ if `touse2', replace  `s0mac'	/*
				*/ parms(`x_n') `s0sampmac' `fcastmac'	/*
				*/ fcomp
			if `yM' < r(rss) {
				local xL = `x_n'
				local yL = r(rss)
			}
			else {
				local xR = `xM'	
				local yR = `yM'
		
				local xM = `x_n'	
				local yM = r(rss)
			}

			local delta = `xR'-`xL'
		}

		tempname rmse
		scalar `rmse' = r(rmse)

		qui tssmooth dexp double `temp_sm'=`oldvar' 		/*
			*/ if `touse2',  parms(`xM') `s0mac'		/*
			*/ `s0sampmac' `fcastmac' replace `fcomp'

		if _by() {
			qui replace `varlist' = `temp_sm' /*
				*/ if `_byindex' == _byindex()
		}
		else {
			qui replace `varlist' = `temp_sm' 
		}


		local a =`xM' 
		local xMf : display %6.4f `xM'

		local vlab2 : variable label `oldvar'
		label variable `varlist' "dexpc(`xMf') `vlab2'"

		ret scalar N         = r(N)
		ret scalar constant  = r(constant)
		ret scalar linear    = r(linear)
		ret scalar s1_0      = r(s1_0)
		ret scalar s2_0      = r(s2_0)
		if "`s0samp'" != "" {
			ret scalar N_pre     = r(N_pre)
		}
		return scalar rss    = `r(rss)'
		return scalar rmse   = `r(rmse)'
		return scalar alpha  = `xM'

		if "`display'" == "" {
di 
di as txt  "optimal double-exponential coefficient = " /*
	*/ as res "{col 43}" %12.4f `xMf'
di  as txt "sum-of-squared residuals               = " /*
	*/ as res "{col 43}" %12.8g r(rss)
di as txt  "root mean squared error                = " /*
	*/ as res "{col 43}" %12.8g r(rmse)

		}

		exit
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

	
	qui gen `obsnum' = _n
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

	if "`panel'" != "" {
		qui sum `obsnum' if `pvar'==`panelid' & `touse2' /*
			*/ & `oldvar' < .
	}
	else {
		qui sum `obsnum' if `touse2'  & `oldvar' < .
	}
	
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
	tempvar s2

	if "`s10'`s20'" != "" {
		local s01 = `s10'
		local s02 = `s20'
	}
	else {
		if "`s0samp'" != "" {
			qui regress `oldvar' `j' if `bcount' <= `s0samp'
		}
		else{
			local s0samp = int(.5*(`lastin'-`firstin'+1 )  ) 
			qui regress `oldvar' `j' if `bcount'<=`s0samp' 
		}
		
		tempname b0 b1 
	
		scalar `b0'=_b[_cons]
		scalar `b1'=_b[`j']
	
			local s01 =`b0'-((1-`a')/`a')*`b1'
			local s02 =`b0'-2*((1-`a')/`a')*`b1'
	}



	qui gen double `s1' = `a'*`oldvar' +(1-`a')*`s01' /*
		*/ if _n==`firstin' 
	qui gen double `s2' = `a'*`s1' +(1-`a')*`s02' if _n==`firstin' 

	_byobs {
		update `s1' = cond( `oldvar' < ., /*
			*/ `a'*`oldvar'+(1-`a')*l.`s1',   /*
			*/ `a'* ( 2*l.`s1'-l.`s2' +  /*
			*/ (`a'/(1-`a'))*(`s1'[_n-1]-`s2'[_n-1])) /*
			*/ + (1-`a')*l.`s1') 
		
		update `s2' = `a'*`s1'+(1-`a')*l.`s2' 
	} if _n>`firstin' & `touse2'	

	if `fcast' > 0 | "`fcomp'" != "" {
		qui replace `varlist' = (2+`a'/(1-`a'))*`s01' /*
			*/ - (1+`a'/(1-`a'))*`s02' if _n==`firstin'
		qui replace `varlist' = (2+`a'/(1-`a'))*l.`s1' /*
			*/ - (1+`a'/(1-`a'))*l.`s2' if _n>`firstin' & `touse2' 
	}
	else {
		qui replace `varlist' = `s2'
	}

	tempname linear constant
	tempvar tau err err2

	scalar `constant' = 2*`s1'[`lastin']-`s2'[`lastin']
	scalar `linear' = (`a'/(1-`a'))*(`s1'[`lastin']-`s2'[`lastin']) 


	qui gen `tau'=_n - `lastin'
	qui replace `varlist' = `constant' + `linear'*`tau' /*
		*/ if _n > `lastin' & _n <= `lastin' + `fcast'

	qui gen double `err'=`oldvar'-`varlist' if `touse2'
	qui gen `err2'=`err'^2 if `touse2'
	qui sum `err2' if `touse2'

	ret scalar N 		= r(N)
	ret scalar rss		=r(sum)
	ret scalar rmse		=sqrt(r(mean))
	ret scalar constant 	= `constant'
	ret scalar linear 	= `linear'
	ret scalar s1_0   	= `s01' 
	ret scalar s2_0   	= `s02' 
	if "`s0samp'" != "" {
		ret scalar N_pre  	= `s0samp'
	}	
	return scalar alpha    	= `a'

	if "`display'" == "" {
		di 
		di as txt  "double-exponential coefficient  = " as res /*
			*/ "{col 35}" %12.4f `a'
		di  as txt "sum-of-squared residuals        = " /*
			*/ as res "{col 35}" %12.5g r(sum)
		di as txt  "root mean squared error         = " /*
			*/ as res "{col 35}"%12.5g sqrt(r(mean))
	}

	local a : display %6.4f `a'
	local vlab : variable label `oldvar'
	label variable `varlist' "dexp parms(`a') `vlab'"
	
end

