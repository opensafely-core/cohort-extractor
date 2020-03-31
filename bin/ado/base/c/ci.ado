*! version 4.0.2  09mar2018
program define ci, rclass byable(onecall)
	version 14
	local vv : di "version " string(_caller()) ", missing:"

	if _by() {
		local by "by `_byvars' `_byrc0':"
	}

	if _caller() < 14.1 {
		`by' ci_14_0 `0'
		return add
		exit
	}
	
	_parse comma lhs rhs : 0
	gettoken param lhs : lhs
	_ci_check_param paramname : "`param'" "ci"

	gettoken first : lhs
	if (`"`first'"'!="") {
		cap confirm number `first'
		if _rc==0 {
			di as err "{p}number found where a variable expected;"
			di as err "perhaps you meant to use {helpb cii}{p_end}"
			exit 198
		}
	}
	`vv' `by' ci_`paramname' `lhs' `rhs'
	ret add
end

program ci_means, rclass byable(onecall) /*everything handles in and if properly*/
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	
	syntax [anything] [if] [in] [aw fw] [, Level(cilevel) Poisson ///
		Exposure(varname) Total SEParator(integer 5) NORMAL /*undoc*/] 
	opts_exclusive "`normal' `poisson'"
	if ("`exposure'"!="") {
		local poisson poisson
	}
	local anything `anything' `if' `in'
	if _by() {
		local by "by `_byvars' `_byrc0':"
	}
	`vv' `by' ci_14_0 `0'
	
	/* repost results in the specific order */	
	ret scalar level = `level'
	ret scalar ub = r(ub)
	ret scalar lb = r(lb)
	ret scalar se = r(se)
	ret scalar mean = r(mean)	
	ret scalar N = r(N)
	local type "`poisson'`normal'"
	if "`type'" == "" local type normal
	ret local exposure = "`exposure'"
	ret local citype `type'
end

program ci_proportions, rclass byable(onecall)
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	
	local SYN_type EXAct wald wilson Agresti Jeffreys 
	gettoken before rest : 0, parse(" ,")
		
	if (`"`before'"' == "," | `"`before'"' == "") {
		local something anything
	}
	else {
		local something varlist
	}
	syntax [`something'] [if] [in] [fw] [, Poisson Exposure(varname) ///
		Binomial BY(varlist) `SYN_type' Level(cilevel) Total ///
		SEParator(integer 5) ]

	local no01 0

	foreach v of local `something' {
		confirm variable `v'				
		capture levelsof `v' `if' `in'
		if !_rc & r(r) > 2 { 
			continue
		}
		else {
			local binvars `binvars' `v' // contains vars with <= 2
						    // levels 			
			qui summ `v' `if' `in'
if (r(min) != 0 & r(min) != 1 ) | (r(max) != 0 & r(max) != 1) { 
				local no01 = `no01'+1    // # of vars in
							// binvars that are not
							// 0/1
			}
		}	
	}
	local nbin : word count `binvars'	
	if "``something''" != "" & ("`binvars'" == "" | `no01' == `nbin') {
		di as txt "no binary (0/1) variables found; nothing to compute"
		exit
	}
	
	local nvar : word count ``something''

	if `nbin' < `nvar' {
local note "Note: The results are produced only for binary (0/1) variables."
	}

	local something ``something'' `if' `in'

	if ("`poisson'"!="") {
		di as err "{p}option {bf:poisson} is not allowed with"
		di as err "{bf:ci proportions}{p_end}"
		exit 198
	}
	if ("`binomial'"!="") {
		di as err "{p}option {bf:binomial} is not allowed with"
		di as err "{bf:ci proportions}{p_end}"
		exit 198
	}
	if (`"`exposure'"'!="") {
		di as err "{p}option {bf:exposure()} is not allowed with"
		di as err "{bf:ci proportions}{p_end}"
		exit 198
	}
	opts_exclusive "`exact' `wald' `wilson' `agresti' `jeffreys'"
	
	if (`"`by'"'!="") {
		di as err "{p}option {bf:by()} is not allowed{p_end}"
		exit 198
	}
	if _by() {
		local by "by `_byvars' `_byrc0':"
	}
	_parse comma lhs rhs : 0
	if (`"`rhs'"'=="") {
		local rhs ","
	}
	local lhs `something' [`weight'`exp']
	`vv' `by' ci_14_0 `lhs' `rhs' binomial label("Proportion")
	if "`note'" != "" {
		di
		di as txt "`note'"
	}
	/* repost results in the specific order */		
	ret scalar level = `level'
	ret scalar ub = r(ub)
	ret scalar lb = r(lb)
	ret scalar se = r(se)
	ret scalar proportion = r(mean)	
	ret scalar N = r(N)
	return hidden scalar mean = r(mean)
	local type "`wald'`wilson'`agresti'`exact'`jeffreys'"
	if "`type'" == "" {
		local type exact
	}
	ret local citype `type'
end

program ci_variances, rclass byable(onecall)
	syntax [varlist] [if] [in] [fw] [,		   ///
		SD					   ///
		Level(cilevel) 	 ///
		BONett Total SEParator(integer 5) NORMAL /*undoc.*/]
	
	if _by() {
		local by "by `_byvars' `_byrc0':"
	}
	opts_exclusive "`normal' `bonett'"
	`by' ci_var `0'
	
	/* repost results in the specific order */	
	ret scalar level = `level'
	ret scalar ub = r(ub)
	ret scalar lb = r(lb)
	if "`bonett'" != "" {
		ret scalar kurtosis = r(kurtosis)
	}
	if "`sd'" != "" {
		ret scalar sd = r(sd)
	}	
	ret scalar Var = r(Var)	
	ret scalar N = r(N)
	ret hidden scalar Var_se = r(Var_se)
	local type "`bonett'`normal'"
	if "`type'" == "" local type normal
	ret local citype `type'
end

program define ci_var, rclass byable(recall)
	
	syntax [varlist] [if] [in] [fw] [,		   ///
		Level(cilevel) 	 ///
		sd BONett   /// 
		Total SEParator(integer 5)]
	
	if `separator'<0 {
		di in red as smcl "option {bf:separator()} must be >= 0"
		exit 198
	}
	if "`total'"!="" & !_by() {
		di in red as smcl "option {bf:total} may only be specified " _c
		di in red as smcl "with prefix {bf:by}"
		exit 198
	}

	tempvar touse
	mark `touse' [`weight'`exp'] `if' `in'
	
	local weight "[`weight'`exp']"
	
	di
	ci_var_wrk `varlist' `weight' if `touse', `sd' level(`level') ///
		`bonett' separator(`separator')
	ret add  /* add return values from ci_var_wrk */	
	if _by() & _bylastcall() & "`total'"!="" {
		tempvar alluse1
		mark `alluse1' `if' `in', noby
		markout `alluse1'
		di
		di in smcl as text "{hline 79}"
		di in smcl as text "-> Total"
		ci_var_wrk `varlist'  `weight' if `alluse1', `sd' ///
			level(`level') `bonett' separator(`separator') 				
		return clear
		ret add	
	}		
