*! version 1.0.2  15jan2018
program clonevar 
	version 8.0 
	gettoken newvar 0 : 0, parse("= ")  
	gettoken eqs 0 : 0, parse("= ")  
	gettoken varname 0 : 0 
	syntax [if] [in] 

	if "`eqs'" != "=" {
		di "{p}{err}syntax is {cmd:clonevar {it:newvar} = {it:varname}} ...{p_end}"
		exit 198
	}

	confirm new var `newvar' 
	
	unab varname : `varname'
	confirm var `varname'
	
	local type : type `varname'
	gen `type' `newvar' = `varname' `if' `in' 
		
	local w : variable label `varname'
	if `"`w'"' != "" label variable `newvar' `"`w'"'
	
	local vallbl : value label `varname' 
	if "`vallbl'" != "" label val `newvar' `vallbl' 
	
	format `newvar' `: format `varname''
	
	tokenize `"`: char `varname'[]'"' 
	while `"`1'"' != "" {
		char `newvar'[`1'] `"`: char `varname'[`1']'"' 
		mac shift 
	}
end
