*! version 2.4.2  20feb2015
program svydescribe, sortpreserve
	if _caller() < 9 {
		svydes_8 `0'
		exit
	}
	SvyDes `0'
end

program SvyDes, rclass
	version 9

	syntax [varlist(numeric default=none)]	///
		[if] [in] [,			///
			stage(integer 0)	///
			FINALstage		///
			GENerate(name)		///
			SINGLE			///
		]

	if `"`generate'"' != "" {
		confirm new var `generate'
	}

	// stage() and finalstage are mutually exclusive options
	if `stage' > 1 & "`finalstage'" != "" {
		opts_exclusive "stage() finalstage"
	}
	if "`finalstage'" != "" & "`single'" != "" {
		opts_exclusive "single finalstage"
	}
	if "`finalstage'" != "" & "`generate'" != "" {
		opts_exclusive "generate() finalstage"
	}

	if `stage' < 0 {
		di as err "option stage() requires a positive integer value"
		exit 198
	}

	// survey design information
	tempvar touse nm
	mark `touse' `if' `in'
	quietly _svy_setup `touse' `nm', svy
	if `stage' > r(stages) {
		if r(stages) == 1 {
			local msg "is 1 stage"
		}
		else	local msg "are `r(stages)' stages"
		di as err ///
"there `msg' currently svyset, stage(`stage') is too large"
		exit 198
	}
	if !missing(r(stages)) {
		local stages = r(stages)
	}
	else	local stages 0
	// look for variables set in more than one stage or as both strata and
	// sampling unit identifiers
	forval i = 1/`stages' {
		local dup `dup' `r(strata`i')' `r(su`i')'
	}
	local dup : list dups dup
	if `"`dup'"' != "" {
		gettoken dup : dup
		di as err ///
"variable `dup' specified more than once as a survey design characteristic"
		exit 198
	}
	if "`finalstage'" != "" {
		local stage `stages'
	}
	else if `stage' == 0 {
		local stage 1
	}
	local sm1 = `stage' - 1
	forval i = 1/`sm1' {
		local strata `strata' `r(strata`i')' `r(su`i')'
	}
	local str_i	`r(strata`stage')'
	local su_i	`r(su`stage')'
	local fpc	`r(fpc`stage')'

	if "`finalstage'" == "" {
		if "`su_i'" == "" & `stage' > 1 {
			di as err ///
"stage(`stage') requires a sampling unit variable to be svyset for stage `stage'"
			exit 198
		}
		if "`single'" == "" {
			local units "stage `stage' sampling units"
		}
		else	local units ///
		"strata with a single sampling unit in stage `stage'"
	}
	else {
		if "`su_i'" == "" {
			if `stage' <= 1 {
				di as err ///
"option finalstage requires a PSU variable to be svyset"
				exit 198
			}
			local sm1 = `stage' - 1
			local strata : list strata - str_i
			local str_i `r(strata`sm1')'
			local su_i `r(su`sm1')'
			local strata : list strata - str_i
			local strata : list strata - su_i
		}
		if "`single'" == "" {
			local units "final stage sampling units"
		}
		else	local units ///
		"strata with a single sampling unit in the final sampling stage"
	}
	di
	di as txt "Survey: Describing `units'"
	svyset
	di

	if "`varlist'" != "" {
		markout `nm' `varlist'
	}
	else {
		drop `nm'
		local nm
	}

	// saved results
	SetR "`strata'" "`str_i'" "`su_i'" `touse' "`generate'" `nm'
	local N      `r(N)'
	local N_miss `r(N_miss)'
	local N_str  `r(N_strata)'
	local N_single  `r(N_single)'
	local N_units  `r(N_units)'
	local N_munits `r(N_munits)'
	return add

	// display results
	if "`finalstage'" != "" {
		ByU	"`strata'"	///
			"`str_i'"	///
			"`su_i'"	///
			"`fpc'"		///
			`N'		///
			`N_miss'	///
			`N_str'		///
			`N_units'	///
			`touse'		///
			`nm'
	}
	else {
		ByS	"`strata'"	///
			"`str_i'"	///
			"`su_i'"	///
			"`fpc'"		///
			"`single'"	///
			`N'		///
			`N_miss'	///
			`N_str'		///
			`N_single'	///
			`N_units'	///
			`N_munits'	///
			`touse'		///
			`nm'
	}

end

program SetR, rclass
	args strata str_i su_i touse gen nm

	// Note: `strata' could contain a varlist or be empty

	qui count if `touse'
	return scalar N = r(N)

	if "`str_i'" == "" {
		tempvar str_i
		qui gen byte `str_i' = 1
	}
	if "`su_i'" == "" {
		tempvar su_i
		qui gen `c(obs_t)' `su_i' = _n
	}

	Ngroup `touse' `strata' `str_i' `su_i'
	return scalar N_units = r(N)
	Ngroup `touse' `strata' `str_i'
	return scalar N_strata = r(N)

	if "`nm'" != "" {
		qui count if `touse' & !`nm'
		return scalar N_miss = r(N)
		Ngroup `nm' `strata' `str_i' `su_i'
		return scalar N_munits = return(N_units) - r(N)
		Ngroup `nm' `strata' `str_i'
		return scalar N_mstrata = return(N_strata) - r(N)
		NoneUnit "`strata'" `str_i' `su_i' `nm' "`gen'"
		return scalar N_single = r(N)
	}
	else {
		return scalar N_miss = 0
		return scalar N_munits = 0
		return scalar N_mstrata = 0
		NoneUnit "`strata'" `str_i' `su_i' `touse' "`gen'"
		return scalar N_single = r(N)
	}
end

program Ngroup
	gettoken touse 0 : 0
	tempvar obs
	sort `0'

quietly {

	local obstype = c(obs_t)
	if "`obstype'" != "double" {
		local obstype "long"
	}
	by `0': gen `obstype' `obs' = cond(_n==_N, sum(`touse'), 0)
	count if `obs'

}

end

program NoneUnit
	args strata str_i su_i touse gen
	tempvar one
	sort `touse' `strata' `str_i' `su_i'

quietly {

	by `touse' `strata' `str_i' `su_i': ///
		gen byte `one' = (_n==1) if `touse'
	by `touse' `strata' `str_i': ///
		replace `one' = cond(_n==_N,sum(`one'),.) if `touse'

	count if `one' == 1

	if "`gen'" != "" {
		by `touse' `strata' `str_i': ///
			replace `one' = `one'[_N] == 1 if `touse'
		rename `one' `gen'
		label var `gen' "indicates strata with 1 sampling unit"
	}

}

end

program ByU
	args	strata	///
		str_i	///
		su_i	///
		fpc	///
		N	///
		N_miss	///
		N_str	///
		N_psu	///
		touse	///
		nm

quietly {

	// generate str_i variable if there isn't one.

	if "`str_i'" == "" {
		tempvar str_i
		if "`strata'" != "" {
			sort `touse' `strata'
			by `touse' `strata': gen `str_i' = _n==1 if `touse'
			quietly replace `str_i' = sum(`str_i')
		}
		else	gen byte `str_i' = 1
		local fakestr 1
	}

	sort `touse' `strata' `str_i' `su_i'

	// Compute `miss' = #missing obs in each PSU.

	if "`nm'" != "" {
		tempvar miss
		gen byte `miss' = !`nm'
		by `touse' `strata' `str_i' `su_i': ///
			replace `miss' = sum(`miss')
	}
	else {
		tempvar nm
		gen byte `nm' = `touse'
	}

	// Compute `nm' = #nonmissing obs in each PSU.

	by `touse' `strata' `str_i' `su_i': ///
		replace `nm' = cond(_n==_N & `touse', sum(`nm'), .)

	// Create `order' variable for listing results.

	tempvar order
	gen `c(obs_t)' `order' = _n if `nm'<.
	sort `order'

}

	// Display output.

	if "`fakestr'" == "" {
		local strname "`str_i'"
	}
	else	local strname "<one>"

	local cs =  1 + int((9 - udstrlen("`strname'"))/2)
	local cp = 11 + int((9 - udstrlen("`su_i'"))/2)

	if "`miss'" != "" {
		di as txt					///
			_col(20) "#Obs with  #Obs with" _n	///
			_col(21)				///
			%~8s "complete" _s(2)			///
			%~8s "missing" _s(2) _n			///
			%~8s "Stratum" _s(2)			///
			%~8s "Unit" _s(2)			///
			%~8s "data" _s(2)			///
			%~8s "data"
		local ndup  3
		local col  24
		local cont "_c"
	}
	else {
		di as txt			///
			%~8s "Stratum" _s(2)	///
			%~8s "Unit" _s(2)	///
			%~8s "#Obs"
		local ndup  2
		local col  19
		local not "*"
	}

	di in smcl as txt "{hline 8}" _dup(`ndup') "  {hline 8}"

	capture confirm string variable `str_i'
	local strstr = _rc
	capture confirm string variable `su_i'
	local psustr = _rc
	local i 1

	if `strstr' & `psustr' { // both not strings
		while `order'[`i']<. {
			di as res				///
				%8.0g `str_i'[`i']		///
				%10.0g `su_i'[`i']		///
				%10.0fc `nm'[`i'] `cont'
			`not' di as res %10.0fc `miss'[`i']
			local i = `i' + 1
		}
	}
	else if !`strstr' & `psustr' { // str_i string, su_i not string
		while `order'[`i']<. {
			local dstr_i = udsubstr(trim(`str_i'[`i']),1,8)
			di as res				///
				%8s "`dstr_i'"			///
				%10.0g `su_i'[`i']		///
				%10.0fc `nm'[`i'] `cont'
			`not' di as res %10.0fc `miss'[`i']
			local i = `i' + 1
		}
	}
	else if `strstr' & !`psustr' { // str_i not string, su_i string
		while `order'[`i']<. {
			local dpsu = udsubstr(trim(`su_i'[`i']),1,8)
			local cp = 19 - udstrlen("`dpsu'")
			di as res				///
				%8.0g `str_i'[`i'] _s(2)	///
				%8s "`dpsu'"			///
				%10.0fc `nm'[`i'] `cont'
			`not' di as res %10.0fc `miss'[`i']
			local i = `i' + 1
		}
	}
	else if !`strstr' & !`psustr' { // both strings
		while `order'[`i']<. {
			local dstr_i = udsubstr(trim(`str_i'[`i']),1,8)
			local dpsu = udsubstr(trim(`su_i'[`i']),1,8)
			di as res				///
				%8s "`dstr_i'" _s(2)		///
				%8s "`dpsu'"			///
				%10.0fc `nm'[`i'] `cont'
			`not' di as res %10.0fc `miss'[`i']
			local i = `i' + 1
		}
	}

        di in smcl as txt "{hline 8}" _dup(`ndup') "  {hline 8}"

    	di as res %8.0fc `N_str' %10.0fc `N_psu' %10.0fc `N'-`N_miss' `cont'

    	`not' di as res				///
		%10.0fc `N_miss'			///
		_n as txt _col(21) "{hline 18}"	///
		_n as res _col(`col') %10.0fc `N'

	if _N > `N' {
		di as res _col(`col')				///
			%10.0fc _N-`N' as txt			///
			" = #Obs with missing values in the"	///
			_n _col(`col')				///
			"  {hline 8}   survey characteristics"	///
			_n as res _col(`col') %10.0fc _N
	}
end

program ByS
	args	strata		///
		str_i		///
		su_i		///
		fpc		///
		single		///
		N		///
		N_miss		///
		N_str		///
		N_single	///
		N_psu		///
		N_mpsu		///
		touse		///
		nm

	tempvar onestr nhnm min max

quietly {

	// Generate PSU variable if there isn't one.

	if "`su_i'" == "" {
		tempvar su_i
		gen `c(obs_t)' `su_i' = _n
		local fakepsu 1
	}
	else local psuname "`su_i'"

	// Generate `nm' (nonmissing obs) if there is not one.

	if "`nm'" == "" {
		tempvar nm
		gen byte `nm' = `touse'
	}
	else	local varlist 1

	sort `touse' `strata' `str_i' `su_i' `nm'

	// `nhnm' = #PSU in stratum h with at least some nonmissing obs.

	by `touse' `strata' `str_i' `su_i': ///
		gen byte `nhnm' = (_n==_N & `nm')
	by `touse' `strata' `str_i': ///
		replace `nhnm' = sum(`nhnm') if `touse'

	if "`varlist'" != "" {
		tempvar nhm miss

		// `nhm' = #PSU in stratum h with all nonmissing obs.

		by `touse' `strata' `str_i' `su_i': ///
			gen byte `nhm' = (_n==_N & !`nm')

		count if `nhm' & `touse'
		local mpsu = r(N)

		by `touse' `strata' `str_i': ///
			replace `nhm' = sum(`nhm')

	// `miss' = #missing obs in stratum h.

		gen byte `miss' = !`nm'
		by `touse' `strata' `str_i': ///
			replace `miss' = sum(`miss')
	}

	// `nm' = #nonmissing obs per PSU.

	by `touse' `strata' `str_i' `su_i': ///
		replace `nm' = cond(_n==_N & `nm' & `touse', sum(`nm'), .)

	summarize `nm'
	local strmin = r(min)
	local strmax = r(max)

	// `min' = minimum #nonmissing obs per PSU.

	local type : type `nm'
	gen `type' `min' = `nm'
	by `touse' `strata' `str_i': ///
		replace `min' = cond(`min'<`min'[_n-1],`min',`min'[_n-1])

	// `max' = maximum #nonmissing obs per PSU.

	gen `type' `max' = `nm'
	by `touse' `strata' `str_i': ///
		replace `max' = cond((`max'>`max'[_n-1] & `max'<.) ///
			| `max'[_n-1]>=.,`max',`max'[_n-1])

	// `nm' = #nonmissing obs in stratum h.

	by `touse' `strata' `str_i': replace `nm' = sum(`nm')

	// Create new str_i variable for listing results.

	by `touse' `strata' `str_i': gen byte `onestr' = 1 if _n==_N & `touse'

	replace `onestr' = sum(`onestr') if `onestr' == 1

	sort `onestr'

}

	// Display output.

	if "`str_i'" != "" {
		local strname "`str_i'"
	}
	else	local strname "<one>"

	if "`fakepsu'" == "" {
		local psuname "`su_i'"
	}

	local cs = 1 + int((9 - udstrlen("`strname'"))/2)

	// Display table header.

	if "`varlist'" != "" {
		di as txt					///
			_col(30) "#Obs with  #Obs with"		///
			_col(55) "#Obs per included Unit"	///
			_n _col(11)				///
			%~8s "#Units" _s(2)			///
			%~8s "#Units" _s(2)			///
			%~8s "complete" _s(2)			///
			%~8s "missing" _s(2)			///
			_col(51) "{hline 28}" _n		///
			%~8s "Stratum" _s(2)			///
			%~8s "included" _s(2)			///
			%~8s "omitted" _s(2)			///
			%~8s "data" _s(2)			///
			%~8s "data" _s(2)			///
			%~8s "min" _s(2)			///
			%~8s "mean" _s(2)			///
			%~8s "max"
		local ndup  7
		local col  34
	}
	else {
		di as txt					///
			_col(39) "#Obs per Unit" _n		///
			_col(31) "{hline 28}" _n		///
			%~8s "Stratum" _s(2)			///
			%~8s "#Units" _s(2)			///
			%~8s "#Obs" _s(2)			///
			%~8s "min" _s(2)			///
			%~8s "mean" _s(2)			///
			%~8s "max"
		local ndup  5
		local col  19
		local skipn "_n"
		local not "*"
	}

	di in smcl as txt "{hline 8}" _dup(`ndup') "  {hline 8}"


	local i 1
	capture confirm string variable `str_i'
	if _rc {			// str_i not a string variable
		while `onestr'[`i']<. {
			if `nhnm'[`i'] == 1 {
				local star "*"
			}
			else {
				local star " "
				if "`single'" != "" {
					local ++i
					continue
				}
			}

			di as res				///
				%8.0g `str_i'[`i']		///
				%10.0fc `nhnm'[`i']		///
				as txt "`star'" _c
			`not' di as res %9.0fc `nhm'[`i'] " " _c
			di as res %9.0fc `nm'[`i'] _c
			`not' di as res %10.0fc `miss'[`i'] _c
			if `nhnm'[`i'] == 0 {
				di as res				///
					%10.0f 0			///
					%8.0f  0			///
					%12.0f 0
			}
			else {
				di as res				///
					%10.0fc `min'[`i']		///
					%10.1fc `nm'[`i']/`nhnm'[`i']	///
					%10.0fc `max'[`i']
			}
			local ++i
		}
	}
	else {				// str_i is a string variable
		while `onestr'[`i']<. {
			if `nhnm'[`i'] == 1 {
				local star "*"
			}
			else {
				local star " "
				if "`single'" != "" {
					local ++i
					continue
				}
			}
			local dstr_i = udsubstr(trim(`str_i'[`i']),1,8)
			local cs = 9 - udstrlen("`dstr_i'")

			di as res				///
				%8s "`dstr_i'"			///
				%10.0fc `nhnm'[`i']		///
				as txt "`star'" _c
			`not' di as res %9.0fc `nhm'[`i'] " " _c
			di as res %9.0fc `nm'[`i'] _c
			`not' di as res %10.0fc `miss'[`i'] _c
			if `nhnm'[`i'] == 0 {
				di as res				///
					%10.0f 0			///
					%8.0f  0			///
					%12.0f 0
			}
			else {
				di as res				///
					%10.0fc `min'[`i']		///
					%10.1fc `nm'[`i']/`nhnm'[`i']	///
					%10.0fc `max'[`i']
			}
			local ++i
		}
	}

	di in smcl as txt "{hline 8}" _dup(`ndup') "  {hline 8}"

	if "`single'" != "" {
		di as res _col(11)				///
			%8.0fc `N_single'
		exit
	}

    	di as res						///
		%8.0fc `N_str'					///
		%10.0fc `N_psu'-`N_mpsu' _c
	`not' di as res %10.0fc `N_mpsu' _c
	di as res %10.0fc `N'-`N_miss' _c
    	`not' di as res %10.0fc `N_miss' _c
	di as res						///
		%10.0fc `strmin'				///
		%10.1fc (`N'-`N_miss')/(`N_psu'-`N_mpsu')	///
		%10.0fc `strmax'

	`not' di as txt _col(31) "{hline 18}" _n		///
		as res _col(`col') %10.0fc `N'

	if _N > `N' {
		di `skipn' as res _col(`col')			///
			%10.0fc _N-`N' as txt			///
			" = #Obs with missing values in the "	///
			_n _col(`col')				///
			"  {hline 8}   survey characteristics"	///
			_n as res _col(`col') %10.0fc _N
	}
end

exit
