*! version 1.0.0  04aug2005
version 9.0
mata:

function bufmissingvalue(colvector C, |real scalar newvalue)
{
	if (args()==1) return(C[2])
	if (newvalue<100 | newvalue>stataversion()) _error(3300)
	C[2] = newvalue
	/* return void in this case */
}

end
