*! version 1.1.1  06nov2017
version 9.0
mata:

void fbufput(real matrix H, real scalar fh, string scalar bfmt, matrix X)
{
	string scalar 	buf
	
	buf = bufbfmtlen(bfmt)*rows(X)*cols(X)*char(0)
	bufput(H, buf, 0, bfmt, X)
	fwrite(fh, buf)
}

end

