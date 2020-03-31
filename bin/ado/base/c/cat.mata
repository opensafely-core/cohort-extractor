*! version 2.0.1 24jan2006
version 9.0
mata:

string colvector cat(string scalar filename, 
			|real scalar uline1, real scalar line2)
{
	real scalar 		fh, fpos, line1, i, n
	string matrix		EOF
	string colvector	res
	string scalar		line

	/* ------------------------------------------------------------ */
					/* setup 			*/
	fh  = fopen(filename, "r")
	EOF = J(0, 0, "")

	line1 = floor(uline1)
	if (line1<1 | line1>=.) line1 = 1 

	/* ------------------------------------------------------------ */
					/* nothing to read case		*/
	if (line1>line2) {
		fclose(fh)
		return(J(0, 1, ""))
	}


	/* ------------------------------------------------------------ */
					/* skip opening lines		*/
	for (i=1; i<line1; i++) {
		if (fget(fh)==EOF) {
			fclose(fh)
			return(J(0, 1, ""))
		}
	}
	fpos = ftell(fh)
	

	/* ------------------------------------------------------------ */
					/* line2 is defined 		*/
	if (line2 < .) {
		res = J(n = line2-line1+1, 1, "") 
		for (i=1; i<=n; i++) {
			if ((line = fget(fh))==EOF) {
				fclose(fh)
				if (--i) return(res[|1\i|])
				return(J(0, 1, ""))
			}
			res[i] = line
		}
		fclose(fh)
		return(res)
	}
	
	/* ------------------------------------------------------------ */
					/* count lines			*/
	for (i=line1; i<=line2; i++) {
		if (fget(fh)==EOF) break 
	}
	res = J(n = i-line1, 1, "")	// (n==0 okay)


	/* ------------------------------------------------------------ */
					/* read lines			*/
	fseek(fh, fpos, -1)
	for (i=1; i<=n; i++) {
		if ((line=fget(fh))==EOF) {
			/* unexpected EOF -- file must have changed */
			fclose(fh)
			if (--i) return(res[|1\i|])
			return(J(0,1,""))
		}
		res[i] = line
	}
	fclose(fh)
	return(res)
}

end
