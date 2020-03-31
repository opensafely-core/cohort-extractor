*! version 1.0.10  08oct2018
program _stubstar2names, sclass
	version 9
	syntax [anything(name=vlist)] [, ///
		nvars(integer 0) zero outcome SINGLEok noVERIFY noSUBCommand]

	if "`outcome'" == "" {
		local outcome equation
	}
	else if "`verify'" != "" {
		/* programmers error */
		di as err "options outcome and noverify may not be combined"
		exit 184
	}
	// check syntax
	if `"`vlist'"' == "" {
		local 0
		syntax newvarlist
		exit 100	// [sic]
	}

	if `nvars' <= 0 {
		di as err "invalid number of variables specified"
		exit 198
	}

	// parse vlist
	if index(`"`vlist'"',"*") {
		local stub 1
		// allow: [<vartype>] <stub>*
		//        [<vartype>] (<stub>*)
		gettoken first vlist : vlist, match(par) bind
		if index(`"`first'"',"*") {
			if ("`vlist'"!="") error 103

			local type `c(type)'
			local vlist `first'
		}
		else {
			tempvar newvar
			local 0 `first' `newvar'
			syntax newvarname
			local type `typlist'
		}
		gettoken vlist rest : vlist, match(par) bind
		if (`"`rest'"'!="" | `:word count `vlist''!=1) error 103

		if index("`vlist'","*") != `:length local vlist' {
			di as err "{it:stub}{bf:*} incorrectly specified"
			exit 198
		}
		local vlist = bsubstr("`vlist'",1,length("`vlist'")-1)
		// turn <stub>* into `varlist' (<stub>1 <stub>2 ...)
		local varlist
		local typlist
		if "`zero'" == "" {
			local nlist "1/`nvars'"
		}
		else	local nlist "0/`=`nvars'-1'"
		forval i = `nlist' {
			local varlist `varlist' `vlist'`i'
			local typlist `typlist' `type'
		}
		confirm new var `varlist'
	}
	else {
		if "`subcommand'" == "" {
			local oscmd ///
			", or you can use the {bf:`outcome'()} option"
			local oscmd "`oscmd' and specify one variable at a time"
		}
		else {
			local oscmd ", or you can use the {it:stub}{bf:*}"
			local oscmd "`oscmd' notation"
		}
		local stub 0
		// generate `typlist' and `varlist'
		local 0 `"`vlist'"'
		syntax newvarlist
	
		if "`verify'" != "" {
			/* caller will verify length of varlist */
			sreturn clear
			sreturn local varlist	`varlist'
			sreturn local typlist	`typlist'
			sreturn local stub	`stub'
			exit
		}
		local kvars : word count `varlist'
		if `kvars' != `nvars' {
			if `kvars' == 1 {
				if "`singleok'" == "" {
					local problem 1
				}
				else	local problem 0
			}
			else	local problem 1
			if `problem' {
				capture noisily	///
				syntax newvarlist(min=`nvars' max=`nvars')
				if `nvars' > 1 & "`e(depvar)'" != "" {
					if "`e(cmd)'" != "" {
						local for "for {bf:`e(cmd)'} "
					}
					di as err "{p 4 4 2}The current " ///
					 "estimation results `for'have "  ///
					 "`nvars' `outcome's so you must " ///
					 "specify `nvars' new "          ///
					 "variables`oscmd'.{p_end}"
				}
				exit c(rc)
			}
		}
	}

	sreturn clear
	sreturn local varlist	`varlist'
	sreturn local typlist	`typlist'
	sreturn local stub	`stub'
end
exit
