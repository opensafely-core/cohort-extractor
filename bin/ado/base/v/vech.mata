*! version 2.0.1  16sep2015
version 9.0
mata:

transmorphic colvector vech(transmorphic matrix x, |real scalar skipdiag)
{
	transmorphic matrix	res
	real scalar		n, k, j, sd

	if ((n=rows(x)) != cols(x)) _error(3205) // not square

	if (args() == 1) {
		skipdiag = 0
	}
	sd = skipdiag != 0
	if (sd) {
		n--
	}
	
	res = J((n*(n+1))/2, 1, missingof(x))

	if (n>0) {
		if (eltype(x)=="real" | eltype(x)=="complex") {
			_vech_u(x, res, sd)
		}
		else {
			for (k=j=1; j<=n; j++) {
				res[|k\(k+n-j)|] = x[|(j+sd,j)\(n+sd,j)|]
				k = k + n-j + 1
			}
		}
	}
	return(res)
}

end

