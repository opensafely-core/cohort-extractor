*! version 1.0.0  04apr2011
version 12

mata:

void st_return_copy_global(
	string	scalar	lname,
	string	scalar	from,
	string	scalar	to,
	|real	scalar	replace)
{
	string	vector	names
	string	scalar	fname
	string	scalar	tname
	real	scalar	k
	real	scalar	i
	string	scalar	hcat
	string	scalar	value

	if (args() == 3) {
		replace = 0
	}

	names	= tokens(st_local(lname))
	k	= cols(names)

	for (i=1; i<=k; i++) {
		tname	= sprintf("%s(%s)", to, names[i])
		value	= st_global(tname)
		if (replace | strlen(value) == 0) {
			fname	= sprintf("%s(%s)", from, names[i])
			value	= st_global(fname)
			hcat	= st_global_hcat(fname)
			if (strlen(hcat)) {
				st_global(tname, value, hcat)
			}
			else {
				st_global(tname, value)
			}
		}
	}
}

void st_return_copy_numscalar(
	string	scalar	lname,
	string	scalar	from,
	string	scalar	to,
	|real	scalar	replace)
{
	string	vector	names
	string	scalar	fname
	string	scalar	tname
	real	scalar	k
	real	scalar	i
	string	scalar	hcat
	real	scalar	value

	if (args() == 3) {
		replace = 0
	}

	names	= tokens(st_local(lname))
	k	= cols(names)

	for (i=1; i<=k; i++) {
		tname	= sprintf("%s(%s)", to, names[i])
		if (replace | st_macroexpand("`"+tname+"'") == "") {
			fname	= sprintf("%s(%s)", from, names[i])
			value	= st_numscalar(fname)
			hcat	= st_numscalar_hcat(fname)
			if (strlen(hcat)) {
				st_numscalar(tname, value, hcat)
			}
			else {
				st_numscalar(tname, value)
			}
		}
	}
}

void st_return_copy_matrix(
	string	scalar	lname,
	string	scalar	from,
	string	scalar	to,
	|real	scalar	replace)
{
	string	vector	names
	string	scalar	fname
	string	scalar	tname
	real	scalar	k
	real	scalar	i
	string	scalar	hcat
	real	matrix	value

	if (args() == 3) {
		replace = 0
	}

	names	= tokens(st_local(lname))
	k	= cols(names)

	for (i=1; i<=k; i++) {
		tname	= sprintf("%s(%s)", to, names[i])
		if (replace | st_macroexpand("`"+tname+"'") == "") {
			fname	= sprintf("%s(%s)", from, names[i])
			value	= st_matrix(fname)
			hcat	= st_matrix_hcat(fname)
			if (strlen(hcat)) {
				st_matrix(tname, value, hcat)
			}
			else {
				st_matrix(tname, value)
			}
			st_matrixrowstripe(tname, st_matrixrowstripe(fname))
			st_matrixcolstripe(tname, st_matrixcolstripe(fname))
		}
	}
}

end
