*! version 3.2.1  24feb2016
program define loneway, rclass byable(recall) sort
	version 6.0, missing
	syntax varlist(min=2 max=2) [if] [in] [aweight] /*
		*/ [, MEDian MEAn EXact Quiet Long Level(cilevel)]
	tokenize `varlist'
	local obs `1'
	local grp `2'
	local obsnam = abbrev("`obs'",12)
	local grpnam = abbrev("`grp'",12)

	confirm numeric variable `obs'
	capture confirm string variable `grp' 
	if !_rc {
		tempvar grp2 
		qui egen long `grp2' = group(`grp') 
		local grp `grp2'
	}

	tempvar touse wt nn nn1
	tempname N DFA DFW F Frefpt Fmax df gr SSW DFT SST SSA /*
		*/ D2OVNU VARF SDF RATIO SDRATIO SDRHO
	if "`median'" ~= "" & "`mean'" ~= "" {
		di in red "Median and mean options are mutually exclusive."
		exit 105
	}
	if "`weight'" ~= "" & "`exact'" ~= "" {
		di in red "Exact option not available with weights."
		exit 135
	}
	if "`weight'" != "" {
		qui gen double `wt' `exp'
		qui replace `wt' = . if `wt' <= 0
		local wt_exp [aw=`wt']
	}
	else qui gen double `wt' = 1

	quietly {
		mark `touse' `if' `in'
		markout `touse' `obs' `grp' `wt'
	}

	if "`long'" == "" {
		capture oneway `obs' `grp' `wt_exp' if `touse'
		if _rc == 0 {
			scalar `N' = r(N)
			scalar `SSA' = r(mss)
			scalar `DFA' = r(df_m)
			scalar `SSW' = r(rss)
			scalar `DFW' = r(df_r) 
			scalar `SST' = `SSW' + `SSA'
			scalar `DFT' = r(N) - 1
			scalar `F' = r(F)
			local one_way good
		}
	}
  
	if "`long'" != "" | "`one_way'" == "" {
		tempvar fac wt_n egrp
		sort `touse' `grp'
		quietly {
			summ `wt' if `touse'
			gen double `wt_n' = `wt'/r(mean) if `touse'
			by `touse' `grp': gen double `fac' = /*
				*/ sum(`obs'*`wt_n')/sum(`wt_n') if `touse'
			by `touse' `grp': replace `fac' = /*
				*/ `wt_n' * (`obs' - `fac'[_N])^2 if `touse'
			*replace `fac' = sum(`fac'*`wt_n') if `touse'
			*scalar `SSW' = `fac'[_N]
			summ `fac' if `touse'
			scalar `SSW' = r(sum)
			*count if `grp' != `grp'[_n-1]
			*scalar `DFA' = r(N) - 1
			egen `egrp' = group(`grp') if `touse'
			summ `egrp', meanonly
			scalar `DFA' = r(max) - 1
			summ `obs' [aw=`wt_n'] if `touse'
			scalar `N' = r(N)
			scalar `DFT' = r(N) - 1
			scalar `SST' = r(Var) * `DFT'
			scalar `SSA' = `SST' - `SSW'
			scalar `DFW' = `DFT' - `DFA'
			scalar `F'   = `SSA' / `DFA' * `DFW' / `SSW'
		}
	}

	if "`weight'" ~= "" {
		tempvar sw goodsum
		qui replace `wt' = . if `touse' == 0
		sort `grp' `touse'
		qui by `grp' `touse': gen double `sw' = sum(`wt') if `touse'
        	qui gen byte `goodsum' = 0 if `touse'
		qui by `grp': replace `goodsum' = 1 if _n == _N & `touse'
		qui summ `sw' if `goodsum' & `touse'
		scalar `df' = r(N) - 1
		scalar `gr' = r(N)*r(mean)
		scalar `gr' = (`gr' - r(mean) - r(Var)*(`df'/`gr'))/`df'
	}
	else {
		tempvar n_i n_i3
		tempname n
		sort `touse' `grp'
		qui by `touse' `grp': gen `c(obs_t)' `n_i' = _n if `touse' & _n == _N
		qui by `touse': summ `n_i' if `touse'
		if r(min) == r(max) { local equal equal }
		scalar `n' = r(sum)
		scalar `df' = r(N) - 1
		scalar `gr' = r(N)*r(mean)
		scalar `gr' = (`gr' - r(mean) - r(Var)*(`df'/`gr'))/`df'
		if "`median'`mean'" == "" { /* prep for asymptotic variance */
			tempname n2sum n3sum
			scalar `n2sum' = r(N)*(r(mean))^2 + (r(N)-1)*r(Var)
			qui replace `n_i' = (`n_i')^3 if `touse'
			qui summ `n_i' if `touse'
			scalar `n3sum' = r(N)*r(mean)
		}
	}
	
	if "`mean'" != "" {
		scalar `Frefpt' = `DFW'/(`DFW' - 2)
	}
	else if "`median'" != "" {
		scalar `Frefpt' = invfprob(`DFA',`DFW',0.5)
	}
	else scalar `Frefpt' = 1

	if `F' < `Frefpt' {
		/* (Truncated to 0) */
		local trunc0 "*"
		scalar `Fmax' = 0
	}
	else scalar `Fmax' = `F' - `Frefpt'

	return scalar N = `N'
	return scalar rho = `Fmax' /(`Fmax' + `Frefpt'*`gr')
	return scalar rho_t = `Fmax' /(`Fmax' + `Frefpt')
	return scalar sd_b = sqrt((`SSA'/`DFA' - `SSW'/`DFW')/`gr')
	return scalar sd_w = sqrt(`SSW'/`DFW')

	/* compute asymptotic variance and CI */
	tempname V
	scalar `V' = 0
	if "`weight'`mean'`median'" == "" {
scalar `V'= (return(rho))^2*(`n2sum' - 2*`n3sum'/`n' + (`n2sum'/`n')^2)
scalar `V' = `V'+`DFA'*(1-return(rho))*(1+return(rho)*(2*`gr'-1))
scalar `V' = `V'/(`DFA'^2)+(1+return(rho)*(`gr'-1))^2/(`n'-`DFA'-1)
scalar `V' = `V'*2*(1-return(rho))^2/(`gr'^2)
return scalar se = sqrt(`V')
	}
	else return scalar se = .
	
	/* compute exact CI if appropriate */
	if "`exact'" ~= "" {
		if "`equal'" == "" {
			di in red /*
*/ "Balanced data (equal groups) required for exact confidence interval."
			exit 105
		}
		tempname Fu Fl
		scalar `Fl' = invfprob(`DFA',`DFW',(100+`level')/200)
		scalar `Fu' = invfprob(`DFA',`DFW',1-((100+`level')/200))
		return scalar ub = /*
			*/ (`F'-`Frefpt'*`Fl')/(`F'+(`gr'-1)*`Frefpt'*`Fl')
		return scalar lb = /*
			*/ max(`F'-`Frefpt'*`Fu',0)/(`F'+(`gr'-1)*`Frefpt'*`Fu')
	}
	else if return(se) < . {
		tempname posneg
		scalar `posneg' = return(se)*invnorm((100+`level')/200)
		return scalar ub = return(rho) + `posneg'
		return scalar lb = max(return(rho)-`posneg',0)
	}
	else {
		return scalar ub = .
		return scalar lb = .
	}

					/* Output begins ... */

	if `"`quiet'"'=="" {
		local lab : variable label `1'
		local lab = usubstr("`lab'",1,32)
		local lbl /*
		*/ `"One-way Analysis of Variance for `obsnam': `lab'"'
		local indent = int((80-udstrlen(`"`lbl'"'))/2)
		di _n _skip(`indent') in gr `"`lbl'"'

		di _n _col(46) in gr "Number of obs = " in ye /*
			*/ %12.0fc return(N)
		di _col(50) in gr "R-squared = " in ye %12.4f `SSA'/`SST'

		di _n in smcl in gr /*
			*/ _col(5) "Source" _col(27) "SS" /*
			*/ _col(38) "df" _col(46) "MS" /*
			*/ _col(60) "F" _col(66) "Prob > F" /*
			*/ _n "{hline 73}" 
		di in smcl in gr "Between " "`grpnam'" in yellow /*
			*/ _col(23) %10.0g `SSA' /*
			*/ _col(34) %6.0fc `DFA'  /*
			*/ _col(43) %10.0g `SSA'/`DFA' /*
			*/ _col(54) %9.2f `F' /*
			*/ _col(68) %6.4f fprob(`DFA',`DFW',`F')
		di in smcl in gr "Within " "`grpnam'" in yellow /*
			*/ _col(23) %10.0g `SSW' /*
			*/ _col(34) %6.0fc `DFW' /*
			*/ _col(43) %10.0g `SSW'/`DFW' /*
			*/ _n in gr "{hline 73}"
		di in smcl in gr "Total" in yellow /*
			*/ _col(23) %10.0g `SST' /*
			*/ _col(34) %6.0fc `DFT' /*
			*/ _col(43) %10.0g `SST'/`DFT'
	}

	/* double save in S_# and r() */
	global S_1 = `"`return(rho)'"'
	global S_2 = `"`return(rho_t)'"'
	global S_3 = 0

	if ("`quiet'"=="") {
		di _n in smcl in gr _col(10) "Intraclass" _col(27) /*
		*/ "Asy." _col(39) _c
		if "`exact'" != "" { 
			di in smcl in gr "{hline 6} Exact {hline 5}"
		}
		else	di
		local cil `=string(`level')'
		local cil `=length("`cil'")'
		di in smcl in gr _col(10) "correlation" _col(27) "S.E." /*
*/ _col(`=40-`cil'') `"[`=strsubdp("`level'")'% Conf. Interval]"'
		di _col(10) in smcl in gr "{hline 48}"

		di in ye _col(11) %9.5f return(rho) in gr "`trunc0'" /*
		*/ in ye _col(23) %9.5f return(se) /*
		*/ _col(37) %9.5f return(lb) _col(49) %9.5f return(ub)

		di 

		di in smcl in gr _col(10) "Estimated SD of `grpnam' effect" /*
		*/ in ye _col(49) %9.0g return(sd_b)

		di in smcl in gr _col(10) "Estimated SD within `grpnam'" /*
		*/ in ye _col(49) %9.0g return(sd_w)

		local grstr : di %9.2f `gr'
		local grstr = trim("`grstr'")
		di in smcl in gr _col(10) "Est. reliability of a `grpnam' mean" /*
		*/ in ye _col(49) %9.5f return(rho_t) in gr "`trunc0'" _n /*
		*/ _col(15) "(evaluated at n=" in ye "`grstr'" in gr ")"

		if "`trunc0'" != "" { 
			di in smcl in gr _n "(*) Truncated at zero."
		}
	}
end
exit
