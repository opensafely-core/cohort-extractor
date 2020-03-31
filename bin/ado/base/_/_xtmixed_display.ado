*! version 1.4.0  10jan2020
program _xtmixed_display
	version 11.1

	syntax [, mi * ]

	if ("`e(cmd)'"=="mi estimate" | "`mi'"!="") {
		local sfx _mi
	}
	local is_xt = "`e(cmd`sfx')'"=="xtmixed"
	local is_me = "`e(cmd`sfx')'"=="mixed"
	if ( (!`is_xt' & !`is_me') | "`e(b`sfx')'"==""|"`e(V`sfx')'"=="") {
		error 301
	}
	
	local 0 , `options'
	syntax [, Level(cilevel) VARiance STDDEViations noLRtest ///
		  noGRoup noHEADer noFETable noRETable ESTMetric grouponly ///
		  DFTABle DFTABle1(string) SMALL * ]

	local MIXED_NOSTDERR_LINK "{mansection ME meRemarksandexamplesDiagnosingconvergenceproblems:failed}"

	//-small- is synonymous to -dftable-
	if (`"`dftable'`dftable1'"'=="" & "`small'"!="") local dftable dftable

	if "`variance'"!="" & "`stddeviations'"!="" {
	    di as err "variance and stddeviations may not be specified together"
	    exit 198
	}
	local var_opt `variance' `stddeviations'
	if "`var_opt'"=="" {
		if `is_me' local variance variance
		else local variance
	}
	local stddeviations

	_get_diopts diopts, `options'
	ParseForCformat `"`diopts'"'

	if `"`dftable'"'!= "" & `"`dftable1'"'!="" {
		di as err "{p 0 4 2}option {bf:dftable} may not be " ///
			"combined with option {bf:dftable()}{p_end}"
		exit 198
	}
	
	if `"`dftable'"' != "" local dftable "default"
	else local dftable `dftable1'

	// check dfmethod() option with other options
	if (`"`dftable'"'!="") {
		if `"`dftable1'"'!="" local dfmesg "dftable()"
		else if ("`small'"!="") local dfmesg "small"
		else local dfmesg "dftable"

		if ("`e(dfmethod)'" == "") {
			di as err "{p}option {bf:`dfmesg'}"
			di as err "requires that option {bf:dfmethod()}"
			di as err "is specified with"
                        di as err "{bf:mixed} during estimation{p_end}"
			exit 198
		}
		if `"`fetable'"'!= "" {
			di as err "{p}option {bf:nofetable} may " ///
				"not be combined with option " ///
				"{bf:`dfmesg'}{p_end}"
			exit 198
		}

		CheckDftable, ///
			dftable(`dftable') diopts(`diopts') dfmesg(`dfmesg')
		local dfdisp `r(dfdisp)'
		local df "df"	
	}

	// Leaves cformat() in local macro cf 
	
	local k = ("`fetable'"!="") + ("`retable'"!="") + ("`var_opt'"!="")
	if `k' {
		if "`estmetric'" != "" {
di as err "{p 0 4 4}option estmetric not allowed with options nofetable, noretable, and `var_opt'{p_end}"
			exit 198
		}
	}
	if "`header'" == "" {
		DiHeader, `group' `grouponly' `mi' `df'
		if "`grouponly'" != "" {
			exit
		}
	}
	if "`estmetric'" != "" {
		di
		_coef_table, level(`level') `diopts'
		if "`df'" != "" {
			di as txt "{p 0 6 4}Note: Large-sample z-" ///
				"statistics are reported when results are" ///
				" displayed in the estimation metric.{p_end}"
		}	
		exit
	}
	if "`fetable'" == "" & e(k_f) > 0 {
		DiEstTable, level(`level') `diopts' `dfdisp' 
		tempname rhold
		_return hold `rhold'
	}
	if "`retable'" == "" {
		DiVarComp, level(`level') `variance' `lrtest' cformat(`cf') `mi'
		local note `r(note)'
	}
	if !`e(converged)' {
		if "`note'" == "" {
			di
		}
		if "`e(emonly)'" != "" {
			di as txt "{p 0 6 4}Note: EM algorithm failed to " ///
			 "converge{p_end}"
		}
		else {
			di as txt "{p 0 9 4}Warning: convergence not " ///
			 "achieved{p_end}"
			 //; estimates are based on iterated EM{p_end}" 
		}
	}
	if "`e(emonly)'" == "" {
		if !missing(e(se_failed)) & e(se_failed) {
			di as txt "{p 0 9 4}Warning: standard-error " ///
			 "calculation `MIXED_NOSTDERR_LINK'{p_end}"
		}
	}
	if "`rhold'" != "" {
		_return restore `rhold'
	}
end

program DiHeader
	syntax [, noGRoup grouponly mi df ]
	if "`grouponly'" != "" {
		if "`e(ivars)'" == "" {
			di as err "{p 0 4 2}model is linear regression; "
			di as err "no group information available{p_end}"
			exit 459
		}
		DiGroupTable, table `mi'
		exit
	}
	di
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
                */ bsubstr(`"`e(crittype)'"',2,.)
	
	di as txt "`e(title)'" _c
	di _col(49) as txt "Number of obs" _col(67) "=" _col(69) as res ///
		%10.0fc e(N)

	if "`group'" == "" {
 		DiGroupTable, `mi'
	}
	if ("`df'"!="") {
		DiDfTable
		di
		if (`e(ddf_m)' != .) {
			di _col(49) as txt "F(" as res e(df_m) as txt "," ///
				as res %9.2f e(ddf_m) as txt ")" ///
               			_col(67) "=" _col(70) as res %9.2f e(F)
			di as txt "`crtype'" " = " as res %10.0g e(ll) /*
                	*/ _col(49) as txt "Prob > F" _col(67) "=" _col(73) /*
                	*/ as res %6.4f Ftail(e(df_m),e(ddf_m), e(F))
		}
		else {
			di _col(49) as txt ///
				"{help j_mixed_ddf##|_new:F(`e(df_m)', }" ///
   	   			_col(59) as txt ///
				"{help j_mixed_ddf##|_new:.  )}" ///
		 		_col(67) "=" _col(73) as txt ///
				"{help j_mixed_ddf##|_new:.  }" 
			di as txt "`crtype'" " = " as res %10.0g e(ll) /*
                	*/ _col(49) as txt "Prob > F" _col(67) "=" _col(73) /*
                	*/ as txt "{help j_mixed_ddf##|_new:.  }" 
		}
	}
	else {
		di
        	di _col(49) as txt "`e(chi2type)' chi2(" as res e(df_m) ///
			as txt ")" _col(67) "=" _col(70) as res %9.2f e(chi2)
		di as txt "`crtype'" " = " as res %10.0g e(ll) /*
                */ _col(49) as txt "Prob > chi2" _col(67) "=" _col(73) /*
                */ as res %6.4f chiprob(e(df_m), e(chi2))
	}
end

program DiGroupTable
	syntax [, table mi ]
	local ivars `e(ivars)'
	local levels : list uniq ivars
	tempname Ng min avg max
	if ("`e(cmd)'"=="mi estimate" | "`mi'"!="") {
		local sfx _mi
	}
	mat `Ng' = e(N_g`sfx')
	mat `min' = e(g_min`sfx')
	mat `avg' = e(g_avg`sfx')
	mat `max' = e(g_max`sfx')
	local w : word count `levels'
	if `w' == 0 {
		exit
	}
	if `w' == 1 & "`table'" == "" {
		di as txt "Group variable: " as res abbrev("`levels'",14) ///
		     _col(49) as txt "Number of groups" _col(67) "=" ///
		     _col(69) as res %10.0fc `Ng'[1,1] _n
		di as txt _col(49) "Obs per group:"
		di as txt _col(63) "min" _col(67) "=" ///
		     _col(69) as res %10.0fc `min'[1,1]
		di as txt _col(63) "avg" _col(67) "=" ///
		     _col(69) as res %10.1fc `avg'[1,1]
		di as txt _col(63) "max" _col(67) "=" ///
		     _col(69) as res %10.0fc `max'[1,1]
	}
	//         1         2         3         4         5         6
	//123456789012345678901234567890123456789012345678901234567890
	//                    No. of       Observations per Group
	// Group Variable |   Groups    Minimum    Average    Maximum
	//        level1  | ########  #########  #########  #########
	else {
		di
		di as txt "{hline 16}{c TT}{hline 44}
		di as txt _col(17) "{c |}" _col(23) "No. of" ///
	          _col(36) "Observations per Group"
		di as txt _col(2) "Group Variable" _col(17) "{c |}" ///
		  _col(23) "Groups" _col(33) "Minimum" ///
		  _col(44) "Average" _col(55) "Maximum" 
		di as txt "{hline 16}{c +}{hline 44}"
		local i 1
		foreach k of local levels {
			local lev = abbrev("`k'",12)
			local p = 16 - length("`lev'")
			di as res _col(`p') "`lev'" /// 
			  as txt _col(17) "{c |}" ///
			  as res _col(21) %8.0fc `Ng'[1,`i'] ///
                          _col(31) %9.0fc `min'[1,`i'] ///
                          _col(42) %9.1fc `avg'[1,`i'] ///
                          _col(53) %9.0fc `max'[1,`i'] 
			local ++i	
		}
		di as txt "{hline 16}{c BT}{hline 44}" 
	}
end

program DiDfTable
	di as txt "DF method: " as txt e(dftitle) ///
		     _col(49) as txt "DF:" _col(63) as txt "min" ///
		     _col(67) "=" _col(69) as res %10.2fc e(df_min)
	di _col(63) as txt "avg" _col(67) "=" _col(69) as res %10.2fc e(df_avg)
	di _col(63) as txt "max" _col(67) "=" _col(69) as res %10.2fc e(df_max)
end

program DiEstTable, eclass
	syntax [, level(cilevel) DFCI DFPValue DFDEFault *]

	local dfdisp `"`dfci'`dfpvalue'`dfdefault'"'	
	di
	if ("`dfdisp'"!="") {
		if ("`e(dfmethod)'"== "kroger") {
		_coef_table, vmat(e(V_df)) dfmatrix(e(df)) cmdextras ///
				first level(`level') `options' `dfci' `dfpvalue'
		}
		else {
		_coef_table, vmat(e(V)) dfmatrix(e(df)) cmdextras ///
				first level(`level') `options' `dfci' `dfpvalue'
		}
	}
	else {
		_coef_table, first level(`level') `options'
	}
end

program DiLRTest, rclass

	// We have already established that e(chi2_c) exists
	if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e5)) | (e(chi2_c)==0) {
  		local fmt "%8.2f"
        }
        else    local fmt "%8.2e"

	local allempty 1
	foreach d in `e(redim)' {
		if `d' {
			local allempty 0
		}
	}

	local msg "LR test vs. linear model:"

	local k1 = strlen("`msg'") + 2
	local chi : di `fmt' e(chi2_c)
	local chi = trim("`chi'")
	local sub = strlen("`chi'")

	di as txt "`msg'" _c
	if `e(df_c)' == 1 & `e(k_rs)' == 2 & !`allempty' {	// chibar2(01)
		di as txt _col(`k1') "{help j_chibar##|_new:chibar2(01) =} " ///
                   as res "`chi'" ///
		   _col(55) as txt "Prob >= chibar2 = " ///
		   _col(73) as res %6.4f e(p_c)
	}		
	else {
		di as txt _col(`k1') "chi2(" as res e(df_c) ///
		   as txt ") = " as res "`chi'" ///
		   _col(59) as txt "Prob > chi2 =" ///
		   _col(73) as res %6.4f e(p_c)
		if `e(k_rs)' > 1 {
			return local conserve conserve
		}
		if `allempty' {
			return local conserve
			return local undetermined undetermined
		}
	}
end

program DiVarComp, rclass
	syntax [, level(cilevel) VARiance noLRtest cformat(string) mi]

	if ("`e(cmd)'"=="mi estimate" | "`mi'"!="") {
		local bmatrix e(b_mi)
	}
	else {
		local bmatrix e(b)
	}
	local depvar `e(depvar)'
	if strpos("`depvar'",".") {
		gettoken ts rest : depvar, parse(".")
		gettoken dot depvar : rest, parse(".")
	}
	
	local dimx `e(k_f)'

	// display header 

	di
	di as txt "{hline 29}{c TT}{hline 48}
	if "`e(vcetype)'" == "Bootstrap" || ///
	   "`e(vcetype)'" == "Bstrap *" {
		local obs "Observed"
		local citype "Normal-based"
	}
	if "`e(mi)'"=="" &		       ///
	   (`"`e(vcetype)'"' == "Bootstrap" || ///
	   `"`e(vcetype)'"' == "Bstrap *"  ||  ///
	   `"`e(vcetype)'"' == "Jackknife" ||  ///
	   `"`e(vcetype)'"' == "Jknife *"  ||  ///
	   `"`e(vcetype)'"' == "Robust") {
		local vcetype `e(vcetype)'
		if `"`e(mse)'"' != "" {
			capture which `e(vce)'_`e(mse)'.sthlp
			local mycrc = c(rc)
			if `mycrc' {
				capture which `e(vce)'_`e(mse)'.hlp
				local mycrc = c(rc)
			}
			if !`mycrc' {
				local vcetype ///
				"{help `e(vce)'_`e(mse)'##|_new:`vcetype'}"
                        }
		}
		local c1 = cond(`"`vcetype'"' == "Robust", 46, 45)
		di as txt _col(30) "{c |}" _col(34) `"`obs'"' ///
			  _col(`c1') `"`vcetype'"' ///
			  _col(63) `"`citype'"'
	}
	local k = length("`level'")
	di as txt _col(3) "Random-effects Parameters" _col(30) "{c |}" ///
		_col(34) "Estimate" _col(45) "Std. Err." _col(`=61-`k'') ///
		`"[`=strsubdp("`level'")'% Conf. Interval]"'
	di as txt "{hline 29}{c +}{hline 48}

	local zvars `e(revars)'
	local dimz `e(redim)'

	// loop over levels

	local foot = 1
	local pos `dimx'
	local levs : word count `e(ivars)'
	forvalues k = 1/`levs' {
		local lev : word `k' of `e(ivars)'
		local vartype : word `k' of `e(vartypes)'

		GetNames "`vartype'" "`zvars'" "`dimz'" `foot'
		local zvars `s(zvars)'     // collapsed lists
		local dimz `s(dimz)'
		local names `"`s(names)'"'
		if `"`s(footnote)'"' != "" {
			local footnotes `"`footnotes' `s(footnote)'"'
			local ++foot
		}
		if `"`names'"' != `""()""' {
			di as res abbrev("`lev'",12) as txt ": `vartype'" ///
				_col(30) "{c |}"

			local nbeta : word count `names'
			DiParms `pos' `nbeta' `"`names'"' "`level'" 	///
					"`variance'" "`bmatrix'" "`cformat'"
			local pos = `pos' + `nbeta'
		}
		else {		// empty
			di as res abbrev("`lev'",12) as txt ":" ///
				_col(22) "(empty)" _col(30) "{c |}"
		}
		di as txt "{hline 29}{c +}{hline 48}
	}

	// Residual Variance 
	
	DiResidual, `variance' level(`level') cformat(`cformat')

	// Footnotes
	if "`e(chi2_c)'" != "" & "`lrtest'" == "" {
		DiLRTest
		local conserve `r(conserve)'
		local undetermined `r(undetermined)'
	}
	
	forvalues k = 1/`=`foot'-1' {
		local note: word `k' of `footnotes'
		local indent = 3 + length("`k'")
		di as txt `"{p 0 `indent' 4} `note'{p_end}"'
	}
	if "`conserve'" != "" {
		di as txt _n "{p 0 6 4}Note: {help j_mixedlr##|_new:LR test is conservative} and provided only for reference.{p_end}"
		return local note note
	}
	if "`undetermined'" != "" {
		di as txt _n "{p 0 6 2}Note: The reported degrees of freedom "
		di as txt "assumes the null hypothesis is not on the "
		di as txt "boundary of the parameter space.  If this is not "
		di as txt "true, then the reported test is "
		di as txt "{help j_mixedlr##|_new:conservative}.{p_end}"
	}
	if "`e(eim)'"== "0" {
		di as txt _n "{p 0 6 2}Note: The observed information matrix"
		di as txt "is used to compute `e(dftitle)' degrees of "
		di as txt "freedom.{p_end}"
	}
	if "`e(pw_warn)'" != "" {
		di as txt _n "{p 0 9 2}Warning: Sampling weights were "
		di as txt "specified only at the first level "
		di as txt "in a multilevel model. If these weights are "
		di as txt "indicative of overall and not conditional "
		di as txt "inclusion probabilities, then "
		di as txt "{help mixed##sampling:results may be biased}."
		di as txt "{p_end}"
	}
