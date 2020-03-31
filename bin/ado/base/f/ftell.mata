*! version 1.0.0  15oct2004
version 9.0
mata:

real scalar ftell(real scalar fh)
{
	real scalar	res 

	if ((res = _fseek(fh, 0, 0)) < 0) _error(-res)
	return(res)
}

end
