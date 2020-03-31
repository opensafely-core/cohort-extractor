*! version 1.0.0  16oct2013

program define power_cmd_twoway
	version 13.0

	syntax [anything], [ test ci * ]

	pss_twoway_test `anything', `options'
end

program define pss_twoway_test
	_pss_syntax SYNOPTS : multileveltest
	syntax [anything(name=args)], pssobj(string)	///
		[	`SYNOPTS'		///
			nrows(string)		///
			ncols(string)		///
			factor(string)		///
			vareffect(string)	///
			varerror(string)	///
			cweights		///
			*			///
		]
	if "`factor'" != "" {
		/* deal with shortcuts					*/
		local 0, `factor'
		cap syntax, [ row COLumn rowcol ]
		local factor `row'`column'`rowcol'
	}
	if ("`varerror'"=="") local varerror = .
	if ("`vareffect'"=="") local vareffect = .
	if ("`nrows'"=="" | "`ncols'"=="") {
		local nrows = .
		local ncols = .
	}
	mata: `pssobj'.init(`alpha',"`power'","`beta'","`n'",`"`args'"', ///
		`"`cweights'"',`"`npercell'"',`varerror',"`factor'",     ///
		`vareffect', `nrows',`ncols');				 ///
	mata: `pssobj'.compute();					 ///
	mata: `pssobj'.rresults()
end
exit
