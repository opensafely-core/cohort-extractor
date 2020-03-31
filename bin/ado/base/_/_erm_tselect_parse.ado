*! version 1.1.0  29may2018
program _erm_tselect_parse
	version 15
	syntax,  EQuation(passthru)
	_erm_parse_equation, `equation'		 		///
		fnequation("tobit selection") 			///
		nequation("tobitselect")			///
		ndepvar("selection variable")			///
		nindepvars("tobit selection regressors")	///
		extraopts("main noRE")				///
		sextraopts("ll ul")
	if "`s(indepvars)'" == "" {
		di as error ///
			"{p 0 4 2}invalid specification of {bf:tobitselect()}; "
		di as error "no selection covariates specified{p_end}"
		exit 198
	}	
end
exit
