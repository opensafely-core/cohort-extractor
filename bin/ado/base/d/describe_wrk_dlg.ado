*! version 1.0.0  16feb2012
program describe_wrk_dlg
	version 13
	syntax using
	capture describe `using', varlist
	if _rc {
		.describe_dlg.main_des_error.setvalue 1
	}
	else {
		local osclist_name ///
			`"`.describe_dlg.main.cb_using.contents'"'
		local i = 1
		foreach var in `r(varlist)' {
			.describe_dlg.`osclist_name'[`i'] = "`var'"
			local ++i
		}
	}
end
