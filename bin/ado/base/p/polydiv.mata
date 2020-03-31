*! version 1.0.0  11jan2005
version 9.0
mata:

function polydiv(numeric rowvector u, numeric rowvector userv, q, r) 
{
	real scalar		k, j 
	real scalar		nv, n 
	numeric rowvector	v

	if (iscomplex(u) | iscomplex(userv)) {
		r = polytrim(C(u))
		q = J(1, n=cols(r), 0i)
	}
	else {	
		r = polytrim(u)
		q = J(1, n=cols(r), 0)
	}
	nv = cols(v = polytrim(userv))

	if (n-nv >= 0) {
		for (k=n-nv;k>=0;k--) { 
			q[k+1] = r[nv+k] / v[nv]
			for (j=nv+k-1;j>=k+1;j--) { 
				r[j] = r[j] - q[k+1]*v[j-k]
			}
		}
		r[nv] = 0 
		r = polytrim(r[|1\nv|])
		q = polytrim(q)
	}
	else {
		q = 0 
		r = u
	}
}

end
