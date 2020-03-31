*! version 3.0.4  16feb2015
program define survsum
	ChkVer
	version 3.1
	local options " BY(string) *"
	local varlist "req ex min(2) max(2)"
	local if "opt"
	local in "opt"
	parse "`*'"
	parse "`varlist'", parse(" ")
	tempvar mean CNT med dead
	preserve
	quietly {
		if "`if'`in'"~="" {
			keep `if' `in'
		}
		if "`by'"!="" {
			local byc "by `by' :"
			drop if `by'==.
		}
		keep `1' `2' `by'
		drop if `1'==. | `2'==.
		replace `2'=1 if `2'!=0 & `2'!=.
		_crcsrvc `1' `2' `by'
		gen `mean' = - `1'
		sort `by' _surv `mean'
		`byc' gen `CNT' = sum(`2')
		`byc' replace `mean' = sum(`1')
		`byc' replace `mean' = `mean'/`CNT' if _n==_N
		drop `CNT'
		`byc' gen `med' = `1' if _surv<.5
		`byc' replace `med' = `med'[_n-1] if `med'==.
		`byc' gen `c(obs_t)' `CNT' = _N
		`byc' gen `dead' = sum(`2')
		#delimit ;
		noisily di in gr _n "    Group" _col(21) "Obs."
			_col(34) "Died" _col(46) "Median" _col(62) "Mean" _n
			_dup(65) "-" ; 
		#delimit cr
		if "`by'"!="" {
			`byc' drop if _n!=_N
			local i 1
			while `i'<=_N {
				#delimit ;
				noisily di in gr %9.0g `by'[`i'] in ye
					_col(15) %9.0g `CNT'[`i']
					_col(29) %9.0g `dead'[`i']
					_col(43) %9.0g `med'[`i']
					_col(57) %9.0g `mean'[`i'] ;
				#delimit cr
				local i = `i' + 1
			}
			noisily di in gr _dup(65) "-"
			replace `CNT' = sum(`CNT')
			replace `dead' = sum(`dead')
			replace `med' = . in l
			replace `mean' = . in l
		}
		global S_1=`CNT'[_N]
		global S_2=`dead'[_N]
		global S_3=`med'[_N]
		global S_4=`mean'[_N]
		#delimit ;
		noisily di in gr "    Total" in ye 
			_col(15) %9.0g `CNT'[_N]
			_col(29) %9.0g `dead'[_N]
			_col(43) %9.0g `med'[_N]
			_col(57) %9.0g `mean'[_N] ;
		#delimit cr
	}
end

program define ChkVer
	quietly version 
	if _result(1)<5 { exit }
	version 5.0
	#delimit ;
	di in ye "survsum" in gr 
	" is an out-of-date command.  Its replacement is " in ye "stsum"
	in gr "." _n(2) in ye "survsum" 
	in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "survsum" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "stsum"  in gr "." ;
	#delimit cr
	exit 199
end
exit

survsum is an out-of-date command.  Its replacement is stsum.  

survsum will, however, work:

	. version 4.0
	. survsum ...
	. version 5.0

Better is to see help sts.
r(199);
