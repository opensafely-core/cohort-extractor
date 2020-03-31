*! version 2.3.4  09feb2015
program define rchart, rclass
	version 6, missing
	if _caller() < 8 {
		rchart_7 `0'
		exit
	}

	syntax varlist(min=2 max=25)	///
		[if] [in] [,		///
		STd(real 1e30)		///
		Mean(real 1e30)		///
		noGRaph			///
		*			///
	]

	_get_gropts , graphopts(`options') getallowed(CLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local clopts `"`s(clopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts clopts, opt(`clopts')

			/* mean included for compatibility with xchart */
			/* load table from handbook	*/
	local d22 1.128 
	local d23 1.693
	local d24 2.059
	local d25 2.326
	local d26 2.534 
	local d27 2.704 
	local d28 2.847 
	local d29 2.970 
	local d210 3.078 
	local d211 3.173 
	local d212 3.258 
	local d213 3.336 
	local d214 3.407 
	local d215 3.472 
	local d216 3.532 
	local d217 3.588 
	local d218 3.640
	local d219 3.689
	local d220 3.735
	local d221 3.778
	local d222 3.819
	local d223 3.858
	local d224 3.895
	local d225 3.931
	local D32  0
	local D33  0
	local D34  0
	local D35  0
	local D36  0
	local D37  .076
	local D38  .136
	local D39  .184
	local D310 .223
	local D311 .256
	local D312 .284
	local D313 .308
	local D314 .329
	local D315 .348
	local D316 .364
	local D317 .379
	local D318 .392
	local D319 .404
	local D320 .414
	local D321 .425
	local D322 .434
	local D323 .443
	local D324 .452
	local D325 .459
	local D42  3.267
	local D43  2.575
	local D44  2.282
	local D45  2.115
	local D46  2.004
	local D47  1.924
	local D48  1.864
	local D49  1.816
	local D410 1.777
	local D411 1.744
	local D412 1.716
	local D413 1.692
	local D414 1.671
	local D415 1.652
	local D416 1.636
	local D417 1.621
	local D418 1.608
	local D419 1.596
	local D420 1.586
	local D421 1.575
	local D422 1.566
	local D423 1.557
	local D424 1.548
	local D425 1.541

	tokenize `varlist'

	tempvar min max touse smpl LCL UCL
	local ssize  0
quietly {
	gen `min' = 1e+32
	gen `max' = -1e+32
	gen byte `touse' = 1 `if' `in'
	capture assert sum(`touse')==0
	if _rc==0 {
		di in red "(no observations)"
		exit 2000
	}
	while "`1'"!="" {		/* go across varlist    */
		capture assert `1'<. if `touse'==1
		if _rc {
			di in red "missing values found"
			exit 499
		}
		replace `min' = `1' if `min'>`1' & `touse'==1
		replace `max' = `1' if `max'<`1' & `touse'==1
		local ssize = `ssize' + 1
		mac shift
	}
	replace `max' = `max' - `min' if `touse'==1
	local d2 = `d2`ssize''
	local D3 = `D3`ssize''
	local D4 = `D4`ssize''
	if (`std'==1e30) { 
		quietly sum `max' if `touse'==1
		local cl = r(mean)
		local lcl= r(mean) * `D3'
		local ucl= r(mean) * `D4'
	}
	else {
		local d3 = (`d2'/3)*(`D4'-1)
		local cl  = `std'*`d2'
		local lcl = `std'*(1 - 3*(`d2')/(`d3'))
		local ucl = `std'*(1 + 3*(`d2')/(`d3'))
	}
	quietly gen `LCL' = `lcl' if `touse' == 1
	quietly gen `UCL' = `ucl' if `touse' == 1
	gen `c(obs_t)' `smpl' = _n
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	local yttl "Range"
	label var `smpl' "Sample"
	local xttl : var label `smpl'
	label var `max' "`yttl'"
	quietly count if (`max'<`lcl' | `max'>`ucl') & `touse'==1
	local out "`r(N)'"
	local note "`r(N)' unit`=cond(r(N)==1," is","s are")' out of control"
	label var `LCL' "Control limit"
	label var `UCL' "Control limit"
	
	/*return values*/
	return scalar central_line =`cl'
	qui summ `LCL' if `touse'
	return scalar lcl_r = `r(mean)'
	qui summ `UCL' if `touse'
	return scalar ucl_r = `r(mean)'
  	qui count if `touse'
	return scalar N = `r(N)'
	return scalar out_r = `out'
	quietly count if (`max'<`lcl') & `touse'==1
	return scalar below_r  = `r(N)'
	quietly count if (`max'>`ucl') & `touse'==1
	return scalar above_r = `r(N)'


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
			ylabels(`lcl' `cl' `ucl',	///
				axis(2))		///
			yticks(`cl',			///
				grid gmin gmax		///
				axis(2)			///
			)				///
			ytitle("", axis(2))		///
			xtitle(`"`xttl'"')		///
			note(`"`note'"')		///
			`legend'			///
			`clopts'			///
		)					///
		(scatter `max' `smpl'			///
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
	Each observation in the data set represents a sample.
	The variables of varlist represent the observations of each sample.
	Thus, the data consists of k samples of n observations each.


		central line = d2*sigma
		LCL          = D1*sigma
		UCL	     = D2*sigma

	where
		D1 = d2 - 3*d3
		D2 = d2 + 3*d3

	If sigma is unknown:

		central line = R		(average range)
		LCL          = D3*R
		UCL	     = D4*R

	where
		D3 = D1/d2
		D4 = D2/d2

	Note:	d2, d3, and therefore D1, D2, D3, and D4 are functions of
		n, the sample size.

	Values for d2, D3, and D4 obtained from

		CRC Handbook of Tables for Probability and Statistics
		2nd Edition
		William H. Beyer, Ed.
		The Chemical Rubber Company
		Cleveland, Ohio

		Table "Quality Control:  Factors for Computing Control Limits"
		page 454.

	Code Copyright (c) 1990 by ==C=R=C== (Computing Resource Center)
*/
