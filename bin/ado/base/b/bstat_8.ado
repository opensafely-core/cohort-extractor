*! version 2.3.10  17mar2005
program bstat_8
	version 8.0, missing
	local version : di "version " string(_caller()) ", missing:"

	// version control
	if _caller() < 8 {
		`version' bstat_7 `0'
		exit
	}
	// check syntax
	syntax [anything] [using/] [if] [in] [, 	///
		accel(string)				///
		bca					///
		Level(cilevel)				///
		noBC					///
		noNormal				///
		noPercentile				///
		notable					///
		SEParate				///
		Stat(string)				///
		TItle(string)				///
		n(integer -1)				///
		]

	if `"`using'"' != "" {
		preserve
		qui use `"`using'"', clear
	}

	GetValues `anything'	///
		`if' `in',	///
		`bca'		///
		accel(`accel')	///
		stat(`stat')	///
		n(`n')
	local nobs `r(Nobs)'
	local nrep `r(Nrep)'
	local nstr `r(Nstr)'
	local nclu `r(Nclu)'
	local bca  `r(bca)'
	local varlist `r(varlist)'

	// mark here since we now have varlist
	tempvar touse
	mark `touse' `if' `in'

	tempname eb
	matrix `eb' = r(b)
	if `"`bca'"' != "" {
		tempname va
		matrix `va' = r(a)
	}

	if (`"`bc'"' != "")		& ///
	   (`"`normal'"' != "")		& ///
	   (`"`percentile'"' != "")	& ///
	   (`"`bca'"' == "") {
		local tablestar "*"
	}
	else if `"`table'"' != "" {
		local bc nobc
		local normal nonormal
		local percentile nopercentile
		local bca
		local tablestar "*"
	}

	// the number of listed bootstrapped variables
	local nstat : word count `varlist'
	// null vector for return vectors
	tempname vzero 
	matrix `vzero' = J(1,`nstat',0)
	matrix colnames `vzero' = `varlist'

	// setup ereturn matrices
	if `"`bca'"' != "" {
		local rvecs accel
		local rmats ci_bca
	}
	local rvecs `rvecs' z0 se bias reps
	foreach vecname of local rvecs {
		tempname `vecname'
		matrix ``vecname'' = `vzero'
		matrix rownames ``vecname'' = `vecname'
	}
	local rmats `rmats' ci_bc ci_percentile ci_normal
	foreach vecname of local rmats {
		tempname `vecname'
		matrix ``vecname'' = `vzero' \ `vzero'
		matrix rownames ``vecname'' = ll ul
	}
	matrix drop `vzero'
	local rmats `rvecs' `rmats'
	local rvecs

	// Calculate and Display
	`tablestar' TableHead	///
		`"`title'"'	///
		"`level'"	///
		"`nobs'"	///
		"`nstr'"	///
		"`nclu'"	///
		"`nrep'"

	// ebi - observed value of the statistic for the current variable
	tempname ebi
	if `"`bca'"' != "" {
		// vai - estimated acceleration of ebi
		tempname vai
	}

	// Loop through varlist
	forvalues i = 1/`nstat' {
		local name : word `i' of `varlist'
		scalar `ebi' = `eb'[1,colnumb(`eb',"`name'")]
		if `"`bca'"' != "" {
			scalar `vai' = `va'[1,colnumb(`va',"`name'")]
		}
		if `i' > 1 {
			local sep `separate'
		}

		OneBstat		///
			`touse'		///
			`name'		///
			`ebi'		///
			"`vai'"		///
			`level'		///
			"`sep'"		///
			"`normal'"	///
			"`percentile'"	///
			"`bc'"		///
			"`bca'"

		// retrieve return vectors
		foreach vecname of local rmats {
			mat ``vecname''[1,`i'] = r(`vecname')
		}
	}
	`tablestar' TableFoot , `normal' `percentile' `bc' `bca'

	// return vectors
	local mats
	foreach vecname of local rmats {
		local mats `mats' `vecname' ``vecname''
	}
	local ns nobs nclu nrep nstr
	foreach n of local ns {
		if `"``n''"' != "" {
			local nopts `"`nopts' `n'(``n'')"'
		}
	}
	Estimate `varlist',	///
		b(`eb')		///
		accel(`va')	///
		`nopts'		///
		`mats'
end

// check options, then save results to be used for display
//
// Saved results:
//
// Scalars:
// 	r(Nobs)		n(), _dta[N] or '.'
// 	r(Nrep)		number of replications, _dta[N_reps]
// 	r(Nstr)		number of strata, _dta[N_strata]
// 	r(Nclu)		number of clusters, _dta[N_cluster]
//
// Macros:
// 	r(varlist)	varlist
// 	r(bca)		bca, or ""
//
// Matrices:
// 	r(b)		observed values of statistics
// 	r(a)		observed acceleration values

program GetValues, rclass
	syntax [varlist(numeric)]	///
		[if] [in] [,		///
		bca			///
		accel(string)		///
		stat(string)		///
		n(integer -1)		///
	]

	return local varlist `varlist'

	qui count `if' `in'
	if r(N)==0 {
		error 2000
	}
	return scalar Nrep = r(N)

	// retrieve bootstrap characteristics
	local version : char _dta[bs_version]

	if `"`version'"' == "2" {
		if `n' < 0 {
			local n : char _dta[N]
			cap confirm integer number `n'
			if !_rc {
				if `n' > 0 {
					return scalar Nobs = `n'
				}
			}
		}
		else	return scalar Nobs = `n'
	
		local nstr : char _dta[N_strata]
		cap confirm integer number `nstr'
		if !_rc {
			if `nstr' > 0 {
				return scalar Nstr = `nstr'
			}
		}
	
		local nclu  : char _dta[N_cluster]
		cap confirm integer number `nclu'
		if !_rc {
			if `nclu' > 0 {
				return scalar Nclu = `nclu'
			}
		}

		GetMat `varlist',	///
			char(observed)	///
			opt(stat)	///
			mat(`stat')
		tempname b
		mat `b' = r(mat)
		return matrix b `b'

		if `"`bca'`accel'"' != "" {
			GetMat `varlist',		///
				char(acceleration)	///
				opt(accel)		///
				mat(`accel')
			tempname a
			mat `a' = r(mat)
			return matrix a `a'
			return local bca bca
		}
		exit
	}

	// version 1 or some other dataset
	GetMat `varlist', 	///
		char(bstrap)	///
		opt(stat)	///
		mat(`stat')
	tempname b
	mat `b' = r(mat)
	return matrix b `b'

	if `"`bca'`accel'"' != "" {
		GetMat `varlist', opt(accel) mat(`accel')
		tempname a
		mat `a' = r(mat)
		return matrix a `a'
		return local bca bca
	}
	if `n' > 0 {
		return scalar Nobs = `n'
	}