end

program DiResidual
	syntax , level(cilevel) cformat(string) [variance]

	DiResidualHeader

	DiRes`=proper("`e(rstructure)'")', `variance' level(`level') ///
					   cformat(`cformat')

	di as txt "{hline 29}{c BT}{hline 48}
end

program DiResidualHeader
	if `e(nrgroups)' > 1 {
		local comma ,
	}
	if "`e(rstructure)'" != "independent" | `e(nrgroups)' > 1 {
		di as txt "Residual: `e(rstructlab)'`comma'" _col(30) "{c |}" 
	}
	if `e(nrgroups)' > 1 {
		di as txt "    by " as res abbrev("`e(rbyvar)'", 21) ///
			as txt _col(30) "{c |}"
	}
end

program DiResIndependent
	syntax , level(cilevel) cformat(string) [variance]
	local type = cond("`variance'" == "", "sd", "var")
	if `e(nrgroups)' == 1 {
		DiLogRatioE "" `type' "`type'(Residual)", level(`level') ///
			cformat(`cformat')
	}
	else {
		forval i = 1/`e(nrgroups)' {
			local w : word `i' of `e(rglabels)'
			local w = abbrev(`"`w'"', cond("`type'"=="sd", 21, 20))
			local label `"`w': `type'(e)"'
			local eq = cond(`i'==1, "", "r_lns`i'ose")
			DiLogRatioE "`eq'" `type' `"`label'"',  ///
				 level(`level') cformat(`cformat')
		}
	}
end

program DiResAr
	syntax , level(cilevel) cformat(string) [variance]
	local type = cond("`variance'" == "", "sd", "var")
	local needglab = `e(nrgroups)' > 1
	if `needglab' {
		local maxl = max(length("phi`e(ar_p)'"), length("`type'(e)"))
	}
	forval j = 1 / `e(nrgroups)' {
		if `needglab' {
			local lab : word `j' of `e(rglabels)'
			local lab = abbrev("`lab'", `=26-`maxl'')
			local pos = 27 - length("`lab'") - `maxl'
			di as txt _col(`pos') "`lab':" _c
		}
		if `e(ar_p)' == 1 {
			qui _diparm r_atr`j', tanh level(`level') notab
			DiVarCompEst "rho" "`cformat'" `needglab'
		}
		else {
			forval i = 1 / `e(ar_p)' {
				qui _diparm r_phi`j'_`i', level(`level') notab
				DiVarCompEst "phi`i'" "`cformat'" `needglab'
			}
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		DiLogRatioE "`eq'" `type' "`type'(e)", level(`level') ///
				cformat(`cformat')
		if `j' < `e(nrgroups)' {
			di as txt _col(30) "{c |}"
		}
	}
