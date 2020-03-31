*! version 1.1.7  09feb2015

/*
	mi convert <style> [, clear <style_dependent_options>]
		

	mi convert flongsep <name> [, clear replace
						<flongsep_dependentoptions>]

	where <style> is wide, mlong, or flong.


	Code notes

	    -mi convert flongsep- is handled by mi_convert_any_flongsep.

	    All other handled by mi_convert_<from>_<to>

*/

program mi_cmd_convert, rclass
	version 11.0

	u_mi_assert_set
	gettoken to 0 : 0, parse(" ,[]()=")
	u_mi_map_style to : `to'

	if ("`to'"=="wide" | "`to'"=="flongsep") {
		u_mi_chk_longvnames_exist "mi convert" "`to'"
	}

	if ("`to'"=="flongsep") { 
		mi_convert_any_flongsep `0'
		exit
	}
		
	syntax [, CLEAR noUPdate *]
	local from "`_dta[_mi_style]'"

	if ("`from'"=="`to'") {
		di as txt "(data already `to')"
		exit
	}

	capture mi_convert_`from'_`to' ?
	if (_rc) {
		di as err "cannot convert from style `from' to `to'"
		exit 198
	}

	if (c(changed) & "`clear'"=="") { 
		error 4
	}

	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')
	if ("`update'"=="") {
		u_mi_certify_data, proper msgno(`msgno')
	}
	local changed = c(changed)
	if (`"`options'"'=="") {
		mi_convert_`from'_`to'
	}
	else {
		mi_convert_`from'_`to', `options'
	}
	mata: (void) st_updata(`changed')
end

program mi_convert_any_flongsep /* name [, clear nomessage noupdate *] */
	gettoken name 0 : 0, parse(" ,[]()-")

	if ("`name'"=="," | "`name'"=="") { 
		di as err "syntax error"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err "nothing found where name expected;{break}"
		di as smcl as err "syntax is {bf:mi convert flongsep} {it:name}"
		di as smcl as err "{p_end}"
		exit 198
	}
	confirm name `name'

	syntax [, CLEAR REPLACE noMESSAGE noUPdate *]
	local from "`_dta[_mi_style]'"

	if ("`from'"=="flongsep") {
		if ("`name'"=="`_dta[_mi_name]'") {
			di as txt "(data already flongsep `name')"
			exit
		}
		local cmd "mi copy `name'"
		if ("`replace'"!="") { 
			local cmd "`cmd', replace"
		}

		tempname msgno
		u_mi_certify_data, acceptable msgno(`msgno')
		if ("`update'"=="") { 
			u_mi_certify_data, proper msgno(`msgno')
		}

		di as smcl as txt "{p 0 1 2}"
		di as smcl "(data already flongsep, but named"
		di as smcl "{res:`_dta[_mi_name]'}; running"
		di as smcl "{bf:mi copy `name'})"
		di
		di as txt "-> " as res "`cmd'"
		`cmd'
		exit
	}

	capture mi_convert_`from'_flongsep ?
	if (_rc) {
		di as err "cannot convert from style `from' to flongsep"
		exit 198
	}

	if (c(changed) & "`clear'"=="") { 
		error 4
	}

	if ("`replace'"=="") {
		confirm new file `name'.dta
	}
	if ("`message'"!="") {
		mata: u_mi_flongsep_erase("`name'", 0, 1)
	}
	else {
		mata: u_mi_flongsep_erase("`name'", 0, 0)
	}
	
	u_mi_certify_data, acceptable proper `update'
	capture noi mi_convert_`from'_flongsep `name' 
	local rc = _rc
	if (_rc) {
		mata: u_mi_flongsep_erase("`name'", 0, 0)
		exit `rc'
	}

	if ("`message'"!="") {
		exit
	}

	local ds `name'.dta
	local M `_dta[_mi_M]'
	if (`M') { 
		local files files
		forvalues m=1(1)`M' {
			local ds `ds' _`m'_`name'.dta
		}
	}
	else {
		local files "file"
	}

	di as txt as smcl "{p}"
	di as smcl "(`files'"
	di as smcl "`ds'"
	di as smcl "created)"
	di as smcl "{p_end}"
end
	
	




/* -------------------------------------------------------------------- */
				/* more convert				*/

/*
               from/to  |         wide   mlong   flong   flongsep
		---------+-------------------------------------------
		wide    |          .       x       x
		mlong   |          x       .       x
		flong   |          x       x       .
		flongsep |                                  .
		-----------------------------------------------------
*/



				/* convert wide to ...		*/

program mi_convert_wide_mlong

	if (`"`0'"'=="?") {
		exit
	}

	syntax [, CLEAR REPLACE]
	novarabbrev mi_convert_wide_mlong_u
	u_mi_curtime set
end
	
program mi_convert_wide_mlong_u

	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
	local vars  `ivars' `pvars'
	local M    `_dta[_mi_M]'
	local N	  = _N

	/* ----------------- no imputations or no variables or both --- */
	local simple 0
	if (`M'==0) {
		local simple 1
	}
	else {
		qui count if _mi_miss
		if (r(N)==0) {
			local simple 1
		}
	}
	if (`simple') {
		nobreak {
			local changed = c(changed)
			local vars `ivars' `pvars'
			forvalues m=1(1)`M' { 
				foreach v of local vars {
					drop _`m'_`v'
				}
			}

			quietly {
				gen `c(obs_t)' _mi_id = _n
				compress _mi_id
				gen int  _mi_m = 0
			}
			u_mi_zap_chars
			char _dta[_mi_style] "mlong"
			char _dta[_mi_M]     `M'
			char _dta[_mi_pvars] "`pvars'"
			char _dta[_mi_ivars] "`ivars'"
			char _dta[_mi_rvars] "`rvars'"
			char _dta[_mi_n]     0
			char _dta[_mi_N]     `N'
			char _dta[_mi_marker] _mi_ds_1
			mata: (void) st_updata(`changed')
			exit
		}
	}

	/* ------------------------------------- we have imputations ---*/
	quietly {
		tempvar id m
		gen int  `m' = 0
		gen `c(obs_t)' `id' = _n
		compress `id'

		local changed = c(changed)
		preserve
		keep if _mi_miss
		drop _mi_miss `vars'

		tempfile justmissing
		save "`justmissing'"
		local n = _N

		forvalues i=1(1)`M' {
			if (`i'>1) {
				use "`justmissing'", clear 
			}
			foreach var of local vars {
				rename _`i'_`var' `var'
			}
			forvalues j=1(1)`M' {
				capture drop _`j'_?*
			}
			replace `m' = `i'
			tempfile file_`i'
			qui save "`file_`i''"
		}
		erase "`justmissing'"
		restore, preserve 
		forvalues i=1(1)`M' {
			drop _`i'_?*
		}
		forvalues i=1(1)`M' { 
			append using "`file_`i''"
			erase "`file_`i''"
		}
		rename `id' _mi_id
		rename `m' _mi_m
		sort _mi_m _mi_id
	}
	u_mi_zap_chars
	char _dta[_mi_style] "mlong"
	char _dta[_mi_M]    `M'
	char _dta[_mi_ivars] `ivars'
	char _dta[_mi_pvars] `pvars'
	char _dta[_mi_rvars] `rvars'
	char _dta[_mi_N]    `N'
	char _dta[_mi_n]    `n'
	char _dta[_mi_marker] _mi_ds_1
	mata: (void) st_updata(`changed')
	restore, not
