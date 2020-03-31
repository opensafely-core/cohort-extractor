*! version 1.0.1  06nov2017
version 9.0

/*
	info = cvpermutesetup(V [, unique])

	real colvector cvpermute(info)


	Description of the contents of info:
		1.		1 -> unique
		2.		n = number of elements
		3.		m = current location
		4.		element 1
		5.		element 2
		...
		3+n.		element n

		3+n+1.		n-1
		3+n+2.		m = current location
		3+n+3.		element 2
		3+n+4.		element 3
		...
		etc.		until n-k = 2

	Let i0 be the base index - 1 for a group (i0=1 if the first 
	group, i0 = 3+n for the second, and so on), then 

		i0+1.		n = number of elements
		i0+2.		m = current location 
		i0+3.		element 1
		i0+4.		element 2
		...
		i0+3+n-1.	element n  and also next i0

	Example:

	Let V[] have N elements.

	N=2: (U,  2, #, x1, x2)
	N=3: (U,  3, #, x1, x2, x3,   2, #, y1, y2)
	N=4: (U,  4, #, x1, x2, x3, x4,   3, #, y1, y2, y3,   2, #, z1, z2)

	Ignoring U, 
		The 1st entry has N+2 elements
		The 2nd entry has N+2-1 elements
		The 3rd entry has N+2-2 element
		...
		The last entry has 4 elements

	total number of entries (ignoring U) is N+2 + N+2-1 + ... + 4.
*/


local UNIQUE 	1

local FIRST_n	2
local FIRST_m	3
local FIRST_el0	3

local FIRST_OFFSET	1

mata:

real rowvector cvpermutesetup(real colvector V, |real scalar unique)
{
	real scalar 	n, sum, isunique
	real rowvector	info
	real colvector	hold
	
	isunique = (args()==1 ? 0 : unique!=0)
	if ((n   = length(V))==0) return(J(1,3,0))
	if (n==1) {
		info = J(1, 4, 0)
		info[1] = isunique
		info[2] = info[3] = 1
		info[4] = V
		return(info)
	}

	/* 
		rows(info) = (4 + 5 + ... + n+2) + `FIST_OFFSET'

		The sum of (1,2,...k) is ((1+k)*k)/2
		Thus, the sum of (1, 2, ..., n+2) is ((3+n)*(n+2))/2
		and the from 4 is ((3+n)*(n+2))/2 - 6

		Alternative code:
		real scalar i
		sum = 0 
		for (i=4; i<=n+2; i++) sum = sum + i 
	*/
	sum = round(((3+n)*(n+2))/2)-6
	info = J(1, sum+`FIRST_OFFSET', 0)

	info[`UNIQUE']  = isunique
	info[`FIRST_n'] = n
	info[`FIRST_m'] = 1

	if (isunique) info[|`FIRST_el0'+1\(`FIRST_el0'+n)|] = V'
	else {
		_sort(hold=V, 1)
		_transpose(hold)
		info[|`FIRST_el0'+1\(`FIRST_el0'+n)|] = hold
	}

	cvpermute_setupnext(info, `FIRST_OFFSET')
	return(info)
}


/* static */
void cvpermute_setupnext(
	real rowvector info,		// information vector
	real scalar i0)			// caller's base location in info[]
{
	real scalar n1, n2
	real scalar j0

	/*
	info :=               
                                               j0+1
                                                 |
                     i0+1   i0+3        i0+2+n1  |    j0+3
		       |      |            |     |      |
		(..., n1, m, x1, x2, ..., xn1,  n2, m, x1, x2, ..., xn2, ...)
                          |       |        |        |                |
                        i0+2    i0+4      j0      j0+2            j0+2+n2
	*/

	n1 = info[i0+1]
	if (n1==2) return

	j0 = i0+2+n1

	info[j0+1] = n2 = n1-1
	info[j0+2] = 1

	info[|j0+3\j0+2+n2|] = info[|i0+4\i0+2+n1|]

	cvpermute_setupnext(info, j0)
}

real colvector cvpermute(real rowvector info)
{
	real vector	res

	res = J(1, info[2], .)
	if (cvpermute_u(res, info, 1)) _transpose(res)
	else			     res = J(0, 1, .)
	return(res)
}


/* static */
real scalar cvpermute_u(real rowvector res, real rowvector info, real scalar i0)
{
	real scalar	i, n, m, mloc, lastel, firstel
	real scalar	nres
	real scalar	value

	nres = length(res)
	n = info[i0+1]
	m = info[mloc = i0+2]

	firstel = mloc + 1
	lastel  = mloc + n

	if (n==2) {
		if (m==1) {
			res[nres-1] = info[firstel]
			res[nres]   = info[lastel]
			info[mloc]  = 2
			return(1)
		}
		if (m==2) {
			if (!info[`UNIQUE']) {
				if (info[firstel]==info[lastel]) return(0)
			}
			res[nres-1] = info[lastel]
			res[nres]   = info[firstel]
			info[mloc]  = 3 
			return(1)
		}
		return(0)
	}

	if (n<=1) {		// n==1 arises only when there is 1 element
		if (n==0) return(0)
		if (m==1) {
			info[mloc] = 2 
			res[nres] = info[firstel]
			return(1)
		}
		return(0)
	}


	res[nres-n+1] = info[firstel]
	if (cvpermute_u(res, info, lastel)) return(1)

	value  = info[firstel]
	if (!info[`UNIQUE']) {
		for (i=mloc+m+1; i<=lastel; i++) {
			if (value != info[i]) {
				info[mloc] = i - mloc
				info[firstel] = info[i]
				info[i] = value
				res[nres-n+1] = info[firstel]
				cvpermute_setupnext(info, i0)
				return(cvpermute_u(res, info, lastel))
			}
		}
	}
	else {
		if ((i = mloc+m+1) <= lastel) {
			info[mloc] = i - mloc
			info[firstel] = info[i]
			info[i] = value
			res[nres-n+1] = info[firstel]
			cvpermute_setupnext(info, i0)
			return(cvpermute_u(res, info, lastel))
		}
	}
	return(0) 
}

end
