*! version 1.0.0  20oct2016
program _eprobit_svgetsigma, rclass
	version 15
	syntax [pw iw fw], endog(string) exog(string) ///
		touse(string) resids(string) [nendog(string) *]
	local 0, `options'
	local s
	forvalues i = 1/`nendog' {
		local s `s' endog_constant`i'(string)
	}	
	if "`s'" != "" {
		syntax, [`s']	
	}
	if("`weight'" != "") {
		local wexp [`weight'`exp']
	}
	if("`weight'" == "pweight" | "`weight'" == "iweight") {
		local awexp [aweight `exp']
	}
	else {
		local awexp `wexp'
	}
	local oendog `endog'	
	local oexog `exog'
	tempname b tb
	local i = 1
	local colnames
	foreach residname of local resids {
		gettoken endogvar endog: endog
		gettoken exogvars exog: exog, parse(",")
		qui mvreg `endogvar' = `exogvars' if `touse' `awexp', ///
			`endog_constant`i''
		gettoken comma exog: exog, parse(",")
		matrix `tb' = e(b)
		local tcolnamesf: colnames `tb'
		local tcolnames
		foreach word of local tcolnamesf {
			local tcolnames `tcolnames' `endogvar':`word'
		}		
		local colnames `colnames' `tcolnames'
		if `i' == 1 {	
			matrix `b' = `tb'
		}
		else {
			matrix `b' = `b',`tb'
		}
		qui predict double `residname' if `touse', residuals
		local i = `i' + 1		
	}
	qui corr `resids' `wexp', cov 
	tempname cov
	matrix `cov' = r(C)
	matrix colnames `cov' = `oendog'
	matrix rownames `cov' = `oendog'	
	matrix colnames `b' = `colnames'
	return matrix b = `b'
	return matrix Cov = `cov'
end
