*! version 1.0.0  17may2016
program bayesmh_wrk_dlg
	args dlgname list_name sreturns issum
	version 14

	local dlg_name "`dlgname'"

	local i = 1
	foreach sret of local sreturns {
		local xx "``sret''"
		foreach param of local xx {
			.`dlg_name'.`list_name'[`i'] = "`param'"
			local ++i
		}
	}

	if `issum' {
		.`dlg_name'.`list_name'[`i'] = "_loglikelihood"
		local ++i
		.`dlg_name'.`list_name'[`i'] = "_logposterior"
	}

//	clslistarray .`dlg_name'.`list_name'
end
