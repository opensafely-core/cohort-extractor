*! version 1.0.1  20jan2015
program procrustes_estat, rclass
	version 8

	if "`e(cmd)'" != "procrustes" {
		dis as err "procrustes estimation results not found"
		exit 301
	}

	gettoken key args : 0, parse(" ,")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("compare",1,max(2,`lkey')) {
	
		Compare `args'
	}
	else if `"`key'"' == bsubstr("mvreg",1,max(2,`lkey')) {
		
		MVreg `args'
	}
	else if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
	
		// override default handler
		Summarize `args'
	}	
	else {
	
		estat_default `0'
	}
	return add
end


program Compare, rclass
	syntax [, DETail ]
	
	tempname c0 cstat esthold fstat rss1 rss2 rss3
	tempvar  touse
	
	gen byte `touse' = e(sample)
	
	matrix `cstat' = J(3,4,.)
	matrix colnames `cstat' = Procrustes df_m df_r rmse
	matrix rownames `cstat' = orthogonal oblique unrestricted

	local xlist `e(xlist)' 
	local ylist `e(ylist)'
	if reldif(e(rho),1) < 1e-7 & "`e(transform)'" != "unrestricted" { 
		local rho norho
	}
	matrix `c0' = J(1,colsof(e(c)),0)
	if mreldif(e(c),`c0') < 1e-8 {
		local cons nocons
	}
		
	if "`detail'" == "" { 
		local log quietly 
	}
	
	local t1 orthogonal
	local t2 oblique
	local t3 unrestricted
	if "`e(transform)'" == "orthogonal" { 
		local ii  "1 2 3"
	}
	else if "`e(transform)'" == "oblique" { 
		local ii  "2 1 3"
	}
	else if "`e(transform)'" == "unrestricted" { 
		local ii  "3 1 2"
	}
	else { 
		_stata_internalerror /// 
		   "procrustes_estat.compare"  "invalid transform()"
	}

	gettoken i ii : ii
	Compare_Store `cstat' `i' 
	scalar `rss`i'' = e(rss)

	_estimates hold `esthold', restore
	forvalues j = 1/2 { 
		gettoken i ii : ii
		if "`log'" == "" { 
			dis _n as txt "{hline}"                    ///
			    _n "procrustes ..., transform(`t`i'')" /// 
			    _n "{hline}"
		}
		`log' procrustes (`ylist') (`xlist') if `touse' , /// 
	           transform(`t`i'') `rho' `scale' `cons' force
	        `log' display    
	        
		Compare_Store `cstat' `i'
		scalar `rss`i'' = e(rss)
	}	
	_estimates unhold `esthold'
	
// F tests between models

	if e(P) > 1e-2 {
		matrix `fstat' = J(3,4,.)
		matrix colnames `fstat' = F df1 df2 p 
		matrix rownames `fstat' = orthogonal_vs_oblique      /// 
		                          orthogonal_vs_unrestricted /// 
		                          oblique_vs_unrestricted

		matrix `fstat'[1,2] = `cstat'[2,2] - `cstat'[1,2]
		matrix `fstat'[1,3] = `cstat'[2,3]  
		matrix `fstat'[1,1] = ((`rss1'-`rss2')/`fstat'[1,2]) /// 
	                      / (`rss1'/`fstat'[1,3])
		matrix `fstat'[1,4] = Ftail(`fstat'[1,1],`fstat'[1,2],`fstat'[1,3])
	

		matrix `fstat'[2,2] = `cstat'[3,2] - `cstat'[1,2]
		matrix `fstat'[2,3] = `cstat'[3,3]
		matrix `fstat'[2,1] = ((`rss1'-`rss3')/`fstat'[2,2]) /// 
	                      / (`rss1'/`fstat'[2,3])	
		matrix `fstat'[2,4] = Ftail(`fstat'[2,1],`fstat'[2,2],`fstat'[2,3])
	

		matrix `fstat'[3,2] = `cstat'[3,2] - `cstat'[2,2]
		matrix `fstat'[3,3] = `cstat'[3,3]
		matrix `fstat'[3,1] = ((`rss2'-`rss3')/`fstat'[3,2]) /// 
	                      / (`rss2'/`fstat'[3,3])
		matrix `fstat'[3,4] = Ftail(`fstat'[3,1],`fstat'[3,2],`fstat'[3,3])
	}
	
// display	

	dis _n as txt "Summary statistics for three transformations" 
	matlist `cstat' , border(row) rspec(--&&-) /// 
	   cspec(o4& %12s | %10.4f & %6.0f & %4.0f & %9.0g o1&)

	if e(P) > 1e-2 {
		dis _n as txt "F tests comparing transformations" 
		matlist `fstat' , border(row) rspec(--&&-) underscore /// 
		   cspec(o4& %26s | %10.4f & %6.0f & %4.0f & %7.4f o1&)
	}
	else {
   		dis _n as txt "(F tests comparing the models suppressed)" 
	}
		   
	return matrix cstat = `cstat' 
	if e(P) > 1e-2 {
		return matrix fstat = `fstat' 
	}	
end	


program Compare_Store
	args cstat i
	
	matrix `cstat'[`i',1] = e(P)
	matrix `cstat'[`i',2] = e(df_m)
	matrix `cstat'[`i',3] = e(df_r)
	matrix `cstat'[`i',4] = e(rmse)
end


program MVreg
	syntax [, * ]
	
	tempname c0 holdest touse

	matrix `c0' = J(1,colsof(e(c)),0)
	if mreldif(e(c),`c0') < 1e-8 {
		local cons nocons
	}
	local ylist `e(ylist)' 
	local xlist `e(xlist)' 
	
	gen byte `touse' = e(sample)
	
	_estimates hold `holdest', restore 
	dis _n as txt "Multivariate regression, " /// 
	       `"similar to "procrustes ..., transform(unrestricted)""'
	
	mvreg `ylist' = `xlist' if `touse', `cons' `options' 
	_estimates unhold `holdest' 
end	


program Summarize
	syntax [, VARlist(str) *]

	if `"`varlist'"' != "" {
		dis as err "option varlist() invalid"
		exit 198
	}

	estat_summ (target : `e(ylist)') (source : `e(xlist)'), `options'
end

exit
