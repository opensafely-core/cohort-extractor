*! version 1.0.14  21feb2015
program permute_8
	version 8.2
	local version : di "version " string(_caller()) ":"
	capture syntax [anything] using [, *]
	local zerorc = (_rc==0)
	capture syntax [varlist] [, *]
	if _rc == 0 | `zerorc' {
		if _by() {
			error 190
		}
		Display `0'
		exit
	}
	preserve
	`version' Permute `0'
end

program Permute
	version 8
	local version : display string(_caller())
	local vv : di "version `version':"

	set more off

	/* get name of variable to permute */
	gettoken permvar 0: 0
	confirm variable `permvar'
	preserve
	_cmdxel cmd names exp val K 0 : pm post permute "`version'" `0'
	local diwarn `s(warn)'
	local keepesample `s(keep)'
	/* setup list of missings */
	forvalues j = 1/`K' {
		local mis "`mis' (.)"
	}
	/* Stuff in `0', if anything, should be options. */
	#delimit ;
	syntax [,
		Dots
		DOUBle
		EPS(real 1e-7)
		EVery(passthru)
		LEft RIght
		Level(cilevel)
		replace
		Reps(integer 100)
		SAving(string)
		STRata(varlist)
		/* _cmdxel options */
		nocheck
		noesample
		noheader		/* undocumented */
		NOIsily
		TRace
		nowarn
		];
	#delimit cr

	if "`check'" != "" {
		di as error "`check' invalid"
		exit 198
	}
	/* expand out permute variable name */
	local 0 `permvar'
	syntax varname
	local permvar `varlist'
	/* check syntax options */
	if `reps' < 1 {
		di as err "reps() must be a positive integer"
		exit 198
	}
	/* Check options. */
	if `"`strata'"' != "" {
		tempvar sflag
		sort `strata'
		by `strata': gen `sflag' = _n==1
		qui replace `sflag' = sum(`sflag')
		sum `sflag', mean
		local nstrata = r(max)
	}
	if "`trace'" != "" {
		local noisily noisily
		local traceon	set trace on
		local traceoff	set trace off
	}
	local dots = cond("`dots'"==""|"`noisily'"!="", "*", "noisily")
	local noi = cond("`noisily'"=="", "*", "noisily")
	if `"`saving'"'=="" {
		tempfile saving
		local filetmp "yes"
		if "`every'" != "" {
			di as err /*
*/ "every() can only be specified when using saving() option"
			exit 198
		}
		if "`replace'" != "" {
			di as err /*
*/ "replace can only be specified when using saving() option"
			exit 198
		}
	}
	else if `"`replace'"' == "" {
		confirm new file `"`saving'"'
	}

	local obs = _N
	if "`strata'"!="" {
		local bystrata "by `strata':"
	}
	if `eps' < 0 {
		di as err "eps() must be greater than or equal to zero"
		exit 198
	}

	/* Display permutation variable. */
	di as txt "permute var:" _col(15) "`permvar'"

	/* display resample warning */
	if `"`warn'"' == "" {
		`diwarn'
	}
	/* keep only the estimation sample */
	if `"`esample'"' != "noesample" {
		`keepesample'
		restore, not
		preserve
	}
	else {
		restore, preserve
	}
	/* temp variables for post */
	local stats
	tempname b
	matrix `b' = J(1,`K',0)
	forvalues j = 1/`K' {
		tempname x`j'
		local stats "`stats' (`val`j'')"
		matrix `b'[1,`j'] = `val`j''
	}
	matrix colnames `b' = `names'

	/* prepare post */
	tempname postnam
	capture postfile `postnam' `names' using `"`saving'"', /*
		*/ `double' `every' `replace'
	if _rc {
		di in smcl as err /*
*/ "an error occurred when preparing {help postfile}"
		exit _rc
	}
	post `postnam' `stats'
	if `reps' > 1 {
		local s s
	}
	else {
		local a "a "
	}
	`noi' di _n as res "`reps'" /*
	*/ as txt " call`s' to (" /*
	*/ as inp `"`cmd'"' /*
	*/ as txt ") with `a'permuted sample`s':" _n

	/* Sort by `strata' if necessary. */
	if "`strata'"!="" {
		sort `strata'
	}

	/* Check if `permvar' is a single dichotomous variable. */
	tempvar v
	qui summarize `permvar'
	local binary 0
	capture assert r(N)==_N & (`permvar'==r(min) | `permvar'==r(max))
	if _rc==0 {
		tempname min max
		scalar `min' = r(min)
		scalar `max' = r(max)

		qui `bystrata' gen long `v' = sum(`permvar'==`max')
		qui `bystrata' replace `v' = `v'[_N]

		local binary 1
	}
	else {
		gen `c(obs_t)' `v' = _n
	}

	/* Do permutations. */
	forvalues i = 1/`reps' {
		if `binary' {
			PermDiV "`strata'" `v' `min' `max' `permvar'
		}
		else {
			PermVars "`strata'" `v' `permvar'
		}

		/* analyze permuted data */
		`noi' di as inp `". `cmd'"'
		`traceon'
		capture `noisily' `vv' `cmd'
		`traceoff'
		if _rc {
			if _rc == 1 {
				error 1
			}
			`noi' di in smcl as error /*
*/ `"{p 0 0 2}captured error running (`cmd'), posting missing values{p_end}"'
			local stats "`mis'"
		}
		else {
			local stats
			forvalues j = 1/`K' {
				capture scalar `x`j'' = `exp`j''
				if _rc {
					if _rc == 1 {
						error 1
					}
					`noi' di in smcl as error /*
*/ `"{p 0 0 2}captured error in `exp`j'', posting missing value{p_end}"'
					scalar `x`j'' = .
				}
				local stats "`stats' (`x`j'')"
			}
		}
		post `postnam' `stats'
		`dots' di as txt "." _c
	}
	`dots' di

	/* cleanup post */
	postclose `postnam'

	/* Load file `saving' with permutation results and display output. */
	capture use `"`saving'"', clear
	if _rc {
		if _rc >= 900 & _rc <= 903 {
			di as err /*
*/ "insufficient memory to load file with permutation results"
		}
		error _rc
	}
	local cmdlab : piece 1 80 of `"`cmd'"'
	label data `"permute: `permvar' "`cmdlab'""'

	/* save permute characteristics and labels to data set */
	forvalues i = 1/`K' {
		local name : word `i' of `names'
		local x = `name'[1]
		char `name'[permute] `x'
		local label = usubstr(`"`exp`i''"',1,80)
		label variable `name' `"`label'"'
	}
	char _dta[N_strata] `nstrata'
	char _dta[N] `obs'
	char _dta[permvar] "`permvar'"
	quietly drop in 1

	if `"`filetmp'"' == "" {
		quietly save `"`saving'"', replace
	}

	Display `names', eps(`eps') `left' `right' level(`level')
