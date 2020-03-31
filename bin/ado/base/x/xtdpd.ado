*! version 1.6.0  21jun2018
program define xtdpd, eclass byable(onecall) prop(xt xtbs)

	local vv : display "version " string(_caller()) ", missing:"
	version 10
	qui _datasignature
	local datasig "`r(datasignature)'"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if "`e(cmd)'" != "xtdpd"  & "`e(engine)'" != "xtdpd"  | {
			error 301
		}	
		if _by() { 
			error 190 
		}
		syntax [, Level(cilevel) *]
		HDisplay , level(`level') cmd(`e(cmd)') `options'
		exit
	}

	local orig `"`0'"'

	syntax  anything [if] [in] , *

	`vv' `BY' Estimate `anything' `if' `in' , `options' datasig(`datasig')
	 ereturn local cmdline `"xtdpd `orig'"'
end

program Estimate, eclass sortpreserve byable(recall)

	local vv : display "version " string(_caller()) ", missing:"
	
	version 10
	qui xtset
	local ivar `r(panelvar)'
	local tvar `r(timevar)'
        local tsdeltal `: char _dta[_TSdelta]'

	local tmin  `r(tmin)'
	local tmax  `r(tmax)'

        if "`ivar'"=="" {
                di as err "must specify panelvar and timevar; use xtset"
                exit 459
        }
        
        if "`tvar'" == "" {
                di as err "must specify timevar; use xtset"
                exit 459
        }

	tempname tsdelta
	scalar `tsdelta' = `tsdeltal'


	syntax  varlist(ts numeric) [if] [in] , 	///
		datasig(string)				/// undocumented
		[					///
		TWOstep					///
		noCONStant				///
		Hascons					///
		FODeviation				///
		VCE(passthru)				///
		Level(cilevel)				///
		ARtests(numlist integer max=1 >=0)	///
		DIFFVars(varlist ts numeric)		/// undocumented  
		DIfference				/// undocumented 
		xtabond					/// undocumented 
		xtdpdsys				/// undocumented 
		diffsmp					/// undocumented
		vsquish					///
		COEFLegend				///
		selegend				///
		NOLSTRETCH				///
		*					///
		]

	_get_diopts diopts, `vsquish' `coeflegend' `selegend' `nolstretch'

// hascons implies only check for collinearity among levels
// of indeps, by default checks occur at levels and differences

// diffsmp causes the e(sample) to correspond to the difference equation
// observations, e(N) to be the number of observations on the difference
// equation, and the sample stats to be computed using the diff eq obs

/*  Repeatable options parsed below
		DGmmiv(string)					///
		LGmmiv(string)					///
		IV(string)					///
		DIv(string)					///
		LIV(string)					///
*/
	
	_vce_parse, opt(GMM Robust) :, `vce' 
	local robust `r(robust)'
	local vce = cond("`r(vce)'" != "", "`r(vce)'", "gmm")	

	if "`xtabond'" != "" & "`xtdpdsys'" != "" {
		di "{err}specify {cmd:xtabond} or {cmd:xtdpdsys}, not both"
		exit 198
	}

	marksample touse			// varlist-if/in sample
	markout `touse' `ivar' `tvar'

	 if _by() {
                qui replace `touse' = 0 if `_byindex' != _byindex()
        }

	tempvar touse2
	qui gen byte `touse2' = 1
	markout `touse2' `varlist' `ivar' `tvar'

	tempvar tvar2 tvarint same
	qui gen double `tvar2'   = (`tvar'-`tmin'+`tsdelta')/`tsdelta'
	qui gen double `tvarint' =  int(`tvar2')

	qui gen byte `same' = `tvar2'==`tvarint'	
	qui count if `same' != 1
	if r(N)>0 {
		di "{err}normalized time variable contains noninteger values"
		exit 498
	}


//  Begin Parse section
	gettoken depvar indeps: varlist

	if "`constant'" == "" {
		tempvar _cons
		qui gen double `_cons' = 1 
	}	

						// parse transform()
	if "`fodeviation'`difference'" != "" {
		if "`fodeviation'" != "" & "`difference'" != "" {
			di "{err}specify either {cmd:fodeviation} "	///
				"or {cmd:difference}, not both"
			exit 498	
		}	
		if "`fodeviation'" != "" {
			local transform fodeviation
		}
		else {
			local transform difference
		}
	}
	else {
		local transform difference
	}
		
// ********************  Begin parsing instruments
							// parse dgmmiv
	dgmmiv_parse_main  , `options'
	local options `"`r(options)'"'
	local dgmmiv_varlist `r(dgmmiv_varlist)'
	local dgmmiv_flag    `r(dgmmiv_flag)' 
	local dgmmiv_llag    `r(dgmmiv_llag)' 

// check that dgmmiv options are specified, code requires them

	if "`dgmmiv_varlist'" == "" {
		di as err "dgmmiv() is required"
		exit 198
	}

							// parse lgmmiv()
	lgmmiv_parse_main  , `options'
	local options `"`r(options)'"'
	local lgmmiv_varlist `r(lgmmiv_varlist)'
	local lgmmiv_flag    `r(lgmmiv_flag)' 

							// Parse div()
	div_parse_main , `options' 				
	local options `"`r(options)'"'
	local div_only_dvars `r(div_dvars)'
	local div_only_lvars `r(div_lvars)' 

							// Parse liv()
	liv_parse_main , `options' 				
	local options `"`r(options)'"'
	local liv_only_lvars `r(liv_lvars)' 

							// Parse iv()
	iv_parse_main2 , `options' 				
	local options `"`r(options)'"'
	local iv_varlist `r(iv_varlist)'
	local iv_diff    `r(iv_diff)'
	
	local _ls_1 "`varlist' `dgmmiv_varlist'  `liv_only_lvars'"
	local _ls_2 "`div_only_lvars' `iv_varlist' `iv_diff' `div_only_dvars'"
	local _ls_3 "`lgmmiv_varlist' "
	local _ls_0 "`_ls_1' `_ls_2' `_ls_3' "
	local _ls_0: list uniq _ls_0

// ********************  End parsing instruments

// All options parsed, anything left is a syntax error

	local options2 : subinstr local options " " "", all
	if `"`options2'"' != "" {
		di as err "option `options2' not allowed"
		exit 198
	}

	if "`transform'" != "difference" & 				///
		"`lgmmiv_varlist'`liv_only_lvars'`iv_varlist'" != "" {
		di as err "forward-orthogonal-difference transform "	///
			"not allowed with system estimator"
		exit 498
	}	

