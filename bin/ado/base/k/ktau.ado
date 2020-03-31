*! version 4.2.4  25apr2007
program define ktau, rclass byable(recall)
	version 6, missing
	syntax [varlist(min=2)] [if] [in] [, /* 
		*/ stats(str) Bonferroni SIDak Print(numlist min=1 max=1) /*
                */ STar(numlist min=1 max=1) pw MATrix]

	tempvar touse
	mark `touse' `if' `in' 	  /* but do not markout varlist */ 
       
          
	tokenize `varlist'

      	local i 1
	while "``i''" != "" { 
		capture confirm str var ``i''
		if _rc==0 { 
			di in gr "(``i'' ignored because string variable)"
			local `i' " "
		}
		local i = `i' + 1
	}
	local varlist `*'

	if  "`pw'"=="" | "`pw'"=="nopw" {
		markout `touse' `varlist'  /* markout varlist if "nopw" */
	}

	tokenize `varlist'
	local nvar : word count `varlist'
	if `nvar' < 2 { error 102 } 

	local adj 1

/* check options */
	if "`bonferr'"!="" | "`sidak'"!="" {
		if "`bonferr'"!="" & "`sidak'"!="" { 
			di in red "only one of bonferroni and sidak" /*
			*/ " can be specified"
			exit 198 
		}
		local nrho=(`nvar'*(`nvar'-1))/2
		if "`bonferr'"!="" { local adj `nrho' }
	}
	if "`star'" != "" {
		if (`star' <= 0 | `star' >= 1) {
			di as error "star() must be between 0 and 1"
			exit 198
		}
	}
	else {
		local star = -1    /* pvalue never < 0, so no stars */
	}
	if "`print'" != "" {
		if (`print' <= 0 | `print' >= 1) {
			di as error "print() must be between 0 and 1"
			exit 198
		}
	}
	else {
		local print = -1
	}

        local nopt=wordcount("`stats'")
	if `nopt'==0 {
		local taua="taua"
	}
	else {
		forvalues i = 1(1)`nopt' {
			local str=word("`stats'", `i')
			if "`str'"=="taua" {
				local taua="taua"
			}
			else if "`str'"=="taub" {
				local taub="taub"
			}
			else if "`str'"=="score" {
				local score="score"
			}
			else if "`str'"=="se" {
				local se="se"
			}
			else if "`str'"=="obs" {
                                local obs="obs"
                        }

			else if "`str'"=="p" {
				local p="p" 
			}
	
			else {
				di as error in smcl /*
*/ "{opt stats()} must contain one or more of {opt taua}, {opt taub}, " /*
*/ "{opt score}, {opt se}, {opt obs}, and {opt p}"
				exit 198
			}
		}
	}
   
        if (`nvar'<=2 & "`matrix'"=="" ) {
		ktau2var `1' `2' if `touse'
		resupr `1' `2'
	
	        ret scalar p = r(p)
		ret scalar se_score = r(se_score)
		ret scalar score = r(score)
		ret scalar tau_b = r(tau_b)
		ret scalar tau_a = r(tau_a)
		ret scalar N = r(N)
	
	}
        else {

/*output the number of observations */
		tempvar obsmiss
	        qui egen `obsmiss'=rowmiss(`varlist') if `touse'
		qui sum `obsmiss' if `touse'
		if ("`pw'"=="pw" & r(max)>0) {
			if ("`obs'"!="obs") {
				di in smcl in gr "(obs=varies)"
			}
		}
		else {
			if ("`obs'"!="obs") {
				qui sum `1' if `touse'
				di in gr "(obs=`r(N)')"
			}
		}

/*produce a key*/
		if !(`nopt'<=1 & "`taua'"=="taua") { 
			di in smcl in gr _n "{c TLC }{hline 17}{c TRC}" _c
			di in smcl in gr _n "{c |}" _skip(2) "Key" _column(19)/*
                	 */ "{c |}"  _c
			di in smcl in gr _n "{c LT }{hline 17}{c RT}" _c
			if "`taua'"=="taua" {
	        		di in smcl in gr _n "{c |}" _skip(2) /*
	                	*/ "{it: tau_a}" _column(19) "{c |}" _c
			}
			if "`taub'"=="taub" {
		        	di in smcl in gr _n "{c |}" _skip(2) /*
 	        	        */ "{it: tau_b}" _column(19) "{c |}" _c
			}
			if "`score'"=="score" {
        			di in smcl in gr _n "{c |}" _skip(2) /*
	               		*/ "{it: score}" _column(19) "{c |}" _c
			}
			if "`se'"=="se" {
        			di in smcl in gr _n "{c |}" _skip(2) /*
	               		*/ "{it: se of score}"  _column(19) "{c |}" _c
			}
			if "`obs'"=="obs" {
                                di in smcl in gr _n "{c |}" _skip(2) /*
                                */  "{it: Number of obs}" _column(19) "{c |}" _c                        }

			if "`p'"=="p" {
        			di in smcl in gr _n "{c |}" _skip(2) /*
               			*/ "{it: Sig. level}" _column(19) "{c |}" _c
			}
			di in smcl in gr _n "{c BLC }{hline 17}{c BRC}"
		}	
    
	        tempname Nobs Tau_a Tau_b Score Sescore P 
        	foreach ib in `Nobs' `Tau_a' `Tau_b' `Score' `Sescore' `P' {
                	mat `ib'=J(`nvar', `nvar', 0)
	                mat colnames `ib' = `varlist'
        	        mat rownames `ib' = `varlist'
		}

	
		local j0 1
	  	local start=int((c(linesize)-15)/11)-1
	        while (`j0'<=`nvar') {
			di
			local j1=min(`j0'+`start',`nvar')
			local j `j0'
			di in smcl in gr _skip(13) "{c |}" _c
			while (`j'<=`j1') {
				di in gr %11s abbrev("``j''",8) _c
				local j=`j'+1
			}
			local l=11*(`j1'-`j0'+1)
			di in smcl in gr _n "{hline 13}{c +}{hline `l'}"

			local i `j0'
			while `i'<=`nvar' {
				di in smcl in gr %12s abbrev("``i''",12) /*
 				*/ " {c |} " _c
				local j `j0'
				while (`j'<=min(`j1',`i')) {

					cap ktau2var ``i'' ``j'' if `touse' 
					if _rc != 0 {
						local a`j' = .
						local b`j'=  .
	                                        local s`j'=  .
        	                                local se`j'= .
					}
					else { 
						local a`j'=r(tau_a)
                             			local b`j'=r(tau_b)
	                                	local s`j'=r(score)
        	                      	 	local se`j'=r(se_score)

					}	       
					local n`j'=r(N)
					local p`j'= min(`adj'*r(p), 1)
					if "`sidak'"!="" {
						local p`j'=min(1,1-(1-`p`j'')/*
						 */^`nrho')
					}
	
                	  		mat 	`Nobs'[`i', `j']=`n`j''
                        	        mat     `Nobs'[`j', `i']=`n`j''
                                	mat    `Tau_a'[`i', `j']=`a`j''
	                                mat    `Tau_a'[`j', `i']=`a`j''
					mat    `Tau_b'[`i', `j']=`b`j''
                	                mat    `Tau_b'[`j', `i']=`b`j''
					mat    `Score'[`i', `j']=`s`j''
                                	mat    `Score'[`j', `i']=`s`j''
					mat `Sescore'[`i', `j']=`se`j''
        	                        mat `Sescore'[`j', `i']=`se`j''
                	                mat        `P'[`i', `j']=`p`j''
                        	        mat        `P'[`j', `i']=`p`j''
	
		                        if `i'==`nvar' & `j'==`nvar'-1 {          
						ret scalar p = `p`j''
					        ret scalar se_score = /*
						*/ r(se_score)
					        ret scalar score = r(score)
					        ret scalar tau_b = r(tau_b)
					        ret scalar tau_a = r(tau_a)
					        ret scalar N = r(N)
/* double save in S_#  */
					        global S_1 = r(N)
				        	global S_2 = r(tau_a)
					        global S_3 = r(tau_b)
					        global S_4 = r(score)
					        global S_5 = r(se_score)
					        global S_6 = r(p)

		  			} 
					local j=`j'+1
				}
                        
