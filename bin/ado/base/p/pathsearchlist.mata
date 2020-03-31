*! version 1.0.0  28oct2005
version 9.0
mata:

string rowvector pathsearchlist(string scalar fname)
{
	string scalar		subfname, dirsep, el
	string rowvector	orig, res
	real scalar		cols, i, j


	dirsep = c("dirsep")
	subfname = adosubdir(fname) + dirsep + fname
	
	orig = pathsubsysdir(pathlist())
	cols = cols(orig)

	res = J(1, cols*2, "")

	for (i=1; i<=cols; i++) {
		el = orig[i]
		j = 2*(i-1) + 1
		res[j] = pathjoin(el, fname)
		res[j+1] = pathjoin(el, subfname)
	}
	return(res)
}

end
