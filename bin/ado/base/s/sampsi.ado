*! version 2.1.0  31may2007
program define sampsi, rclass
	version 6
	gettoken m1 0 : 0, parse(" ,")
	gettoken m2 0 : 0, parse(" ,")

	confirm number `m1'
	confirm number `m2'

	syntax [, PRE(real 0) POST(real 1) r0(real -1) r1(real -1) /*
	*/  r01(real -1) Method(str) SD1(real -1) SD2(real -1) * ]

	if "`method'" ~= "" & `sd1' == -1 {
 		di in red "method() cannot be used without option sd1()"
		exit 198 
	}
	if (`pre' ~= 0 |`post' ~= 1 ) & `sd1' == -1 {
		di in red /*
	*/ "options pre() and post() cannot be used without option sd1()"
		exit 198 
	}

	if `r1' ~= -1 {
		if `r0' == -1 { 
			local r0 = `r1' 
		}
		if `r01' == -1 { 
			local r01 = `r1' 
		}
	}

	confirm integer number `pre' 
	cap confirm integer number `pre' 
	if _rc { 
		di in red "pre() must be a count" 
		exit 198 
	}
	cap assert `pre' >= 0
	if _rc { 
		di in red "pre() must be a count" 
		exit 198 
	}
	cap confirm integer number `post' 
	if _rc { 
		di in red "post() must be a count" 
		exit 198 
	}
	cap assert `post' >= 0
	if _rc { 
		di in red "post() must be a count" 
		exit 198 
	}

	if `post' > 1 & `r1' == -1 { 
		di in red "Correlation r1 is needed with more than one " /*
		*/  "post-trial (follow-up) measurement"
		exit 198 
	}	
	if `pre' ~= 0 & `r01' == -1 { 
		di in red "Correlation r01 is needed with pre-trial" /*
		*/  " (baseline) measurements"
		exit 198 
	}	
	if `pre' > 1 & `r0' == -1 { 
		di in red "Correlation r0 is needed with more than one " /*
		*/ "pre-trial (baseline) measurement"
		exit 198 
	}	

	if `r1' >= 1 | `r1' <-1 {
		di in red "Correlation r1 must be between -1 and 1" 
		exit 198 
	}	
	if `r0' >= 1 | `r0' <-1 {
		di in red "Correlation r0 must be between -1 and 1" 
		exit 198 
	}	
	if `r01' >= 1 | `r01' <-1 {
		di in red "Correlation r01 must be between -1 and 1" 
		exit 198 
	}	

	cap assert "`method'" == "" | "`method'" == "post" | /*
	*/ "`method'" == "change" | "`method'" == "ancova" | "`method'" == "all"
	if _rc { 
		di in red "method() invalid"
		exit 198 
	}

	if "`method'" == "change" & `pre' == 0 { 
		di in red /*
		*/ "method(change) may only be used with baseline measurements"
		exit 198 
	}
	if "`method'" == "ancova" & `pre' == 0 { 
		di in red /*
		*/ "method(ancova) may only be used with baseline measurements"
		exit 198 
	}

	if (`pre' ~= 0 | `post' ~= 1) & "`method'" == "" {
		local method "all" 
	}

	if `sd1' == -1 { local sd1 }
	if `sd2' == -1 { local sd2 }

	
	/* HEADING */

	if "`method'" == "" {
		if "`sd1'" ~= "" {
			local sd1 "sd1(`sd1')" 
		}
		if "`sd2'" ~= "" {
			local sd2 "sd2(`sd2')" 
		}
		global S_w=.
		_SAmpsi `m1' `m2', `sd1'  `sd2' `options'
		global S_4 = 1
		return scalar adj = 1
		return scalar power = $S_3
		return scalar N_2 = $S_2 
		return scalar N_1 = $S_1
		if $S_w ~=.{
			return scalar warning = $S_w
		}
		exit
	}
	*di in gr _n "Sample size and power calculations for repeated measures"
	if "`sd2'" ~= "" { 
		local sd2opt="sd2(`sd2')"
	}
	if "`sd2'" == "" { 
		local sd2opt="sd2(`sd1')"
	}
	_MASs `m1' `m2', sd1(`sd1') `sd2opt' `options'
	if `post' == 1 { 
		di in gr "           number of follow-up measurements = " /*
		*/  in ye %8.0f `post'
	}
	if `post' > 1 { 
		di in gr "           number of follow-up measurements = " /*
		*/  in ye %8.0f `post'
                di in gr " correlation between follow-up measurements = " /*
		*/ in ye %8.3f `r1'
	}

	if `pre' < 1 {
		di in gr "            number of baseline measurements = " /*
		*/ in ye "       0"
	}
	if `pre' == 1 {
		di in gr "            number of baseline measurements = " /*
		*/  in ye %8.0f `pre'
		di in gr "   correlation between baseline & follow-up = " /*
		*/ in ye %8.3f `r01'
	}
	if `pre' > 1 {
		di in gr "            number of baseline measurements = " /*
		*/  in ye %8.0f `pre'
		di in gr "  correlation between baseline measurements = " /*
		*/  in ye %8.3f `r0'
		di in gr "   correlation between baseline & follow-up = " /*
		*/ in ye %8.3f `r01'
	}
****	 

	/* POST */
	if "`method'" == "post" | "`method'" == "all" {	
		di _n in gr "Method:" in ye " POST" 
		local sd_r = (1 + (`post' - 1) * `r1')/`post'
		if `sd_r' <= 0 {
di in red "variance of treatment difference must be positive;"
di in red "increase value in r1()"
exit 198
		}
		local sd_r = (`sd_r')^.5
		local sd1_adj = `sd1'*`sd_r'
		if "`sd2'" ~= "" { 
			local sd2_adj = `sd2'*`sd_r' 
			di in gr " relative efficiency = " in ye %8.3f /*
			*/(`sd_r')^-2 _n /*
			*/ in gr "    adjustment to sd = " in ye %8.3f /*
			*/ `sd_r' _n /*
			*/ in gr "        adjusted sd1 = " in ye %8.3f /*
			*/ `sd1_adj' _n /*
			*/ in gr "        adjusted sd2 = " in ye %8.3f /*
			*/ `sd2_adj' _n 
			qui _SAmpsi `m1' `m2', sd1(`sd1_adj') sd2(`sd2_adj') /*
			*/ `options' 
		}
		if "`sd2'" == "" { 
			di in gr " relative efficiency = " in ye %8.3f /*
			*/(`sd_r')^-2 _n /*
			*/ in gr "    adjustment to sd = " in ye %8.3f /*
			*/ `sd_r' _n /*
			*/ in gr "        adjusted sd1 = " in ye %8.3f /*
			*/ `sd1_adj' _n 
			qui _SAmpsi `m1' `m2',  sd1(`sd1_adj') `options' 
		}
		if "$S_5"=="sample" {
			di in gr " Estimated required sample sizes:"
			if index("`options'", "onesam") == 0 {
				di in gr _col(19) "n1 = " in ye %8.0f $S_1 
				di in gr _col(19) "n2 = " in ye %8.0f $S_2 
			}
			if index("`options'", "onesam") ~= 0 {
				di in gr _col(19) "n1 = " in ye %8.0f $S_1 
			}
		}
		else {
			di in gr " Estimated power:"
			di in gr "               power = " in ye %8.3f $S_3
		}
		if "`method'" == "all" & `pre' == 0 { 
			di in gr _n "method(change) and method(ancova) may " /*
			*/ "only be used with baseline measurements"
		}
		global S_4 = `sd_r'
		return scalar adj = `sd_r'
		return scalar power = $S_3
		return scalar N_2 = $S_2 
		return scalar N_1 = $S_1
	}

	/* method(change) */
	if "`method'" == "change" | ("`method'" == "all" & `pre' >=1 ) {
		/* calculate sd ratio */ 
		di _n in gr "Method:" in ye " CHANGE" 
		local sd_r = ((1 + (`post' - 1) * `r1')/`post') + /*
		*/ ((1 + (`pre'-1) * `r0')/`pre') - 2*`r01'
		if `sd_r' <= 0 {
di in red "variance of treatment difference must be positive;"
di in red "adjust values in r1(), r01(), or r0()"
exit 198
		}
		local sd_r = (`sd_r')^.5
		local sd1_adj = `sd1'*`sd_r'
		if "`sd2'" ~= "" { 
			local sd2_adj = `sd2'*`sd_r' 
			di in gr " relative efficiency = " in ye %8.3f /*
			*/(`sd_r')^-2 _n /*
			*/ in gr "    adjustment to sd = " in ye %8.3f /*
			*/ `sd_r' _n /*
			*/ in gr "        adjusted sd1 = " in ye %8.3f /*
			*/ `sd1_adj' _n /*
			*/ in gr "        adjusted sd2 = " in ye %8.3f /*
			*/ `sd2_adj' _n
			qui _SAmpsi `m1' `m2', sd1(`sd1_adj') sd2(`sd2_adj') /*
			*/ `options' 
		}
		if "`sd2'" == "" { 
			di in gr " relative efficiency = " in ye %8.3f /*
			*/(`sd_r')^-2 _n /*
			*/ in gr "    adjustment to sd = " in ye %8.3f /*
			*/ `sd_r' _n /*
			*/ in gr "        adjusted sd1 = " in ye %8.3f /*
			*/ `sd1_adj' _n 
			qui _SAmpsi `m1' `m2',  sd1(`sd1_adj') `options' 
		}
		if "$S_5"=="sample" {
			di in gr " Estimated required sample sizes:"
			if index("`options'", "onesam") == 0 {
				di in gr _col(19) "n1 = " in ye %8.0f $S_1 
				di in gr _col(19) "n2 = " in ye %8.0f $S_2 
			}
			if index("`options'", "onesam") ~= 0 {
				di in gr _col(19) "n1 = " in ye %8.0f $S_1 
			}
		}
		else {
			di in gr " Estimated power:"
			di in gr "               power = " in ye %8.3f $S_3
		}
		global S_4 = `sd_r'
		return scalar adj = `sd_r'
		return scalar power = $S_3
		return scalar N_2 = $S_2 
		return scalar N_1 = $S_1
	}

	/* method(ancova) */
	if "`method'" == "ancova" | ("`method'" == "all" & `pre' >=1 ) {
		/* calculate sd1_adj */ 
		di _n in gr "Method:" in ye " ANCOVA" 
		local sd_r = (((1 + (`post' - 1) * `r1')/`post') /*
		*/ -((`r01')^2)*`pre'/(1 +(`pre'-1)*`r0'))
		if `sd_r' <= 0 {
di in red "variance of treatment difference must be positive;"
di in red "adjust values in r1(), r01(), or r0()"
exit 198
		}
		local sd_r = (`sd_r')^.5
		local sd1_adj = `sd1'*`sd_r'

		if "`sd2'" ~= "" { 
			local sd2_adj = `sd2'*`sd_r' 
			di in gr " relative efficiency = " in ye %8.3f /*
			*/(`sd_r')^-2 _n /*
			*/ in gr "    adjustment to sd = " in ye %8.3f /*
			*/ `sd_r' _n /*
			*/ in gr "        adjusted sd1 = " in ye %8.3f /*
			*/ `sd1_adj' _n /*
			*/ in gr "        adjusted sd2 = " in ye %8.3f /*
			*/ `sd2_adj' _n
			qui _SAmpsi `m1' `m2', sd1(`sd1_adj') sd2(`sd2_adj') /*
			*/ `options' 
		}
		if "`sd2'" == "" { 
			di in gr " relative efficiency = " in ye %8.3f /*
			*/(`sd_r')^-2 _n /*
			*/ in gr "    adjustment to sd = " in ye %8.3f /*
			*/ `sd_r' _n /*
			*/ in gr "        adjusted sd1 = " in ye %8.3f /*
			*/ `sd1_adj' _n 
			qui _SAmpsi `m1' `m2',  sd1(`sd1_adj') `options' 
		}
		if "$S_5"=="sample" {
			di in gr " Estimated required sample sizes:"
			if index("`options'", "onesam") == 0 {
				di in gr _col(19) "n1 = " in ye %8.0f $S_1 
				di in gr _col(19) "n2 = " in ye %8.0f $S_2 
			}
			if index("`options'", "onesam") ~= 0 {
				di in gr _col(19) "n1 = " in ye %8.0f $S_1 
			}
		}
		else {
			di in gr " Estimated power:"
			di in gr "               power = " in ye %8.3f $S_3
		}
			global S_4 = `sd_r'
			return scalar adj = `sd_r'
			return scalar power = $S_3
			return scalar N_2 = $S_2 
			return scalar N_1 = $S_1
	}
	global S_5
end 

program define _SAmpsi, rclass
	gettoken m1 0 : 0, parse(" ,")
	gettoken m2 0 : 0, parse(" ,")

	confirm number `m1'
	confirm number `m2'

	local dalpha = 1 - $S_level/100
	syntax [, Alpha(real `dalpha') Power(real 0.90) N1(int 0) N2(int 0) /*
	*/  SD1(real 0) SD2(real 0) Ratio(str) ONESAMple ONESIDed noCONTinuity]
	if "`onesamp'"~=""&"`ratio'" ~=""{
		di in red "options r() and onesample " /*
		*/ "are incompatible"
		exit 198
	}
	if "`ratio'"~=""{
		confirm number `ratio'
	}
	else{
		local ratio = 1
	}
	if `alpha'<=0 | `alpha'>=1 { 
		di in red "alpha() out of range"
		exit 198
	}

	if `power'<=0 | `power'>=1 {
		di in red "power() out of range"
		exit 198
	}
	if `sd1'<0 | `sd2'<0 { 
		di in red "sd() out of range"
		exit 198
	}
	if  ("`continuity'"~="")&(`sd1'~=0 |`sd2'~=0 |"`onesample'"~=""){ 
		di in red "option `continuity' not allowed"
		exit 198
	}
	if `ratio'<=0{ 
		di in red "ratio() out of range"
		exit 198
	}
	if `n1'<0 | `n2'<0 { 
		di in red "n() out of range"
		exit 198
	}

	tempname diff n0 pbar r1 w w1 w2 za zb
	scalar `diff' = abs(`m1' - `m2')
	scalar `w1' = `m1'*(1 - `m1')
	scalar `w2' = `m2'*(1 - `m2')
	if `sd1' == 0 & `sd2' == 0 & (`w1' < 0 | `w2' < 0) {
		di in red "if testing means, then sd(#) must be specified" /*
		*/ _n "if testing proportions, the proportions " /*
		*/ "must be between 0 and 1" 
		exit 499
	}	
	if `sd1' ~= 0 & `sd2' ~= 0 & "`onesamp'"~="" {
		di in red "for one-sample comparison of mean, " /*
		*/ "only one sd(#) can be specified"
		exit 499
	}	
	if "`oneside'" ~= "" { scalar `za' = invnorm(1 - `alpha') }
	else                { scalar `za' = invnorm(1 - `alpha'/2)   }
	if `n1' == 0 & `n2' == 0 {  /* compute sample size */
		scalar `zb' = invnorm(`power')
		if `sd1' ~= 0 | `sd2' ~= 0 { /* means */
			scalar `w' = ((`za'+`zb')/`diff')^2
			if `sd1' == 0 { local sd1 = `sd2' }
			if "`onesamp'"~="" {  /* one sample */
				local n1 = `w'*(`sd1')^2
				if `n1' ~= int(`n1') { 
					local n1 = int(`n1' + 1) 
				}
				di _n in gr /*
				*/ "Estimated sample size for one-sample " /*
				*/ "comparison of mean" _n /*
				*/ "  to hypothesized value" _n(2) /*
				*/ "Test Ho: m = " in ye %6.0g `m1' in gr /*
				*/ ", where m is the mean in the population" /*
				*/ _n(2) "Assumptions:" _n(2) _col(10) /*
				*/  "alpha = " in ye %8.4f `alpha' _c 
				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else { 
					di in gr "  (two-sided)" 
				} 
				di _col(10) in gr "power = " in ye %8.4f /*
				*/  `power' _n in gr " alternative m = " /*
				*/ in ye %8.0g `m2' _n in gr _col(13) "sd = " /*
				*/ in ye %8.0g `sd1' _n(2) in gr /*
				*/ "Estimated required sample size:" /*
				*/ _n(2) _col(14) "n = " in ye %8.0f `n1' 

			}
			else {  /* two sample */
				if `sd2' == 0 { local sd2 = `sd1' }
				local n1 = `w'*((`sd1')^2+(`sd2')^2/`ratio')
				if `n1' ~= int(`n1') { 
					local n1 = int(`n1' + 1) 
				}
				local n2 = `ratio'*`n1'
				if `n2' ~= int(`n2') { 
					local n2 = int(`n2' + 1) 
				}
				di _n in gr "Estimated sample size for"  /*
				*/ " two-sample comparison of means" _n(2) /*
				*/ "Test Ho: m1 = m2, where m1 is the mean" /*
				*/ " in population 1" _n _col(21) /*
				*/ "and m2 is the mean in population 2" /*
				*/  _n "Assumptions:" _n(2) _col(10) /*
				*/  "alpha = " in ye %8.4f `alpha' _c 
				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else { 
					di in gr "  (two-sided)" 
				} 
				di _col(10) in gr "power = " in ye %8.4f /*
				*/  `power' _n in gr _col(13) "m1 = " /*
				*/ in ye %8.0g `m1' _n in gr _col(13) "m2 = " /*				*/  in ye %8.0g `m2' _n in gr _col(12) /*
				*/ "sd1 = " in ye %8.0g `sd1' _n in gr /*
				*/ _col(12) "sd2 = " in ye %8.0g `sd2' _n /*
				*/ in gr _col(10) "n2/n1 = " in ye %8.2f /*
				*/ `ratio' _n(2) in gr /*
				*/ "Estimated required sample sizes:" /*
				*/ _n(2) _col(13) "n1 = " in ye %8.0f `n1' _n /*
				*/ in gr _col(13) "n2 = " in ye %8.0f `n2'  

			}

		}
		else { /* proportions */
			if "`onesamp'"~="" {  /* one sample */
				local n1 = /*
				*/ ((`za'*sqrt(`w1')+`zb'*sqrt(`w2'))/`diff')^2
				if `n1' ~= int(`n1') { 
					local n1 = int(`n1' + 1) 
				}
				di _n in gr "Estimated sample size for " /*
				*/ "one-sample comparison of proportion" _n /*
				*/ "  to hypothesized value" _n(2) /* 
				*/ "Test Ho: p = " in ye %6.4f `m1' in gr /*
				*/ ", where p is the proportion in the" /*
				*/ " population" _n(2) "Assumptions:" /*
				*/  _n(2) _col(10) "alpha = " in ye %8.4f /*
				*/  `alpha' _c 
				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else { 
					di in gr "  (two-sided)" 
				}
				di _col(10) in gr "power = " in ye %8.4f /*
				*/ `power' _n in gr " alternative p = " /*
				*/  in ye %8.4f `m2' _n(2) in gr /*
				*/  "Estimated required sample size:" /*
				*/  _n(2) _col(14) "n = " in ye %8.0f `n1'
			}
			else {  /* two sample */
				scalar `r1' = `ratio' + 1
				scalar `pbar' = (`m1'+`ratio'*`m2')/`r1'
				scalar `n0' = /*
				*/ (`za'*sqrt(`r1'*`pbar'*(1-`pbar')) /*
			 	*/ +`zb'*sqrt(`ratio'*`w1'+`w2'))^2 /*
				*/ /(`ratio'*(`diff')^2) 
				
	
				/***without continuity correction***/
								
				if "`continuity'"==""{
					local n1 = (`n0'/4)*(1+ /*
					*/ sqrt(1+2*`r1'/(`n0'*`ratio'*`diff')))^2
				}
				else{
					local n1=`n0'
				}									

				if `n1' ~= int(`n1') { 
					local n1 = int(`n1' + 1) 
				}
				local n2 = `ratio'*`n1'
				if `n2' ~= int(`n2') { 
					local n2 = int(`n2' + 1) 
				}
				di _n in gr "Estimated sample size for " /*
				*/ "two-sample comparison of proportions" /*
				*/  _n(2) "Test Ho: p1 = p2, where p1 is " /*
				*/ "the proportion in population 1" _n  /*
				*/ _col(21) "and p2 is the proportion in " /*
				*/ "population 2" _n "Assumptions:" _n(2) /*
				*/  _col(10) "alpha = " in ye %8.4f `alpha' _c 

				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else { 
					di in gr "  (two-sided)"
				} 
				di _col(10) in gr "power = " in ye %8.4f /*
				*/  `power' _n in gr _col(13) "p1 = " /*
				*/ in ye %8.4f `m1' _n in gr _col(13) /*
				*/  "p2 = " in ye %8.4f `m2' _n in gr /*
				*/ _col(10) "n2/n1 = " in ye %6.2f `ratio' /*
				*/ _n(2) in gr/*
				*/  "Estimated required sample sizes:"/*
				*/  _n(2) _col(13) "n1 = " in ye %8.0f `n1'/*
				*/  _n in gr _col(13) "n2 = " in ye %8.0f `n2' 		
			}
		}
	}
	/* Compute power. */
	else {
		if `n2' == 0 {  /* determine n2 from n1 and ratio */
			local n2 = `ratio'*`n1'
			if `n2' ~= int(`n2') { local n2 = int(`n2' + 1) }
		}
		else if `n1' == 0 {  /* determine n1 from n2 and ratio */
			local n1 = `n2'/`ratio'
			if `n1' ~= int(`n1') { local n1 = int(`n1' + 1) }
		}
		if `sd1' ~= 0 | `sd2' ~= 0 { /* means */
			if `sd1' == 0 { local sd1 = `sd2' }
			if "`onesamp'"~="" {  /* one sample */
				local power = /*
				*/ normprob(`diff'*sqrt(`n1')/`sd1' - `za')
				di _n in gr /*
		       		*/ "Estimated power for one-sample " /*
				*/ "comparison of mean" /*
				*/ _n "  to hypothesized value" _n(2) /*
				*/ "Test Ho: m = " in ye %6.0g `m1' in gr /*
				*/ ", where m is the mean in the population" /*
				*/ _n(2) "Assumptions:" _n(2) _col(10) /*
				*/ "alpha = " in ye %8.4f `alpha' _c 
				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else { 
					di in gr "  (two-sided)" 
					local power = `power' + /*
				*/ normprob(-`diff'*sqrt(`n1')/`sd1' - `za')
				}
				di in gr " alternative m = " in ye %8.0g /*
				*/ `m2' _n in gr _col(13) "sd = " in ye /*
				*/ %8.0g `sd1' _n in gr " sample size n = " /*
				*/ in ye %8.0f `n1' _n(2) in gr /*
				*/ "Estimated power:" _n(2) _col(10) /*
				*/ "power = " in ye %8.4f `power' 

			}
			else {  /* two sample */
				if `sd2' == 0 { local sd2 = `sd1' }
				scalar `w' = sqrt((`sd1')^2/`n1' + (`sd2')^2/`n2')
				local power = normprob(`diff'/`w' - `za')
				di _n in gr /*
				*/ "Estimated power for two-sample " /*
				*/ "comparison of means" _n(2) /*
				*/ "Test Ho: m1 = m2, where m1 is the mean "/*
				*/ "in population 1" _n _col(21) /*
				*/ "and m2 is the mean in population 2" /*
				*/ _n "Assumptions:" _n(2) _col(10) /*
				*/ "alpha = " in ye %8.4f `alpha' _c 

				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else { 
					di in gr "  (two-sided)" 
					local power = `power' + /*
					*/ normprob(-`diff'/`w' - `za')
				} 

				di in gr _col(13) "m1 = " in ye %8.0g `m1' /*
				*/ _n in gr _col(13) "m2 = " in ye %8.0g /*
				*/ `m2' _n in gr _col(12) "sd1 = " /*
				*/ in ye %8.0g `sd1' _n in gr _col(12) /*
				*/ "sd2 = " in ye %8.0g `sd2' _n in gr /*
				*/ "sample size n1 = " in ye %8.0f `n1' _n /*
				*/ in gr _col(13) "n2 = " in ye %8.0f `n2' /*
				*/ _n in gr _col(10) "n2/n1 = " in ye %8.2f /*
				*/ `n2'/`n1' _n(2) in gr "Estimated power:" /*
				*/ _n(2) _col(10) "power = " in ye %8.4f /*
				*/ `power'

			}
		}
		else { /* proportions */

			local assump1=((`m1'*`n1')>=10)*(((1-`m1')*`n1')>=10)
			local warning = 0

			if "`onesamp'"~="" {  /* one sample */
				local power = normprob((`diff'*sqrt(`n1')/*
				*/ - `za'*sqrt(`w1'))/sqrt(`w2'))

				di _n in gr "Estimated power for one-sample " /*
				*/ "comparison of proportion" _n /*
				*/ "  to hypothesized value" _n(2) /*
				*/ "Test Ho: p = " in ye %6.4f `m1' in gr /*
				*/ ", where p is the proportion in the " /*
				*/ "population" _n(2) "Assumptions:" _n(2) /*
				*/ _col(10) "alpha = " in ye %8.4f `alpha' _c 
				 if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else{ 
					di in gr "  (two-sided)" 
					local power = `power' /*
					*/ + normprob((-`diff'*sqrt(`n1') /*
					*/ - `za'*sqrt(`w1'))/sqrt(`w2'))
				} 
			 	di in gr " alternative p = " in ye %8.4f /*
				*/ `m2' _n in gr " sample size n = " in ye /*
				*/ %8.0f `n1' _n(2) in gr "Estimated power:" /*
				*/ _n(2) _col(10) "power = " in ye %8.4f /*
				*/ `power' 
				if (~`assump1'){
					local warning = 1
					di ""
					di in smcl as txt "{p 0 6 4}Note: For the above sample "/*
						*/"size(s) and proportion(s), the normal "/*
						*/"approximation to the binomial may not be very "/*
 						*/"accurate.  Thus, power calculations are " /*
				                */"questionable.{p_end}"
				}
 
			}
			else {  /* two sample */
				
				local assump2=((`m2'*`n2')>=10)*(((1-`m2')*`n2')>=10)
									
				local ratio = `n2'/`n1'
				scalar `r1' = `ratio' + 1
				scalar `pbar' = (`m1'+`ratio'*`m2')/`r1'

				/***without continuity correction***/
								
				if "`continuity'"==""{
					scalar `n0' = /*
					*/ (`n1'- `r1'/(2*`ratio'*`diff'))^2/`n1'
				}
				else{
					scalar `n0'=`n1'
				}
				


				scalar `zb' = (`diff'*sqrt(`ratio'*`n0') - /*
				*/ `za'*sqrt(`r1'*`pbar'*(1-`pbar'))) /*
				*/ /sqrt(`ratio'*`w1'+`w2') 
				local power = normprob(`zb') 
				di _n in gr "Estimated power for two-sample " /*
				*/ "comparison of proportions" _n(2) /*
				*/ "Test Ho: p1 = p2, where p1 is the " /*
				*/ "proportion in population 1" _n _col(21) /*
				*/ "and p2 is the proportion in population 2" /*
				*/ _n "Assumptions:" _n(2) _col(10) /*
				*/ "alpha = " in ye %8.4f `alpha' _c
				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else{ 
					di in gr "  (two-sided)"
				} 
				di in gr _col(13) "p1 = " in ye %8.4f `m1' /*
				*/ _n in gr _col(13) "p2 = " in ye %8.4f /*
				*/ `m2' _n in gr "sample size n1 = " in ye /*
				*/ %8.0f `n1' _n in gr _col(13) "n2 = " /*
				*/ in ye %8.0f `n2' _n in gr _col(10) /*
				*/ "n2/n1 = " in ye %8.2f `n2'/`n1' _n(2) /*
				*/ in gr "Estimated power:" _n(2) _col(10) /*
				*/ "power = " in ye %8.4f `power' 
				if (~(`assump1'*`assump2')){
					local warning = 1
					di ""
					di in smcl as txt "{p 0 6 4}Note: For the above sample "/*
						*/"size(s) and proportion(s), the normal "/*
						*/"approximation to the binomial may not be very "/*
						*/"accurate.  Thus, power calculations are " /*
 				                */"questionable.{p_end}"
				}
			}
			global S_w = `warning'
		}
	}
	global S_1 = `n1'
	global S_2 = `n2'
	global S_3 = `power'
end

program define _MASs, rclass
	gettoken m1 0 : 0, parse(" ,")
	gettoken m2 0 : 0, parse(" ,")

	confirm number `m1'
	confirm number `m2'

	local dalpha = 1 - $S_level/100
	syntax [, Alpha(real `dalpha') Power(real 0.90) N1(int 0) N2(int 0) /*
	*/  SD1(real 0) SD2(real 0) Ratio(real 1) ONESAMple ONESIDed ]
	if `n1' == 0 & `n2' == 0 {  /* compute sample size */
		if "`onesamp'"~="" {  /* one sample */
			di _n in gr /*
			*/ "Estimated sample size for one sample " /*
			*/ "with repeated measures" /*
			*/ _n(1) "Assumptions:" _n(1) _col(39) /*
			*/  "alpha = " in ye %8.4f `alpha' _c 
			if "`oneside'"~="" { 
				di in gr "  (one-sided)" 
			} 
			else { 
				di in gr "  (two-sided)" 
			} 
			di _col(39) in gr "power = " in ye %8.4f /*
			*/  `power' _n in gr _col(30) " alternative m = " /*
			*/ in ye %8.0g `m2' _n in gr _col(42) "sd = " /*
			*/ in ye %8.0g `sd1' 
			global S_5 = "sample" 
			exit

		}
		else {  /* two sample */
			di _n in gr "Estimated sample size for"  /*
			*/ " two samples with repeated measures" /*
			*/  _n "Assumptions:" _n(1) _col(39) /*
			*/  "alpha = " in ye %8.4f `alpha' _c 
			if "`oneside'"~="" { 
				di in gr "  (one-sided)" 
			} 
			else { 
				di in gr "  (two-sided)" 
			} 
			di _col(39) in gr "power = " in ye %8.4f /*
			*/  `power' _n in gr _col(42) "m1 = " /*
			*/ in ye %8.0g `m1' _n in gr _col(42) "m2 = " /*
			*/  in ye %8.0g `m2' _n in gr _col(41) /*
			*/ "sd1 = " in ye %8.0g `sd1' _n in gr /*
			*/ _col(41) "sd2 = " in ye %8.0g `sd2' _n /*
			*/ in gr _col(39) "n2/n1 = " in ye %8.2f /*
			*/ `ratio' 
			global S_5 = "sample" 
			exit
		}
	}
	/* Compute power. */
	else {
		if `n2' == 0 {  /* determine n2 from n1 and ratio */
			local n2 = `ratio'*`n1'
			if `n2' ~= int(`n2') { local n2 = int(`n2' + 1) }
		}
		else if `n1' == 0 {  /* determine n1 from n2 and ratio */
			local n1 = `n2'/`ratio'
			if `n1' ~= int(`n1') { local n1 = int(`n1' + 1) }
		}
		if `sd1' ~= 0 | `sd2' ~= 0 { /* means */
			if "`onesamp'"~="" {  /* one sample */
				di _n in gr /*
		       		*/ "Estimated power for one sample " /*
				*/ "with repeated measures" /*
				*/ _n "Assumptions:" _n(1) _col(39) /*
				*/ "alpha = " in ye %8.4f `alpha' _c 
				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else { 
					di in gr "  (two-sided)" 
				}
				di in gr _col(30) " alternative m = " /*
				*/ in ye %8.0g /*
				*/ `m2' _n in gr _col(42) "sd = " in ye /*
				*/ %8.0g `sd1' _n in gr _col(30) /*
				*/ " sample size n = " /*
				*/ in ye %8.0f `n1'  
				global S_5 = "power" 
				exit
			}
			else {  /* two sample */
				di _n in gr /*
				*/ "Estimated power for two samples " /*
				*/ "with repeated measures" /*
				*/ _n "Assumptions:" _n(1) _col(39) /*
				*/ "alpha = " in ye %8.4f `alpha' _c 

				if "`oneside'"~="" { 
					di in gr "  (one-sided)" 
				} 
				else { 
					di in gr "  (two-sided)" 
				} 

				di in gr _col(42) "m1 = " in ye %8.0g `m1' /*
				*/ _n in gr _col(42) "m2 = " in ye %8.0g /*
				*/ `m2' _n in gr _col(41) "sd1 = " /*
				*/ in ye %8.0g `sd1' _n in gr _col(41) /*
				*/ "sd2 = " in ye %8.0g `sd2' /*
				*/ _n in gr _col(30) /*
				*/ "sample size n1 = " in ye %8.0f `n1' _n /*
				*/ in gr _col(42) "n2 = " in ye %8.0f `n2' /*
				*/ _n in gr _col(39) "n2/n1 = " in ye %8.2f /*
				*/ `n2'/`n1' 
				global S_5 = "power" 
				exit
			}
		}
	}
end