end

program GetMat, rclass
	syntax varlist , opt(name) [ char(name) mat(string) ]

	local ncol : word count `varlist'
	tempname b
	if `"`mat'"' != "" {
		// user supplied matrix
		capture confirm matrix `mat'
		if _rc {
			capture matrix `b' = `mat'
			if _rc {
				di as err "option `opt'() invalid"
				exit 198
			}
		}
		else	matrix `b' = `mat'
		if rowsof(`b') != 1 {
			di as err "option `opt'() requires a row vector"
			exit 198
		}
		if `ncol' < colsof(`b') {
			di as err "too many values in `opt'()"
			exit 503
		}
		else if `ncol' > colsof(`b') {
			di as err "too few values in `opt'()"
			exit 503
		}
		local coln : colnames `b'
		if !`:list coln in varlist' {
			matrix colnames `b' = `varlist'
		}
	}
	else {
		if `"`char'"' == "" {
			NeedOpt `opt'
		}
		// get matrix elements from variable characteristics
		foreach var of local varlist {
			local ch : char `var'[`char']
			cap confirm number `ch'
			if !_rc {
				matrix `b' = nullmat(`b'), `ch'
			}
			else {
				NeedOpt `opt'
			}
		}
		matrix colnames `b' = `varlist'
	}
	return matrix mat `b'
end

program NeedOpt
	args opt

	di in smcl as err "{p 0 0 2}option `opt'() is required"	///
	" with datasets that are not generated"		///
	" by the bootstrap command{p_end}"

	exit 198
end

program OneBstat, rclass
	args touse x ebi vai level sep normal percentile bc bca
	tempname sd zalpha z0 zz

