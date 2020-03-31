*! version 1.0.3  09sep2019
program define _xt_check_cns, eclass

	version 13
	
	syntax [ , vce(passthru) cns(string) names(string) ///
		cmat0(string) cmat(string) ]
	
	if "`cns'" == "" {
		exit 0
	}
	
	tempname hold bt Vt
	
	_est hold `hold', nullok restore
	
	local coef lnsig2u:_cons
	
	local k : list sizeof names
	mat `bt' = J(1,`k',0)
	mat colnames `bt' = `names'
	mat rownames `bt' = "y1"
	mat `Vt' = J(`k',`k',0)
	mat colnames `Vt' = `names'
	mat rownames `Vt' = `names'
	ereturn post `bt' `Vt'
	makecns `cns'
	if "`e(Cns)'"=="matrix" {
		tempname C
		matrix `C' = e(Cns)
		mata: check_cns("`C'","`vce'","`coef'")
		if "`cmat'" != "" {
			mat `cmat' = `C'
			mata: make_cns0("`cmat'","`cmat0'")
		}
	}
	
	_est unhold `hold'
	
end

mata:
version 13

void check_cns(string scalar C, vce, coef) {

	real scalar i, k
	real vector bad
	real matrix Cns
	string scalar msg
	
	msg = "{err}{p 0 4 2}invalid constraint on %s; only constant-value "
	msg = msg + "constraint on %s allowed with %s{p_end}\n"
	
	Cns = st_matrix(C)
	k = cols(Cns)
	bad = (rowsum(Cns[.,1..k-1]):>1) :* Cns[.,k]
	for (i=1; i<=rows(bad); i++) {
		if (bad[i]) {
			printf(msg,coef,coef,vce)
			exit(198)
		}
	}
}

void make_cns0(string scalar strcns, strcns0) {

	// makes a constraint matrix that -xtpoisson, re normal- 
	// uses for a comparison Poisson model
	
	real scalar k, r
	real vector selc, selr, delr
	real matrix cns, cns0
	
	cns = st_matrix(strcns)
	k = cols(cns)
	r = rows(cns)
	
	selc = 1..k
	selc[k-1] = 0
	selr = 1::r

	// if needed, remove the constraint on lnsig2u:_cons
	delr = J(r,1,1) :& cns[.,k-1]
	delr = max(delr :* selr)
	if (delr) selr[delr] = 0
	cns0 = select(select(cns,selc),selr)

	if (rows(cns0)) st_matrix(strcns0,cns0)
}

end

exit
