*! version 1.0.5  11sep2015
program _mixed_ddf, rclass sortpreserve
	version 14

	if "`e(cmd)'" != "mixed" {
		error 301
	}

	syntax [,   METHod(string)	/// df method
		    POST		/// post df method
		    POST1(string) 	/// post()
		    EIM			/// expected information matrix
		    OIM			/// observed information matrix
		    debug		/// undocumented, for debug
		    wmat(name) 		/// undocumented, for benching
		    derivh(real 1e-8)   /// undocumented, for numerical deriv
		    * ] 

	// Check data signature
	checkestimationsample

	local matopts `options'

	if (`"`post'"'!="" & `"`post1'"'!="") {
		di as err "only one of {bf:post} or {bf:post()} is allowed"
		exit 198
	}

	if (`"`eim'"'!="" & `"`oim'"'!="") {
		di as err "only one of {bf:eim} or {bf:oim} is allowed"
		exit 198
	}

	if ("`method'" == "" ) {
		if (`"`post'"'!="" | `"`post1'"'!="") {
			di as err "options {bf:post} and {bf:post()} " ///
				  "require option {bf:method()}"
			exit 198
		}

		if (`"`eim'"'!="" | `"`oim'"'!="") {
			di as err "option {bf:eim} or {bf:oim} requires " ///
			          "option {bf:method()}"
			exit 198
		}
	}

	if "`method'" != "" {
		CheckType, dftypes(`method')
		local dftypes = r(dftype)

		local w : word count `dftypes'
		if `w' > 1  & `"`post'"' != ""{
			di as err "multiple DF methods specified"
			di as err "{p 4 4 2}When multiple methods are"
			di as err "specified on option {bf:method()},"
			di as err "you must specify which DF method to"
			di as err "post in option {bf:post()}.{p_end}"
			exit 198
		}

		local is_kroger : list posof "kroger" in dftypes
		local is_satter : list posof "satterthwaite" in dftypes
		local is_anova : list posof "anova" in dftypes

		local useinfo "`eim'`oim'"
		if "`useinfo'"!= "" {
			if (`is_kroger'==0 & `is_satter'==0) {
				di as err "{p}option {bf:`useinfo'} can only"
				di as err "be specified when option"
				di as err "{bf:method()} contains {bf:kroger}"
				di as err "or {bf:satterthwaite}"
			  	di as err "{p_end}"
				exit 198
			}
		}
	}

	if `"`post1'"'!= "" {
		CheckType, dftypes(`post1')
		local posttype = r(dftype) 
		local w : word count `posttype'
		
		if `w' > 1 {
			di as err "{p}only one DF method can be specified" ///
				" in option {bf:post()}{p_end}" 
			exit 198
		}

		local in_df : list posof "`posttype'" in dftypes
		if !`in_df' {
			di as err "{p}method {bf:`posttype'} in option"
			di as err "{bf:post()} is not one of methods from"
			di as err "option {bf:method()}{p_end}"
			exit 198		
		}
	}
	else if `"`post'"'!= "" {
		local posttype `dftypes'
	}

	if "`e(dfmethod)'"=="" & "`method'"=="" {
		di as err "no degrees of freedom found"
		di as err "{p 4 4 2}Degrees of freedom"
		di as err "cannot be displayed because the previously used"
		di as err "{bf:mixed} command did not specify the"
                di as err "{bf:dfmethod()} option.  Use option {bf:method()}"
		di as err "with {bf:estat df} or option {bf:dfmethod()}"
		di as err "with {bf:mixed} to compute "
		di as err "degrees of freedom.{p_end}"
		exit 198 
	}

	
	if `e(k_f)' == 0 {
		di as err "{p}model contains no fixed effects; " ///
			"DF computation is not available{p_end}"
		exit 198
	}

	if "`e(dfmethod)'" != "" & "`method'"=="" {
		tempname df df_disp 

		local dftype = e(dfmethod)
		mat `df' = e(df)
		mat `df' = `df''
		mat `df_disp' = `df'[1..e(k_f),1]
		mat colnames `df' = `e(dfmethod)'
		mat colnames `df_disp' = `e(dftitle)'

		di _n as txt "Degrees of freedom"
		_matrix_table `df_disp', `matopts'
		
		if (e(eim)==0 ) {
			di as txt "{p 0 6 2}Note: The observed information" 
			di as txt "matrix is used to compute `e(dftitle)'"
		        di as txt "degrees of freedom.{p_end}"
		}

		if "`e(dfmethod)'" == "kroger" {
			tempname V_df
			mat `V_df' = e(V_df)
			return matrix V_df = `V_df'
		}

		return local dfmethods = "`dftype'"
		return matrix df = `df'
		exit 
	}


// step 0: Linear regression
	
	local ivars `e(ivars)'

	if "`ivars'" == "" & `"`e(rstructure)'"'=="independent"{
		local dftype "residual"

		tempname V rank df_r
		mat `V' = e(V)
		mat `V' = `V'[1..e(k_f),1..e(k_f)]
		mata: st_numscalar("`rank'", rank(st_matrix("`V'")))
		scalar `df_r' = e(N)-`rank'

		tempname df
		mat `df' = (`df_r')*e(noomit),J(1,e(k_r),0)
		mat rownames `df' = `dftype'
		mat colnames `df' = `: colfullnames e(b)'
		mat `df' = `df''

		tempname df_disp
		mat `df_disp' = `df'[1..e(k_f),1]
		DFtitles titles : "`dftype'"
		mat colnames `df_disp' = "`titles'"
		
		di _n as txt "Degrees of freedom"
		_matrix_table `df_disp', `matopts'

		//post to e()
		if "`posttype'"!="" {
			tempname Ftest
			cap qui test [`e(depvar)'], df(`=`df_r'')
			scalar `Ftest' = r(F)
			if (_rc==302) {
				cap qui test [`e(depvar)'], df(`=`df_r'') cons
				if (_rc) {
					exit _rc
				}
				scalar `Ftest' = .
			}
			else if (_rc) {
				exit _rc
			}
			tempname postdf
			mat `postdf' = `df'
			Post,  dftype(`posttype') df(`postdf') ///
				min(`=`df_r'') avg(`=`df_r'') max(`=`df_r'') ///
				model(`=`df_r'') test(`=`Ftest'') `eim' `oim'
		}
	
		return local dfmethods = trim("`dftype'")
		return matrix df = `df'

		exit
	}

cap noi {
	tempname b
	mat `b' = e(b)
	mat `b' = `b'[1, 1..e(k_f)]

	local xvars: colnames `b'
	mat drop `b'

	if "`xvars'" != "" {
		local ivars `e(ivars)'
		local uivars : list uniq ivars
		local w : word count `uivars'

		local revars `e(revars)'
		local w : word count `revars'
		forvalues i = 1/`w' {
			gettoken var revars : revars
			if (strpos("`var'","R.")) {
				local Rname: subinstr local var "R." ""
				local rxvars `"`rxvars' `Rname'"'
			}
			else { 
				local rxvars `"`rxvars' `var'"'
			}
		}

		// deal with fv in varnames_0
		local varnames_00 : subinstr local xvars "_cons" ""
		fvexpand `varnames_00'
		local hasfv = "`r(fvops)'"=="true"
	}
	local redim `e(redim)'

	preserve
	_mixed_ddf_u, dftypes(`dftypes') wmat(`wmat') ///
			derivh(`derivh') `debug' `eim' `oim'

// get DF for fixed-effects parameters

	tempname df DF

	local w: word count `dftypes'

	forvalues i = 1/`w' {
		local dftype : word `i' of `dftypes'

		mata: _mixed_ddf_get_ddf("`dftype'", "`df'")
		mata: _mixed_ddf_return_ddf("`df'")

		if ("`posttype'"!="" & "`posttype'"=="`dftype'") {
			tempname df_min df_avg df_max 
			mata: _mixed_ddf_compute_ddf("`df'", ///
					    "`df_min'","`df_avg'","`df_max'")

			tempname ddf_m Ftest
			mata: _mixed_ddf_get_ddfm("`dftype'", ///
						  "`ddf_m'", "`Ftest'")

			tempname postdf postddf_m postF
			tempname postdf_min postdf_avg postdf_max
			mat `postdf'		= `df''
			scalar `postdf_min'	= `df_min'
			scalar `postdf_max'	= `df_max'
			scalar `postdf_avg'	= `df_avg'
			scalar `postddf_m'	= `ddf_m'
			scalar `postF'		= `Ftest'
		}
	
		mat `DF' = (nullmat(`DF'),`df'')
	}

// Display 

	mata: _mixed_ddf_get_ddf_name("`DF'")
	mat colnames `DF' = `dftypes'
	
	di _n as txt "Degrees of freedom"

	tempname df_disp
	mat `df_disp' = `DF'[1..e(k_f),.]
	DFtitles titles : "`dftypes'"
	mat colnames `df_disp' = "`titles'"
	_matrix_table `df_disp', `matopts'
	if (`"`oim'"'!="" ) {
		if `is_kroger' & `is_satter' {
			di as txt "{p 0 6 2}Note: The observed information" 
			di as txt "matrix is used to compute Kenward-Roger"
			di as txt "and Satterthwaite degrees of freedom.{p_end}"
		}
		else if `is_kroger' {
			di as txt "{p 0 6 2}Note: The observed information" 
			di as txt "matrix is used to compute Kenward-Roger"
			di as txt "degrees of freedom.{p_end}"
		}
		else if `is_satter' {
			di as txt "{p 0 6 2}Note: The observed information" 
			di as txt "matrix is used to compute Satterthwaite"
			di as txt "degrees of freedom.{p_end}"
		}
	}

	if (`is_kroger') {
		tempname V_df vdf
		mata: _mixed_ddf_return_V("`V_df'", "kroger")
		mat `vdf' = `V_df'
	}

