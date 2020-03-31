*! version 1.0.3  22jan2019

program hetoprobit, eclass byable(onecall) properties(svyb svyj svyr bayes)
	version 16
	local vv : di "version " string(_caller()) ":"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'  
	}

	`BY' _vce_parserun hetoprobit, wtypes(fw pw iw) mark(CLuster) : `0'

	if "`s(exit)'" != "" {
		ereturn local cmdline `"hetoprobit `0'"'
		exit
	}

	if replay() {
		if "`e(cmd)'" != "hetoprobit" {
			error 301
		}
		if _by() {
			error 190
		}
		`vv' Replay `0'
		exit
	}
	`vv' `BY' Estimate `0'
	ereturn local cmdline `"hetoprobit `0'"'

end

				//------Replay---------//
program Replay, eclass
	syntax [, Level(cilevel) notable noHeader waldhet *]
	_get_diopts diopts, `options'
	
	// showeqns is needed if no indepvars, o.w. superfluous
	_prefix_display, level(`level') notest ///
		`table' `header' `diopts' showeqns 

	local het_offset "`e(offset2)'"
	if "`het_offset'" != "" {
		// We cannot test H0: lnsigma=0 unless the offset term is
		// constant, and for identifiability we do not allow
		// a constant term.
		di as txt "Note: Test of homoskedasticity is not available when {bf:het()} has an offset term."
		exit
	}

	if "`waldhet'" != "" & "`e(chi2_ct)'" == "LR" {
		// display Wald test for lnsigma=0 but
		// retain original LR hettest stats in stored results
		tempname chi2_c_wald df_m_c_wald p_c_wald
		qui test [lnsigma]
		local chi : di %8.2f r(chi2)
		local chi = trim("`chi'")
		scalar `chi2_c_wald' = `r(chi2)'
		scalar `df_m_c_wald' = r(df)
		scalar `p_c_wald'    = r(p)
		di as txt "Wald test of lnsigma=0: " "chi2(" ///
                   as res `df_m_c_wald' as txt ") = " as res `chi' ///
		   as txt _col(59) "Prob > chi2 = " ///
                   as res %6.4f chi2tail(`df_m_c_wald',`chi2_c_wald')
	}
	else {
		hetoprobit_footnote
	}
end


			//------------Estimate-----------//
program Estimate, eclass byable(recall) 
	local vv : di "version " string(_caller()) ":"
	version 16

	syntax varlist(default=none min=1 numeric fv ts)	///
		[if] [in] [fw iw pw/] 			///
		, het(string)				/// het is required
		[ 					///
		Level(cilevel)				///
		FROM(string)        			/// Model Options
		OFFset(varname numeric)			///
		VCE(passthru)          			///
		notable					/// Replay options
		noHeader				///
		waldhet					///
		noLOg					///
		moptobj(passthru)			///
		* ]                    			//  Maximizer Options 

	// *_c correspond to the comparison model, ie, homoskedastic variance
	// *_0 correspond to the cut-point only heteroskedastic model
	tempname ordinal_vals b_c ll_c chi2_c ll_0 

	_get_diopts diopts options, `options'

	mlopts mlopt, `options'

	local cns   `s(constraints)'
	local coll  `s(collinear)'
	local p_off `offset'

	if "`cns'" != "" {
		local cnsopt constraint(`cns') 
	}

	marksample touse
	
	// parse weight option
	if `"`weight'"'!="" {
		local wgt [`weight'=`exp']
	}
	else {
		local wgt 
	}

	// get indepvar and depvars
	gettoken depvar indepvars: varlist
	// construct marginsdefault string while we're at it
	_fv_check_depvar `depvar'   

	// parse het() option
	local 0 `het'
	syntax varlist(numeric min=1 ts fv) [, OFFset(varname numeric)] 
	local heti `varlist'
	local hetf `offset'
	if "`hetf'" != "" {
		local hetoff "offset(`hetf')"
	}
	local offset ""

	// process predictor offset 
   	if "`p_off'" != "" {
		local offset "offset(`p_off')"
	}

   	if "`p_off'" != "" {
		if "`indepvars'" == "" {
			// hetoprobit does not allow -offset- with no
			// independent variables; constraints can be used
			// in this rare case
			di as err ///
"option {bf:offset()} not allowed with no independent variables"
			exit 198
		}
		else {
			local offset "offset(`p_off')"
		}
	}

	// parse vce
	_vce_parse, argopt(CLuster) opt(OIM Robust OPG) 	///
		pwallowed(Robust CLuster)  			///
		: `wgt', `vce' 

	local cluster `r(cluster)'
	local robust  `r(robust)'

	if "`cluster'" != "" { 
		local clopt "cluster(`cluster')" 
	}

	// force Wald test for heteroskedasticity if robust variance estimator
	if "`robust'`cluster'" != "" {
		local waldhet waldhet
	}

	// markout missing values
	markout  `touse' `depvar' `indepvars' `heti' `hetf' `p_off'

	// markout missing clusterv
	markout `touse' `clusterv', strok

	// error if no available observations
	qui count if `touse'
	if r(N) == 0 {
		error 2000
	}

	// drop collinear variables in the variance equation
	`noi' _rmcoll `heti' if `touse' `wgt', `coll' expand `hetoff'
	local heti_expanded "`r(varlist)'"

	// drop collinear variables in the linear predictor and
	// obtain info about the category values of the dependent variable
	noi _rmcoll `depvar' `indepvars' `wgt' if `touse', ///
		expand `coll' oprobit noskipline `offset'
	local indepvars "`r(varlist)'"
	gettoken dep indepvars: indepvars

	matrix `ordinal_vals' = r(cat)'
	local ncat = r(k_cat)

	if (`ncat' == 1) {
		error 148
	}

	local ncut = `ncat' - 1

	forval i = 1/`ncut' {
		local cuteq `cuteq' /cut`i'
	}

	// control display of estimation logs
	local chatty quietly
	if "`log'" == "" {
		local chatty noisily
	}

			// --- Estimation ---- //

	local evaluator _hetoprobit_lf2()

	local nsigvar: list sizeof heti_expanded
	tempvar yk depcopy
	qui gen `depcopy' = `depvar'
	qui egen int `yk' = group(`depcopy')
	drop `depcopy'

	tempname  b_xb b_lnsigma b_cuts b_init df_xb

	// (1) We use the cutpoint-only oprobit model to prepare initial 
	// conditions for the heteroskedastic cutpoint-only model.  
	// (2) We use the heteroskedastic cutpoint-only model to obtain 
	// null model information for the LR test of the linear predictor,
	// aka mean function.
	// (3) We use the full oprobit model to give starting values
	// for the complete model, and to supply a null value for the LR
	// test of heteroskedasticity.
	// (4) Finally, we fit the full heteroskedastic model.
	// If (1) fails, we continue to (2) without an initial guess at
	// the parameters.  If (2) or (3) fail, we regard the
	// full model as infeasible and assign exit code 491.  
	local feas_err "unable to obtain feasible starting values"

	/* force difficult option in heteroskedastic ML optimizers */
	local diff "difficult"

	// we are dissallowing -offset- if no independent vars, so that the
	// cutpoint-only heteroskedastic model is the same as the full model
if "`indepvars'" != "" {

		// --- fit cutpoint-only heteroskedastic model --- //
	local initopt ""

	capture qui oprobit `depvar' if `touse' `wgt', `cnsopt'
	if _rc {
		if _rc==1 {
			exit 1
		}
	}
	else {
		matrix `b_c'	 		= e(b)
		matrix `b_cuts' 		= `b_c'[1, "/cut1" ...]
		matrix `b_lnsigma' 		= J(1, `nsigvar', 0)
		matrix colnames `b_lnsigma' 	= `heti_expanded'
		matrix coleq `b_lnsigma'	= lnsigma
		matrix `b_init' 		= (`b_lnsigma', `b_cuts')
		local initopt init(`b_init')
	}

