*! version 1.2.0  15may2014
program stcox_footnote
	version 10
	local pararg = min(78,c(linesize))
	if "`e(strata)'" != "" {
		local l = `pararg'-13-length("`e(strata)'")
		di as txt _col(`l') "Stratified by `e(strata)'"
	}
	if "`e(k_eform)'" != "1" {
		local t "tvc"
		if (_caller()<11) local t "t"
		local texp "`e(texp)'"
		di as txt "{p 0 6 0 `pararg'}Note: Variables in " /*
		*/ as res "`t'" as txt /*
		*/ " equation interacted with `texp'.{p_end}"
	}
end
