*! version 1.0.0  15oct2004
version 9.0
mata:

function _sort(transmorphic matrix x, real rowvector idx)
{
	_collate(x, order(x, idx))
	/* x = x[order(x,idx), .] */
}

end
