*! version 1.0.1  13oct2017
program u_mi_impute_replace_expr, sclass
	version 11
	args varlist

	if ("`varlist'"=="") {
		local varlist `r(expnames)'
	}
	if ("`varlist'"=="") {
		di as txt ///
			"no expressions found in {cmd:r(expnames)}; do nothing"
		exit
	}
	tokenize `varlist'
	local i = 1
	while("``i''"!="") {
		local var ``i''
		// local expr : variable label `var'
		local expr : char ``i''[_mi_expr]
		qui replace `var' = `expr'
		local ++i
	}
end
