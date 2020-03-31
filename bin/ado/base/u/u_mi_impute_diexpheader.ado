*! version 1.0.3  13oct2017
program u_mi_impute_diexpheader
	version 12
	args varlist

	if ("`varlist'"=="") exit

	local p : word count `varlist'
	tokenize `varlist'
	di
	forvalues i=1/`p' {
		// local exp : variable label ``i''
		local exp : char ``i''[_mi_expr]
		local name = abbrev("``i''", 12)
		local pos  = 12 - udstrlen("`name'")
		di "{p `pos' 15 2}"
		di as txt "`name':  " as res `"`exp'"'
		di "{p_end}"
	}
end