end

program DiResMa
	syntax , level(cilevel) cformat(string) [variance]
	local type = cond("`variance'" == "", "sd", "var")
	local needglab = `e(nrgroups)' > 1
	if `needglab' {
		local maxl = max(length("theta`e(ma_q)'"), length("`type'(e)"))
	}
	forval j = 1 / `e(nrgroups)' {
		if `needglab' {
			local lab : word `j' of `e(rglabels)'
			local lab = abbrev("`lab'", `=26-`maxl'')
			local pos = 27 - length("`lab'") - `maxl'
			di as txt _col(`pos') "`lab':" _c
		}
		if `e(ma_q)' == 1 {
			qui _diparm r_att`j', tanh level(`level') notab
			DiVarCompEst "theta1" "`cformat'" `needglab'
		}
		else {
			forval i = 1 / `e(ma_q)' {
				qui _diparm r_theta`j'_`i', level(`level') notab
				DiVarCompEst "theta`i'" "`cformat'" `needglab'
			}
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		DiLogRatioE "`eq'" `type' "`type'(e)", level(`level') ///
				cformat(`cformat')
		if `j' < `e(nrgroups)' {
			di as txt _col(30) "{c |}"
		}
	}
end

program DiResBanded
	syntax, level(cilevel) cformat(string) [variance]

	DiResUnstructured, level(`level') `variance' banded cformat(`cformat')
