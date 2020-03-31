*! version 3.0.6  16feb2015
program define mantel
	ChkVer
	version 3.1
	local varlist "req ex min(2) max(2)"
	local if "opt"
	local in "opt"
	local options "BY(string)"
	parse "`*'"
	parse "`varlist'", parse(" ")
	if "`by'"=="" { error 198 }
	conf var `by'
	tempvar grp nt ntg dt bt at died v var exp ng ag e
	tempfile T TG
	preserve
	quietly {
		if "`if'`in'"~="" {
			keep `if' `in'
		}
		keep `1' `2' `by'
		drop if `1'==. | `2'==. | `by'==.
		replace `2'=1 if `2'!=0
		recast long `2'
		sort `by'
		gen `c(obs_t)' `grp' = `by' != `by'[_n-1]
		replace `grp' = sum(`grp')
		if (`grp'[_N] != 2) {
			noisily di in red "Only 2 levels of `by' allowed."
			exit 402
		}
		sort `1' `by'                      /* cell = time and group */
		by `1' `by': replace `2'=sum(`2')  /* no. of deaths in cell */
		by `1' `by': gen `c(obs_t)' `ntg'=_N  /* no. of obs in cell */
		by `1' `by': drop if _n!=_N        /* save only the summaries */
		save "`TG'", replace

		by `1':  gen long `nt'=sum(`ntg')  /* cases in time */
		by `1':  gen long `dt'=sum(`2')    /* cases died    */
		by `1':  drop if _n!=_N            /* summaries by time */
		gen long `bt'=sum(`nt')            /* cases gone    */
		gen long `at'=`nt'+`bt'[_N]-`bt'   /* cases alive   */
		drop `ntg' `nt' `bt'
		save "`T'", replace

		use "`TG'", clear
		sort `by'
		by `by': gen long `died'=sum(`2')
		by `by': drop if _n!=_N
		replace `1' = -1
		keep `by' `1' `died'
		gen `v' = 0
		gen `exp' = 0
		gen `var' = 0
		local TOP = _N
		local i   =  1
		#delimit ;
		noisily di _n in gr "    Group" _col(18) "Events"
			_col(29) "Predicted" _n 
			_dup(37) "-" ;
		#delimit cr
		while (`i' == 1) {
			append using "`TG'"
			drop if _n>`TOP' & `by' != `by'[`i']
			sort `1' `by'
			merge `1' using "`T'" /* at = cases rem in all groups */
			drop _merge
			sort `1' `by' /* merge put data out of order */
			gen long `ng' = `ntg' * (`by' == `by'[`i'])
			replace `ng' = 0 if _n>`TOP' & `ng'==.
			gen long `ag' = sum(`ng')
			replace `ag' = `ag'[_N] - `ag' + `ng' /* ag = cases remaining in group */
			drop if `dt' == 0                 /* dt = total deaths in period */
			gen `e' = `dt'*`ag'/`at'            /* e = expected deaths in group */
			replace `v' = `e'*(1-`dt'/`at')*(`at'-`ag')/(`at'-1)
			replace `v' = 0 if `at'<=1
			replace `e' = sum(`e')
			replace `v' = sum(`v')
			replace `exp' = `e'[_N] if _n==`i'
			replace `var' = `v'[_N] if _n==`i'
			noisily di in gr %9.0g `by'[`i'] in ye /*
				*/ _col(15) %9.0g `died'[`i'] /*
				*/ _col(29) %9.2f `e'[_N]
			global S_7=`by'[`i']
			drop if _n>`TOP'
			drop `ng' `e' `dt' `ag' `at'
			local i = `i' + 1
		}

		local tval = (abs(`died'[1]-`exp'[1])-0.5)/sqrt(`var'[1])
		if (`tval' < 0) {
			local tval 0
		}
		noisily di _n in gr _col(25) "z = " in ye /*
			*/ %9.2f `tval' _n in gr /*
			*/ _col(20) "Pr>|z| = " in ye /* 
			*/ %9.4f 2*normprob(-`tval')
		global S_8 
		global S_9 `tval'
	}
end

program define ChkVer
	quietly version 
	if _result(1)<5 { exit }
	version 5.0
	#delimit ;
	di in ye "mantel" in gr 
	" is an out-of-date command.  Its replacement is " in ye "sts test"
	in gr "." _n(2) in ye "mantel" 
	in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "mantel" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "sts"  in gr "." ;
	#delimit cr
	exit 199
end
exit
