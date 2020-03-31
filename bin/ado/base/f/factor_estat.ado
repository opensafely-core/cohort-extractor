*! version 1.0.1  20jan2015
program factor_estat, rclass
	version 9

	if "`e(cmd)'" != "factor" {
		dis as err "factor estimation results not found"
		exit 301
	}

	gettoken key args : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == "anti" {
		AntiImage `args'
	}
	else if `"`key'"' == bsubstr("common", 1, max(3,`lkey')) {
		Common `args'
	}
	else if `"`key'"' == bsubstr("factors", 1, max(3,`lkey')) {
		Factors `args'
	}
	else if `"`key'"' == bsubstr("ic",1,max(2,`lkey')) {  
		// override default handler
		IC `args'
	}
	else if `"`key'"' == "kmo" {
		KMO `args'
	}
	else if `"`key'"' == bsubstr("residuals",1,max(3,`lkey')) {
		Residuals `args'
	}
	else if `"`key'"' == "rotateclear" {
		// undocumented
		_rotate_clear `args'
	}
	else if `"`key'"' == bsubstr("rotatecompare",1,max(3,`lkey')) {
		Rotated `args'
	}
	else if `"`key'"' == "smc" {
		SMC `args'
	}
	else if `"`key'"' == bsubstr("structure",1,max(3,`lkey')) {
		Structure `args'
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

// ----------------------------------------------------------------------------
// subcommands
// ----------------------------------------------------------------------------

// anti-image correlation = minus - partial correlation
// anti-image covariance  = minus - partial covariances
//
program AntiImage, rclass
	corr_anti e(C) `0'
	return add
end


program Common, rclass
	syntax [, noROTated FORmat(str) ]

	if (e(f) == 0) {
		dis as txt "(no factors retained)"
		exit
	}	

	if "`rotated'" != "" & "`e(r_criterion)'" == "" {
		dis as err "no rotated results available"
		exit 198
	}

	tempname Phi T
	
	if `"`format'"' == "" {
		local format %8.4g
	}	
	
	if "`rotated'" != "" {  
		local rtxt     "unrotated "
		local rprefix
	}
	else if "`e(r_criterion)'" != "" { 
		local rtxt     "`e(r_ctitle)' rotated "
		local rprefix  r_
	}
	else { 
		local rtxt     ""
		local rprefix
	}
	
	tempname Phi cPhi
	matrix `Phi' = e(`rprefix'Phi)
	
	matrix `cPhi' = `Phi' 
	local f = e(`rprefix'f) 
	forvalues i = 1/`f' { 
		forvalues j = 1/`f' { 
			matrix `cPhi'[`i',`j'] = chop(`cPhi'[`i',`j'],1e-8)
		}
	}	
	
	matlist `cPhi',                 /// 
	   rowtitle(Factors)  format(`format') /// 
	   border(row)  left(4)  tind(0)       ///
	   title(Correlation matrix of the `rtxt'common factors)
	   
	return matrix Phi = `Phi'    
end


program Factors, rclass
	syntax [, FACtors(numlist max=1 integer >=1) DETail]
	
	tempname hest C stats Stats
	
	local n    = e(N)
	matrix `C' = e(C) 
	local nvar = colsof(`C')
	local maxf = `nvar'
	
	if "`factors'" != "" { 
		local maxf = min(`maxf',`factors')
	}	
	
	_estimates hold `hest', restore 
	
	if "`detail'" != "" { 
		local log noisily 
	}	
	local f = 1
	local nstored = 0 
	while `f' <= `maxf' { 
		if (`nvar'-`f')^2 - (`nvar'+`f') < 0 {
			continue, break
		}
		
		matrix `stats' = J(1,5,.)
		matrix colnames `stats' = loglik df_m df_r AIC BIC
		matrix rownames `stats' = `f' 
		
		capture `log' factormat `C' , n(`n') fac(`f') ml  
		if _rc != 0 {
			dis as err "failure to estimate model with `f' factors"
			exit 498
		}
		
		if e(f) == `f' {
			local ++nstored
			matrix `stats'[1,1] = e(ll)
			matrix `stats'[1,2] = e(df_m)
			matrix `stats'[1,3] = e(df_r)
			matrix `stats'[1,4] = e(aic)
			matrix `stats'[1,5] = e(bic)
			matrix `Stats' = nullmat(`Stats') \ `stats'
			
			if `"`e(heywood)'"' != "" {
				local heywood `heywood' `f' 
			}	
			
			local ++f
		}
		else {
			continue, break
		}	
	}
	
	if `nstored' == 0 {
		dis as txt "(nothing to display)"
		exit 
	}	
	
	forvalues i = 3/`f' {
		local rspec `rspec'& 
	}
	
	#del ;
	matlist `Stats' , 
	   cspec(o4& %8s |o2 %9.0g & %5.0f & %5.0f & %9.0g & %9.0g o1&) 
	   rspec(--`rspec'-) rowtitle(#factors) tindent(0) 
	   title(Factor analysis with different numbers of factors 
	         (maximum likelihood)) ;
	#del cr

	if "`heywood'" != "" { 
		local nh : list sizeof heywood
		if `nh' == rowsof(`Stats') {
			dis as txt ///
		  "    all models are {help heywood_case##|_new:Heywood cases}"
		}	
		else if `nh' == 1 {
			dis as txt "    the model with {res:`heywood'} " ///
			    plural(`heywood',"factor") ///
			    " is a {help heywood_case##|_new:Heywood case}"
		}
		else {  
			dis as txt "    the models with {res:`heywood'} " ///
			"factors are {help heywood_case##|_new:Heywood cases}"
		}
	}
	else {
		dis as txt ///
		  "    no {help heywood_case##|_new:Heywood cases} encountered"
	}
	
	return matrix stats = `Stats' 
end


// overrules default handler of ic command
program IC, rclass
	syntax
	
	if "`e(ll)'" != "" { 
		est stats . , df(df_m)
		return add
	}
	else { 
		dis as err "likelihood information not found " /// 
		           "in last estimation results" 
		exit 321
	}
