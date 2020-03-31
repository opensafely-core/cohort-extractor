*! version 1.0.2  03jun2013

/*
	mi append using <filename> [, 	GENerate(<newvarname>) 
					noLabel
					noNOTEs
					FORCE

					noUPdate
				   ]

	N.B., -append-'s option keep(varlist) is not supported.

	Master must be -mi set-.
	Using not required to be -mi -set-.

	Returns
	   scalars:
		r(N_master)	# of obs. 
		r(N_using)      # of obs.
		r(M_master)	# of imputations in master
		r(M_using)	# of imputations in using
	   macros:
		r(newvars)     new variables added

	Note, resulting values are 
		N = r(N_master) + r(N_using)
		k = k_master + word count `r(newvars)'
		M = max(r(M_master), r(M_using))
*/

program mi_cmd_append, rclass
	version 11.0

	u_mi_assert_set
	syntax using/ [, GENerate(string) noLabel noNOTEs FORCE noUPdate]
	local appendopts `label' `notes' `force'
	local origusing "`using'"

	if ("`generate'"!="") { 
		confirm new var `generate'
	}

	u_mi_get_flongsep_tmpname master : __miappendm
	u_mi_get_flongsep_tmpname using  : __miappendu
	u_mi_get_flongsep_tmpname result : __miappendr

	capture noisily mi_append_u "`origusing'" ///
				    "`generate'" "`update'" `"`appendopts'"' ///
				     `master' `using' `result'
	nobreak {
		local rc = _rc
		return add
		mata: u_mi_flongsep_erase("`master'", 0, 0)
		mata: u_mi_flongsep_erase("`using'" , 0, 0)
		mata: u_mi_flongsep_erase("`result'", 0, 0)
	}
	exit `rc'
end

program mi_append_u, rclass
	args origusing generate noupdate appendopts master using result


	/* ------------------------------------------------------------ */
					/* original master in memory	*/
	qui u_mi_certify_data, acceptable proper `noupdate'

	local m_style `_dta[_mi_style]'
	if ("`m_style'"=="flongsep") {
		local m_style "flongsep `_dta[_mi_name]'"
	}

	local m_fn   "`c(filename)'"
	local m_ivars `_dta[_mi_ivars]'
	local m_pvars `_dta[_mi_pvars]'
	local m_rvars `_dta[_mi_rvars]'
	local m_M    `_dta[_mi_M]' 

	preserve 


	/* ------------------------------------------------------------ */
					/* original using in memory	*/
	qui use "`origusing'", clear 
	capture u_mi_assert_set
	if _rc { 
		qui mi set mlong
	}
	if ("`generate'"!="") { 
		capture confirm new var `generate'
		if (_rc) { 
			di as err ///
			"variable `generate' already defined in using data"
			exit 459
		}
	}
	qui u_mi_certify_data, acceptable proper `noupdate'

	local u_ivars `_dta[_mi_ivars]'
	local u_pvars `_dta[_mi_pvars]'
	local u_rvars `_dta[_mi_rvars]'
	local u_M    `_dta[_mi_M]' 

	/* ------------------------------------------------------------ */
					/* calculate result summaries	*/
	local r_ivars : list m_ivars | u_ivars
	local m_pvars : list m_pvars - r_ivars
	local u_pvars : list u_pvars - r_ivars
	local m_rvars : list m_rvars - r_ivars
	local u_rvars : list u_rvars - r_ivars

	local r_pvars : list m_pvars | u_pvars
	local m_rvars : list m_rvars - r_pvars
	local u_rvars : list u_rvars - r_pvars

	local r_rvars : list m_rvars | u_rvars

	local r_M    = max(`m_M', `u_M')

	mi_append_disjoint "`r_ivars'" "`r_pvars'" "`r_rvars'"
	mi_append_message imputed "`m_ivars'" "`r_ivars'"
	mi_append_message passive "`m_pvars'" "`r_pvars'"
	mi_append_message regular "`m_rvars'" "`r_rvars'"

	return scalar M_master = `m_M'
	return scalar M_using = `u_M'

	/* ------------------------------------------------------------ */
					/* obtain flongsep using	*/
					/* orig using still in memory  */

	quietly {
		mi convert flongsep `using', clear noupdate
		mi set M = `r_M'
		save "`using'", replace
		return scalar N_using = _N

		unab u_vars : _all
	}

	/* ------------------------------------------------------------ */
					/* obtain flongsep master	*/

	restore, preserve
	quietly {
		mi convert flongsep `master', clear noupdate
		mi set M = `r_M'
		save "`master'", replace
		return scalar N_master = _N

		unab m_vars : _all
	}
	/* ------------------------------------------------------------ */
					/* fill in r(newvars)		*/
	local newvars : list u_vars - m_vars
	return local newvars `newvars'
	local newvars
	local m_vars
	local u_vars

	/* ------------------------------------------------------------ */
					/* append			*/
	
	_mi_append_u2 `r_M' "`master'" "`using'" "`result'" ///
				"`generate'" `"`appendopts'"'
	qui use "`result'", clear 
	u_mi_zap_chars
	char _dta[_mi_marker] "_mi_ds_1"
	char _dta[_mi_style]  "flongsep"
	char _dta[_mi_name]   `result'
	char _dta[_mi_M]      `r_M'
	char _dta[_mi_N]      `=_N'
	char _dta[_mi_ivars]  `r_ivars'
	char _dta[_mi_pvars]  `r_pvars'
	char _dta[_mi_rvars]  `r_rvars'
	char _dta[_mi_update]
	qui mi convert `m_style', clear replace
	global S_FN "`m_fn'"
	u_mi_fixchars, proper
	restore, not
