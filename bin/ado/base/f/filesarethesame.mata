*! version 1.0.0  22dec2016
version 15
mata:

real scalar filesarethesame(
	string scalar file1, 
	string scalar file2,
	string scalar loc)
{
	real scalar issame 
	
	issame = issamefile(file1, file2)
	if(issame) {
		st_local(loc, "1")
	}
	else {
		st_local(loc, "0")
	}
	return(issame)
}

end
