*! version 1.0.0  15mar2015
program _mcmc_expr
	version 14.0
	gettoken cmd 0 : 0
	_mcmc_expr_`cmd' `0'
end

program _mcmc_expr_legend
	args exprlegend colonpos linesize

	if `"`colonpos'"' == "" {
		local colonpos 14
	}
	if `"`linesize'"' == "" {
		local linesize  = `c(linesize)'-2
	}
	local LMODEL : copy local exprlegend
	gettoken tok LMODEL : LMODEL, bind match(par)
	while `"`tok'"' != "" {
		local spec `"(expression)(`tok')"'
		gettoken COLON LMODEL : LMODEL, parse(":") match(par)
		if "`COLON'" == ":" {
			gettoken tok LMODEL : LMODEL, bind match(par)
			local lmodel `"`lmodel'(`spec'(`tok'))"'
		}
		gettoken tok LMODEL : LMODEL, bind match(par)
	}
	// consumes the following local macros:
	//	lmodel
	mata: st_mcmc_model_summary(`linesize', 0, `colonpos'-1)
end

program _mcmc_expr_return, rclass

	args exprlegend
	
	local c1 12
	local c2 65
	local ind 0	
	local exprnames
	gettoken tok exprlegend : exprlegend, bind
	while `"`tok'"' != "" {
		tokenize `"`tok'"', parse(":")
		// assume exprlab contains no column (:) 
		gettoken exprlab tok : tok, parse(":") match(paren)
		gettoken 1 tok : tok, parse(":") match(paren)
		if ("`1'" != ":") {
			gettoken tok exprlegend : exprlegend
			continue
		}
		gettoken exprstr tok : tok, match(paren)

		if `ind' > 0 {
			local exprnames `"`exprnames' "`exprlab'""'
		}
		else {
			local exprnames `""`exprlab'""'
		}
		local ++ind
		return local expr_`ind' = `"`exprstr'"'

		gettoken tok exprlegend : exprlegend, bind
	}
	return local exprnames = `"`exprnames'"'
end

exit
