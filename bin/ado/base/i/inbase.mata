*! version 1.0.2  06nov2017

version 10.0

mata:


string matrix inbase(real scalar base, real matrix x, 
			|real scalar fdigits, transmorphic err)
{
	real scalar	i, j, e
	string matrix	r

	pragma unset e

	r = J(rows(x), cols(x), "")

	if (args()==4) {
		err = J(rows(x), cols(x), .)
		for (i=rows(x); i; i--) {
			for (j=cols(x); j; j--) {
				r[i,j] = inbase_scalar(base, x[i,j], fdigits, e)
				err[i,j] = e
			}
		}
	}
	else {
		for (i=rows(x); i; i--) {
			for (j=cols(x); j; j--) {
				r[i,j] = inbase_scalar(base, x[i,j], fdigits)
			}
		}
	}
	return(r)
}


/*static*/ string scalar inbase_scalar(real scalar base, real scalar userx, 
		|real scalar userfdigits, real scalar err)
{
	string scalar	digits, sign, ipres, fpres
	real scalar	fdigits, x, ip, fp, topp, p, P, d
	real scalar	i

	/* ------------------------------------------------------------ */
	err = . 
	if (base<2 | base>62 | base!=floor(base)) return(".")
	digits = bsubstr(
	       "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
		1, base)
	if ((fdigits=userfdigits)>=.) fdigits = 8
	else if (fdigits<1 | fdigits>1000 | fdigits!=floor(fdigits)) {
		return(".")
	}

	/* ------------------------------------------------------------ */
	err = 0 
	if (userx>=.) return(".")

	if (userx<0) { 
		x = -userx 
		sign = "-"
	}
	else {
		x = userx 
		sign = ""
	}

	ip = floor(x)
	fp = (ip!=x ? x-ip : 0)

	if (ip) {
		topp = -1
		for (P=1; P<=ip; P = P*base) {
			topp++
			p = P
		}

		ipres = ""
		for (i=topp; i>=0; i--) {
			d = floor(ip/p)
			ip= ip - d*p
			ipres = ipres + bsubstr(digits, d+1, 1)
			p = p/base
		}
	}
	else	ipres = "0"

	if (fp) {
		fpres = ""
		p = 1/base
		for (i=1; i<=fdigits & fp; i++) {
			d = floor(fp/p)
			fp= fp - d*p
			fpres = fpres + bsubstr(digits, d+1, 1)
			p = p/base
		}
		err = fp
		for (i=strlen(fpres); bsubstr(fpres, i, 1)=="0"; i--) {
			fpres = bsubstr(fpres, 1, i-1)
		}
		if (fpres!="") ipres = ipres + "." + fpres
	}

	return(sign + ipres)
}

end
