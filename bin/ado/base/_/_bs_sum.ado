*! version 1.2.2  08may2012
program _bs_sum, rclass
	version 9, missing
	syntax [anything(name=namelist)] [using/] [if] [in] [, * ]

	if `"`using'"' != "" {
		preserve
		quietly use `"`using'"', clear
	}
	else if `"`namelist'"' != "" {
		local namelist : list uniq namelist
		preserve
	}

	local 0 `"`namelist' `if' `in', `options'"'
	syntax [varlist(numeric)] [if] [in] [,		///
		Level(cilevel)				///
		Accel(string)				///
		Stat(string)				///
		N(integer -1)				///
		MSE					///
		TIEs				///
	]
	// mark the sample
	marksample touse
	quietly count if `touse'
	if r(N)==0 {
		Error2000
	}

	// matrices
	tempname b b_bs V
	// scalars
	tempname N N_reps N_strata N_clust
	scalar `N_strata' = .
	scalar `N_clust' = .
	scalar `N_reps' = r(N)
	quietly count `if' `in'
	if `N_reps' != r(N) {
		local missing missing
		local N_misreps = r(N) - `N_reps'
	}
	else 	local N_misreps 0

	if "`namelist'" != "" {
		keep `namelist' `touse'
		local 0
	}
	else {
		local 0 "*"
	}
	// NOTE: `if' & `in' are not longer needed, since we now have `touse'
	syntax [varlist(numeric)]
	local varlist : list varlist - touse


	// retrieve bootstrap characteristics
	GetIntChar _dta[bs_version]
	local version = cond(r(val) > 3, 0, r(val))

	if `version' > 1 {
		if `version' > 2 {
			local command `"`: char _dta[command]'"'

			local strata : char _dta[strata]
			capture confirm name `strata'
			if !c(rc) {
				GetIntChar _dta[N_strata]
				scalar `N_strata' = r(val)
			}
			local cluster : char _dta[cluster]
			capture confirm name `cluster'
			if !c(rc) {
				GetIntChar _dta[N_cluster]
				scalar `N_clust' = r(val)
			}
		}

		if `n' < 0 {
			GetIntChar _dta[N]
			scalar `N' = r(val)
		}
		else	scalar `N' = `n'

		_prefix_getmat `varlist',	///
			caller(bootstrap)	///
			char(observed)		///
			opt(stat)		///
			mat(`stat')		///
			required
		matrix `b' = r(mat)

		_prefix_getmat `varlist',	///
			char(acceleration)	///
			opt(accel)		///
			mat(`accel')
		if "`r(mat)'" == "matrix" {
			tempname accel
			matrix `accel' = r(mat)
		}
	}
	else {
		local version
		// version 1 or some other dataset
		if `n' > 0 {
			scalar `N' = `n'
		}
		else	scalar `N' = .

		_prefix_getmat `varlist', 	///
			char(bstrap)		///
			opt(stat)		///
			mat(`stat')		///
			required
		matrix `b' = r(mat)

		_prefix_getmat `varlist', opt(accel) mat(`accel')
		if "`r(mat)'" == "matrix" {
			tempname accel
			matrix `accel' = r(mat)
		}
	}

	if "`mse'" != "" {
		local mse mse(`b')
	}
	tempname tmat
	capture _sumaccum `varlist' if `touse', `mse'
	if c(rc) {
		Error2000
	}
	matrix `b_bs' = r(b)
	if "`mse'" != "" {
		matrix `V' = r(V)*(r(n)-1)/r(n)
	}
	else	matrix `V' = r(V)

	// the number of listed bootstrap variables
	local nstat : word count `varlist'

	// null vector for return vectors
	tempname vzero 
	matrix `vzero' = J(1,`nstat',0)
	matrix colname `vzero' = `varlist'
	matrix rowname `vzero' = y1

	local vecs reps bias z0 se 
	foreach mat of local vecs {
		tempname `mat'
		local mvecs `mvecs' ``mat''
		matrix ``mat'' = `vzero'
	}
	local CIs ci_normal ci_percentile ci_bc
	if `"`accel'"' != "" {
		local CIs `CIs' ci_bca
	}
	foreach mat of local CIs {
		tempname `mat'
		local mCIs `mCIs' ``mat''
		matrix ``mat'' = `vzero' \ `vzero'
		matrix rownames ``mat'' = ll ul
	}
	matrix drop `vzero'
	local results `vecs' `CIs'

	// b_i - observed value of the statistic for the current variable
	tempname b_i
	if `"`accel'"' != "" {
		// a_i - estimated acceleration of b_i
		tempname a_i
	}

	// Loop through varlist
	forvalues i = 1/`nstat' {
		local name : word `i' of `varlist'
		scalar `b_i' = `b'[1,colnumb(`b',"`name'")]
		if `"`accel'"' != "" {
			scalar `a_i' = `accel'[1,colnumb(`accel',"`name'")]
		}

		quietly OneBstat	///
			`touse'		///
			`name'		///
			`level'		///
			"`ties'"		///
			`b_i'		///
			`a_i'		///
			// blank

		// retrieve return vectors
		foreach rname of local results {
			matrix ``rname''[1,`i'] = r(`rname')
		}
	}

	// Save results
	local k_eexp 0
	if "`version'" != "" {
		if _caller() < 11 | `version' < 3{
			return scalar version = `version'
		}
		else	return scalar bs_version = `version'
		if `version' >= 3 {
			_prefix_getchars exp coleq colname k_eexp: `varlist'
			forval i = 1/`nstat' {
				return local exp`i' `"`exp`i''"'
			}
			local coleq : list clean coleq
			capture {
				assert `nstat' == `:word count `colname''
				if `"`coleq'"' != "" {
					assert `nstat' == `:list sizeof coleq'
				}
			}
			if !c(rc) {
				version 11: matrix colna `b' = `colname'
				if `"`coleq'"' != "" {
					version 11: matrix coleq `b' = `coleq'
				}
				_copy_mat_stripes `b_bs' `mvecs' : `b', novar
				_copy_mat_stripes `mCIs' : `b', novar norow
				_copy_mat_stripes `V' : `b'
				local coleq : list uniq coleq
				local coleq : list sizeof coleq
				return scalar k_eq = `coleq'
			}
			else {
				return scalar k_eq = 1
			}
			return local command `"`command'"'
			if !missing(`N_strata') {
				return scalar N_strata = `N_strata'
				return local strata `strata'
			}
			if !missing(`N_clust') {
				return scalar N_clust = `N_clust'
				return local cluster `cluster'
			}
			return scalar k_eexp = `k_eexp'
			return scalar k_exp = `nstat' - `k_eexp'
		}
		else {
			return local strata `strata'
			return local cluster `cluster'
		}
		return scalar N_misreps = `N_misreps'
	}
	else {
		local colna : colfullnames `b'
		version 11: ///
		matrix colna `V' = `colna'
		version 11: ///
		matrix rowna `V' = `colna'
		version 11: ///
		matrix colna `b_bs' = `colna'
	}
	if `"`return(k_exp)'"' == "" {
		return scalar k_exp = `nstat'
		return scalar k_eexp = 0
	}
	return scalar N = `N'
	return scalar N_reps = `N_reps'
	return scalar level = `level'
	return local missing `missing'
	if "`mse'" == "" {
		return local vcetype	"Bootstrap"
	}
	else {
		return local vcetype	"Bstrap *"
		return local mse	mse
	}
	return local vce     bootstrap
	return matrix b = `b'
	return matrix V = `V'
	return matrix b_bs = `b_bs'
	if "`accel'" != "" {
		return matrix accel `accel'
	}
	foreach rname of local results {
		return matrix `rname' ``rname''
	}
	return local ties `"`ties'"'
	return local cmd bootstrap
