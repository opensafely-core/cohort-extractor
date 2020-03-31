*! version 1.0.1  08may2012
program _svy_bs_sum, rclass
	version 11
	syntax [anything(name=namelist)] [using/] [if] [in] [, * ]

	if `"`using'"' != "" {
		preserve
		quietly use `"`using'"', clear
	}
	else	local preserve preserve

	local version : char _dta[svy_bs_version]
	if `"`version'"' == "1" {
		local defvlist "default=none"
	}
	else	local version

	local 0 `"`namelist' `if' `in' , `options'"'
	syntax [varlist(numeric `defvlist')]	///
		[if] [in] [fw],			///
		[				///
			Stat(string)		///
			MSE			///
		]

	if "`varlist'" == "" {
		local varlist : char _dta[svy_bs_names]
	}

	marksample touse

	// matrices
	tempname b b_bs v_bs
	// scalars
	tempname df N_reps
	local vopt v(`v_bs')

	// parse -stat()- option
	_prefix_getmat `varlist',	///
		caller(bootstrap)	///
		char(observed)		///
		opt(stat)		///
		mat(`stat')		///
		required
	matrix `b' = r(mat)
	local K : word count `varlist'

	quietly count if `touse'
	if r(N) == 0 {
		Error2000
	}
	scalar `N_reps' = r(N)
	quietly count `if' `in'
	if `N_reps' != r(N) {
		local missing missing
		local N_misreps = r(N) - `N_reps'
	}
	else 	local N_misreps 0

	// compute MSE instead of the sample variance
	if "`mse'" != "" {
		local mse mse(`b')
	}

	capture _sumaccum `varlist' if `touse', `mse'
	if c(rc) {
		Error2000
	}

	// save results
	local k_eexp 0
	local nstat : word count `varlist'
	_prefix_getchars exp coleq colname k_eexp : `varlist'
	forval i = 1/`nstat' {
		return local exp`i' `"`exp`i''"'
	}
	local coleq : list clean coleq
	if `"`:list uniq coleq'"' == "_" {
		local coleq
	}
	if trim(`"`coleq'`colname'"') != "" {
		matrix coleq `b' = `coleq'
		matrix colna `b' = `colname'
		local coleq : list uniq coleq
		local coleq : list sizeof coleq
		return scalar k_eq = max(`coleq',1)
	}
	else	return scalar k_eq = 1
	return local command	`"`: char _dta[svy_bs_command]'"'
	return local cmdname	`"`: char _dta[svy_bs_cmdname]'"'
	return local wtype	`"`: char _dta[svy_bs_wtype]'"'
	return local wexp	`"`: char _dta[svy_bs_wexp]'"'
	return local bsrweight	`"`: char _dta[svy_bs_rweights]'"'
	capture return scalar N = `: char _dta[svy_bs_N]'
	capture return scalar N_pop = `: char _dta[svy_bs_N_pop]'
	capture return scalar bsn = `:char _dta[svy_bs_bsn]'
	if c(rc) {
		return scalar bsn = 1
	}
	return scalar N_misreps = `N_misreps'
	if "`mse'" == "" {
		return local vcetype	"Bootstrap"
	}
	else {
		return local vcetype	"Bstrap *"
		return local mse	mse
	}
	return local vce	bootstrap
	return local missing 	`missing'
	scalar `df' = r(n) - 1
	matrix `b_bs' = r(b)
	if !inlist(return(bsn), 1, .) {
		matrix `v_bs' = r(V)*return(bsn)*`df'/r(n)
	}
	else {
		matrix `v_bs' = r(V)*`df'/r(n)
	}
	_copy_mat_stripes `b_bs' : `b', novar
	_copy_mat_stripes `v_bs' : `b'
	return matrix b		`b'
	return matrix b_bs	`b_bs'
	return matrix V		`v_bs'
	return scalar N_reps	= `N_reps'
	return scalar k_eexp	= `k_eexp'
	return scalar k_exp	= `nstat' - `k_eexp'
	return local prefix	svy
	return local cmd	bootstrap
end

program Error2000
	di in smcl as error ///
		"{p 0 0 2}insufficient observations to" ///
		" compute bootstrap standard errors{break}" ///
		"no results will be saved{p_end}"
	exit 2000
end

exit
