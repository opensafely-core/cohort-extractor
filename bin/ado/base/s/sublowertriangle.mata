*! version 1.0.1  18mar2009
version 11.0

mata:

numeric matrix sublowertriangle(numeric matrix A, | real scalar p) 
{
        numeric matrix  k_a
	real scalar 	d

	if(args()==1) {
		d = 0
	}
	else {
		d = p
	}
	
	k_a = .
	
	if(isfleeting(A)) {
		_sublowertriangle(A, d)
		return(A)
	}
	else {
		_sublowertriangle(k_a=A, d)
		return(k_a)
	}
}

end


