*! version 1.0.1  18apr2017
program sp_wrk_dlg
	version 15
	
	if `"`0'"' == `""' {
		di as err "subcommand required"
		exit 198
	}
	
	gettoken do 0 : 0, parse(" ,")
	local ldo = length("`do'")
	
	if "`do'" == bsubstr("getvars",1,max(7,`ldo')) {
		sp_dlg_getvarlist `0'
		exit
	}
	else if "`do'" == bsubstr("getmat",1,max(6,`ldo')) {
		sp_dlg_getspmatrix `0'
		exit
	}
	else if "`do'" == bsubstr("getshp",1,max(6,`ldo')) {
		sp_dlg_getshpfile `0'
		exit
	}
	else {
		di as err `"unknown subcommand `do'"'
		exit 198
	}
end

program sp_dlg_getvarlist
	syntax using , dlg(string) clist(string)

	capture describe `using', varlist
	if _rc {
		.`dlg'.sp_des_error.setvalue 1
	}
	else {
		local osclist_name ///
			`"`.`dlg'.`clist'.contents'"'
		local i = 1
		foreach var in `r(varlist)' {
			if "`var'" != "_ID" & "`var'" != "_CX" &	///
				"`var'" != "_CY" {
				.`dlg'.`osclist_name'[`i'] = "`var'"
				local ++i
			}
		}
	}
end

program sp_dlg_getspmatrix
	args dlgname list_name

	local dlg_name "`dlgname'"
	quietly spmatrix dir
	local returns = `"`r(names)'"'
	
	local i = 1
	foreach ret of local returns {
		.`dlg_name'.`list_name'[`i'] = "`ret'"
		local ++i
	}
end

program sp_dlg_getshpfile
	args dlgname list_name dshp
	
	local dlg_name "`dlgname'"
	quietly local flist: dir . files "*.dta", respectcase
	
	local i = 1
	foreach ret of local flist {
		if `dshp' == 1 {
			if strpos(`"`ret'"', "_shp.dta") {
				.`dlg_name'.`list_name'[`i'] = "`ret'"
				local ++i
			}
		}
		else if `dshp' == 2 {
			if strpos(`"`ret'"', "_shp.dta")==0 {
				.`dlg_name'.`list_name'[`i'] = "`ret'"
				local ++i
			}			
		}
		else {
			.`dlg_name'.`list_name'[`i'] = "`ret'"
			local ++i
		}
	}
end
