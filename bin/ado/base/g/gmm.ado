*! version 2.2.0  30nov2018

program gmm, eclass byable(onecall) sortpreserve
	version 14

	local vv : di "version " string(_caller()) ":"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	
	`BY' _vce_parserun gmm, jkopts(eclass) noeqlist: `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"gmm `0'"'
		exit
	}
	if replay() {
		if "`e(cmd)'"!="gmm" { 
			exit 301
		} 
		if _by() {
			exit 190
		}
		GMMout `0'
		exit
	}
	/* -gmm- uses temporary id and time vars, so we need to
	   be able to restore user's settings if there is a failure	*/
	capture tsset, noquery
	if "`r(panelvar)'`r(timevar)'" != "" {
		local tsspanv  `r(panelvar)'
		local tssvar   `r(timevar)'
		local tssdelt  `r(tdelta)'
		local tssfmt   `r(tsfmt)'
		local istsset "yes"
		if "`BY'" != "" {
			qui sort `_byvars'
		}
	}
	`vv' ///
	capture noisily `BY' Estimate `0'
	if _rc {
		local myrc = _rc
		// If -tsset-, restore
		if "`istsset'" == "yes" {
			cap tsset `tsspanv' `tssvar', 			///
				delta(`tssdelt') format(`tsfmt') noquery
		}
		exit `myrc'
	}
	ereturn local cmdline `"gmm `:list clean 0'"'
	ereturn hidden local scoreby `BY'
	ereturn hidden local scorevers `vv'
end

program Estimate, eclass byable(recall) sortpreserve
	version 14
	
	local vn = _caller()
	local vv : di "version `vn':"

	local zero `0'		// backup copy

	local type2opts PARAMeters(string) NPARAMeters(integer 0)  ///
			EQuations(namelist) NEQuations(integer 0) ///
			HASDerivatives HASLFDerivatives
	local wtsyntax [aw fw pw iw]	// iw are treated just like fw except
					// that iw may be non-integer

	local EXPRESSION = 1
	local PROGRAM = 2
	local type
	gettoken eqn 0 : 0 , match(paren)
	if "`paren'" == "(" {
		local type = `EXPRESSION'
		local eqn1 `eqn'
		// loop through and get remaining equations
		local i 1
		local stop 0
		while !`stop' {
			gettoken eqn 0 : 0, match(paren)
			local eqn : list clean eqn
			if "`paren'" == "(" {
				local `++i'
				local eqn`i' `eqn'
			}
			else {
				local 0 `eqn'`0'
				local stop 1
			}
		}
		local neqn `i'
		// comma before options may have been stripped off by -gettoken-
		// add if no if, in, or weight expression
		if `"`=bsubstr(`"`0'"', 1, 1)'"' != "," &	///
		   `"`=bsubstr(`"`0'"', 1, 2)'"' != "if" &	///
		   `"`=bsubstr(`"`0'"', 1, 2)'"' != "in" &	///
		   `"`=bsubstr(`"`0'"', 1, 1)'"' != "[" {
			local 0 , `0'
		}
	}
	else {
		local type = `PROGRAM'
		local 0 `zero'	// restore what the user typed
		// program version
		syntax anything(name=usrprog id="program name") 	///
			[if] [in] `wtsyntax',				///
			[ `type2opts' * ]
		if "`parameters'" == "" & `nparameters' == 0 {
			di as err "must specify {bf:parameters()} or " ///
			 "{bf:nparameters()}"
			exit 198
		}
		if "`equations'" == "" & `nequations' == 0 {
			di as err "must specify {bf:equations()} or " ///
			 "{bf:nequations()}"
			exit 198
		}
		if "`hasderivatives'" != "" & "`haslfderivatives'" != "" {
			di as err "{p}options {bf:hasderivatives} and " ///
			 "{bf:haslfderivatives} may not be combined{p_end}"
			exit 198
		}
		if `nequations' == 0 {
			local neqn : list sizeof equations
		}
		else {
			local neqn = `nequations'
		}
		local 0 `if' `in' [`weight'`exp'], `options'
		capture `usrprog' 
		if _rc == 199 {
			di as error "program `usrprog' not found"
			exit 199
		}
	}
	// qui to suppress repeated '(... weights assumed)' message */
	qui syntax [if] [in] `wtsyntax' [,		///
			WMATrix(string) 		///
			WINITial(string)		///
			Center				///
			ONEstep				///
			TWOstep				///
			Igmm				///
			IGMMITerate(passthru)		///
			igmmeps(passthru)		///
			igmmweps(passthru)		///
			VAriables(varlist numeric ts fv) ///
			FROM(string)			///
			VCE(string)			///
			Level(cilevel)			///
			TItle(string)			///
			TItle2(string)			///
			NOCOMMONESAMPLE			///
			COEFLegend			///
			selegend			///
			VALUEID(string)			///
			QUICKDerivatives		///
			DERIVBOUNDUP(real 1e-2)		///
			DERIVBOUNDLOW(real 1e-9)	///
			ITERLOGONLY			///
			FITERLOGONLY			///
			debug				///
			mustconverge			///
			scorevars(string) 		///
			finalwcalc			///
			* ] // instruments() derivatives() xtinstruments()
			    // user & optimize opts
	/* undocumented:
		DERIVBOUNDUP(real 1e-2)
		DERIVBOUNDLOW(real 1e-9)
		ITERLOGONLY
		FITERLOGONLY
		debug
		mustconverge
		scorevars
		finalwcalc
	*/

	tempvar order
	gen double `order' = _n

	if ("`valueid'" == "") {
		local valueid GMM criterion Q(b)
	}
	_get_diopts diopts options, ///
		level(`level') `coeflegend' `selegend' `options'
	local weight2 `weight'	// backup, since we call syntax again
	local exp2 `"`exp'"'

	_parse_gmm_optim_opts, `options'
	local options `s(options)'
	local technique `s(technique)'
	local conv_maxiter `s(conv_maxiter)'
	local conv_ptol `s(conv_ptol)'
	local conv_vtol `s(conv_vtol)'
	local conv_nrtol `s(conv_nrtol)'
	local tracelevel `s(tracelevel)'

	// syntax checking 
	if "`type'" == "" {	// couldn't figure out type of function
		di as error "invalid syntax"
		exit 198
	}
	
	foreach i in up low {
		if (`derivbound`i'' <= 0 | `derivbound`i'' >= 1) {
			di as err "{bf:derivbound`i'} must be between 0 and 1"
			exit 198
		}
	}
	
	if "`nocommonesample'" != "" {
		if "`weight'" != "" {
			di as err "weights not allowed with " ///
			 "{bf:nocommonesample}"
			exit 135
		}
	}
	
	marksample touse

	if "`variables'" != "" {
		markout `touse' `variables'
	}
	// for initial if/in condition and variables
	tempvar touseif
	gen `touseif' = `touse'

	if `:word count `onestep' `twostep' `igmm'' > 1 {
		di as err "{p}can specify only one of {bf:onestep}, " ///
		 "{bf:twostep}, or {bf:igmm}{p_end}"
		exit 184
	}
	if "`onestep'`twostep'`igmm'" == "" {
		local twostep twostep		// default is twostep
	}
	_parse_igmm_options, `igmm' `igmmiterate' `igmmeps' `igmmweps'
	if "`igmm'" != "" {
		local igmmiterate = `s(igmmiterate)'
		local igmmeps = `s(igmmeps)'
		local igmmweps = `s(igmmweps)'
	}
	if "`onestep'" != "" & "`wmatrix'" != "" {
		di in smcl as error 			///
		    "cannot specify {bf:wmatrix()} with one-step estimator"
		exit 198
	}
	// parse weight matrix and VCE
	if "`wmatrix'" == "" & "`vce'" != "" {
		`vv' _parse_covmat `"`vce'"' "vce" `touse'
		local vcetype   	`s(covtype)'
		local vceclvar  	`s(covclustvar)'
		local vcehac    	`s(covhac)'
		local vcehaclag 	`s(covhaclag)'
		local vcehacopt 	`s(covhacopt)'
		local vceopts		`s(covopt)'
		// set wmat to vce 
		local wmatrixtype   	`vcetype'
		local wmatrixclvar  	`vceclvar'
		local wmatrixhac    	`vcehac'
		local wmatrixhaclag 	`vcehaclag'
		local wmatrixhacopt 	`vcehacopt'
		local wmatrixopts	 `vceopts'
	}
	else if "`wmatrix'" != "" & "`vce'" == "" {
		`vv' _parse_covmat `"`wmatrix'"' "wmatrix" `touse'
		local wmatrixtype   	`s(covtype)'
		local wmatrixclvar  	`s(covclustvar)'
		local wmatrixhac    	`s(covhac)'
		local wmatrixhaclag 	`s(covhaclag)'
		local wmatrixhacopt 	`s(covhacopt)'
		local wmatrixopts   	`s(covopt)'
		// set vce to wmat 
		local vcetype   	`wmatrixtype'
		local vceclvar  	`wmatrixclvar'
		local vcehac    	`wmatrixhac'
		local vcehaclag 	`wmatrixhaclag'
		local vcehacopt 	`wmatrixhacopt'
		local vceopts		`wmatrixopts'
	}
	else if "`wmatrix'" != "" & "`vce'" != "" {
		`vv' _parse_covmat `"`vce'"' "vce" `touse'
		local vcetype   	`s(covtype)'
		local vceclvar  	`s(covclustvar)'
		local vcehac    	`s(covhac)'
		local vcehaclag 	`s(covhaclag)'
		local vcehacopt 	`s(covhacopt)'
		local vceopts		`s(covopt)'
		`vv' _parse_covmat `"`wmatrix'"' "wmatrix" `touse'
		local wmatrixtype   	`s(covtype)'
		local wmatrixclvar  	`s(covclustvar)'
		local wmatrixhac    	`s(covhac)'
		local wmatrixhaclag 	`s(covhaclag)'
		local wmatrixhacopt 	`s(covhacopt)'
		local wmatrixopts   	`s(covopt)'
	}
	else {
		local vcetype "robust"
		local wmatrixtype "robust"
	}
	if ("`vcetype'"!="hac" | "`wmatrixtype'"!="hac" ) {
		if ("`vceopts'"!="" | "`wmatrixopts'"!="") { 
			if ("`vceopts'"!="independent" | "`wmatrixopts'"!="independent") {
				di as error ///
				"option {opt `vcetype'()} incorrectly specified"
				exit 198
			}
		}
	}
	capture xtset
	tempname usrtdelta usrtmin usrtmax
	local usrpanvar `r(panelvar)'
	local usrtimevar `r(timevar)'
	local usrtsfmt `r(tsfmt)'
	scalar `usrtdelta' = r(tdelta)
	scalar `usrtmin'  = r(tmin)
	scalar `usrtmax'  = r(tmax)
	
	if "`wmatrixclvar'" != "" | "`vceclvar'" != "" {
		if "`wmatrixclvar'" != "" & "`vceclvar'" != "" {
			if "`wmatrixclvar'" != "`vceclvar'" {
				di as err "{p}cannot specify different " ///
				 "cluster variables in {bf:wmat()} and " ///
				 "{bf:vce()}{p_end}"
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
	if "`weight'" == "pweight" {
		if "`wmatrixtype'" != "cluster" & 			///
			"`wmatrixtype'" != "robust" & "`onestep'" == "" {
			if "`wmatrixtype'" != "unadj" {
				local saywhat `wmatrixtype'
			}
			else {
				local saywhat unadjusted
			}
			di as err "cannot use `saywhat' weight matrix with " ///
			 "pweights"
			exit 404
		}
		if "`vcetype'" != "cluster" & 				///
			"`vcetype'" != "robust" & "`onestep'" != "" {
			if "`vcetype'" != "unadj" {
				local saywhat `vcetype'
			}
			else {
				local saywhat unadjusted
			}
			di as err "{p}cannot use `saywhat' VCE with " ///
			 "pweights and one-step estimator{p_end}"
			exit 404
		}
	}

	if "`wmatrixhac'`vcehac'" != "" {
		if "`weight'" == "fweight" | "`weight'" == "pweight" {
			di as err "{p}cannot use `weight's with " ///
			 "{bf:vce(hac ...)} or {bf:wmatrix(hac ...)}{p_end}"
			exit 498
		}
		qui tsset, noquery
	}

	local hasparmeq = 0	/* will be set to 1 if user specified a
				   function evaluator program and parameters() 
				   has full <eq>:<name> names
				*/

	tempvar one		/* in some of our Mata code, it's fastest if */
	gen byte `one' = 1	/* we can just grab a variable equal to one  */
	local cons_name "`one'" /* for constant terms			     */
	
	// will be changed by Mata routines if used
	local wmatrixhaclagused 0
	local vcehaclagused 0
	local n_clusters 0
						/* set up expression for
						   evaluation and iteration */
	tempname parmvec parmvecall C0 c0 X
	local Cc `C0' `c0'
	local constraints = 0
	if `type' == `EXPRESSION' {
		tempname parseobj
		.`parseobj' = ._parse_sexp_c.new
		
		local kcollin = 0
		forvalues i = 1/`neqn' {
			cap noi `vv' ///
			_parse_sexp, parseobj(`parseobj') eqn(`i') ///
				expression(`eqn`i'') touse(`touse') cc(`Cc')
			local rc = c(rc)
			if `rc' {
				if `rc' > 1 {
					di as txt "{phang}The moment " ///
					 "expression is incorrectly "  ///
					 "specified.{p_end}"
				}
 				exit `rc'
			}
			local eqname`i' `r(eqn)'
			local eqnames `eqnames' `eqname`i''
			local eqn`i' `"`r(expr)'"'
			/* substitutable expression			*/
			local expr`i' `"`eqn`i''"'
			local params`i' `r(parmlist)'
			local params : list params | params`i'
			/* number of new parameters			*/
			local kpar : list sizeof params`i'
			/* number of parameters in equation		*/
			local np`i' = r(k)
			local kcollin = `kcollin' + `r(kcollin)'
			if `np`i'' == 0 { 
				di as txt "note: no parameters in equation `i'"
			}
			else if `kpar' {
				tempname parmvec`i'
				matrix `parmvec`i'' = r(initmat)
				if `vn' < 14 {
					mat coleq `parmvec`i'' = eq`i':
				}
				matrix `parmvecall' =  ///
					(nullmat(`parmvecall'), `parmvec`i'')
			}
		}
		CheckMomentEqNames "`neqn'" "`eqnames'"

		cap confirm matrix `C0'
		local constraints = (c(rc)==0)
		if `constraints' {
			if `=rowsof(`C0')' == 1 {
				mat `X' = `C0'*`C0''
				local constraints = (`X'[1,1]>c(epsdouble))
			}
		}
		if `constraints' {
			/* identify the constraint matrices for Mata	*/
			local Cmat `C0'
			local cmat `c0'
		}
		/* At this point, parmvecall may have the same parameter in
		   more than one equation.  We create a new vector that
		   contains just the FIRST initial value for each unique
		   parameter. */
		if `vn' < 14 {
			local allparms : colnames `parmvecall'
		}
		else {
			local allparms : colfullnames `parmvecall'
		}
		/* put parm into matrix stripe form			*/
		_parse_sexp_matrix_form `allparms'
		local allparms `s(parameters)'
		foreach param of local params {
			local j : list posof "`param'" in allparms
			mat `parmvec' = (nullmat(`parmvec'),`parmvecall'[1,`j'])
		}
		mat colnames `parmvec' = `params'
		local k = colsof(`parmvec')
		forvalues j=1/`k' {
			local parm : word `j' of `params'
			forvalues i = 1/`neqn' {
				local expr`i' : subinstr local expr`i' ///
					"{`parm'}" "\`parmvec'[1,`j']", all
			}
		}
	}
	else { // type == `PROGRAM'
		local nparams `nparameters'	// shorter name
		if "`parameters'" != "" {
			ParseParameters `"`parameters'"' `touse'  `one' `vn'
			local params `"`r(stripe)'"'
			local parmeq `r(eqnames)'
			local nparmeq : list sizeof parmeq
			forvalues i=1/`nparmeq' {
				local parmeq`i'vars `r(eq`i'vars)'
			}
			local hasparmeq = (`nparmeq' > 0)

			if "`r(C)'" != "" {
				mat `C0' = r(C)
				mat `c0' = r(c)
				local Cmat `C0'
				local cmat `c0'
			}
			local np : list sizeof params
			if `nparams' > 0 & `np' != `nparams' {
				di as err "{p}number of parameters in " ///
				 "{bf:parameters()} does not match "    ///
				 "{bf:nparameters()}{p_end}"
				exit 198
			}
			else if `nparameters' <= 0 {
				local nparams `np'
			}
		}
		else {
			if `nparams' <= 0 {
				di as error "no parameters declared"
				exit 198
			}
			local params "b1"
			forvalues i = 2/`nparams' {
				local params "`params' b`i'"
			}
		}
		matrix `parmvec' = J(1, `nparams', 0)
		matrix colnames `parmvec' = `params'

		/* moment equation names; not to be confused with the	*/
		/*  parmvec equation (linear form) names		*/
		CheckMomentEqNames "`nequations'" "`equations'"
		local neqn = `s(neqn)'
		local eqnames `"`s(eqnames)'"'
	}	
	/* At this point we know how many eqns there are, so mark
	   individual touse vars if requested	*/
	if "`nocommonesample'" != "" {
		if `neqn' == 1 {
			di as err "{p}cannot specify {bf:nocommonesample} " ///
			 "with single-equation models{p_end}"
			exit 498
		}
		forvalues i = 1 / `neqn' {
			tempvar touse`i'
			qui gen byte `touse`i'' = `touse'
		}
	}
	// parse `options' for xtinstruments
	if `"`options'"' != "" {
		local zero `0'
		local 0 , `options'
		syntax [, XTINSTruments(string) *]
		while "`xtinstruments'" != "" {
			ParseXTInst `"`xtinstruments'"' `"`eqnames'"'
			local xteqn `s(xteqn)'
			local xtinst `s(xtinst)'
			local xtlags `s(xtlags)'
			foreach e of local xteqn {
				if `e' < 1 | `e' > `neqn' {
					di as err "invalid equation " ///
					 "specified in {bf:xtinstruments()}"
					exit 198
				}
				// up to 8 xtinst() specif. for each equation
				local nxtinst = 0
				forvalues i = 1/8 {
					if "`xtinst`e'_`i''" == "" {
						local nxtinst = `i'
						continue, break
					}
				}
				if `nxtinst' == 0 {
					di as err "{p}can repeat "       ///
					 "{bf:xtinstruments()} at most " ///
					 "eight times for each equation{p_end}"
					exit 198
				}
				local xtinst`e'_`nxtinst' `xtinst'
				local xtlags`e'_`nxtinst' `xtlags'
				local xtinst`e'_n = `nxtinst'
				local anyxtinst 1
			}
			local 0, `options'
			syntax [, XTINSTruments(string) *]
		}
		local 0 `zero'
	}
	// parse `options' for instruments
	if `"`options'"' != "" {
		local collin = ("`anyxtinst'"!="1")
		local kcollin = 0
		local zero `0'
		local 0 , `options'
		syntax [, INSTruments(string) * ]
		while "`instruments'" != "" {
			// following returns s(eqn) and s(inst)
			ParseInst `"`instruments'"' `"`eqnames'"' "`touse'" ///
				`collin'
			local eqn `s(eqn)'
			local vlist `s(inst)'
			local nocons `s(nocons)'
			local kcollin = `kcollin' + `s(kcollin)'

			foreach e of local eqn {
				if `e' < 1 | `e' > `neqn' {
					di as err "invalid equation " ///
					 "specified in {bf:instruments()}"
					exit 198
				}
				local inst`e' `inst`e'' `vlist'
				if "`nocons'" == "" {
					local inst`e' `inst`e'' `one'
				}
				else {
					local nocons`e' 1
				}
			}
			local 0 , `options'
			syntax [, INSTruments(string) * ]
		}
		local 0 `zero'
	}
	forvalues i=1/`neqn' {
		if "`inst`i''"=="" & "`nocons`i''"=="" {
			/* constant even if instruments are not 	*/
			/*  specified for this equation			*/
			local inst`i' `one'
		}
		InstrumentCMatrix `"`inst`i''"'
		if `r(hasCmat)' {
			tempname C`i' 
			mat `C`i'' = r(C)
			/* identify constraint matrices for mother Mata	*/
			local ICmat`i' `C`i''
		}
		if `type' == `EXPRESSION' {
			if "`nocommonesample'" != "" {
				markout `touse`i'' `inst`i''
			}
			else {
				markout `touse' `inst`i''
			}
		}
	}
	// parse `options' for derivatives
	if `"`options'"' != "" {
		local subsderiv ""
		local zero `0'
		local 0 , `options'
		syntax [, DERIVative(string) * ]
		while `"`derivative'"' != "" {
			// function evaluator version doesn't accept deriv()
			if `type' == `PROGRAM' {
				di as err "{p}cannot use "           ///
				 "{bf:derivatives()} with function " ///
				 "evaluator program version{p_end}"
				exit 198
			}
			local subsderiv = 1
			_parse_sexp_deriv `"`derivative'"' `"`eqnames'"'
			local eq = `s(eqn)'
			if `eq' < 1 | `eq' > `neqn' {
				di as err "{p}error in {bf:derivatives()}: " ///
				 "equation `s(eqn)' out of range{p_end}"
				exit 498
			}
			local dp `s(param)'
			// convert linear combinations to long form
			cap noi `vv' ///
			_parse_sexp, parseobj(`parseobj') eqn(`eq') ///
				expression(`s(deriv)') touse(`touse') noinit
			loca rc = c(rc)
			if `rc' {
				if `rc' > 1 {
					di as txt "{phang}The derivative " ///
					 "expression is incorrectly "      ///
					 "specified.{p_end}"
				}
 				exit `rc'
			}
			local sderiv `r(expr)'
			if `.`parseobj'.islcin `dp'' {
				/* reference linear combination	name	*/
				local lcderiv = 1
				local vlist `.`parseobj'.lcvarfetch `dp''
				local dp `.`parseobj'.lcparmfetch `dp''
				local lcderiv : list sizeof vlist
			}
			else if !`:list posof "`dp'" in params' {
				di as err "{p}invalid option "         ///
				 "{bf:derivatives()}; parameter `dp' " ///
				 "undeclared in equation `eq'{p_end}"
				exit 498
			}
			local ppos = 1
			foreach p of local dp {
				local k : list posof "`p'" in params
				if `"`d_`eq'_`k'_e'"' != "" {
					di as err "{p}derivative already " ///
					 "defined for parameter `p' in "   ///
					 "equation `eq'{p_end}"
					exit 498
				}
				gettoken lc cvar : p, parse(":")
				if `lcderiv' & "`cvar'"!=":_cons" {
					local lcvar : word `ppos' of `vlist'
					local d_`eq'_`k'_e (`sderiv')*`lcvar'
				}
				else {
					local d_`eq'_`k'_e `sderiv'
				}
				// replace par names with parmvec elem.
				foreach p2 of local params {
					local j = colnumb(`parmvec',"`p2'")
					local d_`eq'_`k'_e : subinstr     ///
						local d_`eq'_`k'_e        ///
						"{`p2'}" "`parmvec'[1,`j']", ///
						all
				}
				tempname d_`eq'_`k'
				loc d_`eq'_`k'_v `d_`eq'_`k''
				qui gen double `d_`eq'_`k'' = .
				local `++ppos'
			}
			local 0 , `options'
			syntax [, DERIVative(string) * ]
		}
		// verify that we have a deriv for each param/eq
		if "`subsderiv'" == "1" {
			forvalues i = 1/`neqn' {
				foreach p of local params`i' {
					local pcnt : list posof "`p'" in params
					if "`d_`i'_`pcnt'_e'" == "" {
						di as err "{p}no "           ///
						 "derivative for parameter " ///
					 	 "`p' in equation `i' "      ///
						 "specified{p_end}"
						exit 498
					}
				}	
			}
		}
		local 0 `zero'
	}

	/* At this point, `options' should be empty if type 1 (expression); 
	   also check if type-2 (program) options were specified. */
	if `type' == `EXPRESSION' {
		if "`options'" != "" {
			di as err `"{p}{bf:`options'} not allowed with "' ///
			 "interactive version{p_end}"
			exit 198
		}
		syntax [if] [in] `wtsyntax' [, `type2opts' * ]
		if "`equations'" != "" | `nequations' != 0 {
			di as err "{p}cannot specify {bf:equations()} or " ///
			 "{bf:nequation()} with interactive version{p_end}"
			exit 198
		}
		if "`parameters'" != "" | `nparameters' != 0 {
			di as err "{p}cannot specify {bf:parameters()} or " ///
			 "{bf:nparameters()} with interactive version{p_end}"
			exit 198
		}
		if "`hasderivatives'`haslfderivatives'" != "" {
			di as err "{p}cannot specify {bf:hasderivatives} " ///
			 "with interactive version{p_end}"
			exit 198
		}
	}
	
	if "`haslfderivatives'" != "" & !`hasparmeq' {
		di as err "{p}cannot specify {bf:haslfderivatives} unless " ///
		 "you specify equation names in {bf:parameters()}{p_end}"
		exit 198
	}
	
	/* We've created tempvars for derivatives of type 1 evaluators if
	   needed.  Here we create k*m tempvars for derivatives of type 2
	   evaluators; k=number of params; m=number of moment equations
	   If user specifies haslfderivatives, we just need nparmeq*m 
	   variables; the chain rule takes care of the rest. */
	if `type' == `PROGRAM' & "`hasderivatives'`haslfderivatives'" != "" {
		if "`haslfderivatives'" != "" {
			local itop = `nparmeq'
		}
		else {
			local itop = `nparams'
		}
		forvalues i = 1/`neqn' {
			forvalues j = 1/`itop' {
				tempvar d2_`i'_`j'
				qui gen double `d2_`i'_`j'' = 0 if `touse'
				local d2_`i'_`j'_v `d2_`i'_`j''
			}
		}
	}

	if "`anyxtinst'" != "" {
		local xttype = bsubstr(`"`winitial'"', 1, 3)
		ParseWinit `"`winitial'"'
		// space intentional -v- there 
		if "`xttype'" != "xt " & "`s(winitial)'" != "user" {
			di as err "{p}must specify {bf:winitial(xt }" ///
			 "{it:xtspec}{bf:)} or {bf:winitial(}"        ///
			 "{it:matname}{bf:)}{break}with XT-style "    ///
			 "instruments{p_end}"
			exit 498
		}
		// can't compute an unadj weight matrix w/ XT instruments
		if "`wmatrixtype'" == "unadj" & "`twostep'`igmm'" != "" {
			di as err "{p}cannot use unadjusted weight matrix " ///
			 "with XT-style instruments{p_end}"
			exit 498
		}
		if "`weight'" != "" {
			di as err "weights not allowed with " ///
			 "{bf:xtinstruments()}"
			exit 135
		}
		if "`usrpanvar'" == "" {
			di as err "panel variable not set; use {bf:xtset}"
			exit 459
		}
		else if "`usrtimevar'" == "" {
			di as err "must specify time variable; use {bf:xtset}"
			exit 459
		}
		tempvar sumtouse pantouse id t
		qui {
			// use common touse even if -nocommonesample-;
			by `usrpanvar' : gen long `sumtouse' = sum(`touse')
			by `usrpanvar' : replace  `sumtouse' = `sumtouse'[_N]
			by `usrpanvar' : gen `pantouse' = (`sumtouse' > 0)
			gen long `id' = (`pantouse' > 0) in 1
			replace `id' = 1 if 				///
				`usrpanvar' != `usrpanvar'[_n-1] &	///
				`pantouse' == 1 in 2/l
			replace `id' = sum(`id')
			replace `id' = . if `pantouse' == 0
			gen double `t' = (`usrtimevar' - `usrtmin' + 1) / ///
						`usrtdelta'
		}

		local xtcapt `=(`usrtmax' - `usrtmin' + 1) / `usrtdelta''
		local xtpanvar `id'
		local xttimevar `t'
		summ `id', mean
		local xtnpan `=r(max)'
		local n_clusters = `xtnpan'
		// panels must be nested within clusters
		if "`vceclvar'" != "" {
			_xtreg_chk_cl2 `vceclvar' `id' `pantouse'
		}
		else if "`wmatrixclvar'" != "" {
			_xtreg_chk_cl2 `wmatrixclvar' `id' `pantouse'
		}
		/* If we've marked more than one entire panel as NOT in 
		   estimation sample, then `id' = . for all those panels
		   and we could get 'repeated time values' error from
		   -xtset-.  Here we reassign our time variable for
		   those panels, which we ignore anyway since touse=0
		   Too bad we need an extra sort here. */
		qui bys `pantouse': replace `t' = _n if `pantouse' == 0
		qui xtset `id' `t'
		local pantousename `pantouse'
		/* Unfortunately, there is no way to avoid doing a
		   preserve and drop here.  Depending on the pattern
		   of missing observations, there's just no reliable
		   way to keep track of everything otherwise. */
		preserve
		qui drop if !`pantouse'

	}
	else {	// no xtinstruments
		local xttype = bsubstr(`"`winitial'"', 1, 3)
		// space intentional -v- there 
		if "`xttype'" == "xt " {
			di as err "{p}cannot specify {bf:wmatrix(xt ...)} " ///
			 "without XT-style instruments{p_end}"
			exit 198
		}
	}
	if "`vceclvar'`wmatrixclvar'" != "" {
		if "`id'" == "" & "`usrpanvar'" != "" {
			local sortid `usrpanvar'
		}
		else if "`id'" != "" {
			local sortid `id'
		}
		if "`t'" == "" & "`usrtimevar'" != "" {
			local sortt `usrtimevar'
			local delta `usrtdelta'		// scalar name, not #
		}
		else if "`t'" != "" {
			local sortt `t'
			local delta 1
		}
		
		if "`vceclvar'" != "" {
			local myclus `vceclvar'
		}
		else {
			local myclus `wmatrixclvar'
		}
		if "`sortid'`sortt'" != "" {
			/* This is needed to keep data sorted
			   cluster -> panel -> time but to allow time-series
			   operators to work.  We've already ensured panels
			   nested w/in cluster, so new (cluster, panvar) will
			   be okay to use as a panvar as far as TS ops go.*/
			if "`sortid'" != "" {
				tempname cluspanvar
				sort `myclus' `sortid'
				qui by `myclus' `sortid': ///
					gen long `cluspanvar' = 1 	///
						if _n==1
				qui replace `cluspanvar' = sum(`cluspanvar')
				if "`sortt'" == "" {	// just clust & panel
							// no time dimension
					qui xtset `cluspanvar'
				}
				else {
					qui xtset `cluspanvar' `sortt', ///
						delta(`=`delta'')
				}
			}
			else {
				qui tsset `sortt', delta(`=`delta'') noquery
				cap assert `myclus' >= `myclus'[_n-1]	///
					if _n > 1 & `touse'
				if _rc {
					di as err "clusters contain non-" ///
					 "consecutive time spans"
					exit 498
				}
			}
		}
		else {
			sort `myclus'
		}
	}

	if "`winitial'" != "" {
		ParseWinit `"`winitial'"'
		local winitopts `s(winitopts)'
		local winitusr `s(winitusr)'
		local winitial `s(winitial)'
	}
	else {
		local winitial "unadj"
	}
	if "`winitial'" == "unadj" {
		local i 0
		forvalues e = 1/`neqn' {
			if "`inst`e''" != "" & "`inst`e''" != "`one'" {
				local `++i'
			}
			else if "`xtinst`e'_n'" != "" {
				if `xtinst`e'_n' > 0 {
					local `++i'
				}
			}
		}
		if `i' < (`neqn' - 1) & "`winitopts'" != "independent" {
			local s `=cond((`neqn'-1)==1, "", "s")'
			di as err "{p}to avoid a singular initial weight " ///
			 "matrix in a model with `neqn' moment equations " ///
			 "you must declare instruments for at least "      ///
			 "`=`neqn'-1' equation`s' or use "		   ///
			 "{bf:winitial(unadjusted, independent)} or "      ///
			 "{bf:winitial(identity)}{p_end}"
			exit 498
		}
	}
	
	if "`winitial'" == "xt" {
		local l = length("`winitopts'") 
		if `l' != `neqn' {
			di as err "{p}{bf:wmatrix(xt ...)} inconsistent " ///
			 "with number of moment equations{p_end}"
			exit 498
		}
		else if `l' > 2 {
			di as err "{p}can specify at most two moment " ///
			 "equations with {bf:wmatrix(xt ...)}{p_end}"
			exit 498
		}
		local junk:subinstr local winitopts "D" "D", all count(local nd)
		local junk:subinstr local winitopts "L" "L", all count(local nl)
		if `nl' > 1 | `nd' > 1 {
			di as err "{p}can specify at most one equation in " ///
			 "levels and one equation in differences with "     ///
			 "{bf:wmatrix(xt ...)}{p_end}"
			exit 498
		}
	}
	local np : word count `params'	// rest of code uses np
		
	// from() option overrides other initial values
	if "`from'" != "" {
		_parse_initial `"`from'"' : `parmvec' `"`params'"'
	}

	qui count if `touse'
	local capN = r(N)
	if r(N) < `np' {
		di as err "cannot have fewer observations than parameters"
		exit 2001
	}

	tempname initvec		// For returning to user
	matrix `initvec' = `parmvec'

	local tousename `touse'		// to pass to mata
	local touseifname `touseif'
	local parmvecname `parmvec'
	forvalues i = 1/`neqn' {
		tempvar err`i'
		qui gen double `err`i'' = .
		local errnames `errnames' `err`i''
	}
	
	if `type' == `EXPRESSION' {
		forvalues i = 1/`neqn' {
			if "`nocommonesample'" != "" {
				local mytouse `touse`i''
			}
			else {
				local mytouse `touse'
			}
			qui count if `mytouse'
			local n = r(N)
			cap replace `err`i'' = `expr`i'' if `mytouse'
			local rc = _rc
			if `rc' {
				if (`rc'==1) exit `rc'

				di as error "could not evaluate equation `i'"
				exit 498
			}
		}
	}
	else {
		cap noi `usrprog' `errnames' if `touse' ///
			[`weight2' `exp2'], at(`initvec') `options'
		local rc = _rc
		if `rc' {
			if (`rc'==1) exit `rc'

			di as txt "{phang}An error occurred in the user " ///
			 "program {bf:`usrprog'} when evaluating the "    ///
			 "initial values.  Please check the program and " ///
			 "the syntax to the call to {bf:gmm}.{p_end}"
			exit `rc'
		}
	}
	forvalues i = 1/`neqn' {
		if "`nocommonesample'" != "" {
			local mytouse `touse`i''
		}
		else {
			local mytouse `touse'
		}
		qui count if `err`i'' < . & `mytouse'
		if r(N) == 0 {
			di as err "{p}no non-missing values returned for " ///
			 "equation `i' at initial values{p_end}"
			exit 498
		}
		else if r(N) < `capN' {
			local dif = `capN' - r(N)
			local s
			if `dif' > 1 {
				local s s
			}
			if "`nocommonesample'" == "" {
				di as txt "{p 0 6 2}note: `dif' missing " ///
				 "value`s' returned for equation `i' at " ///
				 "initial values{p_end}"
			}
			qui replace `mytouse' = 0 if missing(`err`i'')
		}
	}
	forvalues i=1/`neqn' {
		if "`nocommonesample'" != "" {
			markout `touse`i'' `inst`i''
		}
		else {
			markout `touse' `inst`i''
		}
	}


	tempvar orvar
	qui gen `orvar' = 0
	if "`nocommonesample'" != "" {
		forvalues i = 1/`neqn' {
			qui replace `orvar' = `orvar' | `touse`i''
		}
		qui replace `touse' = `touse' & `orvar'
		forvalues i = 1/`neqn' {
			qui replace `touse`i'' = . if ~`touse'
		}
	}
	/* Here we generate weights and sample size that are suitable
	   for use within Mata, since it does not differentiate
	   between fw, aw, pw, or iw.	*/
	local weight `weight2'	// restore what first -syntax- parsed
	local exp `"`exp2'"'
	tempvar normwt
	if `"`exp'"' != "" {
		// if there are weights, then there's just one `touse'
		qui gen double `normwt' `exp' if `touse'
		if "`weight'" == "aweight" | "`weight'" == "pweight" {
			summ `normwt' if `touse', mean
			qui replace `normwt' = r(N)*`normwt'/r(sum)
		}
	}
	else {
		qui gen double `normwt' = 1 if `touse'
	}
	tempname eN
	summ `normwt' if `touse', mean
	scalar `eN' = r(sum)
	local normN `eN'
	
	if "`nocommonesample'" != "" {
		tempname normNmat
		matrix `normNmat' = J(1,`neqn',.)
		local normNmatname `normNmat'		// passed to Mata
		forvalues i = 1/`neqn' {
			local eqtousename `eqtousename' `touse`i''
			if "`anyxtinst'" == "" {
				/* Can't do this here if there are XT
				   instruments, because we haven't
				   sorted out valid obs. due to missing
				   instruments, yet do so in Mata code.
				   Get an obs count while we're at it.	*/
				qui count if `touse`i''
				mat `normNmat'[1,`i'] = r(N)
			}
		}
	}
	
	tempname V Q V_modelbased finalW finalG finalS finalT	/// 
		finalC finalTC					///
		oQ oW 

	if "`finalwcalc'" != "" {
		tempname finalWfinal
	}
	local Vname `V'
	local Qname `Q'
	local V_modelbased `V_modelbased'
	local finalWname `finalW'
	local finalGname `finalG'
	local finalSname `finalS'
	local finalTname `finalT'
	local finalCname `finalC'
	local finalTCname `finalTC'
	local scorevarsnames `scorevars'
	local oQname `oQ'
	local oWname `oW'
	local finalWfinalname `finalWfinal'
	qui count if `touse'
	local nobs = r(N)

	local igmmcnt	// will be filled in with number
					// of iterations, if igmm
	// estimation
	mata: _gmm_wrk()

	// postestimation
	ereturn clear
	/* Rename a copy, not the param vector we are using,
	   because our code depends on the names of the param 
	   vector.	*/
	tempname b
	tempvar touse2
	mat `b' = `parmvec'

	qui gen byte `touse2' = `touse'
	
	if `vn' < 14 {
		if `hasparmeq' {
			local kaux = 0
			local pareqn `params'
		}
		else {
			local kaux = `np'
			foreach p of local params {
				local pareqn `"`pareqn' `p':_cons"'
			}
		}
	}
	else {
		local kaux = 0
		local plist `params'
		local np = 0
		while "`plist'" != "" {
			gettoken p plist : plist, bind
			if strpos("`p'",":") == 0 {
				/* estimates using program		*/
				local pareqn `"`pareqn' `p':_cons"'
				local `++kaux'
				local `++np'
			}
			else {
				local pareqn `"`pareqn' `p'"'
				gettoken eq var : p, parse(":")
				gettoken colon var : var, parse(":")
	
				if "`var'"=="_cons" & "`eq'"!="`eq1'" {
					/* # _cons at end of coef vec	*/
					local `++kaux'
				}
				else local kaux = 0

				_ms_parse_parts `var'
				local np = `np' + !r(omit)

				local eq1 "`eq'"
			}
		}
	}
	cap confirm mat `finalC'
	local hasC = 0
	if (!c(rc)) {
		local hasC = 1
		mat colnames `finalC' = `pareqn' "_to"
	}

	matrix colnames `b' = `pareqn'
	matrix rownames `V' = `pareqn'
	matrix colnames `V' = `pareqn'

	if `vn' < 14 {
		/* Make it appear to _coef_table that we have 
		   # equations = # params unless it's a type-2 evaluator,
		   where the user specified equation names in parameters(). */
		if `type'==`PROGRAM' & strpos(`"`params'"',":")>0 {
			local eqn : coleq `b'
			local eqn : list uniq eqn
			local keq : list sizeof eqn
		}
		else {
			local keq = `np'
		}
	}
	else {
		local eqn : coleq `b'
		local eqn : list uniq eqn
		local keq : list sizeof eqn
	}

	if "`weight2'" == "fweight" {
		_ms_build_info `b' if `touse' [`weight2'=`normwt']
	}
	else {
		_ms_build_info `b' if `touse'
	}
	/* vrank >= e(rank) computed by -_post_vce_rank-		*/
	local vrank = colsof(`V')-diag0cnt(`V') 
	ereturn post `b' `V', esample(`touse2') buildfvinfo
	_post_vce_rank
	/* Rename finalW and finalS with eq:var format, where eq is
	   equation number and var is name of instrument.	*/
	local stripe 
	forvalues i = 1/`neqn' {
		local inst`i' : subinstr local inst`i' "`one'" "_cons", all ///
			word
		local iname : word `i' of `eqnames'
		if "`iname'" == "" {		// type-2 eval -> no eq names
			local iname eq`i'
		}
		if "`inst`i''" != "" {
			foreach x in `inst`i'' {
				local stripe `stripe' `iname':`x'
			}
			/* put in matrix form				*/
			_parse_sexp_matrix_form `inst`i''
			local inst`i' `s(parameters)'
		}
	}
	mat colnames `finalW' = `stripe'
	mat rownames `finalW' = `stripe'
	cap confirm mat `finalT'
	local hasT = 0
	if (!c(rc)) {
		tempname W0
		local hasT = 1
		mat rownames `finalT' = `stripe'"
		// reduce-rank form for the number of moments
		mat `W0' = `finalT''*`finalW'*`finalT'
		local nmoments = rowsof(`W0')
	}
	else {
		local W0 `finalW'
		local nmoments = rowsof(`finalW')
	}
	local wrank = colsof(`W0')-diag0cnt(`W0')
	/* Use floor below to handle case of iweights, in which case N is
	   defined as floor(sum iw's) as w/ -regress-.	*/
	if "`weight'" == "aweight" | "`weight'" == "pweight" {
		/* can lose an observation due to normalization 	*/
		/*  (above) and truncation				*/
		ereturn scalar N = floor(scalar(`eN')*(1+c(epsdouble)))
	}
	else {
		ereturn scalar N = floor(scalar(`eN'))
	}
	ereturn scalar Q = `Q'
	if "`anyxtinst'" != "" {
		ereturn scalar J = `Q'*`xtnpan'
		/* We had preserved and dropped unused panels if there were
		   xt-style instruments; we must explicitly restore ourselves
		   so that we can later restore the user's -xtset-tings. */
		/* We do not directly use -restore- so that we can 
		   save information about the estimation sample. */
		if "`scorevars'" != "" {
			tempvar tousescores
			gen `tousescores' = e(sample)
			keep `order' `scorevars' `tousescores'
			sort `order', stable
			tempfile scores
			qui save "`scores'", replace			
			restore
			capture confirm variable _merge
			local oldmerge = 0
			if !_rc {
				tempvar oldm
				rename _merge `oldm'
				local oldmerge = 1
			}
			drop `scorevars'
			qui merge 1:1 `order' using "`scores'"
			qui keep if _merge != 2
			drop _merge
			if `oldmerge' {
				rename `oldm' _merge
			}
		}
		else {
			tempvar tousext
			gen `tousext' = e(sample)
			keep `order' `tousext'
			sort `order', stable
			tempfile xtfile
			qui save "`xtfile'", replace
			restore
			capture confirm variable _merge
			local oldmerge = 0
			if !_rc {
				tempvar oldm
				rename _merge `oldm'
				local oldmerge = 1
			}
			qui merge 1:1 `order' using "`xtfile'"
			qui replace `tousext' = 0 if _merge == 1
			qui keep if _merge != 2
			drop _merge
			if `oldmerge' {
				rename `oldm' _merge
			}	
			ereturn repost, esample(`tousext') 		
		}
	}
	else {
		ereturn scalar J = `Q'*`eN'
	}
	ereturn scalar J_df = `wrank' - `vrank'
	ereturn matrix W = `finalW'

	if (`hasC') ereturn hidden matrix C = `finalC'
	if (`hasT') ereturn hidden matrix T = `finalT'

	ereturn hidden matrix G = `finalG'
	if "`vcetype'" != "unadj" {
		mat colnames `finalS' = `stripe'
		mat rownames `finalS' = `stripe'
		ereturn matrix S = `finalS'
		ereturn matrix V_modelbased = `V_modelbased'
	}

	forvalues i = 1 / `neqn' {
		// return other eq-level stuff while we're looping
		if `type' == `EXPRESSION' {
			ereturn scalar k_`i' = `np`i''
			ereturn local sexp_`i' `eqn`i''
		}
		ereturn local params_`i' `params`i''
		ereturn local inst_`i' `inst`i''
		if "`anyxtinst'" != "" {
			if "`xtinst`i'_n'" != "" {
				ereturn scalar xtinst`i'_n = `xtinst`i'_n'
				forvalues j = 1/`xtinst`i'_n' {
					ereturn local ///
						xtinst`i'_`j' `xtinst`i'_`j''
					ereturn local ///
						xtlags`i'_`j' `xtlags`i'_`j''
				}
			}
		}
	}

	ereturn scalar converged = `converged'

	if "`anyxtinst'" != "" {
		ereturn scalar has_xtinst = 1
	}
	else {
		ereturn scalar has_xtinst = 0
	}
	ereturn local params `params'
	ereturn scalar type = `type'
	if `type' == `PROGRAM' {
		ereturn local evalprog = "`usrprog'"
		ereturn local evalopts `"`options'"'
	}
	ereturn hidden scalar version = `vn'
	ereturn hidden scalar Q_criterion = `oQ'
	ereturn hidden matrix W_criterion = `oW', copy
	ereturn hidden matrix W0 = `oW'
	if "`finalwcalc'" != "" {
		ereturn hidden matrix W_final = `finalWfinal'
	}
	ereturn matrix init = `initvec'
	ereturn scalar n_eq = `neqn'
	ereturn scalar k = `np'
	ereturn scalar n_moments = `nmoments'
	ereturn scalar k_eq = `keq'
	ereturn scalar k_aux = `kaux'
	ereturn scalar k_eq_model = 0		// do not do model test

	if `"`title'"' != "" {
		ereturn local title `"`title'"'	
	}
	if `"`title2'"' != "" {
		ereturn local title_2 `"`title2'"'	
	}
	
	// vcetype controls labeling of std. errs. in output table
	if "`vcetype'" == "robust" | "`vcetype'" == "cluster" {
		eret local vcetype "Robust"
	}
	if "`anyxtinst'" == "1" {
		if "`vcetype'" == "robust" & "`vceclvar'" == ""	{
			local vceclvar `usrpanvar'
		}
	}
	if "`vceclvar'" != "" {
		eret local clustvar "`vceclvar'"
		eret scalar N_clust = `n_clusters'
		if "`small'" == "small" {
			eret scalar df_r = `=`e(N_clust)' - 1'
		}
	}
	if "`vcetype'" == "hac" {
		eret local vcetype "HAC"
	}
	foreach x in vce wmatrix {
		if "``x'type'" == "robust" {
			ereturn local `x' "robust"
		}
		if "`x'" == "wmatrix" & "``x'type'" == "cluster" {
			ereturn local `x' "cluster ``x'clvar'"
		}
		else if "``x'type'" == "cluster" {	// stata convention is
			ereturn local `x' "cluster"	// e(vce) = "cluster"
		}					// w/out varname
		if "``x'type'" == "hac" {
			if ``x'haclag' == -1 {
				if "``x'opts'" == "" {
					ereturn local `x' "hac ``x'hac' opt"
				}
				else ereturn local `x' "hac ``x'hac' opt ``x'opts'"
			}
			else {
				ereturn local `x' "hac ``x'hac' ``x'haclag'"
			}
		}
		if "``x'type'" == "unadj" {
			ereturn local `x' "unadjusted"
		}
		if "``x'type'" == "xt" {
			ereturn local `x' "XT"
		}
	}
	if "`wmatrixhaclag'" == "-1" {	may be undef; treat as string
		ereturn scalar wlagopt = `wmatrixhaclagused'
	}
	else if "`wmatrixhaclag'" != "" {
		ereturn scalar wmatlags = `wmatrixhaclag'
	}
	if "`vcehaclag'" == "-1" {
		ereturn scalar vcelagopt = `vcehaclagused'
	}
	else if "`vcehaclag'" != "" {
		ereturn scalar vcelags = `vcehaclag'
	}
	
	if "`weight'`exp'" != "" {
		ereturn local wtype "`weight'"
		ereturn local wexp  "`exp'"
	}

	if "`variables'" != "" {
		ereturn local rhs `"`variables'"'
	}

	if "`twostep'" != "" {
		ereturn local estimator "twostep"
	}
	else if "`igmm'" != "" {
		ereturn local estimator "igmm"
		ereturn scalar ic = `igmmcnt'
	}
	else {
		ereturn local estimator "onestep"
	}

	if "`winitial'" == "user" {
		tempname Wuser2		// so user's matrix isn't dropped
		mat `Wuser2' = `winitusr'	// when we put in e(Wuser)
		ereturn matrix Wuser = `Wuser2'
		ereturn local winit "user"
		ereturn local winitname "`winitusr'"
	}
	else if "`winitial'" == "identity" {
		ereturn local winit "Identity"
	}
	else if "`winitial'" == "xt" {
		ereturn local winit "XT `winitopts'"
	}
	else {
		ereturn local winit "Unadjusted"
	}

	if "`usrpanvar'" != "" {
		if "`usrtimevar'" != "" {
			qui xtset `usrpanvar' `usrtimevar', 		///
				delta(`=`usrtdelta'') format(`usrtsfmt')
		}
		else {
			qui xtset `usrpanvar'
		}
		ereturn hidden local group `usrpanvar'
	}

	if "`nocommonesample'" != "" {
		ereturn local nocommonesample "nocommonesample"
		ereturn matrix N_byequation = `normNmat'
	}

	ereturn local technique `technique'
	ereturn local eqnames `eqnames'	
	ereturn local marginsprop allcons nochainrule
	ereturn local marginsok xb
	ereturn local marginsnotok "Residuals SCores"
	ereturn local predict "gmm_p"
	ereturn local estat_cmd "gmm_estat"
	ereturn local cmd "gmm"

	if "`fiterlogonly'`iterlogonly'" == "" {
		GMMout, `diopts'
	}
end

program GMMout
	syntax [, level(cilevel) COEFLegend selegend *]

	_get_diopts diopts, `coeflegend' `selegend' `options'

	local EXPRESSION = 1
	local PROGRAM = 2
	local robust
	local hac
	local bs
	if bsubstr("`e(vcetype)'", 1, 6) == "Robust" | "`e(clustvar)'" != "" {
		local robust "yes"
	}

	if bsubstr(`"`e(vcetype)'"', 1, 9) == "Bootstrap" | ///
		bsubstr(`"`e(vcetype)'"', 1, 9) == "Jackknife" {
		local bs "yes"
	}

	local anyrobust 0

	di
	di as text "GMM estimation "
	di
	
	tempname left right
	.`left' = {}	
	.`right' = {}
	local C1 "_col(1)"
	local C2 "_col(24)"
	local C3 "_col(51)"
	local C4 "_col(67)"

	.`left'.Arrpush `C1' as text "Number of parameters = "	///
		`C2' as result %3.0f e(k)
	.`left'.Arrpush `C1' as text "Number of moments    = "	///
		`C2' as result %3.0f e(n_moments)
	.`left'.Arrpush `C1' as text "Initial weight matrix: "	///
		`C2' as res "`e(winit)'"
	if "`e(estimator)'" != "onestep" {
		local wstr
		if "`e(wmatrix)'" == "unadjusted" | 			///
			"`e(wmatrix)'" == "robust" {
			local wstr `=proper("`e(wmatrix)'")'
		}
		else if `"`: word 1 of `e(wmatrix)''"' == "cluster" {
			local clv : word 2 of `e(wmatrix)'
			local wstr "Cluster (" abbrev("`clv'",13) ")"
		}
		else {				// must be HAC
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
				local wstr 			///
				"`wstr'`:di %`wlagfmt' `e(wlagopt)''"
			}
			else {
				local lag `e(wmatlags)'
				local wstr `"`wstr'`lag'"'
			}	
		}
		.`left'.Arrpush `C1' as text "GMM weight matrix: " 	///
			`C2' as res "`wstr'"
		if "`e(wlagopt)'" != "" {
			.`left'.Arrpush `C2' as text			///
				"(lags chosen by Newey-West)"
		}
	}
	.`right'.Arrpush ""
	.`right'.Arrpush ""
	if "`e(nocommonesample)'" == "nocommonesample" {
		.`right'.Arrpush `C3' as text "Number of obs" 		///
			`C4' "= " as res "  *"
	}
	else {
		.`right'.Arrpush `C3' as text "Number of obs"		///
			`C4' "= " as res %10.0fc e(N)
	}

	local nl = `.`left'.arrnels'
	local nr = `.`right'.arrnels'
	local k = max(`nl', `nr')
	forvalues i = 1/`k' {
		di as text `.`left'[`i']' as text `.`right'[`i']'
	}
	
	di
	if `"`e(title)'"' != "" {
		di as text `"`e(title)'"'
	}
	if `"`e(title_2)'"' != "" { 
		di as text `"`e(title_2)'"'
	}

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
	
	if "`e(nocommonesample)'" == "nocommonesample" {
		di as res "*" _c
		tempname Nmat
		matrix `Nmat' = e(N_byequation)
		forvalues i = 1/`=e(n_eq)' {
			local eq : word `i' of `e(eqnames)'
			di in smcl as text _col(3) "Number of observations " ///
			 "for equation " as res "`eq'" as text ": "          ///
			 as res `Nmat'[1,`i']
		}
		di in smcl as text "{hline 78}"
	}
	forvalues i = 1/`=e(n_eq)' {
		local eq : word `i' of `e(eqnames)'
		if `e(has_xtinst)' {
			di in smcl as text "Instruments for equation " 	///
				as res "`eq'" as text ":"
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
				di in smcl 				///
			    	"{p 8 18 4}{txt}XT-style: {res}`allxt'{p_end}"
			}
			if "`e(inst_`i')'" != "" & `e(has_xtinst)' {
				di in smcl 	 			///
			    "{p 8 18 4}{txt}Standard: {res}`e(inst_`i')'{p_end}"
			}
			else if "`e(inst_`i')'" != "" {
				di in smcl				///
			    	"{p 4 8 4}{res}`e(inst_`i')'{p_end}
			}
		}
		else {
			di in smcl "{p 0 4 4}{txt}Instruments for " ///
			 "equation {res}`eq'{txt}: {res}`e(inst_`i')'{p_end}"
		}
	}
	ml_footnote
end

program ParseInst, sclass

	args instlist eqnames touse rmcoll

	sreturn clear
	local noc: subinstr local instlist ":" "", all 
	local hasl: length local instlist
	local haslc: length local noc
	local hasc = `hasl' != `haslc'
	if !`hasc' {
		// if user doesn't specify eq, apply inst to all eqs.
		local inst `instlist'
		local en : list sizeof eqnames
		forvalues i = 1/`en' {
			local eqn `eqn' `i'
		}
	}
	else {
		gettoken pre inst : instlist, p(":") bind
		gettoken colon inst : inst, p(":") bind
		capture numlist "`pre'"
		if !_rc {
			local pre `r(numlist)'
		}
		// multiple equations specified before the colon
		foreach x of local pre {
			if bsubstr(`"`x'"',1,1) == "#" {
				local x = bsubstr(`"`x'"',2,.)
			}
			capture confirm integer number `x'
			if !_rc {
				local eqn `eqn' `x'
			}
			else {
				local xeq : list posof "`x'" in eqnames
				if `xeq' == 0 {
					di as err "invalid equation " ///
					 "{bf:`x'} specified in "     ///
					 "{bf:instruments()}"
					exit 498
				}
				local eqn `eqn' `xeq'
			}
		}
	}	
	local eqn : list clean eqn
	
	local 0 `inst'

	cap noi syntax [varlist(numeric fv ts default=none)] , [ noCONStant ]
	local rc = c(rc)
	if `rc' {
		di as err "{p 2}in option {bf:instruments()}{p_end}"
		exit `rc'
	}
	fvexpand `varlist' if `touse'
	local vlist `r(varlist)'
	if "`constant'" == "noconstant" {
		local nocons nocons
	}
	if (`rmcoll') {
		qui _rmcoll `vlist' if `touse', `nocons' expand
		local inst `r(varlist)'
		local kcollin = r(k_omitted)
		if `kcollin' {
			local cvars : list vlist - inst
			if "`cvars'" != "" {
				/* r(k_omitted) includes base groups    */
				local kcollin : list sizeof cvars
				local instr = plural(`kcollin',"instrument")
				di as txt "{p 0 2 6}note: `instr' `cvars' " ///
				 "omitted because of collinearity{p_end}"
                        }
                }
		sreturn local kcollin = `kcollin'
	}
	else {
		sreturn local kcollin = 0
		local inst `vlist'
	}
	sreturn local nocons `nocons'
	sreturn local eqn `eqn'
	sreturn local inst `inst'
end

program InstrumentCMatrix, rclass
	args instr

	tempname C

	local vlist `instr'
	local nv : list sizeof instr

	local i = 0
	local j = 0
	while "`vlist'" != "" {
		gettoken expr vlist : vlist, bind
		local `++j'
		_ms_parse_parts `expr'

		if r(omit) {
			mat `C' = (nullmat(`C')\J(1,`nv',0))
			mat `C'[`++i',`j'] = 1
		}
	}
	cap confirm matrix `C'
	if !c(rc) {
		mat colnames `C' = `instr'
		return local hasCmat = 1
		return matrix C = `C'
	}
	else return local hasCmat = 0

	return local varlist `instr'
