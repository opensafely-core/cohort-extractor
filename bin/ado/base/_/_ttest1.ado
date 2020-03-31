*! version 2.3.6  13feb2015 
program define _ttest1
	local name = trim(udsubstr(trim(`"`1'"'),1,8))
	local n "`2'"
	local mean "`3'"
	local se "`4'"
	local normal = "`5'"    /* don't take = sign away */
	local level "`6'"

	if `n' == 1 | `n' == . {
		local se = .
	}
	local beg = 9 - udstrlen(`"`name'"')
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local cilc = 59
	if `cil' == 4 {
		local cilc = 57
	}
	else if `cil' == 5 {
		local cilc = 56
	}
	if "`normal'" == "" {
		noi di in smcl in gr "{hline 9}{c TT}{hline 68}"
		noi di in smcl in gr "Variable {c |}" /*
		*/ _col(17) "Mean" _col(25) /*
		*/ "Std. Err." _col(41) "t" _col(47) /*
	*/ "P>|t|" _col(`cilc') `"[`=strsubdp("`level'")'% Conf. Interval]"'
		noi di in smcl in gr "{hline 9}{c +}{hline 68}"
		
		local tval = `mean'/`se'
		local df   = `n' - 1
		local pval = tprob(`df',`tval')
		noi di in smcl in gr _col(`beg') `"`name'"' /*
		*/ in gr _col(10) "{c |}" in ye /*
		*/ _col(12) %9.0g  `mean'   /*
		*/ _col(24) %9.0g  `se'     /*
		*/ _col(35) %8.0g  `tval'   /*
		*/ _col(46) %6.4f  `pval'   /*
		*/ _col(58) %9.0g  `mean'-invt(`df',`level'/100)*`se'   /*
		*/ _col(70) %9.0g  `mean'+invt(`df',`level'/100)*`se'
	}
	else {
		noi di 
		noi di in smcl in gr "{hline 9}{c TT}{hline 68}"
		noi di in smcl in gr "Variable {c |}" /*
		*/ _col(17) "Mean" _col(25) /*
		*/ "Std. Err." _col(41) "z" _col(47) /*
	*/ "P>|z|" _col(`cilc') `"[`=strsubdp("`level'")'% Conf. Interval]"'
		noi di in smcl in gr "{hline 9}{c +}{hline 68}"
		
		local tval = abs(`mean'/`se')
		local pval = 2*(1 - normprob(`tval'))

		local vval = (100-(100-`level')/2)/100
		noi di in smcl in gr _col(`beg') `"`name'"' /*
		*/ in gr _col(10) "{c |}" in ye /*
		*/ _col(12) %9.0g  `mean'   /*
		*/ _col(24) %9.0g  `se'     /*
		*/ _col(35) %8.0g  `tval'   /*
		*/ _col(46) %6.4f  `pval'   /*
		*/ _col(58) %9.0g  `mean'-invnorm(`vval')*`se'   /*
		*/ _col(70) %9.0g  `mean'+invnorm(`vval')*`se'
	}
end
exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
------------------------------------------------------------------------------
Variable |      Coef.   Std. Err.       t     P>|t|       [95% Conf. Interval]
---------+--------------------------------------------------------------------
   _cons |   6165.257   342.8719     17.981   0.000       5481.914      6848.6

