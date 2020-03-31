*! version 1.1.1  20jan2015
program ca_estat, rclass
	version 8

	if "`e(cmd)'" != "ca" {
		error 301
	}

	gettoken key args : 0, parse(" ,")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("coordinates",1,max(2,`lkey')) {
		Coord `args' 
	}
	else if `"`key'"' == bsubstr("distances",1,max(2,`lkey')) {
		Distances `args'  
	}
	else if `"`key'"' == bsubstr("inertia",1,max(2,`lkey')) {
		Inertia `args' 
	}
	else if `"`key'"' == bsubstr("loadings",1,max(2,`lkey')) {
		Loadings `args' 
	}
	else if `"`key'"' == bsubstr("profiles",1,max(2,`lkey')) {
		Profiles `args' 
	}
	else if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		// override default handler
		Summarize `args'
	}
	else if `"`key'"' == bsubstr("table",1,max(2,`lkey')) {
		Table `args' 
	}
	else {
		estat_default `0'
	}
	
	return add
end

// ----------------------------------------------------------------------------

program Coord, rclass

	syntax [, noROW noCOLumn FORmat(str) ]
	
	if `"`format'"' == "" { 
		local format %9.4f
	}	

	tempname T 

	local dim = e(f)

	if "`row'" != "norow" { 
		dis _n as txt "Coordinates in row space " /// 
		              "in `e(norm)' normalization"  		
		matrix `T'  = e(TR)
		matlist `T'[1...,1..`dim'], rowtitle(`e(Rname)') /// 
		   format(`format') left(4) border(b) 
	}

	if "`column'" != "nocolumn" {
		dis _n as txt "Coordinates in column space " /// 
		              "in `e(norm)' normalization"     
		matrix `T'  = e(TC)
		matlist `T'[1...,1..`dim'],  rowtitle(`e(Cname)') /// 
	   	   format(`format') left(4) border(b)
	}
	return clear
end

// ----------------------------------------------------------------------------

program Distances, rclass
	syntax [, /// 
		noROW noCOLumn ///
		FORmat(str) /// 
		APprox ///
		FIT /// undocumented synonym to approx
	]

	if `"`format'"' == "" { 
		local format %9.4f
	}

	if "`approx'`fit'" != "" { 
		tempname P 
		quietly Approx `P' 
		local ap  "dim=`e(f)' approximations of the "
	}
	else {
		local P  e(P)
	}	

	tempname Q1 Q2
	return clear

	if "`row'" != "norow" { 
		Chi2Distances `Q1' = `P'  e(r) e(c) "`e(Rname)'" /// 
		   "`ap'row profiles" "`format'" 
		   
		return matrix Drows = `Q1'    
	}

	if "`column'" != "nocolumn" { 
		Chi2Distances `Q2' = `P'' e(c) e(r) "`e(Cname)'" /// 
		   "`ap'column profiles" "`format'" 
		   
		return matrix Dcolumns = `Q2'		 		   
	}
end


// utility command for Distances
// returns in X
program Chi2Distances
	args X colon exp_P exp_r exp_c name title fmt
	
	tempname  P r c d IC
	
	matrix `P' = `exp_P' 
	matrix `r' = `exp_r' 
	matrix `c' = `exp_c' 
		
	local n = rowsof(`P')
	matrix `IC' = syminv(diag(`c'))
		
	matrix `X' = J(`n',`n',.z)
	local rnames : rownames `P'
	matrix colnames `X'  = `rnames' 
	gettoken junk rnames : rnames
	matrix rownames `X'  = `rnames' center

// squared distances between rows of P 

	forvalues i1 = 2/`n' {
		forvalues i2 = 1/`=`i1'-1' {
			matrix `d' = `P'[`i1',1...]/`r'[`i1',1] - /// 
			             `P'[`i2',1...]/`r'[`i2',1]
			matrix `X'[`i1'-1,`i2'] = `d' * `IC' * `d''
		}
	}	

// add distances to center c		

	forvalues i2 = 1/`n' { 
		matrix `d' = `P'[`i2',1...]/`r'[`i2',1] - `c'' 
		matrix `X'[`n',`i2'] = `d' * `IC' * `d''
	}	