end

program DiResUnstructured
	syntax , level(cilevel) cformat(string) [variance banded]
	local type = cond("`variance'" == "", "sd", "var")
	local ctype = cond("`variance'" == "", "corr", "cov")
	if "`banded'" != "" {
		local order `e(res_order)'
	}
	else {
		local order 0
	}
	
	tempname tmap
	mat `tmap' = e(tmap)
	local nt = colsof(`tmap')
	local needglab = `e(nrgroups)' > 1
	if `needglab' {
		local maxT  : di `tmap'[1,`nt']
		local maxT1 : di `tmap'[1,`=`nt'-1']
		local maxl = length("`ctype'(e`maxT1',e`maxT')")
	}
	forval j = 1 / `e(nrgroups)' {
		if `needglab' {
			local lab : word `j' of `e(rglabels)'
			local lab = abbrev("`lab'", `=26-`maxl'')
			local pos = 27 - length("`lab'") - `maxl'
			di as txt _col(`pos') "`lab':" _c
		}
		forval i = 1/`nt' {
			local elab : di "e"`tmap'[1,`i']
			local eq r_lns`j'_`i'ose
			if (`i'==1) & (`j'==1) {
				local eq 
			}
			DiLogRatioE "`eq'" `type' "`type'(`elab')" ///
				"`needglab'" , level(`level') cformat(`cformat')
		}
		forval i = 1/`nt' {
			forval k = `=`i'+1'/`nt' {
				if (`k' > `i'+`order') & "`banded'"!="" {
					continue, break
				}
				local e1 : di "e"`tmap'[1,`i']
				local e2 : di "e"`tmap'[1,`k']
				if "`ctype'" == "corr" {
					qui _diparm r_atr`j'_`i'_`k', /// 
					       tanh level(`level') notab
				}
				else {
					qui DiparmCovarianceUn `j' `i' ///
						`k' , level(`level') 
				}
				DiVarCompEst "`ctype'(`e1',`e2')" ///
						"`cformat'" `needglab'
			}
		}
		if `j' < `e(nrgroups)' {
			di as txt _col(30) "{c |}"
		}
	}
