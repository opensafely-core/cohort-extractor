*! version 1.0.1  21dec2004
version 9.0
mata:

transmorphic matrix invvech(transmorphic colvector v)
{
	real scalar		n, k, j
	transmorphic matrix	x

	n = (sqrt(1+8*rows(v))-1)/2
	if (n<0 | n!=trunc(n)) _error("invalid vech")

	x = J(n, n, missingof(v))
	if (n>0) {
		for (k=j=1; j<=n; j++) {
			x[|(j,j)\(n,j)|] = v[|k\(k+n-j)|]
			k = k + n-j + 1
		}
	}
	_makesymmetric(x)
	return(x)
}

end
