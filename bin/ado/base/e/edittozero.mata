*! version 1.0.0  15oct2004
version 9.0
mata:

numeric matrix edittozero(numeric matrix x, real scalar amt) 
{
	return(edittozerotol(x, amt*epsilon( sum(abs(x)) / (rows(x)*cols(x)) )))
}

end
