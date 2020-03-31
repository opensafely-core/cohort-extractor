*! version 3.0.3  09feb2015
program define coxhaz
	ChkVer
	version 3.0
	if "$S_E_cmd"!="cox" { error 301 }
	local options "Title(string) *"
	local varlist "req ex min(2) max(2)"
	local in "opt"
	local if "opt"
	parse "`*'"
	parse "`varlist'", parse(" ")
	tempvar b1 t1 t2 bhaz
	if "`title'"=="" {
		local title "     Baseline Hazard Function Estimate"
	}
	quietly {
		coxvar `1' `2' `if' `in'
		gen `c(obs_t)' `b1' = _n `if' `in'
		replace `b1' = . if `b1'==.
		replace `b1' = . if `1'==`1'[_n-1]
		sort `b1'
		gen `t1' = `1'[_n-1]
		replace `t1'=0 in 1
		gen `t2' = basesurv[_n-1]
		replace `t2'=1 in 1
		gen `bhaz'=(`t2'[_n+1]-`t2')/`t2'/(`t1'-`t1'[_n+1]) if `b1'!=.
		sort `1' `b1'
		replace `bhaz' = `bhaz'[_n-1] if `b1'==.
		label var `bhaz' "Cox Baseline Hazard Rate"
	}
	rename `bhaz' basehaz
	gr7 basehaz `1', title("`title'") /*
	       */ ysca(0,.) xsca(0,.) xlabel ylabel `options'
	drop `b1' `t1' `t2'
	di in bl _n "Variables created:"
	desc baserelh basesurv ownsurv basehaz
end

program define ChkVer
	quietly version 
	if _result(1)<5 { exit } 
	version 5.0
	#delimit ;
	di in ye "coxhaz" in gr 
	" is an out-of-date command.  Its replacement is the "
	in ye "basech()" in gr " option" _n
	"of " in ye "cox" in gr " and " in ye "stcox"
	in gr ".  "  in ye "coxhaz" 
	in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "coxhaz" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "cox" 
	in gr " and help " in ye "stcox" in gr "." ;
	#delimit cr
	exit 199
end
exit

coxhaz is an out-of-date command.  Its replacement is the basehazard() option
of cox and stcox.  coxhaz will, however, work:

        . version 4.0
        . coxhaz ...
        . version 5.0

Better is to see help cox and help stcox.
