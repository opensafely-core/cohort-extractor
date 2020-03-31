*! version 1.0.0  28jul2005
version 9.0

mata:

real matrix strtoreal(string matrix S)
{
	real matrix	R

	pragma unset R
	(void) _strtoreal(S, R)
	return(R)
}

end
