*! version 1.0.0  15oct2004
version 9.0
mata:

void _edittoint(numeric matrix x, real scalar amt)
{
	_edittointtol(x, amt*epsilon( sum(abs(x)) / (rows(x)*cols(x)) ) )
}

end
