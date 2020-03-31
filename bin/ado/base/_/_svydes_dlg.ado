*! version 1.0.1  30mar2007
program _svydes_dlg
	// NOTE: this is an ado subroutine for svydescribe.dlg
	local max : char _dta[_svy_stages]
	capture confirm integer number `max'
	if c(rc) {
		local max 1
	}
	else {
		local su : char _dta[_svy_su`max']
		if `"`su'"' == "_n" {
			local --max
		}
		if `max' < 1 {
			local max 1
		}
	}
	if `max' > 1 {
		.svydescribe_dlg.main.sp_stage.setrange 1 `max'
	}
	else {
		.svydescribe_dlg.main.tx_stage.disable
		.svydescribe_dlg.main.sp_stage.disable
	}
end
