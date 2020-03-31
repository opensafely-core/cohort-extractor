*! version 1.0.0  15oct2004
version 9.0
mata:

real matrix function designmatrix(real colvector v)
{
	scalar	i 
	matrix	res 

	if (rows(v)==0) return(J(0,0,.))
	res = J(rows(v),colmax(v),0)
	for (i=1;i<=rows(res);i++) res[i,v[i]] = 1
	return(res)
}

end
