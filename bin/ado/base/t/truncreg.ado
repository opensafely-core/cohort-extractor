*! version 1.9.0  14mar2018
program define truncreg, eclass byable(onecall) ///
				properties(svyb svyj svyr mi bayes)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun truncreg, mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"truncreg `0'"'
		exit
	}

	version 7, missing
	local vv : di "version " string(_caller()) ", missing:"

	if replay() {
		if "`e(cmd)'" != "truncreg" { error 301 } 
		if _by() { error 190 }
		Replay `0'
         }
	else {
		`vv' `BY' Estimate `0'
		version 10: ereturn local cmdline `"truncreg `0'"'
	}
	mac drop TRUNCREG_*
end

program define Estimate, eclass byable(recall)
	version 7, missing
	local vv : di "version " string(_caller()) ", missing:"
	syntax [varlist(fv ts)] [aweight fweight iweight pweight] [if] [in]  /*
		 */ [, LL(string) UL(string) /*
		 */ noCONstant NOLOg LOg OFFset(varname numeric)/*
		 */ Marginal   AT(string) noSKIP/*undoc*/ /*
		 */ LRMODEL SCore(string) /*
		 */  Robust CLuster(varname) Level(passthru) from(passthru) /*
		 */ moptobj(passthru) * ]
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		local vv : di "version " string(max(11,_caller())) ", missing:"
	}
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}
	_get_diopts diopts options, `options'
	mlopts mlopts, `options' `log' `nolog'
	local coll `s(collinear)'
	local constr `s(constraints)'
        if "`cluster'"~="" {
		 local clopt "cluster(`cluster')"
        }
	if ("`marginal'"=="") & (`"`at'"' ~= "") {
		local marginal "marginal"
        }			
	if ("`marginal'"!="") {
		if ("`ll'" != "") {
			cap confirm number `ll'
			if _rc {
				dis as err  /*
		*/ "limits are variables, cannot calculate marginal effects"
				exit 198
			}
		}
		if ("`ul'" != "") {
			cap confirm number `ul'
			if _rc {
				dis as err  /*
		*/ "limits are variables, cannot calculate marginal effects"
				exit 198
			}
		}
	}

	tokenize `varlist'
	_fv_check_depvar `1'
	local lhs "`1'"
	tsunab lhs : `lhs'
	mac shift
	local rhs "`*'"

	if "`offset'" != "" { local offopt "offset(`offset')" }
	if "`score'" != "" { 
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 
			local n 
		}
		tokenize `score' 
		if "`2'" == "" | "`3'" != "" {
			di as err /* 
			*/ "number of variables in score() option must be 2"
			exit 198
		}
		confirm new var `1'
		confirm new var `2'
		local scopt "score(`score')" 
	}
	if "`lrmodel'" != "" {
		_check_lrmodel, `constant' `skip' `robust' `clopt' ///
			constraints(`constr') indep(`rhs')
		local skip noskip
	}
	else if "`skip'" != "" {
                if "`robust'" != "" {
			di as txt /*
*/ "(options skip and robust inappropriate together -- skip ignored)"

	*/ "model LR test inappropriate with robust covariance estimates"
                        local skip
                }
                if "`constant'" != "" {
			di as txt /* 
*/ "(options skip and noconstant inappropriate together -- skip ignored)"
                        local skip
                }
        }
	
	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" {
		local showlog	qui
	}
	else local showlog noi	 
                                 
	tempname N_b N_a

	if "`constant'" != "" & `"`rhs'"' == "" {
di as err "independent variables required with noconstant option"
		exit 100
	}
					  /* define estimation sample */
	quietly {
	        marksample touse	
		markout `touse' `lhs' `rhs' `cluster' `wvar' `offset', strok
		//compute number of observations -- sum of weights
		if ("`weight'"!="") {
			if ("`weight'"=="pweight") { 
				//summarize does not support pweights
				local sumwgt [aweight`exp']
			}
			else {
				local sumwgt [`weight'`exp']
			}
		}
		qui summ `touse' `sumwgt' if `touse', meanonly
		scalar `N_b'= r(N)
					/* case 1, left truncated */ 
		if "`ll'" ~= "" {
		        replace `touse' = 0 if `lhs' <= `ll'
			capture confirm number `ll'
			if  _rc != 0 {
				replace `touse' = 0 if `ll'>=.
			}
			global TRUNCREG_a "`ll'"
			global TRUNCREG_flag 1
                }
					/* case -1, right truncated */
		if "`ul'" ~= "" {
			replace `touse' = 0 if `lhs' >= `ul'
			capture confirm number `ul'
			if _rc != 0 {
				replace `touse' = 0 if `ul'>= .
			}
			global TRUNCREG_b "`ul'"
			global TRUNCREG_flag -1
                }
					/* case 0, between        */
		if ("`ul'" ~="") & ("`ll'"~="") {
			global TRUNCREG_flag 0
                }
					/* case 2, regression     */
		if ("`ul'"=="") & ("`ll'"=="") {
			global TRUNCREG_flag 2
		}
		qui summ `touse' `sumwgt' if `touse', meanonly
		scalar `N_a'=r(N)
	 } 
                                          /* handle weights          */
         if "`weight'"~= "" {
	        tempvar wvar
	        qui gen double `wvar' `exp' if `touse' 
	        local weight "[`weight'`exp']"
                } 
	 if `fvops' {
		local rmcoll "version 11: _rmcoll"
	 }
	 else	local rmcoll _rmcoll
	 `rmcoll' `rhs' `weight' if `touse', `coll' `constant'
	 local rhs `r(varlist)'
	 local lhsn : subinstr local lhs "." "_"
	 di as txt "(note: " string(`N_b' - `N_a',"%12.0fc") " obs. truncated)"
                                 	/* get initial values       */
	 `vv' ///
	 Init `lhs' `rhs', touse(`touse') weight(`weight') `from' `constant' 
	 tempname b0
	 mat `b0' = r(b0)
	 local init init(`b0', `r(copy)')
					/* call ml model            */
	 if "`skip'" == "noskip" {
				/* constant only model */
	 	tempname c0
		mat `c0' = r(c0)
	 	`showlog' di
         	`showlog' di as txt "Fitting constant-only model:"
	 	local continu continue
		`vv' ///
	 	`showlog' ml model lf trunc_ll (`lhsn':`lhs'=, `offopt') /*
		*/ /sigma `weight' if `touse', search(off) /*
		*/ `robust' `clopt' nooutput max miss /*
		*/ init(`c0',copy)  nocnsnotes `mllog'
	 }
	`showlog' di
        `showlog' di as txt "Fitting full model:"

        global GLIST : all globals "TRUNCREG*"

	 `vv' ///
	 ml model lf trunc_ll (`lhs'=`rhs', `constant' `offopt') /*
		 */ /sigma    /*
		 */ `weight' if `touse', max miss `init' `continu' /*
		 */ search(off) nopreserve `mlopts' `scopt' /* 
		 */ `robust' `clopt' title("Truncated regression" ) /*
		 */ `moptobj'
	 tempname b
	 mat `b' = get(_b)
	 est scalar N_bf=`N_b'
	 est scalar sigma =`b'[1,colsof(`b')]
	 est local predict "truncr_p"
	 est local marginsok	default			///
				XB			///
				Pr(passthru)		///
				E(passthru)		///
				YStar(passthru)
	 est local k
	 est local k_dv
	 if $TRUNCREG_flag == 1 {
		est local llopt $TRUNCREG_a
         }
	 if $TRUNCREG_flag == -1 {
		est local ulopt $TRUNCREG_b
         }
	 if $TRUNCREG_flag == 0 {
		est local llopt $TRUNCREG_a
		est local ulopt $TRUNCREG_b
         }
	 est scalar k_aux = 1
		/* get mean matrix and check for dummies  */

	 if `"`rhs'"' == "" { 
         	est local cmd "truncreg"
		Replay, `level'	`marginal' `diopts'
		exit
	 }
		
	 tempname A M dum
	 qui mat ac `A'= `rhs' `weight' if `touse',   /*
	  	*/ noc means(`M')

	 matrix `dum' = `M'    /* preserve stripe info */
	 local rhs : colna `M'
	 local i 0
	 foreach v of local rhs {
		local ++i
		capture assert `v' == 0 | `v' == 1 if `touse'
		matrix `dum'[1,`i'] = (_rc==0)
	 }
	 est mat dummy `dum'
	 est mat means `M'
         est local cmd "truncreg"
	 if `"`at'"' ~= "" {
		Replay, `level' `marginal' at(`at') `diopts'
	 }
	 else {
	 	Replay, `level' `marginal'  `diopts'
	 }
end

program define Replay
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [, Level(cilevel) Marginal AT(string) *]
	_get_diopts diopts, `options'
	if ("`marginal'" =="") & (`"`at'"' ~= "") {
		local marginal "marginal"
	}
	local flag cond("`e(ulopt)'"=="", 1, -1) 
	if `flag'== -1 {
		local flag cond("`e(llopt)'"=="", -1,0)	
	}
	else local flag cond("`e(llopt)'"=="", 2, 1)
	cap confirm var `e(llopt)'
	if _rc {
		local llopt: display %10.0g `e(llopt)'
	}
	else local llopt: display %10s "`e(llopt)'" 
	cap confirm var `e(ulopt)'
	if _rc {
		local ulopt: display %10.0g `e(ulopt)'
	}
	else local ulopt: display %10s "`e(ulopt)'" 

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
	*/ bsubstr(`"`e(crittype)'"',2,.)
	local crlen = length(`"`crtype'"')
	local crlow = `crlen' - length("Limit:")

	if `e(df_m)' == 0 & "`marginal'" == "marginal" {
		local marginal
		local zwarn 1
	}

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

	if "`marginal'" =="" {
		di _n as txt `"Truncated regression"'   
		if `flag' == 1 {
			di as txt "Limit:" /*
			*/ as txt %`crlow's "lower" " = " /*
			*/ as res "`llopt'" /*
			*/ as txt _col(49) `"Number of obs"' /*
			*/ as txt _col(67) "= " as res %10.0fc e(N)
			di as txt %`crlen's "upper" " = " /*
			*/ as res "      +inf" `model'
        	}
		if `flag' == -1 {
			di as txt "Limit:" /*
			*/ as txt %`crlow's "lower" " = " /*
			*/ as res "      -inf" /*
			*/ as txt _col(49) `"Number of obs ="' /*
			*/ as txt _col(67) "= " as res %10.0fc e(N)
			di as txt %`crlen's "upper" " = " /*
			*/ as res "`ulopt'" `model'
        	}
		if `flag' == 0 {
			di as txt "Limit:" /*
			*/ as txt %`crlow's "lower" " = " /*
			*/ as res "`llopt'" /*
			*/ as txt _col(49) `"Number of obs ="' /*
			*/ as txt _col(67) "= " as res %10.0fc e(N)
			di as txt %`crlen's "upper" " = " /*
			*/ as res "`ulopt'" `model'
        	}
		if `flag' == 2 {
			di as txt "Limit:" /*
			*/ as txt %`crlow's "lower" " = " /*
			*/ as res "      -inf" /*
			*/ as txt _col(49) `"Number of obs ="' /*
			*/ as txt _col(67) "= " as res %10.0fc e(N)
			di as txt %`crlen's "upper" " = " /*
			*/ as res "      +inf" `model'
        	}
		di as txt `"`crtype' = "' as res %10.0g e(ll) `pvalue'
		di
		version 9: ml display, level(`level') noh `diopts'
	}
	else {
		if `"`at'"' =="" {	
			Margin, level(`level') at(e(means)) 
		}
		else {
			Margin, level(`level') at(`at') atuser
                }
	}
	if "`zwarn'" != "" {
		di as txt "note: no marginal effects to display -- " _c
		di as txt "coefficients displayed instead"
	}
