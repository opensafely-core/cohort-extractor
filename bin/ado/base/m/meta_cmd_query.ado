*! version 1.0.0  24apr2019
program meta_cmd_query
	version 16		
	
	syntax [, short]
	
	if missing("`: char _dta[_meta_marker]'") {
		di as txt "{p}(data not {bf:meta} set;"
		di as txt "use {helpb meta set} or {helpb meta esize}"
		di as txt "to declare as {bf:meta} data){p_end}"
		exit
	}
	
	local level : char _dta[_meta_level]
	local studylabel : char _dta[_meta_studylabel]
	local studysize : char _dta[_meta_studysize]
	if missing("`studysize'") &  ///
		"`:char _dta[_meta_datatype]'" != "Generic" {
			local studysize _meta_studysize
	}
	local nobs : char _dta[_meta_K]
	local model  : char _dta[_meta_model]
	local method : char _dta[_meta_method]
	
	local esvar : char _dta[_meta_esvar]
	if missing("`esvar'") local esvar "_meta_es"
	
	local estype : char _dta[_meta_estype]
	local eslab : char _dta[_meta_eslabel]
	
	local datavars : char _dta[_meta_datavars]
	tokenize `datavars'
	local nvar : word count `datavars'
		
	if (`nvar' == 2) {
		local sevar "`2'"
		local cilvar "_meta_cil"
		local ciuvar "_meta_ciu"			  
	}
	else if (`nvar' == 3) {
		local sevar "_meta_se"
		local cilvar `2'
		local ciuvar `3'			  
	}
	else {
		local sevar "_meta_se"
		local cilvar "_meta_cil"
		local ciuvar "_meta_ciu"
	}
	
	meta__di_metainfo, nobs(`nobs') 	///
		  stlbl(`studylabel') 		///
		  stsize(`studysize') 		///
		  estype(`estype') 		///
		  eslbl(`eslab') 		///
		  esvar(`esvar')		///
		  sevar(`sevar')		///
		  cilvar(_meta_cil) 		///
		  ciuvar(_meta_ciu)		///
		  ciluser(`cilvar') 		///
		  ciuuser(`ciuvar')		///
		  level(`level')		///
		  method(`method')		///
		  model(`model')		///
		  ismetaq			///
		  `short'
end
