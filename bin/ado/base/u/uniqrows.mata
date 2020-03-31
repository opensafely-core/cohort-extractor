*! version 2.0.0  01sep2017
version 15.0

local N_INTEGER_TABLE_SORT 10000 // use integer table sort when x is an
                                 // integer colvector and rows(x)
				 // is greater than this value

mata:

/*
	uniqrows(transmorphic matrix x)
	uniqrows(transmorphic matrix x, real scalar 0)

		returns sorted, unique list.

	uniqrows(transmorphic matrix x, real scalar !0)

		returns sorted, unique list with frequency counts.
		The returned matrix has an extra column that contains the
		counts.

	uniqrowsfreq(transmorphic matrix x, real colvector freq)

		returns sorted, unique list with frequency counts in freq.
		This can be used when eltype(x) is string. It is undocumented.

	uniqrowsofinteger(real colvector x, | real scalar freq)

		bypasses integer check to save time and is undocumented.

	uniqrowssort(transmorphic matrix x, | real scalar freq)

		is a separate function because uniqrowsofinteger() may call it.
		It is undocumented.
*/

transmorphic matrix uniqrows(transmorphic matrix x, | real scalar freq)
{
	if (args() == 1) {
		freq = 0
	}

	if (  orgtype(x) == "colvector"
	    & eltype(x)  == "real"
	    & rows(x)    >  `N_INTEGER_TABLE_SORT') {

		if (all(x :== floor(x))) {
			return(uniqrowsofinteger(x, freq))
		}
	}

	return(uniqrowssort(x, freq))
}

transmorphic matrix uniqrowssort(transmorphic matrix x, | real scalar freq)
{
	real scalar	     n
	real colvector	     sel, count
	transmorphic matrix  xsort

	if (args() == 1) {
		freq = 0
	}

	if (rows(x) == 0) {
		return(J(0, cols(x) + (freq != 0), missingof(x)))
	}

	if (cols(x) == 0) {
		return(J(1, 0, missingof(x)))
	}

	if (eltype(x) == "string" & freq) {
		_error(3250) // type mismatch
	}

	n = rows(x)

	if (n == 1) {

		if (!freq) {
			return(x)
		}

		return(x, 1)
	}

	xsort = sort(x, 1..cols(x))

	sel = rowsum(J(1, cols(x), 1)
		\ (xsort[|2,.\.,.|] :!= xsort[|1,.\(n-1),.|]))

	if (!freq) {
		return(select(xsort, sel))
	}

	count = select(0::(n - 1), sel)

	if (rows(count) > 1) {
		count = (count[|2\.|] \ n) - count
	}
	else {
		count = (n)
	}

	return(select(xsort, sel), count)
}

transmorphic matrix uniqrowsfreq(transmorphic matrix x, real colvector freq)
{
	real scalar	     n
	real colvector	     sel, count
	transmorphic matrix  xsort

	if (rows(x) == 0) {
		freq = J(0, 1, .)
		return(J(0, cols(x), missingof(x)))
	}

	if (cols(x) == 0) {
		freq = J(0, 1, .)
		return(J(1, 0, missingof(x)))
	}

	xsort = sort(x, 1..cols(x))

	n = rows(xsort)

	if (n == 1) {
		freq = (1)
		return(x)
	}

	sel = rowsum(J(1, cols(x), 1)
		\ (xsort[|2,.\.,.|] :!= xsort[|1,.\(n-1),.|]))

	count = select(0::(n - 1), sel)

	if (rows(count) > 1) {
		freq = (count[|2\.|] \ n) - count
	}
	else {
		freq = (n)
	}

	return(select(xsort, sel))
}

real matrix uniqrowsofinteger(real colvector x, | real scalar freq)
{
	real scalar     i, n, nlimit, offset, value
	real colvector  m, minmax, mvalue, r
	real matrix     res

	if (args() == 1) {
		freq = 0
	}

	if (rows(x) == 0) {
		return(J(0, 1 + (freq != 0), .))
	}

	minmax = minmax(x)

	n = minmax[2] - minmax[1] + 1

	nlimit = 2*rows(x) // arbitrary

	if (n > nlimit) {
		return(uniqrowssort(x, freq))
	}

	r = J( n, 1, 0)
	m = J(27, 1, 0)

	mvalue = (.\.a\.b\.c\.d\.e\.f\.g\.h\.i\.j\.k\.l\.m\.n\.o\.p\.q\.r\.s\
	            .t\.u\.v\.w\.x\.y\.z)

	offset = minmax[1] - 1

	if (!freq) {

		for (i = 1; i <= rows(x); ++i) {

			value = x[i]

			if (value < .) {
				r[value - offset] = 1
			}
			else {
				m = m :| (mvalue :== value)
			}
		}

		return(select((minmax[1]::minmax[2] \ mvalue), r \ m))
	}

	for (i = 1; i <= rows(x); ++i) {

		value = x[i]

		if (value < .) {
			r[value - offset] = r[value - offset] + 1
		}
		else {
			m = m + (mvalue :== value)
		}
	}

	res = ((minmax[1]::minmax[2] \ mvalue), (r \ m))

	return(select(res, r \ m))
}

end

