*! version 1.0.0  12sep2010
program use_option_wrk_dlg
	version 11
	syntax using
	capture describe `using', varlist
	if _rc {
		.use_option_dlg.main_des_error.setvalue 1
	}
	else {
		local osclist_name ///
			`"`.use_option_dlg.main.cb_using.contents'"'
		local i = 1
		foreach var in `r(varlist)' {
			.use_option_dlg.`osclist_name'[`i'] = "`var'"
			local ++i
		}
	}
end
