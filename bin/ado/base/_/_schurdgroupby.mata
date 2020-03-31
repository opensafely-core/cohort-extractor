*! version 1.0.0  24feb2009
version 11.0

mata:

void _schurdgroupby(numeric matrix T, pointer scalar f, 
		numeric matrix Q, w, numeric scalar m)
{ 
	real scalar 	dim, i, n, info
	real scalar 	s, sep
	real rowvector 	select

	if(rows(T) != cols(T)) {
		_error(3200)
		return
	}
	
	if(hasmissing(T)) {
		Q = J(rows(T), cols(T), .)
		w = J(1, cols(T), .)
		m = 0
		return
	}
	
	s 	= 0 
	sep 	= 0	
	n 	= cols(T)
	
	(void)_hessenbergd_la(T, Q=., 1, n, 0, 1)	
	
	_flopin(T)
	
	info	= _schurd_la(T, Q, w=., 1, n, 1, 1)

	if(info) {
		Q = T = .
		return
	}
	
	select	= J(1, n, 0)
	dim 	= 0
	
	for(i = 1; i <= n; i++) {
		if((*f)(w[1, i])) {
	       		dim++
	       		select[1, i] = 1
	       	}
	} 	

	if(dim == 0 || dim == n) {
		m = dim
		
		_flopout(Q)
		_flopout(T)
		
		return	
	}

	(void)_schurdgroupby_la(T, Q, w, select, 1, 0, m, s, sep)
}

end
