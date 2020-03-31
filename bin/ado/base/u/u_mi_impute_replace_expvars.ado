*! version 1.0.1  13oct2017
program u_mi_impute_replace_expvars
	version 12
	syntax [anything(name=vars)] [if]

	if ("`vars'"=="") exit

	tempvar touse
	mark `touse' `if'

	local p : word count `vars'
	tokenize `vars'
	forvalues i=1/`p' {
		// local exp : variable label ``i''
		local exp : char ``i''[_mi_expr]
		qui replace ``i'' = `exp' if `touse'
	}
end
