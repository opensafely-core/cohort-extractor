*! version 1.0.0  22may2019
version 16

mata:

real colvector st_matrixrowstripe_order(string scalar mname)
{
	string	matrix	stripe

	stripe = st_matrixrowstripe(mname)
	return(st_ms_order(stripe))
}

real colvector st_matrixcolstripe_order(string scalar mname)
{
	string	matrix	stripe

	stripe = st_matrixcolstripe(mname)
	return(st_ms_order(stripe))
}

real colvector st_ms_order(string matrix stripe, |real scalar bylen)
{
	real	scalar		rows
	real	scalar		maxcols
	string	matrix		names
	real	scalar		digits
	string	scalar		rfmt
	string	scalar		nfmt
	real	colvector	order
	real	scalar		r
	string	scalar		cmd
	real	scalar		rc
	real	scalar		k_names
	real	scalar		offset
	real	scalar		c
	string	scalar		name
	real	scalar		eqidx
	string	scalar		eq0
	string	scalar		eqr

	assert(cols(stripe) == 2)

	if (rows(stripe) == 0) {
		return(J(0,1,.))
	}

	if (args() == 1) {
		bylen = 0
	}

	rows	= rows(stripe)
	maxcols	= c("max_it_fvars") + c("max_it_cvars")
	names	= J(rows,maxcols+2,"")
	digits	= ceil(log(rows)/log(10))
	rfmt	= "%0" + strofreal(digits) + ".0f"
	nfmt	= "%0" + strofreal(c("namelen")) + ".0f"
	order	= 1::rows
	names[,maxcols+2] = strofreal(order, rfmt)

	eqidx	= 0
	eq0	= ""
	for (r=1; r<=rows; r++) {
		eqr = stripe[r,1]
		if (eqr != eq0) {
			eqidx++
			eq0 = eqr
		}
		names[r,1] = strofreal(eqidx, rfmt)
		cmd = sprintf("_ms_parse_parts %s", stripe[r,2])
		rc = _stata(cmd)
		if (rc) exit(rc)
		if (st_global("r(type)") == "interaction") {
			k_names = st_numscalar("r(k_names)")
			offset = maxcols + 1 - k_names
			for (c=1; c<=k_names; c++) {
				name = st_global(sprintf("r(name%f)", c))
				if (bylen) {
					name = strofreal(udstrlen(name), nfmt)
				}
				names[r,c+offset] = name
			}
		}
		else {
			name = st_global("r(name)")
			if (name == "_cons") {
				c = 2
			}
			else {
				c = maxcols + 1
			}
			if (bylen) {
				name = strofreal(udstrlen(name), nfmt)
			}
			names[r,c] = name
		}
	}

	return(order(names, (1..(maxcols+2))))
}

end

exit