end


program define Margin, eclass
	syntax [,Level(cilevel) AT(string) atuser]

	local flag cond("`e(ulopt)'"=="", 1, -1) 
	if `flag'== -1 {
		local flag cond("`e(llopt)'"=="", -1,0)	
	}
	else local flag cond("`e(llopt)'"=="", 2, 1)
	local llopt `e(llopt)'
	local ulopt `e(ulopt)'
	capture di _b[_cons]
	local hascons = _rc==0
	
	if "`e(offset1)'" != "" {
		tempname A M
		if `"`e(wexp)'"' != "" {
			local ww `"[`e(wtype)'`e(wexp)']"'
		}
		qui mat ac `A' = `e(offset1)' `ww' if e(sample), noc means(`M') 
		local meanoff = `M'[1,1]
		local off `"+ `meanoff'"'
	}

	tempname bm vm b V a c xmat xb 
	tempname alpha alpha2 lambda Z z s u 
	tempname f f2 f3 f4 f5 f6 J beta b0col scol dum

	mat `xmat' = `at'
	mat `b' = get(_b) 
	mat `V' = e(V) 
	scalar `a' =colsof(`b')
	scalar `s' =`b'[1,`a'] 
	scalar `c' = colsof(`xmat')
	matrix `beta' = `b'[1,1..`c']'
	mat `xb'= `xmat'*`beta' `off'
	if `hascons' {
		mat `xb' = `xb' + _b[_cons] 
	}
       	scalar `alpha' = (`llopt' - `xb'[1,1])/`s'
       	scalar `alpha2' = (`ulopt' - `xb'[1,1])/`s'

        if `flag' == 1 {
		scalar `lambda' = normd(`alpha')/(normprob(-`alpha'))
		scalar `f' = 1-`lambda'^2 + `alpha'*`lambda'
		scalar `f2' = `lambda'*(`lambda'-`alpha')
		scalar `f2' = ((-2*`lambda' + `alpha')*`f2' ///
				     + `lambda')/`s'
		scalar `f3' = `f2'*`alpha'
        }
	else if `flag' == -1 {
		scalar `lambda' = -normd(`alpha2')/(normprob(`alpha2'))
		scalar `f' = 1-`lambda'^2 + `alpha2'*`lambda'
		scalar `f2' = `lambda'*(`lambda'-`alpha2')
		scalar `f2' = ((-2*`lambda' + `alpha2')*`f2' ///
				     + `lambda')/`s'
		scalar `f3' = `f2'*`alpha2'
	}
	else if `flag' == 0 {
		scalar `lambda' = (normd(`alpha2') - normd(`alpha')) /*
		       */ /(normprob(`alpha2') - normprob(`alpha'))
		scalar `f6' = (`alpha2' - `alpha')*normd(`alpha') /   /*
                       */   (normprob(`alpha2') - normprob(`alpha'))
		scalar `f' = 1 - `lambda'^2 - `alpha2'*`lambda' - `f6'
		scalar `f4' = (`alpha2'*normd(`alpha2') - ///
			       `alpha'*normd(`alpha')) / ///
			      (normprob(`alpha2') - normprob(`alpha')) 
		scalar `f5' = (`alpha2'*`alpha2'*normd(`alpha2') - ///
			       `alpha'*`alpha'*normd(`alpha')) / ///
			      (normprob(`alpha2') - normprob(`alpha')) 
		scalar `f2' = ((2*`lambda' + `alpha2')* ///
			      (`f4'+`lambda'^2) - `lambda' + ///
			      `f6'*(`alpha' + `lambda')) / `s'
		scalar `f3' = ((`alpha2'+2*`lambda')* ///
			       (`f5'+`lambda'*`f4') - `lambda'*`alpha2' + ///
				`f6'*(`alpha'^2 - 1 + `f4')) / `s' 
	}
	else {                          /* `flag'==2 */
		scalar `f' = 1
		scalar `f2' = 0
		scalar `f3' = 0
	}

	matrix `J' = `f'*I(`c') - `f2'*`beta'*`xmat'
	if `hascons' {
		matrix `b0col' = -`f2'*`beta'
		matrix `J' = (`J', `b0col')
	}
	matrix `scol' = -`f3'*`beta'
	matrix `J' = (`J', `scol')
	mat `bm' = `f'*`b'[1,1..`c'] 
	mat `vm' = `J'*`V'*`J''
	mat `dum' = e(dummy)
					   /* display results        */
	scalar `Z' = invnorm(1-(1-`level'/100)/2)

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

	local dv = abbrev("`e(depvar)'",8) 
	di _n as txt `"Marginal effects of truncated regression"'
	di as txt "Prediction: " _c
	if `flag' == 1 {
		local ulopt .
		di as res "E(`dv' | `dv' > `llopt')
        	di as txt "Limit:   lower = " as res %10.0g `llopt' /*
		*/ as txt _col(49) `"Number of obs"' /*
		*/ as txt _col(67) "= " as res %10.0fc e(N)
		di as txt "         upper = " as res "      +inf" `model'
       	}
	if `flag' == -1 {
		local llopt . 
		di as res "E(`dv' | `dv' < `ulopt')
		di as txt "Limit:   lower = " as res "      -inf" /*
		*/ as txt _col(49) `"Number of obs"' /*
		*/ as txt _col(67) "= " as res %10.0fc e(N)
		di as txt "         upper = " as res %10.0g `ulopt' `model'
       	}
	if `flag' == 0 {
		di as res "E(`dv' | `llopt' < `dv' < `ulopt')
		di as txt "Limit:   lower = " as res %10.0g `llopt' /*
		*/ as txt _col(49) `"Number of obs"' /*
		*/ as txt _col(67) "= " as res %10.0fc e(N)
		di as txt "         upper = " as res %10.0g `ulopt' `model'
       	}
	if `flag' == 2 {
		di as res "E(`dv')" 
                di as txt "Limit:   lower = " as res "      -inf" /*
                */ as txt _col(49) `"Number of obs"' /*
		*/ as txt _col(67) "= " as res %10.0fc e(N)
                di as txt "         upper = " as res "      +inf" `model'
        }

	di as txt `"Log likelihood = "' as res %10.0g e(ll) `pvalue'
	di
	if `"`e(clustvar)'"' != "" {
		di as txt %78s /*
	      */ `"(standard errors adjusted for clustering on `e(clustvar)')"'
	}
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local space1 "    "
		local space2 "   "
	}
	if `cil' == 4 {
		local space1 "   "
		local space2 "  "
	}
	if `cil' == 5 {
		local space1 "  "
		local space2 "  "
	}
	
	di in smcl as txt "{hline 9}{c TT}{hline 68}"
	di in smcl as txt /*
		*/ %8s abbrev("`e(depvar)'",8) " {c |}" /*
		*/ _col(17) `"dF/dx"' _col(25) /*
		*/ `"Std. Err."' _col(40) `"z"' _col(45) `"P>|z|"' /*
		*/ _col(55) `"X_at"'/*
		*/ _col(62) `"[`space1'`=strsubdp("`level'")'% C.I.`space2']"' _n /*
		*/ "{hline 9}{c +}{hline 68}"

        local varlist: colnames(`bm')
	tokenize `varlist'
	local i 1
	local hasdummy 0 
	while `i' <= `c' {
		local C = `bm'[1, `i']    
		local v = `vm'[`i',`i']
		if `dum'[1,`i'] & `flag' != 2 {
			local star *
			local hasdummy 1
		}
		else {
			local star " "
		}
		local s = sqrt(`v')
		local ll = `C'-`Z'*`s'
		local ul = `C'+`Z'*`s'
		local z = `C'/`s' 
		local x = `xmat'[1,`i']

		di in smcl as txt %8s abbrev("``i''",8) "`star'{c |}  " /*
			*/ as res /*
			*/ %9.0g `C' `"  "' /*
			*/ %9.0g `s' `" "' /*
			*/ %8.2f `z'  `"  "' /*
			*/ %6.3f 2*normprob(-abs(`z')) `"  "' /* 
			*/ %8.0g `x' `"  "' /*
			*/ %8.0g `ll' `" "' /*
			*/ %8.0g `ul'
		local i=`i'+1
	}
	if "`meanoff'" != "" {
		di as txt %8s abbrev("`e(offset1)'",8) " {c |}   " _c
		di as txt "(offset)" _c
		di as res _col(52) %8.0g `meanoff'	
	}
	di in smcl as txt "{hline 9}{c BT}{hline 68}"

	if `hasdummy' {
		di as txt "(*) For dummy variables, marginal effects are " _c
		di as txt "calculated assuming the "
		di as txt "    variable is continuous. " _c
		di as txt "To obtain the discrete change from 0 to 1 "
		di as txt "    for these variables, use " _c
		local command `"mfx compute, predict(e(`llopt',`ulopt'))"'
		if "`atuser'"=="" {
			di `"{stata `command':`command'}"'
		}
		else {
			di as inp "`command' at(" _c
			di as txt "{it:atlist}" _c
			di as inp ")"
		}
	}

					/* post results		*/
	est local at 
	est mat at `xmat'
	est local dfdx 
	est mat dfdx `bm'
	est local V_dfdx 
	est mat V_dfdx `vm'
	if "`meanoff'" != "" {
		est scalar m_offset = `meanoff'
	}
end

program Init, rclass
	local vv : display "version " string(_caller()) ", missing:"
	version 7, missing
	syntax varlist(fv ts), touse(varname) [ weight(string asis ) ///
		from(string asis) noCONstant ]
	local fvops = "`s(fvops)'" == "true"

	 tempname b0 c0
	 if "`from'" == "" {
		`vv' ///
       	        qui _regress `varlist' `weight' if `touse', `constant'

		tempname b0
		mat `b0'=e(b), e(rmse)
		local copy copy
         }
	 else {
		gettoken b1 copy : from, parse(",")
		local b1 : list clean b1
		cap local nc = colsof(`b1')
		if _rc {
			di as err "matrix name required in from() option"
			exit 198
		}
		if `fvops' {
			quietly fvexpand `varlist' if `touse'
			local nc0 : word count `r(varlist)'
		}
		else {
			local nc0 : word count `varlist'
		}
		if "`constant'" == "" {
			local `++nc0'
		}
		if `nc' != `nc0' {
			di as err "from() matrix has `nc' columns, but " ///
			 "expected `nc0'"
			exit 503
		}
		local copy : list clean copy
		if "`copy'" != "" {
			gettoken comma copy: copy, parse(",")
			local copy : list clean copy
			if "`copy'"!="copy" & "`copy'"!="" {
				di as err "{p}option `copy' in "           ///
				 `"from(`from') is not allowed; use the "' ///
				 "copy option to ignore matrix column "    ///
				 "names{p_end}"
				exit 198
			}
		}
		mat `b0' = `b1'
	 }
	 mat `c0' = `b0'[1,colsof(`b0')-1..colsof(`b0')]
	 return mat b0 = `b0'
	 return mat c0 = `c0'
	 return local copy `copy'
end

exit
