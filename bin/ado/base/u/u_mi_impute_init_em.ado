*! version 1.0.1  12mar2011

program u_mi_impute_init_em, rclass
	version 11

	syntax [varlist(default=none fv)] [if] , IVARS(varlist) 	///
						INITTYPE(string) 	///
						[ NOCONStant * ]

	marksample touse
	local xvars `varlist'
	local initopts `options'

	local p : word count `ivars'
	fvexpand `xvars' if `touse'
	local xvexpand `r(varlist)'
	local q : word count `xvexpand'
	local xnames `xvexpand'
	if ("`noconstant'"=="") {
		local ++q
		local xnames `xnames' _cons
	}

	tempname b0 V0
	if ("`inittype'" == "ac") {
		mat `V0' = I(`p')
		tokenize `ivars'
		forvalues i=1/`p' {
                        qui regress ``i'' `xvars' if `touse', `noconstant'
			mat `b0' = (nullmat(`b0'), e(b)')
			mat `V0'[`i',`i'] = e(rmse)^2
		}
	}
	else if ("`inittype'" == "cc") {
		if ("`xvars'"=="") {
			tempvar cons
			qui gen byte `cons' = 1
			qui mvreg `ivars' = `cons' if `touse', noconstant
			drop `cons'
		}
		else {
			qui mvreg `ivars' = `xvars' if `touse' , `noconstant'
		}
		mata:st_matrix("`b0'", colshape(st_matrix("e(b)"),`q')')
		mat `V0' = e(Sigma)
	}
	else if ("`inittype'" == "user") {
		u_mi_impute_initmat, `initopts' p(`p') q(`q')
		mat `b0' = r(Beta)
		mat `V0' = r(Sigma)
	}
	else {
		di as err "u_mi_impute_init_em:  "	///
			  "unknown {bf:inittype(`inittype')}"
		exit 198
	}
	mat colnames `b0' = `ivars'
	mat rownames `b0' = `xnames'
	mat colnames `V0' = `ivars'
	mat rownames `V0' = `ivars'

	ret matrix Beta  = `b0'
	ret matrix Sigma = `V0'

end