// ********************  update sample for instruments

	markout `touse' `div_only_lvars' `iv_varlist' `liv_only_lvars'
	markout `touse' `div_only_dvars' 

	tempvar gapcnt stouse ntvar stouse2
	qui by `ivar': gen `stouse' = sum(`touse')
	qui gen byte `gapcnt' = (L.`stouse'!=`stouse'-1)
	qui by `ivar': replace `gapcnt' = 0 if _n==1
	qui by `ivar': replace `gapcnt' = 0 if `stouse'==0

	qui gen double `ntvar' = -`tvar'	
	sort `ivar' `ntvar'
	qui by `ivar': gen `stouse2' = sum(`touse')
	qui by `ivar': replace `gapcnt' = 0 if `stouse2'==0
	sort `ivar' `tvar'
	qui count if `gapcnt'==1

	if r(N) > 0 {
		local gaps gaps
	}	

	if "`transform'" == "fodeviation" & "`gaps'" == "gaps" {
		di "{err}{cmd:fodeviation} is not allowed "	///
			"when there are gaps in the data"
		exit 498	
	}

	markout `touse2' `div_only_lvars' `iv_varlist' `liv_only_lvars'
	markout `touse2' `div_only_dvars' 

	
// ********************  Begin collinearity section

						// drop collinear variables
						// from dgmmiv()

