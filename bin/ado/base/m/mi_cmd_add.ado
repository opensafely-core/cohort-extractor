*! version 1.0.5  16apr2019 

/*
	mi add <varlist> using <filename> [, assert(master|match) noupdate]



	<varlist> are the match variables.

	Returns
	   scalars:
		r(M_added)     # of added imputations
		r(unmatched_m) # unmatched in master
		r(unmatched_u) # unmatched in using 

	   macros:
		r(imputed_f)   variables for which imputed found
		r(imputed_nf)  variables for which imputed not found
*/

program mi_cmd_add, rclass
	version 11.0

	u_mi_assert_set
	syntax varlist using/ [, ASSERT(string) noUPdate]
	local origusing "`using'"
	if ("`assert'"!="") {
		local l = strlen("`assert'")
		if ("`assert'"==bsubstr("master", 1, max(3,`l'))) {
			local assert "master"
		}
		else if ("`assert'"==bsubstr("match", 1, max(3,`l'))) {
			local assert "match"
		}
		else {
			di as smcl as err "{p 0 4 2}"
			di as smcl as err ///
			"{bf:assert(`assert')} invalid{break}"
			di as smcl as err ///
			"choices are either {bf:assert(master)} or"
			di as smcl as err "{bf:assert(match)}"
			di as smcl as err "{p_end}"
			exit 198
		}
	}
		

	u_mi_get_flongsep_tmpname master : __miaddm
	u_mi_get_flongsep_tmpname using  : __miaddu

	nobreak {
		break capture noisily ///
		novarabbrev nobreak mi_add_u "`varlist'" ///
				"`origusing'" "`update'" ///
				`master' `using' "`assert'"

		local rc = _rc
		mata: u_mi_flongsep_erase("`master'", 0, 0)
		mata: u_mi_flongsep_erase("`using'", 0, 0)
		return add
	}
	exit `rc'
end

program mi_add_u, rclass
	args varlist origusing noupdate master using assert

	/* ------------------------------------------------------------ */
					/* original master in memory	*/

	capture confirm var `varlist'
	if (_rc) {
		local n : word count `varlist'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "`variables' `varlist' not found in master data"
		di as smcl as err "{p_end}"
		exit 111
	}

	qui u_mi_certify_data, acceptable proper `noupdate'

	local m_fn   "`c(filename)'"
	local m_M    `_dta[_mi_M]'
	local m_ivars `_dta[_mi_ivars]'
	local m_style `_dta[_mi_style]'
	if ("`m_style'"=="flongsep") {
		local m_style "flongsep `_dta[_mi_name]'"
	}

	return hidden scalar M_added = 0
	return scalar m = 0
	return scalar unmatched_m = 0 
	return scalar unmatched_u = 0 
	return local imputed_f
	return local imputed_nf `m_ivars'

	if ("`m_ivars'"=="") {
		di as smcl as txt "{p}"
		di as smcl "(there are no variables registered as imputed"
		di as smcl "in the master data)"
		di as smcl "{p_end}"
		exit
	}
	preserve

	/* ------------------------------------------------------------ */
					/* original using in memory	*/

	quietly use "`origusing'", clear 
	capture u_mi_assert_set
	if (_rc) {
		di as smcl as err "using data not {bf:mi set}"
		exit 459
	}

	capture confirm var `varlist'
	if (_rc) {
		local n : word count `varlist'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "`variables' `varlist' not found in using data"
		di as smcl as err "{p_end}"
		exit 111
	}

	qui u_mi_certify_data, acceptable proper `noupdate'

	local u_M    `_dta[_mi_M]'
	local u_ivars `_dta[_mi_ivars]'
	return hidden scalar M_added = `u_M'
	return scalar m = `u_M'

	if (`u_M'==0) { 
		di as smcl as txt "(no imputations ({it:M}=0) in using data)"
		exit
	}

	/* ------------------------------------------------------------ */
					/* original using in memory	*/
					/* calc. predicted results	*/

	local r_ivars : list m_ivars & u_ivars
	if ("`r_ivars"=="") {
		di as txt ///
		"(master and using data have no imputed variables in common)"
		exit
	}
	local r_ivars_nf : list m_ivars - r_ivars

	return local imputed_f `r_ivars'
	return local imputed_nf `r_ivars_nf'


	/* ------------------------------------------------------------ */
					/* original using in memory	*/
					/* make using			*/

	quietly mi convert flongsep `using', clear noupdate
	sort `varlist'
	capture by `varlist': assert _N==1
	if _rc { 
		local n : word count `varlist'
		local variable = cond(`n'==1, "variable", "variables")
		local does     = cond(`n'==1, "does"    , "do"       )
		di as smcl as err "{p}"
		di as smcl as err "`variable' `varlist'"
		di as smcl as err "`does' not uniquely identify obs. in using"
		di as smcl as err "{p_end}"
		exit 459
	}

	/* ------------------------------------------------------------ */
					/* make master			*/
	restore, preserve
	quietly mi convert flongsep `master', clear noupdate
	sort `varlist'
	capture by `varlist': assert _N==1
	if _rc { 
		local n : word count `varlist'
		local variable = cond(`n'==1, "variable", "variables")
		local does     = cond(`n'==1, "does"    , "do"       )
		di as smcl as err "{p}"
		di as smcl as err "`variable' `varlist'"
		di as smcl as err "`does' not uniquely identify obs. in master"
		di as smcl as err "{p_end}"
		exit 459
	}

	/* ------------------------------------------------------------ */
					/* make file select		*/
	tempfile select
	keep `varlist' _mi_id
	qui save "`select'"

	/* ------------------------------------------------------------ */
					/* add to end of select		*/

	local unmatched_m 0
	local unmatched_u 0
	local M1 = `m_M' + 1
	local M2 = `m_M' + `u_M'
	tempvar mervar
	forvalues i=1(1)`u_M' {
		qui use _`i'_`using', clear 
		drop _mi_id
		sort `varlist'
		qui merge 1:1 `varlist' using "`select'", sorted gen(`mervar')
		qui count if `mervar'==2
		local unmatched_m = `unmatched_m' + r(N)
		qui count if `mervar'==1
		local unmatched_u = `unmatched_u' + r(N)
		if ("`assert'"!="") {
			if (`unmatched_m') {
				mi_add_error1 `unmatched_m'
			}
			if ("`assert'"=="match" & `unmatched_u') {
				mi_add_error2 `unmatched_u'
			}
		}
		qui keep if `mervar'==3
		keep `varlist' _mi_id `r_ivars'
		sort _mi_id

		local j = `m_M' + `i'
		char _dta[_mi_m] `j'
		qui save _`j'_`master'
	}
	return scalar unmatched_m = cond(`unmatched_m', 1, 0)
	return scalar unmatched_u = cond(`unmatched_u', 1, 0)
		

	qui use "`master'", clear
	char _dta[_mi_M]    `j'

	qui u_mi_certify_data, acceptable proper

	/* ------------------------------------------------------------ */
					/* reform result		*/
	qui mi convert `m_style', clear replace
	global S_FN "`m_fn'"
	u_mi_fixchars, proper

	local imputations = cond(return(M_added)==1, "imputation", "imputations")
	local contain     = cond(return(M_added)==1, "contains"  , "contain"    )
	di as smcl as txt ///
		"(`return(M_added)' `imputations' added; {it:M} = `_dta[_mi_M]')"

	if ("`return(imputed_nf)'" != "") {
		local n : word count `return(imputed_nf)'
		if (`n'!=1) {
			local those       "those"
			local variables   "variables"
		}
		else {
			local those       "that"
			local variables   "variable"
		}

		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as txt "{p 0 4 2}"
		di as smcl as txt "(imputed `variables'"
		di as smcl as res "`return(imputed_nf)'"
		di as smcl as txt "not found in using data;{break}"
		di as smcl as txt "added `imputations' `contain'"
		di as smcl as txt "{it:m}=0 values for `those' `variables')"
		di as smcl as txt "{p_end}"
	}
	restore, not
end

program mi_add_error1
	args n
	di as err "`n' obs. in master not found in using"
	exit 459
end

program mi_add_error2
	args n
	di as err "`n' obs. in using not found in master"
	exit 459
end