// take square roots

	forvalues i = 1 / `=rowsof(`X')' { 
		forvalues j = 1 / `=colsof(`X')' { 
			if `X'[`i',`j'] != .z { 
				matrix `X'[`i',`j'] = sqrt(`X'[`i',`j'])
			}
		}
	}
	matrix `X' = `X''
		
// display

	dis _n as txt "Chi2 distances between the `title'" 
	
	matlist `X', left(4) format(`fmt') nodotz ///
   	   lines(coltotal) border(bottom) rowtitle(`name')
end

// ----------------------------------------------------------------------------

program Inertia, rclass
	syntax [, FORmat(str) noSCale TOtal ]
	
	if `"`format'"' == "" { 
		local format %9.4f
	}	

// create table

	tempname Q r c
	
	matrix `Q' = e(P)   // inherit size and labels from P
	matrix `r' = e(r)
	matrix `c' = e(c)  
	
	forvalues i = 1 / `=rowsof(`Q')' {
	   forvalues j = 1 / `=colsof(`Q')' {
	      matrix `Q'[`i',`j'] = ///
	         (`Q'[`i',`j'] - `r'[`i',1] * `c'[`j',1])^2 /  ///
	            (`r' [`i',1] * `c'[`j',1])
	   }
	}

// add margins for display

	if "`total'" != "" { 
		tempname X
		
		matrix `X' = `Q' * J(colsof(`Q'),1,1)
		matrix colnames `X' = Total
		matrix `Q' = `Q' , `X'
		
		matrix `X' = `Q'' * J(rowsof(`Q'),1,1)
		matrix colnames `X'= Total
		matrix `Q' = `Q' \ `X''
		
		local opt lines(rctotal) 
	}
	else {
		local opt border(bottom)
	}
	
// display
	
	if "`scale'" == "" { 
		local N : display e(N)
		dis _n as txt "Inertia (=Pearson-Chi2/N) contributions " /// 
		              "(with N = {res:`N'})		
	}
	else { 
		dis _n as txt "Pearson-Chi2 contributions"
		matrix `Q' = e(N) * `Q'
	}
	
	matlist `Q', left(4) format(`format') `opt' 
	
// save results

	return matrix Q = `Q'
end

// ----------------------------------------------------------------------------

program Loadings, rclass
	syntax [, FORmat(str) noROW noCOLumn ]
	
	if `"`format'"' == "" { 
		local format %9.4f
	}	

	tempname GSR GSC LR LC
	
	matrix `GSR' = e(GSR)
	matrix `GSC' = e(GSC)
	
	local f  = e(f)
	local nr = rowsof(`GSR')
	local nc = rowsof(`GSC')

	matrix `LR' = e(TR) // allocate and stripes - and we need the signs
	matrix `LC' = e(TC)
	
	forvalues  k = 1/`f' {
		forvalues i = 1/`nr' {
			matrix `LR'[`i',`k'] = sqrt(`GSR'[`i',2+3*`k']) ///
			   * cond(`LR'[`i',`k']>0,1,-1)
		}
		forvalues j = 1/`nc' {
			matrix `LC'[`j',`k'] = sqrt(`GSC'[`j',2+3*`k']) ///
			   * cond(`LC'[`j',`k']>0,1,-1)
		}
	}
	
	if "`row'" != "norow" {
		dis _n as txt "Row loadings: correlations of row profiles with axes" 
		matlist `LR' , format(`format') rowtitle(`e(Rname)') ///
		   left(4) border(bot) underscore
	}
	
	if "`column'" != "nocolumn" {
		dis _n as txt "Column loadings: correlations of column profiles with axes" 
		matlist `LC' , format(`format')	rowtitle(`e(Cname)') /// 
		   left(4) border(bot) underscore
	}
	
	return matrix LR = `LR' 
	return matrix LC = `LC' 
end

// ----------------------------------------------------------------------------

