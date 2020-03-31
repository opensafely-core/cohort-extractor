*! version 1.1.3  05feb2014
program _svy_singleton_note
	version 9
	syntax [, linesize(int 79) bmat(string)]

	if ("`bmat'"=="") {
		local bmat e(b)
	}
	if ("`e(mi)'"=="mi") {
		if ("`e(singleton_vs_mi)'"=="matrix") {
			local is_singleton 1
			local minote " detected in some imputations"
		}
		else {
			local is_singleton `e(singleton)'
		}
	}
	else {
		local is_singleton `e(singleton)'
	}

	if "`is_singleton'"=="1" {
		if "`e(singleunit)'" == "certainty" {
			if ("`minote'"!="") {
				local minote ",`minote',"
			}
			di as txt "{p 0 6 0 `linesize'}" ///
"Note: Strata with single sampling unit`minote' treated as certainty units." ///
"{p_end}"
		}
		else if "`e(singleunit)'" == "scaled" {
			if e(stages) != 1 {
				local s s
				local within " within each stage"
			}
			di as txt "{p 0 6 0 `linesize'}" ///
"Note: Variance`s' scaled`within' to handle " ///
"strata with a single sampling unit`minote'." ///
"{p_end}"
		}
		else if "`e(singleunit)'" == "centered" {
			if ("`minote'"!="") {
				local minote ",`minote',"
			}
			di as txt "{p 0 6 0 `linesize'}" ///
"Note: Strata with single sampling unit`minote' centered at overall mean." ///
"{p_end}"
		}
		else {
			local colna : colna `bmat'
			if `:list sizeof colna' > 1 {
				local s s
			}
			di as txt "{p 0 6 0 `linesize'}" ///
"Note: Missing standard error`s' because of " ///
"stratum with single sampling unit`minote'." ///
"{p_end}"
		}
	}
end
exit
