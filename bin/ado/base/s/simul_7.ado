*! version 2.1.4  29jan2015
program define simul_7
	version 7, missing

/* Parse. */

	gettoken prog 0: 0, parse(" ,")
	if `"`prog'"'=="" | bsubstr(`"`prog'"',1,1)=="," {
		di as err `"program name required"'
		exit 198
	}

	syntax [, Args(string) Dots Reps(integer -1) DOUBle /*
		*/ SAving(str) REPLACE EVery(passthru) NOIsily ]

/* Check options. */

	if `reps' < 1 {
		di as err "reps() required"
		exit 198
	}

	local dots = cond("`dots'"=="", "*", "noisily")

	if `"`saving'"'=="" {
		tempfile saving
		local filetmp "yes"
        	if "`every'"!="" {
                	di as err "every() can only be specified when " /*
			*/ "using saving() option"
                	exit 198
        	}
        	if "`replace'"!="" {
                	di as err "replace can only be specified when " /*
			*/ "using saving() option"
                	exit 198
        	}
	}

/* Check to see if final dataset will fit in memory. */

	quietly desc
	if r(N_max)-20 < `reps' {
		di as err "insufficient memory (observations)"
		exit 901
	}
	local version : display "version " string(_caller()) ", missing:"

	global S_1
	quietly `noisily' di _n as txt "Call to " as res "`prog'" as txt /*
	*/ " with ? query to initialize variable names" _n
	capture `noisily' `version' `prog' ? `args'
	if _rc {
		if _rc==199 {
			di as err "program `prog' not found or"
			di as err _quote "`prog' ?" _quote /*
*/ " attempted to execute an unrecognized command"
			exit 199
		}
		di as err _quote "`prog' ?" _quote " returned:"
		error _rc
	}

	if `"$S_1"'=="" {
		di as err _quote "`prog' ?" _quote " did not set \$S_1"
		exit 198
	}

	tempname sim
	postfile `sim' $S_1 using `"`saving'"', `double' `every' `replace'

	quietly {
		`noisily' di _n as res "`reps'" as txt " calls to " as res /*
		*/ "`prog'" as txt " to perform simulations" _n
		local i 1
		while `i' <= `reps' {
			`dots' di as txt "." _c
			`noisily' `version' `prog' `sim' `args'
			local i = `i' + 1
		}

		postclose `sim'
		`dots' di _n
		capture use `"`saving'"', clear
		if _rc {
			if _rc >= 900 & _rc <= 903 {
				di as err "insufficient memory to load " /*
				*/ "file with simulation results"
			}
			error _rc
		}
		if "`filetmp'"!="" { global S_FN }
	}
end
exit
