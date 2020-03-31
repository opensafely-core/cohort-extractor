*! version 2.3.2  13feb2015  
program define centile, rclass byable(recall) sort
	version 6, missing
	syntax [varlist] [if] [in] [, CCi /*
		*/ Centile(numlist >=0 <=100) /*
		*/ Level(cilevel) Meansd Normal ]

	tempvar touse notuse
	mark `touse' `if' `in'
	qui gen byte `notuse' = .  /* will be reset for each variable */

	if "`centile'"=="" { local centile 50 }
/*
	Parse `centile' and count the requested centiles, placing them
	into c1, c2, ....
*/
	local nc 0
	tokenize "`centile'"
	while "`1'" != "" {
		local nc = `nc' + 1
		local c`nc' `1'
		local cents "`cents' `1'" /* to return in r() */
		mac shift
	}

	local tl1 "      Obs "
	local ttl "Percentile"
	if "`meansd'"=="" { 
		if "`normal'"=="" { 
			if "`cci'"~="" {
				di in smcl in gr _n _col(56) /*
				*/ "{hline 2} Binomial Exact {hline 2}"
			}
			else {
				di in smcl in gr _n _col(56) /*
				*/ "{hline 2} Binom. Interp. {hline 2}"
			}
		}
		else {
			di in smcl in gr _n _col(36) /*
		*/ "{hline 2} Normal, based on observed centiles {hline 2}"
		}
	}
	else {
		di in smcl in gr _n _col(36) /*
		*/ "{hline 2} Normal, based on mean and std. dev.{hline 2}"
	}
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces ""
	if `cil' == 2 {
		local spaces "   "
	}
	else if `cil' == 4 {
		local spaces " " 
	}
	#delimit ;
	di in smcl in gr 
`"    Variable {c |} `tl1' `ttl'    Centile     `spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
	_n "{hline 13}{c +}{hline 61}" ;
	#delimit cr

	local anymark 0
	local alpha2 = (100-`level')/200
	local zalpha2 = -invnorm(`alpha2')
/*
	Run through varlist
*/
	tokenize `varlist'
	local vl
	while "`1'" != "" {
		capt conf str var `1'
		if _rc { 
			local vl "`vl' `1'"
		}
		mac shift 
	}

	local nobs 0			/* in case loop aborted */
	tokenize `vl'
	while "`1'" ~= "" {
		local yvar "`1'"

		/* notuse: 0 = use, 1 = not use -- sort will put use first */
		qui replace `notuse' = ~`touse'
		qui replace `notuse' = 1 if `yvar'>=.
		sort `notuse' `yvar'

		qui sum `yvar' if ~`notuse'
		local nobs = r(N)
		local mean = r(mean)
		local sd = sqrt(r(Var))
/*
	Formatting
*/
		local fmt : format `yvar'
		if bsubstr("`fmt'",-1,1)=="f" { 
			local ofmt="%9."+bsubstr("`fmt'",-2,2)
		}
		else if bsubstr("`fmt'",-2,2)=="fc" {
			local ofmt = "%9." + bsubstr("`fmt'",-3,3)
		}
		else	local ofmt "%9.0g"
