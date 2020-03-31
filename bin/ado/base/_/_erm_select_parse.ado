*! version 1.1.0  29may2018
program _erm_select_parse
	version 15
	syntax,  EQuation(passthru)
	_erm_parse_equation, `equation'		 	///
		fnequation("selection") 		///
		nequation("select")			///
		ndepvar("selection variable")		///
		nindepvars("selection regressors")	///
		extraopts("noRE")
	if "`s(indepvars)'" == "" {
		di as error ///
			"{p 0 4 2}invalid specification of {bf:select()}; "
		di as error "no selection covariates specified{p_end}"
		exit 198
	}	
end
exit