end

program ParseXTInst, sclass
	args instlist eqnames
	
	sreturn clear

	if !strmatch(`"`instlist'"', "*:*") {
		// if user doesn't specify eq, apply inst to all eqs.
		local inst `instlist'
		local en : list sizeof eqnames
		forvalues i = 1/`en' {
			local eqn `eqn' `i'
		}
	}
	else {
		gettoken pre inst : instlist, p(":") bind
		gettoken colon inst : inst, p(":") bind
		capture numlist "`pre'"
		if !_rc {
			local pre `r(numlist)'
		}
		foreach x of local pre {
			if bsubstr(`"`x'"',1,1) == "#" {
				local x = bsubstr(`"`x'"',2,.)
			}
			capture confirm integer number `x'
			if !_rc {
				local eqn `eqn' `x'
			}
			else {
				local xeq : list posof "`x'" in eqnames
				if `xeq' == 0 {
					di as err "invalid equation " ///
					 "{bf:`x'} specified in "     ///
					 "{bf:xtinstruments()}"
					exit 498
				}
				local eqn `eqn' `xeq'
			}
		}
	}
	
	local 0 `inst'
 	cap noi syntax varlist(numeric ts), [Lags(string)]
	if _rc {
		di in smcl as error		///
			"error in {bf:xtinstruments()}
		exit 198
	}
	if `"`lags'"' == "" {
		di as err "option {bf:lags()} required in option " ///
		 "{bf:xtinstruments()}"
		exit 198
	}
	
	// See if lags specified as "#/."
	gettoken first second : lags, parse("/")
	gettoken slash second : second, parse("/")
	local first `=trim(`"`first'"')'
	local second `=trim(`"`second'"')'
	
	if "`slash'" == "/" & "`second'" == "." {
		local xtlags "`first' ."
	}
	else {
		capture numlist "`lags'", integer sort
		if _rc {
			di as err "{p}invalid numlist in option {bf:lags()" ///
			 "of option {bf:xtinstruments()}{p_end}"
			exit 121
		}
		local xtlags `r(numlist)'
	}

	sreturn local xteqn  `eqn'
	sreturn local xtinst `varlist'
	sreturn local xtlags `xtlags'
end

program GetEqName, sclass
	args fullexpr
	
	gettoken name rest : fullexpr, parse(":") bind

	if `"`rest'"' == "" {		// no colon found --> no name
		sreturn local eqname ""
		sreturn local eqn `fullexpr'
		exit
	}
	gettoken colon rest : rest, parse(":") bind

	confirm name `name'
	if `:list sizeof name' > 1 {
		di as error `"`name' invalid name"'
		exit 7
	}
	sreturn local eqname `name'
	sreturn local eqn `rest'
end

program StripEqName, sclass
	args expr eqname

	cap confirm integer number `eqname'
	if !c(rc) {
		sreturn local eqname `eqname'
		sreturn local eqn `"`expr'"'
		exit
	}
	local k = strpos("`expr'","`eqname':")
	if `k' != 1 {
		sreturn local eqname `eqname'
		sreturn local eqn `"`expr'"'
		exit
	}
	local eqn = subinstr(`"`expr'"',"`eqname':","",1)

	sreturn local eqname `eqname'
	sreturn local eqn `"`eqn'"'