end

program mi_convert_wide_flong

	if (`"`0'"'=="?") {
		exit
	}

	syntax [, CLEAR REPLACE]

	local change = c(changed)
	preserve
	mi_convert_wide_mlong
	mi_convert_mlong_flong
	u_mi_curtime set
	mata: (void) st_updata(`changed')
	restore, not
end

				/* convert mlong to ...			*/

program mi_convert_mlong_wide

	if (`"`0'"'=="?") {
		exit
	}

	syntax [, CLEAR REPLACE]
	novarabbrev mi_convert_mlong_wide_u
	u_mi_curtime set
end

program mi_convert_mlong_wide_u

	local M    `_dta[_mi_M]'
	local N    `_dta[_mi_N]'
	local n    `_dta[_mi_n]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
	local vars `ivars' `pvars'

	local changed = c(changed)
	preserve

	if (`_dta[_mi_n]'==0) { 
		drop _mi_m _mi_id
		foreach v of local vars {
			local ty : type `v'
			forvalues m=1(1)`M' {
				qui gen `ty' _`m'_`v' = `v'
			}
		}
		char _dta[_mi_N]
		char _dta[_mi_n]
		char _dta[_mi_style] "wide"
		u_mi_fixchars, proper
		mata: (void) st_updata(`changed')
		restore, not
		exit
	}


	quietly {
		forvalues i=1(1)`M' {
			if (`i'!=1) { 
				restore, preserve
			}
			keep if _mi_m==`i'
			keep _mi_id `vars'
			foreach v of local vars {
				rename `v' _`i'_`v'
			}
			sort _mi_id
			tempfile file`i'
			save `"`file`i''"'
		}
		restore, preserve
		keep if _mi_m==0
		drop _mi_m
		forvalues i=1(1)`M' {
			sort _mi_id
			merge 1:1 _mi_id using `"`file`i''"', ///
				nogen sorted noreport nonotes
		}
		sort _mi_id
		drop _mi_id

		forvalues i=1(1)`M' { 
			foreach v of local ivars {
				replace _`i'_`v' = `v' if `v'!=.
			}
			foreach v of local pvars {
				replace _`i'_`v' = `v' if !_mi_miss
			}
		}
		char _dta[_mi_N]
		char _dta[_mi_n]
		char _dta[_mi_style] "wide"
	}
	u_mi_fixchars, proper
	mata: (void) st_updata(`changed')
	restore, not
end
	
program mi_convert_mlong_flong

	if (`"`0'"'=="?") {
		exit
	}

	syntax [, CLEAR REPLACE]
	novarabbrev mi_convert_mlong_flong_u
	u_mi_curtime set
end

program mi_convert_mlong_flong_u

	local M `_dta[_mi_M]'

	if (`_dta[_mi_n]'==0) {
		if (`M') {
			local changed = c(changed)
			preserve
			quietly {
				expand `=`M'+1'
				sort _mi_id
				by _mi_id: replace _mi_m = (_n - 1)
				sort _mi_m _mi_id
			}
			mata: (void) st_updata(`changed')
			restore, not
		}
		char _dta[_mi_n]
		char _dta[_mi_style] "flong"
		exit
	}

	qui count if _mi_miss==0
	if (r(N)==0) {
		char _dta[_mi_n]
		char _dta[_mi_style] "flong"
		exit
	}
		

	local changed = c(changed)
	preserve
	quietly { 
		keep if _mi_m==0 & _mi_miss==0
		drop _mi_miss
		replace _mi_m = .
		tempfile xtra 
		save "`xtra'"

		restore, preserve
		forvalues i=1(1)`M' {
			local Np1 = _N+1
			append using "`xtra'"
			replace _mi_m = `i' in `Np1'/l
		}
		char _dta[_mi_n]
		char _dta[_mi_style] "flong"
		sort _mi_m _mi_id
	}
	mata: (void) st_updata(`changed')
	restore, not
end



program mi_convert_wide_flongsep

	if (`"`0'"'=="?") {
		exit
	}

	preserve
	novarabbrev mi convert mlong, clear
	novarabbrev mi convert flongsep `0', clear replace nomessage
	u_mi_curtime set
	restore, not
end




program mi_convert_mlong_flongsep

	if (`"`0'"'=="?") {
		exit
	}

	novarabbrev mi_convert_mlong_flongsep_u `0'
	u_mi_curtime set
end


program mi_convert_mlong_flongsep_u

	args name

	if (`_dta[_mi_M]'==0) {
		nobreak {
			drop _mi_m
			char _dta[_mi_n]
			char _dta[_mi_name] "`name'"
			char _dta[_mi_style] "flongsep"
			qui save `name', replace
		}
		exit
	}
		
	local M `_dta[_mi_M]'
	preserve
	quietly { 
		keep if _mi_m==0 & _mi_miss==0
		drop _mi_miss
		drop _mi_m
		u_mi_zap_chars
		tempfile xtra 
		save "`xtra'", emptyok

		forvalues i=1(1)`M' {
			restore, preserve
			keep if _mi_m==`i'
			drop _mi_m _mi_miss
			append using "`xtra'"
			sort _mi_id

			u_mi_zap_chars
			char _dta[_mi_style] "flongsep_sub"
			char _dta[_mi_name]  "`name'"
			char _dta[_mi_m]     `i'
			char _dta[_mi_marker] _mi_ds_1
			save _`i'_`name', replace 
		}

		restore, preserve
		drop if _mi_m
		drop _mi_m

		char _dta[_mi_n]
		char _dta[_mi_name] "`name'"
		char _dta[_mi_style] "flongsep"
		sort _mi_id
		save `name', replace
	}
	restore, not
end

program mi_convert_flong_flongsep

	if (`"`0'"'=="?") {
		exit
	}

	novarabbrev mi_convert_flong_flongsep_u `0'
	u_mi_curtime set
end

program mi_convert_flong_flongsep_u
	args name

	if (`_dta[_mi_M]'==0) {
		char _dta[_mi_name] "`name'"
		char _dta[_mi_style] "flongsep"
		drop _mi_m
		qui save `name', replace
		exit
	}
		
	local M `_dta[_mi_M]'
	preserve
	quietly { 
		forvalues i=1(1)`M' {
			if (`i'!=1) {
				restore, preserve
			}
			keep if _mi_m==`i'
			drop _mi_m _mi_miss
			sort _mi_id

			u_mi_zap_chars
			char _dta[_mi_style] "flongsep_sub"
			char _dta[_mi_name]  "`name'"
			char _dta[_mi_m]     `i'
			char _dta[_mi_marker] _mi_ds_1
			save _`i'_`name', replace 
		}

		restore, preserve
		drop if _mi_m
		drop _mi_m

		char _dta[_mi_name] "`name'"
		char _dta[_mi_style] "flongsep"
		sort _mi_id
		save `name', replace
	}
	restore, not
end



					/* convert flong to ...		*/

program mi_convert_flong_mlong

	if (`"`0'"'=="?") {
		exit
	}

	syntax
	novarabbrev mi_convert_flong_mlong_u
