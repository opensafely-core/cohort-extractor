*! version 2.0.9  11nov2004
program define svyprop, rclass sortpreserve
	version 8, missing
	if _caller()<8 {
		svyprop_7 `0'
		exit
	}
	syntax varlist(numeric) 	/*
	*/	[pw iw/]		/* see _svy_newrule.ado
	*/	[if] [in] [,		/*
	*/	BY(varlist numeric) 	/*
	*/	SUBpop(string asis)	/*
	*/	noLABel FORmat(string)	/*
	*/	STRata(passthru)	/* see _svy_newrule.ado
	*/	PSU(passthru)		/* see _svy_newrule.ado
	*/	FPC(passthru)		/* see _svy_newrule.ado
	*/	]

	_svy_newrule, `weight' `strata' `psu' `fpc'

	if "`format'"=="" {
		local format "%10.6f"
	}

	tempvar doit nh

/* Get weights, strata, psu, and fpc. */
	quietly svyset
	local strata `r(strata)'
	local psu `r(psu)'
	local fpc `r(fpc)'
	local wt [`r(wtype)'`r(wexp)']
	local weight `r(wtype)'
	local exp `r(`r(wtype)')'
	if `"`exp'"' == "" {
		tempvar w
		qui gen byte `w' = 1
	}
	else	local w `exp'

/* Mark/markout. */

	mark `doit' `wt' `if' `in', zeroweight
	markout `doit' `w' `fpc' `varlist' `by'
	markout `doit' `strata' `psu', strok

/* Process subpop() option. */

	if "`subpop'"!="" {
		tempvar sub
		svy_sub `doit'		///
			`sub'		///
			"`exp'"		///
			"`strata'"	///
			"" ""		/// not byable
			""		///
			`subpop'
		if "`r(srssubpop)'" != "" {
			local 0 , srssubpop
			syntax [, nothing ]
			exit 198	// should not be necessary
		}
		ret scalar N_sub = r(N_sub)

		local andsub "& `sub'"
	}

