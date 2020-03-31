*! version 3.4.0  16feb2015
program define lnskew0, rclass sort
	version 6, missing
	global S_1 .	/* Gamma */
	global S_2 . 	/* Lower confidence limit */
	global S_3 . 	/* Upper confidence limit */
	global S_4 . 	/* skewness */

	syntax anything(name=eq equalok) [if] [in] [, Level(passthru) * ]
	if "`level'" != "" {
		local old `"`eq' `if' `in' , `options'"'
		local 0 ", `level'"
		syntax [, level(cilevel)]
		local 0 `"`old'"'
		local ci = `level'/100
	}
	else {
		local ci 0
		local level 95
	}		

	syntax newvarname =/exp [if] [in] [, /*
		*/ Delta(real 0) Zero(real 0) ]
	local exp `=trim(`"`exp'"')'	// rm white space, messes up output
	tempvar x lnx
	quietly {
		gen double `lnx'=.
		gen double `x' = `exp' `if' `in'
		summ `x', detail
		local obs = r(N)
		if `obs' < 3 { noisily error 2001 }
		local skew = r(skewness)
		local min = r(min)
		local max = r(max)
		if `min' == `max' {
			noisily di in red "no variance"
			exit 409
		}
		local min0 = r(min)
		local range = r(max)-r(min)
		/*
			Standardize data so that min=0, max=1.
		*/
		replace `x' = (`x'-`min0')/`range'
		local min = 0
		local max = 1
		/*
			Start of Gstar.
		*/
		local xmed = (r(p50)-`min0')/`range'
		local term = `min'+`max'-2.0*`xmed'
		local gamma = -4
		if `term'>0 { 
			local g = `min'-(`min'-`xmed')^2/`term'
		}
		else 	if `term'<0 { 
			local g =-`max'+(`max'-`xmed')^2/`term' 
		}
		else {
			local g -4
		} 
		local m1 = 1
		if `skew'<0 {
			local min -1
			local max 0
			replace `x' = -`x'
			local minus "-"
			local m1 -1
		}
		if (`g'>-4) & (`term'<0)==(`skew'<0) { local gamma = `g' }
		/*
			End of Gstar.
		*/
		local delta = cond(`delta'<=0, .02, `delta')
		local zero  = cond(`zero' <=0, .001, `zero')

		local target 0
		Lnskew0 `x' `gamma' `min' `delta' `zero' `target' `lnx'
		local gamma = r(gamma) 	/* gamma in transformed units */
		local skewg = r(skewness)
		/*
			Find confidence interval for gamma in transformed units
			if n>=8.
		*/
		if (`obs'>7) & (`ci'>0) {
			local z = invnorm(0.5+0.5*`ci')
			_crczsku `z' `obs' 1
			local target = r(target)
			/*
				Lower confidence limit (if it exists).
				If not, it is taken as missing (minus infinity).
			*/
			if abs(`skew')<`target' { local gammal .  }
			else {
				Lnskew0 `x' `gamma' `min' /*
					*/ `delta' `zero' `target' `lnx'
				local gammal = `m1'*`min0'+r(gamma)*`range'
			}
			local target = -`target'
			Lnskew0 `x' `gamma' `min' `delta' /*
					*/ `zero' `target' `lnx'
			local gammah = `m1'*`min0'+r(gamma)*`range'
		}
		else	local ci 0
		replace `lnx'=`lnx'+log(`range')
		replace `lnx'=log(`x'-`gamma')+log(`range')
		local gamma = `m1'*`min0'+`gamma'*`range'
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
        di _n in smcl in gr _col(8) "Transform" _col(18) "{c |}" /*
		*/ _col(28) "k" _col(31) "`spaces'" /*
*/ `"[`=strsubdp("`level'")'% Conf. Interval]       Skewness"' _n /*
		*/ "{hline 17}{c +}{hline 50}"
	local lhs = "ln(`minus'"+bsubstr("`exp'",1,8)+"-k)"
	local l=16-length("`lhs'")
	di in smcl in gr _skip(`l') "`lhs' {c |}  " /*
		*/ in ye %9.0g `gamma' "    " _c
	if `ci' { 
		ret scalar lb = `gammal'
		ret scalar ub = `gammah'
		global S_2 `gammal'
		global S_3 `gammah'
		if `gammal'>=. { 
			di "-infinity" _c
		}
		else	di %9.0g `gammal' _c
		di "  " %9.0g `gammah' _c
	}
	else {
		di in gr "  (not calculated)  " _c
	}
	ret scalar skewness = `skewg'
	global S_4 `skewg'
	di "      " %9.0g return(skewness)
	ret scalar gamma = `gamma'
	global S_1 `gamma'
	local gamma : display string(`gamma', "%9.0g")
	local gamma = trim(`"`gamma'"')
	if `gamma' > 0 {
		local label `"ln(`minus'`exp'-`gamma')"'
	}
	else {
		local gamma = -`gamma'
		local label `"ln(`minus'`exp'+`gamma')"'
	}
	gen `typlist' `varlist' = `lnx' 
	label var `varlist' `"`label'"'
end


program define Lnskew0, rclass
/*
	Args: 1=_x, 2=gamma, 3=`min', 4=`delta', 5=`zero', 6=target skewness.
	7=_lnx variable
	Returns gamma in r(gamma),  skewness in r(skewness)
*/
	args X 
	local gamma = `2'
	local min = `3'
	local delta = `4'
	local zero = `5'
	local target = `6'
	local lnx "`7'"

	local iter 0
	local eta = -log(`min'-`gamma')
	replace `lnx' = log(`X'-`gamma')
	sort `lnx'	/* for speed */
	summ `lnx', detail
	local f0 = r(skewness)-`target'
	ret scalar skewness = r(skewness)
*	di in red "Iter      Gamma     Skewness"
	while (abs(`f0') > `zero') {
 		* noisily di in red `iter' " " `gamma' " " `f0'
		local iter = `iter'+1
		replace `lnx' = log(`X'-`min'+exp(-`eta'-`delta'))
		sum `lnx', detail
		local m = (r(skewness)-`target'-`f0')/`delta'
		if `m' == 0 {
			* noisily di in red /*
			*/ "(convergence problems, doubling the value of delta)"
			local delta = `delta'*2
		}
		else {
			local eta = `eta'-`f0'/`m'
			local gamma = `min'-exp(-`eta')
			if (`gamma' > `min') {
				local gamma = `min'-.0000001
				local eta = -log(`min'-`gamma')
			}
			replace `lnx' = log(`X'-`gamma')
			sum `lnx', detail
			local f0 = r(skewness)-`target'
			ret scalar skewness = r(skewness)
		}
	}
	ret scalar gamma = `gamma'
end
