*! version 1.0.3  02may2007
version 9.0

mata:

void _hqrd(numeric matrix H, tau, R1)
{
	real rowvector 	p

	p = J(1, cols(H), 1)
	_hqrdp(H,tau=., R1, p)
/*
					check that no pivoting occurred 
	if (rows(H)>0 && cols(H)>0) {					
		if( mreldif(p , 1..cols(H)) > 1e-15 ) _error(3930)
	}
*/

}

end
