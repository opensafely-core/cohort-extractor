*! version 3.4.5  28apr2016
program define ci_14_0, rclass byable(recall)
	version 6, missing
	local vv : di "version " string(_caller()) ", missing:"
	global vers = _caller()
	global S_1		/* # obs	*/
	global S_3		/* mean		*/
	global S_4		/* se of mean	*/
	global S_5		/* lower bound	*/
	global S_6		/* upper bound	*/
	
	if _caller() < 14.1 {
		local opts WAld Wilson	
	} 
	else {
		local opts wald wilson
	} 
	syntax [varlist] [if] [in] [aw fw] [, 			///
		Level(cilevel) Poisson Binomial  	///
		EXAct Agresti `opts' Jeffreys			///
		Exposure(varname) BY(varlist) Total SEParator(integer 5) ///
		label(passthru) ]

	if `separat'<0 {
		di in red as smcl "option {bf:separator()} must be >= 0"
		exit 198
	}

	if "`by'"!="" {		/* backwards compatibility */
		if _by() {
			di in red as smcl/*
			*/ "{bf:by()} option may not be combined with " _c
			di in red as smcl "{bf:by} prefix"
			exit 190
		}
		if "`weight'" != "" {
			local wgt `"[`weight'`exp']"'
		}
		if "`level'"!="" {
			local level "level(`level')"
		}
		if "`exposur'"!="" {
			local exposur "exposure(`exposur')"
		}
		`vv' by `by': ci_14_0 `varlist' `if' `in' `wgt', /*
			*/ `level' `poisson' `binomia' `exposur' `total'
		exit
	}

	if "`total'"!="" & !_by() {
		di in red as smcl "option {bf:total} may only be specified with by"
		exit 198
	}

	tempvar touse
	mark `touse' [`weight'`exp'] `if' `in'
	markout `touse' `exposur' /* but not `varlist' */

	if _by() & _bylastcall() & "`total'"!="" {
				/* set alluse for later use */
		tempvar alluse		
		mark `alluse' [`weight'`exp'] `if' `in', noby
		markout `alluse' `exposur' /* but not `varlist' */
	}
	
	local xtras = "`exact' `wald' `agresti' `wilson' `jeffrey'"
	local wrdcnt : word count `xtras'
	if `wrdcnt' > 1 {
		di in red as smcl "only one of {bf:exact}, {bf:wald}, " _c
		di in red as smcl "{bf:agresti}, {bf:wilson}, and " _c
		di in red as smcl "{bf:jeffreys} options allowed"
		exit 198
	}
	if `wrdcnt' >= 1 & "`binomia'"=="" {
		di in smcl as err "{p 0 4 2}"
		di in smcl as err "{bf:exact}, {bf:wald}, {bf:agresti}, " _c
		di in smcl as err "{bf:wilson} and {bf:jeffreys} options "
		di in smcl as err "require the {bf:binomial} option to be specified"
		di in smcl as err "{p_end}"
		exit 198
	}
	if "`binomia'"!=""&`wrdcnt'==0 {
		local exact exact
		local xtras = "`exact' `wald' `agresti' `wilson' `jeffrey'"
	}
	if "`exposur'"!="" { 
		if "`binomia'"!="" { 
			di in red as smcl "option {bf:exposure()} invalid"
			exit 198
		}
		local poisson poisson
		capture assert `exposur'>0 if `touse'
		if _rc { 
			di in red as smcl "variable {bf:`exposur'} <= 0"
			exit 402
		}
		local exposur "ex(`exposur')"
	}
	if "`weight'"=="aweight" & ("`binomia'"!="" | "`poisson'"!="") { 
		di in red as smcl "{bf:aweight}s not allowed"
		exit 101
	}
	local weight "[`weight'`exp']"
	tempvar BYGRP

	di
	Ci `varlist' `weight' if `touse', 				///
		level(`level') `binomia' `poisson' `xtras'		///
		`exposur' separator(`separat') `label'
	ret add  /* add return values from Ci */

	if _by() & _bylastcall() & "`total'"!="" {
		di
		di in smcl as text "{hline 79}"
		di in smcl as text "-> Total"
		if "`level'"!="" {
			local level "level(`level')"
		}
		`vv' ci_14_0 `varlist' if `alluse' `weight', /*
			*/ `level' `poisson' `binomia' `exposur' `xtras'
		return clear
		ret add
	}
end

/*
	In program Ci, we know the `if' is resolved to a touse variable
	and marks out everything except the missing values of the 
	variables.  Therefore, we do not reduce it again but just use `if'
*/