// RMCOLL_dgmmiv drops based on first differences
	RMCOLL_dgmmiv `dgmmiv_varlist' if `touse', 	///
		flag(`dgmmiv_flag')			///
		llag(`dgmmiv_llag')			///

	local dgmmiv_varlist `r(dgmmiv_varlist)'
	local dgmmiv_flag    `r(dgmmiv_flag)' 
	local dgmmiv_llag    `r(dgmmiv_llag)'

						// repeat check in case
						// variables are collinear
						// with constant
	if "`dgmmiv_varlist'" == "" {
		di as err "dgmmiv() is a required option"
		exit 198
	}
						// drop collinear variables
						// from lgmmiv()

	RMCOLL_lgmmiv `lgmmiv_varlist' if `touse', 	///
		flag(`lgmmiv_flag') 

	local lgmmiv_varlist `r(lgmmiv_varlist)'
	local lgmmiv_flag    `r(lgmmiv_flag)' 

					// hascons does not apply because 
					// these instruments only appear
					// in the difference equation

	RMCOLL_list `div_only_dvars' if `touse', noconstant 	///
		name(div) difference
	local div_only_dvars `r(varlist)'

	RMCOLL_list `div_only_lvars' if `touse', `constant' name(div)
	local div_only_lvars `r(varlist)'

						// drop collinear variables
						// from liv()
	if "`hascons'" != "" {
		local con_livonly noconstant
	}	
	RMCOLL_list `liv_only_lvars' if `touse', name(liv) `con_livonly'
	local liv_only_lvars `r(varlist)'


	RMCOLL_iv_list `iv_varlist' if `touse', `constant' iv_diff(`iv_diff')
	local iv_varlist `r(iv_varlist)'
	local iv_diff    `r(iv_diff)'

	local vi 1
	foreach v of local iv_varlist {
		local diffi : word `vi' of `iv_diff'

		if "`diffi'" == "difference" {
			local iv_diff_varlist `iv_diff_varlist' `v'
		}
		else {
			local iv_nodiff_varlist `iv_nodiff_varlist' `v'
		}
		local ++vi
	}

	if "`hascons'" == "" {
		RMCOLL_iv_list `iv_diff_varlist' if `touse', 	///
			`constant' difference
		local iv_diff_varlist `r(iv_varlist)'
	}

	foreach v of local iv_diff_varlist {
		local div_dvars `div_dvars' `v'
		local liv_lvars `liv_lvars' `v'
	}

	foreach v of local iv_nodiff_varlist {
		local div_lvars `div_lvars' `v'
		local liv_lvars `liv_lvars' `v'
	}

	
	rmcoll2list , alist(`div_dvars') blist(`div_only_dvars') 	///
		name(div) touse(`touse')
	local div_only_dvars `r(blist)'

	rmcoll2list , alist(`div_lvars') blist(`div_only_lvars') 	///
		name(div) touse(`touse')
	local div_only_lvars `r(blist)'

	rmcoll2list , alist(`liv_lvars') blist(`liv_only_lvars') 	///
		name(liv) touse(`touse')
	local liv_only_lvars `r(blist)'

	_rmcoll `indeps' if `touse' , `constant'
	local indeps `r(varlist)'

	if "`hascons'" == "" {
		tsunab dvlist : D.(`indeps') 
		_rmcoll `dvlist' if `touse' , `constant'
		local kept `r(varlist)'
		local i 0
		foreach v of local dvlist {
			local ++i
			local in : list v in kept
			if `in' {
				local v2 : word `i' of `indeps'
				local indeps2 `indeps2' `v2'
			}
		}
		local indeps `indeps2'
	}	

	if "`diffvars'" != "" {
		_rmcoll `diffvars' if `touse' , `constant'
		local diffvars `r(varlist)'

		rmcoll2list , alist(`indeps') blist(`diffvars') 	///
		name(diffvars) touse(`touse')
		local diffvars `r(blist)'
	}

// ********************  End collinearity section

						// Section for constant 
	if "`constant'" == "" {
		local liv_only_lvars `liv_only_lvars' `_cons'
	}

// ******************** Begin computing all transforms 

	
	tempname Ddepvar
	diffvars `depvar', newvars(`Ddepvar') `transform' 	///
		touse(`touse') ivar(`ivar') tvar(`tvar')	///
		touse2(`touse2')

	tsunab indeps_test : `indeps'
	if "`constant'" == "" {
		local indeps_names `indeps_test' `diffvars' _cons 
	}
	else {
		local indeps_names `indeps_test' `diffvars' 
	}	

	local i 1
	foreach v of local indeps {
		tempvar Dindepvar`i'
		local Dindeps `Dindeps' `Dindepvar`i''
		local ++i
	}
	diffvars `indeps' , newvars(`Dindeps') touse(`touse')		///
		`transform' ivar(`ivar') tvar(`tvar') touse2(`touse2')

	local Dindeps `Dindeps' `diffvars'

	if "`transform'" == "fodeviation" {
		local i 1
		foreach v of local indeps {
			tempvar FDvar`i'
			local FDvars `FDvars' `FDvar`i''
			local ++i
		}
		diffvars `indeps' , newvars(`FDvars') touse(`touse')	///
			difference ivar(`ivar') tvar(`tvar') touse2(`touse2')

		local FDvars `FDvars' `diffvars'

		tempname FDdepvar
		diffvars `depvar', newvars(`FDdepvar') difference 	///
			touse(`touse') ivar(`ivar') tvar(`tvar')	///
			touse2(`touse2')
	}

	if "`constant'" == "" {
		tempvar D_cons
		diffvars `_cons' , newvars(`D_cons') touse(`touse')	///
		     `transform' ivar(`ivar') tvar(`tvar') touse2(`touse2')
		local Dindeps `Dindeps' `D_cons'
		local indeps `indeps' `_cons'
		if "`transform'" == "fodeviation" {
			tempvar FD_cons
			diffvars `_cons' , newvars(`FD_cons') 		///
				touse(`touse') difference ivar(`ivar')	///
				tvar(`tvar') touse2(`touse2')
			local FDvars `FDvars' `FD_cons'
		}
	}


	local k : word count `Dindeps'


	local i 1
	foreach v of local div_dvars {
		tempvar div_dvar`i'
		local Ddiv_dvars `Ddiv_dvars' `div_dvar`i''
		local ++i
	}
	diffvars `div_dvars', newvars(`Ddiv_dvars') touse(`touse')	///
		ivar(`ivar') tvar(`tvar') `transform' touse2(`touse2')

	local i 1
	foreach v of local div_only_dvars {
		tempvar div_only_dvar`i'
		local Ddiv_only_dvars `Ddiv_only_dvars' `div_only_dvar`i''
		local ++i
	}
	diffvars `div_only_dvars', newvars(`Ddiv_only_dvars') 		///
		touse(`touse') `transform' ivar(`ivar') tvar(`tvar')	///
		touse2(`touse2')
		
// ******************** End computing all transforms 

// ******************** Determine touse_deq from transformed variables

	tempvar touse_deq 
	qui gen byte `touse_deq' = 1
	markout `touse_deq' `Dindeps' `div_dvars' `div_only_dvars' `Ddepvar'
	qui count if `touse_deq'
	if `r(N)' == 0 {
		di as err "no observations"
		exit 2000
	}

// *************** Begin determine included equations and instruments

	if "`constant'" == "" {
		local level_eq 1
	}
	else {
		if "`liv_lvars'`lgmmiv_varlist'`liv_only_lvars'" == "" {
			local level_eq 0
		}
		else {
			local level_eq 1
		}
	}

	if `level_eq' & "`diffvars'" != "" {
                display as error "option {bf:diffvars()} specified" ///
                        " incorrectly"
                di as err "{p 4 4 2}" 
                di as smcl as err "{bf:diffvars()} may not be specified"
                di as smcl as err " if the model has a constant or you " 
                di as smcl as err " specify instruments for level equations." 
                di as smcl as err "{p_end}"             
                exit 498 
	}

	if "`div_dvars'`div_lvars'" == "" {
		local div_in 0
	}
	else {
		local div_in 1
	}
				
	if "`div_only_dvars'`div_only_lvars'" == "" {
		local div_only_in 0
	}
	else {
		local div_only_in 1
	}
				
	if "``liv_only_lvars'" == "" {
		local liv_only_in 0
	}
	else {
		local liv_only_in 1
	}
				

	if "`liv_lvars'" == "" {
		local liv_in 0
	}
	else {
		local liv_in 1
	}

// *************** End determine included equations and instruments
				
	tempvar Ti
	if `level_eq' & "`diffsmp'" == "" {
		qui count if `touse'
		qui by `ivar': gen `Ti' = sum(`touse')
	}
	else {
		qui count if `touse_deq'
		qui by `ivar': gen `Ti' = sum(`touse_deq')
	}
	local ni=r(N)

	qui by `ivar': replace `Ti' = . if _n<_N | `Ti'[_N]==0
	qui sum `Ti', meanonly
	local N_g   = r(N)
	local g_min = r(min)
	local g_max = r(max)
	local g_avg = r(mean)
	qui by `ivar': replace `Ti' = `Ti'[_N]
	
	tempvar ti2 tweight Ltweight
	qui by `ivar': gen `ti2'  = sum(`touse_deq')
	qui gen double `tweight'  = -sqrt( (`Ti'-`ti2'+2)/(`Ti'-`ti2'+1) )
	qui gen double `Ltweight' = sqrt( (`Ti'-`ti2'+1)/(`Ti'-`ti2'+2))
	qui replace `Ltweight' = 0 if `ti2'<0

	if "`artests'" == "" {
		local artests = min(2, `g_max')
	}	

	if `artests'>0 & `artests'> `g_max' {
		di "{p}{err}artests() cannot exceed the number of "	///
			"time periods{p_end}"
		exit 498	
	}	


						// make time variables,
						// panel info matrix
						// and tinfo matrix 

	tempvar tvar_w tvar_ab
	tempname tinfo info


	_mkPinfo  , tvar_w(`tvar_w') tvar_ab(`tvar_ab')		///
		info(`info') ivar(`ivar')	///
		tvar(`tvar2') touse_deq(`touse_deq')
	local maxTi = r(maxTi)	

	qui tab `tvar_ab' if `touse_deq', matrow(`tinfo')

	local myperiods = rowsof(`tinfo')
	matrix `tinfo' = `tinfo' \ .

	local dgmmiv_varlist_n : word count `dgmmiv_varlist'
	tempname tinfoc
	mata: `tinfoc' = J(`myperiods'+1, 1 + 3*`dgmmiv_varlist_n', .)
	mata: `tinfoc'[.,1] = st_matrix("`tinfo'")[.,1]

	local i 0
	foreach var0 of local dgmmiv_varlist {
		local ++i 
		local flag0 : word `i' of  `dgmmiv_flag'
		local llag0 : word `i' of  `dgmmiv_llag'
		local llag0 = min(`llag0', _N)

/*
		_update_tinfob `var0', tinfo(`tinfo') flag(`flag0') 	///
			llag(`llag0') periods(`myperiods') 		///
			tvar(`tvar_ab') ivar(`ivar')	
*/

		mata: _xtdpd_update_tinfoi(`info', `flag0', `llag0',	///
			`i', `myperiods', "`tvar_ab'", `tinfoc')

	}	
	local nzvars = `i'

	mata: st_matrix("`tinfo'", `tinfoc')

	local tr = rowsof(`tinfo')

	mata: st_local("zcols", strofreal(sum(st_matrix("`tinfo'")[`tr',.] )))

	qui count if `touse_deq' >0
	local zrows = r(N)

	if `level_eq' {
		tempname z_lev w_lev q_lev l_iv z_L
		tempname zlev_info
		tempvar touse_leq  lev_cnt

		qui by `ivar': gen `lev_cnt' = sum(`touse')
		qui by `ivar': replace `lev_cnt' = `lev_cnt'[_N]

		if "`twostep'" == "" & "`robust'" == "" {
			local artests 0
		}

		local i 1
		foreach lv of local lgmmiv_varlist {
			tempvar lgmmiv_var`i' touse_var`i'
			local lgmmiv_dvars `lgmmiv_dvars' `lgmmiv_var`i''
			local lgmmiv_tousei `lgmmiv_tousei' `touse_var`i''
		}	

		_mkzlevinfo `lgmmiv_varlist' ,			///
			z_L(`z_L') touse_leq(`touse_leq')  	///
			tvar_ab(`tvar_ab') touse(`touse')	///
			ivar(`ivar') zlev_info(`zlev_info')	///
			lgmmiv_flag(`lgmmiv_flag')		///
			lgmmiv_dvars(`lgmmiv_dvars')		///
			lgmmiv_tousei(`lgmmiv_tousei')		///
			transform(difference) tvar(`tvar')
		local zlevrows = r(N)

	}
	else {

		local zlevrows = 0
	}
	
	tempname b v s rss zrank artestsv sargan warn
	tempvar  ar_en wit Lu_fod 

	`vv' mata: _xtdpd_dowork("`Dindeps'",	///
		"`Ddepvar'",			///
		"`touse_deq'",			///
		"`Ddiv_dvars'",			///
		"`div_dvars'",			///
		"`Ddiv_only_dvars'",		///
		"`div_only_dvars'",		///
		"`div_lvars'",			///
		"`div_only_lvars'",		///
		`level_eq',			///
		"`indeps'",			///
		"`touse'",			///
		"`touse_leq'",			///
		"`depvar'",			///
		"`tinfo'",			///
		"`ivar'",			///
		"`tvar_w'",			///
		"`tvar_ab'",			///
		"`dgmmiv_varlist'",		///
		`zrows',			///
		`zcols',			///
		"`info'",			///
		`nzvars',			///
		`div_only_in',			///
		"`lgmmiv_varlist'",		///
		`zlevrows',			///
		"`liv_lvars'",			///
		"`liv_only_lvars'",		///
		`div_in',			///
		`liv_in',			///
		`ni',				///
		`k',				///
		"`twostep'",			///
		"`robust'",			///
		"`b'",				///
		"`v'",				///
		"`s'",				///
		"`rss'",			///
		"`zrank'",			///
		"`transform'",			///
		"`ar_en'",			///
		`artests',			///
		"`artestsv'",			///
		"`sargan'",			///
		"`FDvars'",			///
		"`FDdepvar'",			///
		"`tweight'",			///
		"`Ltweight'",			///
		`g_max',			///
		"`wit'",			///
		"`Lu_fod'",			///
		"`lev_cnt'",			///
		`maxTi',			///
		"`warn'")
		
	mata: mata drop `info'

	if ( `warn'== 1 ){
		di as err  ///
		"variance-covariance matrix of the two-step estimator" ///
			"is not full rank" 
                di as txt "{p 4 4 4}" 
		di as smcl as err "Two-step estimator is not available."
		di as smcl as err "One-step estimator is available and " ///
				  "variance-covariance matrix provides"	 ///
				  " correct coverage." 
		di as smcl as err "{p_end}"
		exit 198
       }

	matrix colnames `b' = `indeps_names'
	matrix rownames `b' = `depvar'
	matrix colnames `v' = `indeps_names'
	matrix rownames `v' = `indeps_names'

	if `level_eq' {

		local smp `touse'
	}	
	else {
		local smp `touse_deq'
	}

	capture mata: mata drop _DPD_LEQinfo
	ereturn post `b' `v', esample(`smp') depname(`depvar') buildfvinfo
	_post_vce_rank

	if "`fodeviation'" == "" {
		scalar `s' = .5*`s'
	}

	ereturn scalar sig2 = (`s')
	ereturn scalar rss   = `rss'
	ereturn scalar N     = `ni'
	ereturn scalar N_g   = `N_g'
	ereturn scalar g_min = `g_min'
	ereturn scalar g_max = `g_max'
	ereturn scalar g_avg = `g_avg'
	ereturn scalar t_min = `tmin'
	ereturn scalar t_max = `tmax'

	ereturn local twostep `twostep'
	if "`robust'" != "" {
		if "`twostep'" != ""  {
			ereturn local vcetype "WC-Robust"
		}
		else {
			ereturn local vcetype Robust
		}	
		ereturn local vce     robust
	}	
	else {
		ereturn local vce     `vce'
	}

	if `level_eq' {
		ereturn local system system
	}	

	ereturn local datasignature `datasig'
	ereturn local datasignaturevars `_ls_0'

	ereturn hidden local div_odvars `div_only_dvars'
	ereturn hidden local div_olvars `div_only_lvars' 

	if "`_cons'" != "" {
		local liv_only_lvars : subinstr local liv_only_lvars	///
			"`_cons'" "_cons", word
	}		
	ereturn hidden local liv_olvars `liv_only_lvars'

	ereturn hidden local div_dvars `div_dvars'
	ereturn hidden local div_lvars `div_lvars' 

	ereturn hidden local liv_lvars `liv_lvars' 
	
	ereturn hidden local dgmmiv_vars `dgmmiv_varlist'
	ereturn hidden local dgmmiv_flag `dgmmiv_flag'
	ereturn hidden local dgmmiv_llag `dgmmiv_llag'

	ereturn hidden local lgmmiv_vars `lgmmiv_varlist'
	ereturn hidden local lgmmiv_lag  `lgmmiv_flag' 

	ereturn local diffvars `diffvars'
	
	ereturn local ivar `ivar'
	ereturn local tvar `tvar'
	if ("`hascons'" != "") {
		if ("`xtabond'"!="" | "`xtdpdsys'"!="") {
			ereturn hidden local hascons hascons
		}
		else {
			ereturn local hascons hascons		
		}
	}
	ereturn local transform `transform'
	ereturn local depvar `depvar'

	qui test `indeps_test'
	ereturn scalar chi2 = r(chi2)
	ereturn scalar df_m = r(df)
	ereturn scalar zrank = `zrank'
	ereturn scalar artests = `artests'

	if `artests'>0 {
		forvalues i = 1/`artests' {
			ereturn scalar arm`i' = `artestsv'[1,`i']
		}	
	}

	if "`robust'" == "" 	{
		ereturn scalar sargan = `sargan'
	}

	ereturn local predict 	"xtdpd_p"
	ereturn local marginsok "XB default"
	ereturn local estat_cmd "xtdpd_estat"
	ereturn hidden local engine 	xtdpd

	if "`xtabond'" != "" {
		local cmd xtabond
	}
	else if "`xtdpdsys'" != "" {
		local cmd xtdpdsys
	}
	else {
		local cmd xtdpd
	}
	ereturn local cmd "`cmd'"
	
							// display results	

	HDisplay, level(`level') cmd(`cmd') `diopts'

end

program define _update_tinfoc

	syntax varlist(ts max=1), tinfo(name)  flag(real) llag(real) 	///
		periods(real) tvar(varname) ivar(varname) info(name)	///
		varnumber(real)


	mata: st_local("ni", strofreal(rows(`info')))
	mata: st_local("tvar_ind", strofreal(st_varindex("`tvar'")))

	forvalues i = 1/`periods' {
		mata: st_local("tau", strofreal(`tinfo'[`i',1]))

		mata: _update_tinfod(`info', `ni', `tau', `flag',	/// 
			`llag', `tvar_ind', `i', `varnumber', `tinfo')

	}
	mata: `tinfo'[`p', 2+(`varnumber'-1)*3] =		///
		sum(`tinfo'[|1,2+(`varnumber'-1)*3 \		/// 
		.,2+(`varnumber'-1)*3|] )
end

program define _update_tinfob

	syntax varlist(ts max=1), tinfo(name)  flag(real) llag(real) 	///
		periods(real) tvar(varname) ivar(varname)

	tempname w	

	tempvar tin 
	qui gen `tin' = .
	local p = `periods'+1
	matrix `w' = J(`p',3,.)
	local sum = 0
	forvalues i = 1/`periods' {

		local tau = `tinfo'[`i',1]
		
		qui by `ivar': replace `tin' = cond(		///
			(`tvar'<=`tau'-`flag' &			///
		 	 `tvar'>=`tau'-`llag' )			///
			,1 , 0)
		qui by `ivar': replace `tin' = sum(`tin')
		qui by `ivar': replace `tin' = cond(_n==1, `tin'[_N], .)

		qui sum `tin', meanonly
		local val = r(max)
		matrix `w'[`i',1] = `val'
		local sum = `sum' + `val'
		matrix `w'[`i',2] = `flag'
		matrix `w'[`i',3] = `val' + `flag' - 1

	}
	matrix `w'[`p',1] = `sum'
	matrix colnames `w' = `varlist'_total `varlist'_first `varlist'_last

	matrix `tinfo' = `tinfo', `w'
	