program Profiles, rclass
	syntax [, noROW noCOLumn FORmat(str) ]

	if `"`format'"' == "" { 
		local format %9.4f
	}

	tempname X

	if "`row'" != "norow" { 
		matrix `X' = (inv(diag(e(r)))*e(P) , e(r) \ e(c)' , .z)

		dis _n as txt "Row profiles (rows normalized to 1)"
		matlist `X', left(4) format(`format') nodotz /// 
		   lines(rctotal) underscore

		return matrix Prows = `X' 		   		
	}

	if "`column'" != "nocolumn" { 
		matrix `X' = (e(P) * inv(diag(e(c))) , e(r) \ e(c)' , .z)

		dis _n as txt "Column profiles (columns normalized to 1)" 
		matlist `X', left(4) format(`format') nodotz /// 
		   lines(rctotal) underscore

		return matrix Pcolumns = `X' 		   
	}
end

// ----------------------------------------------------------------------------

program Summarize
	syntax [, VARlist(str) Analysis *] // analysis option undocumented
	local summ_opts `options' 

	if `"`varlist'"' != "" {
		dis as err "option varlist() not valid"
		exit 198
	}

	if "`e(ca_data)'" == "matrix" { 
		dis as err "estat summarize not available with matrix data"
		exit 321
	}
	
	if "`analysis'" == "" { 
		// raw variables
		
		if "`e(ca_data)'" != "crossed" { 
			local spec `e(varlist)' 
		}
		else {
			if "`e(Rcrossvars)'" != "" { 
				local rspec (row:`e(Rcrossvars)') 
			}
			else {
				local rspec (row:`e(Rname)') 
			}	
			if "`e(Ccrossvars)'" != "" { 
				local cspec (column:`e(Ccrossvars)') 
			}
			else {
				local cspec (column:`e(Cname)') 
			}	
			local spec `rspec' `cspec' 
		}
		
		estat_summ `spec' , `summ_opts' misswarning
	}
	else {
		// analysis variables
		
		tempname Coding 

		confirm new variable ca_rowvar ca_colvar 
		
		matrix `Coding' = e(Rcoding)'
		qui _applycoding ca_rowvar if e(sample), coding(`Coding') miss
		
		matrix `Coding' = e(Ccoding)'
		qui _applycoding ca_colvar if e(sample), coding(`Coding') miss
		
		estat_summ ca_rowvar ca_colvar, `summ_opts' misswarning
		dis as txt "  CA analysis variables are coded 1,2,..." 
		capture drop ca_rowvar ca_colvar
	}
end

// ----------------------------------------------------------------------------

program Approx, rclass
	args Q
	
	tempname R C Sv rc
	
	local d = e(f)
	
	matrix `R'  = e(R)  // left singular vectors
	matrix `C'  = e(C)  // right singular vectors
	matrix `Sv' = e(Sv) // singular values
	
	// lower rank approximate for residuals
	matrix `Q' = /// 
	   `R'[.,1..`d'] * diag(`Sv'[1,1..`d']) * (`C'[.,1..`d'])'
	
	// transform to approximate of correspondence table
	forvalues i = 1 / `=rowsof(`R')' {
	   forvalues j = 1 / `=rowsof(`C')' {
	      scalar `rc'  = el(e(r),`i',1) * el(e(c),`j',1)
	      matrix `Q'[`i',`j'] = `rc' + sqrt(`rc') * `Q'[`i',`j']
	   }
	}
end	


program Table, rclass
	syntax [, FORmat(str) OBS INdependence FIT noSCale ]

	if "`obs'`independence'`fit'" == "" {
		local fit fit
	}

	if `"`format'"' == "" {
		local format %9.4f
	}

	if "`scale'" != "" { 
		local N "e(N)*"
		local n = e(N)
	}
	else { 
		local n = 1
	}
	local nrmt "(normalized to overall sum = `n')"

	tempname Q
	
	if "`obs'" != "" { 
		matrix `Q' = `N' e(P)

		dis _n as txt "Correspondence table `nrmt'"
		matlist `Q', format(`format') left(4) border(b)

		return matrix Obs = `Q' 
	}

	if "`independence'" != "" { 
		matrix `Q' = `N' e(r) * e(c)'

		dis _n as txt "Expected proportions under independence `nrmt'"
		matlist `Q' , format(`format') left(4) border(b)

		return matrix Fit0 = `Q' 
	}

	if "`fit'" != "" { 
		Approx `Q'

		dis _n as txt "Approximation for dim = `=e(f)' `nrmt'"
		matlist `N'`Q', format(`format') left(4) border(b)
		
		return matrix Fit = `Q' 
	}
end	   
exit
