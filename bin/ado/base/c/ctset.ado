*!  version 1.0.6  12mar2009
program define ctset
	version 6.0

	capture u_mi_not_mi_set ctset
	if (_rc) {
		di as txt as err "may not use ctset with mi set data"
		exit 119
	}

	parse `"`*'"', parse(" ,")
	if `"`1'"' == "" {
		Query
		exit
	}
	if `"`1'"' == "," {
		Reset `*'
		exit
	}
	local varlist "req ex min(2) max(4)"
	local options "BY(string) noShow"
	parse
	if `"`by'"'!="" {
		unabbrev `by'
		local by `"`s(varlist)'"'
	}
	parse `"`varlist'"', parse(" ")
	local t `"`1'"'
	local die `"`2'"'
	local cens `"`3'"'
	local ent `"`4'"'
	Check `t' `die' `"`cens'"' `"`ent'"' `"`by'"'
		

	char _dta[_dta]
	char _dta[ct_t] "`t'"
	char _dta[ct_d] "`die'"
	char _dta[ct_c] "`cens'"
	char _dta[ct_e] "`ent'"
	char _dta[ct_by] "`by'"
	if `"`show'"'=="" {
		char _dta[ct_show]
	}
	else	char _dta[ct_show] "noshow"
	char _dta[_dta] "ct"
	di
	Query nocheck
end

program define Reset
	ct_is
	syntax, [show clear]
	local curshow : char _dta[ct_show]
	if `"`curshow'"'=="" {
		local showopt "noShow"
	}
	else 	local showopt "Show"

	local options `"`showopt' CLEAR"'
	if `"`clear'"'!="" {
		char _dta[_dta]
		char _dta[ct_t]
		char _dta[ct_d]
		char _dta[ct_c]
		char _dta[ct_e]
		char _dta[ct_by]
		char _dta[ct_show]
		exit
	}
	if `"`show'"' != "" {
		if `"`curshow'"'=="" {
			char _dta[ct_show] "noshow"
		}
		else	char _dta[ct_show]
	}
end

program define Query
	ct_is
	local t : char _dta[ct_t]
	local d : char _dta[ct_d]
	local c : char _dta[ct_c]
	local e : char _dta[ct_e]
	local by : char _dta[ct_by]

	if "$S_FN" != "" { 
		di in gr _col(5) "dataset name:  " in ye "$S_FN"
	}

	di in gr _col(13) "time:  " in ye "`t'"
	di in gr _col(9)  "no. fail:  " in ye "`d'"
	di in gr _col(9)  "no. lost:  " _c
	if "`c'"=="" { 
		di in gr "--" _skip(20) "(meaning 0 lost)"
	}
	else	di in ye "`c'"
	di in gr _col(8) "no. enter:  " _c 
	if "`e'"=="" {
		di in gr "--" _skip(20) "(meaning all enter at time 0)"
	}
	else	di in ye "`e'"

	if "`by'" != "" {
		di in gr "              by:  " in ye "`by'"
	}
end


program define Check /* t die cens ent by */
	local t `"`1'"'
	local die `"`2'"'
	local cens `"`3'"'
	local ent `"`4'"'
	local by `"`5'"'

	ChkPos "Number of failures" `die'
	ChkPos "Number lost" `cens'
	ChkPos "Number enter" `ent'

	if `"`ent'"'=="" {
		exit
	}

	quietly { 
		sort `by' `t'
		if `"`by'"' != "" {
			local byp `"by `by':"'
		}
		tempvar pop
		`byp' gen double `pop'=`ent' if _n==1
		`byp' replace `pop' = `pop'[_n-1]-`die'-`cens'+`ent' if _n>1
	}
	capture assert `pop'>=0
	if _rc == 0 { 
		capture `byp' assert `pop'[_n-1] >= `die'+`cens' if _n>1
	}
	if _rc { 
		di in red `"number enter `ent' probably in error"'
		di in red /*
		*/ "More fail or are censored than are available at some times"
		SeqMsg
		exit 198 
	}
	capture `byp' assert `cens'==0 if _n==1
	if _rc { 
		di in red `"number censored `cens' in error"'
		di in red "some censored at first observed time"
		SeqMsg
		exit 198
	}
	capture `byp' assert `die'==0 if _n==1
	if _rc { 
		di in red `"number fail `die' in error"'
		di in red "some fail at first observed time"
		SeqMsg
		exit 198
	}
end


program define SeqMsg
	#delimit ;
	di in red 
"FYI, Stata defines the sequence of events at the same time t as:" _n
"     t       first, the failures are removed from the population" _n
"     t+0     next, the censorings are removed from the population" _n
"     t+0+0   finally, the new entrants are added to the population" ; 
	#delimit cr
end



program define ChkPos /* <ttl> [varname] */
	local ttl `"`1'"'
	local v `"`2'"'

	if `"`v'"'=="" { 
		exit
	}

	capture assert `v'>=0 & `v'!=.
	if _rc { 
		capture assert `v'>=0 
		if _rc {
			di in red `"`ttl' `v' has negative values"'
			exit 198
		}
		di in red `"`ttl' `v' has missing values."' _n /*
		*/ "Type " _quote `"replace `v'=0 if `v'==."' _quote _n /*
		*/ "and try again if the missings should be 0."
		exit 198 
	}
	capture assert `v'==int(`v')
	if _rc { 
		di in red `"`ttl' `v' has noninteger values"'
		exit 198
	}
end