end

program mi_append_disjoint 
	args ivars pvars rvars

	local bad1 : list ivars & pvars 
	local bad2 : list ivars & rvars
	local bad3 : list pvars & rvars

	local bad `bad1' `bad2' `bad3'
	if ("`bad'"=="") {
		exit
	}
	local bad : list uniq bad
	local n  : word count `bad'
	local variables = cond(`n'==1, "variable", "variables")
	di as err as smcl "{p}"
	di as smcl as err "`variables' `bad'"
	di as smcl as err "registered inconsistently in master and using data"
	di as smcl as err "{p_end}"
	exit 459
end

program mi_append_message
	args regtype m_vars r_vars

	local new : list r_vars - m_vars 
	if ("`new'"=="") {
		exit
	}
	local n : word count `new'
	local variables = cond(`n'==1, "variable", "variables")
	di as txt as smcl "{p}"
	di as smcl "(`variables' `new'"
	di as smcl "now registered as `regtype')"
	di as smcl "{p_end}"
end

program _mi_append_u2
	args M master using result gen appendopts
				/* master data imputation 0 in memory */

	_mi_append_myappend "`using'" "`gen'" `"`appendopts'"'
	u_mi_zap_chars
	qui save "`result'", replace

	forvalues i=1(1)`M' {
		qui use _`i'_`master', clear 
		_mi_append_myappend "_`i'_`using'" "`gen'" `"`appendopts'"'
		u_mi_zap_chars
		char _dta[_mi_marker]  "_mi_ds_1"
		char _dta[_mi_style]   "flongsep_sub"
		char _dta[_mi_name]    "`result'"
		char _dta[_mi_m]       `i'
		qui save _`i'_`result', replace 
	}
end

program _mi_append_myappend
	args using gen appendopts

	quietly {
		local N  = _N
		local Np1 = _N+1
		append using "`using'", `appendopts'
		if (_N>`N') {
			replace _mi_id = _mi_id + `N' in `Np1'/l
		}
		if ("`gen'"!="") {
			gen byte `gen' = cond(_n<=`N', 0, 1)
		}
	}
end
