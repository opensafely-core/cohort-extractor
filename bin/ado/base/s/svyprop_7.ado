*! version 1.1.3  07feb2012
program define svyprop_7, rclass sortpreserve
	version 6, missing
	syntax varlist(numeric) [pw iw/] [if] [in] [, STRata(varname) /*
	*/ PSU(varname) FPC(varname numeric) BY(varlist numeric) /*
	*/ SUBpop(varname numeric) noLABel FORmat(string) ]

	if "`format'"=="" { local format "%9.6f" }

	tempvar doit nh

/* Get weights. */

	if "`exp'"=="" {
		svy_get pweight `exp', optional
		local exp "`s(varname)'"
	}
	else if "`weight'"=="pweight" { /* try to varset pweight variable */
		capture confirm variable `exp'
		if _rc==0 {
			svy_get pweight `exp'
			local exp "`s(varname)'"
		}
	}
	if "`exp'"!="" {
		if "`weight'"=="" { local weight "pweight" }
		local wt [`weight'=`exp']
	}

/* Generate weights if necessary. */

	capture confirm variable `exp'
	if _rc {
		tempvar w
		if "`exp'"=="" { qui gen byte   `w' = 1 }
		else		 qui gen double `w' = `exp'
	}
	else local w "`exp'"

/* Get strata, psu, and fpc. */

	svy_get strata `strata', optional
	local strata "`s(varname)'"

	svy_get psu `psu', optional
	local psu "`s(varname)'"

	svy_get fpc `fpc', optional
	local fpc "`s(varname)'"

/* Mark/markout. */

	mark `doit' `wt' `if' `in', zeroweight
	markout `doit' `w' `fpc' `varlist' `by' `subpop'
	markout `doit' `strata' `psu', strok

/* Compute total #obs. */

	qui count if `doit'
	if r(N) == 0 { noisily error 2000 }
	ret scalar N = r(N)

/* Process subpop() option. */

	if "`subpop'"!="" {
		svy_sub_7 `doit' `subpop' "`exp'" "`strata'"
		ret scalar N_sub = r(N_sub)
		return local subexp "`r(subexp)'"

		tempvar sub
		qui gen byte `sub' = (`subpop'!=0) if `doit'
		local andsub "& `sub'"
	}

/* Compute nh, etc. */

	Gen_nh `doit' `w' "`sub'" "`strata'" "`psu'" "`fpc'" `nh'
	ret add

/* Display header. */

	myHeader `return(N)' `return(N_strata)' `return(N_psu)' /*
	*/ `return(N_pop)' "`return(N_sub)'" "`return(N_subpop)'" /*
	*/ "`weight'" "`exp'" "`strata'" "`psu'" "`fpc'" "`subpop'" /*
	*/ "`return(subexp)'" dash

	di in gr _n "Survey proportions estimation"

/* No by(). */

	if "`by'"=="" {
		Prop `doit' `w' "`sub'" "`strata'" "`psu'" `nh' /*
		*/ `return(fpc)' "`label'" `format' `varlist'
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
			di in red "stratum with only one PSU detected"
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

	if "`sub'"=="" { local sub 1 }

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
			rename `nhsub' _Obs
			rename `r' _EstProp
			rename `d' _StdErr

			list `*' _Obs _EstProp _StdErr if _Obs<., /*
			*/	noobs nodisp `label'
		}
		local rc = _rc
		capture drop _Obs
		capture drop _EstProp
		capture drop _StdErr
		if `rc' { error `rc' }
	}
end

program define CheckFPC, rclass
	args doit strata fpc nh

	capture assert `fpc' >= 0 if `doit'
	if _rc {
		di in red "fpc must be >= 0"
		exit 462
	}
	capture by `doit' `strata': assert abs((`fpc' - `fpc'[1]) /*
	*/	/max(`fpc'[1],1)) < 1e-5 if `doit'
	if _rc {
		di in red "fpc for all observations within a stratum " /*
		*/ "must be the same"
		exit 462
	}
	capture assert `fpc' >= `nh' if `doit'
	if _rc {
		capture assert `fpc' <= 1 if `doit'
		if _rc {
			di in red "fpc must be <= 1 if a rate, " /*
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

program define myHeader /* display header */
	version 6, missing
	args nobs nstr npsu npop osub nsub wgt exp strata psu fpc /*
	*/   subpop subexp dash

	if "`wgt'"    == "" { local wgt    "pweight"        }
	if "`exp'"    == "" { local exp    "<none>"         }
	if "`strata'" == "" { local strata "<one>"          }
	if "`psu'"    == "" { local psu    "<observations>" }

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
		di in gr "Subpop.:" _col(11) "`subpop'`subexp'"
		   _col(49) "Subpop. no. of obs" _col(68) "= "
		   in ye %9.0f `osub' _n
		   in gr _col(49) "Subpop. size" _col(68) "="
		   in ye %10.0g `nsub'
	} ;

	if "`dash'"!="" { di in smcl in gr "{hline 78}" } ;
end ;
