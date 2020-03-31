*! version 1.0.1  30jan2019
program define hetoprobit_p
	version 16
	
	if "`e(cmd)'"!="hetoprobit" { 
		error 301
	}

	syntax [anything] [if] [in] [, SCores pr Outcome(string) ///
		XB STDP sigma noOFFset]

	tempvar touse
	marksample touse

	if (`"`anything'"'=="") {
		di as err "'' found where varname expected"
		exit 7
	}

	if strpos(`"`anything'"',"*") {
		ParseNewVars `0'
		local varlist `s(varlist)'
		local typlist `s(typlist)'
	}
	else {
		syntax [newvarlist] [if] [in] [, * ]
	}

	local nvars : list sizeof varlist

	// check for conflicting types
	local type `xb' `stdp' `pr' `scores' `sigma'
	if `:list sizeof type' > 1 {
		local type : list retok type
		di as err "the following options may not be combined: {bf:`type'}"
		exit 198
	}
	// check whether -outcome()- is legal 
	// if not, issue with an error 
	if "`type'"!="" & "`type'"!="pr" & `"`outcome'"'!="" {
		di as err "{p}option {bf:outcome()} is allowed " /*
		*/ "only when computing probabilities{p_end}"
		exit 198
	}

	if `nvars' > 1 {
		local onevartype `xb' `stdp' `sigma'
		if `:list sizeof onevartype' > 0 {
			error 103
		}
		MultVars `nvars' `type' `varlist'
		if `"`outcome'"' != "" {
			di as err ///
"{p}option {bf:outcome()} is not allowed when multiple new variables are specified{p_end}"
			exit 198
		}
	}
	else {
		Singlevar `nvars' `type' `outcome'
	}

/* General preliminaries */
	
	local cut "/cut"	// _b[/cut1] etc 
	local cmd hetoprobit

	// There is 1 equation for the variance term (required).
	// There is 1 equation for each cutpoint, and #cutpoints = e(k_cat)-1.
	local ncut = e(k_aux)
	if `e(k_eq)' == `ncut' + 2 {
		local hasx 1
	}
	else if `e(k_eq)' == `ncut' + 1 {
		local hasx 0
	}

/* scores */

	if `"`type'"' == "scores" {

		if "`offset'" != "" {
di as err "option {bf:offset()} not allowed with statistic {bf:scores}"
			error 198
		}

		local depvar_name = e(depvar)
		markout `touse' `depvar_name'

		// ordinal_vals is the list of values of the dependent
		// variable that were observed in the data used for the 
		// estimation command
		tempname ordinal_vals
		matrix `ordinal_vals' = e(cat)'

		// yk will hold the index within ordinal_vals of the values
		// of the dependent variable in the postest data.
		// Because observations for postestimation may be different 
		// than the observations used during estimation, the 
		// postestimation data may lack some of the categories that 
		// were observed during estimation.
		// Also, the current data may have categories that were not
		// observed during estimation.  Scores cannot be computed
		// for the corresponding observations, so yk is set missing
		// to flag this.
		tempvar yk 
		// This ensures that the categories we saw during estimation
		// map to the correct estimated cutpoints.
		local ncat = `ncut' + 1
		qui gen `yk' = .
		forvalues i = 1(1)`ncat' {
			qui replace `yk' = `i' if `touse' & 		///
				`depvar_name' == `ordinal_vals'[`i',1]
		}
		markout `touse' `yk'

		tempname B stripe
		matrix `B' = e(b)
		local nindepvar = 0
		if `hasx' {
			local depvar_name = e(depvar)
			matrix `stripe' = `B'[1, "`depvar_name':"]
			local nindepvar = colsof(`stripe')
		}
		matrix `stripe' = `B'[1, "lnsigma:"]
		local nsigvar = colsof(`stripe')
nobreak {
		mata: _hetoprobit__userinfo_set("user_info",		///
						`ncut',			///
						`nindepvar',		///
						`nsigvar',		///
						`"`yk'"',		///
						`"`touse'"')	
		capture noisily break {
			ml score `anything' if `touse',		/// 
						missing			///
						userinfo(`user_info')
		}

		local rc = _rc
		capture mata: rmexternal("`user_info'")
		sret clear
} // nobreak
		if `rc' {
			error `rc'
		}
		exit
	}

