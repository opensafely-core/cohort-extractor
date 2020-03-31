*! version 1.0.0  15oct2004
version 9.0
mata:

real vector invorder(real vector p)
{
	real vector	p2
	real scalar	r, c

	if ((r=rows(p))==0 | (c=cols(p))==0) return(J(r,c,.))
	p2 = p				// just to dimension p2
	p2[p] = (r>1 ? 1::r : 1..c)
	return(p2)
}

end
