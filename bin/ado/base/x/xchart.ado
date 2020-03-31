*! version 2.4.3  25dec2007
program define xchart, rclass
	version 6, missing
	if _caller() < 8 {
		xchart_7 `0'
		exit
	}

	syntax varlist(min=2 max=25) [if] [in] [, /*
		*/ Mean(real 1e30) LOwer(real 1e30) UPper(real 1e30) /*
		*/ STd(real 1e30) * noGRaph]

	_get_gropts , graphopts(`options') getallowed(CLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local clopts `"`s(clopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts clopts, opt(`clopts')

	if (`lower'==1e30 | `upper'==1e30) & `std'==1e30 {
		if (`lower'!=1e30 | `upper'!=1e30) { grxbar } 
		local a2 1.88                /* load table from Handbook */
		local a3 1.023
		local a4  .729
		local a5  .577
		local a6  .483
		local a7  .419
		local a8  .373
		local a9  .337
		local a10 .308
		local a11 .285
		local a12 .266
		local a13 .249
		local a14 .235
		local a15 .223
		local a16 .212
		local a17 .203
		local a18 .194
		local a19 .187
		local a20 .180
		local a21 .173
		local a22 .167
		local a24 .157
		local a25 .153
	}
	tokenize `varlist'
	local ssize  0
	tempvar avg min max smpl touse LCL UCL

quietly {
	gen `avg' = 0
	gen `min' = 1e+32
	gen `max' = -1e+32
	gen byte `touse' = 1 `if' `in'
	capture assert sum(`touse')==0
	if _rc==0 { 
		di in red "no observations"
		exit 2000
	}
	while "`1'"!="" {		/* go across varlist    */
		capture assert `1'<. if `touse'==1
		if _rc {
			di in red "missing values found"
			exit 499
		}
		replace `avg' = `avg' + `1' if `touse'==1
		replace `min' = `1' if `min'>`1' & `touse'==1
		replace `max' = `1' if `max'<`1' & `touse'==1
		local ssize = `ssize' + 1
		mac shift
	}
	replace `avg' = `avg' / `ssize' if `touse'==1
	if (`mean'==1e30) {
		quietly sum `avg' if `touse'==1
		local mean = r(mean)   
	}
	if (`std'!=1e+30) { 
		local lower = `mean' - 3*`std'/sqrt(`ssize')
		local upper = `mean' + 3*`std'/sqrt(`ssize')
	}
	else if (`lower'==1e30) {            /* calculate limits     */
		replace `max' = `max' - `min' if `touse'==1
		quietly sum `max' if `touse'==1
		local lower = `mean' - `a`ssize'' * r(mean)   
		local upper = `mean' + `a`ssize'' * r(mean)   
	}
	quietly gen `LCL' = `lower' if `touse' == 1
	quietly gen `UCL' = `upper' if `touse' == 1
	gen `smpl' = _n
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	local yttl "Average"
	label var `smpl' "Sample"
	local xttl : var label `smpl'
	label var `avg' "`yttl'"
	quietly count if `touse'==1 & (`avg'<`lower' | `avg'>`upper')
	local out  `r(N)'
	local note "`r(N)' unit`=cond(r(N)==1," is","s are")' out of control"
	label var `LCL' "Control limit"
	label var `UCL' "Control limit"
	
	/*return values*/
	return scalar xbar = `mean'
	qui summ `LCL' if `touse'
	return scalar lcl_x = `r(mean)'
	qui summ `UCL' if `touse'
	return scalar ucl_x = `r(mean)'
  	qui count if `touse'
	return scalar N = `r(N)'
	return scalar out_x = `out'
	quietly count if `touse'==1 & (`avg'<`lower' )
	return scalar below_x  = `r(N)'
	quietly count if `touse'==1 & (`avg'>`upper')
	return scalar above_x = `r(N)'

	if "`graph'" == "" {
		version 8: graph twoway			///
		(rline `LCL' `UCL' `smpl' 		///
			if `touse'==1,			///
			sort				///
			pstyle(ci)			///
			yaxis(1 2)			///
			ylabels(, nogrid)		///
			xlabels(, nogrid)		///
			ytitle(`yttl', axis(1))		///
			ylabels(`lower' `mean' `upper',	///
				axis(2))		///
			yticks(`mean', grid axis(2))	///
			ytitle("", axis(2))		///
			xtitle(`"`xttl'"')		///
			note(`"`note'"')		///
			`legend'			///
			`clopts'			///
		)					///
		(scatter `avg' `smpl'			///
			if `touse'==1,			///
			sort				///
			pstyle(p1)			///
			`options'			///
		)					///
		|| `plot' || `addplot'			///
	}
	// blank
} // quietly
end

exit
/*
	Graph an x-bar (control line) chart.

	Each observation in the data set represents a sample.
	The variables of varlist represent the observations of each sample.
	Thus, the data consists of k samples of n observations each.

	If mean() is not specified, the average is used,
	I.e.,
		mean() = 1/k * sum(average_x[i])
	Otherwise, mean() is as specified in the mean() option.

	If lower() and upper() are not specified, the following are used:

		lower() = mean() - A(n)*R
		upper() = mean() + A(n)*R

	where R is the average value of the range across the k samples.
	I.e.,
		R = 1/k * sum(average_range[i])

	A(n) (n := # of obs. in a single sample) is from
		CRC Handbook of Tables for Probability and Statistics
		2nd Edition
		William H. Beyer, Ed.
		The Chemical Rubber Company
		Cleveland, Ohio

		Table "Quality Control:  Factors for Computing Control Limits"
		page 454.

	Code Copyright (c) 1988 by ==C=R=C== (Computing Resource Center)
*/
