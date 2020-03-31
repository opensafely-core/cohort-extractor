*! version 6.1.5  28jun2019
program define stbase 
	version 6, missing

	if _caller()<6 {
		ztbase_5 `0'
		exit
	}

	st_is 2 analysis 
	syntax [if] [in] [, AT(real -1) Gap(string) CLEAR REPLACE /*
		*/ noPREserve noSHow]

	if `"`clear'"'=="" & "`replace'"=="" {
		qui desc
		if r(changed) { error 4 }
	}

	if `at'!= -1 {
		if `at'<=0 {
			di in red `"at() <= 0 invalid"'
			exit 198
		}
		if `"`gap'"'=="" {
			MakeVar gap() gap gaptime 
			local gap `"`s(var)'"'
		}
	}
	else {
		if `"`gap'"'!="" {
			di in red `"gap() invalid without at()"'
			exit 198
		}
	}


	st_show `show'

	tempvar touse
	st_smpl `touse' `"`if'"' `"`in'"'

	if `"`preserv'"'==`""' {
		preserve
		local unpres `"restore, not"'
	}
	quietly {
		keep if `touse'
		drop `touse'
	}

	if `at'!= -1 {
		BaseAt `"`at'"' `"`gap'"'
	}
	else {
		BaseST
	}
	global S_FN
	global S_FNDATE
	`unpres'
end


program define BaseST 
	local id : char _dta[st_id]

	if `"`id'"'=="" {
		di _n in gr /*
		*/ `"nothing to do; single-record st data already baseline"'
		exit
	}
	sort `id' _t
	capture by `id': assert _N==1
	if _rc==0 { 
		di _n in gr `"nothing to do; data have one record per id("' /*
		*/ in ye `"`id'"' in gr `") and so is already baseline"'
		exit
	}

	tempvar sub
	st_subid `sub'
	local gaps `r(gaps)' 
	local mult `r(mult)'
	quietly {
		by `id' `sub': replace _t=_t[_N]

	/* adjust user variables which we do not use */ 
		IsVar `_dta[st_bd]'
		if `s(exists)' {
			by `id' `sub': replace `_dta[st_bd]' = `_dta[st_bd]'[_N]
		}
		IsVar `_dta[st_bt]'
		if `s(exists)' {
			by `id' `sub': replace `_dta[st_bt]' = `_dta[st_bt]'[_N]
		}
	/* end adjust user variables */

		by `id' `sub': keep if _n==1

		if `gaps' | `mult' {
			tempvar cnt
			by `id': gen `c(obs_t)' `cnt'=_N if _n==1
			expand `cnt'
			sort `id' `sub'
			by `id': replace _d = 1 if `sub'==1 & _n>1
			by `id': replace _t0=_t0[_n+`cnt'-1] /*
				*/ if `sub'==1 & _n>1
			by `id': replace _t =_t[_n+`cnt'-1] /*
				*/ if `sub'==1 & _n>1

	/* adjust user variables which we do not use */
			IsVar `_dta[st_bt]'
			if `s(exists)' {
				by `id': replace `_dta[st_bt]' = /*
				*/ `_dta[st_bt]'[_n+`cnt'-1] /*
				*/ if `sub'==1 & _n>1
			}
			IsVar `_dta[st_bd]'
			if `s(exists)' {
				by `id': replace `_dta[st_bd]' = /*
				*/ `_dta[st_bd]'[_n+`cnt'-1] /*
				*/ if `sub'==1 & _n>1
			}
			IsVar `_dta[st_bt0]'
			if `s(exists)' {
				if `"`_dta[st_bt0]'"' != "" {
				by `id': replace `_dta[st_bt0]' = /*
					*/ `_dta[st_bt0]'[_n+`cnt'-1] /*
					*/ if `sub'==1 & _n>1
				}
			}
	/* end adjust user variables */

			keep if `sub'==1
		}
	}
	st_note "records now baseline (stbase run)"
	char _dta[st_set] "may not streset after running stbase"

	if `gaps' {
		local gverb `"there were"'
	}
	else	local gverb `"no"'
	if `mult' {
		local mverb `"there were"'
	}
	else	local mverb `"no"'
	if `gaps' | `mult' {
		local recs `"multiple records"'
	}
	else	local recs `"one record"'

	#delimit ;
	di in gr 
