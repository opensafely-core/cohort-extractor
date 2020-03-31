*! version 1.0.0  15oct2004
version 9.0
mata:

/*	
	stats = panelstats(info)
		returns info on panels:
			stats[1] = # of panels (same as Rows(info))
			stats[2] = # of obs
			stats[3] = min(T_i)
			stats[4] = max(T_i)
*/

real rowvector panelstats(real matrix info)
{
	version 9.0

	real rowvector	stats
	real colvector	ti

	stats = J(1, 4, .)
	if ((stats[1] = rows(info))==0) return(stats)

	ti = (info[,2] - info[,1]) :+ 1
	stats[2] = colsum(ti)
	stats[3] = colmin(ti)
	stats[4] = colmax(ti)
	return(stats)
}

end
