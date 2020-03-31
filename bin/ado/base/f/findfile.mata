*! version 1.0.1  20oct2005
version 9.0
mata:

string scalar findfile(string scalar fn, |string scalar p)
{
	real scalar		i
	string rowvector	path
	string scalar		el, subdir, fullname

	if (fn=="") return("")
	subdir = adosubdir(fn)

	path = (args()==1 ? pathlist() : pathlist(p))
	for (i=1; i<=cols(path); i++) {
		el = pathsubsysdir(path[i])
		fullname = pathjoin(el, fn)
		if (fileexists(fullname)) return(fullname)
		fullname = pathjoin(pathjoin(el, subdir), fn)
		if (fileexists(fullname)) return(fullname)
	}
	return("")
}

end
