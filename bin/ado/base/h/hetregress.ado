*! version 1.2.2  08jan2019
program define hetregress, eclass byable(onecall) ///
			   prop(svyb svyj svyr bayes)
	version 15
	local vv : di "version " string(_caller()) ":"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	
	`BY' _vce_parserun hetregress, mark(CLuster) : `0'

	if "`s(exit)'" != "" {
		ereturn local cmdline `"hetregress `0'"'
		exit
	}

	if replay() {
		if "`e(cmd)'" != "hetregress" {
			error 301
		}
		if _by() { 
			error 190 
		}
		`vv' Display `0'
		exit
	}
	`vv' `BY' Estimate `0'
	ereturn local cmdline `"hetregress `0'"'
end

program define Estimate, eclass byable(recall)

	syntax varlist(ts fv) [if] [in] [aweight pweight iweight fweight] [ , /*
		*/ het(varlist numeric min=1 ts fv) /*
		*/ Robust CLuster(varname numeric) /*
		*/ TWOstep MLe waldhet /*
		*/ FROM(string) noCONstant NOLOg LOg LRMODEL /*
		*/ noHETtest /*UNDOCUMENTED*/  /*
		*/ Level(cilevel) MLMethod(string) DIFficult /*
		*/ VCE(passthru) moptobj(passthru) * ]

	local vv : di "version " string(_caller()) ":"

	if "`twostep'" != "" & "`mle'" != "" {
		di as err "only one of {bf:mle} and {bf:twostep} is allowed"
		exit 198
	}

	/* check no het() */
	if "`het'" == "" {
		if "`twostep'" != "" {
			di as err "{p}option {bf:twostep} requires " ///
				"option {bf:het()}{p_end}"
			exit 198
		}
		
		if "`waldhet'" != "" {
			di as err "{p}option {bf: waldhet} requires " ///
				"option {bf:het()}{p_end}"
			exit 198
		}
		local hettest nohettest
	}

	/* force difficult option in full model */
	local diff "difficult"
	local p_vars `varlist'
	_get_diopts diopts options, `options'

	mlopts mlopt, `options' `log' `nolog'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local p_cons `constant'

	if "`mlmethod'" == "" {
		local mlmethod lf2
	}

	marksample touse

	if "`weight'" != "" { 
		local wgt [`weight'`exp'] 
	}
	if "`cluster'" != "" { 
		local clopt "cluster(`cluster')" 
	}
        _vce_parse, argopt(CLuster) opt(Robust oim opg conventional) : ///
		[`weight'`exp'], `vce' `clopt' `robust'
	local vce_err `r(vce)'
        local cluster `r(cluster)'
        local robust `r(robust)'
	if "`cluster'" != "" { 
		local clopt "cluster(`cluster')" 
	}

	if "`twostep'" != "" {
		if "`vce_err'" == "opg" {
			di as err "option {bf:vce(opg)} is not allowed " ///
				"with option {bf:twostep}"
			exit 198
		}
		if "`vce_err'" == "oim" {
			di as err "option {bf:vce(oim)} is not allowed " ///
				"with option {bf:twostep}"
			exit 198
		}	
		if "`vce_err'" == "cluster" {
			di as err "option {bf:vce(cluster `cluster')} is" ///
				" not allowed with option {bf:twostep}"
			exit 198
		}
		if "`vce_err'" == "robust" {
			di as err "option {bf:vce(robust)} is " ///
				"not allowed with option {bf:twostep}"
			exit 198
		}
	}
	else {
		if "`vce_err'" == "conventional" {
			di as err "option {bf:vce(conventional)} is not " ///
				"allowed with maximum likelihood estimation"

			exit 198 
		}
	}	

	markout `touse' `cluster' `het', strok
	`vv' ///
	_rmcoll `het' if `touse', constant `coll' expand 
	local het "`r(varlist)'"

/* Check predictor equation */
	tokenize `p_vars'
	local dep `1'
	_fv_check_depvar `dep'
	tsunab dep : `dep'
	local depn : subinstr local dep "." "_"
	mac shift
	local ind `*'
	if "`p_cons'" == "noconstant" & "`ind'" == "" {
		noi di in red "independent varlist required with " _c
		noi di in red "noconstant option"
		exit 100
	}

