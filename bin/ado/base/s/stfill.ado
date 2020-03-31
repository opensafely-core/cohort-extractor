*!  version 6.0.2  15sep2004
program define stfill, sort
	version 6, missing
	if _caller()<6 {
		ztfill_5 `0'
		exit
	}

	st_is 2 full
	syntax varlist [if] [in] [, Baseline Forward noSHow]

	local nopts = ("`baselin'"!="")+("`closest'"!="")+("`forward'"!="")
	if `nopts'>1 {
		di in red /*
		*/ "may specify only one of options forward and baseline"
		exit 198
	}
	if `nopts'<1 {
		di in red /*
		*/ "must specify either baseline or forward"
		exit 198
	}

	st_show `show'
	di
	local id : char _dta[st_id]
	if `"`id'"'=="" {
		di in gr /*
*/ "(note: stfill with single-record data amounts to a request to do nothing)"
		exit
	}

	tempvar mayrep hold notmis
	mark `mayrep' `if' `in'

	local id : char _dta[st_id]

	tokenize `varlist'

	local ismis `"(!`notmis')"'
	sort _st `id' _t
	if `"`baselin'"'!=`""' {
		di in gr `"replace all values with value at earliest observed:"'
	}
	else {
		di in gr `"replace missing values with previously observed values:"'
	}
	while "`1'"!="" {
		local skip = 16 - length("`1'")
		st_issys `1'
		if `r(boolean)'==0 {
			local ty : type `1'
			quietly {
				gen `ty' `hold' = `1'
				mark `notmis'
				markout `notmis' `1', strok

				if "`baselin'"!="" {
					by _st `id': replace `1'=`1'[1] /*
						*/ if `mayrep' & _st
				}
				else /* if "`forward'"!="" */ {
					by _st `id': replace `1'=`1'[_n-1] /* 
					*/ if `ismis' & `mayrep' & _st
				}
				count if `hold'!=`1'
				local repd = r(N)
				drop `notmis'
				mark `notmis'
				markout `notmis' `1', strok
				count if `hold'!=`1' & `ismis'
				local tomis = r(N)
			}
			if `repd'==1 {
				local change "change "
			}
			else	local change "changes"
			di in gr _skip(`skip') "`1':  " in ye `"`repd'"' /*
			*/ in gr `" real `change' made"' _c
			if `tomis' {
				di in gr "; " in ye `"`tomis'"' in gr /*
				*/ " to missing"
			}
			else	di
			drop `notmis' `hold'
		}
		mac shift
	}
end
