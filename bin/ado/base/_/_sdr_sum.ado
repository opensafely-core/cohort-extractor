*! version 1.0.1  08may2012
program _sdr_sum, rclass
	version 11
	syntax [anything(name=namelist)] [using/] [if] [in] [, * ]

	if `"`using'"' != "" {
		preserve
		quietly use `"`using'"', clear
	}
	else	local preserve preserve

	local version : char _dta[sdr_version]
	if `"`version'"' == "1" {
		local defvlist "default=none"
	}
	else	local version

	local 0 `"`namelist' `if' `in' , `options'"'
	syntax [varlist(numeric `defvlist')]	///
		[if] [in] [fw],			///
		[				///
			Stat(string)		///
			FPC(varname numeric)	///
			MSE			///
		]

	if "`varlist'" == "" {
		local varlist : char _dta[sdr_names]
	}
	if "`varlist'" == "" {
		di as err "varlist required"
		exit 100
	}
	if "`fpc'" == "" {
		local fpc `"`:char _dta[sdr_fpc]'"'
		capture confirm numeric var `fpc'
		if c(rc) local fpc
	}

	marksample touse

	// matrices
	tempname b b_sdr v_sdr
	// scalars
	tempname df N_reps
	local vopt v(`v_sdr')

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
	if "`fpc'" != "" {
		sum `fpc', mean
		if r(min) != r(max) {
			error 461
		}
		tempname fpc
		if r(min) > 1 {
			if r(min) < r(n) {
				error 462
			}
			scalar `fpc' = 1-r(n)/r(min)
		}
		else	scalar `fpc' = 1-r(min)
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
	return local command	`"`: char _dta[sdr_command]'"'
	return local cmdname	`"`: char _dta[sdr_cmdname]'"'
	return local wtype	`"`: char _dta[sdr_wtype]'"'
	return local wexp	`"`: char _dta[sdr_wexp]'"'
	return local sdrweight	`"`: char _dta[sdr_rweights]'"'
	capture return scalar N = `: char _dta[sdr_N]'
	capture return scalar N_pop = `: char _dta[sdr_N_pop]'
	return scalar N_misreps = `N_misreps'
	if "`mse'" == "" {
		return local vcetype	"SDR"
	}
	else {
		return local vcetype	"SDR *"
		return local mse	mse
	}
	return local vce	sdr
	return local missing 	`missing'
	scalar `df' = r(n) - 1
	matrix `b_sdr' = r(b)
	if `:length local fpc' {
		matrix `v_sdr' = `fpc'*4*r(V)*`df'/r(n)
	}
	else {
		matrix `v_sdr' = 4*r(V)*`df'/r(n)
	}
	_copy_mat_stripes `b_sdr' : `b', novar
	_copy_mat_stripes `v_sdr' : `b'
	return matrix b		`b'
	return matrix b_sdr	`b_sdr'
	return matrix V		`v_sdr'
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
