*! version 1.5.1  09oct2019
program define nlsur, eclass byable(onecall) sortpreserve

	version 9.2
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	
	`BY' _vce_parserun nlsur, jkopts(eclass) noeqlist: `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"nlsur `0'"'
		exit
	}
	
	version 9.1, missing
	
	if replay() {
		if "`e(cmd)'"!="nlsur" { 
			exit 301 
		} 
		if _by() { 
			exit 190 
		}
		NLSURout `0'
		exit
	}
	`BY' Estimate `0'
	ereturn local cmdline `"nlsur `0'"'
end
	
program define Estimate, eclass byable(recall) sortpreserve

	version 9.2
	
	local zero `0'		/* Backup copy */

	/* type = 1 : inline ftn, type = 2 : sexpprog, type = 3 : funcprog */
	local type
	gettoken eqn 0 : 0 , match(paren)
	if "`paren'" == "(" {
		local type 1
		local eqn1 `eqn'
		// Now loop through and get remaining equations
		local i 1
		local stop 0
		while !`stop' {
			gettoken eqn 0 : 0, match(paren)
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
	}
	else {
		local 0 `zero'
		local progname
		/* Parse on : and @ to see if we are called with a 
		   user-defined function.  	*/
		gettoken part 0 : 0 , parse(" :@") quotes
		while `"`part'"' != ":" & `"`part'"' != "@" & `"`part'"' != "" {
			local progname `"`progname' `part'"'
			gettoken part 0 : 0 , parse(" :@") quote
		}
		if `"`part'"' == ":" {
			local type 2
		}
		else if `"`part'"' == "@" {
			local type 3
		}
		if `"`0'"' != "" {
			syntax varlist(min=1) [if] [in] [aw fw pw iw] ,	/*
				*/ [ PARAMeters(namelist) 		/*
				*/   NPARAMeters(integer 0) 		/*
				*/   NEQuations(integer 0) * ]
			local vars `varlist'
			local params `"`parameters'"'   /* short name */
			local nparams `"`nparameters'"' /* short name */
			local 0 `"`if' `in' [`weight'`exp'] , `options'"'
		} 
		if "`type'" == "3" {	/* type may be empty ; treat as str*/
			if "`params'" == "" & `nparams' == 0 {
di as error "must specify parameters() or nparameters()"
				exit 198
			}
			local neqn `nequations'
			if `neqn' == 0 {
				di as error "must specify nequations()"
				exit 198
			}
		}
	}
	local 0 `0'		// trim white space
	// comma before options may have been stripped off by -gettoken-
	// add if no if, in, or weight expression
	if `"`=bsubstr(`"`0'"', 1, 1)'"' != "," &	///
	   `"`=bsubstr(`"`0'"', 1, 3)'"' != "if " &	/// (space for ifgnls)
	   `"`=bsubstr(`"`0'"', 1, 2)'"' != "in" &	///
	   `"`=bsubstr(`"`0'"', 1, 1)'"' != "[" {
		local 0 , `0'
	}
	syntax [if] [in] [aw fw iw pw] [, /*
		*/ DELta(real 4e-7) EPS(real 0) INitial(string)		/*
		*/ ITERate(integer 0) NOLOg LOg	 			/*
		*/ TITLE(string) TITLE2(string) TRace 			/*
		*/ Hasconstants(string) noConstants			/*
		*/ VAriables(varlist numeric ts) Robust			/*
		*/ CLuster(passthru) VCE(passthru)	 		/*
		*/ Level(cilevel) SMall					/*
		*/ IFGNLS IFGNLSIterate(integer -1) IFGNLSEPS(real 0)	/*
		*/ NLS FGNLS 						/*
		*/ NOEQTAB   /* undocumented */				/*
		*/ NOCOEFTAB /* undocumented */ 			/*
		*/ *         /* user's func. eval. prog. options */	/*
		*/ ]

	_get_diopts diopts options, `options'
	/* _vce_parserun will pass 'gnr' and 'cluster ...' */
	_vce_parse , opt(GNR Robust) argopt(CLuster) old : ///
		[`weight' `exp'], `cluster' `robust' `vce'
	local robust "`r(robust)'"
	local cluster "`r(cluster)'"
	local vce ""

	/* Syntax checking */
	if "`type'" == "" {	// couldn't figure out type of function
		di as error "invalid syntax"
		exit 198
	}
	if `type' == 1 & `"`options'"' != "" {
		di as error `"`options' not allowed"'
		exit 198
	}
	if "`hasconstants'" != "" & "`constants'" != "" {
		di as error "cannot combine hasconstants() and noconstants"
		exit 198
	}
	if "`cluster'`robust'" != "" & "`weight'" == "iweight" {
		di as error "robust variances not available with iweights"
		exit 101
	}

	if "`weight'" == "pweight" {
		local robust robust
	}

	marksample touse
	if "`cluster'" != "" {
		markout `touse' `cluster', strok
		local robust robust
	}
	if "`variables'" != "" {
		markout `touse' `variables'
	}
	if "`vars'" != "" {
		markout `touse' `vars'
	}
	
	if "`ifgnls'" == "" & `ifgnlsiterate' != -1 {
		di as error "cannot specify ifgnlsiterate() without ifgnls"
		exit 198
	}
	if "`ifgnls'" == "" & `ifgnlseps' != 0 {
		di as error "cannot specify ifgnlseps() without ifgnls"
		exit 198
	}
	if `:word count `nls' `ifgnls' `fgnls'' > 1 {
		di as error "cannot specify more than one estimator"
		exit 198
	}
	if "`nls'`fgnls'`ifgnls'" == "" {
		local fgnls fgnls
	}

	if `type' == 2 {
		local progname `progname'	// remove leading whitespace
		if `"`options'"' != "" {
			capture nlsur`progname' `vars' `wtexp' 		///
				if `touse', `options'
		}
		else {
			capture nlsur`progname' `vars' `wtexp' if `touse'
		}
		if _rc {
			di as error "nlsur`progname' returned " _rc
di as error "verify that nlsur`progname' is a substitutable expression program"
di as error "and that you have specified all options that it requires"
			exit _rc
		}
		local neqn = real(`"`r(n_eq)'"')
		if `neqn' < 2 | `neqn' >= . {
			di as error "nlsur`progname' not defined properly"
			exit 498
		}
		forvalues i = 1/`neqn' {
			local eqn`i' `"`r(eq_`i')'"'
			if `"`eqn`i''"' == "" {
				di as error "equation `i' not found"
				exit 498
			}
		}
		if `"`title'"' == "" & `"`r(title)'"' != "" {
			local title `"`r(title)'"'
		}
	}
	if `type' < 3 {
		forvalues i = 1/`neqn' {
			gettoken yname`i' eqn`i' : eqn`i' , parse("= ")
			gettoken equal eqn`i' : eqn`i' , parse("= ")
			if "`equal'" != "=" {
				local eqn`i' `equal' `eqn'`i'
			}
		}
	}

	if `type' == 2 | `type' == 3 {
		tokenize `vars'
		forvalues i = 1/`neqn' {
			local yname`i' `1'
			mac shift
		}
		local t23rhs `*'
	}
	
	tempname parmvec parmvecall sumwt meany vary gm2 
	tempname old_ssr ssr f sstot 
	
	forvalues i = 1/`neqn' {
		tsunab yname`i' : `yname`i''
		local allyname `allyname' `yname`i''
	}
	_find_tsops `allyname'
	if `r(tsops)' {
		qui tsset, noquery
		tsrevar `allyname', list
		foreach var in `r(varlist)' {
			confirm numeric variable `var'
		}
	}
	else {
		foreach var of local allyname {
			confirm numeric variable `var'
		}
	}
	
	ereturn clear

						/* set up expression for
						   evaluation and iteration */
	if `type' < 3 {
		local params
		forvalues i = 1/`neqn' {
			_parmlist `eqn`i''
			local eqn`i' `r(expr)'

			// Back up expression to return to user
			local origeqn`i' `"`eqn`i''"'

			local params`i' `r(parmlist)'
			local params : list params | params`i'
			tempname parmvec`i'
			matrix `parmvec`i'' = r(initmat)
			local np`i' : word count `params`i''
			if `np`i'' == 0 { 
				di in red "no parameters in equation `i'"
				exit 198
			}
			mat coleq `parmvec`i'' = eq`i':
			matrix `parmvecall' = 	///
				nullmat(`parmvecall'), `parmvec`i''
		}
		/* At this point, parmvecall may have the same parameter in
		   more than one equation.  We create a new vector that
		   contains just the FIRST initial value for each unique
		   parameter */
		local allparms : colnames `parmvecall'
		foreach param of local params {
			local c : list posof "`param'" in allparms
			mat `parmvec' = nullmat(`parmvec'),	///
				`parmvecall'[1, `c']
		}
		mat colnames `parmvec' = `params'
						/* set up initial values */
		foreach parm of local params {
			local j = colnumb(`parmvec', "`parm'")
			forvalues i = 1/`neqn' {
				local eqn`i' : subinstr local eqn`i' /*
					*/ "{`parm'}" "\`parmvec'[1,`j']", all
			}
		}
	}
	else {
		if "`params'" != "" {	// based on parameters() option
			local params : list retok params
			local np : word count `params'
			if `nparams' > 0 & `nparams' != `np' {
				di as error ///
"number of parameters in parameters() does not match nparameters()"
				exit 198
			}
			else if `nparams' <= 0 {
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
	}
	
	local np : word count `params'	/* rest of code uses np */

	/* Initial() option overrides other initial values.  */
	if "`initial'" != "" {
		if `:word count `initial'' == 1 {	/* matrix */
			capture confirm matrix `initial'
			if _rc {
				di as error "matrix `initial' not found"
				exit 480
			}
			if `=colsof(`initial')' != `np' {
				di as error /*
*/ "initial matrix must have as many columns as parameters in model"
				exit 480
			}
			matrix `parmvec' = `initial'
			matrix colnames `parmvec' = `params'
		}
		else {				/* Must be <parm> # ... */
			if mod(`:word count `initial'', 2) != 0 {
				di as error "invalid initial() option"
				exit 480
			}
			tokenize `initial'
			while "`*'" != "" {
				capture local col = colnumb(`parmvec', "`1'")
				if _rc | `col' == . {
		di as error "invalid parameter `1' in initial()"
					exit 480
				}
				else {
					matrix `parmvec'[1, `col'] = `2'
				}
				mac shift 2
			}
		}
	}
	
	if "`constants'" == "noconstants" {	// then hasconstants undefined
		forvalues i = 1/`neqn' {
			local hasconstants "`hasconstants' ."
		}
	}
	// Check hasconstants() option
	if "`hasconstants'" != "" {
		if `:word count `hasconstants'' != `neqn' {
			di as error "option hasconstants() incorrectly specified"
			exit 198
		}
		local const 0
		foreach p of local hasconstants {
			if "`p'" != "." {
				local junk : subinstr local params "`p'" "", ///
					word all count(local j)
				if `j' == 0 {
di as error "`p' not found among parameters"
di as error "check hasconstants() option or try using nlsur without it"
					exit 498
				}
				local const 1
			}
		}
	}

	/* Now that we have initial values, verify type 3 program appropriate */
	if `type' == 3 {
		forvalues i = 1/`neqn' {
			tempvar junk`i'
			qui gen double `junk`i'' = `yname`i'' if `touse'
			local alljunk `alljunk' `junk`i''
		}
		if `"`options'"' != "" {
			local fopts `"`options'"'
			capture noi nlsur`eqn' `alljunk' `t23rhs' `wtexp' 	/*
				*/ if `touse', `fopts' at(`parmvec')
		}
		else {
			capture nlsur`eqn' `alljunk' `t23rhs' `wtexp' 	/*
				*/ if `touse', at(`parmvec')
		}
		if _rc {
			di as error "nlsur`eqn' returned " _rc
di as error "verify that nlsur`eqn' is a function evaluator program"
			exit _rc
		}

	}
	local funcerr "error #\`rc' occurred in evaluating equation"

