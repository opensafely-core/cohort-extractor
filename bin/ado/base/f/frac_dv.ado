*! version 2.1.1  29feb2008
program define frac_dv, rclass
	version 8
	* 1=normal (1=yes), 2=weight type, 3=nobs, 4=mnlnwt, 5=dist, 
	* 6=glm (1=yes), 7=xtgee (1=yes), 8=qreg (1=yes), 9=scale (for glm).
	* Ignore mnlnwt and iweights (let Stata handle them)
	* Returns deviance in r(deviance)

	args normal e nobs mnlnwt dist glm xtgee qreg scale
	if `normal' {
		if e(rss)==0 return scalar deviance=-1e30
		else if "`e(cmd)'"=="rreg" ret scalar deviance = ///
		 `nobs'*(1+log(2*_pi*e(rss)/`nobs')-`mnlnwt')
		else return scalar deviance = -2*e(ll)
		exit
	}
	if `xtgee' {
		if missing(e(chi2)) return scalar deviance = 0
		else return scalar deviance = -e(chi2)
	}
	else if `qreg' return scalar deviance = `nobs'*log(e(sum_adev)/e(sum_rdev))
	else return scalar deviance = -2*e(ll)
end