end

program DiResExchangeable
	syntax , cformat(string) level(cilevel) [variance]
	local type = cond("`variance'" == "", "sd", "var")
	local ctype = cond("`variance'" == "", "corr", "cov")
	local needglab = `e(nrgroups)' > 1
	if `needglab' {
		local maxl = max(length("`ctype'(e)"), length("`type'(e)"))
	}
	forval j = 1 / `e(nrgroups)' {
		if `needglab' {
			local lab : word `j' of `e(rglabels)'
			local lab = abbrev("`lab'", `=26-`maxl'')
			local pos = 27 - length("`lab'") - `maxl'
			di as txt _col(`pos') "`lab':" _c
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		DiLogRatioE "`eq'" `type' "`type'(e)", level(`level') ///
			cformat(`cformat')
		if "`ctype'" == "corr" {
			qui _diparm r_atr`j', tanh level(`level') notab
		}
		else {
			DiparmCovarianceEx r_atr `j' , level(`level')
		}
		DiVarCompEst "`ctype'(e)" "`cformat'" `needglab'
		if `j' < `e(nrgroups)' {
			di as txt _col(30) "{c |}"
		}
	}
end

program DiResToeplitz
	syntax , cformat(string) level(cilevel) [variance]
	local type = cond("`variance'" == "", "sd", "var")
	local ctype = cond("`variance'" == "", "corr", "cov")
	local needglab = `e(nrgroups)' > 1
	if `needglab' {
		local maxl = max(length("`ctype'(e)"), length("`type'(e)"))
	}
	forval j = 1 / `e(nrgroups)' {
		if `needglab' {
			local lab : word `j' of `e(rglabels)'
			local lab = abbrev("`lab'", `=26-`maxl'')
			local pos = 27 - length("`lab'") - `maxl'
			di as txt _col(`pos') "`lab':" _c
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		forval k = 1 / `e(res_order)' {
			if "`ctype'" == "corr" {
				qui _diparm r_atr`j'_`k', /// 
				    tanh level(`level') notab
			}
			else {
				DiparmCovarianceToep r_atr `j' `k' /// 
				, level(`level') 
			}
			if "`ctype'" == "corr" {
				DiVarCompEst "rho`k'" "`cformat'" `needglab'
			}
			else {
				DiVarCompEst "cov`k'" "`cformat'" `needglab'
			}
		}
		DiLogRatioE "`eq'" `type' "`type'(e)", level(`level')  ///
			cformat(`cformat')
		if `j' < `e(nrgroups)' {
			di as txt _col(30) "{c |}"
		}
	}
