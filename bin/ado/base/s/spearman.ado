*! version 4.2.6  10sep2012
program define spearman, rclass byable(recall)
        version 6, missing
        syntax [varlist(min=2)] [if] [in] [, /*
                */stats(str) Bonferroni Print(numlist min=1 max=1) SIDak /*
                */ STar(numlist min=1 max=1) pw MATrix]
        tempvar touse
	mark `touse' `if' `in'          /* but do not markout varlist */
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
                markout `touse' `varlist'
        }

	tokenize `varlist'
	local nvar : word count `varlist'
	if `nvar' < 2 { error 102}  

	local adj 1
	if "`bonferr'"!="" | "`sidak'"!="" {
		if "`bonferr'"!="" & "`sidak'"!="" { 
			di in red "only one of bonferroni and sidak" /*
                        */" can be specified"
                	exit 198 
		}
		local nrho=(`nvar'*(`nvar'-1))/2
		if "`bonferr'"!="" { local adj `nrho' }
	}
	if "`star'" != "" { 
		if (`star' <=0 | `star' >= 1) {
			di as error "star() must be between 0 and 1"
			exit 198
		}
	}
	else {
		local star = -1	   /* pvalue never < 0, so no stars */
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
                local rho="rho"
        }
        else {
                forvalues i = 1(1)`nopt' {
                        local str=word("`stats'", `i')
                        if "`str'"=="rho" {
                                local rho="rho"
                        }
	                else if "`str'"=="obs" {
                                local obs="obs"
                        }
                        else if "`str'"=="p" {
                                local p="p"
                        }
                        else { 
                        	di as error in smcl /*
*/ "{opt stats()} must contain one or more of {opt rho}, {opt obs}, and {opt p}"
                                exit 198
                        }

                }
	}

	if (`nvar'<=2 & "`matrix'"=="" ) {
                spearman2 `1' `2' if `touse'
                
                ret scalar p   = r(p)
		ret scalar rho = r(rho)
		ret scalar N   = r(N)

        }
        else {
        /*output the number of observations */
                tempvar obsmiss
                qui egen `obsmiss'=rowmiss(`varlist') if `touse'
                qui sum `obsmiss' if `touse'
                if ("`pw'"=="pw" & r(max)>0) {
			if ( "`obs'"!="obs" ) {
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
                if !(`nopt'<=1 & "`rho'"=="rho") {
                        di in smcl in gr _n "{c TLC }{hline 17}{c TRC}" _c
                        di in smcl in gr _n "{c |}" _skip(2) "Key" _column(19)/*                  
		        */ "{c |}"  _c
                        di in smcl in gr _n "{c LT }{hline 17}{c RT}" _c
                        if "`rho'"=="rho" {
                                di in smcl in gr _n "{c |}" _skip(2) /*
                                */ "{it: rho}" _column(19) "{c |}" _c
                        }
                        if "`obs'"=="obs" {
                                di in smcl in gr _n "{c |}" _skip(2) /*
                                */ "{it: Number of obs}" _column(19) "{c |}" _c
                        }
                        if "`p'"=="p" {
                                di in smcl in gr _n "{c |}" _skip(2) /*
                                */ "{it: Sig. level}" _column(19) "{c |}" _c
                        }
                        di in smcl in gr _n "{c BLC }{hline 17}{c BRC}"
                }


		tempname Nobs Rho P
        	foreach ib in `Nobs' `Rho' `P' {
        		mat `ib'=J(`nvar', `nvar', 0)
                	mat colnames `ib' = `varlist'
	                mat rownames `ib' = `varlist'
		}


        	local start=int((c(linesize)-15)/9)-1 
	        local j0 1
        	while (`j0'<=`nvar') {
			di
			local j1=min(`j0'+`start',`nvar')
			local j `j0'
			di in smcl in gr _skip(13) "{c |}" _c
			while (`j'<=`j1') {
				di in gr %9s abbrev("``j''",8) _c
				local j=`j'+1
			}
			local l=9*(`j1'-`j0'+1)
			di in smcl in gr _n "{hline 13}{c +}{hline `l'}"
                
			local i `j0'
			while `i'<=`nvar' {
				di in smcl in gr %12s abbrev("``i''",12) /*
				*/ " {c |} " _c
				local j `j0'
				while (`j'<=min(`j1',`i')) {
				
					quietly{
                        	        	tempvar mi mj
						/* need proper if cond to get */
						/* correct results with -pw- */
						local pwif `touse' & ``i''<.
						local pwif `pwif'  & ``j''<.
						egen `mi'=rank(``i'') if `pwif'
						egen `mj'=rank(``j'') if `pwif'
					}
					cap corr `mi' `mj' if `touse' 
					if _rc == 2000 {
                                        	local c`j' = .
                                	}
                                	else {
                                        	local c`j'=r(rho)
                                	}
                                	local n`j'=r(N)
                                	if (r(rho) != . & r(rho) < 1) {
                                        	local p`j'=/*
                                        	*/min(2*`adj'*ttail(r(N)-2,/*
                                        	*/ abs(r(rho))*sqrt(r(N)-2)/ /*
                                        	*/ sqrt(1-r(rho)^2)),1)
                                	}
                                	else if (r(rho)>=1 & r(rho) != .) {
                                        	local p`j'=0
                                	}		
                                	else if r(rho) == . {
                                        	local p`j'= .
                                	}	
					if "`sidak'"!="" {
						local p`j'=min(1,1-(1-`p`j'')/*
						*/ ^`nrho')
					}

	                                mat `Nobs'[`i', `j']=`n`j''
        	                        mat `Nobs'[`j', `i']=`n`j''
                	                mat `Rho'[`i', `j']=`c`j''
					mat `Rho'[`j', `i']=`c`j''
					mat   `P'[`i', `j']=`p`j''
                        		mat   `P'[`j', `i']=`p`j''


	                                if `i'==`nvar' & `j'==`nvar'-1 {
		                                return scalar p=`p`j'' 
                	                	return scalar rho=r(rho)
	                	                return scalar N= r(N)
                                
					 /* Double saves */
					        global S_1 = `return(N)'
					        global S_4 = `return(rho)'
				        	global S_6 = `return(p)'
	
	                                } 
					local j=`j'+1
					drop `mi' `mj' 
				}
