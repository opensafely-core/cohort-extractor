*! version 1.0.0  20oct2016
program _erm_treat_parse
	version 15
	syntax, EQuation(string) [e]
	_erm_parse_equation, equation(`equation')	///
		fnequation("treat")			///
		nequation("treat")			///
		ndepvar("treatment variable")		///
		nindepvars("treatment regressors")	
end
exit
