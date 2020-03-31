*! version 6.0.0  16jul1998
program define sttoct /* die cens [ent], by(...) */
	version 6

	if _caller()<6 {
		zttoct_5 `0'
		exit
	}

	st_is 2 analysis

	syntax newvarlist(max=3) [, BY(varlist) CLEAR REPLACE noSHow ]

	tokenize `varlist'
	local die "`1'"
	local cens "`2'"
	local ent "`3'"

	quietly describe, short
	if "`clear'"=="" & "`replace'"=="" & r(changed) { error 4 }

	st_show `show'

	local id : char _dta[st_id]

	if "`ent'"=="" {
		capture t0igable "`by'" "`id'"
		if _rc {
			di in red /*
*/ "you must specify third, enter variable" _n /*
*/ "st data has entry-time and/or id variable that matter" _n /*
*/ "the actual or implied entry time is not always 0  or lagged _t," _n /*
*/ "at least within by group"
			exit 198
		}
	}

	preserve 
	quietly { 
		keep if _st
		keep _t _t0 _d `id' `_dta[st_wv]' `by' _st
		if "`ent'"=="" {
			if "`id'"!="" {
				sort `by' `id' _t
				by `by' `id': keep if _n==_N
				drop `id'
				char _dta[st_id]
			}
			replace _t0 = 0
		}
		tempvar pop 
		st_ct "`by'" -> _t `pop' "`die'" "`cens'" "`ent'"
		local cond "`die'==0"
		if "`cens'" != "" {
			local cond "`cond' & `cens'==0"
		}
		if "`ent'"!= "" {
			local cond "`cond' & `ent'==0"
		}
		drop if `cond'

		tempvar ht
		local newt `_dta[st_bt]'
		rename _t `ht'
		stset, clear 
		capture drop `newt'
		rename `ht' `newt'
	}
	if "`by'"!="" {
		local by "by(`by')"
	}
	global S_FN
	global S_FNDATE
	di _n in gr "data is now ct" _n
	ctset `newt' `die' `cens' `ent', `by'
	restore, not
end
			



/*
	determine if _t0 and/or id are ignorable
	(can be summed over)
*/


program define t0igable /* "[by]" "[id]" */
	args by id

	if "`id'"=="" {
		assert _t0==0 if _st
		exit
	}

	sort _st `by' `id' _t
	by _st `by' `id': assert _t0==cond(_n==1,0,_t[_n-1]) if _st
	by _st `by' `id': assert _d==0 if _n<_N & _st
end