/*
		iterate is the max iterations allowed.
		eps and tau control parameter convergence, see Gallant p 28.
		delta is a proportional increment for calculating derivatives,
		appropriately modified for very small parameter values.
*/
	local iterate = cond(`iterate'<=0, c(maxiter), `iterate')
	local eps = cond(`eps'<=0, 1e-5, `eps')
	local tau 1e-3
	
/*	ifgnlsiterate is the maximum iterations of FGNLS
		estimation to perform.
	ifgnlseps if for relative change in cov. matrix for ifgnls
*/
	local ifgnlsiterate = 		///
		cond(`ifgnlsiterate'<=0, c(maxiter), `ifgnlsiterate')	
	local ifgnlseps = cond(`ifgnlseps'<=0, 1e-10, `ifgnlseps')


/*
	neqn = number of equations
	eqn`i' 		contains formula for `i'th equation, with 
			parameter names replaced with references to
			`parmvec' column
	yname`i'	dependent variable for `i'th equation
	yhat`i'		holds predicted value for `i'th equation
	resid`i'	holds residual for `i'th equation
	J`i'_`j'	derivative of `i'th function wrt `j'th param
	est_type	estimator type (1, 2, or 3)
	t3_prog		program name for type-3 estimator
	t23_rhs		All variables except the first `neqn' (types 2
			and 3 only)
	touse		touse variable
	Store these in global macros with prefix NLS_ so we don't
	have to mess with passing arbitrary numbers of arguments
	to functions.
	
	Be sure to delete when done.
*/
	global NLS_est_type `type'
	global NLS_yhatnames ""
	global NLS_neqn = `neqn'
	global NLS_touse `touse'
	forvalues i = 1/`neqn' {
		global NLS_eqn`i' `"`eqn`i''"'
		global NLS_yname`i' `"`yname`i''"'
		tempvar yhat`i' resid`i'
		qui gen double `yhat`i'' = .
		global NLS_yhat`i' `yhat`i''
		global NLS_yhatnames $NLS_yhatnames `yhat`i''
		qui gen double `resid`i'' = .
		global NLS_resid`i' `resid`i''
		forvalues j = 1/`np' {
			tempvar J`i'_`j'
			qui gen double `J`i'_`j'' = .
			global NLS_J`i'_`j' `J`i'_`j''
		}
	}
	if `type' == 3 {
		global NLS_t3_prog `"`eqn'"'
	}
	if `type' == 2 | `type' == 3 {
		global NLS_t23_rhs `"`t23rhs'"'
	}

	tempvar Z tmp dbeta 	/* dbeta for _est hold */
	qui gen double `Z' = 0 if `touse' 

	// Update touse for observations for which depvars are missing 
	forvalues i = 1/`neqn' {
		qui replace `touse' = 0 if `yname`i'' >= .
	}
	
	// Here we generate weights and sample size that are suitable
	// for use within Mata, since it does not differentiate
	// between fw, aw, pw, or iw
	tempvar normwt
	if `"`exp'"' != "" {
		qui gen double `normwt' `exp' if `touse'
		if "`weight'" == "aweight" | "`weight'" == "pweight" {
			summ `normwt' if `touse', mean
			qui replace `normwt' = r(N)*`normwt'/r(sum)
		}
	}
	else {
		qui gen double `normwt' = 1 if `touse'
	}
	summ `normwt' if `touse', mean
	if "`weight'" == "iweight" {
		local normN = trunc(r(sum))
	}
	else {
		local normN = r(sum)
	}
	
	if `"`exp'"' != "" & "`weight'" != "iweight" {
		qui summ `:subinstr local exp "=" ""' if `touse'
		noi di in gr "(sum of wgt is " r(sum) ")"
	}
	else {
		qui count if `touse'
		di in gr "(obs = " string(`normN', "%12.0fc") ")"
	}
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"=="" { 
		di 
	}

	qui count if `touse'
	if r(N) < `np' {
		di as err "cannot have fewer observations than parameters"
		exit 2001
	}

	// Make sure all LHS variables have variance
	forvalues i = 1 / `neqn' {
		qui summ `yname`i'' [iw=`normwt'] if `touse', meanonly
		if r(min) == r(max) {
			di as err "`yname`i'' has zero variance"
			exit 498
		}
	}

	local df = `normN'

	tempname initvec		/* For returning to user */
	matrix `initvec' = `parmvec'

	tempname glsmat var convflag
	
	// First use identity matrix for weights
	di as text "Calculating NLS estimates..."
	mat `glsmat' = I(`neqn')
	if "`weight'" == "" {
		local sstype "Residual "
	}
	else {
		local sstype "Scaled R"
	}
	MinSSQ `"`params'"' `parmvec' `var' `touse' `glsmat' 		///
		`normwt' "`log'" "`trace'" `iterate' 			///
		`delta' `eps' `tau' `convflag' "`sstype'" `"`fopts'"'
	CalcErrCov `parmvec' `glsmat' `normwt' `df' `"`fopts'"'
	if "`nls'" != "" {
		mat `glsmat' = diag(vecdiag(`glsmat'))
		MinSSQ `"`params'"' `parmvec' `var' `touse' `glsmat' 	///
			`normwt' "nolog" "" `iterate'			///
			`delta' `eps' `tau' `convflag' "" `"`fopts'"'
	}	
	else {
		// Now get second-step estimates
		di as text "Calculating FGNLS estimates..."
		MinSSQ `"`params'"' `parmvec' `var' `touse' `glsmat' 	///
			`normwt' "`log'" "`trace'" `iterate' 		///
			`delta' `eps' `tau' `convflag' "Scaled R" `"`fopts'"'
	}
	if "`ifgnls'" != "" {
		tempname oldpvec oldglsmat paramchange glsmatchange
		CalcErrCov `parmvec' `glsmat' `normwt' `df' `"`fopts'"'
		local istop 0
		local iiter 2		// We already did 1 iteration of FGNLS
		while `istop' == 0 {
			di as text "FGNLS iteration `iiter'..."
			mat `oldpvec' = `parmvec'
			mat `oldglsmat' = `glsmat'
			MinSSQ `"`params'"' `parmvec' `var' `touse' `glsmat' ///
				`normwt' "`log'" "`trace'" `iterate' 	///
				`delta' `eps' `tau' `convflag'		///
				"Scaled R" `"`fopts'"'
			local `++iiter'
			CalcErrCov `parmvec' `glsmat' `normwt' `df' `"`fopts'"'
			sca `paramchange' = mreldif(`oldpvec', `parmvec')
			sca `glsmatchange' = mreldif(`oldglsmat', `glsmat')
			if "`log'" != "nolog" {
				di as text 			///
			    "Parameter change         = " %10.3e `paramchange'
			    	di as text			///
			    "Covariance matrix change = " %10.3e `glsmatchange'
			}
			if `paramchange' < `eps' | 	 ///
			   `glsmatchange' < `ifgnlseps' | ///
			   `iiter' > `ifgnlsiterate'	{
				local istop 1
			}
			if `iiter' > `ifgnlsiterate' {
				local convflag 0
			}
		}
	}
	if "`robust'" != "" {
		FunctionEval `parmvec' $NLS_yhatnames `"`fopts'"'
		FunctionDeriv `"`params'"' "`parmvec'" "`touse'"	///
				"`delta'" "" `"`fopts'"'
		forvalues i = 1/$NLS_neqn {
			qui replace ${NLS_resid`i'} = ${NLS_yname`i'} -	///
						      ${NLS_yhat`i'}
			forvalues j = 1/`np' {
				local Jnames `Jnames' ${NLS_J`i'_`j'}
			}
			local residnames `residnames' ${NLS_resid`i'}
		}
		tempname nclust	// filled in if cluster-robust
		if "`cluster'" != "" {
			sort `cluster', stable // program declared sortpreserve
			local cltype : type `cluster'
			if bsubstr("`cltype'", 1, 3) == "str" {
				tempvar clus2
				qui by `cluster': gen `c(obs_t)' `clus2' = 1 if _n==1
				qui replace `clus2' = sum(`clus2')
			}
			else {
				local clus2 `cluster'
			}
		}
		mata:CalcRobustVCE("`Jnames'", "`residnames'", 		///
			"`glsmat'", "`var'", "`normwt'", 		///
			"`clus2'", "`nclust'", "`touse'",		///
			"`weight'")
	}

	// Each parameter is its own "equation;" rename here
	// Rename a copy, not the param vector we are using,
	// because our code depends on the names of the param 
	// vector.
	tempname b V
	tempvar touse2
	mat `b' = `parmvec'
	mat `V' = 0.5*(`var' + `var'')

	qui gen byte `touse2' = `touse'
	foreach x of local params {
		local pareqn `"`pareqn' `x':_cons"'
	}
	matrix roweq `V' = `pareqn'
	matrix coleq `V' = `pareqn'
	matrix coleq `b' = `pareqn'
	ereturn post `b' `V', esample(`touse2')

	ereturn scalar N = `normN'
	if "`ifgnls'" != "" {
		ereturn scalar ic = `iiter'-1	// incremented at end of loop
	}

	quietly {
		// Check if sd(any derivative vector) = 0, i.e. that
		// that parameter is a 'regression constant'
		// to reasonable accuracy.
		FunctionEval `parmvec' $NLS_yhatnames `"`fopts'"'
		if "`hasconstants'" == "" {
			// Set up tempvars for yhat(beta+delta)
			forvalues i = 1 / `neqn' {
				tempvar yhat`i'd
				gen double `yhat`i'd' = .
				local yhatdnames `yhatdnames' `yhat`i'd'
			}
			FunctionDeriv `"`params'"' "`parmvec'"		///
				       "`touse'" "`delta'" "`trace'" `"`fopts'"'
			forvalues i = 1 / `neqn' {
				local eqcons 0
				foreach parm of local params`i' {
					local parmcol = 		///
						colnumb(`parmvec', "`parm'")
					su ${NLS_J`i'_`parmcol'} 	///
						[iw=`normwt'] if `touse'
					if sqrt(r(Var)) < 		///
						`eps'*(abs(r(mean))+`tau') {
						local eqcons 1
						local const 1
						local hasconstants /*
						 	*/ `hasconstants' `parm'
						continue, break
					}
				}
				if `eqcons' == 0 {
					local hasconstants `hasconstants' .
				}
			}
		}

		// Get equation-level R^2's
		tempvar tmp
		tempname rss mss
		gen double `tmp' = .
		local mywt "`weight'"
		if "`weight'" == "pweight" {	// -su- dislikes pw
			local mywt "aweight"	// aw will work here
		}
		// divisor is what -su- divides SSR by to get variance
		if "`weight'" == "iweight" {
			local divisor "(r(sum_w) - 1)"
			local scfactor "1"
		}
		else {
			local divisor "(r(N) - 1)"
			// -summarize- returns
			// r(sum) = Sum w(i)*y(i), w(i) not normalized
			// so we need to normalize ourselves to get sum of sq's.
			local scfactor "r(N)/r(sum_w)"
		}
		forvalues i = 1 / `neqn' {
			// Get RSS
			replace `tmp' =	(${NLS_yname`i'} - ${NLS_yhat`i'})^2
			su `tmp' [`mywt'`exp'] if `touse' 
			sca `rss' = r(sum)*`scfactor'
			// Get TSS -> MSS = TSS - RSS
			local consi : word `i' of `hasconstants'
			local consi = ("`consi'" != ".")
			if `consi' {
				su ${NLS_yname`i'} [`mywt'`exp'] if `touse'
				sca `mss' = r(Var)*`divisor' - `rss'
			}
			else {
				replace `tmp' = ${NLS_yname`i'}^2
				su `tmp' [`mywt'`exp'] if `touse'
				sca `mss' = r(sum)*`scfactor' - `rss'
			}
			ereturn scalar rss_`i' = `rss'
			ereturn scalar mss_`i' = `mss'
 			ereturn scalar r2_`i' = `mss'/(`mss' + `rss')
 			if "`small'" == "" {
 				local adjdiv = `divisor' + 1
 			}
 			else {
 				if `type' < 3 {
 					local adjdiv = `divisor' + `consi' - ///
 							`np`i''
 				}
 				else {
 					local adjdiv = `divisor' + `consi' - ///
 							(`np'/`neqn')
 				}
 			}
			ereturn scalar rmse_`i' = sqrt(`rss' /	`adjdiv')
			// Return other eq-level stuff while we're looping
			if `type' != 3 {
				ereturn scalar k_`i' = `np`i''
				ereturn local sexp_`i' `origeqn`i''
			}
		}
	}	// end of quietly block

	forvalues i = 1/`neqn' {
		ereturn local depvar_`i' `"${NLS_yname`i'}"'
		ereturn local params_`i' `params`i''		
	}

	local depvar `allyname'
	local depvar : list uniq depvar
	// e(depvar) undocumented; used to make -estat summ- work
	ereturn local depvar `depvar'
	
	ereturn local params `params'
	ereturn local type `type'
	mat colnames `glsmat' = `allyname'
	mat rownames `glsmat' = `allyname'
	ereturn matrix Sigma = `glsmat'
	// Use new Sigma to match -sureg-
	tempname newglsmat
	CalcErrCov `parmvec' `newglsmat' `normwt' `df' `"`fopts'"'
	ereturn scalar ll = -0.5*(e(N)*`neqn' + 		///
				  e(N)*`neqn'*ln(2*_pi) +	///
				  e(N)*ln(det(`newglsmat')))
	ereturn matrix init = `initvec'
	ereturn local constants `"`hasconstants'"'
	ereturn scalar k_eq = `neqn'
	ereturn scalar n_eq = `neqn'
	ereturn scalar k = `np'
	ereturn hidden scalar k_aux = `np'
	ereturn scalar k_eq_model = 0		// Do not do model test
	
	ereturn local method "`nls'`fgnls'`ifgnls'"
	
	if `"`title'"' != "" {
		ereturn local title `"`title'"'	
	}
	if `"`title2'"' != "" {
		ereturn local title_2 `"`title2'"'	
	}

	if `"`robust'"' != "" {
		ereturn local vce "robust"
		ereturn local vcetype "Robust"
	}
	if `"`cluster'"' != "" {
		ereturn local vce "cluster"
		ereturn local vcetype "Robust"
		ereturn local clustvar "`cluster'"
		ereturn scalar N_clust = `nclust'
	}
	if `"`robust'`cluster'"' == "" {
		ereturn local vce "gnr"
	}
	if "`weight'`exp'" != "" {
		ereturn local wtype "`weight'"
		ereturn local wexp  "`exp'"
	}
	if `type' == 2 {
		ereturn local sexpprog nlsur`progname'
		ereturn local rhs `t23rhs'
		if `:length local t23rhs' {
			ereturn hidden local covariates `t23rhs'
		}
		else {
			ereturn hidden local covariates _NONE
		}
	}
	else if `type' == 3 {
		ereturn local funcprog nlsur`eqn'
		ereturn local rhs `t23rhs'
		if `:length local t23rhs' {
			ereturn hidden local covariates `t23rhs'
		}
		else {
			ereturn hidden local covariates _NONE
		}
	}
	else if "`variables'" != "" {
		ereturn local rhs `"`variables'"'
		ereturn hidden local covariates `"`variables'"'
	}
	else {
		ereturn hidden local covariates _NONE
	}
	if "`cluster'" != "" {
		mat `V' = e(V)
		if e(N_clust) == 1 {
			mat `V' = J(rowsof(`V'),colsof(`V'),0)
		}
		else {
			mat `V' = `V' * (e(N)-1) / (e(N) - e(k)) * 	///
				(e(N_clust)/(e(N_clust)-1))
		}
		ereturn repost V = `V'
	}
	else if "`small'" != "" {
		mat `V' = e(V)
		mat `V' = `V'*e(N) / (e(N) - e(k))
		ereturn repost V = `V'
		ereturn local small "small"
		ereturn scalar df_r = (e(N) - e(k))
	}
	
	ereturn hidden scalar converge = `convflag'
	ereturn scalar converged = `convflag'
	
	macro drop NLS_neqn
	macro drop NLS_yhatnames
	forvalues i = 1/`neqn' {
		macro drop NLS_eqn`i'
		macro drop NLS_yname`i'
		macro drop NLS_yhat`i'
		macro drop NLS_resid`i'
		forvalues j = 1/`np' {
			macro drop NLS_J`i'_`j'
		}
	}
	macro drop NLS_est_type
	macro drop NLS_t3_prog
	macro drop NLS_t23_rhs
	macro drop NLS_touse

	_post_vce_rank
	ereturn hidden local marginsprop noeb
	ereturn local estat_cmd "nlsur_estat"
	ereturn local predict "nlsur_p"
	ereturn local cmd "nlsur"
	
	NLSURout, level(`level') `diopts' `noeqtab' `nocoeftab'

end

program define NLSURout

	syntax [, Level(cilevel) NOEQTAB NOCOEFTAB *]

	_get_diopts diopts, `options'
	local robust
	local hac
	local bs
	if bsubstr("`e(vcetype)'", 1, 6) == "Robust" | "`e(clustvar)'" != "" {
		local robust "yes"
	}
	if `"`e(vcetype)'"' == "HAC" {
		local hac "yes"
		local hactype `e(hac_kernel)'
		local haclags `e(hac_lag)'
	}
	if bsubstr(`"`e(vcetype)'"', 1, 9) == "Bootstrap" | /*
		*/ bsubstr(`"`e(vcetype)'"', 1, 9) == "Jackknife" {
		local bs "yes"
	}

	local anyrobust 0

if "`noeqtab'" == "" {
	di
	if "`e(method)'" == "nls" {
		di as text "Nonlinear least-squares regression " _c
	}
	else {
		di as text "FGNLS regression " _c
	}
	di
	
	tempname mytab
	.`mytab' = ._tab.new, col(8) lmargin(0)
	.`mytab'.width   3      13  |    13     6     11     10     1    13
	.`mytab'.pad     .       1        .     1      2      4     .     .
	.`mytab'.numfmt  %2.0f   .  %11.0fc %5.0f  %9.0g  %5.4f     .     .
	.`mytab'.titlefmt %2s %12s     %11s   %6s   %11s   %10s   %1s  %12s
	.`mytab'.sep, top
	.`mytab'.titles ""					///
			"Equation"				///
			"Obs"					///
			"Parms"					///
			"RMSE"					///
			"R-sq"					///
			""					///
			"Constant"
	.`mytab'.sep, middle
	local addnote 0
	forvalues i = 1 / `e(n_eq)' {
		local vname `=abbrev("`e(depvar_`i')'", 12)'
		local star ""
		if `"`: word `i' of `e(constants)''"' == "." {
			local star "*"
			local addnote 1
		}
		local constpar : word `i' of `e(constants)'
		if "`constpar'" == "." {
			local constpar "(none)"
		}
		local constpar `=abbrev("`constpar'", 12)'
		.`mytab'.row `i'				///
			     "`vname'"				///
			     `=e(N)'				///
			     `=e(k_`i')'			///
			     `=e(rmse_`i')'			///
			     `=e(r2_`i')'			///
			     "`star'"				///
			     "`constpar'"
	}
	.`mytab'.sep, bottom
	if `addnote' {
		di as text "* Uncentered R-sq"
	}
	
	di
	if `"`e(title)'"' != "" {
		di as text `"`e(title)'"'
	}
	if `"`e(title_2)'"' != "" { 
		di as text `"`e(title_2)'"'
	}
}  // noeqtab

if "`nocoeftab'" == "" {
	// Make it appear to _coef_table that we have # equations = # params
	local j `e(k_eq)'
	mata:st_numscalar("e(k_eq)", st_numscalar("e(k)"))
	_coef_table, level(`level') `diopts'
	mata:st_numscalar("e(k_eq)", `j')
}

	if e(converge) ~= 1 {
		exit 430
	}
end

program FunctionEval

	local parmvec `1'
	macro shift

	forvalues i = 1/$NLS_neqn {
		local lhs`i' `1'
		mac shift
	}

// Now `*' has any user-specified function evaluator options if type 3 evaluator

	if $NLS_est_type < 3 {
		forvalues i = 1/$NLS_neqn {
			qui replace `lhs`i'' = ${NLS_eqn`i'} if $NLS_touse
		}
	}
	else {
		forvalues i = 1/$NLS_neqn {
			local alllhs `alllhs' `lhs`i''
		}
		nlsur${NLS_t3_prog} `alllhs' ${NLS_t23_rhs} if $NLS_touse, ///
			at(`parmvec') `*'
	}
end

// This program assumes that $NLS_yhat`i', all i, has current values
// based on the values in `parmvec' passed to it.
program FunctionDeriv

	foreach item in params parmvec touse delta trace {
		local `item' `1'
		mac shift
	}
	local fopts `*'
	
	tempname incr old_pj
	
	// Set up tempvars for yhat(beta+delta)
	forvalues i = 1 / $NLS_neqn {
		tempvar yhat`i'd
		qui gen double `yhat`i'd' = .
		local yhatdnames `yhatdnames' `yhat`i'd'
	}

	local j 1
	foreach parm of local params {
		local parmcol = colnumb(`parmvec', "`parm'")
		sca `old_pj' = `parmvec'[1,`parmcol']
		if "`trace'" != "" {
			noi di in gr _col(12) "`parm' = " in ye %9.0g `old_pj'
		}
		scalar `incr' = `delta'*(abs(`old_pj')+`delta')
		matrix `parmvec'[1, `parmcol'] = `old_pj'+`incr'

		FunctionEval `parmvec' `yhatdnames' `"`fopts'"'
		forvalues i = 1/$NLS_neqn {
			capture assert `yhat`i'd' < . if `touse'
			if _rc {
				noi di as err
*/ "could not calculate derivatives for equation `i'"
				exit 481
			}
			qui replace ${NLS_J`i'_`j'} =           ///
				(`yhat`i'd' - ${NLS_yhat`i'}) / `incr'
		}
		matrix `parmvec'[1,`parmcol'] = `old_pj'
		local `++j'
	}

end



program MinSSQ

	args		params		/* parameter names
		*/	parmvec		/* on entry, initial values, on exit
		*/			/* contains the final values
		*/	parmvar		/* on exit, contains X'X for s.e.'s
		*/	touse		/* estimation sample
		*/	glsmat		/* weighting matrix to use
		*/	normwt		/* iweight variable
		*/	log		/* if "nolog", suppresses iter. log
		*/	trace		/* if "trace", display beta each iter
		*/	iterate		/* maximum iterations
		*/	delta		/* derivative step size	
		*/	eps		/* convergence criterion
		*/	tau		/* convergence offset (see [R] nl)
		*/	converged	/* on exit, 0=not converged, 1=did
		*/	SStype		/* Labels SS in iteration log
		*/	fopts		/* Function-evaluator program opts
		*/
	
	local np : word count `params'		

	tempname old_ssr ssr f
	
/*
	Initializations.
*/

	forvalues i = 1/$NLS_neqn {
		forvalues j = 1/`np' {
			local Jnames `Jnames' ${NLS_J`i'_`j'}
		}
		local residnames `residnames' ${NLS_resid`i'}
/*
		tempvar yhat`i'd
		qui gen double `yhat`i'd' = .
		local yhatdnames `yhatdnames' `yhat`i'd'
*/
	}

	FunctionEval `parmvec' $NLS_yhatnames `"`fopts'"'
	forvalues i = 1/$NLS_neqn {
		capture assert ${NLS_yhat`i'} < . if `touse'
		if _rc { 
			noi di in red "could not evaluate equation `i'"
			noi di in red /*
*/ "starting values invalid or some RHS variables have missing values"
				exit 480
		}
		qui replace ${NLS_resid`i'} = 				///
			${NLS_yname`i'} - ${NLS_yhat`i'} if `touse'
	}
		
	mata:CalcSumSQ( "`residnames'", "`touse'", "`glsmat'", 		///
			"`normwt'", "`old_ssr'")
/*
		Iterative (Gauss-Newton) loop
*/
	local done 0	/* finished (cnvrgd or out of iters) */
	local its 0	/* current iteration count */
	tempname hest	/* for holding estimation results */
	tempname betas  /* betas from reg of resids on derivs */
	local j 1
	foreach parm of local params {
		tempname op`j'
		local j = `j' + 1
	}
	while ~`done' {
		if "`log'" == "" {
			noi di in gr "Iteration " `its' ":  " _c
			if "`trace'"!="" { 
				noi di 
			}
		}
		
		FunctionDeriv `"`params'"' "`parmvec'" 		///
			       "`touse'" "`delta'" "`trace'" `"`fopts'"'

/*
		Update parameter estimates and test for convergence
		by max proportional iterative change in each param.
		See Gallant p 29.
*/
		mata:CalcReg("`residnames'", "`Jnames'", "`parmvar'",	///
				"`glsmat'", "`normwt'", "`touse'", "`betas'")
		mat colnames `betas' = `params'
		scalar `ssr' = .
		scalar `f' = 1
		while (`ssr' > `old_ssr') {	/* backup loop */
			local cnvrge 1 	/* parameter convergence flag */
			if (`f'!=1) {
				local j 1
				foreach parm of local params {
					local parmcol = 	///
						colnumb(`parmvec', "`parm'")
					mat `parmvec'[1,`parmcol'] = `op`j''
					local j=`j'+1 
				}
			}
			local j 1
			foreach parm of local params {
				local parmcol = /*
					*/ colnumb(`parmvec', "`parm'")
				scalar `op`j''=`parmvec'[1,`parmcol']
				matrix `parmvec'[1,`parmcol'] = /*
					*/ `op`j'' + `f'*`betas'[1,`parmcol']
				if `f'*abs(`betas'[1,`parmcol']) > 	/// 
					`eps'*(abs(`op`j'')+`tau') {
					local cnvrge 0
				}
				local j=`j'+1
			}
/* Get predictions based on new parameters */
			FunctionEval `parmvec' $NLS_yhatnames `"`fopts'"'
			local yhatgood 1
			forvalues i = 1/$NLS_neqn {
				cap assert ${NLS_yhat`i'} < . if `touse'
				if _rc {
					local yhatgood 0
				}
				else {
					qui replace ${NLS_resid`i'} =	///
						${NLS_yname`i'} - 	///
						${NLS_yhat`i'}
				}
			}
			if `yhatgood' {
				mata:CalcSumSQ(	"`residnames'", "`touse'",  /*
					*/  "`glsmat'", "`normwt'", "`ssr'")
				if "`ssr'"=="" { 
					scalar `ssr' = .
				}
			}
			scalar `f'=`f'/2
		} /* backup loop */
		if "`log'"=="" {
			if "`trace'"!="" {
				local trcol "_col(42)"
				local trnl "_n"
			}
			noi di in gr `trcol' "`SStype'SS = " /* 
				*/ in ye %9.0g `ssr' `trnl'
		}
		if missing(`old_ssr') & missing(`ssr') {
di as err "`SStype'SS evaluates to missing; check model specification""
			exit 498
		}
			
		if abs(`old_ssr'-`ssr') > `eps'*(`old_ssr'+`tau') {
			local cnvrge 0
		}
		scalar `old_ssr' =  `ssr'
		local done `cnvrge'
		local its = `its'+1
		if `its' >= `iterate' { 
			local done 1 
		}
	}

	sca `converged' = `cnvrge'	

end

program CalcErrCov

	args parmvec mat iwtvar divisor fopts
	
	FunctionEval `parmvec' $NLS_yhatnames `"`fopts'"'
	
	local residnames 
	forvalues i = 1/$NLS_neqn {
		qui replace ${NLS_resid`i'} = ${NLS_yname`i'} - 	///
					      ${NLS_yhat`i'}
		local residnames `residnames' ${NLS_resid`i'}
	}
	
	qui mat accum `mat' = `residnames' [iw=`iwtvar'], nocons
	
	mat `mat' = `mat' / `divisor'
	
end


mata:

/* Given m residuals and an (m x m) weight matrix, calculates the
   sum of squares for the corresponding single-equation regression
   model.  In -nl-, this is accomplished by regressing the single
   residual on a vector of zeros with no constant.
*/

void CalcSumSQ( string scalar lhsstr, string scalar tousevar, 
		string scalar glsmats, string scalar normwts,
		string scalar ssqs)
{

	real matrix lhs, glsmat, psi, normwt
	real scalar neqn, capn, ssq
	real scalar i, j

	st_view(lhs=., ., tokens(lhsstr), tousevar)
	st_view(normwt=., ., normwts, tousevar)
	glsmat = st_matrix(glsmats)
	psi = cholesky(pinv(glsmat))
	
	neqn = cols(lhs)
	capn = rows(lhs)
	ssq = 0
	for(j=1; j<=neqn; ++j) {
		for(i=1; i<=capn; ++i) {
			ssq = ssq + normwt[i]*(lhs[i,.] * psi[.,j])^2
		}
	}
	
	st_numscalar(ssqs, ssq)
	
}

void CalcReg(string scalar errs, string scalar derivs, string scalar XPXis,
	     string scalar glsmats, string scalar normwts, 
	     string scalar tousevar, string scalar betas)
{

	real matrix deriv, err, Ginv 
	real matrix XPX, XPXi, XPy, xi, normwt, yi
	real scalar neqn, capn, nparam, i

	Ginv = pinv(st_matrix(glsmats))

	st_view(err=., ., tokens(errs), tousevar)
	st_view(deriv=., ., tokens(derivs), tousevar)
	st_view(normwt=., ., tokens(normwts), tousevar)
	neqn = cols(err)
	capn = rows(err)
	nparam = cols(deriv) / neqn

	XPX = J(nparam, nparam, 0)
	XPy = J(nparam, 1, 0)
	
	for(i=1; i<=capn; ++i) {
		xi = rowshape(deriv[i,.], neqn)
		yi = err[i, .]
		XPX = XPX + normwt[i]*xi'*Ginv*xi
		XPy = XPy + normwt[i]*xi'*Ginv*yi'
	}
	
	XPX = 0.5*(XPX + XPX')

	st_matrix(betas, qrsolve(XPX,XPy)')
	XPXi = qrinv(XPX)
	st_matrix(XPXis, XPXi)

}

void CalcRobustVCE(string scalar derivs, string scalar resids, 
		   string scalar glsmats, string scalar plainvars,
		   string scalar normwts, string scalar clusters,
		   string scalar numclusts, string scalar tousevar,
		   string scalar weights)
{

	real matrix deriv, resid, normwt, glsmat, plainvar, Ginv, V, Xi, ui, wi
	real vector info, cluster, scorei
	real scalar neqn, capn, nparam, i, j, wtpow

	glsmat = st_matrix(glsmats)
	plainvar = st_matrix(plainvars)
	
	st_view(deriv=.,  ., tokens(derivs), tousevar)
	st_view(resid=.,  ., tokens(resids), tousevar)
	st_view(normwt=., ., tokens(normwts), tousevar)
	
	neqn = cols(resid)
	capn = rows(resid)
	nparam = cols(deriv) / neqn

	Ginv = pinv(glsmat)

	V = J(nparam, nparam, 0)

	wtpow = 1
	if (weights == "aweight" | weights == "pweight") {
		wtpow = 2
	}

	if (clusters == "") {
		for(i=1; i<=capn; ++i) {
			Xi = rowshape(deriv[i,.], neqn)
			ui = rowshape(resid[i,.], neqn)
			V = V + normwt[i]^wtpow*Xi'*Ginv*ui*ui'*Ginv*Xi
		}
	}
	else {
		st_view(cluster=., ., tokens(clusters), tousevar)
		info = panelsetup(cluster, 1)
		for(i=1; i<=rows(info); ++i) {
			scorei = J(nparam, 1, 0)
			panelsubview(Xi=., deriv, i, info)
			panelsubview(ui=., resid, i, info)
			panelsubview(wi=., normwt, i, info)
			for(j=1; j<=rows(Xi); ++j) {
				// Don't square wt w/aw for cluster
				scorei = scorei + wi[j]*	
					rowshape(Xi[j,.],neqn)'*Ginv*
					rowshape(ui[j,.],neqn)
			}
			V = V + scorei*scorei'
		}
		st_numscalar(numclusts, rows(info))
	}
	V = 0.5*(V + V')
	st_matrix(plainvars, plainvar*V*plainvar)

}


end
