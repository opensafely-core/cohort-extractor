*! version 3.1.19  13feb2015
program bootstrap_8
	version 8.2, missing
	local version : di "version " string(_caller()) ", missing:"

	/* replay output */
	capture syntax [anything] using [, *]
	local zerorc = (_rc==0)
	capture syntax [varlist] [, *]
	if _rc == 0 | `zerorc' {
		if "`e(cmd)'" != "bootstrap" {
			error 301
		}
		if _by() {
			error 190
		}
		`version' bstat_8 `0'
		exit
	}
	preserve
	`version' BootStrap `0'
	if `"`r(leave)'"' != "" {
		quietly restore, not
	}
end

program BootStrap, rclass
	version 8, missing
	local version : di string(_caller())
	local vv : di "version `version', missing:"

	set more off

	tempvar id
	gen `id' = _n
	preserve
	_cmdxel cmd names exp val K 0 : bs post bootstrap "`version'" `0'
	local diwarn `s(warn)'
	local keepesample `s(keep)'
	/* setup list of missings */
	forvalues j = 1/`K' {
		local mis `mis' (.)
		if missing(`val`j'') {
			di as err ///
"statistic `exp`j'' evaluated to missing in full sample"
			exit 459
		}
	}
	/* Stuff in `0', if anything, should be options. */
	#delimit ;
	syntax [,
		Dots
		DOUBle
		EVery(passthru)
		LEAVE			/* undocumented */
		REPLACE
		Reps(int 50)
		SAving(str)
		SIze(string)
		/* bsample opts */
		CLuster(varlist)
		IDcluster(string)
		STRata(varlist)
		/* bstat opts */
		bca			/* bias-corrected and accelerated */
		Level(cilevel)
		noBC
		noNormal
		noPercentile
		notable
		SEParate
		TItle(string)
		/* _cmdxel opts */
		nocheck
		noesample
		noheader		/* undocumented */
		NOIsily
		TRace
		nowarn
		];
	#delimit cr

	if "`trace'" != "" {
		local noisily noisily
		local traceon	set trace on
		local traceoff	set trace off
	}
	local dots = cond("`dots'" == "" | "`noisily'" != "", "*", "noisily")
	local noi = cond("`noisily'"=="", "*", "noisily")
	if "`check'" != "" {
		di as error "`check' invalid"
		exit 198
	}
	/* display resample warning */
	if `"`warn'"' == "" {
		`diwarn'
	}
	if `reps' < 2 {
		di as err "reps() must be an integer greater than 1"
		exit 198
	}
	local bstatopts /*
	*/ level(`level') title(`"`title'"') /*
	*/ `bc' `bca' `table' `normal' `percentile' `separate'
	/* Check options. */
	if `"`idcluster'"' != "" & `"`cluster'"'=="" {
		di as err /*
*/ "idcluster() can only be specified with cluster() option"
		exit 198
	}
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
		local ss : subinstr local saving ".dta" ""
		confirm new file `"`saving'.dta"'
	}

	/* keep only the estimation sample */
	if `"`esample'"' != "noesample" & `"`keepesample'"' != "" {
		qui `keepesample'
		restore, not
	}
	else {
		restore
	}
	if `"`strata'`cluster'"' != "" {
		sort `strata' `cluster'
	}
	/* get strata information */
	if `"`strata'"' != "" {
		tempvar sflag touse
		mark `touse'
		markout `touse' `strata'
		by `strata': gen `sflag' = _n==1
		qui replace `sflag' = sum(`sflag')
		sum `sflag' if `touse', mean
		local nstrata = r(max)
		local strataopt strata(`strata')
	}
	/* If clusters, count them. */
	local obs = _N
	if "`cluster'" != "" {
		foreach clname of local cluster {
			capture assert ! missing(`clname')
			if _rc {
				di as err /*
*/ `"missing values in cluster variable `clname' not allowed"'
				exit 459
			}
		}
		if `"`strata'"' != "" {
			local bystrata by `strata':
		}
		tempvar cflag
		quietly by `strata' `cluster': gen `cflag' = (_n==1)
		quietly count if `cflag'
		/* total number of clusters */
		local nclust = r(N)
		quietly `bystrata' replace `cflag' = sum(`cflag')
		/* number of clusters per strata */
		quietly `bystrata' replace `cflag' = `cflag'[_N]
		
		if "`size'" != "" {
			capture assert `size' <= `cflag'
			if _rc {
				di as err /*
*/ "size() must not be greater than number of clusters"
				exit 498
			}
		}
		local clustopts cluster(`cluster')
	}
	else {
		/* bsample prefers call without arguments */
		if `"`size'"' == "_N" {
			local size
		}
	}

	/* temp variables for post */
	local stats
	forvalues j = 1/`K' {
		tempname x`j'
		local stats `stats' (`val`j'')
	}
	/* jackknife estimates of acceleration */
	if `"`bca'"' != "" {
		/* expand the expression list */
		forvalues i = 1/`K' {
			local name : word `i' of `names'
			local exp_list `exp_list' `name'=(`exp`i'')
		}
		quietly `noisily' `vv'	/*
		*/ JKAccel		/*
		*/ `"`cmd'"'		/*
		*/ `"`exp_list'"'	/*
		*/ `"`cluster'"'	/*
		*/ `"`noisily'"'	/*
		*/ `"`trace'"'		/*
		*/
		tempname accel
		matrix `accel' = r(accel)
	}

	preserve

	/* prepare post */
	tempname postnam
	capture postfile `postnam' `names' using `"`saving'"', /*
		*/ `double' `every' `replace'
	local rc = _rc
	if `rc' {
		di in smcl as err /*
*/ "an error occurred when preparing {help postfile}"
		exit `rc'
	}
	post `postnam' `stats'

	/* bsample, compute and post */
	if `"`idcluster'"' != "" {
		local clustopts `clustopts' idcluster(`idcluster')
	}
	if `reps' > 1 {
		local s s
	}
	else            local a "a "
	`noi' di _n as res "`reps'" /*
	*/ as txt " call`s' to (" /*
	*/ as inp `"`cmd'"' /*
	*/ as txt ") with `a'bootstrap sample`s':" _n

	local bsamopts `strataopt' `clustopts'
	forvalues i = 1/`reps' {
		`dots' di as txt "." _c
		restore, preserve
		bsample `size', `bsamopts'
		/* run command and post results */
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
			local stats `mis'
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
				local stats `stats' (`x`j'')
			}
		}
		post `postnam' `stats'
	}
	`dots' di _n

	/* cleanup post */
	postclose `postnam'

	/* Load file `saving' with bootstrap results and display output. */
	capture use `"`saving'"', clear
	if _rc {
		if _rc >= 900 & _rc <= 903 {
			di as err /*
*/ "insufficient memory to load file with bootstrap results"
		}
		error _rc
	}
	local cmdlab : piece 1 80 of `"`cmd'"'
	label data `"bootstrap: `cmdlab'"'

	/* save bootstrap characteristics and labels to data set */
	forvalues i = 1/`K' {
		local name : word `i' of `names'
		local x = `name'[1]
		char `name'[observed] `x'
		if `"`bca'"' != "" {
			local x = `accel'[1,`i']
			char `name'[acceleration] `x'
		}
		local label = usubstr(`"`exp`i''"',1,80)
		label variable `name' `"`label'"'
	}
	char _dta[N_cluster]  `nclust'
	char _dta[N_strata] `nstrata'
	char _dta[N] `obs'
	char _dta[bs_version] 2
	quietly drop in 1

	if `"`filetmp'"' == "" {
		quietly save `"`saving'"', replace
	}
	if "`leave'" != "" {
		global S_FN
		quietly restore, not
		return local leave leave
	}

	/* Display/post output */
	bstat_8, `bstatopts'
end

program JKAccel, rclass
	version 8, missing
	local vv : di "version " string(_caller()) ", missing:"

	args cmd exp_list cluster noisily trace
	preserve
	if `"`cluster'"' != "" {
		local cluster cluster(`cluster')
	}
	jknife `"`cmd'"' `exp_list' , `cluster' keep `noisily' `trace'
	local names `r(names)'
	local K : word count `names'
	tempname accel
	matrix `accel' = J(1,`K',0)

        /* The following depends heavily on the fact that jknife's
        pseudovalues s[j]=N*s-(N-1)*s(j) and the leave one out values s(j)
        are equivalent when calculating acceleration, i.e. skew(s[j]) =
        -skew(s(j)). */

	forvalues i = 1/`K' {
		local name : word `i' of `names'
		quietly summ `name', detail
		if missing(r(skewness)) {
			di as err				///
`"{p 0 0 2}acceleration could not be computed for `name';"'
			if missing(r(Var)) {
				di as err			///
`" the bca option requires that ({cmd}`cmd'{reset}{err})"'	///
`" works with jknife, see help {help jknife}{p_end}"'
			}
			else {
				di as err			///
`" the jackknife values of `name' did not change from"'		///
`" observation to observation{p_end}"'
			}
			exit 198
		}
		matrix `accel'[1,`i'] = r(skewness)/(6*sqrt(r(N)))
		quietly drop `name'
	}
	matrix colnames `accel' = `names'
	return matrix accel `accel'
end
exit
