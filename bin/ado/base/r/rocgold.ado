*! version 7.3.3  18mar2016
program define rocgold, rclass
	version 7, missing

	local vv : display "version " string(_caller()) ", missing:"

	syntax varlist(numeric min=3) [if] [in] [fweight] /*
	*/ [, SIDak TEST(string) /*
	*/  BINormal  Level(cilevel) /*
	*/ Graph  SUMmary * ]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	if `"`s(plot)'"' != "" {
		di in red "option plot() not allowed"
		exit 198
	}
	if `"`s(addplot)'"' != "" {
		di in red "option addplot() not allowed"
		exit 198
	}	

	if "`graph'"=="" {
                syntax varlist [if] [in] [fweight] /*
		*/ [, BINormal Level(cilevel) /*
                */  SIDak test(string) Graph SUMmary  ]
        }
	tokenize `varlist'

	local vars:  word count `varlist'
	if "`test'"~="" {
		noi di as err "contrast matrix option test() not allowed"
		exit 198
	}

	if "`weight'"~="" {
		local wt="[`weight' `exp']"
	}
	local opt1="`binormal' level(`level')"

			/* exclude and count observations with missing value */
	tempvar touse
	mark `touse' `wt' `if' `in'
	qui count if `touse'
	local n1 = r(N)
	markout `touse' `varlist'
	qui count if `touse'
	local nmiss = `n1' - r(N)	/* # of missing, not including wtvar */
 
	if "`graph'"~="" {
		`vv' roccomp `varlist' `wt' if `touse', graph `opt1' `options'
		if "`summary'"=="" {
			exit
		}
	}
	if "`binormal'"~="" {
		if "`graph'"=="" {
			noi di as txt /*
			*/ "Fitting binormal model for standard: " as res "`2'"
		}
		else {
			noi di as txt "Making comparisons"
		}	
		qui `vv' rocfit `1' `2' `wt' if `touse'
		local area=`e(area)'
		local se=`e(se_area)'
	}
	else {
		qui `vv' roctab `1' `2' `wt' if `touse', `opt1' 
		local area=`r(area)'
		local se=`r(se)'
	}
	if "`sidak'"~="" {
		local posi="_col(75)"
		local head="     Sidak"
	}
	else {
		local posi="_col(70)"
		local head="Bonferroni"
	}
	
	local myvar = "`varlist'"
	foreach i of local myvar {
		qui su `i' if `touse', meanonly
		if r(min) == r(max) {
			noi di in red "variable `i' does not vary"
			exit 2000
		}
	}
	
	if "`graph'"=="" | "`summary'"~=""  {
		di as txt _n "{hline 79}"
		noi di as txt _col(24) "ROC" `posi' "`head'"
		noi di as txt "`Gc'" _col(18) "     Area     Std. Err." /*
		*/ "       chi2    df   Pr>chi2     Pr>chi2" _n "{hline 79}"
		di as res abbrev("`2'",8) " (standard)" /*
		*/ _col(20) as res %7.4f `area' /*
		*/ _col(32) %8.4f `se'
	}
	
	gettoken first myvar: myvar
	gettoken first myvar: myvar
	tempname chi2 df p p_adj 
	local vars:  word count `varlist'
        matrix `chi2' = J(1,`vars'-2,0)
        matrix `df' = J(1,`vars'-2,1)
        matrix `p' = J(1,`vars'-2,0)
        matrix `p_adj' = J(1,`vars'-2,0)
        matrix rowname `chi2' = chi2
        matrix colname `chi2' = `myvar'
        matrix rowname `df' = df
        matrix colname `df' = `myvar'
        matrix rowname `p' = p
        matrix colname `p' = `myvar'
        matrix rowname `p_adj' = p_adj
        matrix colname `p_adj' = `myvar'
	tokenize `varlist'
	local i 3
	while `i'<=`vars' {
		tempname area se
		if "`binormal'"~="" {
			qui `vv' rocfit	
			qui `vv' rocfit `1' ``i'' `wt' if `touse'
			scalar `area'=`e(area)'
			scalar `se'=`e(se_area)'
		}
		else { 
			qui `vv' roctab `1' ``i'' `wt' if `touse', `opt1' 
			scalar `area'=r(area)
			scalar `se'=r(se)
		}
		qui `vv' roccomp `1' `2' ``i'' `wt' if `touse', `opt1' 
		if "`sidak'"~="" {
			local padj=  1-(1-`r(p)')^(`vars'-2)
		}
		else {
			local padj= `r(p)'*(`vars'-2)
			local padj = min(`padj', 1)
		}
		if "`graph'"=="" | "`summary'"~="" {
			di as res abbrev("``i''",16) /*
				*/  _col(19) %8.4f `area' _col(32) %8.4f `se' /*
				*/ _col(44) %8.4f `r(chi2)' _col(53) /*
				*/ %5.0f `r(df)' _col(60) %8.4f `r(p)' /*
				*/ _col(72) %8.4f `padj'
		}	
                matrix `chi2'[1,`i'-2] = `r(chi2)'
                matrix `p'[1,`i'-2] = `r(p)'
                matrix `p_adj'[1,`i'-2] = `padj'
		local i=`i'+1
	}
	if "`graph'"=="" | "`summary'"~="" {
		di as txt "{hline 79}"
	}

	if `nmiss' > 0 {
		di as txt "note: `nmiss' observations ignored because of" /*
			*/ " missing values."
	}

	return scalar N_g = `vars'-1
	tempname V
	mat `V'=r(V)
	return matrix V `V'
  	return matrix chi2 `chi2'
	return matrix df `df'
	return matrix p `p'
	return matrix p_adj `p_adj'	
end