/* output */
				if ("`rho'"=="rho"){
					local j `j0'
					while (`j'<=min(`j1',`i')) {
						if `p`j''<=`star' & `i'!=`j' { 
							local ast "*" 
						}
						else local ast " "
						if `p`j''<=`print' |/*
						*/ `print'==-1/*
						*/ |`i'==`j' {
							di " " %7.4f `c`j''/*
							*/ "`ast'" _c
						}
						else 	di _skip(9) _c
						local j=`j'+1
					}
					di
				}
				if "`obs'"=="obs" {
					if ("`rho'"=="rho") {
						di in smcl in gr _skip(13)/*
						*/  "{c |} " _c
					}
					local j `j0'
					while (`j'<=min(`j1',`i')) {
						if `p`j''<=`print'|/*
						*/`print'==-1 /*
						*/ |`i'==`j'{
							di " " %7.0g /*
							 */ `n`j'' " " _c
						}
						else di _skip(9) _c
						local j=`j'+1
					}
					di
				}
				if "`p'"=="p" {
					if ("`rho'"=="rho" | "`obs'"=="obs"){
						di in smcl in gr _skip(13)/*
						*/ "{c |} " _c
					}
					local j `j0'
					while (`j'<=min(`j1',`i'-1)) {
						if `p`j''<=`print'|/*
						*/ `print'==-1{ 
							di " " %7.4f `p`j''/*
							*/ " " _c
						}
						else	di _skip(9) _c
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


	        ret matrix  P    `P'
		ret matrix Rho `Rho'
	        ret matrix  Nobs `Nobs'
	}        
end

program define spearman2, rclass
        version 6, missing
        syntax varlist(min=2 max=2) [if] [in]
        marksample touse
        tokenize `varlist'
        tempname N pval rho
        tempvar r1 r2
        quietly {
                egen `r1' = rank(`1') if `touse'
                egen `r2' = rank(`2') if `touse'
                corr `r1' `r2' if `touse'
                scalar `N' = r(N)
                scalar `rho' = r(rho)
                if (`rho' == 1) { scalar `pval' = 0 }
                else scalar `pval' = 2*ttail(`N'-2, abs(`rho')*sqrt((`N'-2)/ /*
                */ (1-`rho'^2)))
        }
/* Print results */
        #delimit ;
        di _n
                in gr " Number of obs = " in ye  %7.0f `N' _n
                in gr "Spearman's rho = " in ye %12.4f `rho' _n(2)
                in gr "Test of Ho: " abbrev("`1'",20) " and "
                      abbrev("`2'",20) " are independent" _n
                in gr "    Prob > |t| = " in ye %12.4f `pval' ;
        #delimit cr

        ret scalar N   = `N'
        ret scalar rho = `rho'
        ret scalar p   = `pval'

        /* Double saves */
        global S_1 = `return(N)'
        global S_4 = `return(rho)'
        global S_6 = `return(p)'
end

