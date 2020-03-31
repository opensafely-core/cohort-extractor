*! version 1.1.1  17feb2015

program sem_estat_gof, rclass
	version 12
	local ver : di "version " string(_caller()) ", missing :"

	if "`e(cmd)'"!="sem" {
		error 301
	}

	syntax [, STats(str) 		///
		  noDEScribe 		///
		]			//

	local show_d = "`describe'"  == ""
	local isrobust = "`e(vcetype)'" == "Robust"
	local issvy = "`e(prefix)'" == "svy"

    	if "`stats'" == "" {
		local stats chi2
	}

	GOF_parse_stats `"`stats'"'
	local stats   `s(stats)' 
	
	foreach s of local stats {
		local `s' `s' 	
	}
	local showtable 1
	if (`isrobust' | `issvy') & "`residuals'" == "" {
		local showtable 0
	}
	tempname nobs 
	matrix `nobs' = e(nobs)
	
	`ver' mata: st_sem_estat_gof(0)

	if "`stats'" != "" {
		local fmt %10.3f
		local issbentler = "`e(vce)'" == "sbentler"
		if `showtable' {
			Table_Head `show_d' 
			if ("`chi2'" != "" & !(`isrobust' | `issvy')) {
				CHI2 `show_d' `fmt' `issbentler'
			}

			if ("`poperr'" != "" & !(`isrobust' | `issvy')) {
				Header `show_d' "Population error"
				POPERR `show_d' `fmt' `issbentler'
			}

			if ("`ic'" != "" & !(`isrobust' | `issvy')) {
				Header `show_d' "Information criteria"
				IC `show_d' `fmt'
			}

			if ("`indices'" != "" & !(`isrobust' | `issvy')) {
				Header `show_d' "Baseline comparison"
				INDICES `show_d' `fmt' `issbentler'	
			}

			if "`residuals'" != "" {
				Header `show_d' "Size of residuals"
				RESIDUALS `show_d' `fmt'
			}
			Table_Foot `show_d'
		}
	}

	local w = 33
	if `show_d' {
		local w = 75
	}
	
	if (`issvy' & "`stats'" != "residuals") {
		di as txt "{p 0 2 2 `w'}Note: model was fit with" ///
			" svy: prefix; only stats(residuals) valid.{p_end}"
	}
	else if !`showtable' | (`isrobust' & "`stats'" != "residuals") {
		di as txt "{p 0 2 2 `w'}Note: model was fit with" ///
			" vce(`e(vce)'); only stats(residuals) valid.{p_end}"
	}
	else if "`poperr'" != "" & `e(N_groups)' > 1 {
		di as txt "{p 0 2 2 `w'}Note: pclose is not reported" ///
			" because of multiple groups.{p_end}"
	}
	if "`residuals'" != "" {
		if (`e(N_missing)' > 0) {
			di as txt "{p 0 2 2 `w'}Note: SRMR is not" ///
				" reported because of missing values.{p_end}"
		}
		if (`e(k_oy)'+`e(k_ly)' == 0) {
			di as txt "{p 0 2 2 `w'}Note: CD is not reported" ///
				" because there are no endogenous"	///
				" variables.{p_end}"
		}
	}
 	return add
	return scalar N_groups = `e(N_groups)'
	return matrix nobs = `nobs'
end

program GOF_parse_stats, sclass
	args st
	
	local ALL "chi2 RMSea INDices RESiduals"
	if "`e(method)'" == "ml" | "`e(method)'" == "mlmv" {
		local ALL "`ALL' IC"
	}

	local chkic ic

	if !("`e(method)'"=="ml" | "`e(method)'"=="mlmv") {
		local chk : list chkic in st
		if `chk' {
			di as err ///
			    "stats(ic) not allowed with method(`e(method)')"
			exit 198
		}
	}

	if `"`st'"'=="all" {
		local stlist
		foreach s of local ALL {
			local us = lower("`s'")
			if ("`us'"=="rmsea") local us poperr
			local stlist `stlist' `us'
		}
	}
	else { 
		local 0 ,`st' 
		capture noi syntax, [ `ALL' ] 
		local rc = _rc
		if `rc' {
			dis as err "in option stats()"
			exit `rc' 
		}
		
		local stlist             
		foreach s of local ALL {
			local us = lower("`s'") 
			if "``us''"!="" { 
				if ("``us''"=="rmsea") local us poperr
				local stlist `stlist' `us'
			}
		}
	}

	sreturn clear
	sreturn local stats  `stlist' 
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
	args showd fmt sbentler
	CHI2_HEAD `showd' 

	if `showd' {
		local d_ms "model vs. saturated"
		local d_bs "baseline vs. saturated"
		local dsb_ms "model vs. saturated"
		local dsb_bs "baseline vs. saturated"
	}
	local stats "ms bs"
	foreach stat of local stats {
		local df    : display `r(df_`stat')'
		local chi2  : display %10.3f `r(chi2_`stat')'
		local p     : display %10.3f `r(p_`stat')'
		if `"`df'`chi2'`p'"' == "" {
                        continue
		}

		dis as txt "{ralign 20:chi2_`stat'({res:`df'})} {c |} " ///
		    as res "{ralign 10:`chi2'}"                         ///
		    as txt "   `d_`stat''"

		dis as txt "{ralign 20:p > chi2} {c |} "        ///
		    as res "{ralign 10:`p'}"
	}

	if `sbentler' {
		SBHeader `showd'
		local stats "ms bs"
		foreach stat of local stats {
		    local df    : display `r(df_`stat')'
		    local chi2  : display %10.3f `r(chi2sb_`stat')'
		    local p     : display %10.3f `r(psb_`stat')'
		    if `"`df'`chi2'`p'"' == "" {
			continue
		    }

		    dis as txt "{ralign 20:chi2sb_`stat'({res:`df'})} {c |} " ///
			as res "{ralign 10:`chi2'}"			   ///
			as txt "   `d`stat''"

		    dis as txt "{ralign 20:p > chi2} {c |} " 	///
		    	as res "{ralign 10:`p'}" 
		}
	}
end

program CHI2_HEAD
	args showd

	local type_bs `e(chi2type_bs)'
	local type_ms `e(chi2type_ms)'

	if "`type_bs'" == "LR" {
		local btype Likelihood ratio
	}
	else if "`type_bs'" == "Discr." {
		local btype Discrepancy
	}
	if "`type_ms'" == "LR" {
		local mtype Likelihood ratio
	}
	else if "`type_ms'" == "Discr." {
		local mtype Discrepancy
	}

	if "`mtype'"!="" & "`btype'"!="" {
		if "`mtype'"!="`btype'" {
			local type = "`mtype' and " + `btype'
			local type : subinstr local ctype ///
				"Likelihood ratio" "LR"
		}
		else {
			local ctype `mtype'
		}
	}
	else {
		local ctype `mtype' `btype'
	}

	Header `showd' "`ctype'"
end

