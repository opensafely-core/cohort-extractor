*! version 8.0.19  16feb2015
program jknife_8, rclass sortpreserve
	version 8, missing
	local version : di string(_caller())
	local vv : di "version `version', missing:"

	/* version control */
	if _caller()<=6 {
		jknife_6 `0'
		exit
	}

	set more off

	return clear			/* makes r(N) valid after _cmdxel */
	_cmdxel cmd names exp val K 0 : jk new jknife "`version'" `0'
	local RN = r(N)
	local cmdif `s(cmdif)'
	local cmdin `s(cmdin)'
	local cmdnoif `s(cmdnoif)'
	local keepesample `s(keep)'
	/* ignore s(warn) since it is never needed by -jknife- */
	forvalues i = 1/`K' {
		local name`i' : word `i' of `names'
	}
	/* Stuff in `0', if anything, should be options. */
	#delimit ;
	syntax [if] [in] [,
		Dots
		Eclass
		KEEP
		Level(cilevel)
		N(string)
		Rclass
		/* cluster opts */
		CLuster(varlist)
		IDcluster(string)
		/* _cmdxel options */
		nocheck
		noesample
		noheader		/* undocumented */
		NOIsily
		TRace
		nowarn
		] ;
	#delimit cr

	if "`trace'" != "" {
		local noisily noisily
		local traceon	set trace on
		local traceoff	set trace off
	}
	if "`check'" != "" {
		di as error "`check' invalid"
		exit 198
	}
	if "`warn'" != "" {
		di as error "`warn' invalid"
		exit 198
	}
	local nfunc `"`n'"'
	local dots = cond("`dots'" == "" | "`noisily'" != "", "*", "noisily")
	local noi = cond("`noisily'"=="", "*", "noisily")

	/* check options */
	if `"`keep'"' != "" {
		confirm new var `names'
	}
	if `"`idcluster'"' != "" {
		if `"`cluster'"' == "" | `"`keep'"' == "" {
			di as err /*
*/ "idcluster() can only be specified with cluster() and keep options"
			exit 198
		}
	}
	if ("`eclass'" != "") + ("`rclass'" != "") + (`"`nfunc'"' != "")>1 {
		di as err /*
*/ "options rclass, eclass, and n() are mutually exclusive"
		exit 198
	}
	if "`rclass'" != "" {
		local nfunc "r(N)"
	}
	else if "`eclass'" != "" {
		local nfunc "e(N)"
	}

	/* finish opening display */
	if `"`nfunc'"' != "" {
		di as txt  `"n():          `nfunc'"'
	}
	else {
		di as txt  `"n():          (not specified)"' /*
		*/ `"  <-- we strongly recommend that you specify"'
		di as txt _col(35) "the " as res "rclass" as txt ", " /*
		*/ as res "eclass" as txt ", or " as res "n()" as txt " option"
	}

	/* keep only the estimation sample */
	if `"`esample'"' != "noesample" {
		if "`keep'" == "" {
			preserve
			`keepesample'
		}
		else {
			if `"`keepesample'"' != "" {
				local ornotesample | (! e(sample))
			}
		}
	}

	/* mark sample: -cmdif- and -cmdin- from -_cmdxel- are complete */
	tempvar touse
	mark `touse' `cmdif' `cmdin'
	qui replace `touse' = 2 if `touse' == 0	`ornotesample' /* sic */
	qui count if `touse' == 1
	local touseN = r(N)
	/* sort observation to use */
	local sortvars : sortedby		/* to later restore */
	tempvar order
	qui gen `c(obs_t)' `order' = _n
	sort `touse' `order'
	qui replace `order' = _n	/* allow us to restore original sort */

	/* check statistics */
	tempname N

	local prob 0
	/* sample size function */
	if `"`nfunc'"' != "" {
		if `"`nfunc'"' == "r(N)" {
			capture scalar `N' = `RN'
		}
		else	capture scalar `N' = int(`nfunc')
		if _rc {
			di as err
			di as err `"syntax error in n():  `nfunc'"'
			di as err
			di as err `"-> display `nfunc'"'
			display (`nfunc')
			error _rc
		}
		if missing(`N') | `N' == 0 {
			local zm = cond(missing(`N'),"missing","zero")
			di as err /*
*/ `"number of obs. `nfunc' evaluated to `zm' in full sample"'
			local prob 1
		}
	}
	else 	scalar `N' = `touseN'

	tempvar cflag clid
	/* check clusters */
	if "`cluster'" != "" {
		foreach clname of local cluster {
			capture assert ! missing(`clname') if `touse' == 1
			if _rc {
				di as err /*
*/ "missing values in cluster variable `clname' not allowed"
				local prob 1
			}
		}
		sort `touse' `cluster'
		quietly by `touse' `cluster': /*
			*/ gen `cflag' = (_n == 1) if `touse' == 1
		quietly sum `cflag' if `touse' == 1
		/* total number of clusters */
		local nclust = r(sum)
		quietly gen `clid' = sum(`cflag') if `touse' == 1
	}
	else {
		local nclust = max(`N',`touseN')
		qui gen `cflag' = 1
		local clid `order'
	}
	forval i = 1/`K' {
		if missing(`val`i'') {
			di as err /*
*/ `"statistic `exp`i'' evaluated to missing in full sample"'
			local prob 1
		}
	}
	if `prob' {
		exit 459
	}

	/* jackknife */
	forval i = 1/`K' {
		tempvar tv`i'
		qui gen double `tv`i'' = .
		local pseudo `pseudo' `tv`i''
	}

	`noi' di _n as res "`touseN'" /*
	*/ as txt " jackknife calls to (" /*
	*/ as inp `"`cmd'"' /*
	*/ as txt "):" _n 
	`noi' gettoken cmdonly : cmdnoif
	tempvar keepval
	gen `keepval' = 0
	if `"`sortvars'"' != "" {
		sort `sortvars'
	}
	forval j = 1/`nclust' {
		`dots' di as txt "." _c
		`noi' di as inp `". `cmd'"'
		`traceon'
		cap `noisily' `vv' `cmdnoif' if `clid' != `j' & `touse' == 1
		`traceoff'
		if _rc {
			`noi' di in smcl as error /*
*/ `"{p 0 0 2}captured error running (`cmd'), posting missing values{p_end}"'
		}
		else {
			forval i = 1/`K' {
				cap replace `tv`i'' = `exp`i'' /*
				*/ if `clid' == `j'
				if _rc {
				`noi' di in smcl as error /*
*/ `"{p 0 0 2}captured error in `exp`i'', posting missing value{p_end}"'
					qui replace `tv`i'' = . /*
						*/ if `clid' == `j'
				}
			}
			if `"`nfunc'"' != "" {
				local nn = int(`nfunc')
				qui count if `clid' == `j' & `touse' == 1
				/* keep the value */
				if `nn' == `N'-r(N) {
					qui replace `keepval' = 1 /*
						*/ if `clid' == `j'
				}
			}
			else {
				qui replace `keepval' = 1 if `clid' == `j'
			}
		}
	}
	`dots' di _n

	/* pseudovalues */
	tempname psuse nreps
	mark `psuse' if `cflag' & `keepval'
	markout `psuse' `pseudo'
	quietly count if `psuse'
	scalar `nreps' = r(N)
	forval i = 1/`K' {
		quietly replace `tv`i'' = . if ! (`cflag' & `keepval')
		quietly replace `tv`i'' = `nreps'*(`val`i''-`tv`i'')+`tv`i''
	}

	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces ""
	if `cil' == 2 {
		local spaces "   "
	}
	else if `cil' == 4 {
		local spaces " "
	}
	/* display output and save results */
	#delimit ;
	di in smcl as txt _n
`"Variable            {c |}     Obs    Statistic    Std. Err. `spaces'[`=strsubdp("`level'")'% Conf. Interval]"' _n 
	"{hline 20}{c +}{hline 58}" ;
	#delimit cr

	forval i = 1/`K' {
		quietly count if `tv`i'' < .
		ret scalar N`i' = r(N)
		ret scalar stat`i' = `val`i''
		di in smcl as txt abbrev("`name`i''", 12) _col(21) "{c |}"
		di in smcl as txt "            overall {c |}" as res %8.0f /*
			*/ return(N`i') /*
			*/ _col(34) %9.0g return(stat`i')
		quietly ci `tv`i'', level(`level')
		ret scalar mean`i' = r(mean)
		ret scalar se`i'   = r(se)
		di in smcl as txt "             jknife {c |}" as res /*
		 	*/ _col(34) %9.0g return(mean`i') /*
		 	*/ _col(46) %9.0g return(se`i') /*
		 	*/ _col(58) %9.0g r(lb) /*
		 	*/ _col(70) %9.0g r(ub)
	}

	return local names `names'
	if `"`cluster'"' != "" {
		return scalar N_clust = `nclust'
	}
	if "`keep'" == "" {
		exit
	}

	forval i = 1/`K' {
		local label = usubstr(`"`exp`i''"',1,65)
		label var `tv`i'' `"`label' pseudovalues"'
		rename `tv`i'' `name`i''
	}

	if "`idcluster'" != "" {
		capture confirm new variable `idcluster'
		if _rc {
			confirm variable `idcluster'
			drop `idcluster'
		}
		rename `clid' `idcluster'
	}
end
exit