/* output */                 
				if ("`taua'"=="taua")  {       
			        	local j `j0'
                        		while (`j'<=min(`j1',`i')) {
						if `p`j''<=`star' & `i'!=`j' { 
							local ast "*" 
                                		}
						else local ast " "
				
						if `p`j''<=`print' | /*
						*/ `print'==-1 | /*
	                                        */ `i'==`j' {
							di " " %9.4f `a`j''/*
							*/ "`ast'" _c
				       		 }
						else 	di _skip(11) _c
				
						local j=`j'+1
					}
			        	di

        	         	}

                	  	if ("`taub'"=="taub"){
					if ("`taua'"=="taua") {
						di in smcl in gr _skip(13) /*
                                                */ "{c |} " _c 
					}
	                		local j `j0'
	                        	while (`j'<=min(`j1',`i')) {
						if `p`j''<=`star' & `i'!=`j' { 
							local ast "*" 
						}
						else local ast " "
						if `p`j''<=`print' |/*
						*/ `print'==-1 |/*
	                                        */ `i'==`j' {
							di " " %9.4f `b`j'' /*
                                                        */ "`ast'" _c
 						
						}
						else 	di _skip(11) _c
						local j=`j'+1
			        	}
		        	  	di

				}

	        	       	if "`score'"=="score" {
					if ("`taua'"=="taua"|"`taub'"=="taub"){
						di in smcl in gr _skip(13) /*
						*/ "{c |} " _c 
					}
					local j `j0'
					while (`j'<=min(`j1',`i')) {
						if `p`j''<=`print' |/*
						*/ `print'==-1 /*
						*/ |`i'==`j' {
							di " " %9.4f `s`j''/*
							*/ " " _c	
                              			}
						else	di _skip(11) _c
						local j=`j'+1
					}
					di	
                		}

	                	if "`se'"=="se" {
                         		if ("`taua'"=="taua"|"`taub'"=="taub"|/*
					*/ "`score'"=="score") {
						di in smcl in gr _skip(13) /*
						*/ "{c |} " _c 
					}
					local j `j0'
					while (`j'<=min(`j1',`i')) {
						if `p`j''<=`print' |/*
						*/ `print'==-1 /*
						*/ |`i'==`j' {
							di " " %9.4f `se`j''/*
							*/ " "  _c			                                 
                            			}
						else   di _skip(11) _c
						local j=`j'+1
					}
					di	
				}
				

				 if "`obs'"=="obs" {
                                        if ("`taua'"=="taua"|"`taub'"=="taub"/*
                                        */ |"`score'"=="score"|"`se'"=="se") { 
						di in smcl in gr _skip(13) /*
                                                */ "{c |} "  _c
                                        }
                                        local j `j0'
                                        while (`j'<=min(`j1',`i')) {
                                                if `p`j''<=`print' |/*
                                                */ `print'==-1 /*
                                                */ |`i'==`j' {
                                                        di " " %9.0g `n`j''/*
                                                        */ " " _c
                                                 }
                                                else    di _skip(11) _c
                                                local j=`j'+1
                                        }
                                        di

                                }

				if "`p'"=="p" {
					if ("`taua'"=="taua"|"`taub'"=="taub" /*
					*/| "`obs'"=="obs"|"`score'"=="score" /*
					*/|"`se'"=="se") {
                                                di in smcl in gr _skip(13)/*
						*/ "{c |} " _c
                                        }
					local j `j0'
					while (`j'<=min(`j1',`i'-1)) {
						if `p`j''<=`print' |/*
						*/ `print'==-1 {
							di " " %9.4f `p`j''/*
							*/ " " _c
						}
						else	di _skip(11) _c
						local j=`j'+1
			       		}
					di
				}
		
				local i=`i'+1
				if (`nopt'>1) {
					di in smcl in gr _skip(13) "{c |}" 
				}
			}
			local j0=`j0'+`start'+1
		}
 
		ret matrix P `P'
        	ret matrix Se_Score `Sescore'
	        ret matrix Score `Score' 
        	ret matrix Tau_b `Tau_b'
	        ret matrix Tau_a `Tau_a'
   		ret matrix Nobs  `Nobs'
	}
   
