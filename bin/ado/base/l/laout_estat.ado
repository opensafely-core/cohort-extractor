*! version 1.0.5  01may2019
/*
	estat for laout results
*/
program laout_estat
	version 16.0

	local ZERO `0'
	gettoken sub 0 : 0 , parse(" ,")
	local 0 = subinstr(`"`0'"', `","' , `" , "' , .)
	
 	local len = length(`"`sub'"')
        if `len'==0 {
               di as err "No subcommand specified"
               exit 198
        }

	if (`"`sub'"' == substr("summarize", 1, max(2, `len'))){
		estat_default `ZERO'
	}
	else if (`"`sub'"' == substr("cvplot", 1, max(3, `len'))) {
		_laout_estat_cvplot `0'		// not documented
	}
	else if (`"`sub'"' == substr("info", 1, max(4, `len'))){
		LAOUT_info `0'			// not documented
	}
	else if (`"`sub'"' == "check_cmd") {
		LAOUT_check_cmd			// not documented
	}
	else if (`"`sub'"' == "post") {
		LAOUT_post `0'			// not documented
	}
 	else {
                di as error `"{bf:estat `sub'} not allowed"'
                exit 321
        }
end
					//----------------------------//
					// laout summarize
					//----------------------------//
program LAOUT_info, rclass

	laout_estat check_cmd

	syntax [anything(name=laout)] [, subspace(string) ]

	if (`"`laout'"' == "") {
		esrf default_filename
		local laout `s(stxer_default)'
	}
	mata : _LASYS_info(`"`laout'"', `"`subspace'"')
end

					//----------------------------//
					// check e(cmd)
					//----------------------------//
program LAOUT_check_cmd
	
	if (`"`e(cmd)'"' != "lasso" &			///
		`"`e(cmd)'"' != "sqrtlasso" &		///
		`"`e(cmd)'"' != "elasticnet" &		///
		`"`e(cmd)'"' != "dsregress" &		///
		`"`e(cmd)'"' != "dslogit" &		///
		`"`e(cmd)'"' != "dspoisson" &		///
		`"`e(cmd)'"' != "poregress" &		///
		`"`e(cmd)'"' != "xporegress" &		///
		`"`e(cmd)'"' != "pologit" &		///
		`"`e(cmd)'"' != "xpologit" &		///
		`"`e(cmd)'"' != "popoisson" &		///
		`"`e(cmd)'"' != "xpopoisson" &		///
		`"`e(cmd)'"' != "poivregress" &		///
		`"`e(cmd)'"' != "xpoivregress" ) {
		error 301
	}
		
end
					//----------------------------//
					// post results
					//----------------------------//
/*
	1. esrf post to e()
	2. post esrf file's info to dataset in memory
*/
program LAOUT_post
	syntax [anything(name=obj)] [, subspace(string)]

	if (`"`obj'"' == "") {
		esrf default_filename
		local obj `s(stxer_default)'
	}

	esrf assert `"`obj'"'
	esrf post `obj', subspace(`subspace')
	mata : lasso_esrf_post_dta(`"`obj'"', `"`subspace'"')
end
