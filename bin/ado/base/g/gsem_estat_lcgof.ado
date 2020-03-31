*! version 1.0.2  17oct2017
program gsem_estat_lcgof
	version 15

	if "`e(lclass)'" == "" {
		error 301
	}

	syntax [, noDEScribe FIT]

	local show_d = "`describe'"  == ""
	if "`fit'" == "" {
		quietly Compute
	}
	else {
		Fit
	}
	Display `show_d'
end

program Compute, rclass sortpreserve
	quietly estat ic
	return scalar aic = el(r(S),1,5)
	return scalar bic = el(r(S),1,6)

	if `"`e(chi2_ms)'"' == "" {
		exit
	}
	return scalar chi2_ms = e(chi2_ms)
	return scalar df_ms = e(df_ms)
	return scalar p_ms = e(p_ms)
end

program Fit, rclass
	quietly estat ic
	return scalar aic = el(r(S),1,5)
	return scalar bic = el(r(S),1,6)

	local model `"`e(lcgof_model)'"'
	if `"`model'"' == "" |	///
	   `"`e(lcgof_sat_df)'"' == "" | e(lcgof_sat_df) <= e(rank) {
		exit
	}

	gettoken GSEM model : model
	_parse expand L G : model
	local model gsem
	forval i = 1/`L_n' {
		gettoken EQ options : L_`i', parse(",")
		gettoken dv	EQ : EQ
		gettoken ARROW	EQ : EQ 
		gettoken xvars	EQ : EQ 
		if strpos(`"`xvars'"', "#") {
			local xvars : subinstr local xvars "#" " ", all
			tempname T
			quietly fvrevar `xvars', list
			quietly egen `T' = group(`r(varlist)')
			local L_`i' `dv' <- i.`T' `options'
		}
		local model `model' (`L_`i'')
	}

	if `"`e(groupvar)'"' != "" {
		local group group(`e(groupvar)') ginvariant(none)
	}
	if `"`e(wtype)'"' != "" {
		local wt "[`e(wtype)'`e(wexp)']"
	}

	tempname ehold
	quietly est store `ehold', nocopy
	capture noisily quietly `model' `wt' if _est_`ehold',	///
		noasis nocapslatent `group'
	local rc = c(rc)

capture noisily quietly nobreak {

break {

	if `rc' == 0 {
		lrtest `ehold' ., force
		return scalar chi2_ms = r(chi2)
	}

}

	quietly est restore `ehold'
	quietly est drop `ehold'
	if `rc' == 0 {
		return scalar df_ms = e(lcgof_sat_df) - 1 - e(rank)
		return scalar p_ms = chi2tail(return(df_ms), return(chi2_ms))
	}

}

	exit `rc'
end

program Display
	args show_d
	local fmt %10.3f

	Table_Head `show_d' 

	if "`r(chi2_ms)'" != "" {
		Header `show_d' "Likelihood ratio"
		CHI2 `show_d' `fmt'
	}

	Header `show_d' "Information criteria"
	IC `show_d' `fmt'

	Table_Foot `show_d'
end

program Table_Head
	args showd 

	local			ln2 12
	if (`showd') local	ln2 54

	if (`showd') local deswrd "   Description"

	dis
	dis as txt "{hline 21}{c TT}{hline `ln2'}
	dis as txt "{lalign 21:Fit statistic}{c |}      Value`deswrd'"
end

program Table_Foot
	args showd

	local			ln2 12
	if (`showd') local	ln2 54

	dis as txt "{hline 21}{c BT}{hline `ln2'}
end

program Header
	args showd header 

	local			ln2 12
	if (`showd') local	ln2 54

	dis as txt "{hline 21}{c +}{hline `ln2'}"
	dis as txt "{lalign 21:`header'}{c |}"
end

program SBHeader
	args showd  

	local                   ln2 12
	if (`showd') local      ln2 54
	dis as txt _skip(21) "{c |}"
	dis as txt "{lalign 21:  Satorra-Bentler}{c |}"
end

program RESIDUALS
	args showd fmt 

	if `showd' {
		local d_srmr "Standardized root mean squared residual"
		local d_cd "Coefficient of determination"
	}

	local cd : display `fmt' r(cd)

	if (`e(N_missing)'==0) {
		local srmr : display `fmt' r(srmr)
		dis as txt "{ralign 20:SRMR} {c |} " 	///
		    as res "{ralign 10:`srmr'}" 	///
		    as txt "   `d_srmr'" 
	}

	if (`e(k_oy)'+`e(k_ly)' > 0) {
		dis as txt "{ralign 20:CD} {c |} " 	///
	    	    as res "{ralign 10:`cd'}" 		///
	    	    as txt "   `d_cd'"
	}
end

program INDICES
	args showd fmt sbentler 

	if `showd' {
		local d_cfi "Comparative fit index"
		local d_tli "Tucker-Lewis index"
		local d_cfi_sb "Comparative fit index"
		local d_tli_sb "Tucker-Lewis index"
	}

	local cfi : display `fmt' r(cfi)
	local tli : display `fmt' r(tli)

	dis as txt "{ralign 20:CFI} {c |} "	/// 
	    as res "{ralign 10:`cfi'}" 		///
	    as txt "   `d_cfi'" 
	
	dis as txt "{ralign 20:TLI} {c |} " 	///
	    as res "{ralign 10:`tli'}" 		///
	    as txt "   `d_tli'"

	if `sbentler' {
		SBHeader `showd'
		local cfi_sb : display `fmt' r(cfi_sb)
		dis as txt "{ralign 20:CFI_SB} {c |} " ///
		    as res "{ralign 10:`cfi_sb'}"      ///
		    as txt "   `d_cfi_sb'"
		local tli_sb : display `fmt' r(tli_sb)
		dis as txt "{ralign 20:TLI_SB} {c |} " ///
		    as res "{ralign 10:`tli_sb'}"      ///
		    as txt "   `d_tli_sb'"
	}
end

program POPERR
	args showd fmt sbentler

	if `showd' {
		local d_rmsea "Root mean squared error of approximation"
		local d_p "Probability RMSEA <= 0.05"
		local d_rmsea_sb "Root mean squared error of approximation"
	}
	
	local rmsea: display `fmt' r(rmsea)
	local lb   : display `fmt' r(lb90_rmsea)
	local ub   : display `fmt' r(ub90_rmsea)

	dis as txt "{ralign 20:RMSEA} {c |} " 	///
	    as res "{ralign 10:`rmsea'}"	///
	    as txt "   `d_rmsea'"

	dis as txt "{ralign 20:90% CI, lower bound} {c |} " ///
	    as res "{ralign 10:`lb'}" 

	dis as txt "{ralign 20:upper bound} {c |} " ///
	    as res "{ralign 10:`ub'}" 
	
	if `e(N_groups)' == 1 {
		local p    : display `fmt' r(pclose)
		dis as txt "{ralign 20:pclose} {c |} " ///
		    as res "{ralign 10:`p'}" 		///
		    as txt "   `d_p'"
	}
	if `sbentler' {
		SBHeader `showd'
		local rmsea_sb : display `fmt' r(rmsea_sb)
		dis as txt "{ralign 20:RMSEA_SB} {c |} " ///
		    as res "{ralign 10:`rmsea_sb'}"      ///
		    as txt "   `d_rmsea_sb'"
	}
end

program IC
	args showd fmt

	if `showd' {
		local d_aic "Akaike's information criterion"
		local d_bic "Bayesian information criterion"
	}

	local aic : display `fmt' r(aic)
	local bic : display `fmt' r(bic)

	dis as txt "{ralign 20:AIC} {c |} "  	///
	    as res "{ralign 10:`aic'}"		/// 
	    as txt "   `d_aic'" 
	
	dis as txt "{ralign 20:BIC} {c |} " 	///
	    as res "{ralign 10:`bic'}" 		///
	    as txt "   `d_bic'" 
end

program CHI2
	args showd fmt

	local stat ms
	if `showd' {
		local d_ms "model vs. saturated"
	}
	local df    : display `r(df_`stat')'
	local chi2  : display %10.3f `r(chi2_`stat')'
	local p     : display %10.3f `r(p_`stat')'
	if `"`df'`chi2'`p'"' == "" {
                       continue
	}

	dis as txt "{ralign 20:chi2_`stat'({res:`df'})} {c |} "	///
	    as res "{ralign 10:`chi2'}"				///
	    as txt "   `d_ms'"

	dis as txt "{ralign 20:p > chi2} {c |} "		///
	    as res "{ralign 10:`p'}"
end

exit
