*! version 1.0.0  12jun2011
program u_mi_impute_cmd_mvn
	version 12
	args impobj

	local m `_dta[_mi_impute_m]'
	mata: `impobj'.da_impute(`m',1)
end