end

program Display, rclass
	version 8
	syntax [anything] [using/],	/*
	*/ [				/*
	*/ eps(real 1e-7)		/*
	*/ Level(cilevel)		/*
	*/ left				/*
	*/ right			/*
	*/ ]

	/* check options */
	if `"`using'"' != "" {
		preserve
		qui use `"`using'"', clear
	}
	local 0 `anything'
	syntax [varlist]

	GetEvent, `left' `right' eps(`eps')
	local event `s(event)'
	local rel `s(rel)'
	local abs `s(abs)'

	/* check data characteristics */
	local nstrata : char _dta[N_strata]
	local obs : char _dta[N]
	local permvar : char _dta[permvar]
	if `"`permvar'"' == "" {
		di as error /*
*/ "permutation variable name not present as data characteristic"
		exit 9
	}

	/* Begin display */
	TableHead /*
		*/ "Monte Carlo permutation statistics" "`obs'" "`nstrata'" /*
		*/ _N `"`=strsubdp("`level'")'"'
	TableSep
	tempvar diff
	gen `diff' = 0
	local K : word count `varlist'
	tempname b c reps
	matrix `b' = J(1,`K',0)
	matrix colnames `b' = `varlist'
	matrix `c' = J(1,`K',0)
	matrix colnames `c' = `varlist'
	matrix `reps' = J(1,`K',0)
	matrix colnames `reps' = `varlist'
	forvalues j = 1/`K' {
		local name : word `j' of `varlist'
		local value : char `name'[permute]
		capture matrix `b'[1,`j'] = `value'
		if _rc {
			di in red /*
*/ `"estimates of observed statistic for `name' not found"'
			exit 111
		}
		quietly replace /*
		*/ `diff' = (`abs'(`name') `rel' `abs'(`value') - `eps')
		quietly sum `diff' if `name'<.
		mat `c'[1,`j'] = r(sum)
		mat `reps'[1,`j'] = r(N)
		quietly cii r(N) r(sum), level(`level')
		TableEntry "`name'"		/*
			*/ `value'		/*
			*/ `c'[1,`j']		/*
			*/ `reps'[1,`j']	/*
			*/ r(mean)		/*
			*/ r(se)		/*
			*/ r(lb)		/*
			*/ r(ub)		/*
			*/
	}
	TableFoot "`event'" `K'

	return matrix reps `reps'
	return matrix c `c'
	return matrix b `b'
	return local event `event'
	return local left `left'
	return local right `right'
end

program GetEvent, sclass
	version 8
	sret clear
	syntax [, left right eps(string)]
	if "`left'"!="" & "`right'"!="" {
		di as err "only one of left or right can be specified"
		exit 198
	}
	if "`left'"!="" {
		sreturn local event "T <= T(obs)"
		sreturn local rel "<="
		sreturn local eps = -`eps'
	}
	else if "`right'"!="" {
		sreturn local event "T >= T(obs)"
		sreturn local rel ">="
	}
	else {
		sreturn local event "|T| >= |T(obs)|"
		sreturn local rel ">="
		sreturn local abs "abs"
	}