end

program GetIntChar, rclass
	args char
	local val : char `char'
	capture confirm integer number `val'
	if !_rc {
		if `val' > 0 {
			return scalar val = `val'
		}
	}
end

program OneBstat, rclass
	args touse x level ties b_i a_i
	tempname n bias sd zalpha z0 zz
	tempname n1 n2 p1 p2 bc1 bc2 bca1 bca2

	scalar `z0' = .
	scalar `bc1' = .
	scalar `bc2' = .
	scalar `bca1' = .
	scalar `bca2' = .

	summarize `x' if `touse'
	scalar `n' = r(N)
	scalar `bias' = r(mean) - `b_i'
	scalar `sd' = r(sd)
	scalar `zalpha' = invnorm((100 + `level')/200)

	// Compute bias-corrected (and accelerated) percentiles
	count if `x'<=`b_i' & `touse'
	local z0ct = r(N)
	if `"`ties'"' != "" {
		count if `x'==`b_i' & `touse'
		local z0ct = `z0ct' - r(N)/2
	}
	if `z0ct' > 0 & `z0ct' < `n' {
		scalar `z0' = invnorm(`z0ct'/`n')

		// bias-corrected
		scalar `p1' = 100*normprob(2*`z0' - `zalpha')
		scalar `p2' = 100*normprob(2*`z0' + `zalpha')
		capture _pctile `x' if `touse', p(`=`p1'', `=`p2'')
		if !c(rc) {
			scalar `bc1' = r(r1)
			scalar `bc2' = r(r2)
		}

		// bias-corrected and accelerated
		if "`a_i'" != "" {
			if ! missing(`a_i') {
			    scalar `zz' = `z0'-`zalpha'
			    scalar `p1' = 100*norm(`z0'+`zz'/(1-`a_i'*`zz'))
			    scalar `zz' = `z0'+`zalpha'
			    scalar `p2' = 100*norm(`z0'+`zz'/(1-`a_i'*`zz'))
			    capture _pctile `x' if `touse', p(`=`p1'', `=`p2'')
			    if !c(rc) {
				    scalar `bca1' = r(r1)
				    scalar `bca2' = r(r2)
			    }
			}
			else local a_i
		}
	}

	// Compute percentiles
	scalar `p1' = (100 - `level')/2
	scalar `p2' = (100 + `level')/2
	_pctile `x' if `touse', p(`=`p1'', `=`p2'')
	scalar `p1' = r(r1)
	scalar `p2' = r(r2)

	// Compute normal CI
	scalar `n1' = `b_i' - `zalpha'*`sd'
	scalar `n2' = `b_i' + `zalpha'*`sd'

	// Save results
	tempname tmat
	return scalar z0 = `z0'

	matrix `tmat' = (`bca1' \ `bca2')
	return matrix ci_bca `tmat'

	matrix `tmat' = (`bc1' \ `bc2')
	return matrix ci_bc `tmat'

	matrix `tmat' = (`p1' \ `p2')
	return matrix ci_percentile `tmat'

	matrix `tmat' = (`n1' \ `n2')
	return matrix ci_normal `tmat'

	return scalar se = `sd'
	return scalar bias = `bias'
	return scalar reps = `n'
