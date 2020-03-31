*! version 1.0.2  06nov2017
version 10.0

mata:
string scalar invtokens(string rowvector s, | string scalar separator) 
{
	real scalar 	lenv, lensep, pos, j, cs, nseps
	string scalar	s2, sep

	sep = (args()==1 ? " " : separator) 

	lensep = strlen(sep)
	lenv   = strlen(s)
	cs     = cols(s)

	if (cs ==0)  return("")

	nseps = cs-1
	
	s2 = (rowsum(strlen(s))+nseps*lensep)*" "

	_substr(s2,s[1],1)
	pos = 1 + lenv[1]
	for(j=2;j<=cs; j++) {
		_substr(s2,(sep + s[j]),pos)
		pos = pos + lensep + lenv[j] 
	}
	return(s2)
}

end
