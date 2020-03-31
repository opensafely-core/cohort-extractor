*! version 1.0.1  18jun2004
program define _vardisprmse
	version 8.2

	syntax , est(string) [ small ]

	if "`est'" == "var" {
		local neqs = e(neqs)
	}
	else if "`est'" == "vec" {
		local neqs = e(k_eq)

	}
	else if "`est'" == "svar" {
		local neqs = e(neqs)
		local svar   "_var"
	}
	else {
// 		should not be here but exit gracefully
		exit
	}	

	local vlist "`e(eqnames`svar')'"

	if "`small'" == "" {
		local stat_s "chi2"
		local pval_s " P>chi2"
	}
	else {
		local stat_s "F "
		local pval_s "  P > F"
	}

	tempname table

	.`table' = ._tab.new, col(6) lmargin(0)
	.`table'.width		17	8	11	10	11	7
	.`table'.numfmt		.	%6.0f	%8.7g	%7.4f	%9.8g	%7.4f
	.`table'.pad		.	.	2	1	.	.
	.`table'.strcolor	green	.	.	.	.	.
	.`table'.strfmt		%-16s	.	.	.	.	.
	.`table'.titlefmt	%-16s	.	.	.	.	.
	.`table'.titles		"Equation"	/// 1
				"Parms"		/// 2
				"RMSE "		/// 3
				"R-sq  "	/// 4
				"`stat_s'   "	/// 5
				"`pval_s'"	//  6


	.`table'.sep, top
	forvalues i = 1(1)`neqs' {
		if "`small'"  == "" {
local val = chi2tail( e(df_m`i'`svar'), e(chi2_`i'`svar')) 
		}
		else {
local val =  Ftail(e(df_m`i'`svar'), e(df_r`i'`svar'), e(F_`i'`svar')) 
		}

		local var : word `i' of `vlist'
		local var = abbrev("`var'", 16)
		if "`small'"  == "" {
			local sval = e(chi2_`i'`svar')
		}
		else {
			local sval = e(F_`i'`svar')
		}
		.`table'.row	"`var'"			///
				e(k_`i'`svar')		///
				e(rmse_`i'`svar')	///
				e(r2_`i'`svar')		///
				`sval'			///
				`val'
	}
	.`table'.sep, bot
end

