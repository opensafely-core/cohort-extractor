*! version 1.0.1  19nov2006
version 9.0
mata:

string rowvector pathlist(|string scalar dirpath)
{
	real scalar		i
	string rowvector	tok
	string rowvector	res

	tok = tokens(args()==0 ? c("adopath") : dirpath, ";")
	pragma unset res
	for (i=1; i<=cols(tok); i++) {
		if (tok[i]!=";") res = res, tok[i]
	}
	return(res)
}

end
