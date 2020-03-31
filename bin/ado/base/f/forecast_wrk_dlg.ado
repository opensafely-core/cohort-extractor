*! version 1.1.2  01dec2015
program forecast_wrk_dlg
	version 14

	capture qui .forecast_dlg.TimeFormat.setvalue ""
	if _rc {
		local p = "`.postest_dlg.dlgcmd.value'"
		local s = index("`p'","name(") + 5
		local e = index("`p'",")")
		local e = `e' - `s'
		local n = substr("`p'", `s', `e')
		local dlg_name = "`n'_dlg"
	}
	else {
		local dlg_name forecast_dlg
	}
	.`dlg_name'.ModelInMemory.setfalse
	.`dlg_name'.ModelName.setvalue resource FORECAST_WRK_DLG_MODEL_NO_MODEL_IN_MEMORY
	.`dlg_name'.PeriodRangeMax.setvalue 0

	qui forecast query
	local model_found = r(found)
	local model_name  "`r(name)'"

	if "`r_unit'" != "." & "`r_unit'" != "" & "`r_unit'" != "y" {
		local time_format = "t" + "`r_unit'" + "("
		.`dlg_name'.TimeFormat.setvalue "`time_format'"
	}

	if `model_found' {
		.`dlg_name'.ModelInMemory.settrue
	}
	else {
		exit
	}

	if "`model_name'" != "" {
		.`dlg_name'.ModelName.format "resource FORECAST_WRK_DLG_MODEL_EQUALS_FMT" "`model_name'"
	}
	else {
		.`dlg_name'.ModelName.setvalue resource FORECAST_WRK_DLG_MODEL_FORECAST_MODEL_STARTED
	}

	qui cap xtset

	if !_rc {
		local r_unit = "`r(unit1)'"
		if "`r_unit'" != "." & "`r_unit'" != "" & "`r_unit'" != "y" {
			local time_format = "t" + "`r_unit'" + "("
			.`dlg_name'.TimeFormat.setvalue "`time_format'"
		}
		local num = (`r(tmax)'-`r(tmin)'+1)/`r(tdelta)'
		.`dlg_name'.PeriodRangeMax.setvalue `num'
	}
end
