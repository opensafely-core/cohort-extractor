*! version 1.4.0  19feb2019
version 11

mata:

void _mc_check_method(string scalar name)
{
	string	scalar	cmd
	cmd = st_global("e(cmd)")
	if (all(cmd :!= tokens("pwcompare pwmean"))) {
errprintf("method %s is not allowed with results from %s\n", name, cmd)
		exit(322)
	}
}

real scalar _mc_alpha(	string	scalar	method,
			real	scalar	alpha,
			real	scalar	levels,
			real	scalar	extra)
{
	if (method == "bonferroni") {
		return(alpha/extra)
	}
	if (method == "sidak") {
		return(-expm1(ln1m(alpha)/extra))
	}
	if (method == "" | method == "noadjust" | levels == 1) {
		return(alpha)
	}
	if (method == "scheffe") {
		return(alpha)
	}
	if (method == "tukey") {
		return(alpha)
	}
	if (method == "snk") {
		return(alpha)
	}
	if (method == "duncan") {
		return(-expm1(ln1m(alpha)*(levels-1)))
	}
	if (method == "dunnett") {
		return(alpha)
	}
	errprintf("method %s not recognized\n", method)
	exit(198)
}

real scalar _mc_crit(	string	scalar	method,
			real	scalar	udf,
			real	scalar	alpha,
			real	scalar	levels,
			real	scalar	extra)
{
	real	scalar	crit
	real	scalar	eps
	real	scalar	df

	df = udf > 2e17 ? . : udf
	if (method == "bonferroni") {
		eps	= alpha/(2*extra)
		if (missing(df)) {
			crit = -invnormal(eps)
		}
		else {
			crit = invttail(df, eps)
		}
		return(crit)
	}
	if (method == "sidak") {
		eps	= -expm1(ln1m(alpha)/extra)
		if (missing(df)) {
			crit = -invnormal(eps/2)
		}
		else {
			crit = invttail(df, eps/2)
		}
		return(crit)
	}
	if (method == "" | method == "noadjust" | levels == 1) {
		eps = alpha/2
		if (missing(df)) {
			crit = -invnormal(eps)
		}
		else {
			crit = invttail(df, eps)
		}
		return(crit)
	}
	if (method == "scheffe") {
		if (missing(df)) {
			crit = invchi2tail(extra,alpha)
		}
		else {
			crit = extra*invFtail(extra,df,alpha)
		}
		return(sqrt(crit))
	}
	if (method == "tukey") {
		crit = invtukeyprob(levels,df,1-alpha)
		return(crit/sqrt(2))
	}
	if (method == "snk") {
		crit = invtukeyprob(extra,df,1-alpha)
		return(crit/sqrt(2))
	}
	if (method == "duncan") {
		eps = exp(ln1m(alpha)*(extra-1))
		crit = invtukeyprob(extra,df,eps)
		return(crit/sqrt(2))
	}
	if (method == "dunnett") {
		crit = invdunnettprob(levels-1,df,1-alpha)
		return(crit)
	}
	errprintf("method %s not recognized\n", method)
	exit(198)
}

real scalar _mc_pvalue(	string	scalar	method,
			real	scalar	udf,
			real	scalar	stat,
			real	scalar	levels,
			real	scalar	extra)
{
	real	scalar	pvalue
	real	scalar	df

	df = udf > 2e17 ? . : udf
	if (missing(stat)) {
		return(.)
	}
	if (method == "bonferroni") {
		if (missing(df)) {
			pvalue = 2*normal(-abs(stat))
		}
		else {
			pvalue = 2*ttail(df,abs(stat))
		}
		return(min((1,extra*pvalue)))
	}
	if (method == "sidak") {
		if (missing(df)) {
			pvalue = 2*normal(-abs(stat))
		}
		else {
			pvalue = 2*ttail(df,abs(stat))
		}
		pvalue	= -expm1(ln1m(pvalue)*extra)
		return(min((1,pvalue)))
	}
	if (method == "" | method == "noadjust" | levels == 1) {
		if (missing(df)) {
			pvalue = 2*normal(-abs(stat))
		}
		else {
			pvalue = 2*ttail(df,abs(stat))
		}
		return(pvalue)
	}
	if (method == "scheffe") {
		if (missing(df)) {
			pvalue = chi2tail(extra,stat^2)
		}
		else {
			pvalue = Ftail(extra,df,(stat^2)/(extra))
		}
		return(pvalue)
	}
	if (method == "tukey") {
		pvalue = 1-tukeyprob(levels,df,abs(stat)*sqrt(2))
		return(pvalue)
	}
	if (method == "snk") {
		pvalue = 1-tukeyprob(extra,df,abs(stat)*sqrt(2))
		return(pvalue)
	}
	if (method == "duncan") {
		pvalue = tukeyprob(extra,df,abs(stat)*sqrt(2))
		pvalue = -expm1(ln(pvalue)/(extra-1))
		return(pvalue)
	}
	if (method == "dunnett") {
		pvalue = 1-dunnettprob(levels-1,df,abs(stat))
		return(pvalue)
	}
	errprintf("method %s not recognized\n", method)
	exit(198)
}

