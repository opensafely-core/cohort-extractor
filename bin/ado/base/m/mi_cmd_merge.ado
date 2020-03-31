*! version 1.0.4  09feb2015

/*
	mi merge <mtype> <varlist> using <filename>, [
			ASSERT(passthru)
			FORCE
			GENerate(<newvarname>) 
			KEEP(passthru)
		     noLABEL
		     noNOTES
		     noREPort
		     noUPdate

	<mtype> may be 1:1, 1:m, m:1, m:m

	mi merge <varlist> using <filename> [, GENerate(<newvarname> noUPdate]

	using data not required to be -mi set-

	Returns
	   macro:
		r(newvars)	new variables added

	   scalar:
		r(N_master)	# of original obs. in master
		r(N_using)	# of original obs. in using
		r(N_result)	# of original obs in merged result 

		r(M_master)    # of imputations in master
		r(M_using)     # of imputations in using
		r(M_result)    # of imputations in new

	Results are:

		N =  r(N_result)
		k =  k_master + word count `r(newvars)'
		M =  max(r(M_master), r(M_using))
*/



program mi_cmd_merge, rclass
	version 11.0

	u_mi_assert_set
	gettoken mtype 0 : 0, parse(" ")
	mi_merge_chk_mtype "`mtype'"

	syntax varlist using/ [, GENerate(string) noUPdate FORCE ///
		ASSERT(passthru) KEEP(passthru) noLabel noNOTEs noREPort ]
	u_mi_no_sys_vars "`varlist'" "{it:varlist}"

	local origusing `"`using'"'
	local meropts `"`assert' `keep' `label' `notes' `report' `force'"'

	if ("`generate'"!="") { 
		confirm new var `generate'
	}
	else {
		local meropts `"`meropts' nogen"'
	}

	u_mi_get_flongsep_tmpname master : __mimergem
	u_mi_get_flongsep_tmpname using  : __mimergeu
	u_mi_get_flongsep_tmpname result : __mimerger

	capture noisily mi_merge_u "`mtype'" "`varlist'" "`report'" ///
				   "`origusing'" ///
				   "`generate'" "`update'"  ///
				   `master' `using' `result' ///
				   `"`meropts'"'
	nobreak {
		local rc = _rc
		return add
		mata: u_mi_flongsep_erase("`master'", 0, 0)
		mata: u_mi_flongsep_erase("`using'", 0, 0)
		mata: u_mi_flongsep_erase("`result'", 0, 0)
	}
	return add
	exit `rc'
end


program mi_merge_u, rclass
	args mtype keys report origusing generate noupdate ///
			master using result meropts

	local sys_vars "_mi_m _mi_miss _mi_id"

	/* ------------------------------------------------------------ */
					/* original master in memory	*/
	tempname msgno
	qui u_mi_certify_data, acceptable proper msgno(`msgno') `noupdate'

	local m_style `_dta[_mi_style]'
	if ("`m_style'"=="flongsep") {
		local m_style "flongsep `_dta[_mi_name]'"
	}

	local m_fn   "`c(filename)'"
	local m_ivars `_dta[_mi_ivars]'
	local m_pvars `_dta[_mi_pvars]'
	local m_rvars `_dta[_mi_rvars]'
	local m_M     `_dta[_mi_M]' 

	unab m_vars : _all
	preserve 


	/* ------------------------------------------------------------ */
					/* original using in memory	*/
	qui use "`origusing'", clear 
	capture u_mi_assert_set
	if _rc { 
		mi set flong 
		tempfile origusing 
	}
	capture confirm var `keys'
	if (_rc) { 
		local n : word count `keys'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "`variables' `keys' not found"
		di as smcl as err "{p_end}"
		exit 111
	}

	if ("`generate'"!="") { 
		capture confirm new var `generate'
		if (_rc) { 
			di as err ///
			"variable `generate' already defined in using data"
			exit 459
		}
	}
	qui u_mi_certify_data, acceptable proper msgno(`msgno') `noupdate'

	local u_ivars `_dta[_mi_ivars]'
	local u_pvars `_dta[_mi_pvars]'
	local u_rvars `_dta[_mi_rvars]'
	local u_M     `_dta[_mi_M]' 

	unab u_vars : _all

	/* ------------------------------------------------------------ */
					/* returned results		*/
	local r_M    = max(`m_M', `u_M')

	return scalar M_master = `m_M'
	return scalar M_using  = `u_M'
	return scalar M_result = `r_M'

	if (`r_M'>`m_M') {
		di as txt "(M increased from `m_M' to `r_M')"
	}

	local r_newvars : list u_vars - m_vars
	local r_newvars : list r_newvars - sys_vars
	return local newvars `r_newvars' `generate'
	/* ------------------------------------------------------------ */
					/* calculate result summaries	*/

	local new    : list u_ivars & r_newvars
	local r_ivars : list m_ivars | new

	local new    : list u_pvars & r_newvars
	local r_pvars : list m_pvars | new

	local new    : list u_rvars & r_newvars
	local r_rvars : list m_rvars | new

	/* 
	  r_ivars, r_pvars, r_rvars must be disjoint because
	  (1) m_ivars, m_pvars, m_rvars were disjoint and 
	  (2) u_ivars, u_pvars, u_rvars were disjoint, 
          and all that was added to m_* was NEW vars from u_*
	*/

	/* now display msg about new registered variables */
	if ("`report'"=="") {
		mi_merge_message imputed "`m_ivars'" "`r_ivars'"
		mi_merge_message passive "`m_pvars'" "`r_pvars'"
		mi_merge_message regular "`m_rvars'" "`r_rvars'"
	}


	/* we still have issue if new obs are added */
	/* r1_ivars are possible new ivars if newobs */
	/* r1_pvars are possible new pvars if newobs */
	local r1_ivars : list u_ivars - r_ivars

	local r1_pvars : list  u_pvars - r_pvars
	local r1_pvars : list r1_pvars - r_ivars
	local r1_pvars : list r1_pvars - m_ivars

	/* ------------------------------------------------------------ */
					/* obtain flongsep using	*/
					/* orig using still in memory  */

	quietly {
		mi convert flongsep `using', clear noupdate
		mi set M = `r_M'
		save "`using'", replace

		return scalar N_using = _N
	}


	/* ------------------------------------------------------------ */
					/* obtain flongsep master	*/

	restore, preserve
	quietly {
		mi convert flongsep `master', clear noupdate
		mi set M = `r_M'
		save "`master'", replace

		return scalar N_master = _N
	}
	/* ------------------------------------------------------------ */
					/* merge m=0 & produce mapping  */
	if ("`generate'"!="") {
		local genop generate(`generate')
	}

	tempvar masterid usingid
	tempfile ufile
	quietly {
		use "`using'", clear 
		rename _mi_id `usingid'
		save "`ufile'", replace

		use "`master'", clear 
		rename _mi_id `masterid'

		noi merge `mtype' `keys' using `"`ufile'"', `genop' `meropts'

		gen `c(obs_t)' _mi_id = _n
		compress _mi_id 

		sort _mi_id
	}
	quietly count if `masterid'==.
	if (r(N)) {
		mi_merge_fixlist r1_ivars : `masterid' == "`r1_ivars'"
		mi_merge_fixlist r1_pvars : `masterid' >= "`r1_pvars'"

		local r_rvars : list r_rvars - r1_ivars
		local r_rvars : list r_rvars - r1_pvars

		local r_pvars : list r_pvars - r1_ivars
		local r_pvars : list r_pvars | r1_pvars

		local r_ivars : list r_ivars | r1_ivars

		if ("`report'"=="") {
			mi_merge_mention imputed "`r1_ivars'" 
			mi_merge_mention passive "`r1_pvars'"
		}
	}

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
	qui save "`result'"

	tempfile map_m_dta map_u_dta
	mi_merge_makemaps anynew ///
			"`map_m_dta'" "`map_u_dta'" : `masterid' `usingid'
	/* mi_merge_makemaps drop data in memory */
		
	/* ------------------------------------------------------------ */
					/* now merge the other datasets */
	forvalues m=1(1)`r_M' {
		quietly {
			use _`m'_`using', clear 
			mi_merge_prep `usingid' "`map_u_dta'"
			save "`ufile'", replace

			use _`m'_`master', clear 
			mi_merge_prep `masterid' "`map_m_dta'"

			merge 1:1 _mi_id using "`ufile'", sorted nogen ///
						noreport force

			u_mi_zap_chars
			char _dta[_mi_marker]  "_mi_ds_1"
			char _dta[_mi_style]   "flongsep_sub"
			char _dta[_mi_name]    "`result'"
			char _dta[_mi_m]       `m'

			save _`m'_`result'
		}
	}
	/* ------------------------------------------------------------ */

	qui use "`result'", clear 
	drop `masterid' `usingid'
	qui mi convert `m_style', clear replace
	global S_FN "`m_fn'"
	u_mi_fixchars, proper
	restore, not
end

program mi_merge_mention
	args word vars 
	if ("`vars'"=="") {
		exit
	}
	local n : word count `vars'
	local variables = cond(`n'==1, "variable", "variables")
	local contain   = cond(`n'==1, "contains", "contain")

	di as txt
	di as smcl as txt "{p 4 4 2}"
	di as smcl as txt "(existing `variables'"
	di as smcl as res "`vars'"
	di as smcl as txt ///
	"now registered as `word' because  registered as `word' in using"
	di as smcl as txt ///
	"and `contain' missing in unmatched-but-kept using obs.)"
	di as smcl as txt "{p_end}"
end

program mi_merge_fixlist 
	args listname colon masterid op list
	quietly {
		local newlist
		foreach v of local list {
			count if (`v' `op' .) & `masterid'==.
			if (r(N)) {
				local newlist `newlist' `v'
			}
		}
	}
	c_local `listname' `newlist'
end

/*
	mi_merge_makemaps  <anynew> <ds1> <ds2> : <oldmid> <olduid>

	merged m=0 data is now in memory.

	Create <ds1> and <ds2> for mapping master and using datasets.
	<oldmid> and <olduid> are original _mi_id vars of master and using

	<anynew> is a macro name; it will be filled in with 
		1 -> new obs. included from using
		0 -> no new obs. 

	Data in memory is dropped rather then preserved
*/

program mi_merge_makemaps
	args anynewname mapmasterdta mapusingdta  colon  masterid usingid
	tempfile packeddta

	quietly { 
		u_mi_zap_chars
		keep `masterid' `usingid' _mi_id
		save "`packeddta'"

		count if `masterid'==.
		c_local anynew = (r(N)>0)

		keep `masterid' _mi_id
		sort `masterid' _mi_id
		save "`mapmasterdta'"

		use "`packeddta'", clear
		keep `usingid' _mi_id
		sort `usingid' _mi_id
		save "`mapusingdta'"
	}
	drop _all
end

program mi_merge_prep
	args oldid mapdta

	quietly {
		rename _mi_id `oldid'
		sort `oldid'
		merge 1:n `oldid' using "`mapdta'", ///
				sorted keep(match) nogen norep nonotes
		drop `oldid'
		sort _mi_id
	}
end

program mi_merge_chk_mtype
	args mtype
	if ("`mtype'"=="1:1" | ///
	   "`mtype'"=="1:m" | ///
	   "`mtype'"=="m:1" | ///
	   "`mtype'"=="m:m" | ///
	   "`mtype'"=="1:n" | ///
	   "`mtype'"=="n:1" | ///
	   "`mtype'"=="n:n" ) {
		exit
	}
	di as smcl as err "merge `mtype': invalid {it:mtype}"
	di as smcl as err "{p 4 4 2}"
	di as smcl as err "{it:mtype} must be 1:1, 1:m, m:1, or m:m"
	di as smcl as err "{p_end}"
end


program mi_merge_message
	args regtype m_vars r_vars

	local new : list r_vars - m_vars 
	if ("`new'"=="") {
		exit
	}
	local n : word count `new'
	local variables = cond(`n'==1, "variable", "variables")
	di as smcl as txt "{p}"
	di as smcl as txt "(new `variables'"
	di as smcl as res "`new'"
	di as smcl as txt "registered as `regtype')"
	di as smcl "{p_end}"
end
