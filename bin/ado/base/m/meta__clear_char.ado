*! version 1.0.0  07may2019

program meta__clear_char
	version 16
	
	syntax, [ replace]
	
	char _dta[_meta_setcmdline]
	char _dta[_meta_ifexp]
	char _dta[_meta_inexp]
	char _dta[_meta_method]
	char _dta[_meta_methodlabel]
	char _dta[_meta_metashow]
	char _dta[_meta_studysize]
	char _dta[_meta_datavars]
	char _dta[_meta_model]
	char _dta[_meta_modellabel]
	char _dta[_meta_randomopt]
	char _dta[_meta_studylabel]
	char _dta[_meta_eslabel]
	char _dta[_meta_eslabeldb]
	char _dta[_meta_eslabelopt]
	char _dta[_meta_datatype]
	char _dta[_meta_estype]
	char _dta[_meta_esize]
	char _dta[_meta_esizeopt]
	char _dta[_meta_zcvalue]
	char _dta[_meta_zcadj]
	char _dta[_meta_zcopt]
	char _dta[_meta_level]
	char _dta[_meta_K]
	char _dta[_meta_marker]
	char _dta[_meta_sevar]
	char _dta[_meta_esvar]
	char _dta[_meta_esvardb]
	char _dta[_meta_cilvar] 
	char _dta[_meta_ciuvar] 
	char _dta[_meta_civarlevel] 
	char _dta[_meta_studylabel]
	char _dta[_meta_esopt_exact]	
	char _dta[_meta_esopt_holkinse] 
	char _dta[_meta_esopt_unequal] 
	char _dta[_meta_n1var]		
	char _dta[_meta_mean1var]	
	char _dta[_meta_sd1var]		
	char _dta[_meta_n2var]		
	char _dta[_meta_mean2var]	
	char _dta[_meta_sd2var]	
	char _dta[_meta_n11var] 
	char _dta[_meta_n12var] 
	char _dta[_meta_n21var] 
	char _dta[_meta_n22var] 
	
	if !missing("`replace'") {
		save, replace
	}
end
