*! version 1.0.0  14feb2017
program gsem_p_wrk_dlg
	args dlgname list_name
	version 15

	local dlg_name "`dlgname'"
	local ecmd "`e(cmd)'"
	local elcls "`e(lclass)'"
	
	if `"`ecmd'"' != "gsem" {
		exit
	}
	if `"`elcls'"' == "" {
		exit
	}
	
	tempname klevels
	mat klevels = e(lclass_k_levels)
	local clevels : colnames klevels

	local k 1
	local lclspec ""
	parse "`clevels'", parse(" ")
	while "`1'" != "" {
		local lclspec = "`lclspec'" + " lclass(" + 	///
			"`1'" + " " + string(klevels[1, `k']) + ")"
		local ++k
		mac shift
	}
	
	gsem_lcspecs, `lclspec'
	
	local i = 1
	local xx "`r(lcspeclist)'"
	foreach param of local xx {
		.`dlg_name'.`list_name'[`i'] = "`param'"
		local ++i
	}
end
