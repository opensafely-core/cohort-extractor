*! version 1.0.0  22dec2016
version 15
mata:

string scalar pathchangesuffix(
	string scalar upath, 
	string scalar suf,
	| string scalar loc,
	  real scalar fullpath)
{
	string scalar newpath, newsuf
	
	newpath = strtrim(upath)
	if((strrpos(newpath, "/") == strlen(newpath)) || 
	   (strrpos(newpath, "\") == strlen(newpath)) ||
	   (strrpos(newpath, ":") == strlen(newpath))) {
		return("")	
	}

	newpath = pathrmsuffix(newpath)
	newsuf = strtrim(suf)
	if(strpos(newsuf, ".") == 1) {
		newpath = newpath + newsuf
	}
	else {
		newpath = newpath + "." + newsuf	
	}
	
	if(args() == 4) {
		if(fullpath == 0) {
			newpath =  pathbasename(newpath)
		}
	}
	
	if(args() >= 3) {
		st_local(loc, newpath)
	}
	return(newpath)
}

end
