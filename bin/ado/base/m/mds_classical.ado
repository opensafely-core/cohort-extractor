*! version 1.0.1  07apr2007
program mds_classical, rclass
	version 10

	#del ;
	syntax  anything(id="dissimilarity matrix" name=DM),
	[
		ADDconstant
		DIMensions(numlist integer max=1 >=1)
		Copy
		NORMalize(string)
	] ;
	#del cr

// checks that DM is symmetric, nonmissing, and properly named -------
// beware, I do not check that DM is dissimilarity matrix     -------

	confirm matrix `DM'
	if !issym(`DM') {
		dis as err "symmetric dissimilarity matrix expected"
		exit 503
	}
	if matmissing(`DM') {
		dis as err "classical MDS does not allow missing values"
		exit 198
	}

	if "`copy'" == "" {
	   	local rD : rownames `DM'
	   	local cD : colnames `DM'
	   	if !`:list rD==cD' {
	   		dis as err "row and column names of " ///
	   		           "dissimilarity matrix do not match"
	   		exit 198
	   	}
	   	local cD
	}

	local n = colsof(`DM')
	local dim `dimensions'
	
// normalize() ------------------------------------------------------

	mds_parse_normalize `"`normalize'"'
	local nmethod `s(method)'
	local narg    `s(arg)'
	local ncopy   `s(copy)'

	if "`nmethod'" == "classical" {
		dis as err ///
		    "normalize(classical) not allowed with classical MDS"
		exit 198
	}	

	if "`nmethod'" == "target" {
		confirm matrix `narg'
		if "`dim'" == "" {
			local dim = colsof(`narg')
		}	
		if (rowsof(`narg')!=`n')  | (colsof(`narg')!=`dim') {
			dis as err "target matrix not conformable"
			dis as err "need `n' rows by `dim' columns"
			exit 503
		}	
		if matmissing(`narg') {
			dis as err "target matrix has missing values"
			exit 504	
		}
		
		if "`ncopy'" == "" {
			local rT : rownames `narg'
			if !`:list rD==rT' {
				dis as err "names of dissimilarity and " ///
			            "norm(target()) matrix do not match" 		
				exit 198
			}
			local rT
			local rD
		}
	}	
	
// spectral decomposition of centered distances ---------------------

	tempname a1 a11 a12 a2 a21 a22 e eps nstats tol
	tempname B E F H P Shift Tmp V Y

	// one may write a special function to do the double centering
	// b(ij) <-- b(ij) - b(i.) - b(.j) + b(..)


	matrix `H' = I(`n') - J(`n',`n', 1/`n')
	matrix `B' = `H' * hadamard(`DM',`DM') * `H'
	matrix `B' = -0.25 * (`B'+`B'')

	// we may extract just the largest eigenvectors

	matrix symeigen `V' `E' = `B'

	scalar `tol' = c(epsdouble)^(3/4) * abs(`E'[1,1])
	local np = 0
	forvalues i = 1/`n' {
		if (`E'[1,`i'] > `tol') local ++np
	}

	if `np' == 0 {
		dis as err "no positive eigenvalues found"
		dis as err "classical MDS is not meaningful"
		matlist `E', left(4) row(eigenvalues)
		exit 498
	}

	// add smallest constant to make B positive semi-definite
	// (smallest eigenvalue 0, all others strictly positive)

	if ("`addconstant'" != "") & (`E'[1,`n'] < 0) {
		scalar `Shift' = -2*`E'[1,`n']
		matrix `B' = `B' + `Shift'*`H'
		matrix symeigen `V' `E' = `B'

		scalar `tol' = c(epsdouble)^(3/4) * abs(`E'[1,1])
		local np = 0
		forvalues i = 1/`n' {
			if (`E'[1,`i'] > `tol') local ++np
		}
	}
	else {
		scalar `Shift' = 0
	}
	matrix drop `B' `H'

// determine number of relevant eigenvalues -------------------------

	if "`dim'" != "" {
		if `dim' > `np' {
			dis as err "dim() exceeds number of positive "  ///
			    "eigenvalues of the centered dissimilarity " ///
			    "matrix (`np')"
			exit 496
		}
		local p = `dim'
	}
	else {
		local p = min(`np',2)
		// dis as txt "(defaults to `p' dimensions; max = `np')"
	}

