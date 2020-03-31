*! version 5.1.4  15oct2019
program define ztset_5
	version 5.0
	di in gr "(you are running stset from Stata version 5)"
	capture u_mi_not_mi_set ztset_5
	if (_rc) {
		di as smcl as err "{p 0 0 2}"
		di as smcl as err "may not use mi data with version 5"
		di as smcl as err "{bf:stset}"
		di as smcl as err "{p_end}"
		exit 198
	}

	if "`*'"=="" {
		Query check
		exit
	}
	if bsubstr("`1'",1,1) == "," {
		zt_is_5
		local curshow : char _dta[st_show]
		if "`curshow'"=="" {
			local shopt "noShow"
		}
		else 	local shopt "Show"
		local options "CLEAR `shopt'"
		parse "`*'" 
		if "`clear'" != "" {
			version 6
			st_set clear
			exit
		}
		if "`show'" != "" {
			if "`curshow'"=="" {
				char _dta[st_show] "noshow"
			}
			else	char _dta[st_show]
		}
		exit
	}
	local varlist "req ex max(2)"
	local weight "fweight pweight iweight noprefix"
	local options "ID(string) GENT0(string) noShow T0(string) FIrst FORCE"
	parse "`*'"
	parse "`varlist'", parse(" ")

	local t "`1'"

	if "`2'" != "" {
		local d "`2'"
	}

	if "`t0'"!="" {
		unabbrev `t0', max(1)
		local t0 "$S_1"
	}

	if "`id'"!="" {
		unabbrev `id', max(1)
		local id "$S_1"
		if "`d'"=="" {
			version 7: di in red /*
		*/ "you must specify a failure variable when you specify option {bf:id()}"
			exit 198
		}
	}

	if "`gent0'"!="" {
		if "`t0'"!="" {
			version 7: di in red "options {bf:t0()} and {bf:gent0()} may not be specified together"
			exit 198
		}
		ChkNew gent0() "`gent0'"
		local gent0 "$S_1"
	}


	if "`weight'"!="" {
		local wtype "`weight'"
		unabbrev `exp', max(1) 
		local wvar "$S_1"
	}

	if "`force'"!="" | "`first'"!="" {
		preserve
		local preserv 1
		local origN = _N
	}

	if "`force'" != "" {
		local fo_oldN = _N
		qui drop if `t'==.
		if "`d'"!="" {
			qui drop if `d'==.
		}
		if "`t0'"!="" {
			qui drop if `t0'==.
		}
		if "`id'"!="" {
			local idt : type `id'
			if bsubstr("`idt'",1,3)=="str" {
				qui drop if `id'==""
			}
			else	qui drop if `id'==.
		}
		if "`wvar'"!="" {
			qui drop if `wvar'==.
		}
		local fo_newN = _N
	}
		
	if "`first'"!="" {
		if "`id'"=="" {
			version 7: di in red "option {bf:first} requires you also specify option {bf:id()}"
			exit 198
		}
		local fi_oldN = _N
		sort `id' `t'
		if "`d'"=="" {
			qui by `id': keep if _n==1
		}
		else {
			qui by `id': drop if sum(`d'[_n-1]!=0 & `d'[_n-1]!=.)>0
		}
		local fi_newN = _N
	}

	Check  "`t0'" `t' "`d'" "`id'" "`wtype'" "`wvar'"

	if "`id'"!="" {
		if "`t0'"=="" & "`gent0'"=="" {
			MakeVar "gent0()" t0 time0 etime
			local gent0 "$S_1"
		}
	}

	if "`gent0'"!="" {
		Maket0 `gent0' `t' "`id'"
		local t0 "`gent0'"
		label var `t0' "entry time"
	}

	st_set clear
	* char _dta[_dta] 
	if "`show'"=="" {
		char _dta[st_show]
	}
	else	char _dta[st_show] "noshow"
	char _dta[st_t] "`t'"
	char _dta[st_t0] "`t0'"
	char _dta[st_d] "`d'"
	char _dta[st_id] "`id'"
	char _dta[st_wt] "`wtype'"
	char _dta[st_wv] "`wvar'"
	if "`wtype'"!="" {
		char _dta[st_w] "[`wtype'=`wvar']"
	}
	else	char _dta[st_w] 
	char _dta[_dta] "st"

	if "`preserv'" != "" {
		restore, not
		if _N != `origN' {
			global S_FN
			global S_FNDATE
		}
	}
	if "`force'" != "" {
		Plural `fo_oldN' - `fo_newN'
		di in gr "note:  " (`fo_oldN'-`fo_newN') /*
		*/ " observation$S_1 dropped due to missing"
	}

	if "`first'"!="" {
		Plural `fi_oldN' - `fi_newN'
		di in gr /*
		*/ "note:  keeping first failures resulted in dropping " /*
			*/ (`fi_oldN'-`fi_newN') " observation$S_1"
	}
	global S_1

	Query nocheck
end

program define Query
	st_is
	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]

	di

	if "$S_FN" != "" {
		di in gr _col(4) "data set name:  " in ye "$S_FN"
	}

	di _col(15) in gr "id:  " _c
	if "`id'"=="" {
		di in gr "--" _skip(20) "(meaning each record a unique subject)"
	}
	else	di in ye "`id'"

	di _col(7) in gr "entry time:  " _c 
	if "`t0'"=="" {
		di in gr "--" _skip(20) "(meaning all entered at time 0)"
	}
	else	di in ye "`t0'"

	di _col(8) in gr "exit time:  " in ye "`t'"


	di _col(3) in gr "failure/censor:  " _c
	if "`d'"=="" {
		di in gr "--" _skip(20) "(meaning all failed)"
	}
	else	di in ye "`d'"


	if "`w'"!="" {
		di in gr _col(11) "weight:  " in ye "`w'"
	}
	if "`1'"=="check" {
		local wtype : char _dta[st_wt]
		local wvar : char _dta[st_wv]
		di
		Check  "`t0'" `t' "`d'" "`id'" "`wtype'" "`wvar'"
	}
end


program define Check 
	local t0 "`1'"
	local t  "`2'"
	local d  "`3'"
	local id "`4'"
	local wtype "`5'"
	local wvar "`6'"

	IsNorB "`t0'" "entry-time"
	IsN "`t'" "time"
	IsNorB "`d'" "failure/censoring variable"
	
	if "`id'"!="" {
		capture confirm var `id'
		if _rc { 
			version 7: di in red "error:  id variable {bf:`id'} does not exist"
			exit 111
		}
	}
	IsNorB "`wvar'" "weight variable"

	if "`wvar'"!=""  {
		local wgt "[`wtype'=`wvar']"
	}

	MissChk "id" "`id'" 
	MissChk "exit time" `t'
	MissChk "entry time" `t0'
	MissChk "failure/censoring" `d'
	MissChk "weight" "`wvar'"

	capture assert `t'>0
	if _rc {
		di in red "error:  exit time `t' <= 0 in some obs"
		exit 498
	}

	if "`t0'" != "" {
		capture assert `t0'>=0
		if _rc { 
			di in red "error:  entry-time `t0' < 0 in some obs"
			exit 498 
		}
		capture assert `t0'<`t'
		if _rc { 
			di in red "error:  entry time `t0' >= exit time `t' in some obs."
			exit 498
		}
	}

	if "`wvar'"!="" {
		quietly count if `wvar'>0
		if _result(1)==0 {
			di in red /* 
			*/ "error:  all the weights are 0 or negative"
			di in red "        no observations"
			exit 2000
		}
	}
	else {
		if _N==0 {
			di in red "error:  no observations"
			exit 2000
		}
	}

	if "`id'"!="" {
		sort `id' `t'
		capture by `id' `t': assert _N==1 
		if _rc { 
			version 7: di in red "error:  repeated exit times {bf:`t'} within {bf:`id'}"
			exit 498
		}
		if "`t0'" != "" {
			capture by `id': assert `t0'>=`t'[_n-1] if _n>1
			if _rc { 
				version 7: di in red /*
*/ "error:  overlapping records within {bf:`id'}.  That is, some records have" _n /*
*/ "        entry-time {bf:`t0'} < previous record's exit time {bf:`t'}"
				exit 498
			}
		}
		if "`wvar'"!="" {
			capture by `id': assert `wvar'==`wvar'[1]
			if _rc {
				version 7: di in red /* 
*/ "error:  specified weight is not constant within {bf:`id'}"
				exit 498
			}
		}
	}

	/* Now the warnings ... */

	if "`id'"!="" & "`t0'"!="" {
		capture by `id':  assert `t0'==`t'[_n-1] if _n>1
		if _rc { 
			di in gr /* 
*/ "note:  within " in ye "`id'" in gr ", some leave and re-enter the data"
			di in gr "       that is, there are gaps"
		}
	}

	if "`id'"!="" {
		sort `id' `t'
		if "`d'"=="" {
			capture by `id': assert _N==1
			if _rc {
				di in gr /* 
*/ "note:  no failure/censoring variable and multiple records per " /*
*/ in ye "`id'" _n in gr /* 
*/ "       imply multiple failures per subject.
			}
		}
		else {
			capture by `id':  assert `d'==0 if _n!=_N 
			if _rc { 
				di in gr /* 
*/ "note:  within " in ye "`id'" in gr ", some re-enter after failure"
				tempvar cnt
				qui by `id': gen `cnt'=sum(`d'!=0)
				capture by `id': assert `cnt'==1 if _n==_N
				if _rc { 
					di in gr /* 
*/ "note:  within " in ye "`id'" in gr ", there are multiple failures"
				}
			}
		}
	}
			
	if "`wvar'"!="" {
		capture assert `wvar'>0 | `wvar'==.
		if _rc {
			capture assert `wvar'>=0 | `wvar'==.
			if _rc {
				di in gr /*
*/ "note:  weight " in ye "`wvar'" in gr " has negative values"
			}
			else	di in gr /*
*/ "note:  weight " in ye "`wvar'" in gr " has zero values"
		}
	}
