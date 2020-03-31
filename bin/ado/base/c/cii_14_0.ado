*! version 3.3.3  28apr2016
program define cii_14_0, rclass
	version 3.1
	local vv : di "version " string(_caller()) ", missing:"
	local options "Level(cilevel)"
	parse "`*'", parse(" ,")
	local 1=`1'
	confirm number `1'
	local n `1'
	mac shift
	local 1=`1'
	confirm number `1'
	local mork `1'
	mac shift
	if bsubstr("`1'",1,1)=="," | "`1'"=="" { 
		local method "binomial"
		if _caller() < 14.1 {
			local opts WAld Wilson	
		} 
		else {
			local opts wald wilson
		} 
		local options "`options' Binomial Exact Poisson Agresti Jeffreys `opts'"
		if `mork' < 0 {
			di as err as smcl ///
			   "number of successes, {it:#succ}, must be positive"
			exit 198
		}
	}
	else { 
		local 1=`1'
		confirm number `1'
		local s `1'

		if _caller() > 14 {
			capture assert `s' >= 0
			if _rc {
				di as err in smcl "{bf:sd} must be nonnegative"
				exit 198
			}
		}
		mac shift 
		local method "normal"
	}
	parse "`*'"
	local xtras = "`poisson' `wald' `agresti' `wilson' `jeffrey' `exact'"
	local wrdcnt : word count `xtras'
	if `wrdcnt' > 1 {
		di in red as smcl "only one of {bf:exact}, {bf:wald}, " _c
		di in red as smcl "{bf:agresti}, {bf:wilson}, and " _c
		di in red as smcl "{bf:jeffreys} options allowed"
		exit 198
	}
	if `wrdcnt' < 1 {
		local exact "exact"
	}
	local ttl "    Mean"
	local tt1 "     Obs"
	di
	local spc "    "
	if "`method'"=="normal" { 
		confirm integer number `n'
		ret scalar N = `n'
		ret scalar mean = `mork'
		ret scalar se = `s'/sqrt(`n')
		local invt = invt(`n'-1, `level'/100) 
		ret scalar lb = `mork' - `invt'*return(se)
		ret scalar ub = `mork' + `invt'*return(se)

		/* double save in S_# and r()  */
		global S_1 `return(N)'
		global S_3 `return(mean)'
		global S_4 `return(se)'
		global S_5 `return(lb)'
		global S_6 `return(ub)'
	}
	else { 
		if `mork'<1 { 
			local mork = int(`mork'*`n'+.5)
		}
		else { 
			confirm integer number `mork'
		}
		if "`poisson'"!=""  {    /* poisson */
			local tt1 "Exposure"
			tempname alph
			scalar `alph' = (100-`level')/200
			ret scalar lb = ///
			    cond(`mork'==0, 0,invpoisson(`mork'-1,1-`alph')/`n')
			ret scalar ub = invpoisson(`mork',`alph')/`n'
			ret scalar N = `n'
			ret scalar mean = `mork'/`n'
			ret scalar se = sqrt(`mork')/`n'
			/* double save in S_# and r()  */
			global S_1 `return(N)'
			global S_3 `return(mean)'
			global S_4 `return(se)'
			global S_5 `return(lb)'
			global S_6 `return(ub)'
			di in smcl in gr _col(58) /*
			*/ "{hline 2} Poisson  Exact {hline 2}"
			if `mork'==0 { 
				local mark "*"
			}
		}
		else {	           /* binomial of one kind or another */
			confirm integer number `n'
			if _caller() > 14 {
				local ttl "Proportion"
				local spc "  "
			}
			ret scalar N = `n'
			ret scalar mean = `mork'/`n'
			ret scalar se=sqrt((return(mean))*(1-return(mean))/`n')
			tempname kap alph
			scalar `alph' = (100-`level')/200.0
			scalar `kap' = invnorm(1-`alph')
			if "`wald'"!="" {
				tempname ltemp
				scalar `ltemp' = return(mean)-`kap'*return(se)	
				if `ltemp' < 0 {
					scalar `ltemp' = 0
local warnl "The Wald interval was clipped at the lower endpoint."
				}
				ret scalar lb = `ltemp'
				scalar `ltemp' = return(mean)+`kap'*return(se)
				if `ltemp' > 1 {
local warnh "The Wald interval was clipped at the upper endpoint."
					scalar `ltemp' = 1
				}
				ret scalar ub = `ltemp'
				di in smcl in gr _col(58) /*
				*/ "{hline 2} Binomial Wald {hline 3}"
			}
			if "`wilson'"!="" { /* wilson */
				tempname ltemp
				scalar `ltemp' = (`mork' + `kap'^2/2)/	/// 
					(`n' + `kap'^2) - (`kap'*	///
					sqrt(`n')/(`n' + `kap'^2))* 	///
				     sqrt(return(mean)*(1-return(mean))+ ///
				     	`kap'^2/(4*`n'))
				if `ltemp' < 0 {
					scalar `ltemp' = 0
local warnl "The Wilson interval was clipped at the lower endpoint."
				}
				ret scalar lb = `ltemp'
				scalar `ltemp' = (`mork' + `kap'^2/2)/	/// 
					(`n' + `kap'^2) + 		///
				     	(`kap'*sqrt(`n')/		///
					(`n' + `kap'^2))* 		///
				     sqrt(return(mean)*(1-return(mean))+ ///
				     	`kap'^2/(4*`n'))
				if `ltemp' > 1 & `ltemp' < . {
					scalar `ltemp' = 1
local warnh "The Wilson interval was clipped at the upper endpoint."
				}
				ret scalar ub = `ltemp'
				di in smcl in gr _col(58) /*
				*/ "{hline 6} Wilson {hline 6}"
			}
			if "`exact'"!="" {		/* exact */
				ret scalar lb=invbinomial(`n',`mork',	///
					`alph')
				ret scalar ub=invbinomial(`n',`mork',	///
					1-`alph')
				di in smcl in gr _col(58) /*
				*/ "{hline 2} Binomial Exact {hline 2}"
				if `mork'==0 | `mork'==`n' { 
					local mark "*"
				}
			}
			if "`agresti'"!="" {	/* Agresti-Coull */	///
				tempname xt nt pt qt ltemp
				scalar `xt' = `mork' + `kap'^2/2
				scalar `nt' = `n' + `kap'^2
				scalar `pt' = `xt'/`nt'
				scalar `qt' = 1 - `pt'
				scalar `ltemp' = `pt' -			/// 
					`kap'*sqrt(`pt'*`qt')/sqrt(`nt')
				if `ltemp' < 0 & `ltemp' < . {
					scalar `ltemp' = 0
local warnl "The Agresti-Coull interval was clipped at the lower endpoint."
				}
				ret scalar lb = `ltemp'
				scalar `ltemp' = `pt' +			///
					`kap'*sqrt(`pt'*`qt')/sqrt(`nt')
				if `ltemp' > 1 & `ltemp' < . {
					scalar `ltemp' = 1
local warnh "The Agresti-Coull interval was clipped at the upper endpoint."
				}
				ret scalar ub = `ltemp'	
				di in smcl in gr _col(58) /*
				*/ "{hline 2} Agresti-Coull {hline 3}"
			}
			if "`jeffrey'"!="" {   /* Jeffreys Interval */	
				if `mork' > 0 {
					ret scalar lb = invibeta(	///
						`mork'+ 0.5, 		///
						`n'-`mork'+0.5, `alph')
				}
				else {
					ret scalar lb = 0
				}
				if `mork' < `n' {
					ret scalar ub = invibeta(	///
						`mork'+0.5,		///
						`n'-`mork'+0.5, 1.0-`alph')
				}
				else {
					ret scalar ub = 1
				}
				di in smcl in gr _col(58)		/// 
					"{hline 5} Jeffreys {hline 5}"
			}
			/* double save in S_# and r()  */
			global S_1 `return(N)'
			global S_3 `return(mean)'
			global S_4 `return(se)'
			global S_5 `return(lb)'
			global S_6 `return(ub)'

		}
	}
	local efmt %10.0fc
	local ccol 16
	if "`poisson'"!="" {
		local efmt %9.0g
		local ccol 17
	}	
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces "    "
	if `cil' == 2 {
		local spaces "       "
	}
	else if `cil' == 4 {
		local spaces "     "
	}
	#delimit ;
	di in smcl in gr
`"    Variable {c |}   `tt1'`spc'`ttl'    Std. Err.`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
	_n "{hline 13}{c +}{hline 63}" ;
	di in smcl in gr "             {c |}" _col(`ccol') 
		in yel `efmt' return(N)
	 	_col(29) %9.0g return(mean)
	 	_col(41) %9.0g return(se)
	 	_col(57) %9.0g return(lb)
	 	_col(69) %9.0g return(ub) in gr "`mark'" ;
	#delimit cr
	if "`mark'"!="" { 
		di _n in gr "(*) one-sided, " 100-(100-`level')/2 /*
		*/ "% confidence interval"
	}
	if "`warnl'"!="" {
		di _n in gr "`warnl'"
	}
	if "`warnh'"!="" {
		di _n in gr "`warnh'"
	}
end
