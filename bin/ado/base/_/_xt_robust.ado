*! version 1.1.1  09sep2019
program define _xt_robust, eclass
	local vv : display "version " string(_caller()) ", missing:"
	version 13
	
	local 0 : subinstr local 0 "[]" "", all
	
	syntax [anything] [if] [in] , 	///
		relevel(varname) 	/// intercept and discard
		[			///
		indeps(string)		///
		bmat(string)		///
		vce(passthru) 		///
		quad(string)		/// change to intpoints()
		iter(string)		///
		from(string) CONSTraints(string) RE noSKIP I(varname) ///
		noREFINE Level(passthru) noDISplay DOOPT call(string) ///
		GAUSSian NORMAL IRr EForm noCONstant OFFset(passthru) ///
		EXPosure(passthru) * ]

	gettoken cmd anything : anything
	gettoken dep anything : anything
	local f_eq `dep' `indeps' `if' `in', `constant' `offset' `exposure'
	
	if _caller() < 15 {
		local coef lnsig2u:_cons
	}
	else	local coef /lnsig2u
	
	tempname hold b V C J V_modelbased V0 V1 V2
	
	di
	di "{txt}Calculating robust standard errors:"
	
	// must pass `b' explicitly as e(b) may still be striped with tempnames
	if "`bmat'" == "" mat `b' = e(b)
	else mat `b' = `bmat'
	mat `V_modelbased' = e(V)
	
	if "`e(Cns)'"=="matrix" {
		matrix `C' = e(Cns)
		if "`constant'" == "noconstant" {
			mata: __fixcmat("`C'")
		}
		
		local j = colsof(`C')
		
		forvalues i=1/`=rowsof(`C')' {
			if `C'[`i',`j'-1] != 0 {
				mat `C'[`i',`j'] = exp(`C'[`i',`j'])
			}
		}		
		local cns constraints(`C')
	}
	
	_est hold `hold', nullok restore

	local NAMES_O : colfullnames `b'
	local k = colsof(`b')
	local xnames `indeps'
	forvalues i=1/`=`k'-1' {
		gettoken x xnames : xnames
		local NAMES `NAMES' `dep':`x'
	}
	mat `b'[1,`k'] = exp(`b'[1,`k'])
	if _caller() < 15 {
		local VARSPEC "var(_cons[`relevel']):_cons"
	}
	else {
		local VARSPEC "/var(_cons[`relevel'])"
	}
	local NAMES `NAMES' `VARSPEC'
	mat colnames `b' = `NAMES'
	
	local opts intp(`quad') from(`b') iter(0) startv(zero) `options'
	
	_ms_op_info `b'
	if r(tsops) {
		quietly tsset, noquery
	}
	
	`vv' capture me`cmd' `f_eq' || `relevel':, `vce' `cns' `opts'
	if _rc {
		di "{err}calculation of robust standard errors failed"
		exit 198
	}
	
	if "`constant'"!="" {
		mat `V0' = e(V)
		local m = colsof(`V0')
		mat `V1' = `V0'[1..`m'-2,1..`m'-2], `V0'[1..`m'-2, `m']
		mat `V2' = `V0'[`m', 1..`m'-2], `V0'[`m',`m']
		mat `V'  = (`V1')\(`V2')
	}
	else {
		mat `V' = e(V)
	}
	
	if colsof(`V') < `k' {
		local NAMES : colfullnames `V'
		local NAMES: subinstr local NAMES "`VARSPEC'" "`coef'"
		mata: __fixdim("`V'","`NAMES'","`NAMES_O'")
	}
	
	mat `J' = I(`k')
	mat `J'[`k',`k'] = 1/_b[/var(_cons[`relevel'])]
	mat `V' = `J'*`V'*`J'
	
	mat colnames `V' = `NAMES_O'
	mat rownames `V' = `NAMES_O'
	
	_est unhold `hold'
	
	ereturn repost V=`V'
	ereturn matrix V_modelbased = `V_modelbased'
	ereturn local vce "robust"
	ereturn local vcetype "Robust"
	ereturn hidden scalar N_robust = e(N)
	_prefix_model_test
end

version 13
mata:

void __fixdim(string scalar Vs, stripe_from, stripe_to) {

	real scalar i, j, n, m
	real matrix V, T
	string rowvector from, to
	
	V = st_matrix(Vs)
	from = tokens(stripe_from)
	to = tokens(stripe_to)
	
	n = cols(to)
	m = cols(from)
	
	T = J(n,m,0)

	j=1
	for (i=1; i<=n; i++) {
		if (to[i]==from[j]) {
			T[i,j++] = 1
		}
	}
	V = T*V*T'
	st_matrix(st_local("V"),V)
}

void __fixcmat(string scalar Cs) {
	real scalar n, k
	real matrix C, C_new
	// add a column of 0's to C for the constant
	C = st_matrix(Cs)
	n = rows(C)
	k = cols(C)
	C_new = C[|1,1 \ n,k-2|],J(n,1,0),C[|1,k-1 \ n,k|]
	st_matrix(Cs,C_new)
}

end

exit