`"notes:"' _n
`"    1.  `gverb' gaps"' _n
`"    2.  `mverb' multiple failures or reentries after failures"' _n
`"    3.  baseline data have `recs' per id("' in ye `"`id'"' in gr `")"' ;
	#delimit cr
	if `gaps' | `mult' {
		di in gr /*
	*/ `"    4.  all records have covariate values at baseline"'
	}
end



program define BaseAt /* at newgapvar */
	args at gap

	local id : char _dta[st_id]
	local wv : char _dta[st_wv]

	quietly {
		drop if _t0>=`at'
		replace _d=0 if _t>`at'
		replace _t=`at' if _t>`at'
		if `"`id'"' != `""' {
			sort `id' _t
			by `id': gen double `gap' = sum(_t0-_t[_n-1])
			by `id': replace `gap' = `gap'[_N]
			by `id': replace _d = sum(_d)
			by `id': replace _t = sum(_t-_t0)
			by `id': replace _d = _d[_N]
			by `id': replace _t = _t[_N]
			by `id': keep if _n==1
			compress `gap'
		}
		else {
			replace _t = _t - _t0
			gen byte `gap'=0
		}

		/* we will ultimately name 
			_t	`_dta[st_bt]'   t        time    _t
			_t0	`_dta[st_bt0]'  t0       time0   _t0
			_d	`_dta[st_bd]'   failure  _d
		*/

		tempvar ht ht0 hd
		rename _t `ht'
		rename _t0 `ht0'
		rename _d `hd'

		capture drop `_dta[st_bt]'
		capture drop `_dta[st_bt0]'
		capture drop `_dta[st_bd]'
		MakeVar " " `_dta[st_bt]' t time _t
		local newt `s(var)'
		MakeVar " " `_dta[st_bt0]' t0 time0 _t0
		local newt0 `s(var)'
		MakeVar " " `_dta[st_bd]' failure _d 
		local newd `s(var)'

		stset, clear 
		rename `ht' `newt'
		rename `ht0' `newt0'
		rename `hd' `newd'

		drop if `newt'<`at' & `newd'==0
	}
	label var `newt' `"time at risk"'
	label var `gap' `"time on gap"'
	label var `newt0' "first entry time"
	label var `newd' "number of failures"

	di _n in gr _col(12) /*
	*/ `"data now cross-section at time "' in ye `"`at'"'
	DispHdr
	Displine `"`id'"' `"subject identifier"'
	Displine `"`newt0'"' `"first entry time"'
	Displine `"`gap'"' `"time on gap"'
	Displine `"`newt'"'  `"time at risk"'
	Displine `"`newd'"'  `"number of failures during interval `newt'"'
	Displine `"`wv'"' `"weight variable from original sample"'
	summarize `newt0' `gap' `newt' `newd'
end

program define DispHdr
	di in smcl _n in gr `"    Variable {c |} description"' _n /* 
	*/ "{hline 13}{c +}{hline 52}"
end

program define Displine /* varname label */
	args v ttl
	if `"`v'"'==`""' { 
		exit 
	}
	local skip = 8-length(`"`v'"')
	di in smcl in gr %12s abbrev(`"`v'"',12) `" {c |}  `ttl'"'
end


program define MakeVar, sclass /* opname <potential-name-list> */
	local option `"`1'"'
	mac shift
	local list `"`*'"'
	while `"`1'"'!=`""' {
		capture confirm new var `1'
		if _rc==0 {
			sret local var `"`1'"'
			exit
		}
		mac shift
	}
	di in red `"could not find variable name for `option'"'
	di in red `"      tried:  `list'"'
	di in red `"      specify `option' explicitly"'
	exit 110
end


* see comments at end of file
program define st_subid /* newvar */, rclass
	local sub "`1'"
	local id : char _dta[st_id]

	quietly { 
		sort `id' _t
		by `id': gen `c(obs_t)' `sub'=1 if _n==1
		capture by `id': assert _t0==_t[_n-1] if _n>1
		if _rc {
			by `id': replace `sub'=1 if _t0!=_t[_n-1] & _n>1
			local gaps 1
		}
		else	local gaps 0
		capture by `id': assert _d[_n-1]==0 if _n>1
		if _rc {
			by `id': replace `sub'=1 if _d[_n-1]!=0 & _n>1
			local mult 1
		}
		else	local mult 0
		by `id': replace `sub'=sum(`sub')
		sort `id' `sub' _t
	}
	ret scalar gaps = `gaps'
	ret scalar mult = `mult'
end

program define IsVar, sclass
	nobreak {
		capture confirm new var `1'
		if _rc {
			capture confirm var `1'
			if _rc==0 { 
				sret local exists 1
				exit 
			}
		}
	}
	sret local exists 0
end


exit

concerning st_subid:
The purpose of this routine is to create a subid variable so one can join
contiguous-time, single-failure records and then form constructs such as

	st_subid `subid'
	by `id' `subid': ...

Examples of records

        ----------------------------------------------------------------> time
        |-----||------||----X|                    3 records, no gap
subid=     1     1       1

        |----------|  |--------||------------X|   3 records, gap
subid=        1            2           2

        |----------|  |----------------------X|   2 records, gap
subid=        1                 2

        |---------X|------||----------X|          3 records
subid=       1        2         2

        |----------|  |-----X||------||------X|   4 records
subid=        1          2       3       3


Each subid is a 
       contiguous span of time 
       ending in a censoring or one failure


on return, the data is sorted by `id' `subid' _t
Returns:
	$S_1	0  data has no gaps
		1  data has gaps

	$S_2	0  data is single-failure data
		1  data is multiple failure (or re-entry after censoring)


exit
