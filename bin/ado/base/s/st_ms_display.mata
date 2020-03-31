*! version 1.0.0  10feb2019
version 16

mata:

string colvector st_ms_display(
	string	scalar		mname,
	|string	scalar		opts,
	real	scalar		nooutput)
{
	real	scalar		rc
	string	scalar		cmd
	string	matrix		stripe
	string	colvector	result
	real	matrix		eq_info
	real	scalar		neq
	real	scalar		eq
	real	scalar		dim
	real	scalar		i
	string	colvector	cur
	real	scalar		k_di
	real	scalar		j
	string	scalar		first

	if (missing(nooutput)) {
		nooutput = 1
	}

	cmd = sprintf("_ms_display, matrix(%s) %s", mname, opts)
	cmd = cmd + " eq(#%f) el(%f) dimacros %s"

	if (anyof(tokens(opts), "row")) {
		stripe = st_matrixrowstripe(mname)
	}
	else {
		stripe = st_matrixcolstripe(mname)
	}
	result = J(0,1,"")
	eq_info = panelsetup(stripe, 1)
	neq = rows(eq_info)
	for (eq=1; eq<=neq; eq++) {
		dim = eq_info[eq,2] - eq_info[eq,1] + 1
		first = ""
		for (i=1; i<=dim; i++) {
			rc = _stata(sprintf(cmd, eq, i, first), nooutput)
			if (rc) exit(rc)
			if (st_numscalar("r(output)") == 0) {
				if (st_numscalar("r(first)")) {
					first = "first"
				}
				continue
			}
			if (nooutput == 0) {
				printf("\n")
			}
			first = ""
			k_di = st_numscalar("r(k_di)")
			cur = J(k_di,1,"")
			for (j=1; j<=k_di; j++) {
				cur[j] = st_global(sprintf("r(di%f)",j))
			}
			result = result \ cur
		}
	}
	st_rclear()
	return(result)
}

end
exit
