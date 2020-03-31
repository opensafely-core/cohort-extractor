*! version 1.0.2  02feb2012

program mi_sub_replace0_flongsep
	version 11
	args idvars newidvar replfile selfile

	local marker "`_dta[_mi_marker]'"
	local style "`_dta[_mi_style]'"
	local name  "`_dta[_mi_name]'"
	local M     `_dta[_mi_M]'
	local N     `_dta[_mi_N]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
	local update "`_dta[_mi_update]'"
	/*
		_mi_id              0, 1, ..., `_dta[_mi_N]'
		_mi_miss            0, 1
	*/


	tempfile origfile	/* m=0 of flongsep data */
	mata: u_mi_rm_dta_chars()
	qui save "`origfile'"

	keep `idvars' _mi_id _mi_miss
	sort `idvars'
	capture by `idvars': assert _N==1
	if (_rc) { 
		local n : word count `idvars'
		local variables = cond(_n==1, "variable", "variables")
		local do       = cond(_n==1, "does",     "do"       )
		di as smcl as err "{p}"
		di as smcl as err "`variables' `idvars' `do' not"
		di as smcl as err "uniquely identify obs. in"
		di as smcl as err `"original mi data"'
		di as smcl as err "{p_end}"
		exit 459
	}

	qui merge 1:m `idvars' using "`selfile'", ///
			keep(match) sorted noreport nonotes nogen
	keep _mi_id `newidvar' _mi_miss
	sort _mi_id
	quietly save "`selfile'", replace 

	quietly { 
		forvalues m=1(1)`M' { 
			use _`m'_`name', clear 
			sort _mi_id 
			merge 1:m _mi_id using "`selfile'", ///
				keep(match) sorted noreport nonotes nogen
			drop _mi_id _mi_miss
			rename `newidvar' _mi_id
			save _`m'_`name', replace
		}
		use "`selfile'", clear 
		sort `newidvar'
		save "`selfile'", replace
		use "`replfile'", clear 
		sort `newidvar' 
 					// to bring back _mi_miss:
		merge 1:1 `newidvar' using "`selfile'", ///
			keep(master match) sorted noreport nonotes nogen
		drop _mi_id
		u_mi_zap_chars
		char _dta[_mi_marker] "`marker'"
		char _dta[_mi_style] "`style'"
		char _dta[_mi_name]  "`name'"
		char _dta[_mi_M]      `M'
		char _dta[_mi_N]      `N'
		char _dta[_mi_ivars]  `ivars'
		char _dta[_mi_pvars]  `pvars'
		char _dta[_mi_rvars]  `rvars'
		char _dta[_mi_update] "`update'"
		rename `newidvar' _mi_id
		save `name', replace
	}
	u_mi_certify_data, acceptable proper
end