end

/*
// updates tinfo matrix with number of available instruments for each 
// time period for GMM-type instruments 

program define _update_tinfo

	syntax varlist(ts), tinfo(name)  flag(real) llag(real) 	///
		periods(real) tvar(varname) ivar(varname)

	tempname w	

	tempvar tin 
	qui gen `tin' = .
	local p = `periods'+1
	matrix `w' = J(`p',3,.)
	local sum = 0
	forvalues i = 1/`periods' {

		local tau = `tinfo'[`i',1]
		
		qui by `ivar': replace `tin' = cond(		///
			(`tvar'<=`tau'-`flag' &			///
		 	 `tvar'>=`tau'-`llag' )	///
			,1 , 0)
		qui by `ivar': replace `tin' = sum(`tin')
		qui by `ivar': replace `tin' = cond(_n==1, `tin'[_N], .)

		qui sum `tin'
		local val = r(max)
		matrix `w'[`i',1] = `val'
		local sum = `sum' + `val'
		matrix `w'[`i',2] = `flag'
		matrix `w'[`i',3] = `val' + `flag' - 1

	}
	matrix `w'[`p',1] = `sum'
	matrix colnames `w' = `varlist'_total `varlist'_first `varlist'_last

	matrix `tinfo' = `tinfo', `w'
	
end
*/

