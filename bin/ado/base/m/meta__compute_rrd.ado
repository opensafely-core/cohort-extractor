*! version 1.0.0  02may2019

program meta__compute_rrd , rclass
	version 16
	syntax varlist(min=4 max=4 numeric), touse(varname) ///
		es(string) [eslblvarbeg(string) eslblvarmid(string) ///
		cc(real .5) CCType(string)]
		
	tokenize `varlist'
	cap drop _meta_es _meta_se
		
	local db double
	tempvar nonzeros a b c d ttot ctot
	
	if "`cctype'" == "only0" {
		qui egen `nonzeros' = anymatch(`varlist'), v(0)
		qui replace `nonzeros' = 1 - `nonzeros'
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
	else if inlist("`cctype'", "_none", "none") {
		qui gen byte `nonzeros' = 1 if `touse' 
				// equiv 2 all 2x2 tbls having no 0 cells
	}								
	
	cap assert `nonzeros' > 0	// assertion is false if 0 cells exist
	
	if "`es'" == "rdiff" local cc 0
	
	qui gen `db' `a' = cond(_rc, cond(`nonzeros', `1', `1' + `cc'), `1')
	qui gen `db' `b' = cond(_rc, cond(`nonzeros', `2', `2' + `cc'), `2')
	qui gen `db' `c' = cond(_rc, cond(`nonzeros', `3', `3' + `cc'), `3')
	qui gen `db' `d' = cond(_rc, cond(`nonzeros', `4', `4' + `cc'), `4')

	qui gen `db' `ttot' = `a' + `b'	// treat total
	qui gen `db' `ctot' = `c' + `d'	// control tot
	
	if "`es'" == "lnrratio" {		
		qui gen double _meta_es = log(`a'*`ctot'/(`c'*`ttot')) ///
			if `touse'
		label var _meta_es "`eslblvarbeg'"	
		qui gen double _meta_se = sqrt(1/`a'+1/`c'-1/`ttot' - ///
			1/`ctot') if `touse'
		label var _meta_se "Std. Err. for `eslblvarmid'"	
	}
	else {
		qui gen double _meta_es = `a'/`ttot'- (`c'/`ctot') ///
			if `touse'
		label var _meta_es "`eslblvarbeg'"	
		qui gen double _meta_se = sqrt(`a'*`b'/`ttot'^3 +  ///
			`c'*`d'/`ctot'^3) if `touse'
		label var _meta_se "Std. Err. for `eslblvarmid'"	
	}
end