end

program Error2000
	di in smcl as error ///
		"{p 0 0 2}insufficient observations to" ///
		" compute bootstrap standard errors{break}" ///
		"no results will be saved{p_end}"
	exit 2000
end

exit

NOTES:

Bootstrap dataset characteristics:

-_bs_sum- is very dependent upon the dataset generated by -bootstrap-, thus
certain conditions must be set in order for -_bs_sum- to behave consistently.

-GetValues- looks at data characteristics to determine where to look for
results left behind by -bootstrap-.

In the following <var> is the name of a variable in the dataset.

Version 1:    _dta[bs_version] == ""
	char <var>[bstrap] is a number 

Version 2:    _dta[bs_version] == 2
	char  _dta[N] is the number of observations in original dataset
	char <var>[observed] is a number
	char <var>[acceleration] is a number if it exists

Version 3:    _dta[bs_version] == 3
	char  _dta[N] is the number of observations in original dataset
	char  _dta[command] is the statistical command bootstrapped if saved
	char <var>[observed] is a number
	char <var>[acceleration] is a number if it exists
	char <var>[expression] label/expression for <var> if saved
	char <var>[colname] column name for <var> in e(b)
	char <var>[coleq] column equation for <var> in e(b)
	char <var>[is_eexp] == 1 if <var> part of an <eexp>

Saved results
Scalars:
	r(version)	bs dataset version:	_dta[bs_version]
	r(N)		number of obs:		n(), _dta[N] or '.'
	r(N_reps)	number of reps:		r(N) from -count `if'-
	r(N_strata)	number of strata:	_dta[N_strata]
	r(N_clust)	number of clusters:	_dta[N_cluster]
Macros:
	r(command)	bootstrapped command:	 _dta[command]
	r(exp#)		the #th expression
	r(strata)	name of strata variable
	r(cluster)	name of cluster variable
	r(missing)	"" or "missing"
	r(vcetype)	type of vce "Bootstrap" or "Bstrap *"
	r(mse)		"" or "mse"
	r(vce)		"bootstrap"
	r(cmd)		"bootstrap"
Matrices:
	r(b)		observed statistic(s)
	r(V)		bootstrap variance matrix
	r(b_bs)		bootstrap mean(s)
	r(accel)	observed acceleration values
	r(reps)		number of nonmissing results
	r(bias)		bias
	r(z0)		median bias
	r(se)		standard error
	r(ci_normal)	normal CIs
	r(ci_percent)	percentile CIs
	r(ci_bc)	BC CIs
	r(ci_bca)	BCa CIs

<end>
