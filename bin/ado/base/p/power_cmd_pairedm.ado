*! version 1.0.0  05jun2013
program power_cmd_pairedm
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_pairedm_`type' `anything', `options'
end

program pss_pairedm_test
	_pss_syntax SYNOPTS : onetest
	syntax [anything] ,	pssobj(string) 		///
			    [	`SYNOPTS'		///
				NULLDiff(string)	///
				ALTDiff(string)		///
				sddiff(string)		///
				sd(string)		///
				sd1(string)		///
				sd2(string)		///
				CORR(string)	        ///
				KNOWNSD			///
				NORMAL			/// //undoc.
				fpc(string)		///
				*			///
			    ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	if ("`nulldiff'"=="") {
		local nulldiff 0
	}
	if ("`altdiff'"=="") {
		local altdiff .
	}
	if ("`arg1'"=="") {
		local arg1 .
	}
	if ("`arg2'"=="") {
		local arg2 .
	}
	if ("`fpc'"=="") {
		local fpc = .
	}
	if ("`corr'"=="") {
		local corr .
		local sd1 .
		local sd2 .
		local sd  .
	}
	if ("`sd1'"=="") {
		local sd1 = .
	}
	if ("`sd2'"=="") {
		local sd2 = .
	}
	if ("`sd'"=="") {
		local sd = .
	}
	if ("`sddiff'"=="") {
		local sddiff .
	}
	local knownsd = ("`knownsd'"!="")
	local normal = ("`normal'"!="")

	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", "`n'",	///
				`arg1', `arg2', `nulldiff',`altdiff',	///
				`sd',`sd1',`sd2',`corr',`sddiff',`fpc'); ///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
