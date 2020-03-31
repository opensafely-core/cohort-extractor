*! version 1.0.0  15oct2004
version 9.0
mata:

void _edittointtol(numeric matrix x, real scalar usertol)
{
	real scalar	tol 
	real scalar	i, j, r, c
	real scalar	rx, ix, rxr, ixr
	complex scalar	z

	if ( (tol = abs(usertol)) == .) return
	r = rows(x)
	c = cols(x)
	if (isreal(x)) { 
		for (i=1;i<=r;i++) { 
			for (j=1;j<=c;j++) {
				rxr = round(rx=x[i,j])
				if (abs(rx-rxr)<=tol) x[i,j] = rxr 
			}
		}
	}
	else {
		for (i=1;i<=r;i++) { 
			for (j=1;j<=c;j++) { 
				rxr = round(rx = Re(z=x[i,j]))
				ixr = round(ix = Im(z))
				if (abs(rx-rxr)<=tol) rx = rxr
				if (abs(ix-ixr)<=tol) ix = ixr
				x[i,j] = C(rx,ix) 
			}
		}

	}
}
end
