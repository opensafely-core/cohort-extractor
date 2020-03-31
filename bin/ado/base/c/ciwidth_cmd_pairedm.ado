*! version 1.0.0  11jan2019
program ciwidth_cmd_pairedm
	version 16

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	pss_pairedm_`type' `anything', `options'
end

program pss_pairedm_ci
	_pss_syntax SYNOPTS : oneci
	syntax [anything] ,	pssobj(string) 		///
			    [	`SYNOPTS'		///
			    	probwidth(string)	///
				diff(string)		///
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

	if ("`arg1'"=="") {
		local arg1 .
	}
	if ("`diff'"=="") {
		local diff .
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
	
	if ("`width'"=="") local width .
	if ("`hwidth'"=="") local hwidth .
	if ("`probwidth'"=="") local probwidth .
		
	local knownsd = ("`knownsd'"!="")
	local normal = ("`normal'"!="")

	mata:   `pssobj'.init(  "`level'", "`alpha'", `width', `hwidth', ///
			`probwidth', "`n'",	///
				`arg1', `arg2', `diff', ///
				`sd',`sd1',`sd2',`corr',`sddiff',`fpc'); ///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end

