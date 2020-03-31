*! version 1.2.2  08mar2014
program _brr_sum, rclass
	version 9
	syntax [anything(name=namelist)] [using/] [if] [in] [, * ]

	if `"`using'"' != "" {
		preserve
		quietly use `"`using'"', clear
	}
	else	local preserve preserve

	local version : char _dta[brr_version]
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
		local varlist : char _dta[brr_names]
	}

	marksample touse

	// matrices
	tempname b b_brr v_brr
	// scalars
	tempname df N_reps
	local vopt v(`v_brr')

	// parse -stat()- option
	_prefix_getmat `varlist',	///
		caller(brr)		///
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
	if "`version'" != "" {
		_prefix_getchars exp coleq colname k_eexp : `varlist'
		forval i = 1/`nstat' {
			return local exp`i' `"`exp`i''"'
		}
		local coleq : list clean coleq
		if `"`:list uniq coleq'"' == "_" {
			local coleq
		}
		if trim(`"`coleq'`colname'"') != "" {
			version 11: ///
			matrix coleq `b' = `coleq'
			version 11: ///
			matrix colna `b' = `colname'
			local coleq : list uniq coleq
			local coleq : list sizeof coleq
			return scalar k_eq = max(`coleq',1)
		}
		else	return scalar k_eq = 1
		return local command	`"`: char _dta[brr_command]'"'
		return local cmdname	`"`: char _dta[brr_cmdname]'"'
		return local wtype	`"`: char _dta[brr_wtype]'"'
		return local wexp	`"`: char _dta[brr_wexp]'"'
		return local brrweight	`"`: char _dta[brr_rweights]'"'
		capture return scalar N = `: char _dta[brr_N]'
		capture return scalar N_pop = `: char _dta[brr_N_pop]'
		capture return scalar N_strata = `: char _dta[brr_N_strata]'
		capture return scalar N_psu = `: char _dta[brr_N_psu]'
		capture return scalar fay = `:char _dta[brr_fay]'
		if c(rc) {
			return scalar fay = 0
		}
		return scalar N_misreps = `N_misreps'
	}
	else {
		return scalar fay = 0
	}
	if "`mse'" == "" {
		return local vcetype	"BRR"
	}
	else {
		return local vcetype	"BRR *"
		return local mse	mse
	}
	return local vce	brr
	return local missing 	`missing'
	scalar `df' = r(n) - 1
	matrix `b_brr' = r(b)
	if return(fay) != 0 {
		matrix `v_brr' = r(V)*`df'/(r(n)*(1-return(fay))^2)
	}
	else {
		matrix `v_brr' = r(V)*`df'/r(n)
	}
	_copy_mat_stripes `b_brr' : `b', novar
	_copy_mat_stripes `v_brr' : `b'
	return matrix b		`b'
	return matrix b_brr	`b_brr'
	return matrix V		`v_brr'
	return scalar N_reps	= `N_reps'
	return scalar df_r	= `df'
	return scalar k_eexp	= `k_eexp'
	return scalar k_exp	= `nstat' - `k_eexp'
	return local prefix	svy
	return local cmd	brr
end

program Error2000
	di in smcl as error ///
		"{p 0 0 2}insufficient observations to" ///
		" compute BRR standard errors{break}" ///
		"no results will be saved{p_end}"
	exit 2000
end

exit