// approximating configuration Y -----------------------------------

	matrix `V' = `V'[1..., 1..`p']
	matrix rownames `V' = `:rownames `DM''

	matrix `e' = `E'[1, 1..`p']
	forvalues i = 1 / `p' {
		local clist `clist' dim`i'
		matrix `e'[1,`i'] = sqrt(`e'[1,`i']) * sign(`V'[1,`i'])
	}

	matrix `Y' = `V' * diag(`e')
	matrix colnames `Y' = `clist'
	matrix rownames `Y' = `:rownames `DM''

// is Y uniquely determined ----------------------------------------

	local unique = 1
	forvalues i = 1 / `=min(`p',`n'-1)' {
		if reldif(`E'[1,`i'],`E'[1,`i'+1]) < `tol' {
			local unique = 0
		}
	}

// Mardia's fit measures --------------------------------------------

	scalar `a11' = 0
	scalar `a21' = 0
	forvalues i = 1 / `p' {
		scalar `a11' = `a11' + abs(`E'[1,`i'])
		scalar `a21' = `a21' + `E'[1,`i']^2
	}

	scalar `a12' = `a11'
	scalar `a22' = `a21'
	forvalues i = `=`p'+1' / `n' {
		scalar `a12' = `a12' + abs(`E'[1,`i'])
		scalar `a22' = `a22' + `E'[1,`i']^2
	}

	scalar `a1' = `a11' / `a12'
	scalar `a2' = `a21' / `a22'

// normalize MDS solution -------------------------------------------

	if "`nmethod'" == "principal" {
		mata: _mds_NormPrincipal("`Y'")
	}
	else if "`nmethod'" == "target" {
		matrix `nstats' = (.)
		mata: _mds_NormProcrustes("`Y'","`narg'", "`nstats'")
	}	

// OLS-fit : Distance = b0 + b1 Dissimilarity + eps -----------------
// note that (b0,b1) does not depend on normalization

	tempname b

	matrix `b'= (.)
	mata: _mds_linear("`DM'", "`Y'", "`b'")

	matrix colnames `b' = _cons dissim
	matrix rownames `b' = distance
	
// return in r() ---------------------------------------------------

	return local  method  classical
	return scalar addcons = `Shift'
	return local  unique  `unique'

	return scalar N  = `n'
	return scalar p  = `p'
	
	return local norm `nmethod'
	if "`nmethod'" == "target" {
		return local targetmatrix `narg'
		return matrix norm_stats = `nstats'
	}

	return matrix D       = `DM' 	
	return matrix Y       = `Y'    // approx config
	return matrix linearf = `b'    // Disparities: a + b*Dissimilarity
	
	return scalar np      = `np'
	return scalar mardia1 = `a1'
	return scalar mardia2 = `a2'
	return matrix Ev      = `E'    // eigenvalues
end

mata:

void _mds_NormPrincipal( string scalar _Y )
{
	real matrix Y
	
	Y = st_matrix(_Y)
	_mds_principal(Y)
	st_replacematrix(_Y,Y)
}


void _mds_NormProcrustes( string scalar _Y, string scalar _Tg,
		string scalar _S )
{
	real matrix Y, S, Tg
	
	Y  = st_matrix(_Y)
	Tg = st_matrix(_Tg)
	
	_mds_procrustes(Y, Tg, S=.)

	st_replacematrix(_Y, Y) // shifted-rotated configuration
	st_matrix(_S, S)        // statistics
}

// OLS-fit to off-diagonal elements of linear relation
//
//   L2_distance(Y(i.),Y(j.)) = T.a + T.b*Dissimilarity(i,j) + e(i,j)
//
// The transformed dissimilarities are often called disparities or
// pseudo-distances.
//
void _mds_linear( string scalar _D, string scalar _Y, string scalar _T )
{
	real scalar  i, j, ij, n, m
	real matrix  B, D
	real matrix  x, y
	real matrix  T

	D = st_matrix(_D)
	B = _mds_euclidean(st_matrix(_Y))

	n = rows(D)
	m = n*(n-1)/2

	y = J(m,1,.)
	x = J(m,2,1)

	ij = 0
	for (i=1; i<=n; i++)
		for (j=1; j<i; j++) {
			y[++ij] = B[i,j]
			x[ij,2] = D[i,j]
		}

	T = pinv(x'*x)*(x'*y)

	// return as row vector
	st_matrix(_T,T')
}

end
