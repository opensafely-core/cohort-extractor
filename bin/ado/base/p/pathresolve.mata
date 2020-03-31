*! version 1.0.0  07dec2016
version 15
mata:

string scalar pathresolve(string scalar base, 
			string scalar path, 
			| string scalar loc)
{
	string scalar abspath
	
	abspath = _pathresolve(base, path)
	
	if(args() == 3) {
		st_local(loc, abspath)
	}
	
	return(abspath)
}

end