end


// Kaiser-Meyer-Olkin measure of sampling adequacy
program KMO, rclass
	corr_kmo e(C) `0'
	return add
end


program Residuals, rclass
	syntax [, Obs Fitted SResiduals FORmat(str) ]

	if `"`format'"' == "" { 
		local format %7.4f  
	}	

	tempname F Obs R SR v

	matrix `Obs' = e(C)
	if e(f) > 0 { 
		// use unrotated solution
		matrix `F' = e(L)*e(L)' + diag(e(Psi))
	}
	else { 
		matrix `F' = diag(e(Psi))
	}	
	matrix `R'   = `Obs' - `F'

	local opts format(`format') tind(0) left(4) /// 
	           border(row) rowtitle(Variable)

	if "`obs'" != "" {
		matlist `Obs', title(Observed correlations) `opts'
	}

	if "`fitted'" != "" {
		matlist `F',  `opts' ///
		   title(`"Fitted ("reconstructed") values for correlations"')
	}

	if "`sresiduals'" != "" {
		// Bollen (1989; pag 259-260)
		matrix `SR' = `R'
		local nv = colsof(`R')
		forvalues i = 1 / `nv' {
			forvalues j = 1 / `nv' {
				scalar `v' = `F'[`i',`j']^2 + /// 
				             `F'[`i',`i']*`F'[`j',`j']
				             
				matrix `SR'[`i',`j'] = ///
				             `SR'[`i',`j'] / sqrt(`v'/e(N))
			}
		}
		matlist `SR', `opts' ///
		   title("Standardized residuals of correlations")

		return matrix SR  = `SR'
	}
	else {
		matlist `R', `opts' /// 
		   title("Raw residuals of correlations (observed-fitted)")
	}

	return matrix fit = `F'
	return matrix res = `R'
end


program Rotated
	syntax [, FORmat(passthru) ]
	
	if (e(f) == 0) {
		dis as txt "(no factors retained)"
		exit
	}	
	
	factor_pca_rotated , `format' name(factor)
end


program Structure, rclass
	syntax [, noROTated FORmat(str)]
	
	if "`rotated'" != "" & "`e(r_criterion)'" == "" {
		dis as err "no rotated results available"
		exit 198
	}

	if (e(f) == 0) {
		dis as txt "(no factors retained)"
		exit
	}	
	
	if "`format'" == "" { 
		local format %8.4f
	}

	if ("`e(r_criterion)'" != "") & ("`rotated'" != "") {
		local rtxt     "unrotated "
		local rprefix
	}
	else if "`e(r_criterion)'" != "" {
		local rtxt     "`e(r_ctitle)' rotated "
		local rprefix  r_
	}
	else {
		local rtxt     ""
		local rprefix
	}
	
	tempname St
	if "`rprefix'" != "" { 
		matrix `St' = e(r_L) * e(r_Phi)
	}	
	else {
		matrix `St' = e(L)
	}
	
	matlist `St' , rowtitle(Variable) format(`format') border(row)    /// 
	   left(4) title(Structure matrix: correlations between variables ///
	   and `rtxt'common factors)

        return matrix st = `St'
end


// squared multiple correlations
//
program SMC, rclass
	corr_smc e(C) `0'
	return add
end


// overrule default handler to pass correct varlist
program Summarize, rclass
	syntax [, VARlist(str) *]

	if `"`varlist'"' != "" {
		dis as err "option varlist() not valid"
		exit 198
	}
	
	if "`e(matrixname)'" != "" {
		dis as err "sample information not available after factormat"
		exit 321
	}	
	
	tempname C
	matrix `C' = e(C)
	estat_summ `:colnames `C'', `options' 
	
	dis as txt "(Factor analysis correlation matrix)" 
	
	return add
end
exit
