*! version 3.2.2  09sep2002
program define loglogs
	ChkVer
	version 3.1
	local options "Title(string) BY(string) Adjustfor(string) *"
	local varlist "req ex min(2) max(2)"
	local if "opt"
	local in "opt"
	parse "`*'"
	parse "`varlist'", parse(" ")
	tempvar lls lt touse
	preserve
	quietly {
		local time "`1'"
		local died "`2'"

		mark `touse' `if' `in'
		markout `touse' `varlist' `by' `adjustf'
		keep if `touse'

		if "`by'"!="" {
			local byy "by(`by')"
		}
		keep `time' `died' `by' `adjustf'
		if "`adjustf'"=="" {
			if "`title'"=="" { 
				local title /*
			*/ "     Log-Log Survival Check for Weibull"
			}
			_crcsrvc `time' `died' `by'
		}
		else {
			if "`title'"=="" { 
				local title /*
			*/ "     Adjusted Log-Log Survival Check for Weibull"
			}
			tempvar ratio
			if ("`died'"=="") {
				tempvar dd
				local died `dd'
				gen byte `dd' = 1
			}
			if "`by'" != "" {
				qui tab(`by') , gen(__g)
				local ggg "__g*"
			}
			qui cox `time' `adjustf' `ggg', dead(`died') 
			capture drop `ggg'
			parse "`adjustf'", parse(" ")
			qui gen `ratio' = 1
			while ("`1'"!="") {
				qui summ `1'
				qui replace `ratio' = /*
				*/ `ratio'/exp(_b[`1']*(`1'-_result(3)))
				mac shift
			}
			_crcwsrv `time' `died' `by' [iw=`ratio']
		}	
		gen `lls' = ln(-ln(_surv))
		gen `lt' = ln(`time')
		format `lls' %9.2f
	}
	gr7 `lls' `lt', title("`title'") `options' `byy' /*
	      */ l1("log(-log(survival))") b2("log(time)")
end

program define ChkVer
	quietly version 
	if _result(1)<5 { exit }
	version 5.0
	#delimit ;
	di in ye "loglogs" in gr 
	" is an out-of-date command.  It has no exact replacement because" _n
	"duplicating " in ye "loglogs" in gr
	"' graph is easy enough to do yourself:" _n ;
	di _col(8) in gr "." in ye " sts gen surv = s" _n
	_col(8) in gr "." in ye " gen lls = ln(-ln(surv))" _n 
	_col(8) in gr "." in ye " gen ltime = ln(time)" _n
	_col(8) in gr "." in ye " gr7 lls ltime, c(l)" _n ;
	di in ye "loglogs" in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "loglogs" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "sts"  in gr "." ;
	#delimit cr
	exit 199
end
exit
