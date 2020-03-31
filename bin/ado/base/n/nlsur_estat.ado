*! version 1.0.2  20jan2015
program nlsur_estat
	version 11

	local ver : di "version " string(_caller()) ", missing :"

	if "`e(cmd)'" != "nlsur" {
		error 301
	}

	gettoken key 0 : 0, parse(", ")
	local lkey = length(`"`key'"')

	if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		syntax [anything(name=vlist)] [, * ]
		if `"`vlist'"' == "" {
			if "`e(covariates)'" == "_NONE" {
				local vlist `e(depvar)'
			}
			else {
				local vlist `e(depvar)' `e(covariates)'
			}
			local vlist : list uniq vlist
		}
		estat_summ `vlist', `options'
		exit
	}
	estat_default `key' `0'
end
