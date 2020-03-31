*! version 1.0.0  08dec2014

program define power_cmd_cmh
	version 14.0

	syntax [anything], [ test ci * ]

	pss_cmh_test `anything', `options'
end

program define pss_cmh_test
	_pss_syntax SYNOPTS : multitest
	syntax [anything(name=args)], pssobj(string)	///
		[	`SYNOPTS'		///
			oratio(numlist)		///
			cc			///
			nperstratum(string) 	///
			strweights(string)	///
			*			///
		]

	/* pssobj.Nargs is the number of strata				*/
	mata: st_local("N",strofreal(`pssobj'.Nargs))
	forvalues i=1/`N' {
		local OOPS ///
			`"`OOPS' n`i'(numlist max=1) grratio`i'(numlist max=1)"'
		local OOPS `"`OOPS' strwgt`i'(numlist max=1)"'
	}
	local 0, `options'
	syntax, [ `OOPS' * ]
	local sn = 0
	local kn = 0
	forvalues i=1/`N' {
		if ("`grratio`i''"!="") local grratios ///
				`"`grratios' `grratio`i''"'

		if ("`strwgt`i''"!="") local grweights ///
				`"`grweights' `strwgt`i''"'

		if ("`n`i''"!="") local Nj `"`Nj' `n`i''"'
	}
	local grratios : list retokenize grratios
	local grweights : list retokenize grweights
	local Nj : list retokenize Nj
	if ("`Nj'"=="") local Nj `nperstratum'

	mata: `pssobj'.init(`alpha',"`power'","`beta'","`n'",`"`args'"', ///
			`"`grweights'"',`"`Nj'"',`"`oratio'"',`"`grratios'"' ///
			); 					  	 ///
		`pssobj'.compute();					 ///
		`pssobj'.rresults()
end
