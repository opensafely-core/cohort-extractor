*! version 1.0.1  01jun2013
version 9.0
mata:

/*	
	X = panelsubmatrix(V, i, info)
		return matrix containing i-th panel.
*/


matrix panelsubmatrix(matrix V, real scalar i, real matrix info)
{
	return(V[|info[i,1], 1 \ info[i,2], .|])
}
	
end
