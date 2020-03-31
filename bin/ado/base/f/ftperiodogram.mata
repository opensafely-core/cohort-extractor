*! version 1.0.0
version 9.0
mata:

real vector ftperiodogram(numeric vector H)
{
	real scalar	n, m
	real scalar	j, k, i
	real colvector	res

	n = length(H)
	m = n/2 
	if (m != trunc(m)) _error(3200)

	res = (rows(H)==1 ? J(1, m, 0) : J(m, 1, 0))
	j=2
	k=n
	for (i=1;i<=m;i++) { 
		res[i] = (j==k ? abs(H[j])^2 : abs(H[j])^2 + abs(H[k])^2)
		j++
		k--
	}
	return(res)
}
	
end
