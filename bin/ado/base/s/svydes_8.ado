*! version 2.0.4  20feb2015
program define svydes_8, rclass sortpreserve
	version 8, missing

	syntax [varlist(numeric default=none)]	/*
	*/	[pweight iweight]		/*
	*/	[if] [in] [, BYPsu		/*
	*/	STRata(passthru)		/*
	*/	psu(passthru)			/*
	*/	fpc(passthru)			/*
	*/	]
/* Get weights, strata, psu and fpc. */

	quietly svyset [`weight'`exp'], `strata' `psu' `fpc'
	local strata `r(strata)'
	local psu `r(psu)'
	if "`psu'"=="" & "`bypsu'"!="" {
		di as err "bypsu requires a psu variable to be set"
		exit 100
	}
	local fpc `r(fpc)'
	local weight `r(wtype)'
	local exp `r(`weight')'

	local wtype `weight'
	if `"`wtype'"' == "" {
		local wtype pweight
	}
	di
	di as txt %-10s "`wtype':" _c
	if "`weight'" == "" {
		di "<none>"
	}
	else    di "`exp'"
	di as txt %-10s "Strata:" _c
	if "`strata'" == "" {
		di "<one>"
	}
	else    di "`strata'"
	di as txt %-10s "PSU:" _c
	if "`psu'" == "" {
		di "<observations>"
	}
	else    di "`psu'"
	if "`fpc'" != "" {
		di as txt %-10s "FPC:" "`fpc'"
	}

/* Mark/markout. */

	tempvar doit
	mark `doit' `wt' `if' `in', zeroweight
	markout `doit' `fpc'
	markout `doit' `strata' `psu', strok

	if "`varlist'"!="" {
		tempvar nm
		qui gen byte `nm' = `doit'
		markout `nm' `varlist'
	}

/* Compute saved results. */

	SetR "`strata'" "`psu'" `doit' `nm'
	local N      `r(N)'
	local N_miss `r(N_miss)'
	local N_str  `r(N_strata)'
	local N_psu  `r(N_psu)'
	local N_mpsu `r(N_mpsu)'
	return add

/* Produce display. */

	if "`bypsu'"!="" {
		ByPSU "`weight'" "`exp'" "`strata'" "`psu'" "`fpc'" /*
		*/ `N' `N_miss' `N_str' `N_psu' `doit' `nm'
	}
	else ByStrata "`weight'" "`exp'" "`strata'" "`psu'" "`fpc'" /*
	*/ `N' `N_miss' `N_str' `N_psu' `N_mpsu' `doit' `nm'
end

program define SetR, rclass
	args strata psu doit nm

	qui count if `doit'
	ret scalar N = r(N)

	if "`strata'"=="" {
		tempvar strata
		qui gen byte `strata' = 1
	}
	if "`psu'"=="" {
		tempvar psu
		qui gen `c(obs_t)' `psu' = _n
	}

	Ngroup `doit' `strata' `psu'
	ret scalar N_psu = r(N)
	Ngroup `doit' `strata'
	ret scalar N_strata = r(N)

	if "`nm'"!="" {
		qui count if `doit' & !`nm'
		ret scalar N_miss = r(N)
		Ngroup `nm' `strata' `psu'
		ret scalar N_mpsu = return(N_psu) - r(N)
		Ngroup `nm' `strata'
		ret scalar N_mstr = return(N_strata) - r(N)
		Nonepsu `strata' `psu' `nm'
		ret scalar N_onestr = r(N)
	}
	else {
		ret scalar N_miss = 0
		ret scalar N_mpsu = 0
		ret scalar N_mstr = 0
		Nonepsu `strata' `psu' `doit'
		ret scalar N_onestr = r(N)
	}
end

