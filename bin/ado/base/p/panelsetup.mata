*! version 1.0.1  24aug2008
version 9.0
mata:

/*	

	info = panelsetup(V, idcol, [minobs, [maxobs]])
		info will contain the obs ranges for the panels, e.g., 
		(1,5\5,8\9,11) meaning panel 1 is (1,5), panel 2 is 
		(5,8), and panel 3 is (9,11).  There are rows(info) panels.

			minobs = minimum number of obs for panel, 
			maxobs = maximum number of obs for panel, or ., or 0

*/

real matrix panelsetup(matrix V, real scalar idcol,
			|real scalar minobs, real scalar maxobs)
{
	version 9.0

	real matrix	info
	real scalar	i

	if (args()<3) minobs = 1
	if (maxobs<0) _error(3300)

	info = panelsetup_u(V, idcol, minobs, (maxobs ? maxobs : .))
	if (maxobs>0) return(info)

	/* 
		balanced panels
	*/
	if (rows(info)==0) return(info)

	/*
		balanced-min rule
		Let T_i = # of obs in panel i
		Discard for which T_i<min
		Let q be the min(T_i) after discard
		Choose panels such that all panels have q obs
	*/
	i = colmin(info[,2]-info[,1])+1
	return(panelsetup_u(V, idcol, i, i))
}


/* static */ real matrix panelsetup_u(matrix V, real scalar idcol, 
				      real scalar min, real scalar max)
{
	version 9.0

	real scalar	i, n, np, ti, i0
	scalar		curid
	real matrix	info

	n = rows(V)

	if (n == 0) {
		/* no rows, means no panels */
		return(J(0,2,.))
	}

	curid = V[1, idcol]
	np = ti = 0
	for (i=2; i<=n; i++) {
		ti++
		if (V[i, idcol] != curid) {
			if (ti>=min) np++ 
			curid = V[i, idcol]
			ti    = 0
		}
	}
	if (ti+1>=min) np++
	info = J(np, 2, .)

	curid = V[1, idcol]
	np = ti = 0
	i0 = 1
	for (i=2; i<=n; i++) {
		ti++
		if (V[i, idcol] != curid) {
			if (ti>=min) {
				info[++np, .] = (i0, (i-i0>max ? i0+max : i)-1)
			}
			i0 = i
			curid = V[i, idcol] 
			ti    = 0
		}
	}
	ti++
	if (ti>=min) info[++np, .] = (i0, (i-i0>max ? i0+max : i)-1)
	return(info)
}

end
