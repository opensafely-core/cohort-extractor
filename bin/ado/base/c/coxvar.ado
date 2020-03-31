*! version 3.0.1  09feb2015
program define coxvar
	ChkVer
	version 3.0
	if "$S_E_cmd"!="cox" { error 301 } 
	local varlist "req ex min(2) max(2)"
	local in "opt"
	local if "opt"
	parse "`*'"
	parse "`varlist'", parse(" ")
	cap drop baserelh
	cap drop ownsurv
	cap drop basesurv
	cap drop basehaz	/* not created here */
	tempvar rh rh1 temp brelh osurv bsurv order died
	quietly {
		gen byte `died'=`2' `if' `in'
		replace `died'=1 if `died'!=0 & `died'!=.
		predict `rh' `if' `in'
		cap gen `temp' = -`1' `if' `in'
		gen `c(obs_t)' `order' = _n
		sort `temp' `died' `order'
		gen `rh1' = sum(`rh')
		gen `brelh' = 1
		replace `brelh' = (1 - `died'*`rh'/`rh1')^(1/`rh') `if' `in'
		label var `brelh' "Cox Baseline Relative Hazard"
		replace `temp' = - `died'
		sort `1' `temp' `order'
		drop `temp' `order'
		gen byte `temp' = 1
		replace `temp' = 0 `if' `in'
		replace `temp' = 1 if `1'==. | `died'==.
		gen `bsurv' = `brelh'
		replace `bsurv' = 1 if `bsurv'==. | `temp'==1
		replace `bsurv' = `bsurv' * `bsurv'[_n-1] if _n>1
		label var `bsurv' "Cox Baseline Survival Prob"
		by `1': replace `bsurv' = `bsurv'[_N]
		replace `bsurv'=. if `temp'==1
		replace `brelh'=. if `temp'==1
		gen `osurv' = `bsurv' ^ `rh'
		label var `osurv' "Survival Probability"
	}
	rename `brelh' baserelh
	rename `osurv' ownsurv
	rename `bsurv' basesurv
	drop `temp' `rh' `rh1' `died'/* drop temps so varnums are right on d */
	di in bl _n "Variables created:"
	desc baserelh basesurv ownsurv
end


program define ChkVer
	quietly version 
	if _result(1)<5 { exit } 
	version 5.0
	#delimit ;
	di in ye "coxvar" in gr 
	" is an out-of-date command.  Its replacement are the "
	in ye "basesurv()" in gr " and" _n
	in ye "basecdhazard()" in gr " options of "
	"of " in ye "cox" in gr " and " in ye "stcox"
	in gr ".  "  in ye "coxvar" 
	in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "coxvar" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "cox" 
	in gr " and help " in ye "stcox" in gr "." ;
	#delimit cr
	exit 199
end
exit

coxvar is an out-of-date command.  Its replacement are the basesurv() and 
basecdhazard() options of cox and stcox.  coxvar will, however, work:

        . version 4.0
        . coxvar ...
        . version 5.0

Better is to see help cox and help stcox.
