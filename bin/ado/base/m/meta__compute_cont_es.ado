*! version 1.0.0  28apr2019
program meta__compute_cont_es, rclass
	version 16
	syntax varlist(min=6 max=6 numeric), touse(varname) ///
		[es(string) eslblvarbeg(string) eslblvarmid(string) ///
		HOLKINse exact unequal]
	
	local db double	
	
	tokenize `varlist'	
	cap drop _meta_es _meta_se
	tempvar n1 n2 s1 s2 mu1 mu2 s rmd d m invn BiasCorFact
	
	qui {
		gen `db' `n1'  = `1'
		gen `db' `mu1' = `2'
		gen `db' `s1'  = `3'
		gen `db' `n2'  = `4'
		gen `db' `mu2' = `5'
		gen `db' `s2'  = `6'
	}
	
	qui gen `db' `m'    = `n1'+`n2'-2	
	qui gen `db' `s'    = sqrt(((`n1'-1)*`s1'^2+(`n2'-1)*`s2'^2)/(`m'))  
	qui gen `db' `rmd'  = `mu1' - `mu2'
	qui gen `db' `invn' = 1/`n1' + 1/`n2'
	qui gen  `db' `d'   = `rmd'/`s'
	
	local a = cond("`holkinse'" == "", 2, 0)

	if ("`es'" == "") local es hedgesg
		
	if inlist("`es'", "mdiff", "rmd") {
		qui gen `db' _meta_es    = `rmd' if `touse'
		if missing("`unequal'") {
			qui gen `db' _meta_se = `s'*sqrt(`invn') if `touse'
		}
		else {
			qui gen `db' _meta_se = sqrt(`s1'^2/`n1'+ ///
				`s2'^2/`n2') if `touse'
		}	
		
	}
	else if inlist("`es'","cohend", "cohensd") {
		// Hedges (1981) pg 110, Eq 4;
		qui gen `db' _meta_es     = `d' if `touse'
		qui gen `db' _meta_se  =  sqrt(`invn' + ///
			`d'^2/(2*(`m'+`a'))) if `touse'
	}
	else if ("`es'" == "hedgesg") {
		// EXACT BIAS CORRECTION: Hedges (1981) pg 111, Equation 6e
		if "`exact'" != "" {
			qui gen `db' `BiasCorFact' = exp(lngamma(`m'/2) - ///
				1/2*ln(`m'/2) - lngamma((`m'-1)/2))
		}
		else {
			qui gen `db' `BiasCorFact' = 1 - 3/(4*`m' - 1)
		}
		qui gen `db' _meta_es    = `d' * `BiasCorFact' if `touse'
		if missing("`holkinse'") {
			qui gen `db' _meta_se = `BiasCorFact' * ///
				sqrt(`invn'+`d'^2/(2*(`m'+2))) if `touse'
		}
		else {   // Hedges & Olkin (1985) Eq. (8) p. 80
			qui gen `db' _meta_se = sqrt(`invn' + ///
			_meta_es^2/(2*(`m' - 1.94))) if `touse'
		}		
	} // default: use sd of control group to standardize
	else if ("`es'" == "glassdelta2" | "`es'" == "glassdelta" ) {
		qui gen `db' _meta_es = `rmd'/`s2' if `touse'
		qui gen `db' _meta_se = sqrt(`invn' + ///
			_meta_es^2/(2*(`n2'-1))) if `touse'
	}
	else if ("`es'" == "glassdelta1") {
		qui gen `db' _meta_es = `rmd'/`s1' if `touse'
		qui gen `db' _meta_se = sqrt(`invn' + ///
			_meta_es^2/(2*(`n1'-1))) if `touse'
	}
	else {
		di as err "invalid option {bf:es(`es')} for choosing effect" ///
			"size"
		di as err "{p 4 4 2} you must select one of {bf:es(mdiff)}, "
		di as err "{bf:es(hedgesg)}, {bf:es(cohensd)}, or "
		di as err "{bf:es(glassdelta)}{p_end}" 
		exit 198
	}
	
	lab var _meta_es "`eslblvarbeg'"
	lab var _meta_se "Std. Err. for `eslblvarmid'"
end
exit

/* holkinse will be an option to match the slightly different
   version of our user-written commands when ES = cohen or hedges
   unequal: assume unequal s1 and s2 when computing -rmd- (only affects rmd)*/
   

