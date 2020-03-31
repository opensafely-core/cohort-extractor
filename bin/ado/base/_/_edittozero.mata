*! version 1.0.0  15oct2004
version 9.0
mata:

void _edittozero(numeric matrix x, real scalar amt)
{
	_edittozerotol(x, abs(amt)*epsilon( sum(abs(x)) / (rows(x)*cols(x)) ) )
}

end