/* XB or STDP */

	if inlist("`type'", "xb", "stdp") {

		if e(df_m) != 0 {
			_predict `typlist' `varlist' `if' `in', `type' `offset'
		}
		else {
			gen `typlist' `varlist' = . `if' `in'
		}

		if "`type'" == "stdp" {
			label var `varlist' /*
			*/ "S.E. of linear prediction (cutpoints excluded)"
		}
		else {
			label var `varlist' /*
			*/ "Linear prediction (cutpoints excluded)"
		}

		exit
	}	       

	// For both sigma and pr predictions, we need the scale term 

	tempvar lnvar
	* -qui- removes extra missing msg
	qui _predict double `lnvar' `if' `in', xb eq(#2) `offset'
	qui replace `lnvar' = exp(`lnvar')

/* SIGMA */

	if "`type'" == "sigma" {
		gen `typlist' `varlist' = `lnvar'
		label var `varlist' "Heteroskedastic standard deviation"
		exit
	}

/* PROBABILITIES */
	if ("`type'"=="") {
		if `"`outcome'"' != "" {
			di as txt ///
			"(option {bf:pr} assumed; predicted probability)"
		}
		else {
			di as txt ///
			"(option {bf:pr} assumed; predicted probabilities)"
		}
	}

	// The linear predictor, sans cutpoints
	if `hasx' {
		tempvar xb
		qui _predict double `xb' `if' `in', xb `offset'
	}
	else	local xb 0

	/* Probability for a single outcome */

	if `nvars' == 1 {

		/* Probability for a single outcome */

		if "`outcome'" == "" {
			local outcome "#1"
		}

		Eq `outcome'
		local i `s(icat)'
		local im1 = `i' - 1
		sret clear

		if `i' == 1 {
			gen `typlist' `varlist' = 			///
				normal((_b[`cut'1] - `xb') / `lnvar')	///
				`if' `in'
		}
		else if `i' < e(k_cat) {
			gen `typlist' `varlist' = 			///
				normal((_b[`cut'`i'] - `xb') / `lnvar')-  ///
			 	normal((_b[`cut'`im1'] - `xb') / `lnvar') ///
				`if' `in'
		}
		else {
			gen `typlist' `varlist' = 			///
				normal((`xb' - _b[`cut'`im1']) / `lnvar') ///
				`if' `in'
		}

		local val = el(e(cat),1,`i')
		label var `varlist' "Pr(`e(depvar)'==`val')"

		exit
	}

	/* Multiple probabilities  */

	tempvar touse
	mark `touse' `if' `in'

	tempname miss
	local same 1
	mat `miss' = J(1,`e(k_cat)',0)

	quietly {
		local i 1
		while `i' <= e(k_cat) {
			local typ : word `i' of `typlist'
			tempvar p`i'
			local im1 = `i' - 1

			if `i' == 1 {
				gen `typ' `p`i'' =  /*
				*/ normal((_b[`cut'1] - `xb') / `lnvar') /* 
				*/ if `touse'
			}
			else if `i' < e(k_cat) {
				gen `typ' `p`i'' = /*
				*/ normal((_b[`cut'`i'] - `xb') / `lnvar') /*
				*/ - normal((_b[`cut'`im1']-`xb')/`lnvar') /*
				*/ if `touse'
			}
			else {
				gen `typ' `p`i'' = /*
				*/ normal((`xb'-_b[`cut'`im1']) / `lnvar') /*
				*/ if `touse'
			}

			// Count # of missings.
			count if `p`i''>=.
			mat `miss'[1,`i'] = r(N)
			if `miss'[1,`i']!=`miss'[1,1] {
				local same 0
			}

			// Label variable. 
			local val = el(e(cat),1,`i')
			label var `p`i'' "Pr(`e(depvar)'==`val')"

			local i = `i' + 1
		}
	}

	tokenize `varlist'
	local i 1
	while `i' <= e(k_cat) {
		rename `p`i'' ``i''
		local i = `i' + 1
	}
	ChkMiss `same' `miss' `varlist'
end

program ParseNewVars, sclass
	syntax [anything(name=vlist)] [if] [in] [, SCores pr * ]

	if "`scores'" == "" {
		_stubstar2names `vlist', nvars(`e(k_cat)') 
		local varlist `s(varlist)'
		local typlist `s(typlist)'
		confirm new var `varlist'
	}
	else {
		_score_spec `vlist'
		local varlist `s(varlist)'
		local typlist `s(typlist)'
		sreturn local varspec `varspec'
	}
	sreturn clear
	sreturn local varlist `varlist'
	sreturn local typlist `typlist'
end

program MultVars
	gettoken nvars 0 : 0
	gettoken type 0 : 0
	if "`type'" == "scores" {
		if (`nvars' < `e(k_eq)') {
			di as err "too few variables specified"
		}
		if (`nvars' > `e(k_eq)') { 
			di as err "too many variables specified"
		}
		if `nvars' != `e(k_eq)' {
			di as err "{p 4 4 2}You must specify `e(k_eq)' new " /*
			*/ " variable names. " /*
			*/ "You may specify them as a " /*
			*/ "{help newvarlist:{it:newvarlist}} " /*
			*/ "or as a variable " /*
			*/ "{help newvarlist##stub*:{it:stub}{bf:*}}.{p_end}"
			exit cond(`nvars' < e(k_scores), 102, 103)
		}
		exit
	}
	// MultVars should not be called except for score or pr, so this is pr
	if `nvars' != e(k_cat) {
		capture noisily error cond(`nvars'<e(k_cat), 102, 103)
		di as err "{p}dependent variable " /*
		*/ "{bf:`e(depvar)'} has `e(k_cat)' outcomes and so you " /*
		*/ "must specify `e(k_cat)' new variables, or " _n /*
		*/ "you can use option {bf:outcome()} and specify " /*
		*/ "variables one at a time{p_end}"
		exit cond(`nvars'<e(k_cat), 102, 103)
	}
end

program define Eq, sclass
	sret clear
	local out = trim(`"`0'"')
	if bsubstr(`"`out'"',1,1)=="#" {
		local out = bsubstr(`"`out'"',2,.)
		Chk confirm integer number `out'
		Chk assert `out' >= 1
		capture assert `out' <= e(k_cat)
		if _rc {
			di as err "there is no outcome {bf:#`out'}" _n /*
			*/ "there are only `e(k_cat)' categories"
			exit 111
		}
		sret local icat `"`out'"'
		exit
	}

	Chk confirm number `out'
	local i 1
	while `i' <= e(k_cat) {
		if `out' == el(e(cat),1,`i') {
			sret local icat `i'
			exit
		}
		local i = `i' + 1
	}

	di as err `"outcome value {bf:`out'} not found"'
	Chk assert 0 /* return error */
end

program define Chk
	capture `0'
	if _rc {
		di as err "{p}option {bf:outcome()} must either be a value " /*
		*/ "of dependent variable {bf:`e(depvar)'}," /*
		*/ _n "or {bf:#1}, {bf:#2}, ...{p_end}"
		exit 111
	}
end

program define Singlevar

	// check for legal number of new predict variables
	args nvars type outcome

	if "`type'" == "scores" {
		di as err "too few variables specified"
		di as err "{p 4 4 2}You must specify `e(k_eq)' new " /*
		*/ " variable names. " /*
		*/ "You may specify them as a " /*
		*/ "{help newvarlist:{it:newvarlist}} " /*
		*/ "or as a variable " /*
		*/ "{help newvarlist##stub*:{it:stub}{bf:*}}.{p_end}"
		exit 102
	}
	else if "`type'" == "pr" {
		if `nvars' != 1 {
			di as err "{p}dependent variable " /*
			*/ "{bf:`e(depvar)'} has `e(k_cat)' outcomes and " /*
			*/ "so you must specify `e(k_cat)' new variables, or " /*
			*/ _n "you can use option {bf:outcome()} and " /*
			*/ "specify variables one at a time{p_end}"
			exit 102
		}
	}
	else if `nvars' != 1 {
		di as err "option {bf:`type'} requires that you specify 1 new variable"
		exit 102
	}

end

program define ChkMiss
	args same miss
	macro shift 2
	if `same' {
		SayMiss `miss'[1,1]
		exit
	}
	local i 1
	while `i' <= e(k_cat) {
		SayMiss `miss'[1,`i'] ``i''
		local i = `i' + 1
	}
end

program define SayMiss
	args nmiss varname
	if `nmiss' == 0 { 
		exit 
	}
	if "`varname'"!="" {
		local varname "`varname': "
	}
	if `nmiss' == 1 {
		di as txt "(`varname'1 missing value generated)"
		exit
	}
	local nmiss = `nmiss'
	di as txt "(`varname'`nmiss' missing values generated)"
end
