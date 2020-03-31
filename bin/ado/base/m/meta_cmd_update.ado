*! version 1.0.1  03oct2019
program meta_cmd_update
	version 16
	
	cap confirm variable _meta_es _meta_se
	if _rc {
		meta__notset_err
	}
	
	syntax  [,						///
		ESize(string)					///
		random(string) 					///
		RANDOM1						///
		fixed(string)  					///
		FIXED1  					///
		common(string)  				///
		COMMON1  					///
		ESLABel(string)  				///
		Level(string) 					///
		STUDYLABel(varlist min=1 max=2) 		///
		ZEROCELLs(string)				///
		studysize(varname numeric)			///
		NOMETASHOW					///	
		METASHOW1					///
		keepweight					/// Undoc
		keepstudylbl					/// Undoc
		]
	
	if !missing("`metashow1'") & !missing("`nometashow'") {
		di as err ///
		"only one of {bf:metashow} or {bf:nometashow} is allowed"
		exit 198
	}
	
	if "`: char _dta[_meta_datatype]'"=="Generic" {
		syntax  [,					///
		ESize(string)					///
		random(string) 					///
		RANDOM1						///
		fixed(string)  					///
		common(string)  				///
		ESLABel(string)  				///
		Level(string) 					///
		STUDYLABel(varlist min=1 max=2) 		///
		studysize(varname numeric)			///
		ZEROCELLs(string) NOMETASHOW			///	
		METASHOW1 keepweight keepstudylbl * ]
		
		local which `esize' `zerocells' `common' `fixed'
		local k : word count `which'
		if `k' > 0 {
			di as err "{p}options {bf:esize()}, " 	///
			"{bf:zerocells()}, {bf:common()}, and " ///
			"{bf:fixed()} not possible with data " 	///
			"declared with {bf:meta set}{p_end}"
			exit 198 
		}
		
		local if : char _dta[_meta_ifexp]
		local in : char _dta[_meta_inexp]
		local ifin `if' `in'
		
		if !missing("`metashow1'") local metashow
		else {
			if missing("`nometashow'") {
				local metashow : char _dta[_meta_show]
			}
			else {
				local metashow nometashow
			}
		}
		
		if missing("`studylabel'") { 
			local id : char _dta[_meta_studylabel]
			if "`id'" != "Generic" {
				local studylabel ///
					`: char _dta[_meta_studylabel]'
			}	
		}
		if missing("`level'") {
			local level : char _dta[_meta_level]
		}
		
		if missing("`eslabel'") {
			local eslabel : char _dta[_meta_eslabel]
		}
		local 0, `options'
		syntax [, fixed common ]
		if missing("`studysize'") {
			local studysize : char _dta[_meta_studysize]
		}
		
		local civarlevel : char _dta[_meta_civarlevel]
		
		local datavars : char _dta[_meta_datavars]
		if missing("`random'`fixed'`common'`random1'") {
			local model  : char _dta[_meta_model]
			local method : char _dta[_meta_method]
			if "`model'" == "random" {
				local mamodel random(`method')
			}
			else if "`model'" == "common" {
				local mamodel common
			}
			else if "`model'" == "fixed" {
				local mamodel fixed
			}
		 
			meta set `datavars' `ifin',  `mamodel' 	    ///
				studylabel(`studylabel') ismetaq    ///
				level(`level') eslabel(`eslabel')   ///
				`metashow' studysize(`studysize')   ///
				civarlevel(`civarlevel') 	    ///
				`keepweight' `keepstudylbl'
				
		}
		else {
			meta set `datavars' `ifin', random(`random') ///
			`fixed' `common'  studylabel(`studylabel')   ///
			 level(`level') eslabel(`eslabel') `random1' ///
			`metashow' studysize(`studysize') ismetaq    ///
			civarlevel(`civarlevel') `keepweight' `keepstudylbl'
			
		}
	}
	else {
		local if : char _dta[_meta_ifexp]
		local in : char _dta[_meta_inexp]
		local ifin `if' `in'
		
		if !missing("`metashow1'") local metashow
		else {
			if missing("`nometashow'") {
				local metashow : char _dta[_meta_show]
			}
			else {
				local metashow nometashow
			}
		}
		
		if missing("`eslabel'") {
			local eslabopt : char _dta[_meta_eslabelopt]
			if missing("`esize'") & !missing("`eslabopt'") { 
				local eslabel : char _dta[_meta_eslabel]
			}
			else {
				local eslabel
			}
		}
		if missing("`esize'") {
			local esizeopt : char _dta[_meta_esizeopt]
			if missing("`esizeopt'") local esize
			else {
				local esize "`: char _dta[_meta_estype]'"
				local es_ex "`: char _dta[_meta_esopt_exact]'"
				local es_un "`: char _dta[_meta_esopt_unequal]'"
				local es_ho "`: char _dta[_meta_esopt_holkinse]'"
				local esopts `"`es_ex' `es_un' `es_ho'"'
				local esopts : list retokenize esopts
				if !missing("`esopts'") {
					local esopts `", `esopts'"'
				}	
			}
		}	
		if missing("`studylabel'") { 
			local id : char _dta[_meta_studylabel]
			if "`id'" != "Generic" {
				local studylabel `: char _dta[_meta_studylabel]'
			}	
		}
		if missing("`level'") {
				local level : char _dta[_meta_level]
				if "`level'" == "95" local level
		}
	
		if missing("`zerocells'") {
			local zcopt : char _dta[_meta_zcopt]
			if !missing("`zcopts'") {
				local zcadj : char _dta[_meta_zcadj]
				if "`zcadj'"=="none" | ///
					"tacc"==bsubstr("`zcadj'",1,4) { 
					local cc "`zcadj'"
				}
				else {
					local cc "`: char _dta[_meta_zcvalue]'"
					if !missing("`cc'") {
						local cc ///
						"`cc', `: char _dta[_meta_zcadj]'"

					}
				}
			}
			else local cc
		}
		else {
			local cc `zerocells'
		}
		
		local datavars : char _dta[_meta_datavars]
		local mod `"`random'`fixed'`fixed1'`common'`common1'`random1'"'
		if missing(`"`mod'"') {
			local model  : char _dta[_meta_model]
			local method : char _dta[_meta_method]
			local randomopt : char _dta[_meta_randomopt]
			if missing("`randomopt'") & "`model'"=="random" {
				local mamodel
			}
			else local mamodel `model'(`method')  
			meta esize `datavars' `ifin',			  ///
				esize(`esize'`esopts')			  ///
				studylabel(`studylabel')         	  ///
					zerocells(`cc') level(`level')    ///
				eslabel(`eslabel') `mamodel'      	  /// 
				`metashow' ismetaq `keepweight' `keepstudylbl'
		}
		else {
			meta esize `datavars' `ifin', 			 ///
				esize(`esize'`esopts')     		 ///
				random(`random') common(`common') 	 ///
				studylabel(`studylabel')          	 ///
				zerocells(`cc')                   	 ///
				level(`level') eslabel(`eslabel') 	 ///
				`fixed1' fixed(`fixed') 		 ///
				`common1' `random1' `metashow'    	 ///
				ismetaq	`keepweight' `keepstudylbl'
		}	
	}
		
end		
