*! version 1.5.0  20apr2015
program _jk_sum, rclass
	version 9
	syntax [anything(name=namelist)] [using/] [if] [in] [fw pw iw] [, * ]

	if `"`using'"' != "" {
		preserve
		quietly use `"`using'"', clear
	}
	else	local preserve preserve

	local version : char _dta[jk_version]
	if `"`version'"' == "1" {
		local defvlist "default=none"
	}
	else	local version

	local 0 `"`namelist' `if' `in' [`weight'`exp'], `options'"'
	syntax [varlist(numeric `defvlist')]		///
		[if] [in] [fw pw iw],			///
		[					///
			Stat(string)			///
			STRata(varname)			///
			FPC(varname numeric)		///
			SINGLEunit(passthru)		///
			MSE				///
		]
	if "`mse'" != "" & "`fpc'" != "" {
		opts_exclusive "fpc() mse" fpc
	}

	marksample touse

	if "`varlist'" == "" {
		local varlist : char _dta[jk_names]
		markout `touse' `varlist'
	}
	if "`varlist'" == "" {
		di as err "varlist required"
		exit 100
	}
	local jkrw jknife
	if `"`version'"' == "1" {
		local is_svy = `"`: char _dta[jk_svy]'"' == "svy"
		if "`strata'" == "" {
			local strata `"`:char _dta[jk_strata]'"'
			capture confirm var `strata'
			if c(rc) local strata
			else {
				local ustrata `"`:char _dta[jk_stratum]'"'
			}
		}
		if "`weight'" == "" {
			local jk_wtype	`"`:char _dta[jk_wtype]'"'
			local wvar	`"`:char _dta[jk_multiplier]'"'
			CheckWtype [`jk_wtype'=`wvar']
			if r(rc) {
				local wvar
			}
			else {
				local weight `"`r(weight)'"'
				local exp `"`r(exp)'"'
			}
			if _caller() >= 14 & ///
			   `"`:char _dta[jk_rweights]'"' != "" & ///
			   `"`wvar'"' != "" {
				local jkrw jkrw
			}
		}
		if "`fpc'" == "" {
			local fpc `"`:char _dta[jk_fpc]'"'
			capture confirm numeric var `fpc'
			if c(rc) local fpc
		}
	}
	else {
		local is_svy = `"`strata'`fpc'"' != ""
	}
	// remove the stratum id and FPC vars from the varlist, just in case
	local varlist : list varlist - strata
	local varlist : list varlist - fpc

	// matrices
	tempname b b_jk v_jk
	// scalars
	tempname df nm1 N_reps
	if "`weight'" != "" {
		tempvar wvar
		local wtype `weight'
		quietly gen double `wvar' `exp' if `touse'
		local pwgt [pw=`wvar']
		local wgt [`weight'=`wvar']
	}
	if "`weight'" == "fweight" {
		local vopt vsrs(`v_jk')
	}
	else {
		local vopt v(`v_jk')
	}

	// parse -stat()- option
	_prefix_getmat `varlist',	///
		caller(jackknife)	///
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

	// compute degrees of freedom
	if "`wtype'" == "fweight" {
		sum `touse' [fw=`wvar'] if `touse', mean
		scalar `df' = r(sum_w)-1
	}
	else if "`wtype'" == "iweight" {
		sum `touse' [iw=`wvar'] if `touse', mean
		scalar `df' = round(r(sum_w))
	}
	else {
		quietly count if `touse'
		scalar `df' = r(N) - 1
	}

	if (!`is_svy' & "`wtype'" != "pweight") | "`mse'" != "" {
		if "`fpc'" != "" {
			tempname FPC
			capture assert `fpc' <= 1 if `touse'
			if c(rc) {
				if "`strata'" != "" {
					sort `touse' `strata'
					by `touse' `strata':	///
					gen double `FPC' = 1 - _N/`fpc'
				}
				else {
					gen double `FPC' = 1 - r(N)/`fpc'
				}
			}
			else {
				gen double `FPC' = 1 - `fpc'
			}
			if "`wgt'" != "" {
				quietly replace `wvar' = `wvar'*`FPC'
			}
			else {
				local wgt `"[pw=`FPC']"'
			}
		}
		if "`mse'" != "" {
			// compute MSE instead of the sample variance
			local mseopt mse(`b')
		}
		capture _sumaccum `varlist' `wgt' if `touse', `mseopt'
		if c(rc) {
			Error2000
		}

		// save results
		scalar `nm1' = r(n) - 1
		matrix `b_jk' = r(b)
		if "`mse'" != "" {
			if inlist("`wtype'", "iweight", "pweight") {
				matrix `v_jk' = `nm1'*r(V)
			}
			else {
				matrix `v_jk' = `df'*`nm1'*r(V)/(`df'+1)
			}
		}
		else {
			matrix `b_jk' = (`df'+1)*`b'-`df'*`b_jk'
			matrix `v_jk' = `df'*`nm1'*r(V)/(`df'+1)
		}
	}
	else {
		// setup for computing sample variance of pseudovalues
		`preserve'

		quietly svyset _n `pwgt',	///
			strata(`strata')	///
			fpc(`fpc')		///
			`singleunit'

		capture 				///
		_svy2 `varlist' if `touse',		///
			type(total)			///
			svy				///
			`jkrw'				///
			b(`b_jk')			///
			`vopt'				///
			over(`touse')			///
			// blank
		if c(rc) {
			error c(rc)
		}
		if r(N) == 0 {
			Error2000
		}
		return scalar singleton = r(singleton)
		tempname mat
		matrix `mat' = r(_N_strata)
		return matrix _N_strata `mat'
		matrix `mat' = r(_N_strata_single)
		return matrix _N_strata_single `mat'
		matrix `mat' = r(_N_strata_certain)
		return matrix _N_strata_certain `mat'
		// note: -_svy2- puts the total of the pseudo values in 'b_jk'
		matrix `b_jk' = (`df'+1)*`b'-`b_jk'
	}

	// save results
	local k_eexp 0
	local nstat : word count `varlist'
	local cmd jackknife
	local prefix jackknife
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
		return local command	`"`:char _dta[jk_command]'"'
		return local cmdname	`"`:char _dta[jk_cmdname]'"'
		return local nfunction	`"`:char _dta[jk_nfunction]'"'
		return local wtype	`"`:char _dta[jk_wtype]'"'
		return local wexp	`"`:char _dta[jk_wexp]'"'
		return local jkrweight	`"`:char _dta[jk_rweights]'"'
		capture return scalar N = `:char _dta[jk_N]'
		capture return scalar N_pop = `:char _dta[jk_N_pop]'
		capture return scalar N_strata = `:char _dta[jk_N_strata]'
		capture return scalar N_strata_omit = `:char _dta[jk_N_strata_omit]'
		capture return scalar N_psu = `:char _dta[jk_N_psu]'
		if `"`:char _dta[jk_subpop]'"' != "" {
			return local subpop `"`:char _dta[jk_subpop]'"'
		capture return scalar N_sub = `:char _dta[jk_N_sub]'
		capture return scalar N_subpop = `:char _dta[jk_N_subpop]'
		}
		if `is_svy' {
			if `"`return(jkrweight)'"' != "" {
				return local N_psu
			}
			return local su1	`"`:char _dta[jk_su1]'"'
			local prefix svy
			if missing(return(N_strata)) {
				return scalar N_strata = 1
			}
			if missing(return(N_strata_omit)) {
				return scalar N_strata = 0
			}
		}
		return scalar N_misreps = `N_misreps'
	}
	if "`strata'" != "" {
		if missing(return(N_strata)) {
			quietly tab `strata' if `touse'
			return scalar N_strata = r(r)
			return scalar N_strata_omit = 0
		}
		return local strata1	`"`ustrata'"'
	}
	_copy_mat_stripes `b_jk' : `b', novar
	_copy_mat_stripes `v_jk' : `b'
	if "`mse'" == "" {
		return local vcetype	"Jackknife"
	}
	else {
		return local vcetype	"Jknife *"
		return local mse	mse
	}
	return local vce	jackknife
	return local missing 	`missing'
	return matrix b		`b'
	return matrix b_jk	`b_jk'
	return matrix V		`v_jk'
	return scalar N_reps	= `N_reps'
	if `"`prefix'"' == "svy" {
		return scalar df_r	= `df'+1-return(N_strata)
	}
	else	return scalar df_r	= `df'
	return scalar k_eexp	= `k_eexp'
	return scalar k_exp	= `nstat' - `k_eexp'
	return local prefix	`prefix'
	return local cmd	`cmd'
end

program CheckWtype, rclass
	capture syntax [fw pw iw]
	return scalar rc = c(rc)
	return local weight `weight'
	return local exp `"`exp'"'
end

program Error2000
	di in smcl as error ///
		"{p 0 0 2}insufficient observations to" ///
		" compute jackknife standard errors{break}" ///
		"no results will be saved{p_end}"
	exit 2000
end

exit
