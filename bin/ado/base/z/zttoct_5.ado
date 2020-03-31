*! version 2.0.0
program define zttoct_5 /* die cens [ent], by(...) */
	version 5.0
	di in gr "(you are running sttoct from Stata version 5)"

	st_is

	quietly describe 
	local ch = _result(7)

	local varlist "req new max(3)"
	tempvar die cens ent
	local options "BY(string) CLEAR noSHow"
	parse "`*'" 
	drop `varlist'
	parse "`varlist'", parse(" ")
	local die "`1'"
	local cens "`2'"
	local ent "`3'"

	if "`clear'"=="" & `ch' { error 4 }

	zt_sho_5 `show'

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local wv : char _dta[st_wv]


	if "`t0'"=="" {
		tempvar t0
		Maket0 "`id'" `t' -> `t0'
	}

	if "`ent'"=="" {
		capture t0igable "`by'" `t' `t0' "`id'" "`d'"
		if _rc {
			di in red /*
*/ "you must specify third, enter variable" _n /*
*/ "st data has entry-time and/or id variable that matter" _n /*
*/ "the actual or implied entry time is not always 0  or lagged `t'," _n /*
*/ "at least within by group"
			exit 198
		}
	}

	preserve 
	quietly { 
		keep `t' `t0' `d' `id' `wv' `by'
		if "`ent'"=="" {
			drop `t0' 
			char _dta[st_t0]
			if "`id'"!="" {
				sort `by' `id' `t'
				by `by' `id': replace `d'=`d'[_N]
				by `by' `id': keep if _n==1
				drop `id'
				char _dta[st_id]
			}
		}
		tempvar pop 
		zt_ct_5 "`by'" -> `t' `pop' "`die'" "`cens'" "`ent'"
		local cond "`die'==0"
		if "`cens'" != "" {
			local cond "`cond' & `cens'==0"
		}
		if "`ent'"!= "" {
			local cond "`cond' & `ent'==0"
		}
		drop if `cond'
		stset, clear 
	}
	if "`by'"!="" {
		local by "by(`by')"
	}
	global S_FN
	global S_FNDATE
	di _n in gr "data is now ct" _n
	ctset `t' `die' `cens' `ent', `by'
	restore, not
end
			


program define Maket0 /* id t -> t0 */
	local id "`1'"
	local t  "`2'"
	local t0 "`4'"

	quietly {
		if "`id'"=="" {
			gen byte `t0' = 0 
			exit
		}
		sort `id' `t'
		local ty : type `t'
		by `id': gen `ty' `t0' = cond(_n==1,0,`t'[_n-1])
	}
end



/*
	determine if t0 and/or id are ignorable
	(can be summed over)
*/


program define t0igable /* "by" t t0 "id" "d" */
	local by "`1'"			/* optional */
	local t "`2'"
	local t0 "`3'"
	local id "`4'"			/* optional */
	local d "`5'"			/* optional */

	if "`id'"=="" {
		assert `t0'==0
		exit
	}

	sort `by' `id' `t'
	by `by' `id': assert `t0'==cond(_n==1,0,`t'[_n-1])
	by `by' `id': assert `d'==0 if _n<_N
end
