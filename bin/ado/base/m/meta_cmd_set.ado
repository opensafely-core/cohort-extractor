*! version 1.0.2  06jan2020
program meta_cmd_set
	version 16

	cap noi syntax varlist [if] [in] [, 		/// 
		random(string) 				///
		RANDOM1					///
		fixed  					///
		common					///
		ESLABel(string)  			///
		Level(cilevel) 				///
		CIVARLEVel(string)			///
		CIVARTOLerance(real 1E-6)		/// 	
		studysize(varname numeric)		///
		nometashow				///
		ismetaq					/// Undoc
		keepweight				/// Undoc
		keepstudylbl				/// Undoc
		STUDYLABel(varlist min=1 max=2) ]
	
	if _rc == 100 {
		di as err "{p 4 4 2}You must specify an effect-size " ///
			" variable and either a standard-error variable or " ///
			"two variables containing the lower and upper " ///
			"bounds of confidence intervals.{p_end}"
		exit _rc	
	} 
	else if _rc  exit _rc
	
	local wgt = cond(missing("`keepweight'"), "_meta_weight", "")
	local studlbl = cond(missing("`keepstudylbl'"), "_meta_studylabel", "")
	cap drop `wgt'
	
	local randomspec = cond(missing("`random'"), 0, 1)
	local eslabelspec = cond(missing("`eslabel'"), 0, 1)
	
	local nvar : word count `varlist'
	if "`nvar'"!="3" & !missing("`civarlevel'") {
		di as err "option {bf:civarlevel()} allowed only when CI " ///
			"variables specified"
		exit 198	
	}
	
	if !missing("`civarlevel'") {
		meta__validate_level "`civarlevel'"
		local civarlevel `s(mylev)'
	}
	else {
		local civarlevel `c(level)'
	}
	
	local cmdl `varlist' `if' `in', `random1' `fixed' `common' `metashow'
	if "`level'"!= "`c(level)'" {
		local cmdl `"`cmdl' level(`level')"'
	}
	if "`civarlevel'"!= "`c(level)'" {
		local cmdl `"`cmdl' civarlevel(`civarlevel')"'
	}
	
	if `=_N' == 0 error 3
	
	marksample touse
	
	local amount = cond(`nvar' < 2, "few", "many")
	local errc = cond(`nvar' < 2, 102, 103)
	
	if (`nvar' < 2 | `nvar' > 3) {
		di as err "too `amount' variables specified"
		di as err "{p 4 4 2}You must specify 2 variables "
		di as err "{it:esvar} and {it:sevar}, or 3 variables "
		di as err "{it:esvar}, {it:cilvar}, and {it:ciuvar}."
		di as err "{p_end}"
		exit `errc'
	}
	
	local re = subinstr("`random'"," ", "_",.)
	local mod `"`re' `fixed' `common' `random1'"'
	if  (`:word count `mod'' > 1) {
		meta__model_err	  
	}
	
	
	if !missing("`random'") {
		meta__validate_random, `random'
		local method `s(remodel)'
		local model random
		local cmdl `"`cmdl' random(`method')"'
 	}
	else if !missing("`random1'") {
		local method reml
		local model random 
	}
	else if !missing("`fixed'`common'") {
		local model "`fixed'`common'"
		local method invvariance
	}
	else { 
		local method reml
		local model random
	} 
			
	qui count if `touse'
	local nobs = r(N)
			
	meta__parse_varlist `varlist', touse(`touse') civartol(`civartolerance')
	
	tokenize `varlist'
	
	cap drop _meta_es
	qui clonevar  _meta_es    = `1' if `touse'
	local eslbl = cond(missing("`eslabel'"), "ES", ///
		"`eslabel'")
	local esvarlbl = cond(missing("`eslabel'"), "Generic ES", "`eslabel'")
	label var _meta_es "`esvarlbl'" 
	local esvar "`1'"
	
	cap drop _meta_id
	gen _meta_id = _n if `touse'
	label variable _meta_id "Study ID"
	
	if (`nvar' == 2) {
		cap drop _meta_se
		qui clonevar  _meta_se = `2' if `touse'
		qui label var _meta_se "Std. Err. for `eslbl'"
		local sevar "`2'"
		local cilvar "_meta_cil"
		local ciuvar "_meta_ciu"			  

	}
	else {
		local sevar "_meta_se"
		local ualpha = (100 -`civarlevel')/200	
		cap drop _meta_se
		qui gen double _meta_se = ///
		  (`3' - `2')/(2*invnormal(1-`ualpha')) if `touse'
		qui label var _meta_se "Std. Err. for `eslbl'"
		local cilvar `2'
		local ciuvar `3'			  
	}
	
	local nidvar : word count `studylabel'
	
	if (`nidvar' > 1) {
		tokenize `studylabel'
		confirm str v `1'
		cap drop _meta_studylabel
		cap confirm numeric variable `2'
		if !_rc {
			qui gen _meta_studylabel=`1'+", "+string(`2') if `touse'
		}
		else {
			qui gen _meta_studylabel = `1' + ", " + `2' if `touse'
		}
		local cmdl `"`cmdl' studylabel(`studylabel')"'
	}
	else if (!`nidvar' & missing("`keepstudylbl'")) {
		
		meta__gen_studylabel, nobs(`nobs') touse("`touse'")
		
		local studylabel "Generic"
	}
	else if `nidvar' == 1 {
		cap drop _meta_studylabel
		cap confirm str var `studylabel'
		if _rc {
			qui gen _meta_studylabel=string(`studylabel') if `touse'
		}
		else {
			qui gen _meta_studylabel = `studylabel' if `touse'
		}
		local cmdl `"`cmdl' studylabel(`studylabel')"'
	}
	cap label var _meta_studylabel "Study label"
	
	
	cap drop _meta_studysize
	if !missing("`studysize'") {
		cap assert `studysize' > 0 & floor(`studysize')==`studysize'
		if _rc {
			di as err "sample size variable must contain " ///
				"positive integers"
			exit _rc	
		}
		
		qui gen _meta_studysize = `studysize' if `touse'	
		label var _meta_studysize "sample size per study"
		local cmdl `" `cmdl' studysize(`studysize')"'
	} 
	
	if missing("`eslabel'") local eslabel "Effect Size"
	else if "`eslabel'"!="Effect Size" {
		local cmdl `"`cmdl' eslabel(`eslabel')"'
	}
	
	cap drop _meta_cil 
	cap drop _meta_ciu
	meta__compute_ci _meta_es _meta_se, level(`level') ///
		touse("`touse'") eslbl("`eslbl'")

		
	char _dta[_meta_method] "`method'"
	char _dta[_meta_model] "`model'"
	qui meta__model_method, random("`random'") `random1' `fixed1' ///
		`common1' suppressclocal dtype("Generic")
	
	meta__clear_char
	
	local cmdl : list retokenize cmdl
	local cmdl : subinstr local cmdl "random1" "random"
		
	local l_db = strlen(`"`= abbrev("`esvar'", 12)'"')
	
	nobreak {
		char _dta[_meta_setcmdline] "meta set `cmdl'"
		char _dta[_meta_ifexp] "`if'"
		char _dta[_meta_inexp] "`in'"
		char _dta[_meta_datavars] "`varlist'"
		char _dta[_meta_marker] "_meta_ds_1"
		char _dta[_meta_level] "`level'"
		char _dta[_meta_K] "`nobs'"
		char _dta[_meta_modellabel] "`s(modeldesc)'"
		char _dta[_meta_model] "`model'"
		char _dta[_meta_methodlabel] "`s(methdesc)'"
		char _dta[_meta_method] "`method'"
		if "`randomspec'"=="1" {
			char _dta[_meta_randomopt] "random(`random')"
		}
		char _dta[_meta_studylabel]  "`studylabel'"
		char _dta[_meta_studysize] "`studysize'"
		char _dta[_meta_eslabel] `"`eslabel'"'
		local eslabdb = abbrev(`"`eslabel'"', `= 30 -2 -`l_db'')
		char _dta[_meta_eslabeldb] `"`eslabdb'"'
		if "`eslabelspec'"=="1" {
			char _dta[_meta_eslabelopt] "eslabel(`eslabel')"
		}
		char _dta[_meta_datatype] "Generic"
		char _dta[_meta_estype] "Generic"	
		char _dta[_meta_show] "`metashow'"	
	}

	char _dta[_meta_esvar] "`esvar'"
	char _dta[_meta_esvardb] `"`= abbrev("`esvar'", 12)'"'
	if ("`sevar'" != "_meta_se") char _dta[_meta_sevar] "`sevar'"
	if `nvar' == 3 {
		char _dta[_meta_cilvar] "`cilvar'"
		char _dta[_meta_ciuvar] "`ciuvar'"
		char _dta[_meta_civarlevel] "`civarlevel'"
	}
	
	
	meta__di_metainfo, nobs(`nobs') 	///
		  stlbl(`studylabel') 		///
		  stsize(`studysize') 		///
		  estype(Generic) 		///
		  eslbl(`eslabel') 		///
		  esvar(`esvar')		///
		  sevar(`sevar')		///
		  cilvar(_meta_cil) 		///
		  ciuvar(_meta_ciu)		///
		  ciluser(`cilvar') 		///
		  ciuuser(`ciuvar')		///
		  level(`level')		///
		  method(`method')		///
		  model(`model')		///
		  `ismetaq'
	
	qui compress _meta_*
	
	order _meta_id _meta_studylabel _meta_es _meta_se _meta_cil ///
		_meta_ciu, last
	if !missing("`studysize'") {
		order _meta_studysize, last
	}	
end