end

program ParseWinit, sclass
	args winitial
	
	local error as err "option {bf:winitial()} invalid"

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
			di as err "matrix `winitial' not found"
			exit 198
		}
		if "`winitopts'" != "" {
			di as err "{p}cannot specify {bf:independent} with " ///
			 "user-supplied initial weight matrix{p_end}"
			exit 198
		}
		local winitusr `winitial'
		local winitial "user"
	}
	else {					// either XT or an error
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
		if "`winitopts'" != "" {		// not allowed w/ XT
			di `error'
			exit 198
		}
		local winitopts = upper("`spec'")
		local winitial "xt"
	
	}
	
	sreturn local winitopts `winitopts'
	sreturn local winitusr  `winitusr'
	sreturn local winitial	`winitial'
end

/*
	Takes two varlists: one a fvexpanded varlist and the other a list
	   of temporary variables created by fvrevar.  Removes from both
	   lists base categories and other omitted levels.
	
	r(varlist)	-- cleaned up varlist
	r(tmpvarlist)	-- cleaned up tempvarlist
	
*/
program FVOmitBase, rclass
	args vlist tmplist
	
	local cleanvlist
	local cleantmplist
	
	local i 1
	foreach v of local vlist {
		_ms_parse_parts `v'
		if !`r(omit)' {
			local cleanvlist `cleanvlist' `v'
			local tmpvar : word `i' of `tmplist'
			local cleantmplist `cleantmplist' `tmpvar'
		}
		local `++i'
	}

	return local varlist 	`cleanvlist'
	return local tmpvarlist `cleantmplist'
end

/*
	With a type-2 evaluator, the user can specify full equation names
	subject to the following:
		
		1. You may specify parameters of the form
			<eqname>:<varname>
		2. If you provide equation names, you must do so for ALL
		   parameters.
		3. If you use this syntax, <varname> must either be an
		   existing variable in the dataset or "_cons" to 
		   indicate a constant (e.g. rho:_cons)
		   
	This program checks to make sure those three requirements are
	met.
	
	It returns a clean varlist, with factor-variable operated variables
	expanded.
*/
program ParseParameters, rclass
	args parameters touse one vn

	local plist : subinstr local parameters ":" ":", all count(local haseqs)
	if !`haseqs' {
		// names for the parameters, not a coef stripe
		local plist `: list clean plist'
		local vlist `plist'
		while "`vlist'" != "" {
			gettoken v vlist : vlist, bind

			cap confirm name `v'
			if c(rc) {
				di as err "{p}option {bf:parameters()} " ///
				 "is invalid; `v' is not a legal name{p_end}"
				exit 198
			}
		}	
		return local stripe `plist'
		return local keq = 0
		exit
	}
	local plist : subinstr local plist "{" "{", all count(local klb)
	local plist : subinstr local plist "}" "}", all count(local krb)
	if `vn'<14 & (`klb' | `krb') {
		ParamEqErr2
		// back hole
	}
	if `klb' != `krb' {
		di as err "{p}option {bf:parameters()} is invalid; " ///
		 "matching brace not found{p_end}"
		exit 198
	}
	if `klb' {
		// {eq: varlist} ...
		ParseParam1 `"`plist'"' `touse' `one'
	}
	else {
		// eq:var1 eq:var2 ...
		ParseParam2 `"`plist'"' `touse'
	}
	return add
