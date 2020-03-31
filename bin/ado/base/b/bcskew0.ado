*! version 3.2.0  19feb2019
program define bcskew0, rclass
	version 6, missing
	global S_1 .	/* k */
	global S_2 .   /* limit */
	global S_3 . 
	global S_4 .  /* skew */

	syntax anything(name=eq equalok) [if] [in] [, Level(passthru) * ]
	if "`level'" != "" {
		local old `"`eq' `if' `in' , `options'"'
		local 0 ", `level'"
		syntax [, level(cilevel)]
		local 0 `"`old'"'
		local ci = `level'/100
	}
	else {
		local level 95
		local ci 0
	} 
	
	syntax newvarname =/exp [if] [in] [, /*
		*/ Delta(real 0) Zero(real 0) ]
	local exp `=trim(`"`exp'"')'    // rm white space, messes up output
	tempvar bcx x
	quietly {
		gen double `bcx'=.
		gen double `x' = `exp' `if' `in'
		sum `x', detail
		local obs = r(N)
		if `obs' < 3 { noisily error 2001 }
		if r(max) == r(min) {
			noisily di in red "no variance"
			exit 409
		}
		local skew = r(skewness)
		local k 1
		local delta = cond(`delta'<=0, .01, `delta')
		local zero  = cond(`zero' <=0, .001, `zero')

		local target 0
		Bcs0 `x' `k' `delta' `zero' `target' `bcx'
		local k "`r(lambda)'" /* lambda in transformed units */
		local skewg "`r(skewness)'"
		/*
			Find confidence interval for lambda in transformed units
			if n>=8.
		*/
		if (`obs'>7) & (`ci'>0) & (`k' < .) {
			local z = invnorm(0.5+0.5*`ci')
			_crczsku `z' `obs' 1
			local target = -r(target)
			/*
				Lower confidence limit (if it exists).
				If not, it is taken as missing (minus infinity).
			*/
			if abs(`skew')<`target' { local kl .  }
			else {
				Bcs0 `x' `k' `delta' `zero' `target' `bcx'
				local kl = `r(lambda)'
			}
			local target = -`target'
			Bcs0 `x' `k' `delta' `zero' `target' `bcx'
			local kh = `r(lambda)'
		}
		else 	local ci 0
		if abs(`k') > 1e-10 {
			replace `bcx' = expm1(`k'*log(`x'))/`k'
			local kr : display %9.0g `k'
			local kr = trim(`"`kr'"')
			local label `"(`exp'^`kr'-1)/`kr'"'
		}
		else {
			replace `bcx' = log(`x')
			local label `"ln(`exp')"'
		}
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
	di _n in smcl in gr _col(8) "Transform" _col(18) "{c |}"  /*
		*/ _col(28) "L" _col(31) "`spaces'" /*
*/ `"[`=strsubdp("`level'")'% Conf. Interval]       Skewness"' _n /* 
		*/ "{hline 17}{c +}{hline 50}"
	local lhs = "("+udsubstr("`exp'",1,8)+"^L-1)/L"
	local l=16-udstrlen("`lhs'")
	di in smcl in gr _skip(`l') "`lhs' {c |}  " in ye %9.0g `k' "    " _c
	if `ci' { 
		ret scalar lb = `kl'
		ret scalar ub = `kh'
		global S_2 `kl'
		global S_3 `kh'
		if `kl'>=. { 
			di "-infinity" _c
		}
		else	di %9.0g `kl' _c
		di "  " %9.0g `kh' _c
	}
	else {
		di in gr "  (not calculated)  " _c
	}
	ret scalar skewness = `skewg'
	global S_4 `skewg'
	di "      " %9.0g `return(skewness)'
	ret scalar lambda = `k'
	global S_1 `k'
	gen `typlist' `varlist' = `bcx'
	label var `varlist' `"`label'"'
end


program define Bcs0, rclass
/*
	Args: 1=_x, 2=lambda, 3=`delta', 4=`zero', 5=target skewness.
	6=_bcx variable
	Returns lambda in r(lambda), skewness in r(skewness).
*/
	local x "`1'"
	local k = `2'
	local delta = `3'
	local zero = `4'
	local target = `5'
	local bcx "`6'"
	local iter = 0
	local maxit 100
	if abs(`k')>1e-10 {
		replace `bcx' = (exp(`k'*log(`x'))-1)/`k'
	}
	else 	replace `bcx' = log(`x')
	summ `bcx', detail
	local f0 = r(skewness)-`target'
	ret scalar skewness = r(skewness)
	while (abs(`f0') > `zero') & (`iter' < `maxit') {
		local iter = `iter'+1
		local dk = `delta'+`k'
		if abs(`dk')>1e-10 {
			replace `bcx' = (exp(`dk'*log(`x'))-1)/`dk'
		}
		else 	replace `bcx' = log(`x')
		sum `bcx', detail
		local m = (r(skewness)-`target'-`f0')/`delta'
		if `m' == 0 {
			noisily di in bl /*
			*/ "(Convergence problems, doubling the value of delta)"
			local delta = `delta'*2
		}
		else {
			local k = `k'-`f0'/`m'
			if abs(`k')>1e-10 {
				replace `bcx' = (exp(`k'*log(`x'))-1)/`k'
			}
			else 	replace `bcx' = log(`x')
			sum `bcx', detail
			local f0 = r(skewness)-`target'
			ret scalar skewness = r(skewness)
		}
	}
	ret scalar lambda = `k'
end
