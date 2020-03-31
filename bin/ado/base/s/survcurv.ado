*! version 3.1.1  13dec1994
program define survcurv
	ChkVer
	version 4.0
	local options "Adjustfor(string) BY(string)"
	local varlist "req ex min(2) max(2)"
	local if "opt"
	local in "opt"
	local weight "iweight aweight fweight"
	parse "`*'"

	tempvar touse
	mark `touse' [`weight'`exp'] `if' `in'
	markout `touse' `varlist' `adjustfor' `by'

	if "`adjustf'" == "" {
		if "`weight'" != "" {
			di in red "weights allowed in adjusted survcurv"	
			exit 198
		}
		_crcsrvc `varlist' `by' if `touse'
		di in bl _new "Variables created:"
		drop `touse'
		desc _stds _surv _vlogs
		exit
	}
	parse "`varlist'", parse(" ")
	local time "`1'"
	local died "`2'"
	tempvar ratio
	if ("`died'"=="") {
		tempvar dd
		local died `dd'
		gen byte `dd' = 1 if `touse'
	}
	if "`by'" != "" { 
		qui tab(`by') if `touse', gen(__g)
		local ggg "__g*"
		local by "by(`by')"
	}
	qui cox `time' `adjustf' `ggg' if `touse' [`weight'`exp'], dead(`died')
	capture drop `ggg'
	parse "`adjustf'", parse(" ")
	qui gen `ratio' = 1 if `touse'
	while ("`1'"!="") {
		qui summ `1' [`weight'`exp'] if `touse'
		qui replace `ratio' = `ratio'/exp(_b[`1']*(`1'-_result(3))) if `touse'
		mac shift
	}
	wsrvcrv `time' `died' if `touse' [iw=`ratio'], `by'
	drop `touse' `ratio' `dd'
	di in bl _new "Variables created:"
	desc _stds _surv _vlogs
end

program define wsrvcrv
	version 4.0
	local varlist "req ex min(2) max(2)"
	local options "BY(string)"
	local if "opt"			/* required "option" */
	local weight "iweight aweight fweight"
	parse "`*'"

	if ("`weight'"!="") { local weight "[`weight'`exp']" }
	_crcwsrv `varlist' "`by'" `if' `weight'
end

program define ChkVer
	quietly version 
	if _result(1)<5 { exit }
	version 5.0
	#delimit ;
	di in ye "survcurv" in gr 
	" is an out-of-date command.  Its replacement is " in ye "sts"
	in gr "." _n(2) in ye "survcurv"
	in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "survcurv" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "sts"  in gr "." ;
	#delimit cr
	exit 199
end
exit
