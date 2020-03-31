*! version 1.0.0  24aug2016
program define fredsearch, rclass
	version 15
	
	gettoken serlist rest : 0, parse(",")
	
	syntax [anything], [KEYwords(string) 				///
			   DETail					/// 
			   IDonly 					///
			   SORT(string)					///
			   TAGS(string asis) 				///
			   TAGList 					///
			   SAVing(string)]
	
	if `"`anything'"' == "" {
		di as err "invalid syntax"
		di as err "{p 4 4 2}keywords must be specified{p_end}"
		exit 198
	}
		
	local search_keywords `anything'
	
	local search_tags
	tokenize `"`tags'"'
	local first `"`1'"' 
	local tcount 0
	while "`first'"!="" {
		if `tcount'==0 {
			local search_tags = "`first'"
		}
		else {
			local search_tags = "`search_tags';`first'"
		}
		macro shift 
		local tcount = `tcount'+1
		local first `"`1'"' 
	}
	
	if `"`idonly'"' != "" & `"`taglist'"' != "" {
		di as err "options {bf:idonly} and {bf:taglist} may"	///
			" not be specified together"
		exit 198
	}
	
	if `"`saving'"' != "" & `"`taglist'"' != "" {
		di as err "options {bf:saving()} and {bf:taglist} may"	///
			" not be specified together"
		exit 198
	}
	
	if `"`detail'"' != "" & `"`taglist'"' != "" {
		di as err "options {bf:detail} and {bf:taglist} may"	///
			" not be specified together"
		exit 198
	}
	
	if `"`saving'"' != "" {		
		local savefile
		local saveopts
		check_saving_file savefile saveopts : `"`saving'"'
		
		quietly preserve
		quietly clear
	}

	javacall com.stata.plugins.fred.Fred2Stata getSeriesSearch, 	///
		args(`"`search_keywords'"' `"`idonly'"' `"`sort'"' 	///
		     `"`search_tags'"' `"`taglist'"' `"`detail'"' 	///
		     `"`savefile'"') jars(libstata-plugin.jar)
		
	if `"`savefile'"' != "" {
		quietly compress
		quietly drop if _n == _N
		quietly save `"`savefile'"', `saveopts'
		quietly clear
		quietly restore
	}

	if "$fred_series" != "" {
		return local series_ids = "$fred_series"
		macro drop fred_series
	}
end

program define check_saving_file
	args savefile saveopts colon saving_file
	
	local 0 `saving_file'
	syntax [anything] [, REPLACE]
	if `"`anything'"' != "" {
		local _savefile `anything'
		if `"`replace'"' != "" {
			local _save_opts "replace"
		} 
	}
	else {
		di as err "option {bf:saving()} incorrectly specified"
		di as err "{p 4 4 2}a filename must be specified{p_end}"
		exit 198
	}
	
	if bsubstr("`_savefile'",-4,.)!=".dta" {
		local _savefile `"`_savefile'.dta"'
	}
	
	capture confirm file `_savefile'
	if !_rc & `"`_save_opts'"' == "" {
		di as err "file " `"`_savefile'"' " already exists"
		exit 602
	}
	
	c_local `savefile' `"`_savefile'"'
	c_local `saveopts' `"`_save_opts'"'
end
