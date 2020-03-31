*! version 1.0.3  13feb2012
program define _mksigma
	version 8.0

/* this program makes an estimate of Sigma after var.  the order of the
 * variables determines the order of the computations for Sigma.  The order of
 * the variables may be different than they were in the original var.
 */

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" & "`e(cmd)'" != "sureg" {
		di as err "_mksigma only works after var or svar"
		exit 198
	}

	if "`e(cmd)'" == "svar" {
		local svar "_var"
		local sforce force
	}

 	syntax varlist(ts), sig(string) [dfeq(numlist >0 max = 1) 	/*
		*/ neqs(numlist integer >0) ]

	local nvars : word count `varlist'
	if "`neqs'" == "" {
		local neqs = e(neqs`svar')
	}	

	if `neqs' != `nvars' {
		di as error "cannot compute Sigma"
		exit 198
	}	
	
	local i 1
	foreach v of local varlist {
		local eq : subinstr local v "." "_"
		local eqlist "`eqlist' `eq' "
		
		tempvar res`i'
		qui predict double `res`i'', res eq(`eq') `sforce'
							/* this line
							works for both
                                                        svar and var because
                                                        they each use their
                                                        own predict */

		local resvars "`resvars' `res`i'' "
		local i = `i' + 1
	}
	
	qui mat accum `sig' = `resvars' if e(sample), nocons  /* again 
								e(sample) 
								exists for 
								both svar and 
								var
								*/
	local T = e(N)

	mat colnames `sig' = `eqlist'
	mat rownames `sig' = `eqlist'

	if "`dfeq'" == "" {
		local T_dfk = `T'- e(df_eq`svar')
	}
	else {
		local T_dfk = `T'- `dfeq'
	}
	
	
	if "`e(dfk`svar')'" != "" | "`dfeq'" != "" {
		mat `sig'=  (1/`T_dfk')*`sig' 
	}	
	else {
		mat `sig'=  (1/`T')*`sig' 
	}	

end
