*! version 1.10.1  19dec2018
program define zinb, eclass byable(onecall) ///
		prop(ml_score irr svyb svyj svyr bayes)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	
	qui version 6.0: syntax [anything] [if] [in] [fw aw pw iw], ///
		[INFlate(string) *]
	if `"`inflate'"' == "_cons" {
		`BY' _vce_parserun zip, ///
		   mark(EXPosure OFFset CLuster) : `0'
	}
	else {
		`BY' _vce_parserun zip, ///
		   mark(INFlate EXPosure OFFset CLuster) : `0'
	}
	
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"zinb `0'"'
		exit
	}

	version 6.0, missing
	if replay() {
		if "`e(cmd)'" != "zinb" { error 301 }
		if _by() { error 190 }
		Display `0'
		if e(vuong)<. {
			DispV
		}
		_prefix_footnote
		exit
	}
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"zinb `0'"'
end

program define Estimate, eclass byable(recall)
	local vv : di "version " string(_caller()) ":"
	version 6.0, missing
	local cmd "`0'"

	local awopt = cond(_caller()<7,"aw","")
	#delimit ;
	syntax varlist(fv) [if] [in] [fweight `awopt' pweight iweight/] 
		 , INFlate(string) [ noCONstant Robust CLuster(varname) 
		   SCore(string) IRR Level(cilevel) FROM(string)
		   MLMETHOD(string) OFFset(varname numeric) PROBIT
		   EXPosure(varname numeric) NOLOg LOg ZIP VUONG NBREG
		   CRITTYPE(passthru) VCE(passthru) moptobj(passthru)
		   forcevuong *] ;
	#delimit cr

	local fvops1 = "`s(fvops)'" == "true" | _caller() >= 11
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	if "`nbreg'" != "" {		/* -nbreg- option for backwards */
		local vuong "vuong"	/* compatibility */
		local nbreg
	}
	marksample touse
	markout `touse' `cluster', strok
	/* also see 2nd markout below */

	tokenize `varlist'
	local dep "`1'"
	_fv_check_depvar `dep'
	mac shift
	local ind "`*'"

	if "`score'" != "" { 
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 `score'3 
			local n 3
		}
		if `n' != 3 {
			di in red /*
			*/ "score(): you must specify three new variables"
			exit 198
		}
	}

	if "`weight'" != "" {
		local wtexp "[`weight'=`exp']"
		local wtype "`weight'"
		if ( "`wtype'" != "fweight" ) & ("`forcevuong'" != "") {
		 di in red "forcevuong may not be specified with `wtype's" 
		 exit 499
		}		
	}
	else    local exp 1

	local nc  "`constan'"

	_get_diopts diopts options, `options'
	local diopts `diopts' level(`level') `irr'
	mlopts mlopt, `options' `log' `nolog'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local mlopt `mlopt' `crittype'

        if "`cluster'" != "" {
                local clopt "cluster(`cluster')"
        }
        _vce_parse, argopt(CLuster) opt(Robust oim opg) old: ///
                `wtexp', `vce' `clopt' `robust'
	local vceopt  `r(vceopt)'
        local cluster `r(cluster)'
        local robust `r(robust)'	

	if ( "`robust'`cns'" != "" ) & ("`forcevuong'" != "") {
		di in smcl as err "{p 0 6 0 `pararg'}The Vuong " /*
		*/ "statistic cannot be computed with constraints(), " /*
		*/ "vce(cluster), or vce(robust){p_end}" 
		exit 499
	}

	if "`vuong'" != "" {
		di in smcl as err "{p}"
		di in smcl as err "Vuong test is not appropriate for "
		di in smcl as err ///
			"testing {help j_vuong##_new:zero-inflation}."
		di in smcl as err ///
		"  Specify option {bf:forcevuong} to perform the test anyway."
		di in smcl as err "{p_end}"
		exit 498
	}
	else if "`forcevuong'" != "" {
		local vuong vuong
	}


	PrseInf `inflate'
	local inflate "`s(inflate)'"
	local off2 "`s(off2)'"
	local nc2 "`s(nc2)'"
	if "`off2'" != "" {
		local off2a "offset(`off2')"
		local off2s "`off2'"
	}
	local fvops2 = "`s(fvops)'" == "true"

        if "`exposur'" != "" {
                tempvar off
                qui gen double `off' = ln(`exposur') if `touse'
                local offo "offset(`off')"
                local offstr "ln(`exposur')"
        }

	if "`offset'" != "" {
		if "`offstr'" != "" {
			di in red "cannot specify both exposure() and offset()"
			exit 198
		}
		tempvar off
		gen double `off' = `offset' if `touse'
                local offo "offset(`off')"
		local moff "-`off'"
		local poff "+`off'"
		local eoff "*exp(`off')"
                if "`offstr'" == "" {
                        local offstr "`offset'"
                }
	}

	markout `touse' `inflate' `off2' `off' 

	if `fvops1' | `fvops2' {
		local rmcoll "`vv' _rmcoll"
		local mm e2
		local negh negh
	}
	else {
		local rmcoll _rmcoll
		local mm d2
	}
	`rmcoll' `ind' if `touse' `wtexp', `nc' `coll'
	local ind "`r(varlist)'"
	`rmcoll' `inflate' if `touse' `wtexp', `nc2' `coll'
	local inflate "`r(varlist)'"

	if `fvops1' {
		quietly fvexpand `ind' if `touse'
		local ind `"`r(varlist)'"'
	}
	if `fvops2' {
		quietly fvexpand `inflate' if `touse'
		local inflate `"`r(varlist)'"'
	}
	
	// calculate correct df
	local df 0
	foreach var of local inflate {
		_ms_parse_parts `var'
		if !`r(omit)' {
			local ++df
		}
	}
	
	if "`nc2'" == "" { local df = `df'+1 }

	if "`mlmetho'" == "" { local mlmetho "`mm'" }

	if "`score'" != "" {
		local svar1 : word 1 of `score'
		local svar2 : word 2 of `score'
		local svar3 : word 3 of `score'
		confirm new variable `score'
		tempvar sc1 sc2 sc3
		local scopt "score(`sc1' `sc2' `sc3')"
	}

	qui count if `dep'<0 & `touse'
	if r(N) { 
		di in red "`dep'<0 in `r(N)' obs."
		exit 459
	}

	qui { 
		if "`wtype'" != "fweight" {
			count if `touse'
			local nobs = r(N)

			count if `touse' & `dep'==0
			local nzero = r(N)
		
		} 
		else {
			summ `dep' `wtexp' if `touse', meanonly
			local nobs = r(N)

			summ `dep' `wtexp' if `touse' & `dep'==0, meanonly
			local nzero = r(N)
		}
	}


	if `nzero'==`nobs' {
		di in red "`dep' never varies; always equal to zero"
		exit 459
	}
	if `nzero'==0 {
		di in bl _n "(note: " in ye "`dep'" /*
			*/ in bl " never equal to zero; use nbreg instead)"
	}
/* Now calculate Vuong2 which uses separately estimated negative binomial. */

	if "`vuong'" != "" {
    	   qui { 
		nbreg `dep' `ind' `wtexp' if `touse', `offo'
    
		tempvar xbp2 muhat2 phatp2
		tempname alphan

    		predict double `xbp2' if `touse', xb

    		scalar `alphan'=1/exp(_b[/lnalpha]) /* This alpha-1 
							for nbreg */
    		gen double `muhat2'=exp(`xbp2') if `touse'

    		gen double `phatp2'=(exp( lngamma(`dep'+`alphan')) /*
			*/ /(exp(lnfact(`dep'))*exp(lngamma(`alphan'))) )  /*
			*/ *( (`alphan'/(`alphan'+`muhat2'))^`alphan') /*
			*/ *( (`muhat2'/(`alphan'+`muhat2'))^`dep') if `touse'
	    }
	}


	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" == "" { local log "noisily" }
	else             { local log "quietly" }

	qui {
                if "`probit'" == "" {
                        local binprog "logit"
                        local lfprog  "zinb_llf"
                }
                else {
                        local binprog "probit"
                        local lfprog  "zinb_plf"
                }

		if ("`nbreg'" != "" & "`robust'" == "") | "`nc'" != "" {
			`log' di in gr _n "Fitting nbreg model:"
			`vv' ///
			`log' nbreg `dep' `ind' `wtexp' if `touse', /*
				*/ `offo' nodisplay `nc'
			if "`nc'`cns'" == "" {
				local llp = e(ll) 
				local llpp = e(ll_c)
			}
			else {
				if "`from'" == "" {
					tempname from
					mat `from' = get(_b)
				}
			}
		}

		if "`zip'"!="" & "`robust'`cns'" == "" {
                        local inflt "`inflate'"
                        if "`inflt'"=="" {
                                local inflt "_cons"
                        }
			`log' di in gr _n "Fitting zip model:"
			`vv' ///
			`log' zip `dep' `ind' `wtexp' if `touse', /*
				*/ `offo' inflate(`inflt') nodisplay `nc'
			local llpoi = e(ll)
		}


		if "`nc'" == "" & ("`cns'" == "" | "`from'" == "") {

			tempname beta0
                        if "`wtype'" != "" {
                                summ `dep' if `touse' [aweight=`exp']
                        }
                        else    summ `dep' if `touse'
                        local num = ln(r(mean))
                        if "`off'" != "" {
                                summ `off' if `touse'
                                local num = `num' - r(mean)
                        }

                        mat `beta0' = (`num',0)
			if _caller() < 15 {
                        	mat colnames `beta0' = `dep':_cons lnalpha:_cons
			}
			else {
                        	mat colnames `beta0' = `dep':_cons /lnalpha
			}

			`log' di in gr _n "Fitting constant-only model:"
			#delimit ;
			`vv'
			`log' ml model `mlmetho' `lfprog'
				(`dep': `dep' = , `offo')
				(inflate: `inflate', `off2a' `nc2')
				/lnalpha
				if `touse' `wtexp', wald(0) 
				collinear missing max nooutput nopreserve 
				`mlopt' search(off) init(`beta0') `robust'
				nocnsnotes `negh' ;
			#delimit cr
			local ll0 "lf0(1 `e(ll)')"
			if "`from'" == "" {
				tempname from
				mat `from' = get(_b)
			}
		}
		`log' di in gr _n "Fitting full model:"
	}
	#delimit ;
	`vv'
	`log' ml model `mlmetho' `lfprog'
		(`dep': `dep' = `ind', `nc' `offo')
		(inflate: `inflate', `off2a' `nc2')
		/lnalpha
		if `touse' `wtexp', 
		collinear missing max nooutput nopreserve `mlopt'
		title(Zero-inflated negative binomial regression) 
		`scopt' `vceopt'
		init(`from') search(off) `ll0'
		diparm(lnalpha, exp label("alpha")) `negh' `moptobj' ;
	#delimit cr

	if "`vuong'" != "" {
	   qui {
		tempvar xbp muhat psihat prhat mi xbz
		tempname alphaz

    		_predict double `xbp' if `touse', xb eq(#1) 
		      /* Get neg bin based prediction */

    		gen double `muhat'=exp(`xbp') if `touse'

    		_predict double `xbz' if `touse', xb eq(#2) 
			/* get prediction of 
			zero from zinb equation */

    		scalar `alphaz'=1/exp(_b[/lnalpha]) /* This alpha-1 
							for zinb */
    		if "`lfprog'"=="zinb_llf" {
			gen double `psihat'=1/(1+exp(-`xbz')) if `touse'
    		}
    		else {
			gen double `psihat'=normprob(`xbz') if `touse'
    		}

		/* now get predicted probabilities for zinb */

    	
    	   	gen double  `prhat'=`psihat'+(1-`psihat')*( /*
			*/ (`alphaz'/(`alphaz'+`muhat'))^`alphaz') if `touse'

    	   	replace `prhat'=(1-`psihat')*(exp( lngamma(`dep'+`alphaz')) /*
		   	*/ /(exp(lnfact(`dep'))*exp(lngamma(`alphaz'))) )  /*
		   	*/ *( (`alphaz'/(`alphaz'+`muhat'))^`alphaz') /*
		   	*/ *( (`muhat'/(`alphaz'+`muhat'))^`dep') /*
	           	*/ if `dep'>0 & `dep'<. & `touse'

	/* calculate m for Vuong stat.  NOTE: zip is on top so numbers 
    	greater that 1.96 favor zip and number less than -1.96 favor poisson.*/
    
    		gen double `mi'=ln(`prhat'/`phatp2') if `touse'

		tempname N meanm stdm V2

    		summ `mi' `wtexp' if `touse'
    		scalar `N'=r(N)
    		scalar `meanm'=r(mean)
    		scalar `stdm'=sqrt( r(Var) )

    		scalar `V2'=( sqrt(`N') * `meanm')/`stdm'

    		estimates scalar vuong=`V2'

	   }

	}

        if "`score'" != "" { 
		rename `sc1' `svar1' 
		rename `sc2' `svar2' 
		rename `sc3' `svar3' 
		est local scorevars `svar1' `svar2' `svar3'
	}
	// calculate correct df_m
	local coln : colfullnames e(b)
	local dfm 0
	foreach name of local coln {
		tokenize `name', parse(":")
		if "`1'" == "`dep'" {
			if "`3'" != "_cons" {
				_ms_parse_parts `3'
				// constraints are not marked as omitted
				if !r(omit) {
					local dfm = `dfm' + ///
					cond(_b[`3']==0 & _se[`3']==0,0,1)
				}
			}
		}
	}
	est local cmd
	est scalar N_zero = `nzero'
	est scalar df_m = `dfm'
	est hidden scalar df_c = `df'
	est scalar k_aux = 1
	if "`llpoi'" != "" { 
		est scalar ll_cp = `llpoi'
		tempname cc
		scalar `cc' = abs(-2*(e(ll_cp)-e(ll)))
		est scalar chi2_cp = cond(`cc'<1e-5,0,`cc') 
		est local chi2_cpt "LR"
	}
	est local offset
	est local offset1 "`offstr'"
	est local offset2 "`off2s'"
	est local inflate "`binprog'"
	est local predict "zip_p"
        est local cmd     "zinb"
        Display, `diopts'
	if "`vuong'" != "" {
		DispV
	}
	_prefix_footnote
