*! version 1.1.1  20feb2019
program _erm_entreat_parse_oprobit
	version 15
	syntax, EQuation(string)
	_erm_parse_equation, equation(`equation')	///
		fnequation("entreat")			///
		nequation("entreat")			///
		ndepvar("treatment variable")		///
		nindepvars("treatment regressors")	///
		extraopts( noINTeract noMain 		///
		noCUTSINTeract POVariance POCORRelation noRE)
end
exit
