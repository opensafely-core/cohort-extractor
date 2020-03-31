*! version 2.1.7  13jun2000
program define pchart_7, sort
	version 6
	syntax varlist(min=3 max=3) [, STAbilized * ]
	tokenize `varlist'
	local REJECTS "`1'"
	local UNIT "`2'"
	local SAMPLE "`3'"

	tempvar TEMP NTOTAL P PBAR LCL UCL

		/*
		   calculate _p, the fraction rejected
		*/
	gen `TEMP' = -`SAMPLE'
	sort `TEMP'
	drop `TEMP'
	gen long `NTOTAL' = sum(max(0,(`SAMPLE')))
	if `NTOTAL'[_N] <= 0 {
		di in red "All samples are missing or zero"
		exit
	}
	gen float `P' = cond(`REJECTS'/`SAMPLE'>=0,`REJECTS'/`SAMPLE',.)
	label variable `P' "Fraction defective"
	gen float `PBAR' = sum(max(0,`REJECTS'))
	local pbar = `PBAR'[_N]/`NTOTAL'[_N]
	drop `PBAR'
	if `pbar' <= 0 {
		di in red "No units were ever rejected"
		exit
	}
		/*
		   calculate the control limits
		*/
	quietly count if `SAMPLE'>0 & `SAMPLE'!=. & `SAMPLE'!=`SAMPLE'[1]
	if r(N)==0 {      /* constant sample size */
		local ucl=3*sqrt(`pbar'*(1-`pbar')/(`SAMPLE')) + `pbar'
		local lcl=cond(`pbar'>`ucl'-`pbar',2*`pbar'-`ucl',0)
		quietly replace `NTOTAL' = sum(`P'<`lcl' | `P'>`ucl')
		local t2=`NTOTAL'[_N]
		local t2="`t2' units are out of control"
		format `P' %9.4f
		#delimit ;
		gr7 `P' `UNIT', c(l) s(o) sort `options'
			t1("`t2'") yline(`ucl',`lcl')
			rlab(`ucl',`lcl',`pbar')
			l1("Fraction defective") ;
		#delimit cr
		exit
	}
			/* varying sample size  */
	gen float `UCL' = 3*sqrt(`pbar'*(1-`pbar')/(`SAMPLE'))
	gen float `LCL' = cond(`pbar'>`UCL',`pbar'-`UCL',0)
	quietly replace `UCL' = `pbar' + `UCL'
	label variable `UCL' " "
	label variable `LCL' " "

	quietly replace `NTOTAL' = sum(`P'<`LCL' | `P'>`UCL')
	local t2=`NTOTAL'[_N]
	local t2 "`t2' units are out of control"
	if "`stabili'"=="" {
		format `LCL' %9.4f
		#delimit ;
		gr7 `LCL' `UCL' `P' `UNIT', c(lll) s(iio) sort `options' pen(112)
			rlab(`pbar') t1("`t2'") l1("Fraction defective") ;
		#delimit cr
		exit
	}
	quietly replace `NTOTAL' = sum(`UCL'~=`UCL'[1])
	quietly replace `UCL' = (`UCL'-`pbar')/3
	quietly replace `P' = (`P'-`pbar')/`UCL'
	format `P' %9.2f
	local pbar = int(`pbar'*10000+.5)/10000
	#delimit ;
	gr7 `P' `UNIT', c(l) s(o) sort
		yline(-3,3) `options'
		rlabel(-3,0,3)
		t1("Stabilized p Chart, average number of defects = `pbar'")
		t2("`t2'")
		l1("Fraction defective") l2("(Standard Deviation units)") ;
	#delimit cr
end
