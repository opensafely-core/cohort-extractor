*! version 1.0.0  08jan2009
program merge_wrk_dlg
	version 11
	syntax using
	capture describe `using', varlist
	if _rc {
		.merge_dlg.opt_des_error.setvalue 1
	}
	else {
		local osclist_name ///
			`"`.merge_dlg.opt.cb_keepusing.contents'"'
		local i = 1
		foreach var in `r(varlist)' {
			.merge_dlg.`osclist_name'[`i'] = "`var'"
			local ++i
		}
	}
end
