*! version 1.0.2  16sep2019
program stintreg_em, rclass sortpreserve

	version 15

	syntax varlist(min=2 max =2 numeric) [if] [in] ///
		[, OUTfile(string) TOLerance(real 1e-8) ///
		   MAXIter(integer 10000) noTABle ]

	tokenize `varlist'

	local ltime `1'
	local rtime `2'

	tempname mat

	preserve

	if "`if'`in'" != "" {	
		qui keep `if' `in'
	}

	qui replace `ltime' = 0 if `ltime' == .

	sort `ltime' `rtime'

	mata: stintreg_em("`ltime'", "`rtime'", "`mat'", ///
			  `tolerance', `maxiter')

	mat colnames `mat' = t0 t1 prob S(t)
	local iter `r(iter)'
	local converge `r(converge)'

	tempvar result
	qui svmat `mat', names(`result')

	qui keep `result'1 `result'2 `result'3 `result'4
	qui drop if `result'1 == . & `result'2 == .
	
	label data
	rename `result'1 ltime
	rename `result'2 rtime
	label var ltime "left time point"
	label var rtime "right time point"
	rename `result'3 prob
	label var prob "Probability"
	rename `result'4 surv
	label var surv "S(t)"

	// outfile
	if `"`outfile'"' != "" {
		tokenize "`outfile'", parse(",")
		local 1 `1'
		qui save "`1'" `2' `3'
	}

	// return results
	return matrix M = `mat'
	return scalar iter = `iter'
	return scalar converge = `converge'

	if "`table'" != "" exit 

	// Display
	
	qui count 
	local n = `r(N)'

	di 
	di as txt "Turnbull Interval" _col(25) as txt "Probability" ///
	   _col(43) as txt "Survival"
	di in smcl in gr "{hline 53}"
	
	forvalues i = 1(1)`n'{
		local t0 = ltime[`i']
		local t1 = rtime[`i']
		local prob = prob[`i']
		local surv = surv[`i']

		di _col(2) as txt "(" as res %6.0g `t0' as txt "," ///
			as res %6.0g `t1' as txt "]" ///
			_col(24) as res %9.5f `prob' ///
			_col(41) as res %9.5f `surv'
	}

end

mata: 
	
void function stintreg_em(string scalar ltime, string scalar rtime, 
			  string scalar mat, real scalar tol, 
			  real scalar maxiter) 
{
	
	real scalar n, m, iter, converge
	real colvector t0, t1
	real rowvector ut0, ut1, p_old, p_new, p, S
	real matrix index, A, p_ind, result
	
	t0 = st_data(.,ltime)
	t1 = st_data(.,rtime)

	// find Turnbull's Interval
	A = innermost(t0, t1)
	m = rows(A)
	ut0 = A[.,1]'
	ut1 = A[.,2]'

	// initial
	n = rows(t0)
	p_old = J(1,m,1/m)
	index = (J(n,1,ut0):>= J(1,m,t0)):&(J(n,1,ut1):<= J(1,m,t1))
	p_ind = J(n,1,p_old):* index:/J(1,m,index*p_old')
	p_new = colsum(p_ind)/n

	iter = 0

	// EM
	while (sum(abs(p_old - p_new))> tol) {

		iter = iter + 1
		if (iter > maxiter) break
		
		p_new = p_old
		p_ind = J(n,1,p_old):* index:/J(1,m,index*p_old')
		p_old = colsum(p_ind)/n
	}

	if (sum(abs(p_old-p_new)) > tol) {
		converge = 0
	}
	else {
		converge = 1
	}

	// return results
	p = runningsum(p_new)	
	S = J(1,m,1) :- p
	S = abs(S)
	result = ut0\ut1\p\S
	st_matrix(mat, result')
	st_numscalar("r(iter)", iter)
	st_numscalar("r(converge)", converge)
}

real matrix function innermost(real colvector t0, real colvector t1) 
{
	real scalar m, i
	real matrix A, t, exact, interval, ut	
	real colvector int0, int1, ut0, ut1, a

	t = t0, t1

	exact = uniqrows(select(t, t0 :== t1))
	interval = uniqrows(select(t, t0 :!= t1))

if (rows(interval) > 0) {

	int0 = interval[.,1]
	int1 = interval[.,2]

	ut = uniqrows(int0\int1)'
	m  = cols(ut)
	ut0 = ut[1..m-1]'
	ut1 = ut[2..m]'

	a = J(m-1,1,0)
	for (i=1; i<=m-1; i++) {
		if (sum(int0:==ut0[i]) & sum(int1:==ut1[i])) a[i] = 1 
	}
	ut = ut0, ut1
	interval = select(ut, a)

	A = exact\interval
}
else {
	A = exact
}
	_sort(A,(1,2))

	m = rows(A)
	ut0 = A[2..m,1]
	ut1 = A[1..m-1,2]
	ut = ut1:<= ut0
	ut = ut\1
	A = select(A, ut)

	return(A)	
}

end