end

program DiResExponential
	syntax , cformat(string) level(cilevel) [variance]
	local type = cond("`variance'" == "", "sd", "var")
	local ctype = cond("`variance'" == "", "corr", "cov")
	local needglab = `e(nrgroups)' > 1
	if `needglab' {
		local maxl = max(length("`ctype'(e)"), length("`type'(e)"))
	}
	forval j = 1 / `e(nrgroups)' {
		if `needglab' {
			local lab : word `j' of `e(rglabels)'
			local lab = abbrev("`lab'", `=26-`maxl'')
			local pos = 27 - length("`lab'") - `maxl'
			di as txt _col(`pos') "`lab':" _c
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		qui _diparm r_logitr`j', invlogit level(`level') notab
		DiVarCompEst "rho" "`cformat'" `needglab'
		DiLogRatioE "`eq'" `type' "`type'(e)", level(`level') ///
			cformat(`cformat')
		if `j' < `e(nrgroups)' {
			di as txt _col(30) "{c |}"
		}
	}
end

program DiparmCovarianceUn
	args gr i j  
	syntax anything, level(cilevel) 
	if (`gr'==1) & (`i'==1) {
		local fun exp(2*@2+@3)
		qui _diparm r_atr1_1_`j' lnsig_e r_lns1_`j'ose,  ///
			level(`level') notab 			 ///
		        function(tanh(@1)*`fun')                 ///
		        deriv((1-tanh(@1)^2)*`fun'               ///
			      2*tanh(@1)*`fun'                   ///
			      tanh(@1)*`fun')
	}
	else {
		local fun exp(2*@2+@3+@4)
		qui _diparm r_atr`gr'_`i'_`j' lnsig_e 		 ///
		            r_lns`gr'_`i'ose r_lns`gr'_`j'ose,   /// 
			    level(`level') notab		 ///
			    function(tanh(@1)*`fun') 	  	 ///
			    deriv((1-tanh(@1)^2)*`fun' 	         ///
				  2*tanh(@1)*`fun'         	 ///
				  tanh(@1)*`fun'		 ///
				  tanh(@1)*`fun')
	}
end

program DiparmCovarianceToep
	args stub j k
	syntax anything, level(cilevel)
	if (`j'==1) {
		qui _diparm `stub'1_`k' lnsig_e, level(`level') notab ///
		        function(tanh(@1)*exp(2*@2))                  ///
		        deriv((1-tanh(@1)^2)*exp(2*@2)                ///
			      2*tanh(@1)*exp(2*@2))
	}
	else {
		local fun exp(2*(@2+@3))
		qui _diparm `stub'`j'_`k' r_lns`j'ose lnsig_e,    /// 
			   level(`level') 			  ///
			   notab function(tanh(@1)*`fun') 	  ///
			         deriv((1-tanh(@1)^2)*`fun' 	  ///
				       (2*tanh(@1)*`fun')         ///
				       (2*tanh(@1)*`fun'))
	}
end

program DiparmCovarianceEx
	args stub j
	syntax anything, level(cilevel)
	if (`j'==1) {
		qui _diparm `stub'1 lnsig_e, level(`level') notab ///
		        function(tanh(@1)*exp(2*@2))              ///
		        deriv((1-tanh(@1)^2)*exp(2*@2)            ///
			      2*tanh(@1)*exp(2*@2))
	}
	else {
		local fun exp(2*(@2+@3))
		qui _diparm `stub'`j' r_lns`j'ose lnsig_e, level(`level') ///
			   notab function(tanh(@1)*`fun') 	  ///
			         deriv((1-tanh(@1)^2)*`fun' 	  ///
				       (2*tanh(@1)*`fun')         ///
				       (2*tanh(@1)*`fun'))
	}
end

program DiLogRatioE
	args eq type label needglab
	syntax anything, level(cilevel) cformat(string)
	local c = cond("`type'"=="sd", 1, 2)
	if "`eq'" == "" {
		qui _diparm lnsig_e, function(exp(`c'*@)) /// 
				     deriv(`c'*exp(`c'*@)) notab level(`level') 
	}
	else {
		qui _diparm lnsig_e `eq', ///
					 function(exp(`c'*@1+`c'*@2)) ///
				         deriv(`c'*exp(`c'*@1+`c'*@2) ///
				         `c'*exp(`c'*@1+`c'*@2))      ///
					 notab level(`level') ci(log)
	}
	DiVarCompEst `"`label'"' "`cformat'" `needglab'
end

program DiVarCompEst
	// to be executed immediately after qui _diparm, notab
	args label cf needglab
	local k = length("`label'")
	local p = 29 - `k'
	local rest : display `cf' r(est)
	local rse  : display `cf' r(se)
	local lrest = length("`rest'")
	local lrse  = length("`rse'")
	if strpos(`"`label'"', "R.") ///
	 | strpos(`"`label'"', " ") ///
	 | strpos(`"`label'"', ")(") ///
	 | strpos(`"`label'"', "..") ///
	 | "`needglab'" != "" {
		di as txt _col(`p') "`label'" _col(30) "{c |}" _c
	}
	else {
		tempname hold x
		_return hold `hold'
		matrix `x' = 0
		matrix colname `x' = "`label'"
		_ms_display, matrix(`x') width(28) el(1) fnspace
		_return restore `hold'
	}
	if ("`r(lb)'"==".b" | "`r(ub)'"==".b") {
		di as txt ///
			as res _col(`=33+9-`lrest'') `cf' r(est) ///
			as res _col(`=44+9-`lrse'')  `cf' r(se)
		exit 
	}
	local rcil : display `cf' cond(missing(r(se)),.,r(lb))
	local rciu : display `cf' cond(missing(r(se)),.,r(ub))
	local lrcil = length("`rcil'")
	local lrciu = length("`rciu'")
	di as txt ///
   		as res _col(`=33+9-`lrest'') `cf' r(est) ///
   		as res _col(`=44+9-`lrse'')  `cf' r(se)  ///
   		as res _col(`=58+9-`lrcil'') `cf' /// 
		cond(missing(r(se)),.,r(lb))  ///
   		as res _col(`=70+9-`lrciu'') `cf' cond(missing(r(se)),.,r(ub))
end

program DiParms
	args pos nb names cilev var bmatrix cformat

	local stripes : coleq `bmatrix', quoted
	forvalues k = 1/`nb' {
		local label : word `k' of `names'	
		local eq : word `=`pos'+`k'' of `stripes'
		GetParmEqType `eq' `var'
		local parm `s(parm)'
		local label `"`s(type)'`label'"'	
		local diparmeq `"`s(diparmeq)'"'

		local p = 29 - length("`label'")
		qui _diparm `diparmeq', `parm' level(`cilev') notab
		DiVarCompEst "`label'" "`cformat'"
	}
end

program GetNames, sclass
	args type zvars dimz foot

	gettoken dim dimz : dimz
	forvalues k = 1/`dim' {
		gettoken tok1 zvars : zvars
		local fullvarnames `fullvarnames' `tok1'
		local len = length("`tok1'")
		if bsubstr("`tok1'",1,2) == "R." {
			local w = bsubstr("`tok1'",3,`len') 
			local tok1 = "R." + abbrev("`w'",8)
		}
		else {
			local tok1 = abbrev("`tok1'",8)
		}
		local varnames `varnames' `tok1'
	}
	if ("`type'" == "Unstructured") {
		forvalues j = 1/`dim' {
			local w : word `j' of `fullvarnames'
			local names `"`names' "(`w')""'
		}
		forvalues j = 1/`dim' {
			forvalues k = `=`j'+1'/`dim' {
				local w1 : word `j' of `fullvarnames'
				local w2 : word `k' of `fullvarnames'
				local names `"`names' "(`w1',`w2')""'	
			}
		}
	}
	else if ("`type'" == "Independent") {    
		forvalues j = 1/`dim' {
			local w : word `j' of `fullvarnames'
			local names `"`names' "(`w')""'
		}
	}
	else {    // Identity or Exchangeable
		local ex = ("`type'" == "Exchangeable")
		if (`dim' == 1) {		// check for factor variable
			local w `fullvarnames'
			local names `""(`w')""'
			if `ex' {
				local names `"`names' "(`w')""'
			}
		}
		else if (`dim' == 2) {
			local w1 : word 1 of `fullvarnames'
			local w2 : word 2 of `fullvarnames'
			local names `""(`w1' `w2')""'
			if `ex' {
local names `"`names' "(`w1',`w2')""'
			}
		}
		else {
			local k : length local varnames
			if `k' > 20 {		// too long
				local w1 : word 1 of `varnames'	
				local w2 : word `dim' of `varnames'
				local names `""(`w1'..`w2')(`foot')""'
				if `ex' {
local names `"`names' "(`w1'..`w2')(`foot')""'
				}
				local footnote `""(`foot') `fullvarnames'""'
			}
			else {
				local names `""(`varnames')""'
				if `ex' {
local names `"`names' "(`varnames')""'
				}
			}
		}
	}

	sreturn local zvars "`zvars'"
	sreturn local dimz "`dimz'"
	sreturn local names `"`names'"'
	sreturn local footnote `"`footnote'"'
end

program GetParmEqType, sclass
	args eq var
	
	if bsubstr("`eq'",1,1) == "l" {	  // log standard deviation
		if "`var'" == "" {	  // se/corr metric
			local parm exp
			local type sd
		}			
		else {			  // var/cov metric
			local parm f(exp(2*@)) d(2*exp(2*@))
			local type var
		}
		local deq `eq'
	}
	else { // substr("`eq'",1,1) == "a"  atanh correlation
		if "`var'" == "" {        // se/corr metric
			local parm tanh
			local type corr
			local deq `eq'
		}
		else {			  // var/cov metric
			ParseEq `eq'
			local eq2 lns`r(n1)'_`r(n2)'_`r(n3)'
			local eq3 lns`r(n1)'_`r(n2)'_`r(n4)'
			local deq `eq' `eq2' `eq3'	
			local parm f(tanh(@1)*exp(@2+@3))
			local parm `parm' d((1-(tanh(@1)^2))*exp(@2+@3)
			local parm `parm' tanh(@1)*exp(@2+@3)
			local parm `parm' tanh(@1)*exp(@2+@3)) 
			local type cov
		}
	}

	sreturn local parm `"`parm'"'
	sreturn local type `"`type'"'
	sreturn local diparmeq `"`deq'"'
end

program ParseEq, rclass
	args eq

	// I've got "eq" == "atr#_#_#_#", and I need the four #'s
	// returned as r(n1), r(n2), r(n3), and r(n4)

	local len = length("`eq'")
	local eq = bsubstr("`eq'",4,`len')
	forvalues k = 1/4 {
		gettoken n`k' eq : eq, parse(" _")
		return local n`k' `n`k''
		gettoken unscore eq : eq, parse(" _")
	}
end

program ParseForCformat
	args diopts
	local 0 , `diopts'
	syntax [, cformat(string) *]
	
	if `"`cformat'"' == "" {
		local cformat `c(cformat)'
	}
	if `"`cformat'"' == "" {
		local cformat %9.0g
	}
	c_local cf `cformat'
end

program CheckDftable, rclass

	syntax [, dftable(string) diopts(string) dfmesg(string) ]

	local 0, `dftable'

	syntax [, DEFault CI PValue * ]
 
	if `"`options'"' != "" {
		di as err "{p}{bf:`options'} not available in option {bf:dftable()}{p_end}"
		exit 198
	}

	opts_exclusive "`default' `ci' `pvalue'" dftable

	local 0, `diopts'
	syntax [, COEFLegend SELEGEND NOCI NOPValues * ]

	if `"`coeflegend'"'!= "" {
		di as err "{p}option {bf:coeflegend} may not be combined " ///
			"with option {bf:`dfmesg'}{p_end}"
		exit 198
	} 
	if `"`selegend'"'!= "" {
		di as err "{p}option {bf:selegend} may not be combined " ///
			"with option {bf:`dfmesg'}{p_end}"
		exit 198
	}
	if `"`noci'"'!= "" & `"`nopvalues'"'!= "" {
		di as err "{p}only one of {bf:noci} or {bf:nopvalues}" ///
			" is allowed{p_end}"
		exit 198
	}
	if `"`ci'"'!= "" & `"`noci'`nopvalues'"'!="" {
		di as err "{p}only one of {bf:dftable(ci)} or "	///
			"{bf:`noci'`nopvalues'} is allowed{p_end}"
		exit 198
	}
	if `"`pvalue'"'!= "" & `"`noci'`nopvalues'"'!="" {
		di as err "{p}only one of {bf:dftable(pvalue)} or "	///
			"{bf:`noci'`nopvalues'} is allowed{p_end}"
		exit 198
	}

	if `"`pvalue'"' != "" return local dfdisp "dfpvalue"
	else if `"`ci'"' != "" return local dfdisp "dfci"
	else return local dfdisp "dfdefault" 
end

