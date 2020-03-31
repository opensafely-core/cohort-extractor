*! version 1.3.0  27mar2018
*! quantile regression via weighted least squares 

program _qregwls, rclass
	version 13

	syntax varlist(numeric fv) [aw fw iw] [if], ITERate(integer) ///
		Quant(real) r(name) [ NOLOg LOg ]

	if `iterate'<1 {
		error 198
	}
	if `quant' <= 0 | `quant' >= 1 {
		di in red "quantiles(`quantil') out of range"
		exit 198
	}

	tempvar p wt y1 rtouse
	tempname swt swt1 eps

	marksample touse
	tokenize `varlist'
	local y `1'
	mac shift
	local X `*'
	local vl `y1' `X'
	qui count if `touse'
	local n = r(N)
	scalar `swt' = `n'
	scalar `swt1' = 0
	/* same eps used by version 13 -qreg-				*/
	scalar `eps' = 1e-10
	qui gen double `y1' = `y' 

	if "`weight'" != "" {
		tempvar wt1
		qui gen double `wt1'`exp'
		if "`weight'" == "aweight" {
			summarize `wt1', meanonly
			qui replace `wt1' = _N*`wt1'/r(sum)
		}
	}
	qui reg `vl' [`weight'`exp'] if `touse'
	qui gen double `wt' = `touse'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	local i = -1
	while (`i'<=`iterate') {
		capture drop `r'
		qui replace `y1' = `y'
		qui _predict double `r' if `touse', resid
		if `++i' > 0 {
			qui gen double `p'=cond(`r'>=0,`quant',`quant'-1)* ///
				`r' if `touse'

			if "`weight'" != "" {
				summ `p' [`weight'=`wt1'] if `touse', meanonly 
			}
			else summ `p' if `touse', meanonly 

			if "`log'" == "" {
				di in gr  "Iteration  `i':  WLS sum of " ///
				 "weighted deviations = " in ye %10.0g r(sum)
			}
			if `i' >= `iterate' | reldif(`swt',`swt1')<`eps'{
				qui replace `r' = `p' if `touse'
				qui replace `r' = . if !`touse'
				drop `p'
				continue, break
			}
			drop `p'
		}
		qui replace `r' = abs(`r')
		cap drop `rtouse'
		qui gen byte `rtouse' = `touse' & `r'>`eps'*abs(`y')
		qui count if `rtouse'
		if r(N) == 0 {
			di as text "note: weighted least squares perfect fit"
			continue, break
		}
		qui replace `y1' = `y1'+`r'*(2*`quant'-1) if `rtouse'
		qui replace `wt' = 1/`r' if `rtouse'
		qui replace `wt' = 0 if !`rtouse'
		summarize `wt' if `rtouse', meanonly
		scalar `swt1' = `swt'
		scalar `swt' = r(sum)
		if "`weight'" != "" {
			qui replace `wt' = `wt1'*`wt' if `rtouse'
		}
		qui reg `vl' if `rtouse' [iw=`wt']
	}
	tempname b
	mat `b' = e(b)
	return mat b = `b'
end