/* Compute total #obs. */

	qui count if `doit'
	if r(N) == 0 {
		noisily error 2000
	}
	ret scalar N = r(N)

/* Compute nh, etc. */

	Gen_nh `doit' `w' "`sub'" "`strata'" "`psu'" "`fpc'" `nh'
	ret add

/* Display header. */

	myHeader `return(N)' `return(N_strata)' `return(N_psu)' /*
	*/ `return(N_pop)' "`return(N_sub)'" "`return(N_subpop)'" /*
	*/ "`weight'" "`exp'" "`strata'" "`psu'" "`fpc'" "`subpop'" /*
	*/ dash

	di as txt _n "Survey proportions estimation"

/* No by(). */

	if "`by'"=="" {
		Prop `doit' `w' "`sub'" "`strata'" "`psu'" `nh' /*
		*/ `return(fpc)' "`label'" `format' `varlist'
		return local fpc
		exit
	}

/* If here, we have by() subpopulations. */

	tempvar first bysub
	sort `doit' `sub' `by'
	qui by `doit' `sub' `by': gen byte `first' = /*
	*/	(_n==1 & `doit' `andsub')
	qui gen byte `bysub' = . in 1  /* so -replace- auto promotes */
	qui replace `bysub' = sum(`first')
	local nby = `bysub'[_N]

	local i 1
	while `i' <= `nby' {
		_crcbygr `by' if `bysub'==`i' & `first'
		Prop `doit' `w' (`bysub'==`i') "`strata'" "`psu'" `nh' /*
		*/ `return(fpc)' "`label'"  `format' `varlist'
		local i = `i' + 1
	}
	return local fpc
end

program define Gen_nh, rclass
	args doit w sub strata psu fpc nh

	quietly {

	/* Sort by strata, PSU, and weights. */

		sort `doit' `strata' `psu' `w'

	/* Compute total #strata. */

		by `doit' `strata': gen byte `nh' = (_n==1) if `doit'
		count if `nh' == 1
		ret scalar N_strata = r(N)

	/* `nh' = #PSU in stratum h */

		if "`psu'"!="" {
			by `doit' `strata' `psu': replace `nh' = (_n==1) /*
			*/	if `doit'
		}
		else { /* observations are PSUs */
			replace `nh' = 1 if `doit'
		}

	/* Compute total #PSU. */

		count if `nh' == 1
		ret scalar N_psu = r(N)

	/* Finish `nh' computation.  Note: automatic promotion of type. */

		by `doit' `strata': replace `nh' = sum(`nh') if `doit'
		by `doit' `strata': replace `nh' = `nh'[_N]

	/* Check if `nh' >= 2. */

		capture assert `nh' >= 2 if `doit'
		if _rc {
			di as err "stratum with only one PSU detected"
			exit 460
		}

	/* Check fpc variable for sensible ranges. */

		if "`fpc'"!="" {
			CheckFPC `doit' "`strata'" `fpc' `nh'

			ret local fpc "`r(fpc)'*(`nh'/(`nh'-1))"
		}
		else	ret local fpc "(`nh'/(`nh'-1))"

	/* Sum weights over population and subpopulation. */

		tempname npop
		GenSum `npop' `doit'*`w'
		ret scalar N_pop = `npop'

		if "`sub'"!="" {
			tempname nsub
			GenSum `nsub' `sub'*`w'
			ret scalar N_subpop = `nsub'
		}
	}
end

program define Prop
	args doit w sub strata psu nh fpc label format
	macro shift 9

	tempvar d r yh nhsub
	tempname x varx

	if "`sub'"=="" {
		local sub 1
	}

	quietly {

	/* Sort by strata and PSU first. */

		sort `doit' `strata' `psu' `w'

	/* Sum weights over (sub)population. */

		GenSum `x' `sub'*`doit'*`w'

	/* Sum weights over strata and psu. */

		GenSumBy `d' `sub'*`w' `doit' `strata'

		if "`psu'"!="" {
			tempvar xhi
			GenSumBy `xhi' `sub'*`w' `doit' `strata' `psu'
			replace `d' = `xhi'-`d'/`nh'

			by `doit' `strata' `psu': replace `xhi' = /*
			*/	(_n==1 & `doit')

			GenSum `varx' `xhi'*`fpc'*`d'^2
			drop `xhi'
		}
		else {
			replace `d' = `sub'*`w'-`d'/`nh'
			GenSum `varx' `doit'*`fpc'*`d'^2
		}

	/* Sort by varlist first. */

		sort `doit' `*' `strata' `psu' `w'

	/* Sum weights by varlist. */

		GenSumBy `r' `sub'*`w' `doit' `*'

		replace `r' = `r'/`x'

	/* Sum weights over varlist by strata, and PSU. */

		GenSumBy `yh' `sub'*`w' `doit' `*' `strata'

		if "`psu'"!="" {
			tempvar yhi
			GenSumBy `yhi' `sub'*`w' `doit' `*' `strata' `psu'
			by `doit' `*' `strata' `psu': gen byte `nhsub' = (_n==1)
			replace `yhi' = . if `nhsub'==0 | `doit'==0
		}
		else {
			local yhi "`sub'*`w'"
			gen byte `nhsub' = 1
		}

		by `doit' `*' `strata': replace `nhsub' = sum(`nhsub') if `doit'
		by `doit' `*' `strata': replace `nhsub' = `nhsub'[_N]

		replace `yh' = `fpc'*((`yhi'-`yh'/`nh'-`r'*`d')^2 + /*
		*/ `yh'^2/(`nh'*`nhsub') - (`yh'/`nh'+`r'*`d')^2)

		drop `d'
		GenSumBy `d' `yh' `doit' `*'
		replace `d' = sqrt(`d' + `varx'*`r'^2)/`x'

		by `doit' `*': replace `nhsub' = /*
		*/	cond(_n==_N & `doit', sum(`sub'), .)
	}

	format `nhsub' %8.0f
	format `r' `d' `format'

	nobreak {
		capture noisily break {
			char `nhsub'[varname] "Obs"
			char `r'[varname] "Est. Prop."
			char `d'[varname] "Std. Err."

			list `*' `nhsub' `r' `d' if `nhsub'<., /*
			*/	noobs nodisp `label' subvar abbrev(12)
		}
		local rc = _rc
		if `rc' {
			error `rc'
		}
	}
end

program define CheckFPC, rclass
	args doit strata fpc nh

	capture assert `fpc' >= 0 if `doit'
	if _rc {
		di as err "fpc must be >= 0"
		exit 462
	}
	capture by `doit' `strata': assert abs((`fpc' - `fpc'[1]) /*
	*/	/max(`fpc'[1],1)) < 1e-5 if `doit'
	if _rc {
		di as err "fpc for all observations within a stratum " /*
		*/ "must be the same"
		exit 462
	}
	capture assert `fpc' >= `nh' if `doit'
	if _rc {
		capture assert `fpc' <= 1 if `doit'
		if _rc {
			di as err "fpc must be <= 1 if a rate, " /*
			*/ "or >= no. sampled PSUs per stratum if PSU totals"
			exit 462
		}
		else ret local fpc "(1-`fpc')"
	}
	else ret local fpc "(1-`nh'/`fpc')"
end

program define GenSum  /* scalarname expression */
	args s
	macro shift
	tempvar y e
	quietly {
		gen double `y' = sum(`*')
		gen double `e' = sum((`*')-(`y'-`y'[_n-1])) in 2/l
		scalar `s' = `y'[_N] + `e'[_N]
	}
end

program define GenSumBy  /* varname_to_hold_sum expression_to_sum by_varlist */
	args s x
	macro shift 2
	tempvar e
	quietly {
		by `*': gen double `s' = sum(`x')
		by `*': gen double `e' = sum((`x')-(`s'-`s'[_n-1]))
		by `*': replace `s' = `s'[_N] + `e'[_N]
	}
end

program define myHeader/* display header */
	version 6
	args nobs nstr npsu npop osub nsub wgt exp strata psu fpc /*
	*/   subpop dash

	if "`wgt'"    == "" {
		local wgt    "pweight"
	}
	if "`exp'"    == "" {
		local exp    "<none>"
	}
	if "`strata'" == "" {
		local strata "<one>"
	}
	if "`psu'"    == "" {
		local psu    "<observations>"
	}

	if "`dash'"!="" { di  in smcl _n in gr "{hline 78}" }
	else di /* newline */

	#delimit ;
	di in gr "`wgt':" _col(11) "`exp'"
	   in gr _col(49) "Number of obs" _col(68) "= "
	   in ye %9.0f `nobs' _n
	   in gr "Strata:" _col(11) "`strata'"
	   in gr _col(49) "Number of strata" _col(68) "= "
	   in ye %9.0f `nstr' _n
	   in gr "PSU:" _col(11) "`psu'"
	   in gr _col(49) "Number of PSUs" _col(68) "= "
	   in ye %9.0f `npsu' ;

	if "`fpc'"!="" { ;
		di in gr "FPC:" _col(11) "`fpc'"
		   in gr _col(49) "Population size" _col(68) "="
		   in ye %10.0g `npop' ;
	} ;
	else { ;
		di in gr _col(49) "Population size" _col(68) "="
		   in ye %10.0g `npop' ;
	} ;
	if "`subpop'"!="" { ;
		if `: length local subpop' > 20 { ;
			local subpop : piece 1 16 of `"`subpop'"' ;
			local subpop `"`subpop' ..."' ;
		} ;
		di in gr "Subpop.:" _col(11) "`subpop'"
		   _col(49) "Subpop. no. of obs" _col(68) "= "
		   in ye %9.0f `osub' _n
		   in gr _col(49) "Subpop. size" _col(68) "="
		   in ye %10.0g `nsub'
	} ;

	if "`dash'"!="" { di in smcl in gr "{hline 78}" } ;
end ;