nobreak {

	// provide static information about the dependent variable
	// and the model to the ml evaluator
mata: _hetoprobit__userinfo_set("user_info", 		///
				`ncut',			///
				0,			///
				`nsigvar',		///
				`"`yk'"',		///
				`"`touse'"')

	`chatty' di ""
	`chatty' di as text "Fitting cutpoints-only heteroskedastic model:"

capture noisily break {

	// p_off is the offset variable supplied in the main equation.
	// But for the cutpoints-only model we have no main equation;
	// unlike hetprobit, for example, our model has no constant term.  Thus
	// for the cutpoints-only model, we convert the offset to a constraint.
	// We only use the log likelihood and rank from this model, and these 
	// are unchanged by the conversion.
	if "`p_off'" != "" {
		constraint free
		local cnsindex_off `r(free)' 
		constraint `cnsindex_off' `p_off' = 1
		local cns_off `cnsindex_off' `cns'
		local cnsopt_off constraint(`cns_off')
		local main_eq (`dep': `depvar' = `hetf', `cnsopt_off' ///
				noconstant)
	}
	else
	{
		local main_eq
	}

	local var_eq (lnsigma: `depvar'=`heti_expanded', ///
			`hetoff' noconstant)
	`vv'
	ml model lf2 `evaluator'					///
		`main_eq'						///
		`var_eq'						///
		`cuteq'							///
		`wgt' if `touse',					///
		userinfo(`user_info')					///
		missing 						///
		nopreserve 						///
		maximize						///
		`mlopt'							///
		collinear						///
		`log'							///
		search(off)						///
		`clopt'							///
		`robust'						///
		nooutput						///
		`initopt'						///
		title(Heteroskedastic ordered probit model)		///
		`diff'							///
		`moptobj' 
} // capture noisily break

	local rc = _rc

	// don't pollute the workspace with artifacts
	capture mata: rmexternal("`user_info'")
	constraint drop `cnsindex_off'

	if `rc' {
		if `rc' == 1 {
			exit 1
		}
		di as err `"`feas_err'"'
		exit 491 
	}

	// used later for LR test
	scalar `ll_0'	= e(ll)
	local df_0 	= e(rank)

} // nobreak

} // non-null indepvars

			// --- fit the full heteroskedastic model --- //

	// set starting values and retain stats needed for test of
	// heteroskedastic term ...

	`chatty' di ""
	`chatty' di as text "Fitting ordered probit model:"

	capture `chatty' oprobit `depvar' `indepvars' if `touse' `wgt', ///
		`cnsopt' `coll' `offset' noheader notable 

	if _rc | !e(converged) {
		if _rc == 1 {
			exit 1
		}
		di as err `"`feas_err'"'
		exit 491 
	}

	// b_c:    will supply starting values for mean function and cutpoints
	//         if -from()- was not supplied 
	// ll_c & chi2_c:
	//	   full model stats without heteroskedastic equation 
	// ll_0:   model with cutpoints only
	
	matrix `b_c'	= e(b)
	matrix `b_cuts' = `b_c'[1, "/cut1" ...]
	scalar `ll_c'	= e(ll)  
	scalar `chi2_c'	= e(chi2)
	scalar `df_xb'	= e(df_m)
	local rank_c	= e(rank)


	if `"`from'"'!="" { // user-supplied
		local initopt init(`from')
	}
	else {
		// initialize scale parameters to zero
		// cut-point only heteroskedastic lnsigma often fails to
		// give feasible initial values
		matrix `b_lnsigma' = J(1, `nsigvar', 0)
		matrix colnames `b_lnsigma' = `heti_expanded'
		matrix coleq `b_lnsigma' = lnsigma
		matrix `b_init' = (`b_lnsigma', `b_cuts')
		if `"`indepvars'"' != "" {
			matrix `b_xb' = `b_c'[1, "`depvar':"]
			matrix `b_init' = (`b_xb', `b_init')
		}
		local initopt init(`b_init')
	}

	// ... starting values are now set

	if `"`indepvars'"' != "" {
		local main_eq (`dep': `depvar' = `indepvars', `offset' ///
				noconstant)
		local var_eq (lnsigma: `heti_expanded', `hetoff' noconstant)
		if "`offset'" == "" {
			local lf0opt lf0(`df_0' `=`ll_0'')
		}
		else {
			// we don't do LR test when there is an offset
			local lf0opt
		}
	}
	else {
		local main_eq 
		local var_eq (lnsigma: `depvar'=`heti_expanded', ///
			`hetoff' noconstant)
		local lf0opt
	}
nobreak {

	// provide static information about the dependent variable
	// and the model to the ml evaluator
	local nindepvar : list sizeof indepvars
mata: _hetoprobit__userinfo_set("user_info", 		///
				`ncut',			///
				`nindepvar',		///
				`nsigvar',		///
				`"`yk'"',		///
				`"`touse'"')

	`chatty' di ""
	`chatty' di as text "Fitting full model:"

capture noisily break {

	`vv'
	ml model lf2 `evaluator'					///
		`main_eq'						///
		`var_eq'						///
		`cuteq'							///
		`wgt' if `touse',					///
		userinfo(`user_info')					///
		missing 						///
		nopreserve 						///
		maximize						///
		`mlopt'							///
		`log'							///
		`lf0opt'		 				///
		search(off)						///
		`vce'							///
		`clopt'							///
		`robust'						///
		nooutput						///
		`initopt'						///
		title(Heteroskedastic ordered probit model)		///
		`diff'							///
		collinear						///
		`moptobj' 

} // capture noisily break

	local rc = c(rc)

	capture mata: rmexternal("`user_info'")

	if `rc' {
		exit `rc'
	}

} // nobreak

	if "`indepvars'" == "" {
		// we did not do the separate cutpoint only model because
		// it is the same as the full model
		scalar `ll_0' = e(ll)
		local  df_0 = r(df)
	}

	_b_pclass PCDEF : default
	_b_pclass PCAUX : aux
	tempname pclass
	matrix `pclass' = e(b)
	local dim = colsof(`pclass')
	matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
	local pos = colnumb(`pclass', "/cut1")
	matrix `pclass'[1,`pos'] = J(1,`ncut',`PCAUX')
	ereturn hidden matrix b_pclass `pclass'

	ereturn scalar k_cat = `ncat'
	ereturn scalar k_aux = `ncut'		// to display /cut#
	ereturn scalar k_eq_model = 1
	ereturn scalar ll_0  = `ll_0'
	// placeholder until e(k_scores) is added to -moptimize-
	ereturn hidden scalar k_scores = e(k_eq)

	// Test for homoskedasticity if no offset() term within het()
	if "`e(offset2)'" == "" {
		if "`waldhet'" != "" {
			qui test [lnsigma]
			eret scalar chi2_c = r(chi2)
			eret scalar df_m_c = r(df)
			eret scalar p_c    = r(p)
			eret local chi2_ct "Wald"
		}
		else {
			eret scalar ll_c =  `ll_c'       
			eret scalar chi2_c = 2*(e(ll) - `ll_c') 
			eret scalar df_m_c = e(rank) - `rank_c'
			eret scalar p_c = chi2tail(e(df_m_c),e(chi2_c))
			eret local chi2_ct "LR"
		}
	}
	else {
		eret scalar chi2_c = .
		eret scalar df_m_c = .
		eret scalar p_c    = .
	}

	// return ordinal vals as a row vector, to align with oprobit & ologit
	tempname cat
	matrix `cat' = `ordinal_vals'
	matrix `cat' = `cat''
	// construct marginsdefault string while we're at it
	forval i = 1/`ncat' {
		local j = `cat'[1,`i']
		local mdflt `mdflt' predict(pr outcome(`j'))
		local depvar_outcomes `"`depvar_outcomes' `j'"'
	}
	ereturn matrix cat `cat'

	ereturn local marginsok default XB Pr SIGMA 
	ereturn local marginsnotok STDP SCores
	// the next two lines tell -margins- that the main eq has no constant
	ereturn hidden local marginsprop addcons
	ereturn repost, buildfvinfo ADDCONS
	ereturn local marginsdefault `"`mdflt'"'
	ereturn hidden local depvar_outcomes `"`:list retok depvar_outcomes'"'

	ereturn local depvar `depvar'
	ereturn local predict "hetoprobit_p"
	ereturn local title "Heteroskedastic ordered probit regression"
	ereturn local cmd "hetoprobit"
	ereturn local cmdline `"hetoprobit `0'"'

	Replay, level(`level') `table' `header' `diopts'
end