program define Ci, rclass
	syntax varlist [aw fw] [if] [, Level(cilevel) 		///
		 Binomial EXAct WAld Agresti Wilson Jeffreys Poisson Ex(varname)	///
		 SEParator(integer 5) label(string) ]
	
	tempvar tousex
	local spc "    "
	if (`"`label'"'!="") {
		local ttl "`label'"
		local spc "  "
		
	}
	else {
		local ttl "    Mean"
	}
	local tl1 "     Obs"
	
	if "`binomia'"!="" {
		if "`exact'"!="" {
			di in smcl in gr _col(58) /*
				*/ "{hline 2} Binomial Exact {hline 2}"
		}
		if "`wald'"!="" {
			di in smcl in gr _col(58) /*
				*/ "{hline 2} Binomial Wald {hline 3}"
		}
		if "`wilson'"!="" {
			di in smcl in gr _col(58) /*
				*/ "{hline 6} Wilson {hline 6}"
		}
		if "`agresti'"!="" {
			di in smcl in gr _col(58) /*
				*/ "{hline 2} Agresti-Coull {hline 3}"
		}
		if "`jeffrey'"!="" {
			di in smcl in gr _col(58) /*
				*/ "{hline 5} Jeffreys {hline 5}"
		}
	}
	else if "`poisson'"!="" {
		di in smcl in gr _col(58) /*
			*/ "{hline 2} Poisson  Exact {hline 2}"
		local tl1 "Exposure"
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
`"    Variable {c |}   `tl1'`spc'`ttl'    Std. Err.    `spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
	_n "{hline 13}{c +}{hline 63}" ;
	#delimit cr
	global S_1 0
	global S_2 .
	global S_3 . 
	global S_4 . 
	global S_5 . 
	global S_6 . 

	local nlines 0
	local marked 0 
	foreach v of local varlist {
		local mark
		local toprt 1
		capture confirm string var `v'
		if _rc==0 { 
			local toprt 0
		}
		else {
			if "`binomia'"!="" { 
				capture assert `v'==0 | `v'==1 | `v'>=. `if'
				if _rc { 
					local toprt 0
				}
				else {
					qui sum `v' [`weight'`exp'] `if', mean
					local n = r(N)
					local k = int(r(mean)*r(N)+.5)
					ret scalar N = `n'
					ret scalar mean = `k'/`n'
					ret scalar se=sqrt((return(mean)* /*
						*/ (1-return(mean)))/`n')
					tempname kap alph
					scalar `alph' = (100-`level')/200.0
					scalar `kap' = invnorm(1-`alph')

					if "`exact'" != "" { /* exact */
			ret scalar lb=invbinomial(`n',`k',`alph')
			ret scalar ub=invbinomial(`n',`k',1-`alph')
			if `k'==0 | `k'==`n' {
				local mark "*"
				local marked 1
			}
					}
					
					if "`wald'" != "" {
ret scalar lb=max(0,return(mean)-`kap'*return(se))
ret scalar ub=min(1,return(mean)+`kap'*return(se))
if return(lb) == 0 {
	local warnl "(*) The Wald interval was clipped at the lower endpoint"
	local mark "*"
	local marked 2
}
if return(ub) == 1 {
	local warnh "(**) The Wald interval was clipped at the upper endpoint"
	if "`mark'"=="" {
		local mark "**"
	}
	else {
		local mark "* **"
	}
	local marked 2
}
					}

					if "`wilson'" != "" { /* Wilson */
					tempname btem
scalar `btem' = (`k' + `kap'^2/2)/(`n' + `kap'^2) - (`kap'* sqrt(`n')/	/// 
  (`n' + `kap'^2))*sqrt(return(mean)*(1-return(mean))+`kap'^2/(4*`n'))
if `btem' < 0 {
	scalar `btem' = 0
	local warnl "(*) The Wilson interval was clipped at the lower endpoint"
	local mark "*"
	local marked 2
}
ret scalar lb = `btem'
scalar `btem' = (`k' + `kap'^2/2)/(`n' + `kap'^2) + (`kap'*sqrt(`n')/	///
  (`n' + `kap'^2))*sqrt(return(mean)*(1-return(mean))+`kap'^2/(4*`n'))
if `btem' > 1 & `btem' < . {
	scalar `btem' = 1
	local warnh "(**) The Wilson interval was clipped at the upper endpoint"
	if "`mark'"=="" {
		local mark "**"
	}
	else {
		local mark "* **"
	}
	local marked 2
}
ret scalar ub = `btem'
					}

					if "`agresti'"!="" { /*Agresti-Coull*/
			tempname xt nt pt qt btem
			scalar `xt' = `k' + `kap'^2/2
			scalar `nt' = `n' + `kap'^2
			scalar `pt' = `xt'/`nt'
			scalar `qt' = 1 - `pt'
			scalar `btem' =`pt' -`kap'*sqrt(`pt'*`qt')/sqrt(`nt')
			if `btem' < 0 {
				scalar `btem' = 0
local warnl "(*) The Agresti-Coull interval was clipped at the lower endpoint"
				local mark "*"
				local marked 2
			}
			ret scalar lb = `btem'
			scalar `btem' = `pt' +`kap'*sqrt(`pt'*`qt')/sqrt(`nt')
			if `btem' > 1 & `btem' < . {
				scalar `btem' = 1
local warnh "(**) The Agresti-Coull interval was clipped at the upper endpoint"
				if "`mark'"=="" {
					local mark "**"
				}
				else {
					local mark "* **"
				}
				local marked 2
			}
			ret scalar ub = `btem'
					}
			
					if "`jeffrey'"!="" { /* Jeffreys */
	if `k' > 0 {
		ret scalar lb = invibeta(`k'+ 0.5,`n'-`k'+0.5, `alph')
	}
	else {
		ret scalar lb = 0
	}
	if `k' < `n' {
		ret scalar ub = invibeta(`k'+0.5,`n'-`k'+0.5,1.0-`alph')
	}
	else {
		ret scalar ub = 1
	}
					}

					/* double save in S_# and r() */
					global S_1 `return(N)'
					global S_3 `return(mean)'
					global S_4 `return(se)'
					global S_5 `return(lb)'
					global S_6 `return(ub)'
				}
			}
			else if "`poisson'"!="" { 
				capture assert `v'>=0 | `v'>=. `if'
				if _rc { 
					local toprt 0
				}
				else {
					capture drop `tousex'
					mark `tousex' `if'
					markout `tousex' `v'
					qui sum `v' [`weight'`exp'] `if', mean
					local n = r(N)
					local k = int(r(mean)*r(N)+.5)
					if "`ex'"!="" { 
	    				    qui sum `ex' [`weight'`exp'] /*
							*/ `if' & `tousex'
					    local n = r(mean)*r(N)
					}
					/* The missing condition only happens when there are no observations in the by() group */
					tempname alph
					scalar `alph' = (100-`level')/200
					if "`k'" != "." {
						ret scalar lb = ///
				cond(`k'==0, 0,invpoisson(`k'-1,1-`alph')/`n')
						ret scalar ub = ///
						    invpoisson(`k',`alph')/`n'
						ret scalar N = `n'
						ret scalar mean = `k'/`n'
						ret scalar se = sqrt(`k')/`n'
					}
					/* double save in S_# and r() */
					global S_1 `return(N)'
					global S_3 `return(mean)'
					global S_4 `return(se)'
					global S_5 `return(lb)'
					global S_6 `return(ub)'
					if `k'==0 { 
						local mark "*"
						local marked 1
					}
				}
			}
			else { 
				qui summ `v' [`weight'`exp'] `if'
				ret scalar N = r(N)
				ret scalar mean = r(mean)
				ret scalar se = sqrt(r(Var)/r(N))
				local invt = invt(r(N)-1, `level'/100)
				ret scalar lb = r(mean) - `invt'*return(se)
				ret scalar ub = r(mean) + `invt'*return(se)
				/* double save in S_# and r() */
				global S_1 `return(N)'
				global S_3 `return(mean)'
				global S_4 `return(se)'
				global S_5 `return(lb)'
				global S_6 `return(ub)'
			}
			if `toprt' { 
				local ccol 16
				local efmt %10.0fc
				if "`poisson'" != "" {
					local ccol 17
					local efmt %9.0g
				}
				if (mod(`nlines++',`separat')==0) {
					if `nlines'!=1 {
						di in smcl as txt ///
						"{hline 13}{c +}{hline 63}" 
					}
				}
				local fmt : format `v'
				if bsubstr("`fmt'",-1,1)=="f" {
					local ofmt="%9."+bsubstr("`fmt'",-2,2)
				}
				else if bsubstr("`fmt'",-2,2)=="fc" {
					local ofmt="%9."+bsubstr("`fmt'",-3,3)
				}
				else	local ofmt "%9.0g"
				di in smcl in gr /*
				*/ %12s abbrev("`v'",12) " {c |}" _col(`ccol') /*
				*/ in yel `efmt' return(N) /*
		 		*/ _col(29) `ofmt' return(mean) /*
		 		*/ _col(41) `ofmt' return(se) /*
		 		*/ _col(57) `ofmt' return(lb) /*
		 		*/ _col(69) `ofmt' return(ub) in gr "`mark'"
			}
		}
	}
	if `marked' == 1 { 
		di _n in gr "(*) one-sided, " 100-(100-`level')/2 /*
		*/ "% confidence interval"
	}
	if `marked' == 2 {
		if `"`warnl'"'!="" | `"`warnh'"' != "" {
			di 
			if `"`warnl'"'!="" {
				di in gr "`warnl'"
			}
			if `"`warnh'"'!="" {
				di in gr "`warnh'"
			}
		}
	}
end
exit
