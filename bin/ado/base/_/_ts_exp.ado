*! version 1.1.13  13feb2015 
program define _ts_exp, rclass byable(recall, noheader)
	version 8.0

/* syntax is _ts_expsmooth2 type new old, a(real in (0,1)) touse(byte varname)
	s0samp(integer) fcast(integer) s10(real) noDisplay

*/
	gettoken vars left : 0 , parse(",") 
	tokenize `vars'
	local type "`1'"
	local newvar "`2'"
	local oldvar "`3'"
	
	local 0 "`left'"
	syntax , touse(varlist)		/*
		*/ a(string) 		/*
		*/ [s0samp(string) 	/*
		*/ fcast(string) 	/*
		*/ s10(string) 		/*
		*/ noDIsplay ]

	capture confirm number `a'
	if _rc >0 {
		local 0 " , `a'"
		capture syntax , opt
		if _rc > 0 {
			di as err "parms(`a') invalid"
			exit 198
		}
	}	

	local 0 " `newvar', oldvar(`oldvar')" 
	syntax varname , oldvar(varname)  

	if "`opt'" == "" {
		local a = bsubstr("`a'", 1, 14) 
		if reldif(`a',1) < 1e-12 | reldif( `a', 0) < 1e-12 {
			di as err "cannot obtain starting values if " /*
				*/ "exponential coefficient is 0 or 1"
				
			drop `varlist'
			exit 198
		}	

		if `a'>1 | `a'< 0 {
			di as err "exponential coefficient not in (0,1)"
			drop `varlist'
			exit 198
		}
	}
		
	

	tempvar touse2 bmiss bcount
	
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
		if int(r(max)) > int(r(min)) {
			di as err  "_ts_expsmooth only works on one " /*
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

	
	qui tsreport if `touse2' , `panel' 
	
	if r(N_gaps) > 0 {
		qui tsfill
	}	
	

	sort `pvar' `tvar'

	tempvar obs
	tempvar  ob ob1 obN


	if "`opt'" != "" {
		if "`display'" == "" {
			di
			di as txt "computing optimal exponential "	/*
				*/ " coefficient (0,1)"
		}		

		local delta 1
		tempname temp_sm

		if "`s0samp'" != "" {
			local s0sampmac  "samp0(`s0samp')"
		}	

		if "`s10'" != "" {
			local s10mac "s0(`s10')"
		}	
		
		qui tssmooth exp double `temp_sm'=`oldvar' if `touse2', /*
			*/ parms(.0001)  `s0sampmac' nodisp /*
			*/ replace `s10mac'
		local xL = .0001
		local yL=r(rss)

		qui tssmooth exp double `temp_sm'=`oldvar' if `touse2', /*
			*/ parms(.9999) `s0sampmac' nodisp /*
			*/ replace  `s10mac'
		local xR = .9999
		local yR=r(rss)

		qui tssmooth exp double `temp_sm'=`oldvar' if `touse2' , /*
			*/ parms(.5) `s0sampmac' nodisp /*
			*/ replace  `s10mac'
			
		local xM = .5
		local yM=r(rss)

		while abs(`delta') > 1e-4 {
			local x_n=.5*(`xM'+`xR')
			qui tssmooth exp double `temp_sm'=`oldvar'	/*
				*/ if `touse2', replace 		/*
				*/ parms(`x_n')				/*
				*/ `s0sampmac'  nodisp `s10mac'
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
			qui tssmooth exp double `temp_sm'=`oldvar' 	/*
				*/ if `touse2', parms(`x_n')		/*
				*/ `s0sampmac' nodisp replace `s10mac'
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
		qui tssmooth exp double `temp_sm'=`oldvar' 		/*
			*/ if `touse2', parms(`xM') `s10mac'		/*
			*/ `s0sampmac' `fcastmac' nodisp replace `nolbl'

		tempname rmse
		scalar `rmse' = r(rmse)
		
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
		label variable `varlist' "parms(`xMf') `vlab2'"

		ret scalar N = r(N)
		ret scalar s1_0   = r(s1_0)
		if "`s0samp'" != "" {
			ret scalar N_pre  = r(N_pre)
		}
		return scalar rss    = `yM' 
		return scalar rmse   = `rmse'
		return scalar alpha  = `xM'

		if "`display'" == "" {
			di 
			di as txt  "optimal exponential coefficient = " /*
				*/ as res "{col 36}" %12.4f `xMf'
			di  as txt "sum-of-squared residuals        = " /*
				*/ as res "{col 36}" %12.8g r(rss)
			di as txt  "root mean squared error         = " /*
				*/ as res "{col 36}" %12.8g r(rmse)
		}

		exit
	}

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

	qui sum `obsnum' if `touse2' & `oldvar' < .
	
	scalar `firstin' = r(min)
	scalar `lastin'  = r(max)

						/* firstin is ob number of
						 * first ob in touse2 sample
						 * lastin is ob number of last
						 * ob in touse2 sample 
						 */

						/* compute starting values 
						 * or use s10 
						 */
	tempname s01 
	tempvar s2


	if "`s10'" != "" {
		scalar `s01'= `s10'
	}
	else {
		if "`s0samp'" != "" {
			qui regress `oldvar'  if _n>=`firstin' & /*
				*/ `bcount' <= `s0samp'
		}
		else {
			local s0samp = int(.5*(`lastin'-`firstin'+1 )  ) 
			qui regress `oldvar' if _n> = `firstin' & /*
				*/  `bcount' <= `s0samp'
		}
		
	
		tempname b0 b1 
	
		scalar `b0'=_b[_cons]
 		scalar `s01'=`b0'
	}

	qui replace `varlist' = `s01' if _n==`firstin' 
	qui replace `varlist' = cond(l.`oldvar' < ., /*
		*/`a'*l.`oldvar'+(1-`a')*l.`varlist', /*
		*/ l.`varlist') /*
		*/ if _n>`firstin' & `touse2'	

/* now put in forecast */

	tempvar tau err err2


	qui gen `tau'=_n - `lastin'
	qui replace `varlist' = `a'*`oldvar'[`lastin'] + /* 
		*/ (1-`a')*`varlist'[`lastin'] /*
		*/ if _n > `lastin' & _n <= `lastin' + `fcast'

	qui gen double `err'=`oldvar'-`varlist' if `touse2'
	qui gen `err2'=`err'^2 if `touse2'
	qui sum `err2' if `touse2'
	ret scalar N = r(N)
	ret scalar rss=r(sum)
	local rss2=r(sum)
	if r(N) == 0 {
		ret scalar rss = .
		local rss2 "."
	}
	ret scalar rmse=sqrt(r(mean))
	ret scalar s1_0   = `s01' 
	if "`s0samp'" != "" {
		ret scalar N_pre  = `s0samp'
	}
	return scalar alpha    = `a'

	if "`display'" == "" {
		di 
		di as txt  "exponential coefficient  = " as res /*
			*/ "{col 28}" %12.4f `a'
		di  as txt "sum-of-squared residuals = " /*
			*/ as res "{col 28}" %12.5g `rss2'
		di as txt  "root mean squared error  = " /*
			*/ as res "{col 28}"%12.5g sqrt(r(mean))
	}

	local a : display %6.4f `a'
	local vlab : variable label `oldvar'
	label variable `varlist' "exp parms(`a') `vlab'"
	
	
end

