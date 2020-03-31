*! version 2.3.8  13feb2015  
program define bstrap_7
	version 7, missing
	local version : di "version " string(_caller()) ", missing:"

/* Parse. */

	gettoken prog 0: 0, parse(" ,")
	if `"`prog'"'=="" | bsubstr(`"`prog'"',1,1)=="," {
		di as err "program name required"
		exit 198
	}

	syntax [, ARgs(str) Reps(int 50) SIze(int -9) Dots CLuster(varlist) /*
		*/ IDcluster(str) Level(cilevel) SAving(str) /*
		*/ DOUBle EVery(passthru) REPLACE noADjust LEAVE NOIsily ]

/* Check options. */

	if `size' == -9 { local size }
	else if `size' < 1 {
		di as err "size() invalid"
		exit 198
	}

	if `"`idcluster'"'!="" & `"`cluster'"'=="" {
		di as err "idcluster() can only be specified with " /*
		*/ "cluster() option"
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

/* Initialization.  User program is called before preserve in case initializer
   wants to load some data set.
*/
	if `"`prog'"'!="_BS" {
		global S_1
		local toprog `""to " as res "`prog' ""'
		quietly `noisily' di _n as txt "Call " `toprog' /*
		*/ as txt "with ? query to initialize variable names" _n
		capture `noisily' `version' `prog' ? `args'
		if _rc {
			if _rc==1 { error 1 }
			if _rc==199 {
				di as err `"program `prog' not found or"'
				di as err `""`prog' ?""' /*
				*/ `" attempted to execute an unrecognized"' /*
				*/ `" command"'
				exit 199
			}
			di as err `""`prog' ?" returned:"'
			error _rc
		}
		if `"$S_1"'=="" {
			di as err `""`prog' ?" did not set \$S_1"'
			exit 198
		}
		local vl `"$S_1"'
	}
	else {
		local vl `"$S_bs_vl"'
		global S_bs_noi "`noisily'"
	}

/* If clusters, count number.  Display #clusters or #obs and check size. */

	if "`cluster'"!="" {
		tempvar flag
		sort `cluster'
		quietly by `cluster': gen byte `flag' = (_n==1)
		quietly count if `flag'
		local nclust = r(N)
		di as txt "(clusters=" `nclust' ")"
		if "`size'"!="" {
			if `size' > `nclust' {
				di as err "size() must not be greater than " /*
				*/ "number of clusters"
				exit 498
			}
		}
	}
	else {
		di as txt "(obs=" _N ")"
		if "`size'"!="" {
			if `size' > _N {
				di as err "size() must not be greater than " /*
				*/ "number of observations"
				exit 498
			}
			else if `size' == _N { local size }
				/* bsample prefers call without arguments */
		}
	}

/* Preserve and initialize post. */

	preserve
	tempname postnam

	postfile `postnam' `vl' using `"`saving'"', `double' `every' `replace'

/* Do reps. */

	quietly {
		if `"`idcluster'"'!="" {
			capture confirm new variable `idcluster'
			if _rc == 0 {
				replace `flag' = sum(`flag')
				label variable `flag' /*
				*/ "Bootstrap sample cluster id"
				rename `flag' `idcluster'
			}
			else confirm variable `idcluster'

			local idopt "id(`idcluster')"
		}
		`noisily' di _n as txt "First call " `toprog' /*
		*/ as txt "with dataset as is:" _n
		`noisily' `version' `prog' `postnam' `args'
		`noisily' di _n as res "`reps'" as txt " calls " `toprog' /*
		*/ as txt "with bootstrap samples:" _n
		local i 1
		while `i' <= `reps' {
			`dots' di as txt "." _c
			restore, preserve

			if "`cluster'"=="" {
				bsample `size'
			}
			else {
				bsample `size', cluster(`cluster') `idopt'
			}
			`noisily' `version' `prog' `postnam' `args'
			local i = `i' + 1
		}
		`dots' di
		postclose `postnam'

/* Load file `saving' with bootstrap results. */

		capture use `"`saving'"', clear
		if _rc {
			if _rc >= 900 & _rc <= 903 {
				di as err "insufficient memory to load " /*
				*/ "file with bootstrap results"
			}
			error _rc
		}

		if `"`prog'"'=="_BS" {
			local x = trim(`"bs: $S_bs_cmd"')
			label data `"`x'"'
		}
		else {
			if "`cluster'"=="" { label data `"`prog' bootstrap"' }
			else 	label data `"`prog' clustered bootstrap"'
		}

		tokenize `"`vl'"'
		local i 1
		while `"``i''"'!="" {
			local x = ``i''[1]
			char ``i''[bstrap] `x'
			if `"`prog'"'=="_BS" & `"`filetmp'"'=="" {
				local varlab : word `i' of $S_bs_lab
				label variable ``i'' `"`varlab'"'
			}
			local i = `i' + 1
		}
		drop in 1

		if `"`filetmp'"'=="" { quietly save `"`saving'"', replace }
	}
	if "`leave'"!="" {
		global S_FN
		restore, not
	}

	bstat_7, level(`level')
end

program define _BS /* program called by bs.ado */
	version 7, missing	/* sic, do not erase */

	local n : word count $S_bs_vl /* number of values to post */

	if "$S_bs_noi"!="" {
		di as inp `". $S_bs_cmd"'
	}
	capture $S_bs_noi $S_bs_ver $S_bs_cmd /* run command */
	if _rc {
		if _rc == 1 { error 1 }
		local k 1
		while `k' <= `n' {
			local stats "`stats' (.)"
			local k = `k' + 1
		}
	}
	else {
		local slist $S_bs_st
		local k 1
		while `k' <= `n' {
			gettoken stat slist : slist, match(junk)
			SubMacro `stat'
			tempname x
			capture scalar `x' = `s(stat)'
			if _rc {
				if _rc == 1 { error 1 }
				scalar `x' = .
			}
			local stats "`stats' (`x')"
			local k = `k' + 1
		}
	}

	post `1' `stats'

	if "$S_bs_noi"!="" { di /* blank line */ }
end

program define SubMacro, sclass
	sret clear
	local i = index(`"`0'"',`"S_"')
	local n = length(`"`0'"')
	local j 1
	while `i' != 0 & `j' <= `n' {
		local front = bsubstr(`"`0'"',1,`i'-1)
		local back  = bsubstr(`"`0'"',`i',.)
		local 0 `"`front'$`back'"'
		local i = index(`"`0'"',`"S_"')
		local j = `j' + 1 /* prevents infinite loop if error */
	}
	sret local stat `0'
end
