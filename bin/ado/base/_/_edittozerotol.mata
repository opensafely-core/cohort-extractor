*! version 1.0.0  15oct2004
version 9.0
mata:

void _edittozerotol(numeric matrix x, real scalar usertol) 
{
	real scalar	tol 
	real scalar	i, j, r, c
	real scalar	xr, xi 
	complex scalar	z

	version 9

	if ( (tol = abs(usertol)) == .) return
	r = rows(x)
	c = cols(x)
	if (isreal(x)) { 
		for (i=1;i<=r;i++) { 
			for (j=1;j<=c;j++)  if (abs(x[i,j])<=tol) x[i,j] = 0 
		}
	}
	else {
		for (i=1;i<=r;i++) { 
			for (j=1;j<=c;j++) { 
				z = x[i,j]
				if (abs(xr = Re(z)) <= tol ||
				    abs(xi = Im(z)) <= tol) {
					if (abs(xr) <= tol) xr = 0 
					if (abs(xi) <= tol) xi = 0 
					x[i,j] = C(xr, xi)
				}
			}
		}

	}
}

end