end

program mi_convert_flong_mlong_u

	quietly {
		nobreak {
			local changed = c(changed)
			sort _mi_m _mi_id
			drop if _mi_m & _mi_miss[_mi_id]==0
			char _dta[_mi_style] mlong
			count if _mi_m
			char _dta[_mi_n]    `r(N)'
			mata: (void) st_updata(`changed')
		}
	}
end

program mi_convert_flong_wide

	if (`"`0'"'=="?") {
		exit
	}

	syntax
	local changed = c(changed)
	preserve
	novarabbrev mi_convert_flong_mlong
	novarabbrev mi_convert_mlong_wide
	mata: (void) st_updata(`changed')
	restore, not
end

					/* convert flongsep to ...	*/

program mi_convert_flongsep_flong

	if (`"`0'"'=="?") {
		exit
	}

	syntax [, CLEAR REPLACE]
	novarabbrev mi_convert_flongsep_flong_u
end

program mi_convert_flongsep_flong_u

	preserve

					/* preserve chars 	*/
	local marker `_dta[_mi_marker]'
	local style `_dta[_mi_style]'
	local name  `_dta[_mi_name]'
	local M     `_dta[_mi_M]'
	local N     `_dta[_mi_N]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
					/* vars are		*/
	
	/* _mi_id  */
	/* _mi_miss */

	quietly { 
		gen int _mi_m = 0
		forvalues m=1(1)`M' {
			local Np1 = _N + 1
			append using _`m'_`name'
			replace _mi_m=`m' in `Np1'/l
		}
	}
	u_mi_zap_chars
	char _dta[_mi_style]  flong
	char _dta[_mi_marker] `marker'
	char _dta[_mi_M]      `M'
	char _dta[_mi_N]      `N'
	char _dta[_mi_ivars]  `ivars'
	char _dta[_mi_pvars]  `pvars'
	char _dta[_mi_rvars]  `rvars'

	global S_FN
	restore, not
