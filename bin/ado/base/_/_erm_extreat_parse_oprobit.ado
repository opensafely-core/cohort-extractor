*! version 1.0.2  20feb2019
program _erm_extreat_parse_oprobit
	version 15
	syntax, EQuation(string) 
	_erm_parse_equation, equation(`equation')	///
		fnequation("extreat")			///
		nequation("extreat")			///
		ndepvar("treatment variable")		///
		nindepvars("treatment regressors")	///
		extraopts( noINTeract noMain 		///
		noCUTSINTeract POVariance POCORRelation)		
end
exit
