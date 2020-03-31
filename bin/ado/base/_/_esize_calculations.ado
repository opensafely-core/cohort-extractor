*! version 1.1.1  28nov2017

// CALCULATIONS, OUTPUT AND RETURN FOR esize AND esizei
// ============================================================
program define _esize_calculations, rclass
	version 13
	#del ; 
	syntax [if] [in] [,
		IMmediate
		Level(cilevel)
		BY(varlist)
		UNEqual 
		Welch 
		COHensd 
		HEDgesg 
		GLAssdelta 
		PBCorr 
		ALL] ;
	#del cr
	
	tempname touse
	marksample `touse'
	
	
	tempname t F alpha AlphaLower AlphaUpper 
	tempname N n1 n2 ns mean1 mean2 sd1 sd2 sd_within df_within 
	tempname se_multiplier m BiasCorrectionFactor
	tempname LowerLambda UpperLambda
	tempname CohensD CohensD_se CohensD_Lower CohensD_Upper
	tempname HedgesG HedgesG_Lower HedgesG_Upper
	tempname GlassDelta1 GlassDelta1_se GlassDelta1_L GlassDelta1_U 
	tempname GlassDelta2 GlassDelta2_se GlassDelta2_L GlassDelta2_U
	tempname r_pb r_pb_Lower r_pb_Upper
	
	// ttest or ttesti MUST IMMEDIATELY PRECEDE _esize_calculations
	//	SO THAT THE RETURN VALUES ARE AVAILABLE HERE
	scalar `alpha' = 1-(`level'/100)
	scalar `AlphaLower' = `alpha'/2
	scalar `AlphaUpper' = 1 - (`alpha'/2)
	scalar `t' = r(t)
	scalar `F' = `t'^2
	scalar `n1' = r(N_1)
	scalar `n2' = r(N_2)
	scalar `N' = `n1' + `n2'
	scalar `mean1' = r(mu_1)
	scalar `mean2' = r(mu_2)
	scalar `sd1' = r(sd_1)
	scalar `sd2' = r(sd_2)
	scalar `df_within' = r(df_t)
	scalar  `se_multiplier' = invttail(`df_within',`alpha'/2)
	scalar `ns' = sqrt((`n1'*`n2')/(`n1'+`n2'))
	

	// CALCULATE COHEN'S D
	// ==============================================================
	// Hedges (1981) pg 110, Eq 4; Turner & Bernard (2006), Equation 4
	scalar `sd_within' = sqrt(((`n1'-1)*(`sd1'^2) + 	///
		(`n2'-1)*(`sd2'^2)) / (`n1'+`n2'-2))
	scalar `CohensD' = (`mean1' - `mean2') / `sd_within'
	scalar `LowerLambda' = npnt(`df_within',`CohensD'*`ns',`AlphaUpper')
	scalar `UpperLambda' = npnt(`df_within',`CohensD'*`ns',`AlphaLower')
	scalar `CohensD_Lower' = `LowerLambda' * sqrt((`n1'+`n2')/(`n1'*`n2'))
	scalar `CohensD_Upper' = `UpperLambda' * sqrt((`n1'+`n2')/(`n1'*`n2'))
	

	// CALCULATE HEDGE'S G 
	// =================================================================
	// EXACT BIAS CORRECTION: Hedges (1981) pg 111, Equation 6e
	scalar `m' = (`n1'+`n2'-2)
	scalar `BiasCorrectionFactor' = exp(lngamma(`m'/2) - ///
		1/2*ln(`m'/2) - lngamma((`m'-1)/2))
	// Turner & Bernard (2006) , Eq 4
	scalar `HedgesG' = `CohensD' * `BiasCorrectionFactor'
	scalar `HedgesG_Lower' = `CohensD_Lower' * `BiasCorrectionFactor'
	scalar `HedgesG_Upper' = `CohensD_Upper' * `BiasCorrectionFactor'
		
		
	// CALCULATE GLASS'S DELTA
	// ==================================================================
	// Turner & Bernard (2006) , Eq 3 
	// GLASS'S DELTA USING STANDARD DEVIATION 1
	scalar `GlassDelta1' =    (`mean1'-`mean2') / `sd1'
	scalar `LowerLambda' = npnt(`n1'-1,`GlassDelta1'*`ns',`AlphaUpper')
	scalar `UpperLambda' = npnt(`n1'-1,`GlassDelta1'*`ns',`AlphaLower')
	scalar `GlassDelta1_L' = `LowerLambda' * sqrt((`n1'+`n2')/(`n1'*`n2'))
	scalar `GlassDelta1_U' = `UpperLambda' * sqrt((`n1'+`n2')/(`n1'*`n2'))
	// CONFIDENCE INTERVALS FROM Steiger & Fouladi (1997) pg 551 Eq 9.13
	// CALCULATE STANDARD ERRORS BASED ON Cumming & Finch (2001)
	// GLASS'S DELTA USING STANDARD DEVIATION 2
	scalar `GlassDelta2' =    (`mean1'-`mean2') / `sd2'
	scalar `LowerLambda' = npnt(`n2'-1,`GlassDelta2'*`ns',`AlphaUpper')
	scalar `UpperLambda' = npnt(`n2'-1,`GlassDelta2'*`ns',`AlphaLower')
	scalar `GlassDelta2_L' = `LowerLambda' * sqrt((`n1'+`n2')/(`n1'*`n2'))
	scalar `GlassDelta2_U' = `UpperLambda' * sqrt((`n1'+`n2')/(`n1'*`n2'))

	// CALCULATE THE POINT-BISERIAL CORRELATION AND CONFIDENCE INTERVALS
	// =================================================================
	scalar `r_pb' = `t' / sqrt( (`t'^2) + `df_within' )
	scalar `LowerLambda' = npnt(`df_within',`t',`AlphaUpper')
	scalar `r_pb_Lower' = `LowerLambda'/sqrt((`LowerLambda'^2)+`df_within')
	scalar `UpperLambda' = npnt(`df_within',`t',`AlphaLower')
	scalar `r_pb_Upper' = `UpperLambda'/sqrt((`UpperLambda'^2)+`df_within')

	// DISPLAY OUTPUT
	// ====================================================================
	// SET DEFAULT OUTPUT
	if "`all'" == "" & "`cohensd'"=="" & "`hedgesg'"=="" 	///
		& "`glassdelta'"=="" & "`pbcorr'"==""		///
		{ 			
			local cohensd "cohensd"
			local hedgesg "hedgesg"
		}
	
	if "`all'" != "" {
		local cohensd "cohensd"
		local hedgesg "hedgesg"
		local glassdelta "glassdelta"
		local pbcorr "pbcorr"
	}

	// DISPLAY TITLE
	if "`unequal'" != "" | "`welch'" != "" {
		disp _newline as text ///
		"Effect size based on mean comparison, unequal variances"
	}
	else {
		disp _newline as text "Effect size based on mean comparison"
	}
	
	// DISPLAY TABLE HEADER INFORMATION FOR THE IMMEDIATE FLAVOR OF -esize-
	if "`immediate'" != "" {
		disp _newline %45s "Obs per group:"
		disp %47s "Group 1 = " %10.0fc `n1'
		disp %47s "Group 2 = " %10.0fc `n2'
	}	
	// DISPLAY TABLE HEADER INFORMATION FOR -twosample- FLAVOR OF -esize-
	if "`by'" != "" {
		disp _newline %45s "Obs per group:"
		quietly levelsof `by', local(levels)
		local val1:word 1 of `levels'
		local val2:word 2 of `levels'
		local lbe : value label `by'
		if "`lbe'" == "" {
		
			disp %47s "`by'==`val1' = " %10.0fc `n1'
			disp %47s "`by'==`val2' = " %10.0fc `n2'
		}
		else if "`lbe'" != "" {
			local label1 : label `lbe' `val1'
			local label2 : label `lbe' `val2'
			if "`label1'" ~= "`val1'" {
				disp %47s "`label1' = " %10.0fc `n1'
			}
			if "`label2'" ~= "`val2'" {
				disp %47s "`label2' = " %10.0fc `n2'
			}
		}
	}
	// DISPLAY TABLE HEADER INFORMATION FOR -unequal- FLAVOR OF -esize-
	else if "`by'" == "" & "`immediate'" == "" {
		quietly count if ``touse''
		disp _newline %47s "Number of obs = " %10.0fc `N'
	}


	// DISPLAY OUTPUT TABLE
        tempname mytab
        .`mytab' = ._tab.new, col(4) lmargin(0)
        .`mytab'.width    20   |12    12    12
        .`mytab'.titlefmt  .     .    %24s   .
        .`mytab'.pad       .     2     3     3
        .`mytab'.numfmt    . %9.0g %9.0g %9.0g
	.`mytab'.strcolor result  .  .  . 
        .`mytab'.strfmt    %19s  .  .  .
        .`mytab'.strcolor   text  .  .  .
	.`mytab'.sep, top
	.`mytab'.titles "Effect Size"                   /// 1
                        "Estimate"                      /// 2
                        "[`level'% Conf. Interval]" ""  //  3 4
	.`mytab'.sep, middle
	if "`cohensd'" != "" {
		.`mytab'.strfmt    %24s  .  .  .
		.`mytab'.row    "Cohen's {it:d}" 	///
			`CohensD'			///
			`CohensD_Lower' 		///
			`CohensD_Upper'
	}
	if "`hedgesg'" != "" {
		.`mytab'.strfmt    %24s  .  .  .
		.`mytab'.row "Hedges's {it:g}"		///
			`HedgesG' 			///
			`HedgesG_Lower'   		///
			`HedgesG_Upper'
	}
	if "`glassdelta'" != "" {
		.`mytab'.strfmt    %19s  .  .  .
		.`mytab'.row "Glass's Delta 1"		///
			`GlassDelta1'			///
			`GlassDelta1_L'   		///
			`GlassDelta1_U'
		.`mytab'.row "Glass's Delta 2"		///
			`GlassDelta2'	  		///
			`GlassDelta2_L'   		///
			`GlassDelta2_U'
	}
	if "`pbcorr'" != "" {
		.`mytab'.strfmt    %19s  .  .  .
		.`mytab'.row  "Point-Biserial r"	///
			`r_pb' 				///
			`r_pb_Lower'  			///
			`r_pb_Upper'
	}
	.`mytab'.sep, bottom
	if "`welch'" != "" {
		disp %48s "Welch's degrees of freedom =" ///
		_col(51) as result %7s string(`df_within',"%7.4f")
	}
	else if "`unequal'" != "" {
		disp %48s "Satterthwaite's degrees of freedom =" ///
		_col(51) as result %7s string(`df_within',"%7.4f")
	}
	
	
	// RETURN RESULTS
	// =================================================
	return scalar level = `level'
	return scalar N_2 = `n2'
	return scalar N_1 = `n1'
	if "`unequal'" != "" | "`welch'" != "" {
		return scalar df_t = `df_within'
	}
	if "`pbcorr'" != "" {
		return scalar ub_r_pb = `r_pb_Upper'	
		return scalar lb_r_pb = `r_pb_Lower'
		return scalar r_pb = `r_pb'
	}
	if "`glassdelta'" != "" {
		return scalar ub_delta2 = `GlassDelta2_U'
		return scalar lb_delta2 = `GlassDelta2_L'
		return scalar delta2 = `GlassDelta2'
		return scalar ub_delta1 = `GlassDelta1_U'
		return scalar lb_delta1 = `GlassDelta1_L'
		return scalar delta1 = `GlassDelta1'
	}
	if "`hedgesg'" != "" {
		return scalar ub_g = `HedgesG_Upper'
		return scalar lb_g = `HedgesG_Lower'
		return scalar g = `HedgesG'
	}
	if "`cohensd'" != "" {
		return scalar ub_d = `CohensD_Upper'
		return scalar lb_d = `CohensD_Lower'
		return scalar d = `CohensD'
	}
end


/*
References

    Cohen, J. 1988.  Statistical power analysis for the behavioral
	sciences, 2nd ed.  Hillsdale, NJ: Lawrence Erlbaum.
	
    Cumming, G. and Finch, S. (2001)  A primer on the understanding, 
	use and calculation of confidence intervals that are based on 
	central and noncentral distributions.  Educational and 
	Psychological Measurement, 61: 532-574

    Hedges, L. V. 1981.  Distribution theory for Glass's estimator 
	of effect size and related estimators.  Journal of Educational
	Statistics 6(2): 107-128.

    Kline, R. B. 2004.  Beyond significance testing: Reforming data
	analysis methods in behavioral research.  Washington DC: 
	American Psychological Association

    Pearson, K. 1909.  On a new method of determining correlation
	between a measured character A, and a character B, of which
	only the percentage of cases wherein B exceeds (or falls short
	of) a given intensity is recorded for each grade of A.  
	Biometrika 7(1): 96-105.

    Rosenthal, R. and Rosnow, R. L. 2008.  Essentials of Behavioral 
	Research: Methods and Data Analysis, 3rd Edition.  Boston, 
	MA: McGraw-Hill.

    Smith, M. L. and Glass, G. V. 1977.  Meta-analysis of psychotherapy
	outcome studies.  American Psychologist 32: 752-760.

    Smithson, M. 2001.  Correct confidence intervals for various
	regression effect sizes and parameters:  The importance 
	of noncentral distributions in computing intervals.  Educational
	and Psychological Measurement 61: 605-632.
	
    Steiger, J. H. and Fouladi, R. T. (1997)  Noncentrality interval 
	estimation and the evaluation of statistical models.  In L. L. 
	Harlow, S. A. Muliak I\& J. H. Steiger (Eds.), What if there 
	were no significance tests? (pp. 221-257), Mahwah, NJ: Erlbaum

    Turner, H. M. and Bernard, R. M. 2006.  Correct confidence intervals
	for various regression effect sizes and parameters:  Calculating 
	and synthesizing effect sizes.  Contemporary Issues in 
	Communication Science and Disorders 33: 42-55.

*/





