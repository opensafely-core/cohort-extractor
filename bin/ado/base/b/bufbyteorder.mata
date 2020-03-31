*! version 1.0.0  04aug2005
version 9.0
mata:

function bufbyteorder(colvector C, |real scalar newvalue)
{
	if (args()==1) return(C[1])
	if (newvalue!=1 && newvalue!=2) _error(3300)
	C[1] = newvalue
	/* return void in this case */
}

end