end

program PermVars /* "byvars" k var */
	version 8
	local strata "`1'"
	local k "`2'"
	local x "`3'"
	tempvar r y
	quietly {
		if "`strata'"!="" {
			by `strata': gen double `r' = uniform()
		}
		else gen double `r' = uniform()

		sort `strata' `r'
		local type : type `x'
		gen `type' `y' = `x'[`k']
		drop `x'
		rename `y' `x'
	}
end

program PermDiV /* "byvars" k min max var */
	version 8
	args strata k min max x
	tempvar y
	if "`strata'"!="" {
		sort `strata'
		local bystrata "by `strata':"
	}
	quietly {
		gen byte `y' = . in 1
		`bystrata' replace `y' = /*
			*/ uniform()<(`k'-sum(`y'[_n-1]))/(_N-_n+1)
		replace `x' = cond(`y',`max',`min')
	}
end

program TableHead
	version 8
	args title obs nstrata reps level
	if `"`title'"' == "" {
		local title "Monte Carlo Permutation Statistics"
	}

	di
	di in smcl as txt `"`title'"' _c
	if `"`obs'"' != "" {
		di as txt _col(51) "Number of obs    =" as res %10.0f `obs'
	}
	if `"`nstrata'"' != "" {
		di as txt _col(51) "Number of strata =" as res %10.0f `nstrata'
	}
	if `"`reps'"' != "" {
		di as txt _col(51) "Replications     =" as res %10.0f `reps'
	}
	di
	di in smcl as txt "{hline 13}{c TT}{hline 64}"
	di in smcl as txt /*
		*/ %-12s "T" " {c |}" _s(1) /*
		*/ %10s "T(obs)"  /*
		*/ %8s  "c"       /*
		*/ %8s  "n"       /*
		*/ %8s "p=c/n"   /*
		*/ %8s "SE(p)"   _c
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
di in smcl as txt %21s `"[`=strsubdp("`level'")'% Conf. Interval]"'
	}
	else {
di in smcl as txt %21s `"[`=strsubdp("`level'")'% Conf. Int.]"'
	}
end

program TableSep
	di in smcl as txt "{hline 13}{c +}{hline 64}"
end

program TableEntry
	version 8
	args name tobs c n p sep ll ul
	di in smcl as txt /*
		*/ %-12s abbrev(`"`name'"',10) " {c |}" _s(2) as result /*
		*/ %9.0g `tobs' _s(1) /*
		*/ %7.0g `c'    _s(1) /*
		*/ %7.0g `n'    _s(1) /*
		*/ %7.4f `p'    _s(1) /*
		*/ %7.4f `sep'  _s(1) /*
		*/ %9.0g `ll'   _s(2) /*
		*/ %9.0g `ul'   _s(1) /*
		*/
end

program TableFoot
	version 8
	args event K
	di in smcl as txt "{hline 13}{c BT}{hline 64}"
	if `K' == 1 {
		di as txt /*
		*/ "Note:  confidence interval is with respect to p=c/n"
	}
	else {
		di as txt /*
		*/ "Note:  confidence intervals are with respect to p=c/n"
	}
	if "`event'"!="" {
		di in smcl as txt "Note:  c = #{`event'}"
	}
end

exit

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
Monte Carlo Permutation Statistics                Number of obs    =        74
                                                  Replications     =       100

------------------------------------------------------------------------------
T            |     T(obs)       c       n   p=c/n   SE(p) [95% Conf. Interval]
-------------+----------------------------------------------------------------
_pm1         |   24.77273       0     100  0.0000  0.0000         0   .0362167 
------------------------------------------------------------------------------
Note:  confidence interval(s) are with respect to p=c/n
Note:  c = #{|T| >= |T(obs)|}
