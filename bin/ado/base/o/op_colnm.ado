*! version 6.0.1  13feb2015
program define op_colnm /* matname [op]depvar tovarname */
	args mat opdepv to

	/* DepStrip -- tovarname is the name of the depvar supplied to
	 * byobs or kalman.  This variable will dynamically contain predicted 
	 * values of [op]depvar.  For dynamic prediction, replace any matching
	 * [op]indvar with the appropriate transformation of tovarname to 
	 * provide for dynamic prediction.
	 *    will handle:      arima lds3.y l2d3d3s12.y
	 *    will not handle:  arima d.y l.y
	 * The latter rhs does not nest in depvar
	 */

	gettoken opdep sidep : opdepv, parse(". ")
	if "`sidep'" == "" {
		local sidep `opdep'
		local opdep
	}
	else	local sidep = bsubstr("`sidep'", 2, .)
	op_comp `opdep'
	local Ldep `r(L)'
	local Ddep `r(D)'
	local Sdep `r(S)'
	
	local cols : colnames `mat'
	tokenize `cols'
	local i 1
	while "``i''" != "" {
		gettoken opnam sinam : `i', parse(". ")
		if "`sinam'" == "" {
			local sinam `opnam'
			local opnam
		}
		else	local sinam = bsubstr("`sinam'", 2, .)
		op_comp `opnam'			/* --> r(L), r(D), r(S) */

		if "`sinam'" == "`sidep'" { 
			op_diff `r(L)' `r(D)' "`r(S)'" `Ldep' `Ddep' "`Sdep'"
			if !`r(nested)' {
				di in red "operators for the independent "  /*
					*/ "variable ``i'' do not nest"
				di in red "within the dependent "	    /*
					*/ "variable `opdepv'" 
				di in red" dynamic predictions not available"
				exit 198
			}
			if `r(hasF)' {
				di in red "operators for the independent "  /*
					*/ "variable ``i'' imply a"
				di in red "forward reference of the "/*
					*/ "dependent variable `opdepv'"
				di in red "dynamic predictions not available"
				exit 198
			}
			op_str "`r(L)'" "`r(D)'" "`r(S)'"
			local newcol `newcol' `r(op)'.`to' 
		}
		else {
			local newcol `newcol' ``i''
		}
		local i = `i' + 1
	}
	mat colnames `mat' = `newcol'
end

exit

+
-
indirectly certed in arima and arch
