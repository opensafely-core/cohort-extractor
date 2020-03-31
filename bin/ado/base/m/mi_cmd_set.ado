*! version 1.0.6  15apr2019

/*
	mi set				(equivalent to mi query)

	mi set <style>

	mi set {m|M} = ...

	mi set, clear [asis]           (equivalent to mi unset)

	-mi set- returns
		<nothing>
	
*/


program mi_cmd_set, rclass
	version 11.0

	/* ------------------------------------------------------------ */
						/* parse		*/
	gettoken word : 0, parse(" ,=")
	if ("`word'"=="m" | "`word'"=="M") { 
		mi_set_m `0'
		exit
	}

	if (`"`word'"'=="" | `"`word'"'==",") {
		syntax [, CLEAR *]
		if ("`clear'"!="") { 
			mi_cmd_unset, `options'
			return add
			exit
		}
		if (`"`options'"'!="") { 
			mi_set_error_already 
			/*NOTREACHED*/
		}
		mi_cmd_query
		return add
		exit
	}

	gettoken word 0 : 0, parse(" ,")

	u_mi_map_style newstyle : `word'
	if ("`newstyle'"=="flongsep") {
		gettoken name 0 : 0, parse (" ,")
		confirm name `name'
	}

	u_mi_how_set oldstyle

	/* ------------------------------------------------------------ */

	if ("`oldstyle'"!="") {
		if ("`oldstyle'"=="`newstyle'") {
			if ("`newstyle'" == "flongsep") { 
				if ("`_dta[_mi_name]'" != "`name'") {
					mi_set_error_already flongsep `name'
					/*NOTREACHED*/
				}
			}
			exit
		}
		mi_set_error_already `newstyle' `name'
		/*NOTREACHED*/
	}
	/* ------------------------------------------------------------ */
	if (_N==0) {
		error 2000
	}
	/* ------------------------------------------------------------ */

	nobreak mi_set_`newstyle' `name' `0'
end


program mi_set_error_already 
	args newstyle newname

	local newfullstyle "`newstyle'"
	if ("`newstyle'"=="flongsep") {
		local newfullstyle "flongsep `newname'"
	}

	local style     "`_dta[_mi_style]'"
	local fullstyle "`style'"
	if ("`style'"=="flongsep") {
		local name "`_dta[_mi_name]'"
		local fullstyle "flongsep `name'"
	}

	di as smcl as err "data already {bf:mi set `fullstyle'}"
	di as smcl as err "{p 4 4 2}"

	if ("`style'"=="flongsep" & "`newstyle'"=="flongsep") {
		di as smcl as err "type {bf:mi copy `newname'} to copy"
		di as smcl as err "data to new name and to use the new copy"
	}
	else {
		di as smcl as err "type {bf:mi convert `newfullstyle'} to"
		di as smcl as err "convert data to `newstyle' format"
	}

	di as smcl as err "{p_end}"
	exit 459
end



program mi_set_wide
	syntax
	nobreak {
		quietly gen byte _mi_miss = 0 
		label var _mi_miss "Incomplete observation"
		char _dta[_mi_style] "wide"
		char _dta[_mi_M]     0
		char _dta[_mi_ivars]
		char _dta[_mi_pvars]
		char _dta[_mi_rvars]
		u_mi_curtime set
		char _dta[_mi_marker] "_mi_ds_1"
	}
end

program mi_set_mlong
	syntax

	confirm new var _mi_miss _mi_m _mi_id
	nobreak {
		quietly {
			gen byte _mi_miss = 0
			label var _mi_miss "Incomplete observation"
			gen int  _mi_m   = 0
			label var _mi_m "Imputation number"
			gen `c(obs_t)' _mi_id  = _n
			label var _mi_id "Observation ID"
			compress _mi_id
		}

		char _dta[_mi_style] "mlong"
		char _dta[_mi_M]     0
		char _dta[_mi_ivars]
		char _dta[_mi_pvars]
		char _dta[_mi_rvars]
		char _dta[_mi_N]     `=_N'
		char _dta[_mi_n]     0
		u_mi_curtime set
		char _dta[_mi_marker] "_mi_ds_1"
	}
end

program mi_set_flong
	syntax

	confirm new var _mi_miss _mi_m _mi_id
	nobreak {
		quietly {
			gen byte _mi_miss = 0
			label var _mi_miss "Incomplete observation"
			gen int  _mi_m   = 0
			label var _mi_m "Imputation number"
			gen `c(obs_t)' _mi_id  = _n
			label var _mi_id "Observation ID"
			compress _mi_id
		}

		char _dta[_mi_style] "flong"
		char _dta[_mi_M]     0
		char _dta[_mi_ivars]
		char _dta[_mi_pvars]
		char _dta[_mi_rvars]
		char _dta[_mi_N]     `=_N'
		u_mi_curtime set
		char _dta[_mi_marker] "_mi_ds_1"
	}
end

program mi_set_flongsep
	gettoken name 0 : 0, parse(" ,")
	syntax

	nobreak {
		mi set flong 
		capture noi mi convert flongsep `name', clear
		if (_rc) {
			local rc = _rc 
			u_mi_zap_chars 
			exit `rc'
		}
	}
end



/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* mi set M    			*/
/*
	mi_set_m implements 

		mi set M  = #           set M to #
		mi set M += #           increment M by #
		mi set M -= #           decrement M by #
		mi set m -= (<numlist>) remove specified m

	Parsingwise, 
                         we are here
                        /
		mi set M ...

	and it is known that the first token is m or M
*/

program mi_set_m_operr
	di as smcl as err ///
		`"{bf:`0'} found where {bf:=}, {bf:+=}, or {bf:-=} expected"'
	exit 198
end

program mi_set_m
	u_mi_assert_set
	/* ------------------------------------------------------------ */
							/* parse	*/

	gettoken letter 0 : 0, parse(" =+()")

	gettoken op 0 : 0, parse(" =+-()")
	if (!(strlen("`op'")==1 & strpos("=+-", "`op'"))) {
		mi_set_m_operr "`op'"
		/*NOTREACHED*/
	}
	if ("`op'"=="+" | "`op'"=="-") {
		local ch = bsubstr(`"`0'"', 1, 1)	
		if ("`ch'" != "=") {
			mi_set_m_operr "`op'"
			/*NOTREACHED*/
		}
		local fullop `"`op'`ch'"'
		gettoken next 0 : 0, parse(" =")
		local next
	}
	else {
		local fullop `"`op'"'
	}

	gettoken next 0 : 0, parse(" ()") match(hasparens)
	if ("`hasparens'"=="(") {
		if ("`letter'"!="m") {
			di as smcl as err "{p 0 0 2}"
			di as smcl as err ///
"to delete specified imputations command is {bf:mi set m}, not {bf:mi set M}"
			di as smcl as err "{p_end}"
			di as smcl as err "{p 4 4 2}" 
			di as smcl as err ///
"{it:M} is the total number of imputations, {it:m} is a specific imputation"
			di as smcl as err "{p_end}"
			exit 198
		}
		local numlist "`next'"
		numlist "`numlist'", int min(1) sort
		local numlist `r(numlist)'
		gettoken lastel numrest : numlist
		foreach el of local numrest {
			if (`el'==`lastel') {
				di as smcl as err "{p 0 0 2}"
				di as smcl as err ///
				"request to delete {it:m} = (`numlist')"
				di as smcl as err ///
				"invalid; repeated elements not allowed"
				di as smcl as err "{p_end}"
				exit 198
			}
			local lestel `el'
		}
		local lastel
		local numrest
		local isnumlist 1
	}
	else {
		if ("`letter'"!="M") {
			di as smcl as err "{p 0 0 2}"
			di as smcl as err ///
	"{bf:M} in {bf:mi set M} must be uppercase when resetting {it:M}"
			di as smcl as err "{p_end}"
			exit 198
		}

		capture confirm integer number `next'
		if _rc {
			di as err ///
			`"`next'"' found where # or (numlist) expected"'
			exit 198
		}
		local num "`next'"
		local isnumlist 0
	}

	if (`"`0'"' != "") { 
		di as err `""`0'" found where nothing expected"'
		exit 198
	}

	local M `_dta[_mi_M]'
	if (!`isnumlist') {
		if ("`op'" == "=") {
			local newM = `num'
		}
		else {
			local newM = `M' `op' `num'
		}
		if (`newM'<0 | `newM'>1000) {
			di as smcl as err "{p 0 4 2}"
			di as smcl as err "{bf:mi set M `fullop' `num'}"
			di as smcl as err "results in {it:M} = `newM'{break}"
			di as smcl as err ///
			"{it:M} must be between 0 and 1000, inclusive"
			di as smcl as err "{p_end}"
			exit 198
		}
		if ("`_dta[_mi_style]'"=="wide") {
			u_mi_chk_longvnames_exist "mi set M" "wide" "`newM'"
		}
	}
	else {
		if ("`op'"!="-") {
			di as err "numlist may be used only with -= (deletion)"
			exit 198
		}
		local newlist
		local lastm 0
		foreach m of local numlist {
			if (`m'<1 | `m'>`M') {
				di as smcl as err "{it:m} = `m' does not exist"
				exit 111
			}
			if (`m'!=`lastm') { 
				local newlist `newlist' `m'
			}
		}
		local numlist `newlist'
	}
							/* parse	*/
	/* ------------------------------------------------------------ */
							/* execute	*/
	if (!`isnumlist') {
		if (`newM'!=`M') {
			mi_set_m_reset_`_dta[_mi_style]' `newM'
			if (`newM'<`M') { 
				local diff = `M' - `newM' 
				local imps = cond(`diff'==1, ///
					    "imputation", "imputations")
				di as smcl as txt ///
				"(`diff' `imps' dropped; {it:M} = `newM')"
			}
			else {
				local diff = `newM' - `M' 
				local imps = cond(`diff'==1, ///
					    "imputation", "imputations")
				di as smcl as txt ///
				"(`diff' `imps' added; {it:M} = `newM')"
			}
		}
		else {
			di as smcl as txt ///
			"(number of imputations {it:M} = `M' unchanged)"
		}
	}
	else {
		local n : word count `newlist' 
		if (`n') {
			mi_set_m_delete_`_dta[_mi_style]' `n' "`numlist'"
			local newM = `M' - `n' 
			local imps = cond(`n'==1, "imputation", "imputations")
			di as smcl as txt ///
			"(`n' `imps' dropped; {it:M} = `newM')"
		}
		else {
			di as smcl as txt ///
			"(number of imputations {it:M} = `M' unchanged)"
		}
	}
end


program mi_set_m_reset_flongsep
	args newM

	u_mi_certify_data, acceptable 
	local name "`_dta[_mi_name]'"
	local M   `_dta[_mi_M]'

	if (`newM'==`M') { 
		exit
	}

	if (`newM'<`M') { 
		nobreak {
			local del0 = `newM' + 1
			forvalues i=`del0'(1)`M' { 
				capture erase "_`i'_`name'.dta"
			}
			char _dta[_mi_M] `newM'
		}
		exit
	}

	preserve 
	u_mi_zap_chars
	qui drop _mi_miss
	char _dta[_mi_marker] "_mi_ds_1"
	char _dta[_mi_style]  "flongsep_sub"
	char _dta[_mi_name]   "`name'"
	local add0 = `M' + 1
	nobreak {
		forvalues i=`add0'(1)`newM' { 
			char _dta[_mi_m]      `i'
			qui save "_`i'_`name'.dta", replace
		}
		restore
		char _dta[_mi_M] `newM'
	}
end
		

program mi_set_m_reset_wide
	args newM

	u_mi_certify_data, acceptable

	local M `_dta[_mi_M]'
	local vars `_dta[_mi_ivars]' `_dta[_mi_pvars]'

	nobreak {
		if (`newM'<`M') { 
			local newMp1 = `newM' + 1 
			foreach v of local vars {
				forvalues i=`newMp1'(1)`M' {
					capture drop _`i'_`v'
				}
			}
		}
		else {
			local Mp1 = `M' + 1
			foreach v of local vars {
				local ty : type `v'
				forvalues i=`Mp1'(1)`newM' {
					qui gen `ty' _`i'_`v' = `v'
				}
			}
		}
		char _dta[_mi_M] `newM'
	}
end

program mi_set_m_delete_flongsep
	args n numlist 

	if (`n'==0) {
		exit
	}

	u_mi_certify_data, acceptable
	local M    `_dta[_mi_M]'
	local name "`_dta[_mi_name]'"

	forvalues i=1(1)`M' { 
		local fulllist `fulllist' `i'
	}
	local restlist : list fulllist - numlist
	local newM : word count `restlist'

	local preserved 0
	nobreak {
		forvalues todrop=1(1)`n' {
			local i : word `todrop' of `numlist' 
			capture erase _`i'_`name'.dta
		}
		forvalues j=1(1)`newM' { 
			local i : word `j' of `restlist'
			if (`i'!=`j') { 
				if (!`preserved') {
					preserve
					local preserved 1
				}
				qui use _`i'_`name', clear 
				local _dta[_mi_m] `j'
				qui save _`j'_`name'
				erase _`i'_`name'.dta
			}
		}
		if (`preserved') {
			restore
		}
		char _dta[_mi_M] `newM'
	}
end
				

program mi_set_m_delete_wide
	args n numlist

	u_mi_certify_data, acceptable
	local M `_dta[_mi_M]'
	local vars `_dta[_mi_ivars]' `_dta[_mi_pvars]'

	nobreak {
		forvalues todrop=`n'(-1)1 {
			local i_todrop : word `todrop' of `numlist'
			foreach v of local vars {
				capture drop _`i_todrop'_`v'
			}
			foreach v of local vars {
				local i_todrop_p1 = `i_todrop' + 1
				forvalues j=`i_todrop_p1'(1)`M' {
					local i = `j' - 1
					rename _`j'_`v' _`i'_`v'
				}
			}
			local M = `M' - 1
		}
		char _dta[_mi_M] `M'
	}
end



program mi_set_m_reset_mlong 
	args newM 

	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')
	local M `_dta[_mi_M]'
	nobreak {
		if (`newM' < `M') { 
			quietly drop if _mi_m>`newM'
			char _dta[_mi_M] `newM'
		}
		else {
			char _dta[_mi_M] `newM'
			quietly u_mi_certify_data, proper msgno(`msgno')
		}
	}
end

program mi_set_m_delete_mlong 
	args n numlist 

	u_mi_certify_data, acceptable
	local M `_dta[_mi_M]'

	nobreak {
		forvalues idx=`n'(-1)1 {
			local todrop : word `idx' of `numlist'
			quietly drop if _mi_m==`todrop'
			quietly replace _mi_m = _mi_m-1 if _mi_m>`todrop'
		}
		local newM = `M' - `n'
		char _dta[_mi_M] `newM'
	}
end

program mi_set_m_reset_flong 
	args newM 

	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')
	local M `_dta[_mi_M]'
	nobreak {
		if (`newM' < `M') { 
			quietly drop if _mi_m>`newM'
			char _dta[_mi_M] `newM'
		}
		else {
			char _dta[_mi_M] `newM'
			quietly u_mi_certify_data, proper msgno(`msgno')
		}
	}
end

				
program mi_set_m_delete_flong 
	args n numlist 

	u_mi_certify_data, acceptable
	local M `_dta[_mi_M]'

	nobreak {
		forvalues idx=`n'(-1)1 {
			local todrop : word `idx' of `numlist'
			quietly drop if _mi_m==`todrop'
			quietly replace _mi_m = _mi_m-1 if _mi_m>`todrop'
		}
		local newM = `M' - `n'
		char _dta[_mi_M] `newM'
	}
end
