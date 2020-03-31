*! version 2.0.0  05mar2008
version 9.0
mata:

transmorphic colvector vec(transmorphic matrix x)
{
	transmorphic matrix	res 
	real scalar		r, c
	real scalar		j, k

	r = rows(x)
	c = cols(x)
	
	res = J(r*c, 1, missingof(x))

	if (r>0) {
		if (eltype(x)=="real" | eltype(x)=="complex") {
			_vec_u(x, res)
		}
		else{
			for (k=j=1; j<=c; j++) {
				res[|k\(k+r-1)|] = x[.,j]
				k = k + r
			}
		}
	}
	return(res)
}

end
