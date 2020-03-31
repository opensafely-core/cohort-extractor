*! version 3.4.0  20feb2019
program sqreg, byable(onecall) prop(mi) eclass
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if "`e(cmd)'" != "sqreg" {
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

	syntax varlist(numeric fv) [if] [in] [,	Level(cilevel)	///
					Quantiles(string)	///
					WLSiter(integer 1)	///
					Reps(integer 20)	///
					NOLOg LOg		///
					noDOts			///
					* ]
	_get_diopts diopts, `options'

	marksample touse

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"!="" | "`dots'"!="" {
		local log "*"
	}

	SetQ `quantiles'
	tokenize "`r(quants)'"
	local nq 1
	while "``nq''" != "" {
		local q`nq' ``nq''
		local nq = `nq' + 1
	}
	local nq = `nq' - 1
		
	if `reps' < 2 {
		di in red "{bf:reps(`reps')} must be greater than 1"
		error 198
	}

	tempname coefs VCE coefs0 coefs1 handle
	tempvar e bcons bwt

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

	local pow = 10
	local done = 0
	while !`done' {
		local pow = `pow'*10
		local done = 1
		forvalues k=1/`nq' {
			local q = (`q`k'')*`pow'
			local done = `done' & /* 
				*/ (reldif(`q',trunc(`q'))<c(epsfloat))
		}
	}
	local f = ceil(log10(`pow'))
	forvalues k=1/`nq' {
		local myeq = "q" + /*
			*/ string(trunc((`q`k'')*`pow'),"%0`f'.0f")
		local eqnames `eqnames' `myeq'
	}
	local eqnames : list uniq eqnames
	local k : word count `eqnames'
	if `k' < `nq' {
		di as err "only `k' out of `nq' quantiles are " /*
		 */ "unique within a relative precision of c(epsfloat)"
		exit 498
	}
	local EQNAMES : copy local eqnames
	forval k = 1/`nq' {
		tempname coef`k'
		gettoken myeq EQNAMES : EQNAMES
		local COLNA : copy local colna
		forval i = 1/`ncolna' {
			gettoken name COLNA : COLNA
			local result "`result' (`coef`k''[1,`i'])"
			local eqnams "`eqnams' `myeq'"
			local conams "`conams' `name'"
			tempvar v
			local vl "`vl' `v'"
		}
	}

	local seed = c(seed)
	preserve
	`log' di in gr "(fitting base model)"

	qui {
		keep if `touse'
		fvrevar `rhs', list
		keep `depv' `r(varlist)'
		/* vc <= 12 for old std.err. (discarded)	*/
		version 12: qreg `depv' `rhs', `opts' q(`q1')
		tempname omit1
		_check_omit `omit1', get
	}
	if e(N)==0 | e(N)>=. {
		error 2001
	}
	local nobs `e(N)'
	local tdf `e(df_r)'
	local rsd1 `e(sum_rdev)'
	local msd1 `e(sum_adev)'

	local vle "_cons"
	local vli "`bcons'"

	mat `coefs' = e(b)

	local k 2
	while `k' <= `nq' {
		version 12: qui qreg `depv' `rhs', `opts' q(`q`k'')
		tempname omit`k'
		_check_omit `omit`k'', get
		if e(N) != `nobs' {
			di in red "`q0' quantile:  `nobs' obs. used" 
			di in red "`q`k'' quantile:  `e(N)' obs. used"
			di in red "{p}same sample cannot be used to " 	  ///
			 "estimate both quantiles; sample size probably " ///
			 "too small{p_end}"
			exit 498
		}
		if e(df_r) != `tdf' {
			di in red "`q0' quantile:  " `nobs'-`tdf' " coefs " ///
			 "estimated"
			di in red "`q`k'' quantile:  " `e(N)'-`e(df_r)'     ///
			 "coefs estimated"
			di in red "{p}same model cannot be used to "	    ///
			 "estimate both quantiles; sample size probably "   ///
			 "too small{p_end}"
			exit 498
		}
		local msd`k' `e(sum_adev)'
		local rsd`k' `e(sum_rdev)'
		mat `coefs' = `coefs', e(b)

		local k = `k' + 1
	}
	mat colnames `coefs' = `conams'
	mat coleq `coefs' = `eqnams'

	qui gen double `bwt' = .
	if "`log'" == "" {
		di
		_dots 0, title(Bootstrap replications) reps(`reps') `dots'
		if ("`dots'"!="") local dots *
		else local dots _dots
	}
	else local dots *

	qui frame create `handle' double(`vl')
	quietly noisily {
		local j 1
		while `j'<=`reps' {
			bsampl_w `bwt'
			capture noisily {
				local k 1
				while `k'<=`nq' {
					qreg_c `depv' `rhs', /*
					*/ `opts' q(`q`k'') wvar(`bwt')
					_check_omit `omit`k'', ///
						check result(omit)
					if `omit' {
						exit 2
					}
					mat `coef`k'' = e(b)
					local k =`k' + 1
				}
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
		mat rownames `VCE' = `conams'
		mat roweq `VCE' = `eqnams'
		mat colnames `VCE' = `conams'
		mat coleq `VCE' = `eqnams'
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

	local k 1
	while `k' <= `nq' {
		ereturn scalar q`k' = `q`k''
		ereturn scalar sumrdv`k' = `rsd`k''
		ereturn scalar sumadv`k' = `msd`k''
		local k = `k' + 1
	}
	ereturn scalar n_q = `nq'
	ereturn local eqnames "`eqnames'"
	ereturn local vcetype "Bootstrap"
	ereturn scalar convcode = 0
	ereturn local marginsnotok stdp stddp Residuals
	ereturn local predict "sqreg_p"
	ereturn local cmdline `"sqreg `cmdline'"'
	ereturn local cmd "sqreg"
	_post_vce_rank

	Replay, level(`level') `diopts'
end

program Replay
	syntax [, Level(cilevel) *]
	_get_diopts diopts, `options'

	di _n in gr "Simultaneous quantile regression" _col(53) _c

	di in gr "Number of obs = " in ye %10.0gc e(N)

	PrForm `e(q1)'
        di in gr "  bootstrap(" in ye "`e(reps)'" in gr ") SEs" /* 
	*/ _col(53) "`r(pr)' Pseudo R2 = " /*
	*/ in ye %10.4f 1-(e(sumadv1)/e(sumrdv1))

	local k 2
	while `k' <= e(n_q) {
		PrForm `e(q`k')'
		di in gr /*
		*/ _col(53) "`r(pr)' Pseudo R2 = " /*
		*/ in ye %10.4f 1-(e(sumadv`k')/e(sumrdv`k'))
		local k = `k' + 1
	}
	di

	_coef_table, showeqns level(`level') `diopts'
	error `e(convcode)'
end


program SetQ /* <nothing> | # [,] # ... */ , rclass
	if "`*'"=="" {
		ret local quants ".5"
		exit
	}
	local orig "`*'"
	tokenize "`*'", parse(" ,")

	while "`1'" != "" {
		FixNumb "`orig'" `1'
		local quants "`quants' `r(q)'"
		mac shift 
		if "`1'"=="," {
			mac shift
		}
	}
	return local quants `"`quants'"'
end

program FixNumb /* # */ , rclass
	local orig "`1'"
	mac shift
	capture confirm number `1'
	if _rc {
		Invalid "`orig'" "`1' not a number"
	}
	if `1' >= 1 {
		ret local q = `1'/100
	}
	else 	ret local q `1'
	if `return(q)'<=0 | `return(q)'>=1 {
		Invalid "`orig'" "`return(q)' out of range"
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