quietly {
	summarize `x' if `touse'
	local n = r(N)

	local bias = r(mean) - `ebi'
	scalar `sd' = r(sd)

	// Compute bias-corrected (and accelerated) percentiles
	local eps = (1e-7)*max(`sd',abs(`ebi'))
	count if `x'<=`ebi'+`eps' & `touse'
	if r(N) > 0 & r(N) < `n' {
		scalar `z0' = invnorm(r(N)/`n')
		scalar `zalpha' = invnorm((100 + `level')/200)

		// bias-corrected
		local p1 = 100*normprob(2*`z0' - `zalpha')
		local p2 = 100*normprob(2*`z0' + `zalpha')
		cap _pctile `x' if `touse', p(`p1', `p2')
		if _rc {
			local bc1 `"."'
			local bc2 `"."'
		}
		else {
			local bc1 = r(r1)
			local bc2 = r(r2)
		}

		// bias-corrected and accelerated
		if "`vai'" != "" {
			if ! missing(`vai') {
			    scalar `zz' = `z0'-`zalpha'
			    local p1 = 100*normprob(`z0'+`zz'/(1-`vai'*`zz'))
			    scalar `zz' = `z0'+`zalpha'
			    local p2 = 100*normprob(`z0'+`zz'/(1-`vai'*`zz'))
			    capture _pctile `x' if `touse', p(`p1', `p2')
			    if _rc {
				    local bca1 `"."'
				    local bca2 `"."'
			    }
			    else {
				    local bca1 = r(r1)
				    local bca2 = r(r2)
			    }
			}
			else local vai
		}
		if "`bca1'`bca2'" == "" {
			local bca1 = `"."'
			local bca2 = `"."'
		}
	}
	else {
		scalar `z0' = .
		local bc1 `"."'
		local bc2 `"."'
		local bca1 `"."'
		local bca2 `"."'
	}

	// Compute percentiles
	local p1 = (100 - `level')/2
	local p2 = (100 + `level')/2
	_pctile `x' if `touse', p(`p1', `p2')
	local p1 = r(r1)
	local p2 = r(r2)

	// Compute normal CI
	scalar `zalpha' = invttail(`n'-1, (100-`level')/200)
	local n1 = `ebi' - `zalpha'*`sd'
	local n2 = `ebi' + `zalpha'*`sd'

} // quietly

	// Print results
	local full    `x' `n' `ebi' `bias' `sd'
	if `"`sep'"' != "" {
		TableSep
	}
	if `"`normal'"' == "" {
		TableEntry `full'  `n1'   `n2'   "(N)"
		local full
	}
	if `"`percentile'"' == "" {
		TableEntry `full'  `p1'   `p2'   "(P)"
		local full
	}
	if `"`bc'"' == "" {
		TableEntry `full'  `bc1'  `bc2'  "(BC)"
		local full
	}
	if "`bca'" != "" {
		TableEntry `full' `bca1' `bca2' "(BCa)"
	}
	else local vai `"."'

	// Save results
	tempname tmat
	return scalar z0 = `z0'
	return scalar accel = `vai'

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
	return scalar stat = `ebi'
	return scalar reps = `n'
end

program Estimate, eclass
	syntax [varlist] ,		///
		b(name)			///
		[			///
		accel(name)		///
		nrep(integer -1)	///
		NOBS(integer -1)	///
		nclu(integer -1)	///
		nstr(integer -1)	///
		*			///
	]

	capture confirm matrix `b'
	if _rc {
		di as error `"b() invalid"'
		exit 198
	}
	if `nobs' > 0 {
		local obsopt obs(`nobs')
	}
	if `nrep' < 2 {
		di as error `"insufficient observations in bootstrap dataset"'
		exit 198
	}
	capture confirm matrix e(accel)
	if `"`e(accel)'"' != "" {
		tempname eaccel
		matrix `eaccel' = e(accel)
	}
	local nvars : word count `varlist'
	tempname eb
	matrix `eb' = J(1,`nvars',0)
	matrix colnames `eb' = `varlist'
	tokenize `varlist'
	// line up the columns for posting
	forvalues i = 1/`nvars' {
		matrix `eb'[1,`i'] = `b'[1,colnumb(`b',"``i''")]
	}
	SumAccum `varlist'
	if `"`r(rc)'"' != "" {
		di 
		di in smcl as error		///
			"{p 0 0 2}insufficient observations to" ///
			" compute bootstrap standard errors{break}" ///
			"no results will be saved{break}"
		exit `r(rc)'
	}
	tempname bs_b bs_v
	mat `bs_b' = r(bs_b)
	matrix rownames `bs_b' = y1
	mat `bs_v' = r(V)
	local n = r(n)
	eret post `eb' `bs_v', `obsopt'
	if `"`accel'"' != "" {
		eret matrix accel `accel'
	}
	else if `"`eaccel'"' != "" {
		eret matrix accel `eaccel'
	}
	local nalt : word count `options'
	if mod(`nalt',2) != 0 {
		di as error `"invalid extra options"'
		exit 198
	}
	tokenize `options'
	while `"`1'"' != "" {
		local name `1'
		local mat `2'
		mac shift 2
		eret matrix `name' `mat'
	}
	eret matrix bs_b `bs_b'
	// scalars
	if `nclu' > 0 {
		eret scalar N_clust = `nclu'
	}
	if `nstr' > 0 {
		eret scalar N_strata = `nstr'
	}
	// macros
	eret local predict _no_predict
	eret local cmd bootstrap
end

program SumAccum, rclass
	syntax [varlist] [if] [in]
	marksample touse
	tempname b v
	local K : word count `varlist'
	qui count if `touse'
	if r(N)<=1 {
		return local rc 2000
		exit
	}
	qui matrix accum `v' = `varlist' if `touse', deviations
	local n = r(N)
	local df = `n'-1
	local k1 = `K'+1
	matrix `b' = `v'[`k1',1..`K']/`n'
	matrix `v' = `v'[1..`K',1..`K']/`df'
	return matrix bs_b `b'
	return matrix V `v'
	return local n `n'
end

program TableHead
	args title level nobs nstr nclu reps
	if `"`title'"' == "" {
		local title "Bootstrap statistics"
	}
	di
	di in smcl as txt `"`title'"' _c
	if `"`nobs'"' == "" {
		local nobs .
	}
	di as txt _col(51) "Number of obs    =" as res %10.0f `nobs'
	if `"`nstr'"' != "" {
		di as txt _col(51) "Number of strata =" as res %10.0f `nstr'
	}
	if `"`nclu'"' != "" {
		di as txt _col(51) "N of clusters    =" as res %10.0f `nclu'
	}
		di as txt _col(51) "Replications     =" as res %10.0f `reps'
	di
	di in smcl as txt "{hline 13}{c TT}{hline 64}"
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local cititle "Conf. Interval"
	}
	else {
		local cititle "Conf. Int."
	}
	di in smcl as txt %-12s "Variable" " {c |}" ///
		%6s  "Reps"      ///
		%10s "Observed" ///
		%10s "Bias"     ///
		%10s "Std. Err" "." ///
		%21s `"[`=strsubdp("`level'")'% `cititle']"'
	TableSep
end

program TableSep
	di in smcl as txt "{hline 13}{c +}{hline 64}"
end

program TableEntry
	args name reps ebi bias se ll ul comment
	capture confirm name `name'
	if _rc == 0 {
		di in smcl as txt %12s abbrev(`"`name'"',12) " {c |}" ///
			as res ///
			%6.0g `reps' _s(1) ///
			%9.0g `ebi'  _s(1) ///
			%9.0g `bias' _s(1) ///
			%9.0g `se'   _s(2) ///
			%9.0g `ll'   _s(2) ///
			%9.0g `ul'   _s(1) ///
			as txt %5s `"`comment'"'
	}
	else {
		args ll ul comment
		di in smcl as txt _col(13) " {c |}"	///
			as res _col(53)			///
			%9.0g `ll'   _s(2)		///
			%9.0g `ul'   _s(1)		///
			as txt %5s `"`comment'"'
	}

end

program TableFoot
	syntax [, nonormal nopercentile nobc bca]
	if `"`normal'"' == "" {
		local desc _col(8) "N   = normal"
		local break _n
	}
	if `"`percentile'"' == "" {
		local desc `desc' `break' _col(8) "P   = percentile"
		local break _n
	}
	if `"`bc'"' == "" {
		local desc `desc' `break' _col(8) "BC  = bias-corrected"
		local break _n
	}
	if "`bca'" != "" {
		local desc `desc' `break' _col(8) ///
			"BCa = bias-corrected and accelerated"
	}
	di in smcl as txt "{hline 13}{c BT}{hline 64}"
	di "Note:" _c
	di `desc'
end

exit

NOTES:

-bstat- is very dependent upon the dataset generated by -bootstrap-, thus
certain conditions must be set in order for -bstat- to behave consistently.

The -Check- subroutine checks certain conditions of the data in memory.  These
conditions determine the version of the bootstrap dataset, as well as strict
conditions that are required by that version in order to proceed.  These
conditions are based on characteristics (-char-) of the data and the variables.

In the following <var> is the name of a variable in the dataset.

Version 1:	_dta[bs_version] == ""
	char <var>[bstrap] is a number 
		NOTE: this characteristic will be copied over to
		<var>[observed]

Version 2:	_dta[bs_version] == 2
	char <var>[observed] is a number
	char <var>[acceleration] is a number if it exists

Output ruler:
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Logit estimates                                   Number of obs   =        100
                                                  LR chi2(1)      =       0.83
                                                  Prob > chi2     =     0.3610
Log likelihood = -5.1830091                       Pseudo R2       =     0.0745
        
------------------------------------------------------------------------------
           y |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
           x |  -3.712523   4.739402    -0.78   0.433    -13.00158    5.576535
       _cons |  -3.374606   1.441799    -2.34   0.019    -6.200481   -.5487309
------------------------------------------------------------------------------
        
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Bootstrap statistics                              Number of obs    =        74
                                                  Number of strata =         1
                                                  Replications     =        50

------------------------------------------------------------------------------
Variable     |  Reps  Observed      Bias  Std. Err. [95% Conf. Interval]
-------------+----------------------------------------------------------------
       _bs_1 |    50   21.2973   .178109  .6358634   20.01948   22.57511   (N)
             |                                       20.33784   22.93243   (P)
             |                                       20.09459   22.24324  (BC)
             |                                       20.09459   22.27027 (BCa)
------------------------------------------------------------------------------
N   = normal
P   = percentile
BC  = bias-corrected
BCa = bias-corrected and accelerated

<end>
