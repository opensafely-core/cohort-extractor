*! version 3.3.0  20feb2019
program iqreg, byable(onecall) prop(mi) eclass
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if "`e(cmd)'" != "iqreg" {
			error 301
		}
		if _by() {
			error 190
		}
		Replay `0'
		exit
	}
	`BY' Estimate `0'
end

program Estimate, eclass byable(recall) sort
	local cmdline : copy local 0
	version 13

	syntax varlist(numeric fv) [if] [in] [, Level(cilevel)		///
						Quantiles(string)	///
						WLSiter(integer 1)	///
						Reps(integer 20) 	///
						noLOg 			///
						noDOts			///
						* ]
	_get_diopts diopts , `options'
	marksample touse

	if "`log'"!="" | "`dots'"!="" {
		local log "*"
	}

	SetQ `quantiles'
	local q0 = r(q0)
	local q1 = r(q1)

	if `reps' < 2 {
		di in red "{bf:reps(`reps')} must be greater than 1"
		exit 198
	}

	tempname coefs VCE coefs0 coefs1 handle
	tempvar bcons bwt

	quietly count if `touse'
	if r(N) < 4 {
		error 2001
	}

	local opts "wls(`wlsiter')"
	gettoken depv rhs : varlist
	_rmcoll `rhs' [`weight'`exp'] if `touse', expand
	local rhs `r(varlist)'
	qui _regress `depv' `rhs' if `touse'
	local colna : colna e(b)
	local ncolna : list sizeof colna

	forval i = 1/`ncolna' {
		local result "`result' (`coefs1'[1,`i'])"
		tempvar v
		local vl "`vl' `v'"
	}

	local seed = c(seed)
	preserve
	`log' di in gr "(fitting base model)"

	tempname omit0 omit1
	qui {
		keep if `touse'
		fvrevar `rhs', list
		keep `depv' `r(varlist)' `touse'
		version 12: qreg `depv' `rhs', `opts' q(`q0')
		_check_omit `omit0', get
	}
	if e(N)==0 | e(N)>=. {
		error 2001
	}
	local nobs `e(N)'
	local tdf `e(df_r)'
	local q `e(q)'
	local rsd1 `e(sum_rdev)'
	local msd1 `e(sum_adev)'
	mat `coefs0' = e(b)

	qui version 12: qreg `depv' `rhs', `opts' q(`q1') 
	if e(N) != `nobs' {
		di in red 						///
		 "`q0' quantile:  `nobs' obs. used" _n			///
		 "`q1' quantile:  `e(N)' obs. used" _n 			///
		 "{p}same sample cannot be used to estimate both " 	///
		 "quantiles; sample size is probably too small{p_end}"
		exit 498
	}
	if e(df_r) != `tdf' {
		di in red 						   ///
		 "`q0' quantile:  " `nobs'-`tdf' " coefs estimated" _n 	   ///
		 "`q1' quantile:  " `e(N)'-`e(df_r)' " coefs estimated" _n ///
		 "{p}same model cannot be used to estimate both "	   ///
		 "quantiles; sample size probably too small{p_end}"
		exit 498
	}
	_check_omit `omit1', get
	local msd0 `e(sum_adev)'
	local rsd0 `e(sum_rdev)'
	mat `coefs' = e(b) - `coefs0'

	qui gen double `bwt' = .
	if "`log'" == "" {
		di
		_dots 0, title(Bootstrap replications) reps(`reps') `dots'
		if ("`dots'"!="") local dots *
		else local dots _dots
	}
	else local dots *

	qui frame create `handle' double(`vl')
	capture noisily {
		local j 1
		while `j'<=`reps' {
			bsampl_w `bwt' /* `recnum' */
			capture noisily {
				qreg_c `depv' `rhs', /*
					*/ `opts' q(`q0') wvar(`bwt')
				_check_omit `omit0', check result(omit)
				if `omit' {
					exit 2
				}
				mat `coefs0' = e(b)
				qreg_c `depv' `rhs', /*
					*/ `opts' q(`q1') wvar(`bwt')
				_check_omit `omit1', check result(omit)
				if `omit' {
					exit 2
				}
				mat `coefs1' = e(b) - `coefs0'
			}
			local rc = _rc
			if (`rc'==0) {
				frame post `handle' `result'
				`dots' `j' 0
				local j=`j'+1
			}
			else {
				if _rc == 1 {
					exit 1
				}
				`dots' `j' 1
			}
		}
	}
	local rc = _rc 
	`dots' `reps'
	if `rc' {
		exit `rc'
	}

	frame `handle' {
		quietly mat accum `VCE' = `vl', dev nocons
		mat rownames `VCE' = `colna'
		mat colnames `VCE' = `colna'
		mat `VCE'=`VCE'*(1/(`reps'-1))
	}

	restore
	ereturn post `coefs' `VCE',	obs(`nobs')		///
					dof(`tdf')		///
					depn(`depv')		///
					esample(`touse')	///
					buildfvinfo

	ereturn hidden local seed `seed'
	ereturn local depvar "`depv'"
	ereturn scalar reps = `reps'
	ereturn scalar N = `nobs'
	ereturn scalar df_r = `tdf'
	ereturn scalar q0 = `q0'
	ereturn scalar q1 = `q1'
	ereturn scalar sumrdev0 = `rsd0'
	ereturn scalar sumrdev1 = `rsd1'
	ereturn scalar sumadev0 = `msd0'
	ereturn scalar sumadev1 = `msd1'
	ereturn local vcetype "Bootstrap"
	ereturn scalar convcode = 0
	ereturn local marginsnotok stdp stddp Residuals
	ereturn local predict "qreg_p"
	ereturn local cmdline `"iqreg `cmdline'"'
	ereturn local cmd "iqreg"
	_post_vce_rank

	Replay, level(`level') `diopts'
end

program Replay
	syntax [, Level(cilevel) *]
	_get_diopts diopts, `options'

	PrForm `e(q0)'
	local q0 `r(pr)'
	PrForm `e(q1)'
	local q1 `r(pr)'

	di _n in gr "`e(q1)'-`e(q0)' Interquantile regression" _col(53) _c

	di in gr "Number of obs = " in ye %10.0gc e(N)

        di in gr "  bootstrap(" in ye "`e(reps)'" in gr ") SEs" /* 
	*/ _col(53) "`q1' Pseudo R2 = " in ye %10.4f /*
	*/ 1-(`e(sumadev0)'/`e(sumrdev0)')
	di in gr _col(53) "`q0' Pseudo R2 = " in ye %10.4f /*
	*/ 1-(`e(sumadev1)'/`e(sumrdev1)')
	di

	_coef_table, level(`level') `diopts'
	error `e(convcode)'
end


program SetQ /* <nothing> | # [,] # */ , rclass
	if "`*'"=="" {
		ret scalar q0 = .25
		ret scalar q1 = .75
		exit
	}
	local orig "`*'"
	tokenize "`*'", parse(" ,")
	FixNumb "`orig'" `1'
	ret scalar q0 = r(qval)

	mac shift 
	if "`1'"=="," {
		mac shift
	}
	FixNumb "`orig'" `1'
	ret scalar q1 = r(qval)

	mac shift
	if "`*'"!="" {
		Invalid "`orig'"
	}
	if `return(q0)' >= `return(q1)' {
		Invalid "`orig'" "`return(q0)' >= `return(q1)'"
	}
end

program FixNumb /* # */ , rclass
	local orig "`1'"
	mac shift
	capture confirm number `1'
	if _rc {
		Invalid "`orig'" "`1' not a number"
	}
	if `1' >= 1 {
		ret scalar qval = `1'/100
	}
	else 	ret scalar qval = `1'
	if `return(qval)'<=0 | `return(qval)'>=1 {
		Invalid "`orig'" "`return(qval)' out of range"
	}
end
		

program Invalid /* "<orig>" "<extra>" */
	di in red "quantiles(`1') invalid"
	if "`2'" != "" {
		di in red "`2'"
	}
	exit 198
end

program PrForm /* # */ , rclass
	local pr : di %4.2f `1'
	if bsubstr("`pr'",1,1)=="0" {
		local pr = bsubstr("`pr'",2,.)
	}
	return local pr `"`pr'"'
end
exit
