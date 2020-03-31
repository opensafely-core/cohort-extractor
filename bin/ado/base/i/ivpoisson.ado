*! version 1.2.2  29aug2017
program ivpoisson, eclass byable(onecall) sortpreserve
	version 13.0
	local vv : di "version " string(_caller()) ":"
	if _by() {
                local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun ivpoisson, jkopts(eclass) noeqlist: `0'
        if "`s(exit)'" != "" {
                ereturn local cmdline `"ivpoisson `0'"'
                exit
        }

        if replay() {
		if "`e(cmd)'" != "ivpoisson" {
			error 301
		}
		Display `0'
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

	local ivpoissoncmd ivpoisson `0'

        local estimator : word 1 of `0'
        local 0 : subinstr local 0 "`estimator'" ""
	
        CheckEstimator `estimator'
        local estimator `=s(estimator)'

	// factor variable settings
	if(`"`r(designlist)'"' != "") {
		local wc: word count `r(varlist)'
		local asbalanced
		local asobserved
		forvalues i = 1/`wc' {
			local w: word `i' of `r(designlist)'
			local wv: word `i' of `r(varlist)'
			if ("`w'" == "asbalanced") {
				local asbalanced `asbalanced' `wv'
			}
			else if ("`w'" == "asobserved") {
				local asobserved `asobserved' `wv'
			}
		}
	}	
	// Portions of syntax parsing code are from ivreg.ado	ivprobit.ado
        local n 0

	// lhs takes the first token (parsing on " "), rest takes 
	// the rest of 0
        gettoken lhs rest : 0

	// make sure dependent variable not a factor variable
	qui capture _fv_check_depvar `lhs'
	if (_rc==198) {
		di as error "dependent variable may not be a factor variable"
		exit 198
	}
	else if (_rc==111) {
                di as error "variable `lhs' not found."
                exit 111
	}	
	
	// from ivprobit  
        gettoken lhs 0 : 0, parse(" ,[") match(paren)
        IsStop `lhs'
        if `s(stop)' { 
                error 198 
        }  
        while `s(stop)'==0 {
                if "`paren'"=="(" {
                        local n = `n' + 1
                        if `n'>1 {
				local s syntax is (all instrumented 
				local s `s' variables = instrument variables)
                                capture noi error 198
				di as error `"`s'"'
                                exit 198
                        }
                        gettoken p lhs : lhs, parse(" =")
                        while "`p'"!="=" {
                                if "`p'"=="" {
                                        capture noi error 198
	                                local s syntax is (all instrumented
        	                        local s `s' variables = instrument
					local s `s' variables)
					di as error `"`s'"''
					di as error `"the = is required"'
                                        exit 198
                                }
                                local end`n' `end`n'' `p'
                                gettoken p lhs : lhs, parse(" =")
                        }
                        fvunab end`n' : `end`n''
                        fvunab exog`n' : `lhs'			    
                }
                else {
                        local exog `exog' `lhs'
                }
                gettoken lhs 0 : 0, parse(" ,[") match(paren)
                IsStop `lhs'
        }
        local 0 `"`lhs' `0'"'
	local lhs

	// parse remaining syntax
	// some display options will be parsed later
	syntax [if] [in] [aw fw iw pw] [, 	/*
		*/ ADDitive			/* Model options
		*/ MULTiplicative		/*
	        */ TWOstep                      /*
                */ ONEstep                      /*
                */ Igmm                         /*
                */ WMATrix(string)             	/* Weight Matrix
                */ Center                       /*
                */ WINITial(string)             /*
		*/ VCE(string)			/* SE/Robust
   	        */ Level(cilevel)               /* Reporting, _get_diopts later
		*/ FROM(string)			/*
                */ IGMMITerate(passthru)        /*
                */ igmmeps(passthru)            /*
                */ igmmweps(passthru)           /*
		*/ IRr 				/*  display ir ratios
		*/ EXposure(varname numeric)	/*
		*/ OFFset(varname numeric) 	/*
		*/ noConstant			/*
		*/  *] 				/* other display options */
		
	if "`end1'" == ""  & "`estimator'" == "cfunction" {
		di as error "control-function estimation requires at least" ///
		" one endogenous variable"
		exit 198
	}

	if ("`exposure'" != "" & "`offset'" != "") {
		opts_exclusive "exposure() offset()"
	}	
	if ("`additive'" != "" & "`irr'" != "") {
		di in smcl as error ///
			"{bf:irr} not appropriate under additive errors"
			exit 198
	}		

	// default to additive
	if ("`estimator'" == "gmm" & "`additive'`multiplicative'" == "") {
		local additive additive
	}
	
		// check parsed syntax

	// model options
	capture assert "`additive'" == "" if "`estimator'" == "cfunction"
	if (_rc) {
		di in smcl as error ///
"cannot specify {bf:additive} for {bf:cfunction} estimator"
		exit 198
	}

	capture assert "`multiplicative'" == "" if "`estimator'" == "cfunction"
	if (_rc) {
		di in smcl as error ///
"cannot specify {bf:multiplicative} for {bf:cfunction} estimator"
		exit 198
	}
	
	if `:word count `additive' `multiplicative'' > 1 {
		di in smcl as error ///
			"can specify only one of additive, multiplicative"
		exit 198
	}

	if `:word count `onestep' `twostep' `igmm'' > 1 {
                di in smcl as error ///
			"can specify only one of {bf:onestep}, " ///
			"{bf:twostep}, or {bf:igmm}"
                exit 198
        }

        if "`estimator'"== "gmm" & "`onestep'`twostep'`igmm'" == "" {
                local twostep twostep           // default is twostep
        }
	else if "`estimator'"=="cfunction" & "`onestep'`twostep'`igmm'"=="" {
		local onestep onestep
	}

	_parse_igmm_options, `igmm' `igmmiterate' `igmmeps' `igmmweps'
        if "`igmm'" != "" {
		local igmmiterate = `s(igmmiterate)'
		local igmmeps = `s(igmmeps)'
		local igmmweps = `s(igmmweps)'
        }
	_parse_gmm_optim_opts, `options'
	local options `s(options)'
	local technique `s(technique)'
	local conv_maxiter `s(conv_maxiter)'
	local conv_ptol `s(conv_ptol)'
	local conv_vtol `s(conv_vtol)'
	if "`technique'" != "gn" {
		local conv_nrtol `s(conv_nrtol)'
	}
	local tracelevel `s(tracelevel)'

	// now weight matrices
	// will pass whole arguments into gmm
	// but will check for time series/panel specification, 
	// which is  not allowed first
	// hac forbidden
   	if "`onestep'" != "" & "`wmatrix'" != "" {
                di in smcl as error                     ///
                    "cannot specify {bf:wmatrix()} with one-step estimator"
                exit 198
        }

        // Parse weight matrix and VCE
        if "`wmatrix'" == "" & "`vce'" != "" {
                _parse_covmat `"`vce'"' "vce" `touse'
                local vcetype   `s(covtype)'
                local vceclvar  `s(covclustvar)'
                local vcehac    `s(covhac)'
                local vcehaclag `s(covhaclag)'
                local vceopts   `s(covopt)'
		// independent not allowed
		capture assert "`vceopts'" == ""
		if (_rc) {
			di in smcl as error 		///
				"option {bf:vce()} incorrectly specified"
			exit 198
		}

                // set wmat to vce 
                local wmatrixtype   `vcetype'
                local wmatrixclvar  `vceclvar'
                local wmatrixhac    `vcehac'
                local wmatrixhaclag `vcehaclag'
                local wmatrixopts        `vceopts'

		capture assert "`vcehac'`vcehac1lag'" == ""
		if (_rc) {
			di in smcl as error		///
				"`vcetype' invalid vcetype in vce()"
			exit 198
		}
        }
        else if "`wmatrix'" != "" & "`vce'" == "" {
                _parse_covmat `"`wmatrix'"' "wmatrix" `touse'
                local wmatrixtype   `s(covtype)'
                local wmatrixclvar  `s(covclustvar)'
                local wmatrixhac    `s(covhac)'
                local wmatrixhaclag `s(covhaclag)'
                local wmatrixopts   `s(covopt)'
                capture assert "`wmatrixopts'" == ""
                if (_rc) {
			di in smcl as error 		///
				"option {bf:wmatrix()} incorrectly specified"
			exit 198
                }
                // set vce to wmat 
                local vcetype   `wmatrixtype'
                local vceclvar  `wmatrixclvar'
                local vcehac    `wmatrixhac'
                local vcehaclag `wmatrixhaclag'
                local vceopts   `wmatrixopts'
		capture assert "`wmatrixhac'`wmatrixhac1ag'" == ""
		if (_rc) {
			di in smcl as error 		///
				"ption {bf:wmatrix()} incorrectly specified"
			exit 198
		}
        }
        else if "`wmatrix'" != "" & "`vce'" != "" {
                _parse_covmat `"`vce'"' "vce" `touse'
                local vcetype   `s(covtype)'
                local vceclvar  `s(covclustvar)'
                local vcehac    `s(covhac)'
                local vcehaclag `s(covhaclag)'
                local vceopts   `s(covopt)'
                capture assert "`vceopts'" == ""
                if (_rc) {
                        di in smcl as error "{p 0 4 2}{bf:`vce'} invalid " ///
				"argument to {bf:vce()}, allowed " ///
				"arguments are {bf:robust}, " ///
				"{bf:cluster clustvar}, or " ///
				"{bf:unadjusted}{p_end}"
                        exit 198
                }
                _parse_covmat `"`wmatrix'"' "wmatrix" `touse'
                local wmatrixtype   `s(covtype)'
                local wmatrixclvar  `s(covclustvar)'
                local wmatrixhac    `s(covhac)'
                local wmatrixhaclag `s(covhaclag)'
                local wmatrixopts   `s(covopt)'
                capture assert "`wmatrixopts'" == ""
                if (_rc) {
			di in smcl as error 		///
				"option {bf:wmatrix()} incorrectly specified"
			exit 198
                }
		capture assert "`vcehac'`vcehac1lag'" == ""
		if (_rc) {
			di in smcl as error		///
				"`vcetype' invalid vcetype in vce()"
			exit 198
		}
		capture assert "`wmatrixhac'`wmatrixhac1ag'" == ""
		if (_rc) {
			di in smcl as error 		///
				"option {bf:wmatrix()} incorrectly specified"
			exit 198
		}
        }
        else {
                local vcetype "robust"
                local wmatrixtype "robust"
        }
	if ("`estimator'" == "cfunction" & "`vcetype'" == "unadj") {
		di as error "{p 0 4 2}unadjusted not allowed in {bf: vce()}" ///
				" for {bf: ivpoisson cfunction}{p_end}"
		exit 198
	}

	// noconstant
        if "`constant'"=="noconstant" {
                local nvar : word count `exog'
                if `nvar' == 1 {
                        di in red "independent variables required with " /*
                        */ "noconstant option"
                        exit 100
                }
        }

	// mark sample
	marksample touse

	markout `touse' `exog' `end1' `inst'

	// now check that clustering is handled 
     	if "`wmatrixclvar'" != "" | "`vceclvar'" != "" {
        	if "`wmatrixclvar'" != "" & "`vceclvar'" != "" {
                	if "`wmatrixclvar'" != "`vceclvar'" {
                        	di in smcl as error ///
					"cannot specify different " ///
					"cluster variables in " ///
					"{bf:wmat()} and " ///
					"{bf:vce()}"
                                exit 498
                        }
                }
                if "`wmatrixclvar'" != "" {
                        markout `touse' `wmatrixclvar', strok
                }
                else {
                        markout `touse' `vceclvar', strok
                }
        }
        if "`exposure'"!="" {
                capture assert `exposure' > 0 if `touse'
                if _rc {
                        di as error "{bf:exposure()} must be greater than zero"
                        exit 459
                }
                tempvar offset
                qui gen double `offset' = ln(`exposure')
                local offvar "ln(`exposure')"
        }

        if "`offset'"!="" {
                markout `touse' `offset'
                local offopt "offset(`offset')"
                if "`offvar'"=="" {
                        local offvar "`offset'"
                }
        }

        if "`weight'" == "pweight" {
                if "`wmatrixtype'" != "cluster" &  ///
                        "`wmatrixtype'" != "robust" & "`onestep'" == "" {
                        if "`wmatrixtype'" != "unadj" {
                                local saywhat `wmatrixtype'
                        }
                        else {
                                local saywhat unadjusted
                        }
                        di as err ///
                          "cannot use `saywhat' weight matrix with pweights"
                        exit 404
                }
                if "`vcetype'" != "cluster" &                           ///
                        "`vcetype'" != "robust" & "`onestep'" != "" {
                        if "`vcetype'" != "unadj" {
                                local saywhat `vcetype'
                        }
                        else {
                                local saywhat unadjusted
                        }
			di as err "cannot use `saywhat' VCE with pweights " ///
					"and one-step estimator"
                        exit 404
                }
        }

	if "`winitial'" != "" {
        	ParseWinit `"`winitial'"'
		if ("`s(winitopts)'" == "independent" & ///
			"`estimator'" != "cfunction")  {
			di as err ///
"{bf:independent} not allowed in {bf:winitial()} in {bf:ivpoisson gmm}"
			exit 198
		}
        }


	// will make another call to syntax shortly
	// so save information
	local IF: copy local if
        local IN: copy local in
        local WEIGHT: copy local weight
        local EXP: copy local exp
	
		// get reporting/display options through get_diopts
	_get_diopts diopts, `options'
	
	// Besides display options, `options' is empty.
	// otherwise _get_diopts would cause an error.
        // they are, now parse them 
        local 0 ",`diopts'"
        syntax [,                       ///
                NOLSTRETCH              ///
                LSTRETCH                ///
                cformat(string)         ///
                sformat(string)         ///
                pformat(string)         ///
		OMITted			///
		NOOMITted		///	
		VSQuish			///
		BASElevels		///
		ALLBASElevels		///
		NOEMPTYcells		///
		EMPTYcells		///	
                ]
	
	// save sample back, touse variable is still ok
        local if: copy local IF
        local in: copy local IN
        local weight: copy local WEIGHT
        local exp: copy local EXP
	
        fvexpand `exog' if `touse'
        local exog "`r(varlist)'"
	tokenize `exog' 
	local lhs `1'
	local 1 
	macro shift
	local exog `*'

        fvexpand `exog1' if `touse'
        local exog1 "`r(varlist)'"
	
        fvexpand `end1' if `touse'
        capture assert "`end1'" == "`r(varlist)'"
	if (_rc) {
		di as error "endogenous regressors cannot be factor variables"
		exit 198
	}
	
        // Eliminate vars from `exog1' that are in `exog'
        Subtract inst : "`exog1'" "`exog'"

        //Collinearity checking

	//normalized weights	
        // Here we generate weights and sample size that are suitable 
        // for use within Mata, since it does not differentiate
        // between fw, aw, pw, or iw
        tempvar normwt 
        if `"`exp'"' != "" {
                qui gen double `normwt' `exp' if `touse'
                if "`weight'" == "aweight" | "`weight'" == "pweight" {
                        qui summ `normwt' if `touse', mean                   
                        qui replace `normwt' = r(N)*`normwt'/r(sum)
                }
                local wtexp `"[`weight' `exp']"'
                summ `normwt' if `touse', mean
                if "`weight'" == "iweight" {
                        local normN = trunc(r(sum))
                }
                else {
                        local normN = r(sum)
                }
        }
        else {
                qui gen double `normwt' = 1 if `touse'
                qui count if `touse'
                local normN = r(N)
        }
	// final checks on dependent variable
        summarize `lhs' [iw=`normwt'] if `touse', meanonly

        if r(N) == 0 { 
		error 2000 
	}
        if r(N) == 1 { 
		error 2001
	}

        if r(min) < 0 {
                di as error "`y' must be greater than or equal to zero"
                exit 459
        }
        if r(min) == r(max) & r(min) == 0 {
                di as error "`y' is zero for all observations"
                exit 498
        }
	// collinearity checks
	CheckCollin `lhs' if `touse' [iw=`normwt'],     ///
		endog(`end1') exog(`exog')              ///
                inst(`inst') `constant' 
        local endog `s(endog)'
	local exog `s(exog)'
	local inst `s(inst)'
	local fvops `s(fvops)'
        local tsops `s(tsops)'
	
	if "`endog'" == ""  & "`estimator'" == "cfunction" {
		di as error "Control-function estimation requires at least" ///
		" one endogenous variable"
		exit 198
	}

	// temporary variables in for factor and omitted variables
	// in fvrendog fvrexog, and fvrinst
	// backups in oexog, oendog, and oinst
	
	fvrevar `exog'
	local oexog `exog'
	local fvrexog `r(varlist)'
	fvrevar `endog'
	local oendog `endog'
	local fvrendog `r(varlist)'
	fvrevar `inst'
	local oinst `inst'
	local fvrinst `r(varlist)'

	// collinearity check done
	//now, on temporary variables..
	
	// take omitted, base case temporary variables out of fvr*
	// create exog, endog, and inst as this list
	// rexog, rendog, and rinst are the originally named variables
	local masl exog endog inst
	foreach v of local masl {
		local f`v'
		local r`v'
		local wc`v': word count `o`v''
		forvalues i=1/`wc`v'' {
			local a: word `i' of `o`v''
			_ms_parse_parts `a'
			if (r(base) != .) {
				local base = r(base)
			}
			else {
				local base = 0
			}
			if (r(omit) != .) {
				local omit = r(omit)
			}	
			else {
				local omit = 0
			}
			if !(`omit' | `base') {
				local b: word `i' of `fvr`v''
				local f`v' `f`v'' `b'
				local r`v' `r`v'' `a'
				if ("`r(type)'" != "variable") {
					// for later renaming
					// of results
					local o`b'_o `a'
				}	
			}			
		}
		local `v' `f`v''
	}

	// syntax checked
	// from syntax will be checked within gmm call
	// we do this previous checking to forbid certain behaviors
	// like panel/ts
	if("`weight'" != "") {
		local wexp [`weight'`exp']
	}
	local rparcnt: word count `exog' `endog'
	if ("`constant'" != "noconstant") {
		local rparcnt = `rparcnt' + 1
	}

	if ("`estimator'"== "cfunction" & "`winitial'" == "") {
		local winitial unadjusted, independent
	}
		
	local comargs technique(`technique')    ///
		`twostep'			/// 			
		`onestep'			///
		`igmm'				///
		wmatrix(`wmatrix')		///
		`center'			///
		winitial(`winitial')		///
		vce(`vce')			///	
		level(`level')			///
		igmmiterate(`igmmiterate')	///
		igmmeps(`igmmeps')		///
		igmmweps(`igmmweps')		///
		conv_ptol(`conv_ptol')		///
		conv_vtol(`conv_vtol')		///
		conv_nrtol(`conv_nrtol')	///
		conv_maxiter(`conv_maxiter') 	///
		tracelevel(`tracelevel')	///
		`offopt'			///
		`constant'			///
		fiterlogonly			///
		mustconverge
		
	if ("`estimator'"!= "cfunction") {	
		local proguse 		
		if ("`additive'"!= "") {
			local proguse _ivpoisson_add
		}
		if ("`multiplicative'" != "") {
			local proguse _ivpoisson_mult
		}
		
		// initial values
		if(`"`from'"' == "") {
			qui count if `lhs' <= 0 & `touse'
			local nonm = r(N)
			qui count if `touse'
			local frac = `nonm'/r(N)
			tempvar loglhs
			qui gen double `loglhs' = ln(`lhs') if `touse'
			if ("`offset'" != "") {
				qui replace `loglhs' = `loglhs'-`offset' ///
					if `touse'
			}
			if "`endog'" != "" {
				qui capture ivregress 2sls ///
				`loglhs' `exog' ///
				(`endog'=`inst') if `touse' `wexp', ///
				`constant'
			}
			else {
				qui capture glm ///
				`lhs' `exog' ///
				if `touse' `wexp', ///
				`constant' `offopt' ///
				link(log) family(poisson)
			}
			
			if (!_rc) {
				tempname fram
				matrix `fram' = e(b)
				local b = colsof(`fram')
				local from `fram'
				ereturn clear
			}
		}
		local cnstmp
		if ("`constant'" != "noconstant") {
			local cnstmp _cons
		}
		gmm `proguse' if `touse' `wexp', 		///
			rhs(`endog' `exog') lhs(`lhs') 		///
			equations(`lhs')			///
			nequations(1) nparameters(`rparcnt') 	///
			parameters(`endog' `exog' `cnstmp') 	///
			instruments( `exog' `inst') 		///
			from(`from')				///
			`comargs'				///
			hasderivative				///
		

		// Each parameter is its own "equation" rename here
		// Rename a copy, not the param vector we are using,
		tempname b V touse2 eVm init
		qui gen byte `touse2' = e(sample)
		matrix `b' = e(b)
		matrix `V' = e(V)
		tempname checkmat
		capture matrix `checkmat' = e(init)
		if ! (`checkmat'[1,1] == . & ///
			(colsof(`checkmat') == 1 & rowsof(`checkmat') == 1)) {
			capture matrix `init' = e(init)		
		}					 
		local params `rendog' `rexog' 
		if ("`constant'" != "noconstant") {
			local params `params' _cons
		}
		foreach x of local params {
			local params2 `params2' `lhs':`x'
		}
		matrix rownames `V' = `params2'
		matrix colnames `V' = `params2'
		matrix colnames `b' = `params2'
		capture matrix colnames `init' = `params2'
		if ("`e(vcetype)'"== "Robust") {
			capture matrix `eVm' = e(V_modelbased)				
			matrix rownames `eVm' = `params2'
			matrix colnames `eVm' = `params2'
		}
		
		//params2 were the correctly named parameters
		//without omitted variables
		
		//now create the b,V,init,V_modelbased results
		//for omitted variables	
		local fparams `oendog' `oexog'
		if ("`constant'" != "noconstant") {				
			local fparams `fparams' _cons
		}
		local wc: word count `fparams'
		tempname b1 V1 V1M init1 
		matrix `b1'  = J(1,`wc',0)
		matrix `V1'  = J(`wc',`wc',0)	
		
		local fparams2
		foreach x of local fparams {
			local fparams2 `fparams2' `lhs':`x'
		}
		matrix rownames `V1' = `fparams2'
		matrix colnames `V1' = `fparams2'
		
		if("`e(vcetype)'"== "Robust") {
			matrix `V1M' = J(`wc',`wc',0)
			matrix rownames `V1M' = `fparams2'
			matrix colnames `V1M' = `fparams2'
		}			
		
		matrix colnames `b1' = `fparams2'

		capture qui di colsof(`init') 
		if !_rc {
			matrix `init1' = J(1,`wc',0)
			matrix colnames `init1' = `fparams2'
			matrix rownames `init1' = y1
		}		
		foreach x of local params2 {
			matrix `b1'[1,colnumb(`b1',"`x'")] = ///
				`b'[1,colnumb(`b',"`x'")]
			capture qui di colsof(`init') 
			if !_rc {
				capture	matrix ///
					`init1'[1,colnumb(`b1',"`x'")] = ///
					`init'[1,colnumb(`b',"`x'")]	
			}	
			foreach y of local params2 {
				matrix `V1'[colnumb(`V1',"`x'"), ///
					colnumb(`V1',"`y'")] = ///
					`V'[colnumb(`V',"`x'"), ///
					colnumb(`V',"`y'")] 
				if("`e(vcetype)'"== "Robust") {
					matrix `V1M'[colnumb(`V1M',"`x'"), ///
						colnumb(`V1M',"`y'")] = ///
					`eVm'[colnumb(`eVm',"`x'"), ///
					colnumb(`eVm',"`y'")] 				
				}
			}
		}			
		
		//renames W and S columns and rows as appropriate
		tempname checkmat eW eS
		local masl W S
		foreach x of local masl {
			capture matrix `checkmat' = e(`x')
			if ! (`checkmat'[1,1] == . & ///
				(colsof(`checkmat') == 1 & ///
				rowsof(`checkmat') == 1)) {
				matrix `e`x'' = e(`x')
				local f: colnames `e`x''
				local fnu
				foreach word of local f {
					local l = 0
					capture local l = length("`o`word'_o'")
					if (`l' > 0) {
						local fnu `fnu' `o`word'_o'
					}
					else {
						local fnu `fnu' `word'
					}
				}
				matrix colnames `e`x'' = `fnu'
				matrix rownames `e`x'' = `fnu'
			}
		} 
	}
	else {
		//control function estimator
		
		local proguse _ivpoisson_cmult	
	
	        if("`weight'" == "pweight" | "`weight'" == "iweight") {
        	        local awexp [aweight `exp']
		}
		else {
			local awexp `wexp'
		}
		
		// get multivariate regression residuals to use as instruments
		qui mvreg `endog' = `exog' `inst' if `touse' `awexp'
		local resids
		local i = 1
		foreach var of varlist `endog' {
			tempvar resid`i'
			qui predict double  `resid`i''      ///
				if e(sample), equation(`var') ///
				residuals
			local resids `resids' `resid`i''
			local i = `i' + 1			
		}
		if ("`from'" == "") {
			tempname bmvreg bpois bfrom
			matrix `bmvreg' = e(b)
			if("`weight'" == "aweight") {
				local ewexp [iweight `exp']
			}
			else {
				local ewexp `wexp'
			}
			qui poisson `lhs' `exog' `endog' `resids' if ///
				`touse' `ewexp', `constant' `offopt'
			matrix `bpois' = e(b)
  			tempname swci swcr
			local wci: word count `exog' `endog'
			scalar `swci' = `wci'
			local wcr: word count `resids'
			scalar `swcr' = `wcr'
			local bcons
			if ("`constant'" != "noconstant") {
				tempname bcons
				scalar `bcons' = _b[_cons]
			}
			mata: _cfunction_init("`bfrom'","`bpois'","`bmvreg'","`bcons'","`swci'","`swcr'")
			local from `bfrom'
		}
		
		// define instruments for linear regression equations
		local endogcnt: word count `endog'
		local equationcnt = 2*`endogcnt'+1
		local arginst 
		foreach var of local endog {
			local arginst `arginst' ///
				instruments(`var': `exog' `inst')
		}
		// define parameters
		local vl `exog' `endog'
		local j = 1
		foreach var of local vl  {
			local gmmparams `gmmparams' exp_`j'
			local j = `j' + 1
		}
		if ("`constant'" != "noconstant") {
			local gmmparams `gmmparams' exp_cons
		}
		local i = 1
		local j = 1
		foreach var of local endog {
			local evl `exog' `inst'
			foreach evar of local evl  {
				local gmmparams `gmmparams' end_`i'_`j'
				local j = `j' + 1
			}
			local gmmparams `gmmparams' end_`i'_cons
			local i = `i' + 1
		}
		local j = 1 
		local ceqn
		local ceqninst
		foreach var of local endog {
			local gmmparams `gmmparams' ctrl_`j'
			local ceqn `ceqn' ctrl_`j'
			local ceqninst `ceqninst' ///
				instruments(ctrl_`j': `resid`j'', noconstant)
			local j = `j' + 1
		}

		local wcer: word count `gmmparams'
		// set parameter count reflecting control estimation
		local rparcnt: word count `gmmparams'
		gmm `proguse' if `touse' `wexp',			///
			lhs(`lhs') endog(`endog')			///
			exog(`exog') zinst(`inst')			///	
			nequations(`equationcnt')			///
			equations(`lhs' `endog' `ceqn')			///
			instruments(`lhs': `exog' `endog',`constant')	///
			`arginst'					///
			`ceqninst'					///
			parameters(`gmmparams')				///
			hasderivatives					///
			from(`from')					///
			`comargs'
			
	
		// Each parameter is its own "equation" rename here
		// Rename a copy, not the param vector we are using,
		tempname b V touse2 eVm init
		qui gen byte `touse2' = e(sample)
		matrix `b' = e(b)
		matrix `V' = e(V) 
		tempname checkmat
		capture matrix `checkmat' = e(init)
		if ! (`checkmat'[1,1] == . & ///
			(colsof(`checkmat') == 1 & rowsof(`checkmat') == 1)) {
			matrix `init' = e(init)		
		}			
		if("`e(vcetype)'"== "Robust") {			
			matrix `eVm' = e(V_modelbased)		
		}						
				
		// params has the original names before temp variables used
		// from rexog and rendog
		// these correspond to e(b), omitted variables are missing,
		// etc.
		local params
		local vl `rexog' `rendog'
		foreach var of local vl {
			local params `params' `lhs'_`var'
		}
		if ("`constant'" != "noconstant") {
			local params `params' `lhs'_cons		
		}
				
		foreach var of local rendog {
			local evl `rexog' `rinst'
			foreach evar of local evl {
				local params `params' `var'_`evar'
			}
			local params `params' `var'_cons
		}
		foreach var of local rendog {
			local params `params' control_`var'
		}

		
		// now original params, including omitted 
		local oparams
		local vl `oexog' `oendog'
		foreach var of local vl {
			local oparams `oparams' `lhs'_`var'
		}
		if ("`constant'" != "noconstant") {
			local oparams `oparams' `lhs'_cons
		}
		foreach var of local oendog {
			local evl `oexog' `oinst'
			foreach evar of local evl  {
				local oparams `oparams' `var'_`evar'
			}
			local oparams `oparams' `var'_cons
		}
		foreach var of local oendog {
			local oparams `oparams' control_`var'
		}

		
		// and for final matrices
		local noparams
		local evl `oexog' `oendog'
		foreach var of local evl {
			local noparams `noparams' `lhs':`var'
		}
		if ("`constant'" != "noconstant") {
			local noparams `noparams' `lhs':_cons
		}
		foreach var of local oendog {
			local evl `oexog' `oinst'
			foreach evar of local evl  {
				local noparams `noparams' `var':`evar'
			}
			local noparams `noparams' `var':_cons
		}
		foreach var of local oendog {
			local abvar `var'
			local l = ustrlen("`var'")
			if (`l' == 32) {
				local abvar = usubstr("`var'",1,29) 
			}	
			if _caller() < 15 {
				local noparams `noparams' c_`abvar':_cons
			}
			else {
				local noparams `noparams' /c_`abvar'
			}
		}

		local wc: word count `noparams'
		tempname b1 V1 V1M init1
		matrix `b1'  = J(1,`wc',0)
		capture qui di colsof(`init') 
		if !_rc {
			matrix `init1' = J(1,`wc',0)
			matrix colnames `init1' = `noparams'
			matrix rownames `init1' = y1
		}	
		
		if("`e(vcetype)'"== "Robust") {
			matrix `V1M' = J(`wc',`wc',0)
			matrix rownames `V1M' = `noparams'
			matrix colnames `V1M' = `noparams'
		}

		matrix `V1'  = J(`wc',`wc',0)
		matrix rownames `V1' = `noparams'
		matrix colnames `V1' = `noparams'
		matrix colnames `b1' = `noparams'
		
		foreach x of local params {
			wordindex, word(`x') str(`oparams')
			local colnumb1 = r(ind)
			wordindex, word(`x') str(`params')
			local colnumB1 = r(ind)
			matrix `b1'[1,`colnumb1'] = ///
				`b'[1,`colnumB1']
			capture qui di colsof(`init') 
			if !_rc {				
				capture matrix `init1'[1,`colnumb1'] = ///
					`init'[1,`colnumB1']			
			}		
			foreach y of local params {
				wordindex, word(`y') str(`oparams')
				local colnumb2 = r(ind)
				wordindex, word(`y') str(`params')
				local colnumB2 = r(ind)				
				matrix `V1'[`colnumb1', ///
					`colnumb2'] = ///
					`V'[`colnumB1', ///
					`colnumB2'] 
				if ("`e(vcetype)'"== "Robust") {
					matrix `V1M'[`colnumb1', ///
						`colnumb2'] = ///
					`eVm'[`colnumB1', ///
					`colnumB2'] 				
				}
			}
		}
		//renames W and S columns and rows as appropriate
		tempname checkmat eW eS
		local masl W S
		foreach x of local masl {
			capture matrix `checkmat' = e(`x')
			if ! (`checkmat'[1,1] == . & ///
				(colsof(`checkmat') == 1 & ///
				rowsof(`checkmat') == 1)) {
				matrix `e`x'' = e(`x')
				local f: colfullnames `e`x''
				local fnu
				local endcnt: word count `endog'
				foreach word of local f {
					local goon = 0
					local i = 1
					tokenize `resids'
					while `i' <= `endcnt' {
						if ("`word'" == ///
							"ctrl_`i':``i''") {
							local endit: ///
								word `i' ///
								of `endog'
							local ar `endit'
							local l = ///
								ustrlen("`ar'")
							if (`l' == 32) {
						local ar=usubstr("`ar'",1,29) 
							}	

	if _caller() < 15 {
		local fnu `fnu' c_`ar':_cons
	}
	else {
		local fnu `fnu' /c_`ar'
	}

							local goon = 1
							local i = `endcnt'
						}
						local i = `i'+1
					}
					if (`goon' == 0) {		
						tokenize `word', parse(":")
						local l = 0
						capture local l = ///
							length("`o`3'_o'")
						if (`l' > 0) {
							local fnu ///
							`fnu' `1':`o`3'_o'
						}
						else {
							local fnu `fnu' `word'
						}
					}
				}
				matrix colnames `e`x'' = `fnu'
				matrix rownames `e`x'' = `fnu'
			}
		}
	}

	// save gmm results 
	// scalars
	tempname eN eQ eJ eJ_df eN_clust erank eic econverged en_moments
	capture scalar `eN' = e(N)
	capture scalar `eQ' = e(Q)
	capture scalar `eJ' = e(J)
	capture scalar `eJ_df' = e(J_df) 
	capture scalar `eN_clust' = e(N_clust)
	capture scalar `erank' = e(rank)
	capture scalar `eic' = e(ic)
	capture scalar `econverged' = e(converged)
	capture scalar `en_moments' = e(n_moments)
		
	//macros
	local eclustvar `e(clustvar)'
	local ewinit `e(winit)'
	local ewinitname `e(winitname)'
	local egmmestimator `e(estimator)'
	local ewmatrix `e(wmatrix)'
	local evce `e(vce)'
	local evcetype `e(vcetype)'
	local etechnique `e(technique)'
	local einst_1 `e(inst_1)'
	local etitle `e(title)'
	local ewexp "`e(wexp)'"
        local ewtype `e(wtype)'
		
	//matrices
	tempname eWuser eV_modelbased checkmat
	capture matrix `checkmat' = e(Wuser)
	if ! (`checkmat'[1,1] == . & ///
		(colsof(`checkmat') == 1 & rowsof(`checkmat') == 1)) {
		matrix `eWuser' = e(Wuser)
	}
	capture qui di colsof(`V1M') 
	if !_rc {
		matrix `eV_modelbased' = `V1M'
	}	
	ereturn post `b1' `V1', esample(`touse2') buildfvinfo
	capture ereturn hidden scalar n_moments = `en_moments'
	capture ereturn scalar N = `eN' 
        tempname beb
        matrix `beb' = e(b)
        ereturn scalar k = colsof(`beb')
        if("`estimator'" == "cfunction") {
                local wc: word count `oendog'
		ereturn scalar k_eq = 1 + 2*`wc'
		ereturn scalar k_aux = `wc'
		ereturn scalar k_dv = 1 + `wc'
        }
        else {
                ereturn scalar k_eq = 1
		ereturn scalar k_dv = 1
        }
	capture ereturn scalar Q = `eQ'
	capture ereturn scalar J = `eJ' 
	if ("`eJ_df'" != "") {
		if (`eJ_df' != .) {
			capture ereturn scalar J_df = `eJ_df'
		}
	}
	if ("`eN_clust'" != "") {
		if (`eN_clust' != .) {
			capture ereturn scalar N_clust = `eN_clust'
		}
	}
	capture ereturn scalar rank = `erank' 
	if ("`eic'" != "") {
		if(`eic' != .) {
			capture ereturn scalar ic = `eic'
		}
	}
	capture ereturn scalar converged = `econverged'
	ereturn hidden scalar noconstant = cond("`constant'" == "noconstant",1,0) 
	ereturn local asobserved `asobserved'
	ereturn local asbalanced `asbalanced'
	ereturn local marginsok "xb default n pr XBTotal"
	ereturn local marginsnotok "Residuals"
        ereturn local footnote ivpoisson_footnote
        ereturn local predict ivpoisson_p
        ereturn local estat_cmd ivpoisson_estat
	ereturn hidden local inst `oinst'
	ereturn hidden local exog `oexog'
	ereturn hidden local endog `oendog'
	local indepv `oexog' `oendog'
	ereturn hidden scalar consonly = cond("`indepv'"!="",0,1)
	ereturn local properties b V
	ereturn local technique `etechnique'
	ereturn local vcetype `evcetype'
	ereturn local vce `evce'
	ereturn local wmatrix `ewmatrix'
	ereturn local gmmestimator `egmmestimator'
	ereturn local winitname `ewinitname'
	ereturn local winit `ewinit'
	ereturn local offset1 `offvar'
        ereturn local clustvar `eclustvar'
	ereturn local title "Exponential mean model with endogenous regressors"
        ereturn local wexp "`ewexp'"
        ereturn local wtype `ewtype'
        ereturn local additive `additive'
        if ("`multiplicative'" != "" | "`estimator'" == "cfunction") {
                ereturn local multiplicative multiplicative
        }
        ereturn local estimator `estimator'
	local pinsts `oexog' `oinst'
	fvexpand `pinsts' if e(sample)
	local pinsts `r(varlist)'
	local insts: list uniq pinsts
	ereturn local insts `insts'
	ereturn local instd `oendog'
        ereturn local depvar `lhs'
	ereturn local cmdline `ivpoissoncmd'
	ereturn local cmd ivpoisson
		
	capture qui di colsof(`eV_modelbased') 
	if !_rc {
		ereturn matrix V_modelbased =`eV_modelbased'
	}	
	capture qui di colsof(`eS') 
	if !_rc {
		ereturn matrix S = `eS'
	}
	capture qui di colsof(`eW')	
	if !_rc {
		ereturn matrix W =`eW'
	}
	capture qui di colsof(`eWuser')
	if !_rc {
		ereturn matrix Wuser = `eWuser'
	}
	capture qui di colsof(`init1') 
	if !_rc	{
		ereturn matrix init = `init1'
	}
	
	if ("`estimator'" == "cfunction") {
		ereturn hidden scalar k_eform = 1
	}
	
	Display, level(`level') `diopts'  `irr'
end


// Borrowed from ivreg.ado      
program define IsStop, sclass

        if `"`0'"' == "[" {
                sret local stop 1
                exit
        }
        if `"`0'"' == "," {
                sret local stop 1
                exit
        }
        if `"`0'"' == "if" {
                sret local stop 1
                exit
        }
        if `"`0'"' == "in" {
                sret local stop 1
                exit
        }
        if `"`0'"' == "" {
                sret local stop 1
                exit
        }
        else {
                sret local stop 0
        }

end

// Borrowed from ivreg.ado      
program define Subtract   /* <cleaned> : <full> <dirt> */

        args        cleaned     /*  macro name to hold cleaned list
                */  colon       /*  ":"
                */  full        /*  list to be cleaned
                */  dirt        /*  tokens to be cleaned from full */

        tokenize `dirt'
        local i 1
        while "``i''" != "" {
                local full : subinstr local full "``i''" "", word all
                local i = `i' + 1
        }

        tokenize `full'                 /* cleans up extra spaces */
        c_local `cleaned' `*'

end


// from revised gmm
program GMMout
        syntax [, level(cilevel) COEFLegend selegend supout *]

        _get_diopts diopts, `coeflegend' `selegend' `options'

        local robust
        local hasc
        local bs
        if bsubstr("`e(vcetype)'", 1, 6) == "Robust" | "`e(clustvar)'" != "" {
                local robust "yes"
        }

        if bsubstr(`"`e(vcetype)'"', 1, 9) == "Bootstrap" | /*
                */ bsubstr(`"`e(vcetype)'"', 1, 9) == "Jackknife" {
                local bs "yes"
        }

        local anyrobust 0

        di
	di as text "Exponential mean model with endogenous regressors"	
        di

        tempname left right
        .`left' = {}
        .`right' = {}
        local C1 "_col(1)"
        local C2 "_col(24)"
        local C3 "_col(52)"
        local C4 "_col(67)"

        .`left'.Arrpush `C1' as text "Number of parameters = "  ///
                `C2' as result %3.0f e(k)
        .`right'.Arrpush `C3' as text "Number of obs"           ///
                  `C4' "= " as res %10.0fc e(N)


        .`left'.Arrpush `C1' as text "Number of moments    = "  ///
                `C2' as result %3.0f e(n_moments)
        .`left'.Arrpush `C1' as text "Initial weight matrix: "  ///
                `C2' as res "`e(winit)'"
        if "`e(estimator)'" != "onestep" {
                local wstr
                if "`e(wmatrix)'" == "unadjusted" |                     ///
                        "`e(wmatrix)'" == "robust" {
                        local wstr `=proper("`e(wmatrix)'")'
                }
                else if `"`: word 1 of `e(wmatrix)''"' == "cluster" {
                        local clv : word 2 of `e(wmatrix)'
                        local wstr "Cluster (" abbrev("`clv'",13) ")"
                }
                else {                          // must be HAC
                        local ktyp : word 2 of `e(wmatrix)'
                        if "`ktyp'" == "bartlett" {
                                local wstr "HAC Bartlett "
                                local wlagfmt -6.0f
                        }
                        else if "`ktyp'" == "parzen" {
                                local wstr "HAC Parzen "
                                local wlagfmt -6.0f
                        }
                        else {
                                local wstr "HAC quadratic spectral "
                                local wlagfmt -6.3f
                        }

                        if "`e(wlagopt)'" != "" {
                                local wstr                      ///
                                "`wstr'`:di %`wlagfmt' `e(wlagopt)''"
                        }
                        else {
                                local lag `e(wmatlags)'
                                local wstr `"`wstr'`lag'"'
                        }
                }
                .`left'.Arrpush `C1' as text "GMM weight matrix: "      ///
                        `C2' as res "`wstr'"
                if "`e(wlagopt)'" != "" {
                        .`left'.Arrpush `C2' as text                    ///
                                "(lags chosen by Newey-West)"
                }
        }
        .`right'.Arrpush ""
        .`right'.Arrpush ""
        local nl = `.`left'.arrnels'
        local nr = `.`right'.arrnels'
        local k = max(`nl', `nr')
        forvalues i = 1/`k' {
                di as text `.`left'[`i']' as text `.`right'[`i']'
        }

        di

        if (`"`supout'"' != "") {
                if e(converged) ~= 1 {
                        exit 430
                }
                exit
        }
        // Make it appear to _coef_table that we have # equations = # params
        mata:st_numscalar("e(k_eq)", st_numscalar("e(k)"))
        _coef_table, level(`level') `diopts'

        if "`e(vcetype)'" == "HAC" {
                local ktyp : word 2 of `e(vce)'
                local optbw `="`:word 3 of `e(vce)''" == "opt"'
                di as text "HAC standard errors based on " _c
                if "`ktyp'" == "bartlett" {
                        di as res "Bartlett " _c
                        local lagfmt
                }
                else if "`ktyp'" == "parzen" {
                        di as res "Parzen " _c
                        local lagfmt
                }
                else {
                        di as res "quadratic spectral " _c
                        local lagfmt %6.3f
                }
                di as text "kernel with " _c
                if `optbw' {
                        di as res `lagfmt' e(vcelagopt) _c
                        di as text " lags."
                        di as text "   (Lags chosen by Newey-West method.)"
                }
                else {
                        di as res e(vcelags) as text " lags."
                }
        }

        if "`e(nocommonesample)'" == "yes" {
                di as res "*" _c
                tempname Nmat
                matrix `Nmat' = e(N_byequation)
                forvalues i = 1/`=e(n_eq)' {
                        di in smcl as text _col(3)                      ///
"Number of observations for equation " as res `i' as text ": "          ///
as res `Nmat'[1,`i']
                }
                di in smcl as text "{hline 78}"
        }
        forvalues i = 1/`=e(n_eq)' {
                if `e(has_xtinst)' {
                        di in smcl as text "Instruments for equation "  ///
                                as res "`i'" as text ":"
                        if "`e(xtinst`i'_n)'" != "" {
                                local n = e(xtinst`i'_n)
                                local allxt
                                forvalues j = 1/`n' {
                                        local xtlags `e(xtlags`i'_`j')'
                                        local a : word 1 of `xtlags'
                                        local c `e(xtinst`i'_`j')'
                                        if `:word count `c'' > 1 {
                                                local c "(`c')"
                                        }
                                        local b : word count `xtlags'
                                        if `b' > 1 {
                                            local b : word `b' of `xtlags'
                                            local allxt `allxt' L(`a'/`b').`c'
                                        }
                                        else {
                                                if `a' == 1 {
                                                        local a
                                                }
                                                local allxt `allxt' L`a'`c'
                                        }
                                }
                                di in smcl                              ///
                                "{p 8 18 4}{txt}XT-style: {res}`allxt'{p_end}"
                        }
                        if "`e(inst_`i')'" != "" & `e(has_xtinst)' {
                                di in smcl                              ///
                            "{p 8 18 4}{txt}Standard: {res}`e(inst_`i')'{p_end}"
                        }
                        else if "`e(inst_`i')'" != "" {
                                di in smcl                              ///
                                "{p 4 8 4}{res}`e(inst_`i')'{p_end}
                        }
                }
                else {
                        di in smcl                                      ///
"{p 0 4 4}{txt}Instruments for equation {res}`i'{txt}: {res}`e(inst_`i')'{p_end}"
                }
        }
        if e(converged) ~= 1 {
                exit 430
        }

end

program ParseWinit, sclass
        args winitial
        local totwinit `winitial'
        local error in smcl as error "option {bf:winitial()} invalid"

        gettoken winitial winitopt : winitial, parse(",")
        gettoken junk winitopt : winitopt, parse(",")
        local winitopt : list clean winitopt
	if "`winitopt'" != "" {
		local optlen : length local winitopt
		if "`winitopt'" == bsubstr("independent", 1,     ///
	               	  	max(5, `optlen')) {
			local winitopts "independent"
		}
		else {
			di `error'
			exit 198
		}
	}	

        local nwords : word count `winitial'
        
        local iwlen = length(`"`winitial'"')
        local iwunadj = bsubstr("unadjusted", 1, max(2, `iwlen'))
        local iwiden = bsubstr("identity", 1, max(1, `iwlen'))
        if `nwords' == 1 & "`winitial'" == "`iwunadj'" {
                local winitial "unadj"
        }
        else if `nwords' == 1 & "`winitial'" == "`iwiden'" {
                local winitial "identity"
        }
        else if `nwords' == 1 {
                capture confirm matrix `winitial'
                if _rc {
                        di in smcl as error "matrix `winitial' not found"
                        exit 198
                }
                if "`winitopts'" != "" {
                        di in smcl as error             ///
"cannot specify {bf:independent} with user-supplied initial weight matrix"
                        exit 198
                }
                local winitusr `winitial'
                local winitial "user"
        }
        else {                                  // either XT or an error
                local xt : word 1 of `winitial'
                if "`xt'" != "xt" {
                        di `error'
                        exit 198
                }
                local spec = trim(bsubstr(`"`winitial'"', 4, .))
                local junk : subinstr local spec "L" "", all
                local junk : subinstr local junk "l" "", all
                local junk : subinstr local junk "D" "", all
                local junk : subinstr local junk "d" "", all
                if `"`junk'"' != "" {
                        di `error'
                        exit 198
                }
                if "`winitopts'" != "" {       // not allowed w/ XT
                        di `error'
                        exit 198
                }
                local winitopts = upper("`spec'")
                local winitial "xt"
        
        }
        
        sreturn local winitopts `winitopts'
        sreturn local winitusr  `winitusr'
        sreturn local winitial  `winitial'

end

// from ivregress
program CheckCollin, sclass
        syntax varlist(ts min=1 max=1) [if] [in] [iw/]          ///
                [, endog(varlist ts) exog(varlist fv ts)        ///
                   inst(varlist fv ts) PERfect NOCONSTANT ]
        marksample touse
        if `"`exp'"' != "" {
                local wgt `"[`weight'=`exp']"'
        }
        local fvops = "`s(fvops)'" == "true" | _caller() >= 11
        local tsops = "`s(tsops)'" == "true" 

        if `fvops' {
                local expand "expand"
                fvexpand `exog' if `touse'
                local exog  "`r(varlist)'"
                fvexpand `inst' if `touse'
                local inst  "`r(varlist)'"
        }
        local endog_o `endog'
        local exog_o  `exog'
        local inst_o  `inst'

        /* Catch specification errors */        
        /* If x in both exog and endog, error out */
        local both : list exog & endog
        foreach x of local both {
                di as err       ///
"`x' included in both exogenous and endogenous variable lists"
                exit 498
        }
        
        if "`perfect'" == "" {
                /* If x in both endog and inst, error out */
                local both : list endog & inst
                foreach x of local both {
                        di as err       ///
"`x' included in both endogenous and excluded exogenous variable lists"
                        exit 498
                }
        }
        
        /* If x on both LHS and (RHS or inst), error out */
        local both : list varlist & endog
        if "`both'" != "" {
                di as err       ///
                  "`both' specified as both regressand and endogenous regressor"
                exit 498
        }
        local both : list varlist & exog
        if "`both'" != "" {
                di as err       ///
                   "`both' specified as both regressand and exogenous regressor"
                exit 498
        }

        local both : list varlist & inst
        if "`both'" != "" {
                di as err       ///
"`both' specified as both regressand and excluded exogenous variable"
                exit 498
        }

        /* Now check for collinearities */

        _rmdcoll `varlist' `endog' `exog' `wgt' if `touse', `noconstant' 
        if "`r(k_omitted)'" == "" {
                local both `r(varlist)'
                local endog : list endog & both
                local exog  : list exog & both
        }
        else {
                local list `r(varlist)'
                local omitted `r(k_omitted)'
                if `omitted' {
                  foreach var of local list {
                        _ms_parse_parts `var'
                        local inendog : list var in endog
                        if (`inendog') {
                                local endog_keep `endog_keep' `var'
                        }
                        else {
                                local exog_keep `exog_keep' `var'
                        }
                  }
                }
                else {
                        local exog_keep `exog'
                        local endog_keep `endog'
                }
                local endog `endog_keep'
                local exog `exog_keep'
        }
        _rmcoll `inst', `expand'
        local inst `r(varlist)'

        if "`inst'" != "" & "`endog'`exog'" != "" {
                if "`perfect'" == "" {
                        _rmcoll2list, alist(`endog' `exog') blist(`inst') ///
                                normwt(`exp') touse(`touse')
                        local inst `r(blist)'
                }
                else if "`exog'" != "" {   // allowing perfect instruments
                        _rmcoll2list, alist(`exog') blist(`inst') ///
                                normwt(`exp') touse(`touse')
                        local inst `r(blist)'
                }
        }

        sreturn local endog `endog'
        sreturn local exog `exog'
        sreturn local inst `inst'
        sreturn local fvops `fvops'
        sreturn local tsops `tsops'
        
end



program wordindex, rclass 
	syntax, word(string) str(string)
	local wc: word count `str'
	local ind = -1
	forvalues j = 1/`wc' {
		local a: word `j' of `str'
		if ("`a'" == "`word'") {
			local ind = `j'
		}		
	}
	return scalar ind = `ind'
end


program CheckEstimator, sclass
        args input
        
        if "`input'" == "gmm" {
                sreturn local estimator "gmm"
                exit
        }
        if inlist("`input'","cfunc","cfunct","cfuncti","cfunctio","cfunction") {
                sreturn local estimator "cfunction"
                exit
        }        
        di as error "`input' not a valid estimator"
        exit 198
        
end

program Display
        syntax, [Level(cilevel) IRr *]
	if ("`e(additive)'" != "" & "`irr'" != "") {
		di as error ///
		"{bf:irr} not appropriate under additive errors"
		exit 198
	}

	GMMout, supout
	_get_diopts diopts, `options'
	_coef_table, level(`level') `options' `irr'
	_prefix_footnote, noline
end

mata:

void _cfunction_init(	string scalar bfrom, string scalar bpois, 	///
			string scalar bmvreg, string scalar sconstant,	///
			string scalar swci, string scalar swcr) {
	real matrix mbfrom, mbpois, mbmvreg
	real scalar wci, wcr, constant
	pragma unset constant
	mbpois = st_matrix(bpois)
	mbmvreg = st_matrix(bmvreg)
	wci = st_numscalar(swci)
	wcr = st_numscalar(swcr)
	
	if (sconstant != "") {
		constant = st_numscalar(sconstant)
		mbfrom = (mbpois[1,1::wci],constant,mbmvreg, ///
	 		  mbpois[1,(wci+1)::(wci+wcr)])		
	}
	else {
		mbfrom = (mbpois[1,1::wci],mbmvreg, ///
	 		  mbpois[1,(wci+1)::(wci+wcr)])		
	}
	st_matrix(bfrom,mbfrom)
}
end
exit
