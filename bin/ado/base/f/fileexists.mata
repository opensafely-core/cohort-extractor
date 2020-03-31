*! version 1.0.0  01nov2004
version 9.0
mata:

real scalar fileexists(string scalar filepath)
{
	real scalar	fd

	if ((fd = _fopen(filepath, "r")) >= 0) {
		fclose(fd) 
		return(1) 
	}
	return(0)
}

end
