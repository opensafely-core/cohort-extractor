*! version 1.0.0  15oct2004
version 9.0
mata:

transmorphic matrix sort(transmorphic matrix x, real rowvector idx)
{
	return(x[order(x,idx), .])
}

end
