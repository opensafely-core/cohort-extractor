*! version 1.0.1  12jan2020

program meta__compute_ci, rclass 
	version 16
	syntax varlist(min=2 max=2 numeric), touse(varname) ESlbl(string) ///
		[Level(cilevel)]
	
	cap drop _meta_cil _meta_ciu
	
	tokenize `varlist'
	
	local alpha = (100 -`level')/200	
	
	qui gen double _meta_cil = `1' + invnormal(`alpha')*`2' if `touse'
	qui lab var _meta_cil "`level'% lower CI limit for `eslbl'" 
	qui gen double _meta_ciu = `1' + invnormal(1-`alpha')*`2' if `touse'
	qui lab var _meta_ciu "`level'% upper CI limit for `eslbl'"

end
