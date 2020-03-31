*! version 1.0.0  12jun2019
program _dslasso_display_opts, sclass
	version 16.0

	syntax [, irr or coef]

	local opts `irr' `or' `coef'
	local k : list sizeof opts

	if (`k' > 1) {
		opts_exclusive "`opts'"
	}
	
	local model `e(model)'

	if (`"`model'"' == "linear") {
		local opts_default 
	}
	else if (`"`model'"' == "logit") {
		local opts_default or
	}
	else if (`"`model'"' == "poisson") {
		local opts_default irr
	}

	if (`"`opts'"' == "") {
		local coef_opts `opts_default'
	}
	else if (`"`opts'"' == "coef") {
		local coef_opts 
	}
	else {
		local coef_opts `opts'
	}

	sret local coef_opts `coef_opts'
end
