*! version 1.0.2  15may2016
program _svy_check_stset, rclass sortpreserve
	version 10
	args wvname su_last

	// svyset info
	local wvname	: list retok wvname
	local su_last	: list retok su_last

	// stset info
	local stid	: char _dta[st_id]
	local stwgt	: char _dta[st_w]
	local stwt	: char _dta[st_wt]
	local stwv	: char _dta[st_wv]
	local st_t	: char _dta[st_bt]
	local st_t0	: char _dta[st_bt0]

	if "`stwgt'" != "" & `"`wvname'"' != "" {
		if `"`stwv'"' != "`wvname'" {
			di as err ///
"svyset and stset specify different weight variables"
			exit 459
		}
	}
	if "`wvname'" == "" & "`stwv'" != "" {
		di as txt "(note:  using stset `stwt' variable)"
		local wvname `stwv'
	}
	if !inlist(`"`stwt'"', "", "iweight", "pweight") {
		di as err "`stwt's are not allowed with svy"
		exit 198
	}
	if !inlist(`"`stid'"', "", `"`su_last'"') {
		if `"`su_last'"' == "" {
			local rc = 459
		}
		else {
			sort `stid'
			capture by `stid': assert `su_last' == `su_last'[1]
			local rc = c(rc)
		}
		if `rc' {
			di as err ///
"the stset ID variable is not nested within the final stage sampling units"
			exit 459
		}
	}
	return local stid `"`stid'"'
	return local stwgt `"`stwgt'"'
	return local stwt `"`stwt'"'
	if "`wvname'" != "" {
		return local wexp `"= `wvname'"'
	}
	local wvname : subinstr local wvname "*" " ", all
	local stmarkout `stid' `wvname' `st_t' `st_t0'
	local stmarkout : list retok stmarkout
	return local stmarkout `"`stmarkout'"'

end
