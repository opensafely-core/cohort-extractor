*! version 4.2.2  18feb2016
program cc, rclass
	version 6, missing
	syntax varlist(min=2 max=2) [if] [in] [fw] [, BY(string) BD /*
		*/ Tarone Binomial(varname) COrnfield/*
		*/ noCrude Exact Fast EStandard noHom noHEt IStandard /*
		*/ Level(cilevel) Pool Standard(varname) TB Woolf ]
	local hom "`hom'`het'"		/* het is old option name */

	tokenize `varlist'
	local cas `1'
	local ex `2'

	local stdflg=("`standar'"!="")+("`istanda'"!="")+("`estanda'"!="")
	if `stdflg'>1 { error 198 }

	marksample use
	qui count if `use'
	if (r(N)==0) {
		error 2000
	}

	_epitab_by_parse `by'
	local by `s(by)'
	local missing `s(missing)'
	sret clear
	local nbyvars: word count `by'
	if (`nbyvars' > 1) {
		error 103
	}
	
	tempvar WGT one first decoded
	
	* checks that weight and binomial are not both present
	if "`binomial'"!="" & "`weight'"!="" {
		di in re "weight not allowed with binomial frequency records"
		exit 198
	}
	if "`binomial'"~="" {
		preserve
		qui keep if `use'
		tempvar case mywt 
		bitowt `cas' `binomial' , c(`case') w(`mywt')
		local exp "= `mywt'"
		qui drop `cas'
		tempvar cas
		rename `case' `cas'
		local weight "fweight"
	}
	if `"`weight'"'!="" { 
		qui gen double `WGT' `exp' if `use'
		local w "[fweight=`WGT']"
	}

	if "`by'"!="" { 
		if ("`missing'" == "") {
			cap replace `use' = 0 if missing(`by')
			qui count if `use'
			if (r(N)==0) {
				error 2000
			}
		}
		quietly { 
			if "`binomial'" == "" {
				preserve
			}
			sort `use' `by'
			if "`standar'"!="" {
				capture assert `standar'>=0 if `use'
				if _rc {
					noi di in red /*
					*/ "`standar' has negative values"
					exit 498
				}
				capture by `use' `by': assert /*
				*/ `standar'==`standar'[_n-1] if _n>1 & `use'
				if _rc {
					noi di in red /*
					*/ "`standar' not constant within `by'"
					exit 198
				}
			}
			by `use' `by': gen byte `first'=1 if _n==1 & `use'
			sort `first' `by'

			if "`crude'" == "" {
				local optex = /*
				*/ ("`woolf'"=="") +  ("`cornfield'"=="") /*
			*/ + ("`tb'"=="") + ("`exact'"=="") + ("`level'"=="") 
				
				if "`level'" != "" {
					local ml "level(`level')" 
				}
				else 	local ml

				if `optex' == 5 {
					local myopt
				}
				else {
				local myopt /*
				*/ ",`woolf' `exact' `ml' `tb' `cornfield' "
				}
				cc `cas' `ex' if `use' `w' `myopt'
				local CRUDE  `r(or)'
				local C0     `r(lb_or)'
				local C1     `r(ub_or)'
				
				ret scalar crude = `CRUDE'
				ret scalar lb_crude = `C0'
				ret scalar ub_crude = `C1'
				ret add
				
				local CTYPE  "(exact)"
				if "`cornfield'" != "" { 
					local CTYPE  "(Cornfield)" 
				}
				if "`tb'" != ""    { local CTYPE  "(tb)" }
				if "`woolf'" != "" { local CTYPE  "(Woolf)" }
			}

		}
	}
	else {
		if `stdflg' { 
			di in red "missing by() option"
			error 198 
		}
	}
	quietly gen byte `one'=1
	_crcvarl `ex'
	local col "col(`s(varlabel)')"

	if "`by'"=="" { 
		quietly { 
			safesum `one' `w' if `cas' & `ex' & `use'
			local a=r(sum)
			safesum `one' `w' if `cas' & `ex'==0 & `use'
			local b=r(sum)
			safesum `one' `w' if `cas'==0 & `ex' & `use'
			local c=r(sum)
			safesum `one' `w' if `cas'==0 & `ex'==0 & `use'
			local d=r(sum)
		}
		noi cci `a' `b' `c' `d', /*
		*/ level(`level') `col' `woolf' `tb' `exact' `cornfield'
		ret add
		exit
	}
	local lby : value label `by'
	if "`lby'"!="" { 
		quietly decode `by', gen(`decoded')
		local lby "`decoded'"
	}
	else	local lby `by'
	if `stdflg'==0 { local hdr2 "M-H" }
	else	local hdr2 "   "

	local lbl : var label `by'
	if "`lbl'"=="" { local lbl = abbrev("`by'",12) }
	else local lbl = udsubstr("`lbl'",1,16)
	local skip=16-udstrlen("`lbl'")
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	di in smcl _n in gr _skip(`skip') "`lbl' {c |}" _col(26) "OR" /*
*/ _col(`=37-`cil'') `"[`=strsubdp("`level'")'% Conf. Interval]   `hdr2' Weight"' _n /*
	*/ "{hline 17}{c +}{hline 49}"


	local i 1
	local iz=invnorm(1-(1-`level'/100)/2)
	local sumwgt 0
	local sumor 0
	local sumPR 0
	local sumR 0
	local sumPSQR 0
	local sumS 0
	local sumQS 0
	local sumXnum 0
	local sumXden 0
	local or0 . 
	local or1 . 
	local pnum 0
	local pden 0
	local nf
	local df 0

	tempvar irr virr Sf 
	tempname test
	scalar `test'=0
	local bddf 0
	qui gen `irr' = .
	qui gen `virr' = .
	qui gen `Sf'=.
	
	while 1 { 
		if "`or'"=="0" | "`or'"=="." {
			local suphom 1
		}
		if `first'[`i']!=1 { 
			if `stdflg'==0 {
				local or=`sumor'/`sumwgt'
				local se=sqrt(`sumPR'/(2*((`sumR')^2))+/*
					*/ `sumPSQR'/(2*`sumR'*`sumS')+/*
					*/ `sumQS'/(2*((`sumS')^2)))
				if "`tb'"=="" { 
					local or0=exp(ln(`or')-`iz'*`se')
					local or1=exp(ln(`or')+`iz'*`se')
				}
				else { 
					local x=`sumXnum'/sqrt(`sumXden')
					local or0=(`or')^(1-`iz'/`x')
					local or1=(`or')^(1+`iz'/`x')
					if `or0'>`or1' { 
						local h `or0'
						local or0 `or1'
						local or1 `h'
					}
					local 	note "(tb)"
				}
				local x2=((`sumXnum')^2)/`sumXden'
				*local x2=((`sumXnum')^2)/`sumXden'
				global S_1 `x2'
				ret scalar chi2 = `x2'
				local hdr2 "   M-H combined"
			}
			else {
				if "`istanda'"!="" { 
					local hdr2 "I. Standardized" 
				}
				else if "`estanda'"!="" {
					local hdr2 "E. Standardized" 
				}
				else local hdr2 "   Standardized"
				local or=`sumwgt'/`sumor' /* sic */
				local se=sqrt(`sumR')/`sumwgt'
				local or0=exp(ln(`or')-`iz'*`se')
				local or1=exp(ln(`or')+`iz'*`se')
				global S_1
				ret scalar chi2 = .
			}
			di in smcl in gr "{hline 17}{c +}{hline 49}"

			if "`crude'" == "" {
				di in smcl /*
			*/ 	in gr "           Crude {c |}  " in ye /*
			*/	%9.0g `CRUDE' "     " %9.0g `C0' "  "  /*
			*/	%9.0g `C1'    in gr _col(69) "`CTYPE'"
			}

			if "`pool'"!="" {
				local POOL = exp(`pnum'/`pden')
				local sd = sqrt(1/`pden')
				local P0 = exp(log(`POOL')-`iz'*`sd')
				local P1 = exp(log(`POOL')+`iz'*`sd')
				
				ret scalar pooled = `POOL'
				ret scalar lb_pooled = `P0'
				ret scalar ub_pooled = `P1'
				
				di in smcl /*
			*/ 	in gr " Pooled (direct) {c |}  " in ye /*
			*/	%9.0g `POOL' "     " %9.0g `P0' "  "  /*
			*/	%9.0g `P1'    
			}
			di in smcl in gr " `hdr2' {c |}  " in ye /* 
			*/ %9.0g `or' "     " %9.0g `or0' "  " %9.0g `or1' /*
			*/ in gr _col(69) "`note'" 

/* Here is where the test of homogeneity goes */

			if "`hom'"=="" {
				if "`pool'"!="" | `stdflg'==0 {
					di in smcl in gr /*
						*/ "{hline 17}{c BT}{hline 49}"
				}
				if "`suphom'"~="" {
					local tarone="tarone"
				}
				if "`pool'"!="" & "`suphom'"=="" {
					local dfm1=`df'-1
					qui replace `Sf'=sum( /*
					*/ (log(`irr')-log(`POOL'))^2/`virr')/*
					*/ in 1/`df'
					local pchi = `Sf'[`df']
					quietly summ `irr' in 1/`df'
					local cdf = r(N) - 1
					*local pval = chiprob(`dfm1',`pchi')
					local pval = chiprob(`cdf',`pchi')
					if `cdf' > 0 {
						di in gr /*
						*/ "Test of homogeneity " /*
						*/ "(direct)" _col(32) "chi2(" /*
						*/ in ye "`cdf'" in gr ") = " /*
						*/in ye %8.2f `pchi'  /*
						*/ in gr "  Pr>chi2 = " /*
						*/ in ye %6.4f /*
						*/ `pval'
						global S_26 = `cdf'
						global S_27 = `pchi'
						ret scalar df = `cdf'
						ret scalar chi2_p = `pchi'
					}
				}
				if `stdflg'==0 {
					local dfm1=`df'-1
					qui replace `Sf'=sum( /*
					*/ (log(`irr')-log(`or'))^2/`virr')/*
					*/ in 1/`df'
					local pchi = `Sf'[`df']
					quietly summ `irr' in 1/`df'
					local cdf = r(N) - 1
					*local pval = chiprob(`dfm1',`pchi')
					local pval = chiprob(`cdf',`pchi')

					if `cdf' > 0 & "`suphom'"=="" {
						di in gr /*
						*/"Test of homogeneity "   /*
						*/ "(M-H)" _col(32) "chi2(" /*
						*/in ye "`cdf'" in gr ") = " /*
						*/in ye %8.2f `pchi'  /*
						*/ in gr "  Pr>chi2 = " /*
						*/ in ye %6.4f /*
						*/ `pval'
						global S_26 = `cdf'
						global S_27 = `pchi'
						ret scalar df = `cdf'
						ret scalar chi2_p = `pchi'
					}
					if "`bd'"!="" {
						HOMOBD1 `cas' `ex' `first' /*
						*/ `use' `w', by(`by') or(`or')
						tempname
						scalar `test'= r(homo_bd)
						local bddf=r(bddf)-1
						if `bddf' > 0 {
						di in gr /*
						*/"Test of homogeneity " /*
						*/ "(B-D)" _col(32) "chi2(" /*
						*/in ye `bddf' in gr ") = " /*
						*/in ye %8.2f `test' /*
						*/in gr "  Pr>chi2 = " /*
						*/ in ye %6.4f /*
						*/ chiprob(`bddf', `test')
						ret scalar chi2_bd=`test'
						ret scalar df_bd=`bddf'
						}
					}
                                        if "`tarone'"!="" {
                                                HOMOBD1 `cas' `ex' `first' /*
                                                */ `use' `w', by(`by') or(`or')
                                                tempname
                                                scalar `test'= r(homo_t)
                                                local bddf=r(bddf)-1
                                                if `bddf' > 0 {
                                                di in gr /*
                                                */"Test of homogeneity " /*
                                                */"(Tarone)" _col(32) "chi2(" /*
                                                */in ye `bddf' in gr ") = " /*
                                                */in ye %8.2f `test' /*
                                                */in gr "  Pr>chi2 = " /*
                                                */ in ye %6.4f /*
                                                */ chiprob(`bddf', `test')
                                                ret scalar chi2_t=`test'
                                                ret scalar df_t=`bddf'
                                                }
                                        }
				}
				
			}	

			if `stdflg'==0 {
				di _n _col(20) in gr /*
				*/ "Test that combined OR = 1:" _n _col(33) /*
				*/ "Mantel-Haenszel chi2(1) =" /*
				*/ in ye %10.2f `x2' _n in gr /*
				*/ _col(49) "Pr>chi2 =" in ye /*
				*/ %10.4f chiprob(1,`x2')
			}

			ret local p        /* this is the S_2 thing */
			ret local p_exact  /* this is also the S_2 thing */
			ret local rd     
			ret local lb_rd  
			ret local ub_rd  
			ret local rr     
			ret local lb_rr  
			ret local ub_rr  
			ret local afe    
			ret local lb_afe 
			ret local ub_afe 

			ret scalar or     = `or'
			ret scalar lb_or  = `or0'
			ret scalar ub_or  = `or1'

		/* the following because of double saving in S_# and r() */
			global S_1=return(chi2)
			global S_2
			global S_3
			global S_4
			global S_5
			global S_6
			global S_7
			global S_8
			global S_9 `or'
			global S_10 `or0'
			global S_11 `or1'
			global S_12
			global S_13
			global S_14
			global S_24
                        *if "`nf'"=="error" & `stdflg'==0{
                          *di
                          *di in bl "Note: Stratum specific estimates appear"/*
                          **/    " both sides of the null value. "
                          *di in bl "      This problem may require " /*
			  * */ "standardization."
                        *}
			exit
		}
		quietly { 
			safesum `one' `w' /*
			*/ if `cas' & `ex' & `use' & `by'==`by'[`i']
			local a=r(sum)
			safesum `one' `w' /* 
			*/ if `cas' & `ex'==0 & `use' & `by'==`by'[`i']
			local b=r(sum)
			safesum `one' `w' /*
			*/ if `cas'==0 & `ex' & `use' & `by'==`by'[`i']
			local c=r(sum)
			safesum `one' `w' /*
			*/ if `cas'==0 & `ex'==0 & `use' & `by'==`by'[`i']
			local d=r(sum)
		}
		local m1=`a'+`b'
		local m0=`c'+`d'
		local n1=`a'+`c'
		local n0=`b'+`d'
		local t=`n1'+`n0'

		local or=(`a'*`d')/(`b'*`c')
		

		if `stdflg'==0 {
			local wgt=(`b'*`c')/`t'
			*local sumor=`sumor'+`wgt'*`or'
			local sumor=`sumor'+(`a'*`d')/`t'
			local sumwgt=`sumwgt'+`wgt'

			local P=(`a'+`d')/`t'
			local Q=(`b'+`c')/`t'
			local R=(`a'*`d')/`t'
			local S=(`b'*`c')/`t'
			local sumPR=`sumPR'+`P'*`R'
			local sumR=`sumR'+`R'
			local sumPSQR=`sumPSQR'+`P'*`S'+`Q'*`R'	/* sic */
			local sumS=`sumS'+`S'
			local sumQS=`sumQS'+`Q'*`S'

			local sumXnum=`sumXnum'+`a'-(`n1'*`m1')/`t'
			local sumXden=`sumXden'+/*
				*/ (`n1'*`n0'*`m1'*`m0')/((`t')^2*(`t'-1))
		}
		else {
			if "`istanda'"!="" { local wgt `c' }
			else if "`estanda'"!="" { local wgt `d' }
			else local wgt=`standar'[`i']
			local waoc=`wgt'*`a'/`c'
			local sumwgt=`sumwgt'+`waoc'
			local sumor=`sumor'+`wgt'*`b'/`d'
			local sumR=`sumR'+((`waoc')^2)*(1/`a'+1/`b'+1/`c'+1/`d')
		}

		global S_4
		ret local lb_rd		/* -ret drop- */
		if "`fast'"=="" { 

			if "`woolf'"=="" & "`cornfield'"=="" & "`tb'"=="" {
				qui cci `a' `b' `c' `d', level( `level')
				local or0=r(lb_or)
				local or1=r(ub_or)
				local label="(exact)"
			} 
			else {
				_crcor `a' `b' `c' `d' `level' `woolf' `tb' 
				local or0 = r(lb)
				local or1 = r(ub)
				local label=r(label)
			}
		}
		local lbl=`lby'[`i']
		local lbl=udsubstr("`lbl'",1,16)
		local skip=16-udstrlen("`lbl'")
		di in smcl in gr _skip(`skip') "`lbl' {c |}  " in ye /*
		*/ %9.0g `or' "     " %9.0g `or0' "  " %9.0g `or1' /*
		*/ "    " %9.0g `wgt' in gr " `label'"

		qui replace `irr'  = (`a'*`d')/(`c'*`b') in `i'
		qui replace `virr' =  1/`a'+1/`b'+1/`c'+1/`d' in `i'
		
		local pnum = `pnum'+log(`irr'[`i'])/`virr'[`i']
		local pden = `pden'+1/`virr'[`i']

		local i=`i'+1
		local df=`df'+1
	}
	/*NOTREACHED*/
end

program HOMOBD1, rclass
	syntax varlist(min=4 max=4) [fw] , BY(varname) or(string)
	tokenize `varlist'
	local cas `1'
	local ex `2'
	local first `3'
	local use `4'
	tempvar WGT one 
	quietly { 
		if "`weight'"!="" { 
			gen double `WGT' `exp' if `use'
			local w "[fweight=`WGT']"
		}
		sort `first' `by'
		gen byte `one'=1
	}
	tempname test suma sumamh sumvar
	scalar `test'=0
	scalar `suma'=0
	scalar `sumamh'=0
	scalar `sumvar'=0
	local i 1	
	while 1 { 
		quietly { 
			safesum `one' `w' /*
			*/ if `cas' & `ex' & `use' & `by'==`by'[`i']
			local a=r(sum)
			safesum `one' `w' /* 
			*/ if `cas' & `ex'==0 & `use' & `by'==`by'[`i']
			local b=r(sum)
			safesum `one' `w' /*
			*/ if `cas'==0 & `ex' & `use' & `by'==`by'[`i']
			local c=r(sum)
			safesum `one' `w' /*
			*/ if `cas'==0 & `ex'==0 & `use' & `by'==`by'[`i']
			local d=r(sum)
		}
		
		HOMOBD `a' `b' `c' `d' `or'

		if r(homo)<. {
			scalar `test'=`test'+ r(homo)
		}
		if r(amh)<. {
			scalar `sumamh'=`sumamh'+ r(amh)
		}
		if r(a)<. {
			scalar `suma'=`suma'+ r(a)
		}
		if r(var)<. {
			scalar `sumvar'=`sumvar'+ r(var)
		}
		if `test'<. {
			local bddf=`bddf'+1
		}
		local i=`i'+1
		if `first'[`i']~=1 {
			ret scalar homo_bd=`test'
			ret scalar homo_t=`test'-((`suma'-`sumamh')^2)/`sumvar'
			ret scalar bddf=`bddf'
			exit
		}
	}
	restore
end

program def HOMOBD, rclass
args A B C D rr 
        local n1=`A'+`B'
        local n0=`C'+`D'
        local m1=`A'+`C'
        tempname a b c d r1 r2 var or test
        scalar `a'=1-`rr'
        scalar `b'=`n0'-`m1'+(`m1'*`rr')+(`n1'*`rr')
        scalar `c'=-`rr'*`n1'*`m1'

        scalar `r1'=(-`b'+sqrt((`b'^2) - (4*`a'*`c') )) / (2*`a')
        scalar `r2'=(-`b'-sqrt((`b'^2) - (4*`a'*`c') )) / (2*`a')

        if `r1'<= `n1' & `r1'<= `m1' & `r1'>=0 {
                scalar `a' = `r1'
        }
        else scalar `a' = `r2'
        scalar `b'=`n1'-`a'
        scalar `c'=`m1'-`a'
        scalar `d'=`n0'-`c'
        scalar `var'=1/( (1/`a')+(1/`b')+(1/`c')+(1/`d') )
        scalar `or'=`a'*`d'/(`b'*`c')
        scalar `test' = ((`A'-`a')^2)/`var'
	ret scalar homo=`test'
	ret scalar amh = `a'
	ret scalar a = `A'
	ret scalar var = `var'
end
