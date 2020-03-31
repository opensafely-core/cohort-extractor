*! version 1.0.0  28sep2009
version 11

mata:

real matrix codingmat(	string	scalar	type,
			real	scalar	dim,
			|real	vector	levels,
			real	vector	weight,
			real	scalar	base)
{
	real	matrix	C

	C = contrastmat(type,dim,levels,weight,base) \ J(1,dim,1)
	C = C*invsym(cross(C,C))
	return(C[|_2x2(1,1,dim-1,dim)|])
}

end