program define Ngroup
	gettoken doit 0 : 0
	sort `0'
	tempvar obs
	quietly {
		local obstype = c(obs_t)
		if "`obstype'" != "double" {
			local obstype "long"
		}
		by `0': gen `obstype' `obs' = cond(_n==_N, sum(`doit'), 0)
		count if `obs'
	}
end

program define Nonepsu
	args strata psu doit

	sort `doit' `strata' `psu'

	tempvar one
	quietly {
		by `doit' `strata' `psu': gen byte `one' = (_n==1) if `doit'
		by `doit' `strata': replace `one' = cond(_n==_N,sum(`one'),.) /*
		*/ if `doit'

		count if `one' == 1
	}
end

program define ByPSU
	args weight exp strata psu fpc N N_miss N_str N_psu doit nm

	quietly {

	/* Generate strata variable if there isn't one. */

		if "`strata'"=="" {
			tempvar strata
			gen byte `strata' = 1
			local fakestr 1
		}

	/* Sort. */

		sort `doit' `strata' `psu'

	/* Compute `miss' = #missing obs in each PSU. */

		if "`nm'"!="" {
			tempvar miss
			gen byte `miss' = !`nm'
			by `doit' `strata' `psu': replace `miss' = sum(`miss')
		}
		else {
			tempvar nm
			gen byte `nm' = `doit'
		}

	/* Compute `nm' = #nonmissing obs in each PSU. */

		by `doit' `strata' `psu': replace `nm' = cond( /*
		*/ _n==_N & `doit', sum(`nm'), .)

	/* Create `order' variable for listing results. */

		tempvar order
		gen `c(obs_t)' `order' = _n if `nm'<.
		sort `order'
	}

/* Display output. */

	if "`weight'"=="" {
		local weight "pweight"
	}

	if "`fakestr'"=="" {
		local strname "`strata'"
	}
	else	local strname "<one>"

	local cs =  1 + int((9 - udstrlen("`strname'"))/2)
	local cp = 11 + int((9 - udstrlen("`psu'"))/2)

	if "`miss'"!="" {
		di as txt _col(20) "#Obs with  #Obs with" _n /*
		*/ " Strata      PSU    complete   missing" _n /*
		*/ _col(`cs') "`strname'" _col(`cp') "`psu'" _col(23) /*
		*/ "data      data"
		local ndup  3
		local col  24
		local cont "_c"
	}
	else {
		di _n as txt " Strata      PSU" _n _col(`cs') "`strname'" /*
		*/ _col(`cp') "`psu'" _col(23) "#Obs"
		local ndup  2
		local col  19
		local not "*"
	}

	di in smcl as txt "{hline 8}" _dup(`ndup') "  {hline 8}"

	capture confirm string variable `strata'
	local strstr = _rc
	capture confirm string variable `psu'
	local psustr = _rc
	local i 1

	if `strstr' & `psustr' { /* both not strings */
		while `order'[`i']<. {
			di as res %8.0g `strata'[`i'] %10.0g `psu'[`i'] /*
			*/ %10.0f `nm'[`i'] `cont'
			`not' di as res %10.0f `miss'[`i']
			local i = `i' + 1
		}
	}
	else if !`strstr' & `psustr' { /* strata string, psu not string */
		while `order'[`i']<. {
			local dstrata = udsubstr(trim(`strata'[`i']),1,8)
			local cs = 9 - udstrlen("`dstrata'")
			di as res _col(`cs') "`dstrata'" %10.0g `psu'[`i'] /*
			*/ %10.0f `nm'[`i'] `cont'
			`not' di as res %10.0f `miss'[`i']
			local i = `i' + 1
		}
	}
	else if `strstr' & !`psustr' { /* strata not string, psu string */
		while `order'[`i']<. {
			local dpsu = udsubstr(trim(`psu'[`i']),1,8)
			local cp = 19 - udstrlen("`dpsu'")
			di as res %8.0g `strata'[`i'] _col(`cp') "`dpsu'" /*
			*/ %10.0f `nm'[`i'] `cont'
			`not' di as res %10.0f `miss'[`i']
			local i = `i' + 1
		}
	}
	else if !`strstr' & !`psustr' { /* both not strings */
		while `order'[`i']<. {
			local dstrata = udsubstr(trim(`strata'[`i']),1,8)
			local cs = 9 - udstrlen("`dstrata'")
			local dpsu = udsubstr(trim(`psu'[`i']),1,8)
			local cp = 19 - udstrlen("`dpsu'")
			di as res _col(`cs') "`dstrata'" _col(`cp') "`dpsu'" /*
			*/ %10.0f `nm'[`i'] `cont'
			`not' di as res %10.0f `miss'[`i']
			local i = `i' + 1
		}
	}

        di in smcl as txt "{hline 8}" _dup(`ndup') "  {hline 8}"

    	di as res %8.0f `N_str' %10.0f `N_psu' %10.0f `N'-`N_miss' `cont'

    	`not' di as res %10.0f `N_miss' _n in smcl as txt _col(21) "{hline 18}" /*
	*/ _n as res _col(`col') %10.0f `N'

	if _N > `N' {
		local count = ("`exp'"!="")+("`fakestr'"=="") /*
		*/ +("`psu'"!="")+("`fpc'"!="")
		if "`fpc'"!="" {
			if `count'>=2 {
				local fpc "or `fpc'"
			}
			local behind 1
		}
		else	local behind 0
		if "`psu'"!="" {
			if !`behind' & `count'>=2 {
				local psu "or `psu'"
			}
			else if `behind' & `count'>=3 {
				local psu "`psu', "
			}
			else if `behind' {
				local psu "`psu' "
			}
			local behind 1
		}
		if "`fakestr'"=="" {
			if !`behind' & `count'>=2 {
				local strname "or `strname'"
			}
			else if `behind' & `count'>=3 {
				local strname "`strname', "
			}
			else if `behind' {
				local strname "`strname' "
			}
		}
		else local strname
		if "`exp'"!="" & `count'>=3 {
			local exp "`exp',"
		}

		di in smcl as res _col(`col') %10.0f _N-`N' as txt /*
		*/ " = #Obs with missing `exp'" _n /*
		*/ _col(`col') "  {hline 8}   `strname'`psu'`fpc'" _n /*
		*/ as res _col(`col') %10.0f _N
	}
end

program define ByStrata, rclass
	args weight exp strata psu fpc N N_miss N_str N_psu N_mpsu doit nm

	tempvar onestr nhnm min max

	quietly {

	/* Generate PSU variable if there isn't one. */

		if "`psu'"=="" {
			tempvar psu
			gen `c(obs_t)' `psu' = _n
			local fakepsu 1
		}
		else local psuname "`psu'"

	/* Generate `nm' (nonmissing obs) if there is not one. */

		if "`nm'"=="" {
			tempvar nm
			gen byte `nm' = `doit'
		}
		else	local varlist 1

	/* Sort. */

		sort `doit' `strata' `psu' `nm'

	/* `nhnm' = #PSU in stratum h with at least some nonmissing obs. */

		by `doit' `strata' `psu': gen byte `nhnm' = (_n==_N & `nm')
		by `doit' `strata': replace `nhnm' = sum(`nhnm') if `doit'

		if "`varlist'"!="" {
			tempvar nhm miss

		/* `nhm' = #PSU in stratum h with all nonmissing obs. */

			by `doit' `strata' `psu': gen byte `nhm' = /*
			*/	(_n==_N & !`nm')

			count if `nhm' & `doit'
			local mpsu = r(N)

			by `doit' `strata': replace `nhm' = sum(`nhm')

		/* `miss' = #missing obs in stratum h. */

			gen byte `miss' = !`nm'
			by `doit' `strata': replace `miss' = sum(`miss')
		}

	/* `nm' = #nonmissing obs per PSU. */

		by `doit' `strata' `psu': replace `nm' = cond( /*
		*/	_n==_N & `nm' & `doit', sum(`nm'), .)

		summarize `nm'
		local strmin = r(min)
		local strmax = r(max)

	/* `min' = minimum #nonmissing obs per PSU. */

		local type : type `nm'
		gen `type' `min' = `nm'
		by `doit' `strata': replace `min' = cond(`min'<`min'[_n-1], /*
		*/	`min',`min'[_n-1])

	/* `max' = maximum #nonmissing obs per PSU. */

		gen `type' `max' = `nm'
		by `doit' `strata': replace `max' = cond( /*
		*/	(`max'>`max'[_n-1]&`max'<.)|`max'[_n-1]>=., /*
		*/	`max',`max'[_n-1])

	/* `nm' = #nonmissing obs in stratum h. */

		by `doit' `strata': replace `nm' = sum(`nm')

	/* Create new strata variable for listing results. */

		by `doit' `strata': gen byte `onestr' = 1 if _n==_N & `doit'

		replace `onestr' = sum(`onestr') if `onestr'==1

		sort `onestr'
	}

/* Display output. */

	if "`weight'"=="" {
		local weight "pweight"
	}

	if "`strata'"!="" {
		local strname "`strata'"
	}
	else	local strname "<one>"

	if "`fakepsu'"=="" {
		local psuname "`psu'"
	}

	local cs = 1 + int((9 - udstrlen("`strname'"))/2)

	if "`varlist'"!="" {
		di in smcl as txt _col(30) "#Obs with  #Obs with" _col(55) /*
		*/ "#Obs per included PSU" _n /*
		*/ " Strata     #PSUs     #PSUs   complete   missing" /*
		*/ _col(51) "{hline 28}" _n _col(`cs') "`strname'" /*
		*/ _col(11) "included   omitted    data      data" /*
		*/ "       min      mean       max"
		local ndup  7
		local col  34
	}
	else {
		di in smcl as txt _col(39) "#Obs per PSU" _n /*
		*/ " Strata" _col(31) "{hline 28}" _n _col(`cs') "`strname'" /*
		*/ _col(13) "#PSUs     #Obs       min      mean       max"
		local ndup  5
		local col  19
		local skipn "_n"
		local not "*"
	}

	di in smcl as txt "{hline 8}" _dup(`ndup') "  {hline 8}"


	local i 1
	capture confirm string variable `strata'
	if _rc { /* strata not a string variable */
		while `onestr'[`i']<. {
			if `nhnm'[`i']==1 {
				local star "*"
			}
			else local star " "

			di as res %8.0g `strata'[`i'] %10.0f `nhnm'[`i'] /*
			*/ as txt "`star'" _c
			`not' di as res %9.0f `nhm'[`i'] " " _c
			di as res %9.0f `nm'[`i'] _c
			`not' di as res %10.0f `miss'[`i'] _c
			di as res %10.0f `min'[`i'] %10.1f /*
			*/ `nm'[`i']/`nhnm'[`i'] %10.0f `max'[`i']
			local i = `i' + 1
		}
	}
	else { /* strata is a string variable */
		while `onestr'[`i']<. {
			if `nhnm'[`i']==1 {
				local star "*"
			}
			else local star " "
			local dstrata = udsubstr(trim(`strata'[`i']),1,8)
			local cs = 9 - udstrlen("`dstrata'")

			di as res _col(`cs') "`dstrata'" %10.0f `nhnm'[`i'] /*
			*/ as txt "`star'" _c
			`not' di as res %9.0f `nhm'[`i'] " " _c
			di as res %9.0f `nm'[`i'] _c
			`not' di as res %10.0f `miss'[`i'] _c
			di as res %10.0f `min'[`i'] %10.1f /*
			*/ `nm'[`i']/`nhnm'[`i'] %10.0f `max'[`i']
			local i = `i' + 1
		}
	}

	di in smcl as txt "{hline 8}" _dup(`ndup') "  {hline 8}"

    	di as res %8.0f `N_str' %10.0f `N_psu'-`N_mpsu' _c
	`not' di as res %10.0f `N_mpsu' _c
	di as res %10.0f `N'-`N_miss' _c
    	`not' di as res %10.0f `N_miss' _c
	di as res %10.0f `strmin' %10.1f (`N'-`N_miss')/(`N_psu'-`N_mpsu') /*
	*/ %10.0f `strmax'

	`not' di in smcl as txt _col(31) "{hline 18}" _n as res _col(`col') %10.0f `N'

	if _N > `N' {
		local count = ("`exp'"!="")+("`strata'"!="") /*
		*/ +("`psuname'"!="")+("`fpc'"!="")
		if "`fpc'"!="" {
			if `count'>=2 {
				local fpc "or `fpc'"
			}
			local behind 1
		}
		else	local behind 0
		if "`psuname'"!="" {
			if !`behind' & `count'>=2 {
				local psuname "or `psuname'"
			}
			else if `behind' & `count'>=3 {
				local psuname "`psuname', "
			}
			else if `behind' {
				local psuname "`psuname' "
			}
			local behind 1
		}
		if "`strata'"!="" {
			if !`behind' & `count'>=2 {
				local strata "or `strata'"
			}
			else if `behind' & `count'>=3 {
				local strata "`strata', "
			}
			else if `behind' {
				local strata "`strata' "
			}
		}
		if "`exp'"!="" & `count'>=3 {
			local exp "`exp',"
		}

		di `skipn' in smcl as res _col(`col') %10.0f _N-`N' as txt /*
		*/ " = #Obs with missing `exp'" _n /*
		*/ _col(`col') "  {hline 8}   `strata'`psuname'`fpc'" _n /*
		*/ as res _col(`col') %10.0f _N
	}
end
