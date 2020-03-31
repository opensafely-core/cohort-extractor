*! version 3.1.2  09sep2002
program define coxbase
	ChkVer
	version 3.0
	if "$S_E_cmd"!="cox" { error 301 }
	local options "Title(string) YLAbel(string) BY(string) *"
	local varlist "req ex min(2) max(2)"
	local in "opt"
	local if "opt"
	parse "`*'"
	parse "`varlist'", parse(" ")
	if "`title'"=="" {
		local title "     Baseline Survival Curve"
	}
	if "`offset'"=="" {
		local myaxis "noaxis xline(0) yline(0)"
	}
	if "`ylabel'"=="" { local ylabel "ylabel(0,.25,.5,.75,1)" } 
	else if "`ylabel'"=="." { local ylabel } 
	else local ylabel "ylab(`ylabel')"
	quietly coxvar `1' `2' `if' `in'
	format basesurv %9.2f
		
	if "`by'"!="" {
		sort `by'
		local bopt "by(`by')"
	}
	capture noisily gr7 basesurv `1', c(J) title("`title'") /*
		 */  xsca(0,.) `ylabel' `bopt' `options'
	local rc = _rc
	cap drop basesurv baserelh ownsurv
	exit `rc'
end

program define ChkVer
	quietly version 
	if _result(1)<5 { exit } 
	version 5.0
	#delimit ;
	di in ye "coxbase" in gr 
	" is an out-of-date command.  Its replacement is the "
	in ye "basesurv()" in gr " option" _n
	"of " in ye "cox" in gr " and " in ye "stcox"
	in gr ".  "  in ye "coxbase" 
	in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "coxbase" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "cox" 
	in gr " and help " in ye "stcox" in gr "." ;
	#delimit cr
	exit 199
end
exit

coxbase is an out-of-date command.  Its replacement is the basesurv() option
of cox and stcox.  coxbase will, however, work:

        . version 4.0
        . coxbase ...
        . version 5.0

Better is to see help cox and help stcox.
