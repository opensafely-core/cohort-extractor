*! version 1.0.0  02may2019

program meta__compute_or, rclass
	version 16
	syntax varlist(min=4 max=4 numeric), touse(varname) ///
		[ eslblvarbeg(string) eslblvarmid(string) peto cc(real .5) ///
			CCType(string) CCMethod(string)]
	
	local db double
	tokenize `varlist'
	cap drop _meta_es _meta_se		
	
	tempvar nonzeros 
	if "`cctype'" == "only0" {
		qui egen `nonzeros' = anymatch(`varlist'), v(0)
		qui replace `nonzeros' = 1 - `nonzeros'
		if "tacc" == bsubstr("`ccmethod'", 1, 4) & missing("`peto'") {
			tempvar a b c d kc kt nc nt		
			local h = cond("`ccmethod'"=="tacc",1,.01)
			qui gen `db' `nt' = `1' + `2'
			qui gen `db' `nc' = `3' + `4'
			qui gen `db' `kc' = `h'*`nc'/(`nc' + `nt')
			qui gen `db' `kt' = `h'*(1 - `kc')
			qui gen `db' `a' = cond(`nonzeros', `1', `1' + `kt')
			qui gen `db' `b' = cond(`nonzeros', `2', `2' + `kt')
			qui gen `db' `c' = cond(`nonzeros', `3', `3' + `kc')
			qui gen `db' `d' = cond(`nonzeros', `4', `4' + `kc')
			
			qui g `db' _meta_es = log(`a'*`d'/(`b'*`c')) if `touse'
			label var _meta_es "`eslblvarbeg'"
			qui g `db' _meta_se = sqrt(1/`a'+1/`d'+1/`b'+1/`c') ///
				if `touse'
			la var _meta_se "Std. Err. for `eslblvarmid'"
			exit
		}		
	}
	else if "`cctype'" == "all" {
			qui gen byte `nonzeros' = 0 if `touse' 
				// equiv to all 2x2 tables having 0 cells 
	}
	else if "`cctype'" == "allif0" {
		qui egen `nonzeros' = anymatch(`varlist'), v(0)
		cap assert `nonzeros' == 0 // no 0-cell
		
		qui replace `nonzeros' = cond(_rc, 0,1) if `touse'
		
	}
	if ("`ccmethod'" == "none") {
		qui replace `nonzeros' = 1 if `touse' 
				// equiv 2 all 2x2 tbls having no 0 cells
	}								
	cap assert `nonzeros' > 0 
	if _rc & (missing("`peto'")) {
		tempvar a b c d		
		qui gen `db' `a' = cond(`nonzeros', `1', `1' + `cc')
		qui gen `db' `b' = cond(`nonzeros', `2', `2' + `cc')
		qui gen `db' `c' = cond(`nonzeros', `3', `3' + `cc')
		qui gen `db' `d' = cond(`nonzeros', `4', `4' + `cc')
		qui gen `db' _meta_es = log(`a'*`d'/(`b'*`c')) if `touse'

		qui gen `db' _meta_se = sqrt(1/`a'+1/`d'+1/`b'+1/`c') ///
			if `touse'
		
			
	}
	else if (!missing("`peto'")) {
		tempvar ttot ctot evtot nevtot tot e v
		qui {
			gen `db' `ttot'   = `1' + `2'      // treat total
			gen `db' `ctot'   = `3' + `4'      // control tot
			gen `db' `evtot'  = `1' + `3'      // event tot
			gen `db' `nevtot' = `2' + `4'      // non-event tot
			gen `db' `tot'    = `ttot' + `ctot'
			gen `db' `e'      = `evtot'*`ttot'/(`tot')
			gen `db' `v'      = `evtot'*`ttot'*`ctot'*   ///
				`nevtot'/(`tot'^2*(`tot'- 1))
			gen `db' _meta_es = (`1' - `e')/`v' if `touse'
			label var _meta_es "`eslblvarbeg'"
			gen `db' _meta_se = sqrt(1/`v') if `touse'
			label var _meta_se "Std. Err. for `eslblvarmid'" 
			//char _meta_es[estype] "or_peto"
		}
	}
	else {
		qui gen `db' _meta_es = log(`1'*`4'/(`2'*`3')) if `touse'
		qui gen `db' _meta_se = sqrt(1/`1'+1/`2'+1/`3'+1/`4') ///
			if `touse'	
	}
	
	label var _meta_es "`eslblvarbeg'"
	label var _meta_se "Std. Err. for `eslblvarmid'"
end	

