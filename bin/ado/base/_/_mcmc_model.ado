*! version 1.0.0  16mar2015
program _mcmc_model
	version 14
	syntax,	MCMCOBJECT(string)	///
	[	LMODEL(string)		///
		LINESIZE(int 78)	///
		noEXPRession		///
		NOMODELSUMMary		///
	]

	if ("`nomodelsummary'"!="") exit

	if `"`lmodel'"' == "" {
		mata: st_local("lmodel", `mcmcobject'.model())
	}

	if `linesize' <= 0 {
		local linesize = `c(linesize)'-2
	}

	mata: st_mcmc_model_summary(`linesize')
end
exit