real scalar _mc_pos(real scalar i, real scalar j, real scalar k)
{
	if (j > i) {
		return(j-i+(i-1)*(k-i/2))
	}
	return(i-j+(j-1)*(k-j/2))
}

string scalar _mc_group(real scalar i, real scalar rc)
{
	rc = 0
	if (i == 0) {
		return(" ")
	}
	if (i <= 26) {
		return(char(65+i-1))
	}
	if (i <= 52) {
		return(char(97+i-27))
	}
	if (i <= 62) {
		return(char(48+i-53))
	}
	rc = 1
	return("")
}

function _mc_sort(real scalar usevs)
{
	real	matrix b

	if (usevs) {
		b = st_matrixcolstripe_term_index("e(b_vs)"),
		    st_matrix("e(b_vs)")'
	}
	else {
		b = st_matrixcolstripe_term_index("e(b)"),
		    st_matrix("e(b)")'
	}
	st_matrix(st_local("order"), order(b, (1..3)))
}

real scalar _mc_find_min_width(	real	scalar	width,
				string	scalar	name,
				|real	scalar	dolevels,
				string	scalar	extra)
{
	real	scalar	rc
	real	matrix	eq_info
	real	scalar	max
	real	scalar	neq
	real	scalar	eq
	real	scalar	nel
	real	scalar	el
	real	scalar	k
	real	scalar	i
	real	scalar	w
	string	scalar	text

	if (missing(dolevels)) {
		dolevels = 1
	}

	if (width < 12 | missing(width)) {
		return(12)
	}
	if (anyof(tokens(extra), "row")) {
		eq_info	= panelsetup(st_matrixrowstripe(name), 1)
	}
	else {
		eq_info	= panelsetup(st_matrixcolstripe(name), 1)
	}
	neq	= rows(eq_info)
	max	= 0
	for (eq=1; eq<=neq; eq++) {
		rc = _stata(sprintf(
			"_ms_eq_display, matrix(%s) width(%f) eq(%f) %s",
			name,
			width,
			eq,
			extra), 1)
		if (rc == 0 & st_numscalar("r(output)") == 1) {
			k = st_numscalar("r(k)")
			for (i=1; i<=k; i++) {
				text = sprintf("r(eq%f)", i)
				w = udstrlen(st_global(text))
				if (max < w) {
					max = w
				}
			}
		}
		nel = eq_info[eq,2] - eq_info[eq,1] + 1
		for (el=1; el<=nel; el++) {
			rc = _stata(sprintf(
"_ms_display, matrix(%s) width(%f) eq(#%f) el(%f) %s",
				name,
				width,
				eq,
				el,
				extra), 1)
			if (st_numscalar("r(output)") == 0) {
				continue
			}
			if (rc == 0) {
				k = st_numscalar("r(k_term)")
				if (k == 0) {
					w = udstrlen(st_global("r(term)"))
					if (max < w) {
						max = w
					}
				}
				for (i=1; i<=k; i++) {
					text = sprintf("r(term%f)", i)
					w = udstrlen(st_global(text))
					if (max < w) {
						max = w
					}
				}
				if (dolevels) {
				    k = st_numscalar("r(k_level)")
				    if (k == 0) {
					w = udstrlen(st_global("r(level)")) + 1
					if (max < w) {
						max = w
					}
				    }
				    for (i=1; i<=k; i++) {
					text = sprintf("r(level%f)", i)
					w = udstrlen(st_global(text)) + 1
					if (max < w) {
						max = w
					}
				    }
				}
			}
		}
	}

	if (max < 12) {
		return(12)
	}
	if (max > width) {
		return(width)
	}
	return(max)
}

end
