*! version 1.1.2  18feb2019
program define matcproc /* T a C */
	if _caller() < 11 {
		old_matcproc `0'
		exit
	}
	version 11

	syntax namelist(min=3 max=3)
	gettoken T namelist	: namelist
	gettoken a C		: namelist

	matrix `C' = e(Cns)
	mata: matcproc_u("`C'", "`T'", "`a'")
end

mata:

void matcproc_u(string scalar sRr, string scalar sT, string scalar sa)
{
	real	scalar	rc
	real	scalar	k
	real	scalar	p
	real	scalar	p1
	real	scalar	i
	real	vector	ix
	real	vector	v
	real	vector	sub
	real	vector	prev
	real	vector	curr
	real	vector	pp
	string	matrix	stripe
	real	matrix	Rr
	real	matrix	T
	real	matrix	a
	pragma unset T
	pragma unset a
	
	Rr	= st_matrix(sRr)
	k	= rows(Rr)
	p	= cols(Rr)
	p1	= p-1
	
	// drop duplicate constraints but preserve their leftmost occurrence
	if ( rows(uniqrows(Rr)) < k ) {
		Rr = Rr, (1::k)
		_sort(Rr,(1..p+1))
		
		ix = J(k,1,1)
		prev = Rr[1,1..p]
		for (i=2; i<=k; i++) {
			curr = Rr[i,1..p]
			if ( sum(curr :== prev) == p ) {
				ix[i] = 0
			}
			prev = curr
		}

		pp = Rr[.,p+1]
		Rr = Rr[.,1..p]

		Rr = Rr[invorder(pp),.]
		ix = ix[invorder(pp),.]

		Rr = select(Rr,ix)
		k = rows(Rr)
	}

	if (k > p1) {
		exit(error(412))
	}

	if (k == p1) { // # of constraints == # of parameters
		ix = 1..p1
		v = J(1,p1,0)

		// add a fake parameter that is not constrained
		Rr = (J(k,1,0)), Rr

		rc = _cns_eigen(Rr, T, a)

		if (rc == 2) {
			exit(error(412))
		}
		
		// remove the fake parameter
		Rr = Rr[|1,2 \ k,p+1|]
		T = T[2..p]
		a = a[2..p]
		
		// put constraints in the order of the parameters
		
		// create permutation vector
		for (i=1; i<p; i++) {
			sub = Rr[|i,1 \ i,p1|]
			v[i] = sum( (sub:==1) :* ix)
		}
		
		// put all 1's in R on the main diagonal
		Rr = Rr[invorder(v),.]
	}
	else {
		rc = _cns_eigen(Rr, T, a)
		if (rc == 2) {
			exit(error(412))
		}
	}

	stripe = st_matrixcolstripe(sRr)

	if (rows(Rr) <= k) {
		st_matrix(sRr, Rr)
		st_matrixcolstripe(sRr, stripe)
	}
	st_matrix(sT, T)
	st_matrixrowstripe(sT, stripe[|_2x2(1,1,p1,2)|])
	st_matrix(sa, a)
	st_matrixcolstripe(sa, stripe[|_2x2(1,1,p1,2)|])
}

end

program old_matcproc
    version 3.1
    tempname x z R
    mat `3' = get(Cns)
    mat `z' = get(_b)
    mat `x' = J(1,1,0)
    mat `z' = `z' , `x'

    local names : colnames(`z')
    matrix colnames `3' = `names'
    local names : coleq(`z')
    matrix coleq `3' = `names' 
    local names

    local nc = rowsof(matrix(`3'))
    local p = colsof(matrix(`3')) - 1
    if `nc' >= `p' {
    	di as err "there are at least as many constraints as parameters"
	exit 498
    }
    local k = `p' - `nc'
    local kp1 = `k' + 1
    local pp1 = `p' + 1
    mat `R' = `3'[.,1..`p']
    mat `z' = `R' * `R''
    mat `z' = syminv(`z')
    mat `z' = `R'' * `z'
    mat `z' = `z' * `R'
    mat `x' = I(`p')
    mat `x' = `x' - `z'
    mat `x' = 0.5*(`x' + `x'')
    mat symeigen `x' `z' = `x'
    if (`z'[1,`kp1']>.5) { error 412 } 
    mat `1' = `x'[.,1..`k']
    mat `z' = `x'[.,`kp1'...]
    mat `x' = `R'*`z'              /* nc x p * p x nc */
    mat `x' = inv(`x')
    mat `z' = `z' * `x'            /* p x nc * nc x nc */
    mat `x' = `3'[.,`pp1']         /* nc x 1 */
    mat `2' = `x''*`z''            /* 1 x p */
end

exit
