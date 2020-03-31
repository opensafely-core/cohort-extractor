*! version 1.2.1  26apr2016
program mi_cmd_impute
	local version : di "version " string(_caller()) ":"
	local caller = _caller()

	version 12

	u_mi_assert_set

	_parse comma lhs rhs : 0
	gettoken method lhs : lhs
	// also sets global macros MI_IMPUTE_user for user methods
	u_mi_impute_check_method method : "`method'"

	local 0 `"`rhs'"'
	syntax , [ noUPdate by(string) * ]
	if (`caller'<12 & `"`by'"'!="") {
		di as err "{p}option by() not allowed with {bf:mi impute}"
		di as err "run under version < 12"
		exit 198
	}
	if (`"`by'"'!="" & $MI_IMPUTE_user) {
		di as err "{p}option {bf:by()} is not allowed"
		di as err "with user-defined imputation methods{p_end}"
		exit 198
	}

	// ensure mi data are acceptable and proper
	u_mi_certify_data, acceptable
	if ("`update'"=="") { 
		u_mi_certify_data, proper
	}
	else if ($MI_IMPUTE_user) {
		di as err "{p}option {bf:noupdate} is not allowed"
		di as err "with user-defined imputation methods{p_end}"
		exit 198
	}
	// check struct. vars (if any)
	u_mi_sets_okay

	_check_opts , `options'

	local style `_dta[_mi_style]'
	// sort data
	if ("`style'"=="mlong" | "`style'"=="flong") {
		local sortvars _mi_m _mi_id
	}
	else if ("`style'"=="wide") {
		tempvar id
		qui gen `c(obs_t)' `id' = _n
		qui compress `id'
		local sortvars `id'
	}
	else if ("`style'"=="flongsep") {
		local sortvars _mi_id
	}
	sort `sortvars'
	if (`"`by'"'!="") {
		_parse_byopts byvars missing nobylegend byopts : `"`by'"'
		// check if ivars or pvars used within by()
		local notallowed `_dta[_mi_ivars]' `_dta[_mi_pvars]'
		local bad : list byvars & notallowed
		if ("`bad'"!="") {
			di as err "{p 0 2 2}{bf:`bad'}: registered as"
			di as err "imputed or passive and used within"
			di as err "{bf:by()}; this is not allowed{p_end}"
			exit 198
		}
		// extract global -if- from `lhs'
		_parse_if if : `"`lhs'"'
		tempvar touse
		mark `touse' `if'
		// create group variable based on m0 and -if-
		tempvar group last
		if ("`style'"=="mlong" | "`style'"=="flong") {
			qui replace `touse' = 0 if _mi_m>0
		}
		local nvars : word count `byvars'
		tempname bylabname
		qui egen long `group' = group(`byvars') if `touse', ///
				`missing' label qlabel lname(`bylabname')
		qui compress `group'
		if ("`style'"=="mlong" | "`style'"=="flong") {
			qui replace `group' = `group'[_mi_id] if _mi_m>0
			sort `group' `sortvars'	
			qui by `group' _mi_m: 	///
					gen byte `last' = (_n==_N) ///
						if `group'<. & `touse'
		}
		else {
			sort `group' `sortvars'	
			qui by `group': gen byte `last' = (_n==_N) ///
							if `group'<. & `touse'
		}
		sort `sortvars'
		//check for all missing categories
		qui summ `last' if `touse', meanonly
		local ngroup = r(sum)
		if (`ngroup'==0) {
			di as err "{p 0 0 2}{bf:mi impute}: {bf:by()}"
			di as err "identifies no groups{p_end}"
			di as err "{p 4 4 2}This may happen when variables"
			di as err "within {bf:by()} contain missing values.  If"
			di as err "you wish to treat missing values as"
			di as err "categories, use"
			di as err "{bf:by({it:varlist}, missing)}{p_end}"
			exit 2000
		}
		local byopts `byopts' by(`group') ngroup(`ngroup')
	}
	else {
		local ngroup = 1
	}

	// create and init. main class object
	cap noi {
		mata: u_mi_get_mata_instanced_var("ImpObj","__mi_imp_obj")
		global MI_IMPUTE_obj `ImpObj'
		cap `version' mata: `ImpObj' = _Imp_`method'_by()
		if _rc { // object for user-defined methods
			`version' mata: `ImpObj' = _Imp_user_by()
		}
		mata: `ImpObj'.init(`ngroup',"`byvars'","`bylabname'",	///
				    "`nobylegend'","`group'")
	}
	local rc = _rc
	if `rc' {
		cap mata: mata drop `ImpObj'
		exit `rc'
	}
	if ("`style'"=="flongsep") {
		local flongsep_prefix u_mi_xeq_on_tmp_flongsep :
	}
	else {
		preserve
	}
	`version' cap noi `flongsep_prefix' _xeq_esthold u_mi_impute, 	///
					impobj(`ImpObj')		///
					method(`method')		///
					lhs(`lhs')			///
					`options'			///
					`byopts'
						  
	local rc = _rc
	local stop "`s(stop)'"	// no imputation performed
	if ("`style'"=="flongsep" & "`stop'"!="") {
		local rc 0
	}
	sret clear
	if ($MI_IMPUTE_user) {
		tempname rres
		_return hold `rres'
		// call user-defined clean up routine (if any)
		cap findfile mi_impute_cmd_`method'_cleanup.ado
		if !_rc {
			cap noi mi_impute_cmd_`method'_cleanup
			if _rc {
				di as err ///
			"in program {bf:mi_impute_cmd_`method'_cleanup}"
				_return restore `rres'
				local rc = _rc
			}
		}
		// unregister and drop missing-value indicators and
		// drop imputation-sample indicators
		cap mi unregister $MI_IMPUTE_user_missvars ///
				  $MI_IMPUTE_user_tousevars
		if ("`style'"=="flongsep") {
			cap mi xeq: drop $MI_IMPUTE_user_missvars ///
					 $MI_IMPUTE_user_tousevars
		}
		else {
			cap drop $MI_IMPUTE_user_missvars ///
				 $MI_IMPUTE_user_tousevars
		}
		_return restore `rres'
	}
	sret clear
	mata: mata drop `ImpObj'
	macro drop MI_IMPUTE*
	cap macro drop MI_IMPUTE_user*

	if ("`style'"!="flongsep" & `rc'==0 & "`stop'"=="") {
		restore, not
	}
	exit `rc'
end

program _check_opts
	syntax [, NOBYREPORT NOBYLEGEND BYERROROK by(string) 	///
		  ngroup(string) * ]

	if ("`nobyreport'"!="") {
		di as err "option `nobyreport' not allowed"
		exit 198
	}
	if ("`byerrorok'"!="") {
		di as err "option `byerrorok' not allowed"
		exit 198
	}
	if (`"`ngroup'"'!="") {
		di as err "option ngroup() not allowed"
		exit 198
	}
	if (`"`by'"'!="") {
		di as err `"{bf:by(`by')} not allowed"'
		exit 198
	}
end

program _parse_byopts
	args byvars miss nobyleg byopts colon by
	local 0 `by'
	cap noi syntax varlist [, MISsing NOREPORT NOLEGend NOSTOP ]
	if _rc {
		di as err ///
		" -- above applies to {bf:mi impute}'s option {bf:by()}"
		exit _rc
	}
	if ("`noreport'"!="") {
		local opts nobyreport
	}
	if ("`nolegend'"!="") {
		local nobylegend nobylegend
	}
	if ("`nostop'"!="") {
		local opts `opts' byerrorok
	}
	c_local `byopts' `opts'
	c_local `byvars' `varlist'
	c_local `miss' `missing'
	c_local `nobyleg' `nobylegend'
end

program _parse_if
	args ifspec colon lhs
	local 0 `lhs'
	syntax [anything(equalok)] [if] [aw fw pw iw]
	c_local `ifspec' `if'
end