/* check independent variables for collinearity */
	`vv' ///
	noi _rmcoll `dep' `ind' if `touse', `p_cons' `coll' expand 
	local ind "`r(varlist)'"
	gettoken dep ind : ind
	
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'" 
	if "`log'" != "" { 
		local log quietly 
	}
	else {
		local log noisily
	}

/* output options */
	if "`robust'`cluster'" != "" | "`weight'" == "pweight" {
		local robust "robust"
	}

	if "`lrmodel'" != "" {
		_check_lrmodel, `p_cons' constraints(`cns') ///
			options(`twostep' `clopt' `robust') indep(`ind')
	}

	if "`hettest'" !="" & "`waldhet'" != "" {
		di as err "{p}option {bf:nohettest} may not be specified " ///
			"together with option {bf:waldhet}{p_end}"
		exit 198
	}

	if "`waldhet'" == "" {
		if "`robust'`cluster'" != "" | "`weight'" == "pweight" {
			local waldhet waldhet
		}
	}

	// check for -twostep- options
	if "`twostep'" != "" {
		if "`mlopt'" != "" {
			local n_opt: word count `mlopt'
			if `n_opt' == 1 {
				local errmsg "option {bf:`mlopt'} is"
			}
			else local errmsg "options {bf:`mlopt'} are"
			di as err "{p}`errmsg' not allowed with " ///
				"option {bf:twostep}{p_end}"
			exit 198
		}

		if "`wgt'" != "" {
			di as err "{p}weights are not allowed with option" ///
				" {bf:twostep}{p_end}"
			exit 198
		}
	}	
	 

	* compute full regress without heteroskedastic equation and
	* obtain the initial values

	qui regress `dep' `ind' `wgt' if `touse', `p_cons' ///
						notable noheader

	if "`twostep'" == "" {
		scalar lnsig2 = 2*log(e(rmse))
	}

	// twostep  
	tempvar res 
	qui predict double `res' if `touse', res

	qui replace `res' = log(`res'^2)
	qui regress `res' `het' if `touse'

	tempname b_het V_het
	mat `b_het' = e(b)
	mat coleq `b_het' = lnsigma2

	qui mat acc `V_het' = `het' if `touse'
		/* modify covariance matrix (Harvey 1976:463) */
	mat `V_het' = 4.9348 * invsym(`V_het')
		
		/* add 1.2704  to het:_cons (Harvey 1976:463) */
	mat `b_het'[1, colsof(`b_het')] = ///
		`b_het'[1, colsof(`b_het')] + 1.2704

	tempvar w
	qui predict double `w'
	qui replace `w' = exp(`w'+ 1.2704)

	qui regress `dep' `ind' [aw = 1/`w'] if `touse', `p_cons'

	if "`twostep'" != "" {
		local vce conventional
		local N = e(N)
	}
		
	tempname b_reg V_reg
	mat `b_reg' = e(b)
	mat coleq `b_reg' = `dep'
	mat `V_reg' = e(V)

	tempname b_all V_all
	mat `b_all' = `b_reg', `b_het'
		
	local row `=colsof(`b_reg')'
	local col `=colsof(`b_het')'
	mat `V_all' = ///
		    `V_reg', J(`row', `col', 0)\J(`col', `row',0), `V_het'

	local colname : colnames `b_all'
	local coleq : coleq `b_all'
	mat colnames `V_all' = `colname'
	mat rownames `V_all' = `colname'
	mat roweq `V_all' = `coleq'
	mat coleq `V_all' = `coleq'

	if "`twostep'" != "" {
		eret post `b_all' `V_all', dep(`dep') obs(`N') ///
			esample(`touse') buildfvinfo findomitted 
		eret local method "twostep"
		eret local vce "`vce'"
		eret local vcetype "`vcetype'" 
		eret local clustvar "`clustvar'" 
		_post_vce_rank

		tempname b
		mat `b' = e(b)
		local k : colsof `b'
		eret scalar k = `k'

		if "`ind'" != "" {
			qui test [`dep'] 
			eret scalar df_m = r(df)
			eret scalar chi2 = r(chi2)
			eret scalar p    = r(p) 
		}
		else {
			eret scalar df_m = 0
			eret scalar chi2 = . 
			eret scalar p 	 = .
		}
		eret local chi2type "Wald"

		if "`hettest'" == "" {
			qui test [lnsigma2]
			eret scalar chi2_c = r(chi2)
			eret scalar df_m_c = r(df)
			eret scalar p_c    = r(p)
			eret local chi2_ct "Wald"
		}
	}  /* end of two-step */
	else { /* ML */

		if "`hettest'" == "" & "`waldhet'" == "" {	

			mat `b_reg' = `b_reg', lnsig2
			local initreg "init(`b_reg', copy)"	

			/* fit homoskedasticity linear model */
			#delimit ;
			`vv'
			qui ml model `mlmethod' hetregress_lf2 
				(`depn': `dep' = `ind', `p_cons') 
				(lnsigma2: =  ) if `touse' `wgt',
				max missing nopreserve `mlopt'
				`continu' search(off) `diff' collinear 
				`clopt' `robust' nooutput `initreg';
			#delimit cr

			tempname ll_c
			scalar `ll_c' = e(ll) 
		}

		if "`init'" == "" {
			local init "init(`b_all', copy)"
		}

		/* constant only model */
	    	if "`lrmodel'" != "" {
			local continu "continue"

		/* starting values from regress */
			tempname p_1 p_2 Ival
			`vv' ///
			quietly regress `dep' if `touse' `wgt', `doopt' 
			capture matrix `p_1' = e(b)
			if _rc {
				local confrom ""
			}
			else {
				matrix coleq `p_1' = `dep':

				tempvar lnres2
				qui predict double `lnres2' if `touse', res
				qui replace `lnres2' = ln(`lnres2'^2)
				capture regress `lnres2' `het' if `touse'

				mat `p_2' = e(b)
					/* Harvey's (1976) adjustment */
				mat `p_2'[1, colsof(`p_2')]= ///
					`p_2'[1, colsof(`p_2')] + 1.2704
				mat coleq `p_2' = lnsigma2
				mat `Ival' = `p_1', `p_2'
				local confrom "init(`Ival', copy)"
			}
      
			`log' di _n as txt "Fitting constant-only model:"
			#delimit ;
			`vv'
			`log' ml model `mlmethod' hetregress_lf2 
				(`depn': `dep' = ) 
				(lnsigma2: = `het') 
				if `touse' `wgt', 
				`confrom' max missing nopreserve wald(0) `mlopt'
				nooutput search(off) `diff' 
				collinear ;
			#delimit cr
		}
		else {
			local continu "wald(1)"
		}

		if "`from'" != "" {
			local init "init(`from')"
		}

		`log' display _n as txt "Fitting full model:"
		#delimit ;
		`vv'
		`log' ml model `mlmethod' hetregress_lf2 
			(`depn': `dep' = `ind', `p_cons') 
			(lnsigma2: `het') if `touse' `wgt',
			max missing nopreserve `mlopt'
			`continu' search(off) `vce'
			`clopt' `robust' nooutput `init'
			title(Heteroskedastic regression model) `diff'
			collinear `moptobj';
		#delimit cr

		if "`hettest'" == "" {
			if "`waldhet'" != "" {
				qui test [lnsigma2]
				eret scalar chi2_c = r(chi2)
				eret scalar df_m_c = r(df)
				eret scalar p_c    = r(p)
				eret local chi2_ct "Wald"
			}
			else {
				eret scalar ll_c =  `ll_c'       
				eret scalar chi2_c = 2*(e(ll) - e(ll_c)) 
				if "`p_cons'" == "noconstant" {
					local fulldof = e(rank)-e(df_m)
				}
				else{ 
					local fulldof = e(rank)-e(df_m)-1
				}
				eret scalar df_m_c = `fulldof' - 1
				eret scalar p_c = chi2tail(e(df_m_c),e(chi2_c))
				eret local chi2_ct "LR"
			}
		}

		eret local method "ml"
	} /* end of ML */

	eret local title "Heteroskedastic regression model"
	if "`e(method)'" == "twostep" {
		eret local title2 "Two-step GLS estimation"
	}	
	else {
		eret local title2 "ML estimation"
	}

	eret local predict "hetregress_p"
	eret local cmd "hetregress"
	eret local marginsok XB SIGMA default
	eret local marginsnotok STDP SCores
	Display, level(`level') `hettest' `diopts' 
end

program define Display
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [, Level(cilevel) noHETtest waldhet *]

	_get_diopts diopts, `options'
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)

	di as txt _n "Heteroskedastic linear regression" _col(49) /*
		*/ "Number of obs     =" as res _col(69) %10.0gc e(N)

	di as txt "`e(title2)'"
	if !missing(e(df_r)) {	// jackknife
		di as txt _col(49) "F(" as res  %3.0f e(df_m) /*
*/		as txt "," as res %6.0f e(df_r) /*
*/ 		as txt ")" _col(67) "=" as res _col(70) /*
*/	 	%9.2f e(F)
	}	
	else if "`e(chi2type)'" == "Wald" & missing(e(chi2)) {
		di in smcl _col(49) 				/*
*/ "{help j_robustsingular##|_new:Wald chi2(`e(df_m)'){col 67}= }"	/*
*/		as res _col(70) %9.2f e(chi2)
	}
	else {	// lrmodel
		di as txt _col(49) "`e(chi2type)' chi2(" as res `e(df_m)' /*
*/ 		as txt ")" _col(67) "=" as res _col(70) %9.2f e(chi2) 
	}

	if !missing(e(df_r)) {	// jackknife
	    if "`e(method)'" != "twostep" {
		di as txt "`crtype' = " as res %9.0g e(ll) /*
		*/ as txt _col(49) "Prob > F" _col(67) "=" /*
		*/ as res _col(70) %9.4f Ftail(e(df_m), e(df_r), e(F)) _n
	    }
	    else {
		di as txt _col(49) "Prob > F" _col(67) "=" /*
		*/ as res _col(70) %9.4f Ftail(e(df_m), e(df_r), e(F)) _n
	    }	
	}
	else if "`e(method)'" != "twostep" {
		di as txt "`crtype' = " as res %9.0g e(ll) /*
		*/ as txt _col(49) "Prob > chi2" _col(67) "=" /*
		*/ as res _col(70) /*
		*/ as res %9.4f chi2tail(e(df_m),e(chi2)) _n
	}
	else {
		di as txt _col(49) "Prob > chi2" _col(67) "=" /*
		*/ as res _col(70) /*
		*/ as res %9.4f chi2tail(e(df_m),e(chi2)) _n
	}

	if "`e(method)'" == "twostep" {
		_coef_table, level(`level') `diopts'
	}
	else ml di, noheader level(`level') `diopts' nofoot

	if "`hettest'" != "" exit 

	local chi : di %8.2f e(chi2_c)
	local chi = trim("`chi'")

	if "`e(chi2_ct)'" == "Wald" {
		di as txt "Wald test of lnsigma2=0: " ///
		"chi2(" as res "`e(df_m_c)'" as txt ") = " as res "`chi'" ///
		as txt _col(59) "Prob > chi2 = " as res %6.4f ///
		chi2tail(e(df_m_c),e(chi2_c))
	}
	else if "`e(chi2_ct)'" == "LR" {	
		if "`waldhet'" != "" {
			tempname chi2_c_wald df_m_c_wald p_c_wald
			qui test [lnsigma2]
			scalar `chi2_c_wald' = `r(chi2)'
			scalar `df_m_c_wald' = r(df)
			scalar `p_c_wald'    = r(p)
			local chi2 : di %8.2f `r(chi2)'
			local chi2 = trim("`chi2'")
			di as txt "Wald test of lnsigma2=0: " ///
			          "chi2(" as res `df_m_c_wald' as txt ") = " as res "`chi2'"  ///
			          as txt _col(59) "Prob > chi2 = " ///
			          as res %6.4f chi2tail(`df_m_c_wald',`r(chi2)')
		}
		else {
			di as txt "LR test of lnsigma2=0: " ///
			"chi2(" as res "`e(df_m_c)'" as txt ") = " as res "`chi'" ///
			as txt _col(59) "Prob > chi2 = " as res %6.4f ///
			chi2tail(e(df_m_c),e(chi2_c))
		}
	}
	ml_footnote
end
exit


