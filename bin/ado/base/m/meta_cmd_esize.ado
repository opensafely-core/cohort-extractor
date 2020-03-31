*! version 1.0.2  06dec2019
program meta_cmd_esize
	version 16
	
	syntax varlist(min=4 max=6 numeric) [if] [in][,		///
		ESize(string)					///
		random(string) 					///
		RANDOM1						///
		fixed(string)  					///
		FIXED1  					///
		common(string)  				///
		COMMON1  					///
		ESLABel(string)  				///
		Level(cilevel) 					///
		STUDYLABel(varlist min=1 max=2) 		///
		ZEROCELLs(string)				///
		ismetaq						/// UNDOC
		keepweight					/// UNDOC
		keepstudylbl					/// UNDOC
		nometashow ]
	
	if `=_N' == 0 error 3
	
	marksample touse	
	qui count if `touse'
	local nobs = r(N)	
	
	local esizespec   = cond(missing("`esize'")    , 0, 1)
	local randomspec  = cond(missing("`random'")   , 0, 1)
	local eslabelspec = cond(missing("`eslabel'")  , 0, 1)
	local zcspec      = cond(missing("`zerocells'"), 0, 1)
	
	meta__parse_varlist `varlist', touse(`touse')
	local wgt = cond(missing("`keepweight'"), "_meta_weight", "")
	local studlbl = cond(missing("`keepstudylbl'"), "_meta_studylabel", "")
	
	// drop this var o/w it won't be in sync with _meta_es 
	cap drop `wgt'
	
	local nvar : word count `varlist'
	
	if `nvar' == 5 {
		di as error "incorrect number of variables specified"
		di as err "{p 4 4 2} You must specify 4 variables for " ///
			"binary data and 6 variables for continuous " ///
			"data.{p_end}"
		exit 459	
	}
	
	local re = subinstr("`random'"," ", "_",.)
	local fe = subinstr("`fixed'"," ", "_",.)
	local co = subinstr("`common'"," ", "_",.)
	
	local dtype = cond(`nvar' == 4, "binary", "continuous")
	
	local mod `"`re' `fe' `fixed1' `co' `common1' `random1'"'
	if  (`:word count `mod'' > 1) {
		if "`dtype'"=="continuous" {
			meta__model_err
		}
		if "`dtype'"=="binary" {
			meta__model_err, mh
		}
	}
	
	
	meta__validate_esize, dtype(`dtype') estype(`esize')
	local esize `s(estype)'
	local unequal `s(unequal)'
	local exact `s(hedgesexact)'
	local holkinse `s(holkinse)'
	local eslab = cond("`eslabel'" == "", "`s(eslab)'", "`eslabel'")	
	
	meta__eslabel, estype(`esize') eslbl(`eslab')
	local eslab "`s(eslab)'"
	local eslblvarmid "`s(eslabvarmid)'"	// for labeling sys vars
	local eslblvarbeg "`s(eslabvarbeg)'"
	
	meta__parse_cctyp, cc(`zerocells') es(`esize') name(zerocells) ///
		`specified'
	local cctyp `s(cctyp)'
	local cc `s(cc)'
	local ccmethod `s(ccmethod)'
		
	if !missing("`random'") {
		meta__validate_random, `random'
		local random `s(remodel)'
		local model random
	}
	else if !missing("`random1'") {
		local random reml
		local model random 
	}
	else if !missing("`fixed'") {
		meta__validate_fixed, meth(fixed) `fixed'
		local method `s(femodel)'
		local model fixed
	}
	else if !missing("`common'") {
		meta__validate_fixed, meth(common) `common'
		local method `s(femodel)'
		local model common
	}
	else if !missing("`fixed1'") {
		if ("`dtype'" == "binary" & "`esize'"!="lnorpeto") {
			local method mhaenszel
		}
		else local method invvariance 
		local model fixed
	}
	else if !missing("`common1'") {
		if ("`dtype'" == "binary" & "`esize'"!="lnorpeto") {
			local method mhaenszel
		}
		else local method invvariance
		local model common 
	}
	else {	
		local random reml // default to reml
		local model "random"		
	}
	
	if inlist("`esize'", "lnoratio", "lnorpeto") {
		local ispeto = cond("`esize'" == "lnorpeto", "peto","")
		if !missing("`ispeto'") & "`method'"=="mhaenszel" {
			di as err "{p}the {bf:mhaenszel} method may not be" ///
			  " combined with effect size {bf:lnorpeto}{p_end}"
			exit 184  
		}	
		meta__compute_or `varlist', touse(`touse') `ispeto' cc(`cc') ///
			cctype(`cctyp') ccmethod(`ccmethod') ///
			eslblvarbeg("`eslblvarbeg'") ///
			eslblvarmid("`eslblvarmid'")
	}
	else if inlist("`esize'", "rdiff", "lnrratio") {
		meta__compute_rrd `varlist', touse(`touse') es(`esize') ///
			cc(`cc') eslblvarmid("`eslblvarmid'") ///
			cctype(`cctyp') eslblvarbeg("`eslblvarbeg'") 
			
	}	
	else {
		meta__compute_cont_es `varlist', touse(`touse') es(`esize') ///
			`holkinse' `exact' `unequal' ///
			eslblvarbeg("`eslblvarbeg'") ///
			eslblvarmid("`eslblvarmid'")
	}
			
	local method "`random'`method'"
	
	cap drop _meta_id
	gen _meta_id = _n if `touse'
	label var _meta_id "Study ID"
	
	meta__compute_ci _meta_es _meta_se, level(`level') touse("`touse'") ///
		eslbl("`eslblvarmid'")
	
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
	}		
	
	meta__clear_char
	
	label var _meta_studylabel "Study label"
	
	cap drop _meta_studysize
	if "`dtype'" == "binary" {
		qui egen _meta_studysize = rowtotal(`varlist') if `touse'
		tokenize `varlist'
		char _dta[_meta_n11var] "`1'"
		char _dta[_meta_n12var] "`2'"
		char _dta[_meta_n21var] "`3'"
		char _dta[_meta_n22var] "`4'"
		
		local zerosexist 0
		tempvar zeros
		qui egen `zeros' = anymatch(`varlist'), v(0)
		cap assert `zeros' == 0
		
		if _rc local zerosexist 1
		
		if !missing("`zerocells'") & !`zerosexist' {
			di as txt "{p 0 6 2}" ///
				"note: option {bf:zerocells()} ignored; " ///
				"no zero cells detected in data{p_end}"
		}
	}
	else {
		tokenize `varlist'
		qui gen _meta_studysize = `1' + `4'  if `touse'
		char _dta[_meta_n1var]		"`1'"
		char _dta[_meta_mean1var]	"`2'"
		char _dta[_meta_sd1var]		"`3'"
		char _dta[_meta_n2var]		"`4'"
		char _dta[_meta_mean2var]	"`5'"
		char _dta[_meta_sd2var]		"`6'"
	}
	label var _meta_studysize "Sample size per study"
	
	char _dta[_meta_model] "`model'"
	char _dta[_meta_method] "`method'" 
	qui meta__model_method, random("`random'") `random1' `fixed1' ///
		`common1' fixed("`fixed'") common("`common'") suppressclocal ///
		dtype("`dtype'") estype("`esize'")
	
	local cmdl `"`0'"'
	local cmdl : subinstr local cmdl "random1" "random"
	local cmdl : subinstr local cmdl "fixed1" "fixed"
	local cmdl : subinstr local cmdl "common1" "common"
	mata: _clean_cmdline()
	
	nobreak {
		char _dta[_meta_setcmdline] "meta esize `opts'"
		char _dta[_meta_ifexp] "`if'"
		char _dta[_meta_inexp] "`in'"
		char _dta[_meta_datavars] "`varlist'"
		char _dta[_meta_marker] "_meta_ds_1"
		char _dta[_meta_datatype] "`dtype'"
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
		char _dta[_meta_esvardb] `"_meta_es"'
		char _dta[_meta_eslabel] `"`eslab'"'
		local eslabdb = abbrev(`"`eslab'"', 20)
		char _dta[_meta_eslabeldb] `"`eslabdb'"'
		if "`eslabelspec'"=="1" {
			char _dta[_meta_eslabelopt] `"eslabel(`eslabel')"'
		}
		char _dta[_meta_estype] `"`esize'"'
		if "`esizespec'"=="1" {
			char _dta[_meta_esizeopt] "esize(`esize')"
		}
		char _dta[_meta_esopt_exact]	"`exact'"
		char _dta[_meta_esopt_holkinse] "`holkinse'"
		char _dta[_meta_esopt_unequal] 	"`unequal'"
		if inlist("`esize'", "lnoratio", "lnrratio") & ///
			"`zerosexist'"=="1" {
			if !missing("`ccmethod'") {
				char _dta[_meta_zcadj] "`ccmethod'"
			}
			else {
				char _dta[_meta_zcvalue] "`cc'"
				char _dta[_meta_zcadj] "`cctyp'"
			}
		}
		if "`zcspec'"=="1"{
			 char _dta[_meta_zcopt] "zerocells(`zerocells')"
		}
			
		char _dta[_meta_show] "`metashow'"
		
	}
	
	meta__di_metainfo, nobs(`nobs') 	///
		  stlbl(`studylabel') 		///
		  stsize(_meta_studysize) 	///
		  estype(`esize') 		///
		  eslbl(`eslab') 		///
		  esvar(_meta_es)		///
		  sevar(_meta_se)		///
		  cilvar(_meta_cil) 		///
		  ciuvar(_meta_ciu)		///
		  level(`level')		///
		  method(`method')		///
		  model(`model')		///
		  `ismetaq'
	
	qui compress _meta_*
	
	order _meta_id _meta_studylabel _meta_es _meta_se _meta_cil ///
		_meta_ciu _meta_studysize, last	  
end