end

program mi_convert_flongsep_wide

	if (`"`0'"'=="?") {
		exit
	}

	syntax [, CLEAR REPLACE]
	preserve
	mi convert mlong, clear
	mi convert wide, clear 
	global S_FN ""
	restore, not
end

program mi_convert_flongsep_mlong

	if (`"`0'"'=="?") {
		exit
	}

	syntax [, CLEAR REPLACE]
	novarabbrev mi_convert_flongsep_mlong_u
end

program mi_convert_flongsep_mlong_u

	preserve

					/* preserve chars 	*/
	local marker `_dta[_mi_marker]'
	local style `_dta[_mi_style]'
	local name  `_dta[_mi_name]'
	local M     `_dta[_mi_M]'
	local N     `_dta[_mi_N]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
					/* vars are		*/
	
	/* _mi_id  */
	/* _mi_miss */

	local has_marginal_data 0
	local n                0
	if (`M') {
		qui count if _mi_miss
		if (r(N)) { 
			local has_marginal_data 1
		}
	}

	if (`has_marginal_data') { 
		quietly {
			keep _mi_id _mi_miss
			keep if _mi_miss
			sort _mi_id
			tempfile touse_dta
			save "`touse_dta'"

			forvalues m=1(1)`M' {
				use _`m'_`name', clear 
				sort _mi_id 
				merge 1:1 _mi_id using "`touse_dta'", ///
					keep(match) nogen sorted norep nonotes
				gen int _mi_m = `m'
				tempfile file`m'
				save "`file`m''"
			}
			restore, preserve
			sort _mi_id
			gen int _mi_m = 0
			forvalues m=1(1)`M' {
				append using "`file`m''"
			}
			replace _mi_miss = . if _mi_m
			count if _mi_m
			local n = r(N)
		}
	}
	else {
		qui gen int _mi_m = 0
	}

	u_mi_zap_chars 
	char _dta[_mi_style]   mlong
	char _dta[_mi_marker]  `marker'
	char _dta[_mi_M]       `M'
	char _dta[_mi_N]       `N'
	char _dta[_mi_n]       `n'
	char _dta[_mi_ivars]   `ivars'
	char _dta[_mi_pvars]   `pvars'
	char _dta[_mi_rvars]   `rvars'
	
	global S_FN
	restore, not
end
