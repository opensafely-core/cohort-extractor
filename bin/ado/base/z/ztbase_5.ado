*! version 5.1.2  09feb2015
program define ztbase_5
	version 5.0, missing
	di in gr "(you are running stbase from Stata version 5)"

	zt_is_5

	local if "opt"
	local in "opt"
	local options "AT(real -1) Gap(string) CLEAR noPREserve noSHow"
	parse "`*'"

	if "`clear'"=="" {
		qui desc
		if _result(7) { error 4 }
	}

	if `at'!= -1 {
		if `at'<=0 {
			di in red "at() <= 0 invalid"
			exit 198
		}
		if "`gap'"=="" {
			MakeVar gap() gap gaptime 
			local gap "$S_1"
		}
	}
	else {
		if "`gap'"!="" {
			di in red "gap() invalid without at()"
			exit 198
		}
	}


	zt_sho_5 `show'

	tempvar touse
	zt_smp_5 `touse' "`if'" "`in'"

	if "`preserv'"=="" {
		preserve
		local unpres "restore, not"
	}
	quietly {
		keep if `touse'
		drop `touse'
	}

	if `at'!= -1 {
		BaseAt "`at'" "`gap'"
	}
	else {
		BaseST
	}
	global S_FN
	global S_FNDATE
	`unpres'
end


program define BaseST
	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]

	if "`id'"=="" {
		di _n in gr /*
		*/ "nothing to do; single-record st data already baseline"
		exit
	}
	sort `id' `t'
	capture by `id': assert _N==1
	if _rc==0 { 
		di _n in gr "nothing to do; data has one record per id(" /*
		*/ in ye "`id'" in gr ") and so is already baseline"
		exit
	}

	tempvar sub
	Subid `sub'
	local gaps $S_1
	local mult $S_2
	quietly {
		by `id' `sub': replace `d'=sum(`d'!=0)
		by `id' `sub': replace `d'=`d'[_N]
		by `id' `sub': replace `t'=`t'[_N]
		by `id' `sub': keep if _n==1
		if `gaps' | `mult' {
			tempvar cnt
			by `id': gen `c(obs_t)' `cnt'=_N if _n==1
			expand `cnt'
			sort `id' `sub'
			by `id': replace `d'=`d'[_n+`cnt'-1] /*
				*/ if `sub'==1 & _n>1
			by `id': replace `t0'=`t0'[_n+`cnt'-1] /*
				*/ if `sub'==1 & _n>1
			by `id': replace `t' =`t'[_n+`cnt'-1] /*
				*/ if `sub'==1 & _n>1
			keep if `sub'==1
		}
	}

	if `gaps' {
		local gverb "there were"
	}
	else	local gverb "no"
	if `mult' {
		local mverb "there were"
	}
	else	local mverb "no"
	if `gaps' | `mult' {
		local recs "multiple records"
	}
	else	local recs "one record"

	#delimit ;
	di in gr 
"notes:" _n
"    1.  `gverb' gaps" _n
"    2.  `mverb' multiple failures or re-entries after failures" _n
"    3.  baseline data has `recs' per id(" in ye "`id'" in gr ")" ;
	#delimit cr
	if `gaps' | `mult' {
		di in gr "    4.  all records have been covariate values at baseline"
end

program define BaseAt /* at newgapvar */
	local at "`1'"
	local gap "`2'"

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local wv : char _dta[st_wv]

	quietly {
		if "`t0'"!="" {
			drop if `t0'>=`at'
		}
		replace `d'=0 if `t'>`at'
		replace `t'=`at' if `t'>`at'
		replace `d' = 1 if `d'!=0
		if "`id'" != "" {
			sort `id' `t'
			by `id': gen double `gap' = sum(`t0'-`t'[_n-1])
			by `id': replace `gap' = `gap'[_N]
			by `id': replace `d' = sum(`d')
			by `id': replace `t' = sum(`t'-`t0')
			by `id': replace `d' = `d'[_N]
			by `id': replace `t' = `t'[_N]
			by `id': keep if _n==1
			compress `gap'
		}
		else {
			if "`t0'" != "" {
				replace `t' = `t' - `t0'
			}
			gen byte `gap'=0
		}
		stset, clear 
		drop if `t'<`at' & `d'==0
	}
	label var `t' "time at risk"
	label var `gap' "time on gap"
	di _n in gr _col(12) /*
	*/ "data now cross-section at time " in ye "`at'"
	DispHdr
	Displine "`id'" "subject identifier"
	Displine "`t0'" "first entry time"
	Displine "`gap'" "time on gap"
	Displine "`t'"  "time at risk"
	Displine "`d'"  "number of failures during interval `t'"
	Displine "`wv'" "weight variable from original sample"
	summarize `t0' `gap' `t' `d'
end

program define DispHdr
	di _n in gr "Variable | description" _n /* 
	*/ _dup(9) "-" "+" _dup(52) "-"
end

program define Displine /* varname label */
	local v "`1'"
	local ttl "`2'"
	if "`v'"=="" { 
		exit 
	}
	local skip = 8-length("`v'")
	di in gr _skip(`skip') in ye "`v'" in gr " |  `ttl'"
end


program define MakeVar /* opname <potential-name-list> */
	local option "`1'"
	mac shift
	local list "`*'"
	while "`1'"!="" {
		capture confirm new var `1'
		if _rc==0 {
			global S_1 "`1'"
			exit
		}
		mac shift
	}
	di in red "could not find variable name for `option'"
	di in red "      tried:  `list'"
	di in red "      specify `option' explicitly"
	exit 110
end


program define Subid /* newvar */
	local sub "`1'"
	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]

	quietly { 
		sort `id' `t'
		by `id': gen `c(obs_t)' `sub'=1 if _n==1
		capture by `id': assert `t0'==`t'[_n-1] if _n>1
		if _rc {
			by `id': replace `sub'=1 if `t0'!=`t'[_n-1] & _n>1
			local gaps 1
		}
		else	local gaps 0
		capture by `id': assert `d'[_n-1]==0 if _n>1
		if _rc {
			by `id': replace `sub'=1 if `d'[_n-1]!=0 & _n>1
			local mult 1
		}
		else	local mult 0
		by `id': replace `sub'=sum(`sub')
		sort `id' `sub' `t'
	}
	global S_1 `gaps'
	global S_2 `mult'
end
exit

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


on return, the data is sorted by `id' `subid' `t'
Returns:
	$S_1	0  data has no gaps
		1  data has gaps

	$S_2	0  data is single-failure data
		1  data is multiple failure (or re-entry after censoring)
exit
