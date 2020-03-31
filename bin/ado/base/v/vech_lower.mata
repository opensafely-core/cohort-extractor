*! version 1.0.0  16sep2015
version 14
mata:

transmorphic colvector vech_lower(transmorphic matrix x)
{
	return(vech(x,1))
}

end

