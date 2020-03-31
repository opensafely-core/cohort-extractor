*! version 3.1.12  19feb2015
program simulate_8
	version 8.2, missing
	local version : display string(_caller())
	local vv : di "version `version', missing:"

	set more off

	_cmdxel cmd names exp val K 0 : sim post "" "`version'" `0'
	local diwarn `s(warn)'
	/* setup list of missings */
	forvalues i = 1/`K' {
		local mis "`mis' (.)"
	}
	/* Stuff in `0', if anything, should be options. */
	#delimit ;
	syntax [, 
		Dots 
		DOUBle 
		EVery(passthru) 
		REPLACE 
		Reps(integer -1) 
		SAving(str) 
		/* _cmdxel options */
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
	if "`esample'" != "" {
		di as error "`esample' invalid"
		exit 198
	}
	/* display resample warning */
	if `"`warn'"' == "" {
		`diwarn'
	}
	/* Check options. */
	if `reps' < 1 {
		di as err "reps() is required, and must be a positive integer"
		exit 198
	}
	if `"`saving'"'=="" {
		tempfile saving
		local filetmp "yes"
		if "`every'"!="" {
			di as err /*
*/ "every() can only be specified when using saving() option"
			exit 198
		}
		if "`replace'"!="" {
			di as err /*
*/ "replace can only be specified when using saving() option"
			exit 198
		}
	}
	else if `"`replace'"' == "" {
		confirm new file `"`saving'"'
	}

	/* temp variables for post */
	forvalues i = 1/`K' {
		tempname x`i'
	}

	/* this must be done before another command that saves in r() or
	e() can be run */

	if "`check'" == "" {
		local sims
		forvalues i = 1/`K' {
			capture scalar `x`i'' = `exp`i''
			local sims "`sims' (`x`i'')"
		}
		local repsleft = `reps' - 1
	}
	else	local repsleft `reps'

	/* Check to see if final dataset will fit in memory. */
	qui desc
	if r(N_max)-20 < `reps' {
		di as err "insufficient memory (observations)"
		exit 901
	}

	tempname postnam
	postfile `postnam' `names' using `"`saving'"', /*
		*/ `double' `every' `replace'

	if "`check'" == "" {
		post `postnam' `sims'
	}
	`noi' di _n as res "`repsleft'" /*
	*/ as txt " calls to (" /*
	*/ as res `"`cmd'"' /*
	*/ as txt ") to perform simulations" _n
	forvalues i = 1/`repsleft' {
		`dots' di as txt "." _c
		`noi' di as inp `". `cmd'"'
		`traceon'
		cap `noisily' `vv' `cmd'
		`traceoff'
		if _rc {
			if _rc == 1 {
				error 1
			}
			`noi' di in smcl as error /*
*/ `"{p 0 0 2}captured error running (`cmd'), posting missing values{p_end}"'
			local sims `mis'
		}
		else {
			local sims
			forvalues i = 1/`K' {
				capture scalar `x`i'' = `exp`i''
				if _rc {
					if _rc == 1 {
						error 1
					}
					`noi' di in smcl as error /*
*/ `"{p 0 0 2}captured error in `exp`i'', posting missing value{p_end}"'
					scalar `x`i'' = .
				}
				local sims "`sims' (`x`i'')"
			}
		}
		cap noi post `postnam' `sims'
		local rc = _rc
		if `rc' {
			di as err ///
"this error is most likely due to {cmd:clear} being used within: `cmd'"
			exit `rc'
		}
	}

	postclose `postnam'
	`dots' di _n

	capture use `"`saving'"', clear
	if _rc {
		if 900 <= _rc & _rc <= 903 {
			di as err /*
*/ "insufficient memory to load file with simulation results"
		}
		error _rc
	}

	local cmdlab : piece 1 80 of `"`cmd'"'
	label data `"simulate: `cmdlab'"'

	/* save labels to data set */
	forvalues i = 1/`K' {
		local name : word `i' of `names'
		local label = usubstr(`"`exp`i''"',1,80)
		label variable `name' `"`label'"'
	}
	if "`filetmp'"!="" {
		global S_FN
	}
	else {
		qui save `"`saving'"', replace
	}
end
exit
