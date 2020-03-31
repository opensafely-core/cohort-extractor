*! version 1.0.0  29jan2007
* display coefficients and asymptotic std.err. for exlogistic/expoisson

program _exactreg_replayse, rclass
	version 10

	syntax [, coef irr ]

	if "`e(cmd)'" == "exlogistic" {
		if ("`coef'"!="") local lcoef Coef.
		else local lcoef Odds Ratio
	}
	else if "`e(cmd)'" == "expoisson" {
		if ("`irr'"!="") local lcoef IRR
		else {
			local lcoef Coef.
			local coef coef
		}
	}
	else error 301

	di
	tempname Tab
	.`Tab' = ._tab.new, col(4) lmargin(0) ignore(.b)
	// column        1      2   3      4  
	.`Tab'.width	13    |11   1     11   
	.`Tab'.titlefmt  .   %11s %1s   %11s   
	.`Tab'.strfmt    .   %11s   .      . 
	.`Tab'.pad       .      2   0      1   
	.`Tab'.strcolor  result .   . result   
	.`Tab'.sep, top
	.`Tab'.titles	`"`=abbrev("`e(depvar)'",12)'"'	/// 1
			"`lcoef'"	/// 2
			""              /// 3
			"Std. Err." 	/// 4

	.`Tab'.strcolor  text result  . result
	.`Tab'.numfmt       .  %9.0g  .  %9.0g  

	tempname est 
	local vnames: colnames e(b)
	local bnames `vnames'
	local k = 0
	tempname b se imue

	mat `est' = J(2,`:word count `vnames'',.)
	mat colnames `est' = `vnames'

	if ("`coef'"=="") mat rownames `est' = OR se
	else mat rownames `est' = estimate se

	.`Tab'.sep
	foreach vi of local vnames {
		mat `b' = e(b)
		local i : list posof "`vi'" in vnames
		scalar `b' = `b'[1,`i']
		if ("`coef'"=="") scalar `b' = exp(`b')
		mat `imue' = e(mue_indicators)
		scalar `imue' = `imue'[1,`i']
		if `imue' == 0 { 
			mat `se' = e(se)
			scalar `se' = `se'[1,`i']
			if ("`coef'"=="") scalar `se' = `se'*`b'
			local muei
			local dse `se'
		}
		else {
			local dse `""N/A ""'
			local muei *
			scalar `se' = .
		}
		mat `est'[1,`i'] = `b'
		mat `est'[2,`i'] = `se'
		.`Tab'.row `"`=abbrev("`vi'",12)'"' `b' "`muei'" `dse' 
	}
	.`Tab'.sep, bottom

	forvalues i=1/`=colsof(e(mue_indicators))' {
		if el(e(mue_indicators),1,`i') {
			di in smcl in gr "{p}(*) median unbiased estimates" ///
			 "(MUE){p_end}"
			continue, break
		}
	}
	return matrix estimates = `est'
end