end


program define ktau2var, rclass sort
	syntax varlist(min=2 max=2) [if] [in]
	tokenize `varlist'
        local x "`1'"
        local y "`2'"
	marksample doit

	tempname k N NN pval score se tau_a tau_b
	tempname xt xt2 xt3 yt yt2 yt3
	tempvar nobsx nobsy

	quietly count if `doit'
	scalar `N' = r(N)
        if `N' < 3 { error 2001 } 
	local Nmac = `N'
	quietly {
		replace `doit' = -`doit'
		sort `doit', stable  /* put obs for computation first */

		egen long `nobsx' = count(`x') in 1/`Nmac', by(`x')
		egen long `nobsy' = count(`y') in 1/`Nmac', by(`y')

		_ktau `x' `y' `nobsx' `nobsy', N(`Nmac')
		scalar `score' = r(score)
		scalar `xt' = r(xt)
		scalar `yt' = r(yt)
		scalar `xt2' = r(xt2)
		scalar `yt2' = r(yt2)
		scalar `xt3' = r(xt3)
		scalar `yt3' = r(yt3)

	/* Compute Kendall's tau-a, tau-b, s.e. of score, and pval */
		scalar `NN'    = `N'*(`N' - 1)
		scalar `tau_a' = 2*`score'/`NN'
		scalar `tau_b' = 2*`score'/sqrt((`NN' - `xt2')*(`NN' - `yt2'))
		#delimit ;
		scalar `se' = sqrt((1/18)*(`NN'*(2*`N' + 5) - `xt' - `yt')
			           + `xt3'*`yt3'/(9*`NN'*(`N' - 2))
			           + `xt2'*`yt2'/(2*`NN')) ;
		#delimit cr
		if `score' == 0 { scalar `pval' = 1 }
		else scalar `pval' = 2*(1 - normprob((abs(`score') - 1)/`se'))
	}

/* saved results: r() */
        ret scalar N = `N'
        ret scalar tau_a = `tau_a'
        ret scalar tau_b = `tau_b'
        ret scalar score = `score'
        ret scalar se_score = `se'
        ret scalar p = `pval'
	ret scalar xt2=`xt2'
	ret scalar yt2=`yt2'

/* Double save */
	global S_1 = `N'
        global S_2 = `tau_a'
        global S_3 = `tau_b'
        global S_4 = `score'
        global S_5 = `se'
        global S_6 = `pval'
end


program resupr
        syntax varlist(min=2 max=2)
        tokenize `varlist'
        local x "`1'"
        local y "`2'"

        #delimit ;
        di _n
                in gr "  Number of obs = " in ye  %7.0f r(N) _n
                in gr "Kendall's tau-a = " in ye %12.4f r(tau_a) _n
                in gr "Kendall's tau-b = " in ye %12.4f r(tau_b) _n
                in gr "Kendall's score = " in ye  %7.0f r(score) _n
                in gr "    SE of score = " in ye %11.3f r(se_score) _c ;
        if r(xt2) > 0 | r(yt2) > 0 { di in gr "   (corrected for ties)" _c } ;
        di _n(2)
                in gr `"Test of Ho: "' abbrev("`x'",20) " and "
                        abbrev("`y'",20) `" are independent"' _n
                in gr "     Prob > |z| = " in ye %12.4f = r(p)
                in gr "  (continuity corrected)" ;
        #delimit cr
end
