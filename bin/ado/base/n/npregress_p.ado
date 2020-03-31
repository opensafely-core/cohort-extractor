*! version 1.0.5  22feb2018
program define npregress_p
        version 15
        
        syntax [anything] [if] [in],			///
                        [				///
				Residuals		///
				DERIVatives		///
				MEAN			///			
                        ]   

	marksample touse 
	local touse2 e(sample)
	tempvar touse3 naranjas
	quietly generate `touse3' = `touse'*`touse2'
	quietly replace `touse' = `touse3'	

	local k = e(kscores)
	_stubstar2names `anything', nvars(`k') singleok
        local varlist  = s(varlist)
        local typlist `s(typlist)'
        local ns: list sizeof varlist 

	local options =  ("`residuals'"!="") + ("`derivatives'"!="")  + ///      
			 ("`mean'"!="")
	
	if (`options'>1) {
		display as error "you may request at most one statistic"
		exit 198
	}
	if (`options'==0) {
		di as txt "(option {bf:mean} assumed; mean function)"
	}

	quietly capture checkestimationsample
	local rc = _rc
	if (`rc' & "`c(marginsdxvars)'"=="" & "`c(marginsatvars)'"=="" & ///
		"`c(marginsmvars)'"=="") {
		 display as error ///
		"data have changed since estimation"
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:margins} and {bf:predict} "
		di as smcl as err "after {bf:npregress} "
		di as smcl as err "will not work if your covariates," 
		di as smcl as err "your dependent variable, or the "
		di as smcl as err "predictions from {bf:npregress} "
		di as smcl as err "have changed" 
		di as smcl as err " since estimation." 
		di as smcl as err "{p_end}"
		exit 198		
	}

	capture confirm numeric variable `e(yname)'
	local rc = _rc
	if ((`options'== 0|"`mean'"!=""|"`residuals'"!="") & `rc'==0) {	
		if ("`residuals'"!="") {
			generate `typlist' `varlist' =  ///
				`e(lhs)' - `e(yname)' if `touse'
			label var `varlist' "mean function residuals"
		}
		else {
			generate `typlist' `varlist' =  `e(yname)' if `touse'
			label var `varlist' "mean function" 
		}
	}
	if ((`options'== 0|"`mean'"!=""|"`residuals'"!="") & `rc') {
		tempvar yhat rdos newwgt ttot
		if("`e(wexp)'"!="") {
			local wgtb "`e(wtype)'"
			if ("`e(wtype)'"=="pweight") {
				local  wgtb "iweight"
			}
			local wgta "`e(wexp)'"
			local wgt "[`wgtb' `wgta']"
			local wgtc = 0 
			gettoken wgtbc wgtac: wgta
			if ("`weight'"=="fweight"|"`weight'"=="iweight") {
				local wgtc = 1
				clonevar `newwgt' = `wgtac'
			}
			egen `ttot' = total(`wgtac') if `touse'
			if (`wgtc'==0) {
				clonevar `newwgt' = `wgtac'
				summarize `touse', meanonly 
				local n = r(N)
				quietly replace `newwgt' = `newwgt'*`n'/(`ttot')
			}	
		}
		else {
			quietly generate `newwgt' = 1
		}
		quietly generate byte `naranjas'  = 1   
		quietly generate `typlist' `yhat' = . 
		quietly generate `typlist' `rdos' = .
		mata: _kernel_regression(`e(ke)', "`e(cvars)'", 	///
		"`e(dvars)'", "`e(lhs)'", "`e(kest)'", "`yhat'", 1, 	///
		"e(pbandwidths)", `e(aicm)', `e(cdnum)', 1, "`rdos'", 	///
		0, 1e-4, 1e-5, 1000, 0, 0,  .05, `e(cellnum)',		///
		"`newwgt'", "`naranjas'", "e(converged_mean)",  	///
		"e(ilog_mean)", "`touse'")
		if ("`residuals'"=="") {
			generate `typlist' `varlist' =  `yhat' if `touse'
			label var `varlist' "mean function" 
		}
		else {
			generate `typlist' `varlist' =  ///
				 - `yhat' if `touse'
			label var `varlist' "mean function residuals" 		
		}
	}
	if ("`derivatives'"!="") {
		local dlist "`e(cigradnoms)'"
		capture confirm numeric variable `dlist'
		local rc = _rc
		local c "`e(predictnoms)'"
		_parse expand a b: c
		if (`rc'==0) {
			forvalues i=1/`a_n' {
				local nom: word `i' of `varlist'
				local var: word `i' of `dlist'
				quietly generate `typlist' `nom' = `var'
				label var `nom' "`a_`i''"
			}
		}
		else {
			tempvar yhat rdos newwgt ttot
			if("`e(wexp)'"!="") {
				local wgtb "`e(wtype)'"
				if ("`e(wtype)'"=="pweight") {
					local  wgtb "iweight"
				}
				local wgta "`e(wexp)'"
				local wgt "[`wgtb' `wgta']"
				local wgtc = 0 
				gettoken wgtbc wgtac: wgta
				if ("`weight'"=="fweight"| ///
					"`weight'"=="iweight") {
					local wgtc = 1
					clonevar `newwgt' = `wgtac'
				}
				egen `ttot' = total(`wgtac') if `touse'
				if (`wgtc'==0) {
					clonevar `newwgt' = `wgtac'
					summarize `touse', meanonly 
					local n = r(N)
					quietly replace `newwgt' = ///
						`newwgt'*`n'/(`ttot')
				}	
			}
			else {
				quietly generate `newwgt' = 1
			}
			tempname gbase
			local kp1 = e(kp1)
			local kp2 = e(kp2)
			local grad ""
			local gradsen ""
			local kbase = rowsof(e(basevals))
			matrix `gbase' = J(1,`kbase', 0)
			forvalues i=1/`kp1' {
				tempvar x`i' 
				quietly generate `x`i'' = .
				local grad "`grad' `x`i''"
			}
			forvalues i=1/`kp2' {
				tempvar w`i'
				quietly generate `w`i'' = .
				local gradsen "`gradsen' `w`i''"
			}
			mata: _kernel_regression_gradient(`e(ke)', 	///
			"`e(cvars)'", "`e(dvars)'", "`e(lhs)'", 	///
			"`e(kest)'", "`grad'", "`gradsen'", "`gbase'", 	///
			1, "e(pbandwidthgrad)", `e(cdnum)', 1, 		///
			"e(pbandwidthgrad)", "e(basemat)", 		///
			"e(basevals)", "e(uniqvals)", 0, 0, 		///
			`e(tolerance)', `e(ltolerance)', `e(iterate)', 	///
			0, 0, `e(nmsdelta)', `e(cellnum)', "`newwgt'", 	///
			"e(pbandwidths)", "e(converged_effect)", 		///
			"e(ilog_effect)", "`touse'")	
			forvalues i=1/`a_n' {
				local nom: word `i' of `varlist'
				local var: word `i' of `grad'
				quietly generate `typlist' `nom' = `var'
				label var `nom' "`a_`i''"
			}
		}
	}

end