end




program define IsN
	capture confirm var `1'
	if _rc {
		di in red "error:  `2' `1' does not exist"
		exit 111
	}
	capture confirm str var 
	if _rc==0 {
		di in red "error:  `2' `1' not numeric"
		exit 109
	}
end

program define IsNorB
	if "`1'"=="" { exit }
	IsN `1' "`2'"
end

program define MissChk
	local msg "`1'"
	local v "`2'"
	local advice "`3'"

	capture confirm var `v'
	if _rc { exit }
	capture confirm string var `v'

	if _rc { 
		capture assert `v'!=.
	}
	else	capture assert "`v'"!=""
	if _rc { 
		di in red /*
		*/ "error:  `msg' `v' has missing values"
		`advice'
		exit 498
	}
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


program define Maket0 /* t0 t id */
	local t0 "`1'"
	local t  "`2'"
	local id "`3'"
	di _n in gr "note:  making entry-time variable " in ye "`t0'" _c
	if "`id'"=="" {
		di in gr " = 0"
		qui gen byte `t0' = 0
		exit
	}
	di _n in gr "       (within " in ye "`id'" in gr ", " in ye "`t0'" /*
	*/ in gr " will be " in ye "0" in gr " for the 1st observation and the"
	di in gr "       lagged value of exit time " /* 
	*/ in ye "`t'" in gr " thereafter)"
	quietly {
		sort `id' `t'
		local ty : type `t'
		by `id': gen `ty' `t0' = cond(_n==1,0,`t'[_n-1])
	}
end

program define ChkNew /* optionname varname */
	if "`2'"=="" {
		global S_1
		exit
	}
	local n : word count `1'
	if `n' != 1 { 
		di in red "`1' invalid"
		exit 198
	}
	confirm new var `2'
	global S_1 "`2'"
end

program define Plural /* <exp> */
	if (`*') == 1 { 
		global S_1
	}
	else	global S_1 "s"
end
	
exit

/*
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
              Id variable:  id
    Failure-time variable:  t
      Entry-time variable:  t0
  Failure/censor variable:  d (0 means censored)
                   weight:  [fweight=exp]
               
              Id variable:  (none -- meaning each record a unique subject)
    Failure-time variable:  t
      Entry-time variable:  (none -- meaning all entered at time 0)
  Failure/censor variable:  (none -- meaning all assumed to have failed)
                   weight:  [fweight=exp]
*/
