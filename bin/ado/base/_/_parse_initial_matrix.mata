*! version 1.0.0  24aug2016

local GENERAL	0
local VECH	1
local DIAGONAL	2

mata:

mata set matastrict on

real scalar _parse_initial_matrix(string scalar name, string scalar spec,
		string scalar option, real matrix X, string scalar errmsg)
{
	real scalar k, rc, r, c, order, nooutput
	string scalar tmat, cmd
	real matrix x

	pragma unset x

	order = `GENERAL'
	if (k=ustrlen(option)) {
		if (option == "vech") {
			order = `VECH'
		}
		else if (option == substr("diagonal",1,max((4,k)))) {
			order = `DIAGONAL'	
		}
		else {
			errmsg = sprintf("option {bf:%s} not allowed",option)
			return(198)
		}
	}
	nooutput = 1
	tmat = st_tempname()

	cmd = sprintf("matrix %s=%s",tmat,spec)
	if (rc=_stata(cmd,nooutput)) {
		errmsg = sprintf("failed to parse initial values for " +
			"matrix {bf:%s}; check the specification for ",name)
		if (rc == 111) {
			errmsg = errmsg + "an undefined reference"
		}
		else if (rc == 503) {
			errmsg = errmsg + "a conformability error"
		}
		else {
			errmsg = errmsg + "a syntax error"
		}
		return(rc)
	}
	x = st_matrix(tmat)

	cmd = sprintf("matrix drop %s",tmat)
	(void)_stata(cmd,nooutput)

	r = rows(x)
	c = cols(x)
	if (order == `VECH') {
		if (c == 1) {
			c = r
		}
		else if (r != 1) {
			rc = 198
		}
		else {
			x = x'
			r = c
		}
		if (!rc) {
			k = (-1+sqrt(1+8*c))/2
		}
		if (floor(floatround(k))!=floatround(k) | rc) {
			errmsg = sprintf("vector specified for matrix " +
				"{bf:%s} is of length %g; option {bf:vech} " +
				"requires a vector of length k*(k+1)/2, " +
				"where k is the order of the symmetric matrix",
				name,c)
			return(503)
		}
		X = invvech(x)
	}
	else if (order == `DIAGONAL') {
		if (c == 1) {
			c = r
		}
		else if (r != 1) {
			errmsg = sprintf("specification for matrix {bf:%s} " + 
				"is invalid; option {bf:diagonal} requires " + 
				"a vector of length k, where k is the order " +
				"of the square matrix",name)
			rc = 503
		}
		else {
			r = c
		}
		X = diag(x)
	}
	else {
		X = x
	}
	return(rc)
}

end
exit