end

program SubstituteConstant, sclass
	args eqn one

	local k = strpos(`"`eqn'"',"_cons")
	if !`k' {
		sreturn local eqn `"`eqn'"'
		sreturn local hascons = 0
		exit
	}
	local k1 = `k'-1
	local eqn1 = bsubstr(`"`eqn'"',1,`k1')
	local eqn2 = bsubstr(`"`eqn'"',`k',.)
	local eqn2 : subinstr local eqn2 "_cons" "`one'", word all

	local eqn `"`eqn1'`eqn2'"'

	sreturn local eqn `"`eqn'"'
	sreturn local hascons = 1
end

program ParseParam1, rclass
	args parameters touse one

	tempname parseobj C0 c0
	.`parseobj' = ._parse_sexp_c.new
		
	local Cc `C0' `c0'
	local plist : list clean parameters
	local keq = 0
	local kcollin = 0
	while "`plist'" != "" {
		gettoken lbr plist : plist, parse("{")
		local k = strpos("`plist'","}")
		if "`lbr'" != "{" | !`k' {
			ParamEqErr1
			// back hole
		}
		local `++keq'

		gettoken eqn plist : plist, parse("}") 
		gettoken brace plist : plist, parse("}") bind

		local eqn`keq' `"{`eqn'}"'
		cap noi _parse_sexp, parseobj(`parseobj') eqn(`keq')   ///
			expression(`eqn`keq'') touse(`touse') cc(`Cc') ///
			noinit noreuse
		local rc = c(rc)
		if `rc' {
			if `rc' > 1 {
				di as txt "{phang}The {bf:parameters()} " ///
				 "option is incorrectly specified.{p_end}"
			}
			exit `rc'
		}
		local eq `r(eqlist)'
		local eqlist `eqlist' `eq'
		local vlist `.`parseobj'.lcvarfetch `eq''
		local const = `.`parseobj'.lcconst `eq''
		if `const' {
			local vlist `"`vlist' _cons"'
			local vlist : list retokenize vlist
		}
		local parmlist `"`r(parmlist)'"'
		local kcollin = `kcollin' + `r(kcollin)'

		local vlist`eq' `vlist'
		local stripe `"`stripe' `parmlist'"'
	}
	return local stripe `stripe'
	return local eqnames `eqlist'
	forvalues i=1/`keq' {
		local eq : word `i' of `eqlist'
		return local eq`i'vars `vlist`eq''
	}
	return local keq = `keq'
	return local kcollin = `kcollin'
	cap confirm matrix `C0'
	if !c(rc) {
		/* check for empty C0 vector				*/
		tempname x
		mat `x' = `C0'*`C0''
		if `x'[1,1] > 0 {
			return matrix C = `C0'
			return matrix c = `c0'
		}
	}
end

program ParseParam2, rclass
	args parameters touse

	local plist : list clean parameters

	local keq = 0
	local kcollin = 0
	while "`plist'" != "" {
		gettoken p plist : plist, bind
		// colon after an equation name
		if strpos(`"`p'"', ":") < 2 {
			ParamEqErr2
			// back hole
		}
		gettoken eqname vlist : p, parse(":")
		local k : list posof "`eqname'" in eqlist
		if `k' & `k'<`keq' {
			di as err "{p}parameter `p' specifies an equation " ///
			 "that is out of order; all parameters belonging "  ///
			 "to the same equation must be listed together{p_end}"
			exit 198
		}
		cap noi confirm name `eqname'
		if _rc {
			ParamEqErr2
			// back hole
		}
		// strip the colon		
		gettoken colon vlist : vlist, parse(":")
		if !`k' {
			// new equation
			tempname C`eqname'

			local eqlist `eqlist' `eqname'
			local Clist `Clist' `C`eqname''
			local `++keq'
		}
		cap noi {
			local vcons _cons
			local vcons : list vlist & vcons
			if "`vcons'" != "" {
				local vlist : list vlist - vcons
				local vlist : list clean vlist
			}
			if "`vlist'" != "" {
				// expand factor variable expression 
				fvexpand `vlist' if `touse'
				local vlist `r(varlist)'
			}
			local vlist`eqname' `vlist`eqname'' `vlist' `vcons'
		}
		if _rc {
			di as txt "{phang}The {bf:parameters()} option is " ///
			 "incorrectly specified.{p_end}"
			exit _rc
		}
	}
	local kv = 0
	local eqlist : list clean eqlist
	foreach eq of local eqlist {
		local k : list sizeof vlist`eq'
		local vlist `vlist`eq''
		if ("`eq'"!="0") local eqopt eq(`eq')

		CheckForDuplicates, vlist(`vlist') `eqopt'

		local vlist0 : subinstr local vlist "_cons" "", ///
			count(local c) word
		if (!`c') local noconst noconstant

		_rmcoll `vlist0', `noconst'
		local vlist `r(varlist)'
		fvexpand `vlist'
		local vlist `r(varlist)'
		if (`c') local vlist `"`vlist' _cons"'

		local vlist`eq' `vlist'
		local kv`eq' = `k'
		local kv = `kv' + `k'
		local j = 0
		local i = 0 
		while "`vlist'" != "" {
			gettoken var vlist: vlist, bind

			local stripe `"`stripe' `eq':`var'"'
			local `++j'

			if "`var'" == "_cons" {
				continue
			}
			_ms_parse_parts `var'
			if r(omit) {
				mat `C`eq'' = (nullmat(`C`eq'')\J(1,`k',0))
				local i = rowsof(`C`eq'')
				mat `C`eq''[`i',`j'] = 1
			}
		}
		local kc`eq' = `i'
		local kc = `kc' + `i'
	}
	local stripe : list clean stripe
	if `kc' {
		// at least one eq constraint mat; build model constr mat
		tempname C c
		mat `C' = J(`kc',`kv',0)
		local k2 = 0
		local l2 = 0
		foreach eq of local eqlist {
			local l1 = `l2' + 1
			local l2 = `l2' + `kv`eq''
			cap confirm matrix `C`eq''
			if c(rc) {
				continue
			}
			local kr = rowsof(`C`eq'')
			local k1 = `k2' + 1
			local k2 = `k2' + `kr'
			nobreak {
				// TGFM
				mata: `C' = st_matrix("`C'");         ///
				      `C'[|`k1',`l1' \ `k2',`l2'|] =  ///
						st_matrix("`C`eq''"); ///
				      st_matrix("`C'",`C'); `C' = J(0,0,0)
			}
		}
		mat `c' = J(`k2',1,0)
		mat colnames `C' = `stripe'
		return mat C = `C'
		return mat c = `c'
	}
	// canonical eqname:varname form
	return local stripe `stripe'
	return local eqnames `eqlist'
	forvalues i=1/`keq' {
		local eq : word `i' of `eqlist'
		return local eq`i'vars `vlist`eq''
	}
	return local keq = `keq'
	return local kcollin = `kcollin'
end

/* validate moment equation names & the number of moments		*/
program CheckMomentEqNames, sclass
	args neqn eqnames

	if "`eqnames'" != "" {
		local eqnames : list retok eqnames
		local keqn : list sizeof eqnames
		if `neqn' > 0 & `keqn' != `neqn' {
			di as err "{p}number of moment equation names in " ///
			 "option {bf:opt equations()} does not match "     ///
			 "{bf:nequations()}{p_end}"
			exit 198
		}
		else if `neqn' <= 0 {
			local neqn `keqn'
		}
		local eq : list uniq eqnames
		local eq0 : list eqnames - eq
		if "`eq0'" != "" {
			local eq0 : list uniq eq0
			local k : list sizeof eq0
			local eqs = plural(`k',"equation")
			local are = plural(`k',"is","are")
			di as err "{p}`eqs' `eq0' `are' used more than " ///
			 "once; this is not allowed{p_end}"
			exit 198
		}
	}
	else if `neqn' <= 0 {
		di as error "no moment equations declared"
		exit 198
	}
	else {
		forvalues i = 1/`neqn' {
			local eqnames `eqnames' `i'
		}
	}
	sreturn local neqn = `neqn'
	sreturn local eqnames `"`eqnames'"'
