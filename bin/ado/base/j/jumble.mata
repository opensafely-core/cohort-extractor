*! version 1.0.0  15oct2004
version 9.0
mata:

transmorphic matrix jumble(transmorphic matrix x)
{
	return(x[unorder(rows(x)), .])
}

end
