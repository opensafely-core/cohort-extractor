*! version 1.3.0  14mar2018
program etpoisson, eclass byable(onecall) properties(svyb svyj svyr)
	version 13.0
	local vv : display "version " string(_caller()) ":"
	if _by() {
                local BY `"by `_byvars'`_byrc0':"'
	}
	`vv' `BY' _vce_parserun etpoisson, jkopts(eclass) noeqlist: `0'
        if "`s(exit)'" != "" {
                ereturn local cmdline `"etpoisson `0'"'
                exit
        }
        if replay() {
		if "`e(cmd)'" != "etpoisson" {
			error 301
		}
		else {
			Display `0'
                }
		exit
	}
	`vv' capture noisily `BY' Estimate `0'
        if _rc {
                local myrc = _rc
                exit `myrc'
        }
end

program Estimate, eclass byable(recall) sortpreserve
	version 13.0
	local vv : display "version " string(_caller()) ":"
	syntax varlist(fv ts numeric) [if] [in] 			/*
			*/ [fweight aweight iweight pweight], 		/*
			*/ [TReat(string)         			/*
			*/ noCONstant					/*
			*/ EXPosure(varname numeric ts)			/*
			*/ OFFset(varname numeric ts) 			/*
			*/ CONSTraints(numlist integer >=1 <=1999) 	/*
			*/ INTMethod(string) 	    /*UNDOCUMENTED*/    /*
			*/ INTPoints(string) 				/*
			*/ from(string)					/*
			*/ IRr						/*
			*/ vce(string)					/*
			*/ TECHnique(string)				/*
			*/ *]	// display,reporting and maximization
	
	//1. check syntax
	// check treat option		 
	capture assert "`treat'" != ""
	if (_rc) {
		di in smcl as error "option {bf:treat()} required"
		exit 198
	}		
	local cmdline etpoisson `0'		
	if ("`exposure'" != "" & "`offset'" != "") {
		opts_exclusive "exposure() offset()"
	}
	mlopts mlopts rest, `options'
	_get_diopts diopts, `rest'
		 	
	capture assert inlist("`intmethod'","","gh","ghe", ///
			"gher","gherm","ghermi","ghermit","ghermite")
	if (_rc) {
		di as error "{bf:intmethod()} invalid;"
		di as error ///
		"only Gauss-Hermite quadrature integration supported"
		exit 198 
	}
	else if ("`intmethod'" == "") {
		local intmethod `ghermite'
	}
	if ("`intpoints'" == "") {
		local intpoints 24
	}
	capture confirm integer number `intpoints'
	local rc = _rc
	capture assert `intpoints' > 1 & `intpoints' < 129
	local rc = `rc' | _rc
	if (`rc') {
		di as error "{bf:intpoints()} must be " ///
			    "an integer greater than 1"  ///
			    " and less than 129"
		exit 198 
	}

	marksample touse
	
	//expand sw
	gettoken binend fop : treat, parse(" =,")
	gettoken fop swl : fop, parse(" =,")
	if ("`fop'" == ",") {
		local swl `fop' `swl'
		Parseswl2 `swl'
		local swl 
		local swoffset `r(swoffset)'
		local swconstant `r(swconstant)'
		if ("`swoffset'" != "") {
			local swoffset offset(`swoffset')
		}	
	}	
	else {
		capture assert "`fop'" == "="
		if (_rc) {
			capture assert "`swl'" == "" & "`fop'" == ""
			if (_rc) {
				// treat list is not empty
				local s {bf:treat()} syntax is (endogenous 
        			local s `s' variable = treat
				local s `s' variables)
				di in smcl as error `"`s'"'
				exit 198
			}
		}
		// swl contains switching variables and perhaps
		// offset and noconstant
		if ("`swl'" != "") {
			Parseswl `swl'
			local swl `r(swl)'
			local swoffset `r(swoffset)'
			local swconstant `r(swconstant)'
			if ("`swoffset'" != "") {
				local swoffset offset(`swoffset')
			}	
		}
	}
	
	fvexpand `binend' if `touse'
	tokenize `r(varlist)'
	_ms_parse_parts `1'
	if (inlist("`r(type)'", "factor", "interaction")) {
		di in smcl as error ///
			"endogenous treatment cannot be factor variable"
		exit 198
	}
	
	// check that dependent variable is not factor variable	
	gettoken depvar mlist : varlist
	fvexpand `depvar' if `touse'	
	tokenize `r(varlist)'
	_ms_parse_parts `1'
	local rtsop `r(ts_op)'
	capture assert !inlist("`r(type)'", "factor", "interaction") 
	if (_rc) {
		di as error "depvar cannot be factor variable"
		exit 198
	}

	// finish marking sample	
	markout `touse' `binend' `swl' `offset' `exposure'
	
	capture assert inlist(`binend',0,1) if `touse'
	if (_rc) {
		di as error "endogenous treatment variable must be 0/1"
		exit 198
	}	

	//binend	binary endogenous regressor
	//swl 		regressors for probit regression of binend
	//depvar	dependent variable
	//mlist		regressors for dependent variable
	// remove binend from mlist if it is present


	capture assert `depvar' >= 0 
	if (_rc) {
		di as error "`depvar' must be greater than or equal to zero"
		exit 459
	} 

	capture assert round(`depvar',1) == `depvar'
	if (_rc) {
             	di as error "`depvar' must be an integer"
		exit 459
	}

	local omlist `mlist'
	local mlist: list mlist - binend
	if "`omlist'" != "`mlist'" {
		di in green "{p 0 3 2}treatment `binend' automatically added to outcome dependent variable list{p_end}"
	}
	// handle constraints
	if ("`constraints'" != "") {
		mlopts cmlopts, constraints(`constraints')
		local constraints constraints(`s(constraints)')
	}
	if ("`exposure'" != "") {
		local exposure exposure(`exposure')
	}
	if ("`offset'" != "") {
		local offset offset(`offset')
	}	
	
	// 2. set final estimation options
	if (!inlist("`vce'","","oim","robust","opg")) {  
		_parse_covmat `"`vce'"' "vce" `touse'
	}
	if ("`weight'" == "pweight" & "`vce'" == "") {
		local vce robust
	}  
	if ("`vce'" != "") {
		local vce vce(`vce')
	}
	if ("`technique'" == "bhhh") {
		local vce vce(opg)
	}
	if ("`technique'" != "") {
		local technique technique(`technique')
	}

	// 3. initial values
	tempvar lfy
	qui gen double `lfy' = lngamma(`depvar'+1) if `touse'
	local wexp `weight'`exp'
	if ("`wexp'" != "") {
		local wexp [`wexp']
	}
	if ("`from'" != "") {
		local from init(`from')  search(on) 
	}
	// if from() not specified, following will be used
	tempname tb tb2
	if("`weight'" == "aweight") {
		qui glm `depvar' `mlist' i.`binend' if `touse' `wexp', 	///
			`constraints' family(poisson) link(log)	///
			`offset' `exposure' 			///
			`constant'
		matrix `tb' = e(b)
		qui glm `binend' `swl' if `touse' `wexp', 	    ///
			`constraints' family(binomial) link(probit) ///
			`swoffset' `exposure' 			    ///
			`constant' `swconstant'
		matrix `tb2' = e(b)	
	}
	else {
		qui poisson `depvar' `mlist' i.`binend' if ///
			`touse' `wexp',     ///
			`constraints' `offset' `exposure' 	    ///
			`constant'
		matrix `tb' = e(b)			
		qui probit `binend' `swl' if `touse' `wexp', 	 ///
			`swoffset' `constraints' `swconstant'
		matrix `tb2' = e(b)
	}

	tempname initmat
	tempname rhoinit
	matrix `initmat' = (.1,1)
	if _caller() < 15 {
		matrix colnames `initmat' = athrho:_cons lnsigma:_cons  
	}
	else {
		matrix colnames `initmat' = /athrho /lnsigma
	}
	matrix `initmat' = (`tb',`tb2',`initmat')
	if ("`from'" == "") {
		local from init(`initmat',copy) search(off)
	}		
	
	// 4. fit model
	nobreak {		
		mata: _etpoisson_init(	"inits", ///
				"`lfy'","`intpoints'", "`touse'")
		capture noisily break  {
		`vv' ///
		ml model lf2 _etpoisson_lf2()  			///
			(`depvar':`depvar'=`mlist' i.`binend', 	///
				`constant' `offset' `exposure')	///
	   (`binend': `binend' =`swl', `swconstant' `swoffset') ///
			/athrho /lnsigma if `touse' `wexp', 	///
			maximize `mlopts' `constraints' `vce' 	///
			`from' `technique' nopreserve	///
			userinfo(`inits') 			///
			diparm(athrho, tanh label("rho"))	///
			diparm(lnsigma, exp label("sigma"))     
		}
	}
	local erc = _rc
	capture mata: rmexternal("`inits'")
	if (`erc') {
		exit `erc'
	}
	// 5. Return results
	ereturn repost
	ereturn scalar N = e(N)
	ereturn scalar k = e(k)
	ereturn scalar k_eq = e(k_eq)
	ereturn scalar k_eq_model = e(k_eq_model)
	ereturn scalar k_aux = 2
	ereturn scalar k_dv = e(k_dv)
	ereturn scalar df_m = e(df_m)
	ereturn scalar ll = e(ll)
	if (e(N_clust) != .) {
		ereturn scalar N_clust = e(N_clust)
	}
	ereturn scalar chi2 = e(chi2)
        ereturn local chi2_ct "Wald"
	if `:colnfreeparms e(b)' {
        	qui test _b[/athrho] = 0
	}
	else {
	        qui test [athrho]_cons = 0
	}
        ereturn scalar chi2_c = r(chi2)	
	ereturn scalar p = e(p)
	ereturn scalar p_c = chiprob(1, e(chi2_c))
	ereturn scalar rank = e(rank)
	ereturn scalar ic = e(ic)
	ereturn scalar rc = e(rc)
	ereturn scalar converged = e(converged)

	ereturn hidden local switch `binend'
	ereturn hidden local response `depvar'
	ereturn hidden local intpoints `intpoints'
	ereturn hidden local intmethod `intmethod'

	ereturn hidden local swl `swl'
	ereturn hidden local mlist `mlist'
	ereturn hidden local marginsprop nochainrule

	ereturn local marginsok default POMean OMean TIrr xb XBTreat pr(passthru) te cte
	ereturn local predict etpoisson_p
	ereturn local properties `e(properties)'
	ereturn local technique `e(technique)'
	ereturn local user `e(user)'
	ereturn local ml_method `e(ml_method)'
	ereturn local which `e(which)'
	ereturn local opt `e(opt)'
	ereturn local vcetype `e(vcetype)'
	ereturn local vce `e(vce)'
	ereturn local chi2_ct `e(chi2_ct)'
	ereturn local  chi2type `e(chi2type)'
	ereturn local offset2 `e(offset2)'
	ereturn local offset1 `e(offset1)'
	ereturn local clustvar `e(clustvar)'
	ereturn scalar n_quad = `intpoints'
	ereturn local title2 "(`e(intpoints)' quadrature points)"
	ereturn local title "Poisson regression with endogenous treatment"
	ereturn local wexp "`e(wexp)'"
	ereturn local wtype "`e(wtype)'"
	ereturn local depvar `depvar' `binend'
	ereturn local cmdline `cmdline'
	ereturn local cmd etpoisson
	Display, `irr' `diopts'
end

program Display
	syntax, [IRr *]
	ml display, `irr' `options'
	local testtyp Wald
        di in gr  "`testtyp' test of indep. eqns. (rho = 0):" /*
                 */ _col(38) "chi2(" in ye "1" in gr ") = "   /*
                 */ in ye %8.2f e(chi2_c)                     /*
                 */ _col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
        exit e(rc)
end

program Parseswl, rclass
syntax varlist(fv ts numeric), [OFFset(varlist) noConstant]
tokenize `offset'
capture assert "`2'" == ""
return local swl `varlist'
return local swoffset `offset'
return local swconstant `constant'
end

program Parseswl2, rclass
syntax, [OFFset(varlist) noConstant]
tokenize `offset'
capture assert "`2'" == ""
return local swoffset `offset'
return local swconstant `constant'
end


exit

