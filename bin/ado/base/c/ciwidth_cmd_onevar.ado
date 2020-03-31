*! version 1.0.0  11jan2019
program ciwidth_cmd_onevar
	version 16

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	pss_onevar_`type' `anything', `options'
end

program pss_onevar_ci

	_pss_syntax SYNOPTS : oneci
	syntax [anything] ,	pssobj(string) 		///
			    [	`SYNOPTS'		///
				sd			///
				probwidth(string)       ///
				*			///
			    ]
	gettoken arg1 anything : anything

	if ("`width'"=="") local width .
	if ("`hwidth'"=="") local hwidth .
	if ("`probwidth'"=="") local probwidth .

	mata: `pssobj'.init("`level'", "`alpha'", `probwidth', `width', `hwidth', "`n'", ///
			    `arg1');			///
	      `pssobj'.compute();					///
	      `pssobj'.rresults()
end
