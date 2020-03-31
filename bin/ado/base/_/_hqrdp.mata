*! version 1.0.1  06jan2005
version 9.0

mata:

void _hqrdp(numeric matrix A, tau, R, real rowvector p) 
{
	_hqrdp_la(A,tau=., p)
	R = uppertriangle(A,.)
}

end