end


program define Display
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [, Level(cilevel) IRr *]

	_get_diopts diopts, `options'
	DispHd
	di
	version 9: ml di, noheader level(`level') `irr' nofootnote `diopts'
	DispLR
end

program define DispLR
	if "`e(ll_cp)'" != "" {
		tempname pval
                scalar `pval' =  chiprob(1, e(chi2_cp))*0.5
                if e(chi2_cp)==0 { scalar `pval'= 1 }
                if ((e(chi2_cp) > 0.005) & (e(chi2_cp)<1e4)) | (e(chi2_cp)==0) {
                        local fmt "%8.2f"
                }
                else    local fmt "%8.2e"
                di in green "Likelihood-ratio test of alpha=0: " _c
                di in green in smcl "{help j_chibar##|_new:chibar2(01) = }" /*
                        */ in ye `fmt' e(chi2_cp) _c
                di in green " Pr>=chibar2 = " in ye %7.4f /*
                        */ `pval'
	}
end

program define DispV
	di in green "Vuong test of zinb vs. standard negative binomial: " /* 
		    */ in green "z = "in ye %8.2f e(vuong) /*
		    */ in green "  Pr>z = " /*
		    */ in ye %6.4f normprob(-e(vuong))
	local v The Vuong test is not appropriate for testing
	local v `v' {help j_vuong##_new:zero-inflation}
	di in smcl as text "{p 0 4 2}Warning: `v'.{p_end}" 
