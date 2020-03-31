*! version 1.0.0  11jan2019
program ciwidth_cmd_onecorr
	version 16

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	pss_onecorr_`type' `anything', `options'
end

program pss_onecorr_ci

	_pss_syntax SYNOPTS : oneci
	syntax [anything] ,	pssobj(string) 		///
			    [	`SYNOPTS'		///
				*			///
			    ]
 
	gettoken arg1 anything : anything

	if ("`width'"=="") local width .
	if ("`hwidth'"=="") local hwidth .

	mata: `pssobj'.init("`level'", "`alpha'", `width', `hwidth', "`n'", ///
			    `arg1');		///
	  `pssobj'.compute();			///				 
	  `pssobj'.rresults()
end