/*
	Calc required centile(s)
*/
		local j 1
		local s 7
		while `j' <= `nc' {
			local mark ""
			local cj "c`j'"
			local quant = ``cj''/100
			if "`meansd'" ~= "" & (`nobs' > 0) {
			/*
				Normal distribution (parametric estimates)
			*/
				local z = invnorm(`quant')
				local centil = `mean'+`z'*`sd'
				local se = `sd'*sqrt(1/`nobs'+(`z')^2/(2*(`nobs'-1)))
				local cLOWER = `centil'-`zalpha2'*`se'
				local cUPPER = `centil'+`zalpha2'*`se'
			}
			else if `nobs' > 0 {
/*
	If `normal' is not set, calc centile and exact nonparametric confidence
	limits (for example, see Gardner and Altman 1989, pp 72-74),
	interpolating when not at ends of distribution.  An iterative process
	is required for each limit.  As starting values, find ranks for lower
	and upper limits using a normal approximation.

	If `normal' is set, use normal distribution formula for variance, 
	(10.29) in Kendall & Stuart (1969) p 237.

	`alpha2' is for example .025 for a 95% CI.
*/
				local frac1 = (`nobs'+1)*`quant'
* di "Central fraction and rank = " `quant',`frac1'
				local i1 = int(`frac1')
				local frac1 = `frac1'-`i1'
				if `i1' >= `nobs' {
					local centil = `yvar'[`nobs']
				}
				else if `i1' < 1 {
					local centil = `yvar'[1]
				}
				else {
					local centil = `yvar'[`i1']+ /*
					*/ `frac1'*(`yvar'[`i1'+1]-`yvar'[`i1'])
				}
				if "`normal'" == "" {
					local nq = `nobs'*`quant'
					local z = sqrt(`nq'*(1-`quant'))*`zalpha2'
					local rzLOW = int(.5+`nq'-`z')
					local rzHIGH = 1+int(.5+`nq'+`z')
* di "lower and upper approx ranks = " `rzLOW',`rzHIGH'
					local r1 `rzHIGH'
					if `r1' > `nobs'+1 { 
						local r1 = `nobs'+1
					}
					local r0 = `r1'-1
					local p0 = Binomial(`nobs',`r0',`quant')
					local p1 = Binomial(`nobs',`r1',`quant')
					local done 0
					while ~`done' {
						if `p0' > `alpha2' {
							if `p1' <= `alpha2' {
								local done 1
							}
							else {
								local r0 = `r1'
								local p0 = `p1'
								local r1 = `r1'+1
								local p1 = Binomial(`nobs',`r1',`quant')
							}
						}
						else if `p0' == `alpha2' {
							local r1 = `r0'
							local p1 = `p0'
							local done 1
						}
						else {
							local r1 = `r0'
							local p1 = `p0'
							local r0 = `r0'-1
							local p0 = Binomial(`nobs',`r0',`quant')
						}
					}
* di "Upper r0, p0, r1, p1, interp =" `r0',`p0',`r1',`p1',(`p0'-`alpha2')/(`p0'-`p1')
/*
	Upper limit. Interpolate between r0 and r1, r1 being
	conservative. Note that p0>=p1 (upper tail areas).
*/
					if `r0' >= `nobs' {
						local cUPPER = `yvar'[`nobs']
						local mark "*"
						local anymark 1
					}
					else if `r0' < 1 {
						local cUPPER = `yvar'[1]
						local mark "*"
						local anymark 1
					}
					else {
						if "`cci'" == "" {
							local cUPPER = `yvar'[`r0']		/*
							*/	+((`p0'-`alpha2')/(`p0'-`p1'))	/*
							*/	*(`yvar'[`r1']-`yvar'[`r0'])
						}
						else {
							local cUPPER = `yvar'[`r1']
						}
					}
					local r1 `rzLOW'
					if `r1' < 0 { local r1 0 }
					local r0 = `r1'-1
					local p0 = 1-Binomial(`nobs',`r0'+1,`quant')
					local p1 = 1-Binomial(`nobs',`r1'+1,`quant')
					local done 0
					while ~`done' {
						if `p1' > `alpha2' {
							if `p0' <= `alpha2' {
								local done 1
							}
							else {
								local r1 = `r0'
								local p1 = `p0'
								local r0 = `r0'-1
								local p0 = 1-Binomial(`nobs',`r0'+1,`quant')
							}
						}
						else if `p0' == `alpha2' {
							local r0 = `r1'
							local p0 = `p1'
							local done 1
						}
						else {
							local r0 = `r1'
							local p0 = `p1'
							local r1 = `r1'+1
							local p1 = 1-Binomial(`nobs',`r1'+1,`quant')
						}
					}
/*
	Interpolate between r1 and r1+1, r1 being conservative.
	Note that p0<=p1 (both are lower tail areas).
*/
					if `r1' >= `nobs' {
						local cLOWER = `yvar'[`nobs']
						local mark "*"
						local anymark 1
					}
					else if `r1' < 1 {
						local cLOWER = `yvar'[1]
						local mark "*"
						local anymark 1
					}
					else {
						if "`cci'" == "" {
							local cLOWER = `yvar'[`r1'] /*
							*/ +((`alpha2'-`p0')/(`p1'-`p0')) /*
							*/ *(`yvar'[`r1'+1]-`yvar'[`r1'])
						}
						else {
							local cLOWER = `yvar'[`r1']
						}
					}
* di "Lower r0, p0, r1, p1, interp =" `r0',`p0',`r1',`p1',(`alpha2'-`p0')/(`p1'-`p0')
* di "Var = `yvar', centile `cj'=" `centil' ", CI = " `cLOWER',`cUPPER'
				}
				else {
/*
	Normal distribution, observed centiles
*/
					local dens = exp(-0.5*((`centil'-`mean')/`sd')^2)/(`sd'*sqrt(2*_pi))
					local se = sqrt(`quant'*(1-`quant')/`nobs')/`dens'
					local cLOWER = `centil'-`zalpha2'*`se'
					local cUPPER = `centil'+`zalpha2'*`se'
				}
			}

			if (`j' == 1) & (`nobs' > 0)  {
				di in smcl in gr /*
				*/ %12s abbrev("`yvar'",12) " {c |}" _col(14) /*
				*/ in yel %10.0fc `nobs'	/*
		 		*/ _col(29) %7.0g ``cj''	/*
		 		*/ _col(39) `ofmt' `centil'	/*
		 		*/ _col(55) `ofmt' `cLOWER'	/*
		 		*/ _col(67) `ofmt' `cUPPER' in gr "`mark'"
			}
			else if `nobs' > 0 {
				di in smcl in gr "             {c |}" /*
		 		*/ in yel _col(29) %7.0g ``cj''	/*
		 		*/ _col(39) `ofmt' `centil'	/*
		 		*/ _col(55) `ofmt' `cLOWER'	/*
		 		*/ _col(67) `ofmt' `cUPPER' in gr "`mark'"
			}
			else {  /* `nobs' == 0 */
				if (`j' == 1) {
					di in smcl in gr /*
					*/ %12s abbrev("`yvar'",12) " {c |}" /*
					*/ _col(14) in yel %8.0f `nobs'
				}
				local centil .
				local cLOWER .
				local cUPPER .
			}
/*
	Store centile in S_# macros, starting at 7.
	Store centiles also in r(c_#) where # starts at 1.
	Store lower and upper bounds on centiles in r(lb_#) and r(ub_#)
*/
			local tmp = `s' - 6
			ret scalar c_`tmp' = `centil'    /* save in r() */
			global S_`s' `centil'      /* also save in S_# */
			/* save confidence limits also in r(), but not S_# */
			ret scalar lb_`tmp' = `cLOWER'
			ret scalar ub_`tmp' = `cUPPER'
			local j = `j'+1
			local s = `s'+1
		}
		mac shift
	}
	if "`anymark'" == "1" {
		di in gr _n /*
*/ "`mark' Lower (upper) confidence limit held at minimum (maximum) of sample"
	}
/*
	Store quantities at final point; S_4 is duplicate of S_[`nc'+6].
*/
	ret scalar N = `nobs'
	ret scalar n_cent = `nc'
	ret local centiles `cents'

	/* double save in S_# */
	global S_1 `nobs'
	global S_2 `nc'
	global S_3 ``cj''
	global S_4 `centil'
	global S_5 `cLOWER'
	global S_6 `cUPPER'
end