end

program define DispHd
	if !missing(e(df_r)) {
		local model _col(49) as txt "F(" ///
			as res %3.0f e(df_m) as txt "," ///
			as res %6.0f e(df_r) as txt ")" _col(67) ///
			"= " as res %10.2f e(F)
		local pvalue _col(49) as txt "Prob > F" _col(67) ///
			"= " as res %10.4f Ftail(e(df_m),e(df_r),e(F))
	}
	else {
		if "`e(chi2type)'" == "" {
			local chitype Wald
		}
		else	local chitype `e(chi2type)'
		local model _col(49) as txt `"`chitype' chi2("' ///
			as res e(df_m) as txt ")" _col(67) ///
			"= " as res %10.2f e(chi2)
		local pvalue _col(49) as txt "Prob > chi2" _col(67) ///
			"= " as res %10.4f chiprob(e(df_m),e(chi2))
	}
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)
	#delimit ;
	local infl "Inflation model" ;
	local crlen = max(length("`infl'"),length(`"`crtype'"')) ;
	di in gr _n "`e(title)'" _col(49) "Number of obs" _col(67) "= "
		in ye %10.0fc e(N) ;
	di in gr _col(49) "Nonzero obs" _col(67) "= "
		in ye %10.0fc e(N) - e(N_zero) ;
	di in gr _col(49) "Zero obs" _col(67) "= "
		in ye %10.0fc e(N_zero) _n ;
	di in gr %-`crlen's "`infl'" " = " in ye "`e(inflate)'" `model' ;
	di in gr %-`crlen's "`crtype'" " = " in ye %9.0g e(ll) `pvalue' ;
	#delimit cr
end

program define PrseInf, sclass

	local 0 : subinstr local 0 "_cons" "", word
	local 0 : subinstr local 0 "_cons," ",", word
	syntax [varlist(default=none fv)] [, noCONstant OFFset(varname numeric)]
	local fvops = "`s(fvops)'" == "true"
	sret clear
	sret local inflate "`varlist'"
	sret local off2 "`offset'"
	sret local nc2 "`constan'"
	sret local fvops = cond(`fvops', "true", "")
end

exit

----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
     mpg |        IRR   Std. Err.       z     P>|z|       [95% Conf. Interval]
   price |   .9999179   .0000564     -1.455   0.146       .9998073    1.000029
  weight |   .9982906   .0001933     -8.833   0.000       .9979118    .9986697

Zero-inflated negative binomial regression        Number of obs   =         74
                                                  Nonzero obs     =         
                                                  Zero obs        =         

                                                  Wald chi2(1)    =      30.69
Log likelihood = -130.26465                       Prob > chi2     =     0.0000

