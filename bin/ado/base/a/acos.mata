*! version 1.0.2  26dec2008
version 11.0
mata:

numeric matrix acos(numeric matrix x)
{
	complex matrix	y
	real scalar	i, j

	if (isreal(x)) return(acosr(x))

	/*
	   Re(acos()) is in the interval [0,pi].
	   Note that Im(acosh()) is in the interval [-pi, pi]
	    
	*/

	y = acosh(x):/(1i)
	for (i=1; i<=rows(y); i++) {
		for (j=1; j<=cols(y); j++) {
			if (Re(y[i,j])<=0) {
				if (Re(y[i,j]))	y[i,j] = -y[i,j]
				else if (Im(y[i,j])<0) y[i,j] = conj(y[i,j])
			}
		}
	}
	return(y)
}

end
