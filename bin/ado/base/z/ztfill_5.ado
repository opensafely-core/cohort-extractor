*!  version 5.0.1  15sep2004
program define ztfill_5
	version 5.0, missing
	di in gr "(you are running stfill from Stata version 5)"
	zt_is_5
	local varlist "req ex"
	local if "opt"
	local in "opt"
	local options "Baseline Forward noSHow"
	parse "`*'"

	local nopts = ("`baselin'"!="")+("`closest'"!="")+("`forward'"!="")
	if `nopts'>1 {
		di in red /*
		*/ "may specify only one of forward and baseline"
		exit 198
	}
	if `nopts'<1 {
		di in red /*
		*/ "must specify either baseline or forward"
		exit 198
	}

	zt_sho_5 `show'
	di
	local id : char _dta[st_id]
	if "`id'"=="" {
		di in gr /*
*/ "(note: stfill amounts to a request to do nothing with single-record st data)"
		exit
	}

	tempvar mayrep hold notmis
	mark `mayrep' `if' `in'

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]

	parse "`varlist'", parse(" ")

	local ismis "(!`notmis')"
	sort `id' `t'
	if "`baselin'"!="" {
		di in gr "replace all values with value at earliest observed:"
	}
	else {
		di in gr "replace missing values with previously observed values:"
	}
	while "`1'"!="" {
		local skip = 16 - length("`1'")
		zt_iss_5 `1'
		if $S_1==0 {
			local ty : type `1'
			quietly {
				gen `ty' `hold' = `1'
				mark `notmis'
				markout `notmis' `1', strok

				if "`baselin'"!="" {
					by `id': replace `1'=`1'[1] if `mayrep' 
				}
				else /* if "`forward'"!="" */ {
					by `id': replace `1'=`1'[_n-1] /* 
					*/ if `ismis' & `mayrep'
				}
				count if `hold'!=`1'
				local repd = _result(1)
				drop `notmis'
				mark `notmis'
				markout `notmis' `1', strok
				count if `hold'!=`1' & `ismis'
				local tomis = _result(1)
			}
			if `repd'==1 {
				local change "change "
			}
			else	local change "changes"
			di in gr _skip(`skip') "`1':  " in ye "`repd'" /*
			*/ in gr " real `change' made" _c
			if `tomis' {
				di in gr "; " in ye "`tomis'" in gr /*
				*/ " to missing"
			}
			else	di
			drop `notmis' `hold'
		}
		mac shift
	}
end
