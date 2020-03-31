*! version 2.0.1  26dec2008
version 11.0

mata:

numeric matrix acosh(numeric matrix x)
{
	complex matrix	y
	real scalar	i, j
	complex scalar	yij

	if (isreal(x)) return(acoshr(x))


	/* 
	   acosh() is to return nonnegative values along the real axis 
           (and in the interval [-i*pi, i*pi] along the imaginary).

	   Note that ln() returns values unbounded along the real 
	   axis and in the interval [-i*pi, i*pi] along the imaginary.
	*/

	y = ln(x+sqrt(x:*x:-1))
	for(i=1; i<=rows(y); i++) { 
		for (j=1; j<=cols(y); j++) { 
			if ( Re(yij=y[i,j]) <= 0) {
				y[i,j] = (Re(yij) ? -yij : C(0, abs(Im(yij))))
			}
		}
	}
	return(y) 
}

end
