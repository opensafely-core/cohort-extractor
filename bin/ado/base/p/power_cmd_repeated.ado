*! version 1.0.0  16oct2013

program define power_cmd_repeated
	version 13.0

	syntax [anything], [ test ci * ]

	pss_repeated_test `anything', `options'
end

program define pss_repeated_test
	_pss_syntax SYNOPTS : multitest

	syntax , pssobj(string)	///
		[	`SYNOPTS'		///
			vareffect(string)	///
			ngroups(string)		///
			nrepeated(string)	///
			varerror(string)	///
			corr(string)		///
			factor(string)		///
			*			///
		]
	
	forvalues i=1/`ngroups' {
		local OOPS `"`OOPS' n`i'(numlist max=1)"'
		local OOPS `"`OOPS' grwgt`i'(numlist max=1)"'
	}
	local 0, `options'
	syntax, [ `OOPS' * ]

	forvalues i=1/`ngroups' {
		if ("`n`i''"!="") local Nj `"`Nj' `n`i''"'

		if ("`grwgt`i''"!="") local grweight `"`grweight' `grwgt`i''"'

	}
	local grweight : list retokenize grweight
	local Nj : list retokenize Nj

	if ("`Nj'"=="") local Nj `npergroup'
	if ("`varerror'"=="") local varerror .
	if ("`vareffect'"=="") local vareffect .
	if ("`corr'"=="") local corr .

	mata: `pssobj'.init(`alpha',"`power'","`beta'","`n'",`"`grweight'"', ///
		`"`Nj'"',"`factor'",`vareffect',`ngroups',`nrepeated',       ///
		`varerror',`corr'); ///
	`pssobj'.compute();	    ///
	`pssobj'.rresults()
end
exit
