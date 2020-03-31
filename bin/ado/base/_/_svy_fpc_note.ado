*! version 1.1.2  05feb2014
program _svy_fpc_note
	version 9
	args deff linesize bmat

	if ("`bmat'"=="") {
		local bmat e(b)
	}
	if ("`e(mi)'"=="mi") {
		local wse "within-imputation "
	}
	if e(census) == 1 {
		local colna : colna `bmat'
		if `:list sizeof colna' > 1 {
			local s "s"
		}
		di as txt "{p 0 6 0 `linesize'}" ///
"Note: Zero `wse'standard error`s' because of 100% sampling rate detected" ///
" for FPC in the first stage.{p_end}"
	}
	else if `"`e(fpc1)'"' != "" & "`deff'"!="" ///
			& inlist("`e(singleton)'","","0")  {
		di as txt "{p 0 6 0 `linesize'}" ///
"Note: Weights must represent population totals for deff to" ///
" be correct when using an FPC; however, deft is invariant" ///
" to the scale of weights.{p_end}"
	}
end
exit
