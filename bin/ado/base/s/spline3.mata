*! version 1.0.3  07mar2007
version 9.0
mata:
/*
	spline3 computes the coefficients of a cubic natural spline
	S(x), interpolating the ordinates y[i] at the points x[i].

	For xx in [x[i],x[i+1]):

	S(xx) = ((d[i]*t + c[i])*t + b[i])*t + y[i]

	with    t = xx - x[i]

	Input:
		x, y    vectors with x[i] as abscissa and y[i] as ordinate of
			i-th data point.  The elements of x[] must be strictly 
			monotone increasing.  x and y may be rows or columns,
			but must be p-conformable.
	Output:
		(b,c,d,x,y) array collecting the coefficients of the cubic 
			natural spline S(xx).  c[n]=0 while b[n] and d[n] are 
			left as missing.  Note that x is kept with the spline
			coefficients.  (If x and y are row vectors, 
			(b,c,d,x',y') is returned.)

	Source:
		Collected Algorithms from CACM
		Algorithm 472
		Procedures for Natural Spline Interpolation [E1]
		John G. Herriot, Computer Science Department, Stanford Univ.
		Christian H. Reinsch, Mathematisches Institut der Technischen
		Universitat, 8 Munchen 2, Germany.

		Algorithm CUBNATSPLINE, 472-P 5-0

		Translated from ALGOL into C for use in Stata, 1985.

		Translated from C into Mata for library inclusion, 1990.
*/

real matrix spline3(real vector x, real vector y)
{
	real scalar	i, n, m2
	real colvector	b, c, d
	real scalar	r, s

	if ((n=length(x)) != length(y)) _error(3200)

	if (n==0) return(J(0,5,.))


	b = c = d = J(n,1,.)
	
	m2 = n-1


	s = 0 
	for (i=1;i<=m2;i++) { 
		r = (y[i+1]-y[i]) / ( d[i]=x[i+1]-x[i] ) 
		c[i] = r - s 
		s = r 
	}

	r = s = c[1] = c[n] = 0 

	for (i=2;i<=m2;i++) {
		c[i] = c[i] + (r*c[i-1]) 
		b[i] = (x[i-1]-x[i+1])*2 - r*s 
		r    = (s=d[i]) / b[i] 
	}

	for (i=m2;i>=2;i--) c[i] = (d[i]*c[i+1]-c[i])/b[i] 

	for (i=1;i<=m2;i++) {
		b[i] = (y[i+1]-y[i])/d[i] - (2*c[i]+c[i+1])*d[i] 
		d[i] = (c[i+1]-c[i])/d[i] 
		c[i] = 3*c[i] 
	}
	return(cols(x)==1 ? (b,c,d,x,y) : (b,c,d,x',y'))
}

/*
	y = spline3eval(spline, x)

	Given real matrix spline obtained from spline3, and 
        vector x, splineeeval() returns p-conformable y(x) evaluated at the
        spline.  Elements of y are set to missing if outside the range of the
        spline.

	x is assumed to be monotonically increasing.

	x may be a row vector or column vector.

*/

real vector spline3eval(real matrix spline, real vector x)
{
	real scalar	i, j, n, m, m0
	real scalar	t
	real colvector	y

	n = length(x)
	m = rows(spline)
	y = J(rows(x),cols(x),.)

	if (rows(spline)==0) return(J(rows(x), cols(x), .))

			/* go forward through below range	*/
	t = spline[1,4]
	for (m0=j=1;j<=n;j++) {
		if (x[j]>=t) break 
	}


			/* begin approximations			*/
	for (i=j;i<=n;i++) { 
		for (j=m0;j<m;j++) { 		/* sic	*/
			if (x[i]>=spline[j,4] & x[i]<spline[j+1,4]) break 
		}
		if (j>=m) { 
			if (x[i]==spline[m,4]) j = m-1
		}
		if (j<m) { 
			t = x[i] - spline[j,4]
			y[i] = ((spline[j,3]*t + spline[j,2])*t + 
				 spline[j,1])*t + spline[j,5]
		}
		m0 = j 
	}
	return(y)
}
end
