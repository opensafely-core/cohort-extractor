*! version 1.0.1  13oct2017
/*
        Generates variables <varlist> from expressions.  If <varlist> is
        empty, variable names from r(expnames) are used.

	Assumptions:
		r(expnames) 	must contain variable names, <stub>_#
		r(<stub>_1_exp)	expr. 1
		r(<stub>_2_exp)	expr. 2
		...
*/

program u_mi_impute_genexpr, sclass
	version 11

	args varlist explist

	if ("`varlist'"=="") {
		local varlist `r(expnames)'
	}
	if ("`varlist'"=="") {
		di as txt ///
			"no expressions found in {cmd:r(expnames)}; do nothing"
		exit
	}
	tokenize `varlist'
	local names `r(expnames)'
	local i = 1
	while("``i''"!="") {
		if ("`explist'"=="") {
			gettoken name names : names	
			local expr	`r(`name'_exp)'
		}
		else {
			gettoken expr explist : explist, bind
		}
		local var ``i''
		qui gen double `var' = `expr'
		// qui label variable `var' "`expr'"
		char ``i''[_mi_expr] `expr'
		local elist `elist' `expr'
		local ++i
	}
	sret local elist "`elist'"
end
