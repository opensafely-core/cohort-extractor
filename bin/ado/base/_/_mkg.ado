*! version 1.1.3  06nov2002
program define _mkg
	version 8.0

/* this program makes the G needed for std errors of *irf functions
 */
 	syntax varlist(ts) , gname(string) lags(numlist >0) /*
		*/ bigt(numlist max=1 >0) touse(varname) /*
		*/ [noConstant exog(string) ] 
		
	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "_mkg only works after var and svar"
		exit 198
	}	

	local neqs  : word count `varlist'
	local nlags  : word count `lags'
	local maxlag : word `nlags' of `lags'

	if int(`nlags') == int(`maxlag') {
		local full "full"
	}
	else {
		local full ""
		tempvar zerov
		qui gen `zerov' = 0
		forvalues i=1(1)`neqs' {
			local zvarlist "`zvarlist' `zerov' "
		}
	}

	if "`exog'" != "" {
		_exogPARSE `exog'
		local exog `r(varlist)'
	}

	if "`constant'" == "" {
		tempname cons 
		qui gen `cons' = 1
		local cons_name _cons
	}	

	if "`full'" != "" {
		foreach i of local lags {
			local gvars "`gvars' L`i'.(`varlist') "
		}
	}
	else {
		local claglist "`lags'"
		gettoken clag claglist : claglist
		forvalues i=1(1)`maxlag' {
			if `clag' == `i' {
				local gvars "`gvars' L`i'.(`varlist') "
				gettoken clag claglist : claglist
			}
			else {
				local gvars "`gvars' L`i'.(`zvarlist') "
			}
		}	
	}	
	qui matrix accum `gname' = `cons' `exog' `gvars' if `touse', nocons 
	
	local cnames : colnames `gname'
	if "`cons'" != "" {
		local cnames: subinstr local cnames "`cons'" "_cons", all
	}	
	if "`zerov'" != "" {
		local cnames: subinstr local cnames "`zerov'" "zero", all
	}	
	mat colnames `gname' = `cnames'
	mat rownames `gname' = `cnames'

	local T = `bigt' 

	matrix `gname'= (1/`T')*`gname'
end

program define _exogPARSE, rclass
		syntax varlist(ts)
		
		ret local varlist `varlist'
end		
