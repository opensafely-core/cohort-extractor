*! version 1.0.0  09nov2004
version 9.0
mata:

numeric matrix edittoint(numeric matrix x, real scalar amt)
{
	return(edittointtol(x, amt*epsilon( sum(abs(x)) / (rows(x)*cols(x)) ) ))
}

end
