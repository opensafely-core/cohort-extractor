*! version 1.0.1  06jan2005
version 9.0

mata:

void _matpowersym(numeric matrix A, real scalar p)
{
	_symmatfunc_work(0, A, p)
}

end
