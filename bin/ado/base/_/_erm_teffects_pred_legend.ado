*! version 1.0.0  14nov2016
program _erm_teffects_pred_legend
	local k = e(kod)
	forvalues i = 1/`k' {
		Legend `"`e(ostripe`i')'"' `"`e(dstripe`i')'"'
		exit
	}
end

program Legend
	args name value
	local len = strlen("`name'")
	local c2 = 14
	local c3 = 16
	di "{txt}{p2colset 1 `c2' `c3' 2}{...}"
	if `len' {
		di `"{p2col:`name'}:{space 1}{res:`value'}{p_end}"'
	}
	else {
		di `"{p2col: }{space 2}{res:`value'}{p_end}"'
	}
	di "{p2colreset}{...}"
end