end

/*
	- Compute CI for the standard deviation (option -sd-) or variance 
	  (the default). The default is the normal-based CI.
	- option -bonett- will compute the bonett CI. See eq. 4 in 
	  Bonett (2006) -- THERE WAS A TYPO in the expression for se (a missing 
	  'minus' sign) in the original paper
*/

program define ci_var_wrk, rclass byable(recall)
	syntax varlist [if] [in] [fw] [, sd Level(cilevel)  /// 
		BONett SEParator(integer 5) ]
	 
	marksample touse_g, novarlist
	tempvar touse
	qui gen byte `touse' = `touse_g'

	tempname alpha z n
	local ttl "Variance"
	local ret_val return(Var)
	local nlines 0
	
	if "`bonett'" != "" {
		di in smcl in gr _col(47) /*
		      */ "{hline 6} Bonett {hline 6}"
	}	
	if "`sd'" != "" {
		local ttl "Std. Dev."
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
	di in smcl in gr _col(5) /*
	  */  "Variable {c |}" _col(23) /* 
	  */ "Obs" /* 
	  */ _col(32) "`ttl'" /* 
	  */ _col(44) `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'/*
	  */ _n "{hline 13}{c +}{hline 52}"
	  	
	scalar `alpha' = (100 - `level')/100
	scalar `z' = invnormal(1 - `alpha'/2)
	foreach v of local varlist {				
		capture confirm string var `v'
		if _rc==0 { 
			continue
		}
		qui replace `touse' = `touse_g'*(`v'<.)
		if "`bonett'" !=  "" {
			tempname c se g4
			qui summarize `v' [`weight' `exp'] if `touse'
			if "`weight'" == "fweight" {
				tokenize `exp', parse(" =")
				preserve
				qui expand `2'
			}
			
			mata: st_numscalar("`g4'", kurt("`v'","`touse'","`n'"))
			scalar `c' = `n'/(`n' - `z')
			scalar `se' = `c' * sqrt((`g4'-(`n'-3)/`n')/(`n'-1))
			ret scalar N = `n'
			ret scalar lb = exp(log(`c' * r(Var)) - `z' * `se')
			ret scalar Var = r(Var)
			ret scalar ub = exp(log(`c' * r(Var)) + `z' * `se')
			ret scalar kurtosis = `g4'
			ret hidden scalar Var_se = `se'
		}
		else { /* normal-based CI */
			qui summarize `v' [`weight' `exp'] if `touse'			
			ret scalar lb=(r(N)-1)*r(Var)/invchi2tail(r(N)-1,`alpha'/2)
			ret scalar ub=(r(N)-1)*r(Var)/invchi2(r(N)-1,`alpha'/2)
			ret scalar Var = r(Var)
			ret scalar N = r(N)
		} 
					
		/* Dealing with sep option */
		if (mod(`nlines++',`separator')==0) {
			if `nlines' != 1 {
				di in smcl as txt ///
				    "{hline 13}{c +}{hline 52}" 
			}
		}
		local efmt %10.0fc			
		local fmt : format `v'
		if bsubstr("`fmt'",-1,1)=="f" {
			local ofmt="%9."+bsubstr("`fmt'",-2,2)
		}
		else if bsubstr("`fmt'",-2,2)=="fc" {
			local ofmt="%9."+bsubstr("`fmt'",-3,3)
		}
		else    local ofmt "%9.0g"
		
		if "`sd'" != "" {
			local std sd
			di in smcl in gr /*
			  */ %12s abbrev("`v'",12) " {c |}" _col(16) /*
			  */ in yel `efmt' return(N) /*
			  */ _col(31) `ofmt' sqrt(`ret_val') /*
			  */ _col(46) `ofmt' sqrt(return(lb)) /*
			  */ _col(58) `ofmt' sqrt(return(ub))
			ret scalar N = return(N)
			ret scalar lb = sqrt(return(lb))
			ret scalar `std' = sqrt(`ret_val')
			ret scalar ub = sqrt(return(ub))
		}
		else {
			di in smcl in gr /*
			  */ %12s abbrev("`v'",12) " {c |}" _col(16) /*
			  */ in yel `efmt' return(N) /*
			  */ _col(31) `ofmt' `ret_val' /*
			  */ _col(46) `ofmt' return(lb) /*
			  */ _col(58) `ofmt' return(ub)
		}
		
		
	}
end

/*
	- mata function kurt(): compute an estimate of kurtosis 
		needed in Bonett Interval, see Bonett (2006) eq (2)
*/

version 14.0

mata:
real scalar kurt(string scalar varname, string scalar touse, 
                 string scalar n_obs)
{
	real colvector x
	real scalar n, xbar, trim, lo, hi, m, num, den, krt
	
	x = st_data(., varname, touse)
	n = length(x)
	xbar = mean(x)
	trim = 1/(2 * sqrt(n - 4)) /* one-side trim */
	lo = floor(n * trim) + 1
	hi = n + 1 - lo
	_sort(x,1)
	m = mean(x[lo..hi])
	num = n * sum((x :- m):^4)
	den = sum((x :- xbar):^2)
	krt = num/(den^2)
	st_numscalar(n_obs, n)
	return(krt)
}
end
exit

