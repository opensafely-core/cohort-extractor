*! version 1.0.0  16oct2013

program define power_cmd_oneway
	version 13.0

	syntax [anything], [ test ci * ]

	pss_oneway_test `anything', `options'
end

program define pss_oneway_test
	_pss_syntax SYNOPTS : multitest
	syntax [anything(name=args)], pssobj(string)	///
		[	`SYNOPTS'		///
			ngroups(string)		///
			varerror(string)	///
			varmeans(string) 	///
			delta(string)		///
			contrast(string)	///
			nullcontrast(string)	///
			*			///
		]
	if ("`varerror'"=="") local varerror = .

	/* pssobj.Nargs is the number of groups				*/
	mata: st_local("N",strofreal(`pssobj'.Nargs))
	forvalues i=1/`N' {
		local OOPS `"`OOPS' grwgt`i'(numlist max=1)"'
		local OOPS `"`OOPS' n`i'(numlist max=1)"'
	}
	local 0, `options'
	syntax, [ `OOPS' * ]

	forvalues i=1/`N' {
		if ("`grwgt`i''"!="") local grweight `"`grweight' `grwgt`i''"'

		if ("`n`i'"!="") local Nj `"`Nj' `n`i''"'
	}
	local grweight : list retokenize grweight
	local Nj : list retokenize Nj
	if ("`nullcontrast'"=="") local nullcontrast = .
	if ("`Nj'"=="") local Nj `npergroup'

	mata: `pssobj'.init(`alpha',"`power'","`beta'","`n'",`"`args'"',    ///
			`"`grweight'"',`"`Nj'"',`varerror',"`varmeans'", ///
			"`delta'",`"`contrast'"',`nullcontrast')
	mata: `pssobj'.compute()
	mata: `pssobj'.rresults()
end
exit
