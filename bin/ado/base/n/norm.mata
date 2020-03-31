*! version 1.0.1  09nov2004
version 9.0

mata:

/*

	norms:

	real scalar norm(numeric matrix A)
	real scalar norm(numeric matrix A, p)


	norm(A) returns the 2-norm

		norm(A) returns largest singular value if A is matrix  
		norm(A) returns sqrt(abs(A)'abs(A)) if A is a column vector 
		norm(A) returns sqrt(abs(A)abs(A)') if A is a row vector 

	norm(A,p) returns the p-norm

		if A is an m by n matrix

			p	norm(A,p) returns
			0	Frobenius-norm of A
					sqrt(sum(diag(conj(A)'A)))
			1	maximum of sums of abs(columns of A)		
					max_j \sum_{i=1}^m |a[i,j]|

			2	spectral norm, largest singular value 
				of A

			. 	infinity norm, maximum of sums of 
				abs(rows of A)
					max_i \sum_{j=1}^n |a[i,j]|


		if A is an n x 1 column vector or 1 x n row vector
			norm(A,p) returns

				(sum(abs(A)^p))^(1/p) if p >=1 and p<.

				max_i abs(A) if p >= .
	
				
*/

real scalar norm(numeric matrix x, | real scalar p) 
{
	real scalar	r, c

	if (args()==1) p = 2 

	if ((r=rows(x))==1 | (c=cols(x))==1) {
		return(r==1 & c==1 ? scalar_norm(x, p) : vec_norm(x,p))
	}
	return(mat_norm(x, p))
}


/* static */ real scalar mat_norm( numeric matrix x, real scalar p) 
{
	real scalar 	i, j, r, c, sum
	scalar		val
	real colvector	s

	scalar		max, z

	r = rows(x)
	c = cols(x)

	val = 0

	if (p==0) {
		max = 0 
		for (i=1; i<=r; i++) {
			for (j=1; j<=c; j++) {
				if (max<(z=abs(x[i,j]))) max = z 
			}
		}
		for (i=1; i<=r; i++) {
			for (j=1; j<=c; j++) {
				val = val + (abs(x[i,j])/max)^2
			}
		}
		return(max*sqrt(val))
	}

	if(p==1) {
		for(j=1; j<=c; j++) {
			sum = 0
			for(i=1; i<=r; i++) {
				sum = sum + abs(x[i,j])
			}
			val = sum > val ? sum : val
		}
		return(val)
	}

	if(p==2) {
		if (missing(x)) return(.)
		if (rows(x) & cols(x)) {
			s = svdsv(x)
			return(s[1])
		}
		return(0) 
	}

	if(p>=.) {
		for(i=1; i<=r; i++) {
			sum = 0
			for(j=1; j<=c; j++) {
				sum = sum + abs(x[i,j])
			}
			val = sum > val ? sum : val
		}
		return(val)
	}

	/* if here p out of range */
	_error(3300) /* MRC_range */
}

/* static */ real scalar vec_norm( numeric vector x, real scalar p) 
{
	real vector	absx
	real scalar	a

	if (missing(x)) return(.)

	if (p == 1) return(sum(abs(x)))
	if (p >= .) return(max(abs(x)))
	if (p > 1) {
		if (length(x)==0) return(0)
		a = max(absx = abs(x))
		return( a*(sum((absx:/a):^p)^(1/p)) )
	}
	_error(3300) /* MRC_range */
	/*NOTREACHED*/
}

/* static */ real scalar scalar_norm( numeric scalar x, real scalar p) 
{
	if (p<1) _error(3300) 
	return(abs(x))
}

end
