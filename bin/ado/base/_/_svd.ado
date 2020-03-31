*! version 2.1.1  27jan2017

// _svd tol [, tol(#) name(str) direction(U|V) ] 
//
// returns in r(U), r(W), and r(V) the singular value decomposition with
// columns sorted on the singular values r(D), dropping columns associated
// with singular values smaller than tol (defaults to 0); negative tolerances 
// are treated as relative to the largest singular value.
//
// name specifies the name used for "internal" stripes. Default: factor. 
//
// if direction is defined as U or V, the left or right singular vectors v
// are directed, i.e., their sign is selected so that v'1>0.
//
// for computation, we use the mata SVD. Beware that Mata returns V-transpose,
// not V. 

program _svd
	version 9
	
	syntax anything(id=matrix) [, tol(str) name(str) DIRection(str) ]

	// allow a matrix expression
	tempname P
	matrix 	`P' = `anything' 

	// beware: version 1, tol was required to be nonnegative; this 
	// is no longer the case; negative tolerances are treated as 
	// relative to the largest singular value, rather than absolute. 
	
	if `"`tol'"' == "" {
		local tol 0 
	}
	confirm number `tol'
	
	if "`name'" == "" {
		local name factor
	}
	
	if !inlist("`direction'", "U", "V", "") {
		dis as err "direction() invalid"
		exit 198
	}	

	// my_svd returns directly in r()
	mata: my_svd("`P'", "`name'", `tol', "`direction'" ) 
end

// ----------------------------------------------------------------------------

mata:

void my_svd( string scalar _P, string scalar _name, real scalar tol,  
             string scalar dir  )
{
	real scalar     i, k
	real colvector  W
	real rowvector  sgn
	real matrix     P, U, Vt
	string matrix   names
		
// get SVD
	
	P = st_matrix(_P)
	if (rows(P)>=cols(P)) { 
		svd(P, U=.,W=.,Vt=.)
	}
	else {
		svd(P', Vt=.,W=.,U=.)
		U  = U'
		Vt = Vt'
	}

	// The singular value decomposition satisfies 
	//   (1) P = (U:*W')*Vt)
	//   (2) I = U'*U
	//   (3) I = Vt*Vt'	
		
	// norm(P - (U:*W')*Vt) 
	// norm(I(cols(U)) - U'*U)
	// norm(I(cols(U)) - Vt*Vt')	
		
// chop off singular values below the tolerance

	if (tol!=0) { 
		k = rows(W)
		if (tol>0) {
			// absolute tolerance
			if (W[1]<=tol) {
				displayas("err")	
				printf("no singular value exceeds the tolerance\n")
				exit(498)
			}	
			for (; k>0 & W[k]<tol; k--) { }
		}
		else if (tol<0) {
			// tolerance relative to the largest singular value
			if (W[1]<=abs(tol)*W[1]) { /* sic */
				displayas("err")	
				printf("largest singular value too close to 0\n")
				exit(498)
			}	
			for (; k>0 & W[k]<abs(tol)*W[1]; k--) { }
		}
		if (k < rows(W)) {
			U  =  U[.,1..k]
			Vt = Vt[1..k,.]
			W  =  W[1..k]
		}
	}	
	
// normalize the signs of the singular vectors v : v'1>=0

	if (dir == "U") { 
		sgn = 2.*(colsum(U):>=0):-1
		U   = U  :* sgn
		Vt  = Vt :* sgn'
	}
	else if (dir == "V") {
		sgn = 2.*(rowsum(Vt):>=0):-1
		U   = U  :* sgn' 
		Vt  = Vt :* sgn 
	}
	
	
// for compatibility with _svd, version 1, we return U, V (not V-transpose), 
// and W-as-a-rowvector

	// rownames of U,V copied from P; other stripes derived from _name
	
	names = ("", _name+"1")
	for (i=2; i<=rows(W); i++) {
		names = names \ ("", _name+sprintf("%f",i))
	}	
	
	st_matrix( "r(U)", U )
	st_matrixrowstripe("r(U)", st_matrixrowstripe(_P))
	st_matrixcolstripe("r(U)", names)
	
	st_matrix( "r(V)", Vt' )
	st_matrixrowstripe("r(V)", st_matrixcolstripe(_P))
	st_matrixcolstripe("r(V)", names)
	
	st_matrix( "r(W)", W' ) 
	st_matrixcolstripe("r(W)", names)
	st_matrixrowstripe("r(W)", ("","sv"))
}
end
exit
