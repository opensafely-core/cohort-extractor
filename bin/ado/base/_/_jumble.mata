*! version 1.0.0  15oct2004
version 9.0
mata:

function _jumble(transmorphic matrix x)
{
	_collate(x,unorder(rows(x)))
}

end
