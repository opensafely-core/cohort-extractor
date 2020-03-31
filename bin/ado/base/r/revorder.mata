*! version 1.0.1  15dec2004
version 9.0
mata:

real vector revorder(real vector p)
{
	real scalar	r, c

	if ((r=rows(p))==0 | (c=cols(p))==0) return(J(r,c,.))
	return(p[(r>c ? r : c)::1])
}

end
