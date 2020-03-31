*! version 1.0.0  02may2019
program meta__compute_wgt
	version 16
	
	syntax, method(string) touse(varname) [eslbl(string) *] 

	local es     : char _dta[_meta_estype]
	if "`eslbl'"=="" {
		local eslbl : char _dta[_meta_eslabel]
	}
	
	if "`method'" == "mhaenszel" {
		local datavars : char _dta[_meta_datavars]		
		_computeWgtmh `datavars', touse(`touse') es(`es') eslbl(`eslbl')
	}
	else if inlist("`method'", "ivariance", "invvariance") {
		_computeWgtIvFe, touse(`touse') method(`method') eslbl(`eslbl')
	}
	else {
		_computeWgtRe, touse(`touse') method(`method') eslbl(`eslbl') ///
			`options'
	}
end

program _computeWgtmh
	version 16
	syntax varlist(min=4 max=4 numeric), touse(varname) es(string) /// 
		[eslbl(string) ASPERcentage]
	
	if !inlist("`es'", "lnoratio", "lnrratio", "rdiff") {
		di as err "invalid effect size {bf:esize(`es')}"
		di as err "{p 4 4 2} Mantel-Haenszel method is only " ///
		"available with {bf:lnoratio}, {bf:lnrratio}, or " ///
		"{bf:rdiff}.{p_end}"
		exit 198
	}
	
	cap drop _meta_weight
	local db double
	
	tempvar a b c d tot ctot ttot nonzeros 
	
	tokenize `varlist'

	local cctype : char _dta[_meta_zcadj]
	local cc     : char _dta[_meta_zcvalue]
	if missing("`cctype'") {
		local cctype "only0"
		local cc 0.5
	}
	
	if "`cctype'" == "only0" | "tacc" == bsubstr("`cctype'", 1, 4) {
		qui egen `nonzeros' = anymatch(`varlist'), v(0)
		qui replace `nonzeros' = 1 - `nonzeros'
				// nonzeros is 0 if there is a 0 cell
		if "tacc" == bsubstr("`cctype'", 1, 4) & "`es'" == "lnoratio" {
			tempvar a b c d kc kt nc nt		
			local h = cond("`cctype'"=="tacc",1,.01)
			qui gen `db' `nt' = `1' + `2'
			qui gen `db' `nc' = `3' + `4'
			qui gen `db' `kc' = `h'*`nc'/(`nc' + `nt')
			qui gen `db' `kt' = `h'*(1 - `kc')
			qui gen `db' `a' = cond(`nonzeros', `1', `1' + `kt')
			qui gen `db' `b' = cond(`nonzeros', `2', `2' + `kt')
			qui gen `db' `c' = cond(`nonzeros', `3', `3' + `kc')
			qui gen `db' `d' = cond(`nonzeros', `4', `4' + `kc')
			
			qui gen `db' `ttot' = `a' + `b'
			qui gen `db' `ctot' = `c' + `d'
			qui gen `db' `tot'  = `ctot' + `ttot'
			
			qui gen `db' _meta_weight = `b'*`c'/`tot' if `touse'
			la var _meta_weight "M-H weights for `eslbl'"
			exit
		}
	}
	else if "`cctype'" == "all" {
			qui gen byte `nonzeros' = 0 if `touse' 
				// equiv to all 2x2 tables having 0 cells 
	}
	else if "`cctype'" == "allif0" {
		qui egen `nonzeros' = anymatch(`varlist'), v(0)
		cap assert `nonzeros' == 0 // check if no 0-cell
		
		qui replace `nonzeros' = cond(_rc, 0,1) if `touse'
		
	}
	if "`cctype'" == "none" {
		qui gen byte `nonzeros' = 1 if `touse'
		local cc 0
				// equiv 2 all 2x2 tbls having no 0 cells
	}
	
	cap assert `nonzeros' > 0 // assertion is false if cc is to be applied
	
	if "`es'" == "rdiff" local cc 0
	
	qui gen `db' `a' = cond(_rc, cond(`nonzeros', `1', `1' + `cc'), `1')
	qui gen `db' `b' = cond(_rc, cond(`nonzeros', `2', `2' + `cc'), `2')
	qui gen `db' `c' = cond(_rc, cond(`nonzeros', `3', `3' + `cc'), `3')
	qui gen `db' `d' = cond(_rc, cond(`nonzeros', `4', `4' + `cc'), `4')
	
	qui gen `db' `ttot' = `a' + `b'
	qui gen `db' `ctot' = `c' + `d'
	qui gen `db' `tot'  = `ctot' + `ttot'
		
	if "`es'" == "lnoratio" {
		qui gen `db' _meta_weight = `b'*`c'/`tot' if `touse'
		label var _meta_weight "M-H weights for `eslbl'"
	}
	else if ("`es'" == "lnrratio") {
		qui gen `db' _meta_weight = `ttot'*`c'/`tot' if `touse'
		label var _meta_weight "M-H weights for `eslbl'"
	}
	else {
		qui gen `db' _meta_weight = `ttot'*`ctot'/`tot' if `touse'
		label var _meta_weight "M-H weights for `eslbl'"
	}
	
	if ("`aspercentage'" != "") {
		qui summ _meta_weight
		qui replace _meta_weight = 100*_meta_weight/r(sum)
	}
	
end

program define _computeWgtIvFe
	version 16
	syntax, touse(varname) [eslbl(string) method(string) ASPERcentage]
	cap confirm var _meta_se
	if _rc {
		di as err "{p}unable to compute weight variable " ///
		"{bf:_meta_weight}; variable {bf:_meta_se} not found{p_end}"
		exit 111
	}

	cap drop _meta_weight
	
	if ("`method'" == "" | inlist("`method'","invvariance","ivariance")) ///
		local method iv
	
	qui gen `db' _meta_weight = 1/_meta_se^2 if `touse'
	lab var _meta_weight "I-V weights for `eslbl'"
	
	if ("`aspercentage'" != "") {
		qui summ _meta_weight
		qui replace _meta_weight = 100*_meta_weight/r(sum)
	}
end

program define _computeWgtRe
	version 16
	
	syntax, touse(varname) [eslbl(string) method(string) ASPercentage *]
		
	cap drop _meta_weight
	cap confirm var _meta_es _meta_se
	
	if _rc {
		di as err "{p}unable to compute weight variable " 	 ///
		"{bf:_meta_weight}; one of variables {bf:_meta_es} and " ///
		"{bf:_meta_se} is missing{p_end}"
		exit 111
	}
	
	if ("`method'" == "") local method reml
	tempname tausq
	
	
	meta__tausq, esvar(_meta_es) sevar(_meta_se) method("`method'") ///
		touse("`touse'") `options'  
	

	scalar `tausq' = r(_meta_tau2)
	
	qui gen double _meta_weight = 1/(_meta_se^2 + `tausq')
	label var _meta_weight "RE(`method') weights for `eslbl'"
	
	if ("`aspercentage'" != "") {
		qui summ _meta_weight
		qui replace _meta_weight = 100*_meta_weight/r(sum)
	}
	
end