// Post to e()
	if "`posttype'"!="" {
		Post,  dftype(`posttype') df(`postdf') 		///
			min(`=`postdf_min'') 				///
			avg(`=`postdf_avg'') max(`=`postdf_max'') 	///
			model(`=`postddf_m'') test(`=`postF'') vdf(`vdf') ///
			`eim' `oim'
	}

// Return
	return local dfmethods = trim("`dftypes'")
	return matrix df = `DF'
	if (`is_kroger') return matrix V_df = `V_df'
	if (`is_kroger' | `is_satter') {
		if (`"`oim'"'!="") return hidden scalar eim = 0 
		else return hidden scalar eim = 1
	}

} //end cap noi
	local rc = _rc
// Cleanup
	mata: _mixed_ddf_cleanup()
	exit `rc'
end

program CheckType, rclass

	syntax [, dftypes(string) * ]

	local w : word count `dftypes'
	forvalues i=1/`w' {
		local dftype : word `i' of `dftypes'
		Unabbrev, `dftype'
		local types "`types' `r(dftype)'"
	}

	return local dftype = trim("`types'")
end

program Unabbrev, rclass

	syntax [, KRoger SATterthwaite RESidual REPeated ANOVA *]

	if `"`options'"' != "" {
		local nopts : word count `options'
		if (`nopts'==1) {
			di as err "{p}{bf:`options'} is not a valid DF " ///
			"method{p_end}"
		}
		else {
			di as err "{bf:`options'}: not valid DF methods"
		}
		exit 198
	}

	// linear regression	
	if `"`e(ivars)'"' == "" & `"`e(rstructure)'"'=="independent" {
		if ("`kroger'`satterthwaite'`anova'`repeated'"!= ""){
			di as err ///
				"{p 0 4 2}model is linear regression;  " ///
				"option {bf:dfmethod(residual)} should be " ///
				"used{p_end}"
			exit 198
		}
		else {
			return local dftype = "residual"
			exit
		}
	}

	local method `e(method)'

	if "`method'" == "ML" {
		if `"`kroger'"'!="" {
 			di as err "{p}Kenward-Roger DF method is available" ///
				" only with REML estimation{p_end}"
			exit 198
		}
		else if `"`satterthwaite'"'!="" {
 			di as err "{p}Satterthwaite DF method is available" ///
				" only with REML estimation{p_end}"
			exit 198
		}
	}
	
	if `"`repeated'"' != "" { 
		local ivars `e(ivars)'
		local uivars : list uniq ivars
		local k : word count `uivars'

		if `k' > 1 {
			di as err ///
				    "{p}method {bf:repeated} " ///
				    "is not available for models with more " ///
				    "than two levels{p_end}"
			exit 198
		}	
	}

	local dftype "`kroger'`satterthwaite'"
	local dftype "`dftype'`residual'`repeated'`anova'"

	ret local dftype = "`dftype'"
end

program Post, eclass

	syntax, dftype(string) df(name) min(real) ///
		  avg(real) max(real) model(real) /// 
		  test(real) [ vdf(name) EIM OIM * ]

	eret local dfmethod = "`dftype'"

	DFtitles dftitle : `dftype'
	ereturn local dftitle = "`dftitle'"

	mat `df' = `df''
	eret matrix df = `df'
	if ("`dftype'" == "kroger") {
		eret matrix V_df = `vdf'
	}
	eret scalar df_min = `min'
	eret scalar df_avg = `avg'
	eret scalar df_max = `max'
	eret scalar ddf_m   = `model'
	eret scalar F       = `test'
	eret scalar small   = 1
	if ("`dftype'"=="kroger" | "`dftype'"=="satterthwaite") {
		if ("`oim'"!="") eret hidden scalar eim = 0
		else eret hidden scalar eim = 1
	}
end

program DFtitles
	args tomac colon methods
	local krogerti "Kenward-Roger"
	local satterthwaiteti "Satterthwaite"
	local repeatedti "Repeated"
	local residualti "Residual"
	local anovati "ANOVA"
	foreach meth of local methods {
		local titles `"`titles' "``meth'ti'""'
	}
	c_local `tomac' `titles'
end

exit