program define dgmmiv_parse, rclass

	syntax varlist(ts numeric), [Lagrange(string) ]

	if `"`lagrange'"' != "" {
		gettoken first last:lagrange
		capture confirm integer number `first'
		if _rc {
di as err `"{p}invalid {cmd:lagrange()} in dgmmiv(`0'){p_end}"'
exit 498
		}
		if `"`last'"' != "" {
						// clear spaces
			capture local last `last'		
			
			if `"`last'"' != "." {

				capture confirm integer number `last'
				if _rc {
di as err `"{p}invalid {cmd:lagrange()} in dgmmiv(`0'){p_end}"'
exit 498
				}
			}	
		}
		else {
			local last .
		}	

	}
	else {
		local first 2
		local last  .
	}

	if `first' >=. {
di as err `"{p}invalid {cmd:lagrange()} in dgmmiv(`0'){p_end}"'
exit 498
		
	}

	if `last' < `first' {
		di "{err}last lag cannot be less than first lag"
		di "{err}{cmd:dgmmiv(`0')} invalid"
		exit 198
	}


	foreach var of local varlist {
		local flag `flag' `first'
		local llag `llag' `last'
	}


	return local varlist `varlist'
	return local flag    `flag'
	return local llag    `llag'

end

program define div_parse, rclass

	syntax varlist(ts numeric), [ noDIfference]

	if "`difference'" == "" {
		local difference	difference
	}	

	return local varlist 	`varlist'
	return local difference	`difference'

end

