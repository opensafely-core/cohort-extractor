*! version 3.0.7  05sep2001
program define lvr2plot_7 /* leverage vs. residual squared */
	version 6
	_isfit cons anovaok
	syntax [, XLIne(string) YLIne(string) *]

	if "`e(vcetype)'"=="Robust" { 
		di in red "leverage plot not available after robust estimation"
		exit 198
	}

	tempvar h r 
	quietly { 
		_predict `h' if e(sample), hat
		_predict `r' if e(sample), resid
		replace `r'=`r'*`r'
		sum `r', mean
		replace `r'=`r'/(r(mean)*r(N))
		local x=1/r(N)
		local y=(e(df_m)+1)*`x'
	}
	if "`xline'"!="" {
		if "`xline'"!="." { local xline "xline(`xline')" }
		else local xline
	}
	else	local xline "xline(`x')"
	if "`yline'"!="" {
		if "`yline'"!="." { local yline "yline(`yline')" }
		else local yline
	}
	else	local yline "yline(`y')"

	label var `h' "Leverage"
	label var `r' "Normalized residual squared"
	gr7 `h' `r', `options' `xline' `yline'
end
