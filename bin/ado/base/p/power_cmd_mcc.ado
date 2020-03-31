*! version 1.0.0  08dec2014
program define power_cmd_mcc
	version 14.0
	syntax [anything], [ test * ]

	pss_mcc_test `anything', `options'
end

program define pss_mcc_test
	_pss_syntax SYNOPTS : onetest
	syntax [anything], pssobj(string)	///
		[	`SYNOPTS'		///
			m(numlist)		///
			corr(numlist)		///
			ORatio(numlist)		///
			*			///  // solvenl() options
		]

	gettoken p0 anything : anything
	if ("`oratio'"=="") local oratio .
	if ("`m'"=="") local m = 1

	mata: `pssobj'.init(`alpha',"`power'","`beta'","`n'",`p0',`oratio', ///
			"`m'", "`corr'");				///
		`pssobj'.compute();				 	///
		`pssobj'.rresults()
end
