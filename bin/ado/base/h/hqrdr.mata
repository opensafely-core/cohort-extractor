*! version 1.0.0  30sep2004
version 9.0

mata:

numeric matrix hqrdr(numeric matrix H)
{	
	scalar 		zero
	numeric matrix 	R

	R    = uppertriangle(H,.)
	if (rows(H) > cols(H)) {
		zero = iscomplex(H) ? 0i: 0
		R    = R \ J((rows(H) - cols(H)), cols(H), zero)
	}
	else if (rows(H) < cols(H)) {
		_error(3200)		/* MRC_conformability */
	}

	return(R)
}

end
