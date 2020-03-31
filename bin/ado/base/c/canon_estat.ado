*! version 1.0.6  20jan2015
program canon_estat, rclass
	version 9

	if "`e(cmd)'" != "canon" {
		dis as err "canon estimation results not found"
		exit 301
	}

	gettoken key args: 0, parse(" ,")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("correlations",1,max(3, `lkey')) {
		Corrmat `args'
	}
	else if `"`key'"' == bsubstr("loadings",1,max(3,`lkey')) {
		Loadings `args' 
	}
	else if `"`key'"' == bsubstr("rotate",1,max(3,`lkey')) {
		Rotate `args'
	}
	else if `"`key'"' == bsubstr("rotatecompare",1,max(7,`lkey')) {
		Rotatecomp `args'
	}
	else {
	
		estat_default `0'
	}
	return add
end

program define Corrmat, rclass
	syntax [, format(string)]

	if "`format'" =="" {
		local format format(%8.4f)
	} 
	else {
		quietly di `format' 0
		local format format(`format')
	}
	
	tempname corr_var1 corr_var2 corr_mixed
	mat `corr_var1' = e(corr_var1)
	mat `corr_var2' = e(corr_var2)
	mat `corr_mixed' = e(corr_mixed)
	
	di _n in green "Correlations for variable list 1"
	matlist `corr_var1', left(4) border(bottom) `format'
	
	di _n in green "Correlations for variable list 2"
	matlist `corr_var2', left(4) border(bottom) `format'

	di _n in green "Correlations between variable lists 1 and 2"
	matlist `corr_mixed', left(4) border(bottom) `format'
	di
	
	return matrix corr_var1 = `corr_var1'
	return matrix corr_var2 = `corr_var2'
	return matrix corr_mixed = `corr_mixed'
end

program define Loadings, rclass
	syntax [, format(string)]
	
	if "`format'" =="" {
		local format format(%8.4f)
	} 
	else {
		quietly di `format' 0
		local format format(`format')
	}
	
	tempname canload11 canload12 canload21 canload22
	mat `canload11'=e(canload11)
	mat `canload12'=e(canload12)
	mat `canload21'=e(canload21)
	mat `canload22'=e(canload22)
	local lc `e(n_lc)'
	local fir `e(n_first)'
	
	di
	if "`lc'" !="" {
		di in green "Linear combinations for canonical "	///
			"correlation `lc' calculated" _n
	}
	if "`fir'" != "" {
		di in green "Linear combinations for the first `fir' "	///
			"canonical correlations calculated" _n
	}
	
	di in green "Canonical loadings for variable list 1"
	matlist `canload11', left(4) border(bottom) `format'
	 
	di _n in green "Canonical loadings for variable list 2"
	matlist `canload22', left(4) border(bottom) `format'
		
	di _n in green "Correlation between variable list 1 and " ///
		"canonical variates from list 2"
	matlist `canload12', left(4) border(bottom) `format'
	
	di _n in green "Correlation between variable list 2 and " ///
		"canonical variates from list 1"
	matlist `canload21', left(4) border(bottom) `format'
	di
	
	return matrix canload11 = `canload11'
	return matrix canload12 = `canload12'
	return matrix canload21 = `canload21'
	return matrix canload22 = `canload22'
end

program define Rotate, rclass
	syntax [, Loadings Stdcoefs Rawcoefs Format(string)]

	if "`format'" != "" {
		qui display `format' 0
		local format format(`format')
	}
	else {
		local format format(%8.4f)
	}
	tempname B rB rots M rM
	if "`loadings'"!="" {
		if "`stdcoefs'"!="" {
			di as err "loadings and stdcoefs may not be specified together"
			exit 198
		}
		if "`rawcoefs'"!="" {
			di as err "loadings and rawcoefs may not be specified together"
			exit 198
		}
		mat `M' = (e(canload11) \ e(canload22))
		mat coleq `M' = "Unrotated canonical loadings" 
		local Mlabel "Rotated canonical loadings"
		local orig "canonical loadings"
	}
	else if "`stdcoefs'"!="" {
		if "`rawcoefs'"!="" {
			di as err "rawcoefs and stdcoefs may not be specified together"
			exit 198
		}
		mat `M' = (e(stdcoef_var1) \ e(stdcoef_var2))
		mat coleq `M' = "Unrotated"
		local Mlabel "Rotated standardized coefficients"
		local orig "standardized coefficients"
	} 
	else {
		mat `M' = (e(rawcoef_var1) \ e(rawcoef_var2))
		mat coleq `M' = "Unrotated raw coefficients"
		local Mlabel "Rotated raw coefficients"
		local orig "raw coefficients"
	}

	matrix `B' = (e(canload11) \ e(canload22))
	mat coleq `B' = Unrotated

	qui rotatemat `B'

	matrix `rB' = r(AT)
	mat `rots' = r(T)
	local ctitle `r(criterion)'
	local norm `r(normalization)'
	local class `r(class)'

	di
	di as txt "    Criterion         " as res `"`ctitle'"'
	di as txt "    Rotation class    " as res `"`class'"'
	di as txt "    Normalization     " as res `"`norm'"'
	di

	mat `rM' = `M'*`rots'
	matlist (`rM'), left(4) border(bottom) title("`Mlabel'") `format'
	matlist (`rots'), left(4) border(bottom) title("Rotation matrix") `format'
	
	return clear
	return local criterion `ctitle'
	return local class `class'
	return local coefficients `orig'
	return matrix T = `rots'
	return matrix AT = `rM'
	
end

program define Rotatecomp, rclass
	syntax , [ Format(str) ]

	if `"`r(coefficients)'"' == "" & `"`r(AT)'"'=="" {
		di as err "rotated coefficients not available"
		exit 321
	}

	if "`format'" =="" {
		local format %8.4f
	}

	capture di `format' 1
	if _rc != 0 {
		di as err "format invalid"
		exit 198
	}
	
	local class `r(class)'
	local crit `r(criterion)'
	local coefs `r(coefficients)'

	tempname A
	if "`coefs'" == "raw coefficients" {
		mat `A' = ( e(rawcoef_var1) \ e(rawcoef_var2))
	}
	if "`coefs'" == "standardized coefficients" {
		mat `A' = ( e(stdcoef_var1) \ e(stdcoef_var2))
	}
	if "`coefs'" == "canonical loadings" {
		mat `A' = (e(canload11) \ e(canload22))
	}

	matlist r(AT), format(`format') border (row) left(4) tind(0) ///
		title(Rotated `coefs' {hline 2} `class' `crit' `norm')

	matlist `A', format(`format') border (row) left(4) tind(0) ///
		title(Unrotated `coefs' )
	
	return add
end
		
exit