end

program CheckForDuplicates
	syntax, vlist(string) [ eq(string) noCONSTant]

	local vlist0 `"`vlist'"'
	local vlist : list uniq vlist0
	local dvlist : list vlist0 - vlist
	if ("`dvlist'"=="") exit

	local dvlist : list uniq dvlist
	if ("`constant'"!="" & "`dlist'"=="_cons") exit

	if "`eq'" != "" {
		local rest " in equation `eq'"
	}
	local n : list sizeof dvlist
	local var = plural(`n',"variable")
	di as err "{p}invalid {bf:parameters()}; `var' `dvlist' specified " ///
	 "more than once`rest'{p_end}"
	exit 103
end

program ParamEqErr1

	di as err "option {bf:parameters()} incorrectly specified:"
	di as txt "{p 4 4 2}If you specify equations in option "            ///
	 "{bf:parameters()} then all equation specifications must be of "   ///
	 "the form {bf:{{it:eqname}:{it:varlist}}} where {it:eqname} is a " ///
	 "valid Stata name and {it:varlist} is a list of variables that "   ///
	 "may include factor variable notation.  Include {bf:_cons} to "    ///
	 "indicate a constant term.{p_end}"
	
	exit 198
end

program ParamEqErr2

	di as err "option {bf:parameters()} incorrectly specified:"
	di as txt "{p 4 4 2}If you specify equation names in option "       ///
	 "{bf:parameters()} then all parameters must be specified using "   ///
	 "the form <{it:eqname}>:<{it:varname}> where {it:eqname} is a "    ///
	 "valid Stata name and {it:varname} is either an existing numeric " ///
	 "variable or {bf:_cons} to indicate a constant term.{p_end}"
	
	exit 198
end

