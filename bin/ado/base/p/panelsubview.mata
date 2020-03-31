*! version 1.0.0  15oct2004
version 9.0
mata:

/*	
	panelsubview(SV, V, i, info)
		return matrix in sv containing i-th panel.
		SV will be a subview if V is a view.
*/


void panelsubview(SV, matrix V, real scalar i, real matrix info)
{
	version 9.0
	st_subview(SV, V, info[i,], .)
}

end
