*! version 1.0.1  06jan2005
version 9.0

mata:

void hqrdp(numeric matrix A, H, tau, R, real rowvector p) 
{
	_hqrdp_la(H=A, tau=., p)
	R = uppertriangle(H, .)
}

end