program define liv_parse_main , rclass
	
	syntax [anything(name=junk)], [ LIv(string) LIv1(string) * ]
	if "`liv'" == "" & "`liv1'" != "" {
		di "{err}{cmd:liv()} invalid"
		exit 198
	}	
	if "`liv1'" != "" {
		local back liv(`liv1')
	}	
	local 0 `", `back' `options'"'

	while `"`liv'"' != "" {
		liv_parse `liv'
		local liv_lvars `liv_lvars' `r(varlist)'
		
		syntax [anything(name=junk)], [ LIv(string) LIv1(string) * ]
		if "`liv'" == "" & "`liv1'" != "" {
			di "{err}{cmd:liv()} invalid"
			exit 198
		}	
		if "`liv1'" != "" {
			local back liv(`liv1')
		}	
		else {
			local back 
		}
		local 0 `", `back' `options'"'
	}

	return local options   `"`options'"'
	return local liv_lvars `liv_lvars' 
end


program define liv_parse, rclass

	syntax varlist(ts numeric),  *
	
	if "`options'" != "" {
		di "{err}options not allowed in {cmd:liv()}"
		exit 101
	}

	return local varlist `varlist'

end

program define div_parse_main , rclass
	
	
	syntax [anything(name=junk)], [ DIv(string) DIv1(string) * ]
	if "`div'" == "" & "`div1'" != "" {
		di "{err}{cmd:div()} invalid"
		exit 198
	}	
	if "`div1'" != "" {
		local back div(`div1')
	}	
	else {
		local back 
	}
	local 0 `", `back' `options'"'

	while `"`div'"' != "" {
		div_parse `div'
		if "`r(difference)'" == "difference" {
			local div_dvars `div_dvars' `r(varlist)'
		}
		else {
			local div_lvars `div_lvars' `r(varlist)'
		}
		
		syntax [anything(name=junk)], [ DIv(string) DIv1(string) * ]
		if "`div'" == "" & "`div1'" != "" {
			di "{err}{cmd:div()} invalid"
			exit 198
		}	
		if "`div1'" != "" {
			local back div(`div1')
		}	
		else {
			local back 
		}
		local 0 `", `back' `options'"'
	}

	return local options   `"`options'"'
	return local div_dvars `div_dvars'
	return local div_lvars `div_lvars' 
end

program define dgmmiv_parse_main , rclass

	syntax [anything(name=junk)], [ DGmmiv(string) DGmmiv1(string) * ]
	if "`dgmmiv'" == "" & "`dgmmiv1'" != "" {
		di "{err}{cmd:dgmmiv()} invalid"
		exit 198
	}
	if "`dgmmiv1'" != "" {
		local back dgmmiv(`dgmmiv1')
	}	
	local 0 `", `back' `options'"'

	while `"`dgmmiv'"' != "" {
		dgmmiv_parse `dgmmiv'
		local dgmmiv_varlist `dgmmiv_varlist' `r(varlist)'
		local dgmmiv_flag    `dgmmiv_flag'    `r(flag)'
		local dgmmiv_llag    `dgmmiv_llag'    `r(llag)'

		syntax [anything(name=junk)], 			///
			[					///
			DGmmiv(string) 				///
			DGmmiv1(string) 			///
			* 					///
			]
		if "`dgmmiv'" == "" & "`dgmmiv1'" != "" {
			di "{err}{cmd:dgmmiv()} invalid"
			exit 198
		}
		if "`dgmmiv1'" != "" {
			local back dgmmiv(`dgmmiv1')
		}	
		else {
			local back 
		}
		local 0 `", `back' `options'"'
	}

	return local options 	   `"`options'"'
	return local dgmmiv_varlist `dgmmiv_varlist'
	return local dgmmiv_flag    `dgmmiv_flag' 
	return local dgmmiv_llag    `dgmmiv_llag' 

end

program define lgmmiv_parse, rclass

	syntax varlist(ts numeric), [Lag(integer 1) * ]

	if "`options'" != "" {
		di "{err}`options' not allowed in lgmmiv()"
		exit 198
	}	
	

	if `lag' < 0 {
		di as error "{cmd:lag()} must specify a nonnegative integer"
		exit 498
	}	

	foreach var of local varlist {
		local laglist `laglist' `lag'
	}

	return local varlist  `varlist'
	return local flag     `laglist'

end

program define biv_parse2, rclass

	syntax varlist(ts numeric), 				///
		[						///
		noDIfference 					///
		]

	if "`difference'" == "" {
		local difference difference
	}	

	local nvars : word count `varlist'
	if `nvars' > 1 {
		mata: st_local("difference", 			///
			`nvars'*(st_local("difference") + " "))
	}
	return local iv_varlist  `varlist'
	return local iv_diff     `difference'

end


program define biv_parse, rclass

	syntax varlist(ts numeric), 				///
		[						///
		noDIfferencedeq 				///
		]

	if "`differencedeq'" == "nodifferencedeq" {
		local div_lvars `varlist'
	}
	else {
		local div_dvars `varlist'
	}

	local liv_lvars `varlist'

	return local div_dvars `div_dvars'
	return local div_lvars `div_lvars'
	return local liv_lvars `liv_lvars'

end

program define iv_parse_main2 , rclass
	
	syntax [anything(name=junk)], [ iv(string) IV1(string) * ]
	if "`iv'" == "" & "`iv1'" != "" {
		di "{err}{cmd:iv()} invalid"
		exit 198
	}	
	if "`iv1'" != "" {
		local back iv(`iv1')
	}	
	local 0 `", `back' `options'"'

	while `"`iv'"' != "" {
		biv_parse2 `iv'

		local iv_varlist  `iv_varlist' `r(iv_varlist)'
		local iv_diff     `iv_diff'    `r(iv_diff)'

		syntax [anything(name=junk)], [ iv(string) iv1(string) * ]
		if "`iv'" == "" & "`iv1'" != "" {
			di "{err}{cmd:iv()} invalid"
			exit 198
		}	
		if "`liv1'" != "" {
			local back liv(`liv1')
		}	
		else {
			local back 
		}
		local 0 `", `back' `options'"'
	}

	return local options   `" `options' "'
	return local iv_varlist  `iv_varlist' 
	return local iv_diff     `iv_diff'    
end

program define lgmmiv_parse_main , rclass

	syntax [anything(name=junk)], [ LGmmiv(string) LGmmiv1(string) * ]
	if "`lgmmiv'" == "" & "`lgmmiv1'" != "" {
		di "{err}{cmd:lgmmiv()} invalid"
		exit 198
	}
	if "`lgmmiv1'" != "" {
		local back lgmmiv(`lgmmiv1')
	}	
	local 0 `", `back' `options'"'

	while `"`lgmmiv'"' != "" {
		lgmmiv_parse `lgmmiv'
		local lgmmiv_varlist `lgmmiv_varlist' `r(varlist)'
		local lgmmiv_flag    `lgmmiv_flag'    `r(flag)'

		syntax [anything(name=jk)], [ LGmmiv(string) LGmmiv1(string) * ]
		if "`lgmmiv'" == "" & "`lgmmiv1'" != "" {
			di "{err}{cmd:lgmmiv()} invalid"
			exit 198
		}
		if "`lgmmiv1'" != "" {
			local back lgmmiv(`lgmmiv1')
		}	
		else {
			local back 
		}
		local 0 `", `back' `options'"'
	}

	return local options 	   `"`options'"'
	return local lgmmiv_varlist `lgmmiv_varlist'
	return local lgmmiv_flag    `lgmmiv_flag' 

end

program define _mkPinfo, rclass  
	
	syntax , 				///
		tvar_w(name)	 		///
		tvar_ab(name) 			///
		info(name)			///
		ivar(varname)			///
		tvar(varname)			///
		touse_deq(varname)		

	qui sum `tvar' if `touse_deq', meanonly
	local t0 = r(min)
	local tn = r(max)

	qui gen double `tvar_ab' = `tvar' - `t0'

	qui sum `tvar_ab', meanonly
	local maxTi = r(max) + 1

	qui gen double `tvar_w' = .
						// info is now Ni by 5
						// first ob for panel i
						// sec ob for panel i
						// first ob with period to 
						// 	instrument
						// first period to instrument
						// number of periods to
						// 	instrument
	local vlist `ivar' `tvar' `touse_deq' `tvar_ab'
	
	mata: _xtdpd_getpinfo("`vlist'", "`tvar_w'", `info'=., `maxTi')

	return scalar maxTi = `maxTi'

end	


program define _mkzlevinfo, rclass
	
		syntax  [ varlist(ts numeric default=none) ] , 		///
			[ 			///
			lgmmiv_flag(string) 	///
			lgmmiv_dvars(namelist)	///
			lgmmiv_tousei(namelist)	///
			] 			///
			z_L(name)		///
			touse_leq(name)		///
			tvar_ab(varname)	///
			touse(varname)		///
			ivar(varname)		///
			zlev_info(name)		///
			transform(string)	///
			tvar(varname)

		
		local lgmmiv_varlist `varlist'
		

		if "`lgmmiv_varlist'" != ""  {
		
			local lgmmiv_nvars : word count `lgmmiv_varlist'
			mata: _xtdpd_initialize_info(`lgmmiv_nvars')
	
			qui gen `touse_leq'  = 0

//  touse is model touse and touse_leq determines observations
//    to be included in level equation
			tempvar work
			local i 1
			foreach lv of local lgmmiv_varlist {
				capture drop `work'
				local vari   : word `i' of `lgmmiv_dvars'
				local tousei : word `i' of `lgmmiv_tousei'
				local m : word `i' of `lgmmiv_flag'
				if "`transform'" == "difference" {
qui gen double `vari' =  L`m'D.`lv' 
				}
				else {
diffvars `lv', newvars(`work') `transform' 	///
	touse(`touse') ivar(`ivar') tvar(`tvar')
qui gen double `vari' = L`m'.`work'	
				}
				qui gen `tousei' = (`vari'<. & `touse')
				qui tab `tvar_ab' if `tousei',	///
					matrow(colperiods)
				mata: _xtdpd_fillin_info(`i', 		///
					"`vari'",		///
					"`tousei'", 		///
					(st_matrix("colperiods")') )
				qui replace `touse_leq' = 		///
				    	( `touse_leq' |  `tousei')
					
				local ++i
			}

		}	

		qui count if `touse'
		local N = r(N)
		return scalar N = `N'

end

program define RMCOLL_lgmmiv, rclass

	syntax [varlist(ts numeric default=none)] [if] [in], 		///
		[							///
		flag(string)						///
		]


	if "`varlist'" != "" {
		marksample touse 

		tsunab vlist : D.(`varlist')

		qui _rmcoll `vlist' if `touse' , noconstant

		local nvars : word count `vlist'

		local rmcolllist `r(varlist)'
		local drop : list vlist - rmcolllist
		
		local di       1
		local vi       1
		local getdrop  1

		foreach v of local vlist {
			if `getdrop' {
				local dvar : word `di' of `drop'
				local ++di
				local getdrop  0
			}
			
			if "`v'" == "`dvar'" {
				di as txt "note: `v' dropped from "	///
					"lgmmiv() because of collinearity"
				local getdrop  1
			}
			else {
				local nvar  : word `vi' of `varlist'
				local nflag : word `vi' of `flag'

				local lgmmiv_varlist2 `lgmmiv_varlist2' `nvar'
				local lgmmiv_flag2    `lgmmiv_flag2'    `nflag'

			}

			local ++vi
		}
	}

	return local lgmmiv_varlist `lgmmiv_varlist2'
	return local lgmmiv_flag    `lgmmiv_flag2' 

end

program define RMCOLL_dgmmiv, rclass

	syntax varlist(ts numeric) [if] [in],		 		///
		flag(string)						///
		llag(string)

	marksample touse 

	tsunab vlist : D.(`varlist')

	qui _rmcoll `vlist' if `touse' , noconstant
	local rmcolllist `r(varlist)'
	local drop : list vlist - rmcolllist
		
	local di       1
	local vi       1
	local getdrop  1

	foreach v of local vlist {
		if `getdrop' {
			local dvar : word `di' of `drop'
			local ++di
			local getdrop  0
		}
			
		if "`v'" == "`dvar'" {
			local nvar  : word `vi' of `varlist'
			di as txt "note: `nvar' dropped from "	///
				"dgmmiv() because of collinearity"
			local getdrop  1
		}
		else {
			local nvar  : word `vi' of `varlist'
			local nflag : word `vi' of `flag'
			local nllag : word `vi' of `llag'

			local dgmmiv_varlist2 `dgmmiv_varlist2' `nvar'
			local dgmmiv_flag2    `dgmmiv_flag2'    `nflag'
			local dgmmiv_llag2    `dgmmiv_llag2'    `nllag'

		}

		local ++vi
	}

	return local dgmmiv_varlist `dgmmiv_varlist2'
	return local dgmmiv_flag    `dgmmiv_flag2' 
	return local dgmmiv_llag    `dgmmiv_llag2' 

end


program define RMCOLL_iv_list, rclass

	syntax [varlist(ts numeric default=none)] [if] , 	///
		[						///
		iv_diff(string)					///
		noCONStant 					///
		DIfference					///
		]						///

	if "`varlist'" == "" {
		exit
	}	
	
	
	if "`difference'" == "" {
		local vlist  `varlist'
	}
	else {
		tsunab vlist : D.(`varlist')
	}

	qui _rmcoll `vlist' `if', `constant' 
	local left0 `r(varlist)'
	local drop : list vlist - left0

	local di       1
	local vi       1
	local getdrop  1

	foreach v of local vlist {
		if `getdrop' {
			local dvar : word `di' of `drop'
			local ++di
			local getdrop  0
		}
			
		if "`v'" == "`dvar'" {
			local nvar  : word `vi' of `varlist'
			di as txt "note: `nvar' "	///
				"dropped from iv()" ///
				" because of collinearity"
			local getdrop  1
		}
		else {
			local nvar   : word `vi' of `varlist'
			local ndiff  : word `vi' of `iv_diff'
			local iv_varlist2 `iv_varlist2' `nvar'
			local iv_diff2    `iv_diff2'    `ndiff'
		}

		local ++vi
	}


	return local iv_varlist `iv_varlist2'
	return local iv_diff    `iv_diff2'

end



program define RMCOLL_list, rclass

	syntax [varlist(ts numeric default=none)] [if] , 	///
		name(name)					///
		[						///
		DIfference					///
		noCONStant 					///
		]						///

	if "`name'" == "" {
		local nme  from
	}
	else {
		local nme "from `name'()"
	}
	if "`varlist'" != "" {
		if "`difference'" == "" {
			qui _rmcoll `varlist' `if', `constant' 
			local left `r(varlist)'
			local drop : list varlist - left
			if "`drop'" != "" {
				foreach v of local drop {
					di as txt "note: `v' dropped "	///
					   "`nme' because of "	///
					   "collinearity"
				}
			}
		}
		else {
			tsunab vlist : D.(`varlist')
			qui _rmcoll `vlist' `if', `constant' 
			local left0 `r(varlist)'
			local drop : list vlist - left0

			local di       1
			local vi       1
			local getdrop  1

			foreach v of local vlist {
				if `getdrop' {
					local dvar : word `di' of `drop'
					local ++di
					local getdrop  0
				}
					
				if "`v'" == "`dvar'" {
					local nvar  : word `vi' of `varlist'
					di as txt "note: `nvar' "	///
						"dropped `nme' " ///
						"because of collinearity"
					local getdrop  1
				}
				else {
					local nvar  : word `vi' of `varlist'
					local left `left' `nvar'
				}

				local ++vi
			}

		}
	}

	return local varlist `left'

end

program define HDisplay
	
	syntax , level(cilevel) cmd(string) ///
		[vsquish coeflegend selegend NOLSTRETCH]

	_get_diopts diopts, `vsquish' `coeflegend' `selegend' `nolstretch'
	if "`cmd'" == "xtabond" {
		local title "Arellano-Bond dynamic panel-data estimation"
	}
	else if "`cmd'" == "xtdpdsys" {
		local title "System dynamic panel-data estimation"
	}
	else {
		local title "Dynamic panel-data estimation" 
	}

	di 
	di as txt "`title'"			///
		"{col 49}Number of obs{col 67}= " as res %10.0fc e(N)
	di as txt "Group variable: " as res abbrev("`e(ivar)'",12)	///
		as txt "{col 49}{txt}Number of groups{col 67}= " 	///
		as res %10.0fc e(N_g)
	di  as txt "Time variable: " as res abbrev("`e(tvar)'", 12)
	local df = e(df_m)
	
	di as txt _col(49) "Obs per group:"
	di as txt _col(63) "min" _col(67) "= "				///
		as res %10.0fc e(g_min)  

        di as txt _col(63) "avg" _col(67) "=  "				///
                as res %9.0gc e(g_avg)  			

        di as txt _col(63) "max" _col(67) "= "				///
                as res %10.0fc e(g_max)  _n
		
	di as txt  "Number of instruments =  "				///
			as res %5.0g `e(zrank)' 			///
		 "{txt}{col 49}Wald chi2(" as res "`df'"		///
		as txt"){col 67}=  " as res %9.2f e(chi2)
	di as txt "{col 49}Prob > chi2" _col(67) "="			///
                        _col(73) as res %6.4f chiprob(e(df_m),e(chi2)) 

	if "`e(twostep)'" != "" {
                di as txt "Two-step results"
        }                
        else {
                di as txt "One-step results"
        }       
	
	ereturn display, level(`level') `diopts'
	local w = `"`s(width)'"'
	capture {
		confirm integer number `w'
	}
	if c(rc) {
		local w 78
	}
	local w = min(`w', `c(linesize)')
	local rmargin = c(linesize) - `w' + 2

	tempname rhold
	_return hold `rhold'

        if "`e(twostep)'" != "" & "`e(vce)'" != "robust" {
                di "{txt}Warning: gmm two-step standard "	///
			"errors are biased; robust standard "
		di "{col 10}errors are recommended."
       }

	getgmmdiff
	local gmmdiff `r(inst)'

	getstddiff
	local stddiff `r(inst)'

	getgmmL
	local gmmL `r(inst)'

	getstdL
	local stdL `r(inst)'

	di "{txt}Instruments for differenced equation"
	di "{p 8 18 `rmargin'}{txt}GMM-type: {res}`gmmdiff'{p_end}"

	if "`stddiff'" != "" {
		di "{p 8 18 `rmargin'}{txt}Standard: {res}`stddiff'{p_end}"
	}

	if "`e(system)'" != "" {
		di "{txt}Instruments for level equation"
		if "`gmmL'" != "" {
			di "{p 8 18 `rmargin'}{txt}GMM-type: {res}`gmmL'{p_end}"
		}	

		if "`stdL'" != "" {
			di "{p 8 18 `rmargin'}{txt}Standard: {res}`stdL'{p_end}"
		}
	}

	if "`e(transform)'" == "fodeviation" {
		di "{txt}(All differences are forward-orthogonal deviations)"
	}
	_return restore `rhold'
	

end

program define getgmmdiff, rclass


	local nvars : word count `e(dgmmiv_vars)'

	forvalues i = 1/`nvars' {
		local v    : word `i' of `e(dgmmiv_vars)'
		local flag : word `i' of `e(dgmmiv_flag)'
		local llag : word `i' of `e(dgmmiv_llag)'

		tsunab work : `v'
		local inst `inst' L(`flag'/`llag').`work'
	}
	
	return local inst `inst'

end

program define getstddiff, rclass

	local cp `e(div_odvars)' `e(div_dvars)'
	foreach v of local cp {
		local work : tsnorm D.`v' , varname
		local inst `inst' `work'
	}
	
	local cp `e(div_olvars)' `e(div_lvars)'
	foreach v of local cp {
		local work : tsnorm `v' , varname
		local inst `inst' `work'
	}

	return local inst `inst'

end

program define getgmmL, rclass

	local nvars : word count `e(lgmmiv_vars)'

	forvalues i=1/`nvars' {
		local v : word `i'  of `e(lgmmiv_vars)'
		local f : word `i'  of `e(lgmmiv_lag)'
		
		tsunab work : L`f'.D.`v'
		local inst `inst' `work'
	}

	return local inst `inst'

end

program define getstdL, rclass

	local cp `e(liv_lvars)' `e(liv_olvars)'
	foreach v of local cp {
		local work : tsnorm `v' , varname
		local inst `inst' `work' 
	}

	return local inst `inst'

end

program define diffvars, rclass

	syntax  [ varlist(ts numeric default=none)], 	///
		[ newvars(namelist)			///
		  FODeviation 				///
		  DIfference				///
		  touse(varname)			///
		  touse2(varname)			///
		  ivar(varname)				///
		  tvar(varname)				///
		]

	if "`varlist'" == "" {
		exit
	}
	local n1 : word count `varlist'
	local n2 : word count `newvars'

	if `n1' != `n2' {
		di "{err}number of new variables differs from " /// 
			"number of variables"
		exit 498	
	}

	if "`fodeviation'" == "" {
		tempvar tmp
		local i = 1
		foreach v of local varlist {
			local newv : word `i' of `newvars'
			qui gen double `newv' = D.`v' if `touse'
			local ++i
		}
	}
	else {
		_xtdpd_xtfod `varlist', nvarlist(`newvars') 		///
			touse(`touse')	ivar(`ivar') tvar(`tvar')	///
			touse2(`touse2')
	}

end

// This program takes two lists of linearly independent variables
// and checks for collinearity in the union of the two lists.  Collinear
// variables are removed from the second list.

program define rmcoll2list, rclass

	syntax , 					///
		[					///
		alist(varlist ts) 			///
		blist(varlist ts) 			///
		]					///
		name(string)				///
		touse(varname)

	if "`alist'" == ""  {
		return local blist `blist'
		exit
	}

	if "`blist'" == "" exit

	local full `alist' `blist'
	local remove : list blist & alist
	foreach v of local remove {
		di "{txt}note: `v' dropped from `name'() due to collinearity"
	}
	local blist : list blist - remove
	local full `alist' `blist'

	qui _rmcoll `full' if `touse', noconstant 
	local dropped `r(varlist)'

	local same : list full == dropped
	if !`same' {
		local ndivs  : word count `alist'
		mata: _xtdpd_rmcoll2(`ndivs', "full", "`touse'")
		local blist `full'
	}	
	
	return local blist `blist'
end


