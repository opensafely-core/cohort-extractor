*! version 1.0.1  02feb2015

version 10.0

mata:


real matrix frombase(real scalar base, string matrix s)
{
	real scalar	i, j
	string matrix	r

	r = J(rows(s), cols(s), .)
	for (i=rows(s); i; i--) {
		for (j=cols(s); j; j--) r[i,j] = frombase_scalar(base, s[i,j])
	}
	return(r)
}


/*static*/ real scalar frombase_scalar(real scalar base, string scalar users)
{
	string scalar	s, c, ip, fp, digits
	real scalar	i, n, sign, resip, resfp, p, d

	/* ------------------------------------------------------------ */
	if (base<2 | base>62 | base!=floor(base)) return(.)
	digits = bsubstr(
	      "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVYXYZ",
		1, base)
	if ((s = strtrim(users)) == "") return(.)
	if (base<=36) s = strlower(s)

	/* ------------------------------------------------------------ */
					/* set sign		*/
	c = bsubstr(s, 1, 1)
	sign = 1
	if (c=="+" | c=="-") {
		if ((s = bsubstr(s, 2, .)) == "") return(.)
		if (c=="-") sign = -1 
	}

	/* ------------------------------------------------------------ */
					/* split on base point	*/
	if (i = strpos(s, ".")) {
		ip = bsubstr(s, 1, i-1)
		fp = bsubstr(s, i+1, .)
		if (ip=="" & fp=="") return(.)
	}
	else {
		ip = s
		fp = ""
	}

	/* ------------------------------------------------------------ */
	resip = resfp = 0
	p = 1
	for (i=strlen(ip); i; i--) {
		c = bsubstr(ip, i, 1)
		if (d = strpos(digits, c)) {
			resip = resip + (d-1)*p 
			p = p*base
		}
		else 	return(.)
	}

	n = strlen(fp)
	p = 1/base
	for (i=1; i<=n; i++) {
		c = bsubstr(fp, i, 1)
		if (d = strpos(digits, c)) {
			resfp = resfp + (d-1)*p
			p = p/base
		}
		else	return(.)
	}

	return(sign*(resip+resfp))
}

end
