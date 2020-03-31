*! version 1.5.1  09oct2019
program define ivregress, eclass byable(onecall) prop(or svyb svyj svyr)

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 10

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	`BY' _vce_parserun ivregress, noeqlist jkopts(eclass) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"ivregress `0'"'
		exit
	}

	if replay() {
		if `"`e(cmd)'"' != "ivregress" { 
			error 301
		}
		else if _by() { 
			error 190 
		}
		else {
			Display `0'
		}
		exit
	}
	`vv' ///
	`BY' Estimate `0'
	ereturn local cmdline `"ivregress `0'"'

end

program Estimate, eclass byable(recall) sortpreserve

	local vv : di "version " string(_caller()) ":"
	version 10

	local estimator : word 1 of `0'
	local 0 : subinstr local 0 "`estimator'" ""
	CheckEstimator `estimator'
	local estimator `=s(estimator)'

	_iv_parse `0'
	
	local lhs `s(lhs)'
	local endog `s(endog)'
	local exog `s(exog)'
	local inst `s(inst)'
	local 0 `s(zero)'
	

	syntax [if] [in] [aw fw pw iw/] ///
		[,FIRST			///
		  Robust		///
		  CLuster(varname)	///
		  NOConstant 		///
		  Hasconstant		///
		  Level(cilevel)	///
		  EForm(passthru)	///
		  SMALL			///
		  NOHEader		///
		  VCE(string)		///
		  WMATrix(string) 	///
		  DEPname(string) 	///
		  Igmm			///
		  Center		///
		  ITERate(integer -1)	///
		  EPS(real -1)		///
		  WEPS(real -1)		///
		  PERfect		///
		  NOLOg LOg *]

	_get_diopts diopts, `options'
	if "`robust'`cluster'" != "" {
		if "`vce'" != "" {
			di as error ///
"cannot specify options {opt robust} or {opt cluster()} with {opt vce()}"
			exit 198
		}
		if "`cluster'" != "" {
			local vce "cluster `cluster'"
		}
		else {
			local vce "robust"
		}
	}
	
	marksample touse
	markout `touse' `lhs' `exog' `inst' `endog'

	// populate lists based on fully expanded list
	local totexp `endog' `exog' `inst'
	fvexpand `totexp' if `touse'
	local totexp `r(varlist)'
	fvexpand `endog' if `touse'
	local endog `r(varlist)'
	fvexpand `exog' if `touse'
	local exog `r(varlist)'
	fvexpand `inst' if `touse'
	local inst `r(varlist)'
	foreach vargroup in endog exog inst {
		local there: list `vargroup' & totexp
		local leftover: list `vargroup' - there
		foreach var of local leftover {
			_ms_put_omit `var'
			local there `there' `s(ospec)'
		}
		local `vargroup' `there'
	}
	
	// set up robust VCE by default for pweights;
	// Handle GMM separately, after wmat() and vce() parsed
	if "`estimator'" != "gmm" {
		if "`weight'" == "pweight" & "`vce'" == "" {
			local vce robust
		}
	}

	if "`estimator'" == "liml" & "`perfect'" != "" {
		di as error 		///
			"cannot specify {opt perfect} with the LIML estimator"
		exit 198
	}
	
	if "`estimator'" == "gmm" {
		if "`wmatrix'" == "" & "`vce'" != "" {
			// Before setting wmatrix, make sure vce valid
			`vv' ParseCovMat `"`vce'"' "vce" `touse'
			if "`=s(covtype)'" == "unadj" {
				local wmatrix "robust"
			}
			else {
				local wmatrix `"`vce'"'
			}
		}
		`vv' ParseCovMat `"`wmatrix'"' "wmatrix" `touse'
		local wmatrixtype `=s(covtype)'
		if "`=s(covclustvar)'" != "." {
			local wmatrixclustvar `=s(covclustvar)'
			markout `touse' `wmatrixclustvar'
		}
		if "`=s(covhac)'" != "." {
			local wmatrixhac `=s(covhac)'
			local wmatrixhaclag `=s(covhaclag)'
			local wmatrixopts `s(covopt)'
		}
		// By default, using same VCE as weighting matrix for GMM
		// Default for wmatrix is robust; make vce robust in this
		// case
		if "`wmatrix'" == "" & "`vce'" == "" {
			local vce "robust"
		}
		else if "`vce'" == "" {
			if `"`wmatrix'"' == "unadj" & "`weight'" == "pweight" {
				local vce "robust"
			}
			else {
				local vce `"`wmatrix'"'
			}
		}
	}
	else if "`wmatrix'" != "" {
		di as error	///
"cannot specify {opt wmatrix()} with `=upper("`estimator'")' estimator"
		exit 198
	}

	`vv' ParseCovMat `"`vce'"' "vce" `touse'
	local vcetype `=s(covtype)'
	if "`=s(covclustvar)'" != "." {
		local vceclustvar `=s(covclustvar)'
		markout `touse' `vceclustvar', strok
	}
	if "`=s(covhac)'" != "." {
		local vcehac `=s(covhac)'
		local vcehaclag `=s(covhaclag)'
		local vceopts  `s(covopt)'
	}

	if `"`exp'"' != "" {
		local wgt `"[`weight' = `exp']"'
		qui replace `touse' = 0 if missing(`exp')
	}

	if "`noconstant'" != "" & "`hasconstant'" != "" {
di as err "{opt noconstant} and {opt hasconstant} are mutually exclusive"
		exit 198
	}
	if "`vcetype'" == "hac" | "`wmatrixtype'" == "hac" {
		if "`weight'" != "" & "`weight'" != "aweight" {
			di as error 					///
"cannot use `weight's with {opt vce(hac ...)} or {opt wmatrix(hac ...)}"
			exit 498
		}
		_ts, sort onepanel
		tempname tvardelta
		local timevar `_dta[_TStvar]'
		if "`: char _dta[_TSdelta]'" != "" {
			scalar `tvardelta' = `: char _dta[_TSdelta]'
		}
		else {
			scalar `tvardelta' = 1
		}
	}
	else {
		local timevar ""
	}
	if "`weight'" == "iweight" & "`vcetype'" != "unadj" {
		di as error "iweights not allowed with {opt vce()}"
		exit 101
	}
	if "`estimator'" != "gmm" {
		if "`igmm'" != "" {
			di as error 	///
			  "may only specify {opt igmm} with GMM estimator"
			exit 198
		}
		if "`center'" != "" {
			di as error	///
			  "may only specify {opt center} with GMM estimator"
			exit 198
		}
	}
	if "`igmm'" == "" {
		if `iterate' != -1 {
			di as error	///
"may only specify {opt iterate()} with iterative GMM estimator"
			exit 198
		}
		if `eps' != -1 {
			di as error	///
"may only specify {opt eps()} with iterative GMM estimator"
			exit 198
		}
		if `weps' != -1 {
			di as error	///
"may only specify {opt weps()} with iterative GMM estimator"
			exit 198
		}
		if "`log'`nolog'" != "" {
			di as error	///
"may only specify {opt nolog} and {opt log} with iterative GMM estimator"
			exit 198
		}
	}
	else {
		_parse_iterlog, `log' `nolog'
		local log "`s(nolog)'"
		if `iterate' <= 0 & `iterate' != -1 {
			di as error "{opt iterate()} must be greater than zero"
			exit 198
		}
		if `eps' <= 0 & `eps' != -1 {
			di as error "{opt eps()} must be greater than zero"
			exit 198
		}
		if `weps' <= 0 & `weps' != -1 {
			di as error "{opt weps()} must be greater than zero"
			exit 198
		}
		local iterate `=cond(`iterate'>0, `iterate', c(maxiter))'
		local eps `=cond(`eps'>0, `eps', 1e-6)'
		local weps `=cond(`weps'>0, `weps', 1e-6)'
	}
	
	// Here we generate weights and sample size that are suitable 
	// for use within Mata, since it does not differentiate
	// between fw, aw, pw, or iw
	tempvar normwt 
	if `"`exp'"' != "" {
		qui gen double `normwt' = `exp' if `touse'
		if "`weight'" == "aweight" | "`weight'" == "pweight" {
			summ `normwt' if `touse', mean
			di as text "(sum of wgt is " %12.4e r(sum) ")"
			qui replace `normwt' = r(N)*`normwt'/r(sum) if `touse'
		}
		local wtexp `"[`weight' = `exp']"'
		summ `normwt' if `touse', mean
		if "`weight'" == "iweight" {
			local normN = trunc(r(sum))
		}
		else {
			local normN = r(sum)
		}
		markout `touse' `normwt'
	}
	else {
		qui gen double `normwt' = 1 if `touse'
		qui count if `touse'
		local normN = r(N)
	}
	/* Remove collinear variables */
	if "`hasconstant'`noconstant'" != "" {
		`vv' ///
		CheckCollin `lhs' if `touse' [iw=`normwt'], 	///
			endog(`endog') exog(`exog') 		///
			inst(`inst') noconstant `perfect'
	}
	else {
		`vv' ///
		CheckCollin `lhs' if `touse' [iw=`normwt'],	///
			endog(`endog') exog(`exog') 		///
			inst(`inst') `perfect'
	}
	local endog `s(endog)'
	local exog `s(exog)'
	local inst `s(inst)'
	local fvops `s(fvops)'
	local tsops `s(tsops)'
	if `fvops' {
		if _caller()<11 {
			local vv "version 11:"
		}
	}
	
	// If cluster weight matrix, see if we have enough clusters to
	// perhaps get a positive definite weight matrix.
	if "`wmatrixclustvar'" != "" {
		tempvar clustid
		qui bysort `wmatrixclustvar' (`touse') : 		///
			gen `c(obs_t)' `clustid' = (_n==_N & `touse')
		qui replace `clustid' = sum(`clustid')
		summ `clustid', mean
		if r(max) < (`:list sizeof exog' + `:list sizeof inst' 	///
			     + ("`noconstant'`hasconstant'"=="")) {
			di as err 					///
"insufficient number of clusters to compute GMM weighting matrix"
			di as err					///
"number of clusters must be greater than total number of instruments"
			exit 498
		}
	}
	
		
	/* Handle time-series operators here instead of 
	   making each subprogram deal with them	*/
	local hastsops 0
	local lhsname `lhs'
	local endogname `endog'
	local exogname `exog'
	local instname `inst'
	if `tsops' {
		local hastsops 1
		qui tsset, noquery
		foreach x in lhs endog exog inst {
			fvrevar ``x'', tsonly
			local `x' `r(varlist)'
		}
	}

	if `fvops' {
		NoOmit `endog', touse(`touse')
		local endo_ct = `r(noomitted)'
		NoOmit `exog', touse(`touse')
		local exog_ct = `r(noomitted)'
		NoOmit `inst', touse(`touse')
		local inst_ct = `r(noomitted)'
	}
	else {
		local endo_ct : word count `endog'
		local exog_ct : word count `exog'
		local inst_ct : word count `inst'
	}
	if `endo_ct' > `inst_ct' {
		di as err "equation not identified; must have at " /*
		*/ "least as many instruments not in"
		di as err "the regression as there are "           /*
		*/ "instrumented variables"
		exit 481
	}
	if (`endo_ct' + `exog_ct' == 0) & 		///
		"`hasconstant'`noconstant'"!="" {
		di as err "no RHS variables"
		exit 498
	}
	if "`estimator'" != "gmm" {
		if `endo_ct' == 0 & `inst_ct' != 0 {
			di as err 			///
"cannot specify additional instruments without endogenous"
			di as err			///
"regressors unless you use the GMM estimator"
			exit 498
		}
	}
	if "`first'"!="" {
		`vv' 					///
		doFirst `"`endog'"' 			///
			`"`endogname'"'			///
			`"`exog' `inst'"' 		///
			`"`exogname' `instname'"'	///
			`"`touse'"' 			///
			`"`weight'"'			///
			`"`wtexp'"'			///
			`"`normwt'"' 			///
			`"`normN'"' 			///
			`"`timevar'"' 			///
			`"`tvardelta'"'			///
			`"`noconstant'"' 		///
			`"`hasconstant'"' 		///
			`"level(`level')"' 		///
			`"`vcetype'"' 			///
			`"`vceclustvar'"'		///
			`"`vcehac'"' 			///
			`"`vcehaclag'"'
	}
	
	local exogc `exog'
	local exognamec `exogname'
	if "`noconstant'`hasconstant'" == "" {
		tempvar one
		gen byte `one' = 1
		local exogc `exogc' `one'
		local exognamec `exognamec' `one'
		local nconsreg
	}
	else {
		local nconsreg noconstant
	}
	tempname b V itsdone noomitcols 
	NoOmit `lhs' `endog' `exogc' `inst', touse(`touse')
	local hasfv = `r(hasfv)'
	mat `noomitcols' = r(noomitcols)
	foreach var in endog exog exogc inst {
		NoOmit ``var'', touse(`touse')
		local `var'_c = `r(noomitted)'
	}
	scalar `itsdone' = 0		// Will be > 0 after GMM estimation
	// Call estimator
	if "`estimator'" == "2sls" {
		tempname hold
		_estimates hold `hold', nullok
		
		foreach word in endog exog inst {
			local f`word' ``word''
			local f`word'name
			if ("`f`word''" != "") {
				fvexpand `f`word'' if `touse'
				local vlist `r(varlist)'
				fvrevar `f`word'' if `touse'
				local fvlist `r(varlist)'
				local f`word'
				local j = 1
				foreach var of local vlist {
					_ms_parse_parts `var'
					if (r(omit)==0) {
						local wordj: word `j' ///
							of `fvlist'
						local f`word' `f`word'' `wordj'
						local fw: word `j' of ///
							``word'name' 
						local f`word'name
							`f`word'name' `w'
					}
					local j = `j' + 1
				}
			}
		}
		qui `vv' _regress `lhs' `fendog' `fexog' (`fexog' `finst')  ///
			[iw=`normwt'] if `touse', `nconsreg'
		local edfr = e(df_r)
		tempname br Vr
		matrix `br' = e(b)
		matrix `Vr' = e(V)
		local conslab
		if ("`nconsreg'" == "") {
			local conslab _cons
		}
		`vv' matrix colnames `br' = `fendogname' `fexogname' `conslab' 
		`vv' matrix colnames `Vr' = `fendogname' `fexogname' `conslab'
		`vv' matrix rownames `Vr' = `fendogname' `fexogname' `conslab'
		matrix `b' = `br'
		matrix `V' = `Vr'
		_estimates unhold `hold'		
		tempname kappa ZPX ZPZi
		mata:_red_2sls_iv_kclass_wrk("`lhs'", 		///
					    "`endog'", 		///
					    "`exogc'",		///
					    "`inst'",		///
					    "`touse'",		///
					    "`normwt'",		///
					    `hasfv',		///
					    `endog_c',		///
					    `exogc_c',		///
					    `inst_c',		///
					    "`kappa'",		///
					    "`ZPX'",		///
					    "`ZPZi'" )
	}
	else if"`estimator'" == "liml" {
		tempname kappa ZPX ZPZi
		mata:_iv_kclass_wrk("`lhs'", 		///
				    "`endog'", 		///
				    "`exogc'",		///
				    "`inst'",		///
				    "`touse'",		///
				    "`normwt'",		///
				    "`normN'",		///
				    "`estimator'",	///
				    `hasfv',		///
				    `endog_c',		///
				    `exogc_c',		///
				    `inst_c',		///
				    "`b'",		///
				    "`V'",		///
				    "`kappa'",		///
				    "`ZPX'",		///
				    "`ZPZi'" )
	}
	else {
		if `iterate' < 0 {
			local iterate 0		// 0 => two-step
		}
		if "`wmatrixclustvar'" != "" {
			sort `wmatrixclustvar'
		}
		tempname ZPX W J wlagopt
		mata:_iv_gmm_wrk("`lhs'",		///
				 "`endog'",		///
				 "`exogc'",		///
				 "`inst'",		///
				 "`touse'",		///
				 "`normwt'",		///
				 "`normN'",		///
				 "`weight'",		///
				 "`wmatrixtype'",	///
				 "`wmatrixclustvar'",	///
				 "`wmatrixhac'",	///
				 "`wmatrixhaclag'",	///
				 "`wmatrixopts'",	///
				 "`timevar'",		///
				 "`tvardelta'",		///
 				 "`log'",		///
				 "`center'",		///
 				 "`iterate'",		///
 				 "`eps'",		///
				 "`weps'",		///
				 `hasfv',		///
				 `endog_c',		///
				 `exogc_c',		///
				 `inst_c',		///
				 "`b'",			///
				 "`V'",			///
				 "`ZPX'",		///
				 "`W'",			///
				 "`J'",			///
				 "`itsdone'",		///
				 "`wlagopt'" )
	}
	tempname noomitv
	NoOmit `endog' `exog', touse(`touse')
	local v_omit = `r(omitted)'
	matrix `noomitv' = r(noomit)

	local names `endog' `exog'
	if "`noconstant'`hasconstant'" == "" {
		local names `names' _cons
		matrix `noomitv' = `noomitv'[1,1...],1
	}
	if `v_omit' {
		mata: _add_omitted("`b'","`V'","`noomitv'",`v_omit',0,1,1)
		if "`estimator'" == "gmm" {
			mata: ///
			_add_omitted("tmp","`ZPX'","`noomitv'",`v_omit',1,0,1)
		}
	}
	`vv' ///
	mat colnames `b' = `names'
	`vv' ///
	mat colnames `V' = `names'
	`vv' ///
	mat rownames `V' = `names'
	tempvar touse2
	gen byte `touse2' = `touse'
	if "`depname'" == "" {
		local dv `lhsname'
	}
	else {
		local dv `depname'
	}
	_ms_op_info `b'
	if r(tsops) {
		quietly tsset, noquery
	}
	if ("`estimator'" == "2sls") {
		mat `V' = `V' * `edfr'/`normN'
	}

	eret post `b' `V', esample(`touse2') depname(`dv') buildfvinfo
	if "`estimator'" == "2sls" | "`estimator'" == "liml" {
		eret scalar kappa = `kappa'
	}
	else if "`estimator'" == "gmm" {
		eret scalar J = `J'
		tempname W2
		mat `W2' = `W'	// We use `W' later; -eret- eats matrices
		local Wstripe `exognamec' `instname'
		tempname noomitw
		NoOmit `exogc' `inst', touse(`touse')
		mat `noomitw' = r(noomit)
		local w_omit = `r(omitted)'
		if `w_omit' {
		  mata: ///
		  _add_omitted("tmp","`W2'","`noomitw'",`w_omit',1,1,1)
		  mata: ///
		  _add_omitted("tmp","`ZPX'","`noomitw'",`w_omit',1,1,0)
		}
		if "`noconstant'`hasconstant'" == "" {
			local Wstripe : subinstr local Wstripe "`one'" "_cons"
		}
		`vv' ///
		mat colnames `W2' = `Wstripe'
		`vv' ///
		mat rownames `W2' = `Wstripe'
		mat `W' = `W2'
		eret matrix W = `W2'	
		if "`center'" == "center" {
			eret local moments "centered"
		}
	}

	// Residuals used in various places; get now
	tempname rss
	tempvar err errsq
	mat `b' = e(b)
	mat score double `err' = `b' if `touse'
	qui replace `err' = `lhs' - `err'

	qui gen double `errsq' = `err'^2	
	summ `errsq' [iw=`normwt'], mean
	scalar `rss' = r(sum)
	ereturn scalar rss = `rss'
	mat `V' = e(V)
	if "`vcetype'" == "robust" | "`vcetype'" == "cluster" | ///
	   "`vcetype'" == "hac" {
	   	tempname Omega nclus vcelagopt noomitcols
	   	if "`vceclustvar'" != "" {
	   		sort `vceclustvar'
	   	}
		NoOmit `err' `exogc' `inst' `normwt', touse(`touse')
		mat `noomitcols' = r(noomitcols)
		local hasfv = `r(hasfv)'
		mata:_iv_vce_wrk("`err'",		///
				 "`exogc'",		///
				 "`inst'",		///
				 "`touse'",		///
				 "`normwt'",		///
				 "`weight'",		///
				 "`vcetype'",		///
				 "`vceclustvar'",	///
				 "`vcehac'",		///
				 "`vcehaclag'",		///
				 "`vceopts'",		///
				 "`estimator'",		///
				 "`center'",		///
				 "`timevar'",		///
				 "`tvardelta'",		///
				 `hasfv',		///
				 `exogc_c',		///
				 `inst_c',		/// 
				 "`Omega'",		///
				 "`nclus'" ,		///
				 "`vcelagopt'")
		if "`estimator'" == "2sls" | "`estimator'" == "liml" {
			tempname vmb
			// Get just the "X'X" part
			mat `V' = `normN' / e(rss) * `V'
			mat `vmb' = `V'
			eret matrix V_modelbased `vmb'
			if `v_omit' {
				mata: ///
			_add_omitted("tmp","`ZPX'","`noomitv'",`v_omit',1,0,1)
			}
			mat `V' = `V'*`ZPX''*`ZPZi'*`Omega'*`ZPZi'*`ZPX'*`V'
		}
		else {
			// When we simplify the full GMM VCE to the optimal
			// VCE, there is a factor of N that appears at the
			// front (Davidson&MacKinnon, '04, p. 365).  Here
			// when we robustify we need to remove that N that
			// the GMM engine adds
			
			if `w_omit' mata: _add_omitted("tmp","`Omega'",	    ///
				"`noomitw'",`w_omit',1,1,1)
			mat `V' = `V'*`ZPX''*`W'*`Omega'*`W'*`ZPX'*`V' /    ///
					`normN'^2
			`vv' ///
			mat colnames `Omega' = `Wstripe'
			`vv' ///
			mat rownames `Omega' = `Wstripe'
			eret matrix S = `Omega'
		}
		mat `V' = (`V' + `V'')/2
		eret repost V=`V'
	}
	// Rescale variance matrix if "small"
	if "`small'" == "small" {
		mat `V' = e(V)
		local k = rowsof(`V') - `v_omit'
		if "`vcetype'" != "cluster" {
			mat `V' = `normN' * `V' / (`normN' - `k')
		}
		else {
			if "`e(N_clust)'" != "" {
				local nclus `e(N_clust)'
			}
			mat `V' = (`normN' - 1) / (`normN' - `k') *	///
				  `nclus' / (`nclus' - 1) * `V'
		}
		eret repost V=`V'
	}
	// Get R2, etc
	CalcStats `lhs' if `touse', endog(`endog') 		///
		exog(`exog') inst(`inst') `robust'		///
		normwt(`normwt') normN(`normN') `small'		///
		`noconstant' `hasconstant'

	if `hastsops' | `fvops' {		// Fix name stripes
		mat `b' = e(b)
		mat `V' = e(V)
		local oldnames : colnames `b'
		local newnames
		foreach n of local oldnames {
			local pos : list posof "`n'" in oldnames
			local nn  : word `pos' of `endogname' `exogname' _cons
			local newnames `newnames' `nn'
		}
		`vv' mat colnames `b' = `newnames'
		`vv' mat colnames `V' = `newnames'
		`vv' mat rownames `V' = `newnames'
		local wgt "[`e(wtype)'`e(wexp)']"
		_ms_op_info `b'
		if r(tsops) {
			quietly tsset, noquery
		}
		eret repost b=`b' V=`V' `wgt', rename buildfvinfo
	}
	local title ///
		"Instrumental variables (`=upper("`estimator'")') regression"
	eret local title `title'
	if "`small'" == "small" {
		eret local small "small"
	}
	eret scalar iterations = `itsdone'
	if "`noconstant'`hasconstant'" != "" {
		eret local constant "`noconstant'`hasconstant'"
	}	
	eret local instd `endogname'
	eret local insts `exogname' `instname'
	eret local exogr `exogname'
	if "`depname'" == "" {
		eret local depvar `lhsname'
	}
	else {
		eret local depvar `depname'
	}
	eret local predict "ivregress_p"
	eret local marginsok "XB default"
	eret local marginsnotok	Residuals SCores
	eret hidden local marginsprop nolinearize
	eret local footnote "ivreg_footnote"
	eret local estimator "`estimator'"
	if "`weight'" != "" {
		eret local wtype "`weight'"
		eret local wexp "= `exp'"
	}
	
	// vcetype controls labeling of std. errs. in output table
	if "`vcetype'" == "robust" | "`vcetype'" == "cluster" {
		eret local vcetype "Robust"
	}
	if "`vceclustvar'" != "" {
		eret local clustvar "`vceclustvar'"
		eret scalar N_clust = `nclus'
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
			ereturn local `x' "cluster ``x'clustvar'"
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
	}
	if "`wmatrixhaclag'" == "-1" {	may be undef; treat as string
		ereturn scalar wlagopt = `wlagopt'
	}
	if "`vcehaclag'" == "-1" {
		ereturn scalar vcelagopt = `vcelagopt'
	}
	if "`vcetype'" == "hac" {
		if "`vcehac'" == "bartlett" | "`vcehac'" == "parzen" {
			ereturn local hac_kernel "`=proper("`vcehac'")'"
		}
		else {
			ereturn local hac_kernel "quadratic spectral"
		}
		if "`vcehaclag'" == "-1" {
			ereturn scalar hac_lag = `vcelagopt'
		}
		else {
			ereturn scalar hac_lag = `vcehaclag'
		}
	}
	_post_vce_rank	
	eret hidden local robust_prolog "ivregress_prolog"
	eret hidden local robust_epilog "ivregress_epilog"
	eret local estat_cmd "ivregress_estat"	
	eret local cmd "ivregress"

	Display, level(`level') `eform' `noheader' `diopts'
	
end

program DispHACVCE

	args ktyp klag lagu
	
	di as text "HAC VCE:" _col(16) _c
	if "`ktyp'" == "quadraticspectral" {
		local ktyp "Quadratic spectral"
		local klagfmt -6.3f
	}
	else {
		local ktyp `=proper("`ktyp'")'
		local klagfmt -6.0f
	}
	local adds s
	if "`klag'" == "1" {			// may contain "opt"
		local adds ""
	}
	if "`klag'" != "opt" {
		di as text "`ktyp' kernel with " 		///
			`:di %`klagfmt' `klag'' " lag`adds'"
	}
	else {
		di as text "`ktyp' kernel with "		///
			`:di %`klagfmt' `lagu'' " lag`adds'" 
	}
	if "`lagu'" != "" {
		di as text "HAC Lags:" _col(16) "Chosen by Newey-West method"
	}
	
end

program Display

	syntax , [ Level(cilevel) EForm(passthru) NOHEader *]

	_get_diopts diopts, `options'
	if "`noheader'" == "" {
		di
		DisplayHeader
		di
	}
	_coef_table, level(`level') `eform' `diopts'
	_prefix_footnote, noline
	if "`e(vcetype)'" == "HAC" {
		local ktyp : word 2 of `e(vce)'
		local klag : word 3 of `e(vce)'
		local lagu `"`e(vcelagopt)'"'
		DispHACVCE "`ktyp'" "`klag'" "`lagu'"
	}
	if "`e(wlagopt)'" != "" {
		di as text "WMat Lags:" _col(16) "Chosen by Newey-West method"
	}
	
end

program define doFirst, eclass
	local vv : di "version " string(_caller()) ":"
	args        endolst    	/*  endogenous regressors
		*/  endonam	/*  endogenous names
		*/  instlst	/*  list of all instrumental variables 
		*/  instnam	/*  all IV's names
		*/  touse	/*  touse sample
		*/  weight	/*  type of weight
		*/  wtexp	/*  user's weight expression 
		*/  normwt	/*  normalized wt variable
		*/  normN	/*  sample size accting for wts
		*/  timevar	/*  -tsset- variable
		*/  tvardelta	/*  -tsset- delta
		*/  nocons	/*  noconstant option 
		*/  hascons	/*  hasconstant option 
		*/  levopt 	/*  CI level
		*/  vcetype	/*  type of VCE
		*/  vceclustvar /*  cluster var, if apropos
		*/  vcehac	/*  HAC kernel
		*/  vcehaclag	/*  lags for HAC vce */
	di in gr _newline "First-stage regressions"
	di in smcl in gr     "{hline 23}"
	tempname b1 V1 Omega1 clcnt1 lagused1
	tempvar resid1 touse1
	if "`hascons'`nocons'" == "" {
		tempvar one
		gen byte `one' = 1
	}
	local wtexp2 `wtexp'
	if "`weight'" == "pweight" {
		// if pweights, we're robust; use aweights and doctor
		// up VCE with _iv_vce_wrk
		local wtexp2 : subinstr local wtexp2 "pweight" "aweight"
	}
	tempvar endotmp
	local restore = 0
	if "`vcetype'" == "cluster" {
		local sortedby : sortedby

		if "`sortedby'" != "`vceclustvar'" {
			cap tsset
			local restore = ("`r(timevar)'"!="")
			if `restore' {
				preserve
			}
			/* to get proper # clusters			*/
			sort `vceclustvar' 
		}
	}
	tokenize `endolst'
	local i 1
	while "``i''" != "" {
		_ms_parse_parts ``i''
		if r(omit)==1 {
			local i = `i' + 1
			continue
		}
		qui gen double `endotmp' = ``i'' if `touse'
		`vv' ///
		qui _regress `endotmp' `instlst' `wtexp2' if `touse',	///
			`nocons' `hascons' omitted allbaselevels
		local F1 = e(F)
		local dfm = e(df_m)
		local dfr = e(df_r)
		local rmse = e(rmse)
		local r2 = e(r2)
		local r2a = e(r2_a)
		mat `V1' = e(V)
		tempname noomit
		NoOmit `instlst', touse(`touse')
		local omit = `r(omitted)'
		mat `noomit' = r(noomit)
		if "`vcetype'" != "unadj" {
			qui predict double `resid1', resid
			tempname noomitcols
			NoOmit `resid1' `instlst' `one' `normwt', touse(`touse')
			mat `noomitcols' = r(noomitcols)
			local hasfv = `r(hasfv)'
			NoOmit `instlst' `one', touse(`touse')
			local exog_c = `r(noomitted)'
			mata: _iv_vce_wrk("`resid1'",		///
					  "`instlst' `one'",	///
					  "",			///
					  "`touse'",		///
					  "`normwt'",		///
					  "`weight'",		///
					  "`vcetype'",		///
					  "`vceclustvar'",	///
					  "`vcehac'",		///
					  "`vcehaclag'",	///
					  "`vceopts'",		///
					  "",			///
					  "",			///
					  "`timevar'",		///
					  "`tvardelta'",	///
					  `hasfv',		///
					  `exog_c',		///
					  0,			///
					  "`Omega1'",		///
					  "`clcnt1'",		///
					  "`lagused1'")
			if `omit' {
				mata: ///
			_add_omitted("tmp","`Omega1'","`noomit'",`omit',1,1,1)
			}
			mat `V1' = `V1'/e(rmse)^2 * `Omega1' * `V1'/e(rmse)^2
			local df : list sizeof instlst
			if "`one'" != "" {
				local `++df'
			}
			if "`vcetype'" == "cluster" {
				mat `V1' = (`normN'-1)/(`normN'-`df')*	///
					  `clcnt1'/(`clcnt1'-1)*`V1'
			}
			else {
				mat `V1' = `V1'* `normN' / (`normN'-`df')
			}
		}
		if `restore' {
			/* data is tsset and we sorted on the clustvar	*/
			/* restore data or -post, buildvinfo- will error*/
			restore
		}
		gen byte `touse1' = `touse'
		mat `b1' = e(b)
		local stripe
		foreach x in `:colnames(`b1')' {
			`vv' local pos : list posof "`x'" in instlst
			if `pos' > 0 {
				local stripe `stripe' `:word `pos' of `instnam''
			}
			else {
				local stripe `stripe' _cons			
			}
		}
		`vv' ///
		mat colnames `b1' = `stripe'
		`vv' ///
		mat colnames `V1' = `stripe'
		`vv' ///
		mat rownames `V1' = `stripe'
		eret post `b1' `V1', esample(`touse1') obs(`normN') buildfvinfo
		eret scalar df_r = `dfr'
		if "`vcetype'" != "" {		// test with new VCE
			qui test `instnam'
			eret scalar F = r(F)
			eret scalar df_m = r(df)
		}
		else {
			eret scalar F = `F1'
			eret scalar df_m = `dfm'
		}

		if "`vcetype'" == "robust" | "`vcetype'" == "cluster" {
			eret local vcetype "Robust"
		}
		else if "`vcetype'" == "hac" {
			eret local vcetype "HAC"
		}
		if "`vcetype'" == "cluster" {
			eret local clustvar `clus'
			eret scalar N_clust = `clcnt1'
		}
		eret local depvar `:word `i' of `endonam''
		eret scalar rmse = `rmse'
		eret scalar r2 = `r2'
		eret scalar r2_a = `r2a'
		eret local cmd "ivregress_first"
		_coef_table_header
		di
		_coef_table, level(`level')
		cap drop `resid1'
		cap drop `touse1'
		if "`vcetype'" == "hac" {
			if "`vcehaclag'" == "-1" {
				DispHACVCE "`vcehac'" "opt" "`lagused1'"
			}
			else {		
				DispHACVCE "`vcehac'" "`vcehaclag'" ""
			}
		}
		local i = `i' + 1
		cap drop `endotmp'
		if `restore' & "`i'"!="" {
			preserve
			/* to get proper # clusters			*/
			sort `vceclustvar' 
		}			
	}
	di

end

program CheckEstimator, sclass

	args input
	
	if "`input'" == "2sls" {
		sreturn local estimator "2sls"
		exit
	}
	if "`input'" == "liml" {
		sreturn local estimator "liml"
		exit
	}
	if "`input'" == "fullerk" {
		sreturn local estimator "fullerk"
		exit
	}
	if "`input'" == "gmm" {
		sreturn local estimator "gmm"
		exit
	}
	
	di as error "`input' not a valid estimator"
	exit 198
	
end

program DisplayHeader
	
	tempname left right
	
	.`left' = {}
	.`right' = {}
	
	local C1 "_col(1)"
	local C2 "_col(7)"
	local C3 "_col(51)"
	local C4 "_col(67)"

	if "`e(vcetype)'" == "" & "`e(small)'" == "small" {
		di
		di as text "`e(title)'"
		di
		.`left'.Arrpush `C1' as text 				///
			"      Source {c |}       SS       df       MS"
		.`left'.Arrpush `C1' as text "{hline 13}{c +}{hline 30}"
		.`left'.Arrpush `C1' as text 				///
			"       Model {c |} " 				///
			as res %11.0g e(mss) 			 	///
			as res %6.0f e(df_m) " " 			///
			as res %11.0g e(mss)/e(df_m)
		.`left'.Arrpush `C1' as text 				///
			"    Residual {c |} " 				///
			as res %11.0g e(rss)				///
			as res %6.0f e(df_r) " "			///
			as res %11.0g e(rss)/e(df_r)
		.`left'.Arrpush `C1' as text "{hline 13}{c +}{hline 30}"
		.`left'.Arrpush `C1' as text				///
			"       Total {c |} " 				///
			as res %11.0g (e(mss)+e(rss))			///
			as res %6.0f (e(df_m)+e(df_r)) " "		///
			as res %11.0g ((e(mss)+e(rss))/(e(df_m)+e(df_r)))
	}
	else {
		.`left'.Arrpush `C1' "`e(title)'"
		.`left'.Arrpush `C1' as text ""
		.`left'.Arrpush `C1' as text ""
		.`left'.Arrpush `C1' as text ""
		if "`e(small)'" == "small" {
			.`left'.Arrpush `C1' as text ""	// For adj. R2 on right
		}
	}
	if "`e(estimator)'" == "gmm" {
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
				local lag : word 3 of `e(wmatrix)'
				local wstr `"`wstr'`lag'"'
			}
				
		}
		.`left'.Arrpush `C1' as text "GMM weight matrix: `wstr'"
	}
	
	.`right'.Arrpush `C3' "Number of obs"			///
		`C4' "= " as res %10.0fc e(N)
	if "`e(vcetype)'" == "Jackknife" {
		.`right'.Arrpush `C3' "Replications"		///
			`C4' "= " as res %10.0fc e(N_reps)
	}
	if "`e(small)'" == "small" | "`e(vcetype)'" == "Jackknife" {
		.`right'.Arrpush `C3' "F("			///
			%3.0f e(df_m) as text ","		///
			%6.0f e(df_r) as text ")"		///
			`C4' "= " as res %10.2f e(F)
		.`right'.Arrpush `C3' "Prob > F" `C4' "= "	///
			as res %10.4f Ftail(e(df_m), e(df_r), e(F))
	}
	else {
		.`right'.Arrpush `C3' "Wald chi2("		///
			as res e(df_m) as text ")"		///
			`C4' "= " as res %10.2f e(chi2)
		.`right'.Arrpush `C3' "Prob > chi2" `C4' "= "	///
			as res %10.4f chi2tail(e(df_m),e(chi2))
	}
	.`right'.Arrpush `C3' "R-squared"			///
		`C4' "= " as res %10.4f e(r2)
	if "`e(small)'" == "small" {
		.`right'.Arrpush `C3' "Adj R-squared"		///
			`C4' "= " as res %10.4f e(r2_a)
	}
	.`right'.Arrpush `C3' "Root MSE"			///
		`C4' "=    " as res %7.0g e(rmse)
	
	local nl = `.`left'.arrnels'
	local nr = `.`right'.arrnels'
	local k = max(`nl', `nr')
	forvalues i = 1/`k' {
		di as text `.`left'[`i']' as text `.`right'[`i']'
	}

end

program ParseCovMat, sclass

	args cov covtype touse
	
	sret clear
	
	if "`covtype'" != "vce" & "`covtype'" != "wmatrix" {
		di as error "ParseCovMat called improperly"
		exit 2000
	}
	
	local lkey : length local cov
	if "`covtype'" == "wmatrix" & "`cov'" == "" {	// default wmat(r)
		sreturn local covtype "robust"
		exit
	}
	if "`cov'" == "" | "`cov'" == bsubstr("unadjusted", 1, max(2, `lkey')) {
		sreturn local covtype "unadj"
		exit
	}
	if `"`cov'"' == bsubstr("robust", 1, max(1,`lkey')) {
		sreturn local covtype "robust"
		exit
	}
	
	local word1 : word 1 of `cov'
	local word1len : length local word1
	if `"`word1'"' == bsubstr("cluster",1,max(2,`word1len')) {
		local word2 : word 2 of `cov'
		capture noi confirm var `word2'
		if _rc {
			di as error ///
				"option {opt `covtype'()} incorrectly specified"
			exit 198
		}
		unab word2 : `word2'
		sreturn local covtype "cluster"
		sreturn local covclustvar "`word2'"
		exit
	}
	
	if `"`word1'"' != "hac" {
		di as error "option {opt `covtype'()} incorrectly specified"
		exit 198
	}

	local kernel : word 2 of `cov'
	local kernlen : length local kernel
	local ktype ""
	if `"`kernel'"' == bsubstr("nwest", 1, max(2,`kernlen')) |	///
		`"`kernel'"' == bsubstr("bartlett", 1, max(2,`kernlen')) {
		local ktype "bartlett"
	}
	else if `"`kernel'"' == bsubstr("gallant", 1, max(2,`kernlen')) | ///
		`"`kernel'"' == bsubstr("parzen", 1, max(2,`kernlen')) {
		local ktype "parzen"
	}
	else if `"`kernel'"' == 					///
		bsubstr("quadraticspectral", 1, max(2, `kernlen')) |	///
		`"`kernel'"' == bsubstr("andrews", 1, max(2,`kernlen')) {
		local ktype "quadraticspectral"
	}
	
	if "`ktype'" == "" {
		di as error "invalid kernel in option {opt `covtype'()}"
		exit 198
	}
	sreturn local covtype "hac"
	sreturn local covhac "`ktype'"
	
	local wordcnt : word count `cov'
	if `wordcnt'==3 | `wordcnt'==4 {
		if _caller()<14.1 & `wordcnt'==4 {
			di as error "option {opt `covtype'()} incorrectly specified"
			exit 198
		}
		local lag : word 3 of `cov'

		if `"`lag'"' == bsubstr("optimal", 1, 			///
					max(3,`:length local lag')) {
			local tune: word 4 of `cov'
			sreturn local covhaclag -1
			if ("`tune'"=="")	exit
			else {
				cap confirm integer number `tune'
				if _rc {
di as error "option {opt `covtype'()} incorrectly specified"
exit 198
				}
				else {
					if (`tune'<=1) {
di as err "{p}must specify a positive integer greater than 1 in option "
di as err "{opt `covtype'()}{p_end}""
exit 198
					}
					sreturn local covopt `tune'
				}
				exit
			}
		}
		else {		
			if "`ktype'" == "bartlett" | "`ktype'" == "parzen" {
				capture confirm integer number `lag'
				if _rc | `lag' <= 0 {
					di as error ///
"invalid lag specification in option {opt `covtype'()}"
					exit 198
				}
				qui count if `touse'
				if `lag' >= r(N) {
					di as error	///
"number of lags in option {opt `covtype'()} must be less than the sample size"
					exit 198
				}
			}
			else if "`ktype'" == "quadraticspectral" {
				capture confirm number `lag'
				if _rc | `lag' <= 0 {
					di as error ///
"invalid lag specification in option {opt `covtype'()}"
					exit 198
				}
			}
			sreturn local covhaclag `lag'
			exit
		}
	}
	if `wordcnt' == 2 {
		qui count if `touse'
		sreturn local covhaclag `=`r(N)' - 2'
		exit
	}

	di as error "option {opt `covtype'()} incorrectly specified"
	exit 198

end

program CheckCollin, sclass
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	syntax varlist(ts min=1 max=1) [if] [in] [iw/]	 	///
		[, endog(varlist fv ts) exog(varlist fv ts) 	///
		   inst(varlist fv ts) PERfect NOCONSTANT ]
	marksample touse
	if `"`exp'"' != "" {
		local wgt `"[`weight'=`exp']"'
	}
        local fvops = "`s(fvops)'" == "true" | _caller() >= 11
        local tsops = "`s(tsops)'" == "true" 

        if `fvops' {
                if _caller() < 11 {
                        local vv "version 11:"
                }
		local expand "expand"
		fvexpand `exog' if `touse'
		local exog  "`r(varlist)'"
		fvexpand `inst' if `touse'
		local inst  "`r(varlist)'"
		fvexpand `endog'
		local endog "`r(varlist)'"
	}
	/* Catch specification errors */	
	/* If x in both exog and endog, error out */
	local both : list exog & endog
	foreach x of local both {
		di as err 	///
"`x' included in both exogenous and endogenous variable lists"
		exit 498
	}
	
	if "`perfect'" == "" {
		/* If x in both endog and inst, error out */
		local both : list endog & inst
		foreach x of local both {
			di as err 	///
"`x' included in both endogenous and excluded exogenous variable lists"
			exit 498
		}
	}
	
	/* If x on both LHS and (RHS or inst), error out */
	local both : list varlist & endog
	if "`both'" != "" {
		di as err 	///
		 "`both' specified as both regressand and endogenous regressor"
		exit 498
	}
	local both : list varlist & exog
	if "`both'" != "" {
		di as err 	///
		   "`both' specified as both regressand and exogenous regressor"
		exit 498
	}

	local both : list varlist & inst
	if "`both'" != "" {
		di as err 	///
"`both' specified as both regressand and excluded exogenous variable"
		exit 498
	}

	/* Now check for collinearities */
	`vv' ///
	_rmdcoll `varlist' `endog' `exog' `wgt' if `touse', `noconstant'
	local totvarlist  `r(varlist)'
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
				local inexog : list var in exog
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
	`vv' ///
	_rmcoll `inst', `expand' `noconstant'
	local inst `r(varlist)'
	if "`inst'" != "" & "`endog'`exog'" != "" {
		if "`noconstant'"  == "" {
			tempvar tmpcons
			qui gen double `tmpcons' = 1 if `touse'
		}
		else {
			local tmpcons
		}
		if "`perfect'" == "" {
			`vv' ///
			_rmcoll2list, alist(`endog' `exog' `tmpcons') ///
				blist(`inst') ///
				normwt(`exp') touse(`touse')
			local inst `r(blist)'
		}
		else if "`exog'" != "" {   // allowing perfect instruments
			`vv' ///
			_rmcoll2list, alist(`exog' `tmpcons') blist(`inst') ///
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

program CalcStats, eclass

	syntax varlist(min=1 max=1 numeric) [if] [in],			///
		normwt(varlist) normN(real)				///
		[ endog(varlist fv)  inst(varlist fv) exog(varlist fv) 	///
		  NOConstant HASCONSTANT SMALL ROBUST ]

	local y `varlist'
	
	marksample tousevar
	
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

        if `fvops' {
                if _caller() < 11 {
                        local vv "version 11:"
                }
		fvexpand `exog' if `tousevar'
		local exog  "`r(varlist)'"
		fvexpand `inst' if `tousevar'
		local inst  "`r(varlist)'"
		fvexpand `endog' if `tousevar'
		local endog "`r(varlist)'"
	}
	ereturn scalar N = `normN'
	
	NoOmit `exog' `endog', touse(`tousevar')
	local dfm = `r(noomitted)'

	if "`hasconstant'" ~= "" {
		local dfm `=`dfm'-1'
	}
	ereturn scalar df_m = `dfm'

	local dfr = `normN' - `dfm' - ("`noconstant'" == "")

	if "`small'" == "small" {
		// If you set this, then you get t-statistics instead
		// of z-statistics with -ereturn display-, so you don't
		// want to set this unless you really want t-statistics.
		ereturn scalar df_r = `dfr'
		ereturn scalar rmse = sqrt(e(rss) / `dfr')
	}
	else {
		ereturn scalar rmse = sqrt(e(rss) / e(N))
	}
	
	tempname tss rsq rsqa F
	if "`noconstant'" == "" {
		qui summ `y' [iw=`normwt'] if `tousevar'
		scalar `tss' = r(Var)*(`normN' - 1)
	}
	else {
		tempvar ysq
		qui gen double `ysq' = `y'^2
		qui summ `ysq' [iw=`normwt'] if `tousevar'
		scalar `tss' = r(sum)
	}
	ereturn scalar mss = `tss' - e(rss)

	if "`noconstant'" == "" {
		scalar `rsq'  = 1 - e(rss)/`tss'
		if `rsq' < 0 | `rsq' > 1 {
			scalar `rsq' = .
		}
		ereturn scalar r2 = `rsq'
		scalar `rsqa' = 1 - 	///
		    (1 - `rsq')*(`normN'-("`noconstant'" == ""))/`dfr'
		ereturn scalar r2_a = `rsqa'
	}

	if "`noconstant'`hasconstant'" == "" {
		capture test `endog' `exog'
		if "`small'" == "small" {
			ereturn scalar F = r(F)
		}
		else {
			ereturn scalar chi2 = r(chi2)
		}
	}
	else if "`hasconstant'" != "" {
		if "`small'" != "" {
			quietly {
				tempvar yhat zyhat
				tempname tmpest
				_predict double `yhat' if `tousevar'
				_estimates hold `tmpest'
				_regress `yhat' `exog' `inst' [iw=`normwt']
				_predict double `zyhat' if `tousevar'
				_estimates unhold `tmpest'
				replace `zyhat' = `zyhat'^2
				summ `zyhat' [iw=`normwt'], mean
				ereturn scalar F=r(sum)/(`dfm' * e(rss)/ `dfr')
			}
		}
		else {
			capture test `endog' `exog'
			eret scalar chi2 = r(chi2)
		}
	}

end
program NoOmit, rclass
	syntax [varlist(fv ts default=none)] [,touse(string) exporder(string)]
	if "`varlist'" == "" {
		local hasfv = 0
		local omitted 0 
		local noomitted 0
		return scalar omitted = `omitted'
		return scalar noomitted = `noomitted'
		return scalar hasfv = `hasfv'
		exit
	}
	local hasfv = "`s(fvops)'" == "true"	
	if ("`exporder'" == "") {
		fvexpand `varlist' if `touse'
		local full_list `r(varlist)'
	}
	else {
		local full_list `exporder'
	}
	local cols : word count `full_list'
	tempname noomit noomitcols
	mat `noomit' = J(1,`cols',1)
	local omitted 0
	local noomitted 0
	local i 1
	foreach var of local full_list {
		_ms_parse_parts `var'
		if `r(omit)' {
			local ++omitted	
			mat `noomit'[1,`i'] == 0
			if !`hasfv' {
				local hasfv 1
			}
		}
		else {
			local ++noomitted
			capture assert `noomitcols'[1,1]>0
			if !_rc {
				mat `noomitcols' = `noomitcols'[1,1...],`i'
			}
			else {
				mat `noomitcols' = J(1,1,`i')
			}
		}
		local ++i
	}
	return scalar omitted = `omitted'
	return scalar noomitted = `noomitted'
	if `noomitted' > 0 {
		return matrix noomitcols = `noomitcols'
	}
	return scalar hasfv = `hasfv'
	return matrix noomit = `noomit'
end

version 11
local SS        string scalar
local RS        real scalar
local RRVEC     real rowvector
local RMAT      real matrix
mata:

void _add_omitted(	`SS' bname, 
			`SS' vname, 
			`SS' noomitname, 
			`RS' k, 
			`RS' nob,
			`RS' row,
			`RS' col)
{
	`RS'	ncols, nrows,p, both
	`RRVEC'	noomitcols, b
	`RMAT'	V

	both = col + row
	p = cols(st_matrix(noomitname))

	if(both==1) {
		if(col) {
			ncols = cols(st_matrix(vname))+k
			nrows = rows(st_matrix(vname))
			noomitcols = range(1,ncols,1)'
			noomitcols = select(noomitcols,(st_matrix(noomitname),
				J(1,ncols-p,1)))
			if(nob) {
				V = J(nrows,ncols,0)
				V[., noomitcols] = st_matrix(vname)
				st_matrix(vname, V)
			}
			else {
				b = J(1,ncols,0)
				V = J(nrows,ncols,0)
				b[noomitcols] = st_matrix(bname)
				V[., noomitcols] = st_matrix(vname)
				st_matrix(bname, b)
				st_matrix(vname, V)
			}
		}
		if(row) {
			ncols = cols(st_matrix(vname))
			nrows = rows(st_matrix(vname))+k
			noomitcols = range(1,nrows,1)'
			noomitcols = select(noomitcols,(st_matrix(noomitname),
				J(1,nrows-p,1)))
			V = J(nrows,ncols,0)
			V[noomitcols', .] = st_matrix(vname)
			st_matrix(vname, V)
		}
	
	}
	else {	
	ncols = cols(st_matrix(vname))+k
	nrows = rows(st_matrix(vname))+k
	noomitcols = range(1,ncols,1)'
	noomitcols = select(noomitcols,(st_matrix(noomitname),
				J(1,ncols-p,1)))

		if(nob) {
			V = J(ncols,ncols,0)
		V[noomitcols', noomitcols] = st_matrix(vname)
		st_matrix(vname, V)
		}
		else {
		b = J(1,ncols,0)
		V = J(ncols,ncols,0)
		b[noomitcols] = st_matrix(bname)
		V[noomitcols', noomitcols] = st_matrix(vname)
		st_matrix(bname, b)
		st_matrix(vname, V)
		}
	}
}

void _red_2sls_iv_kclass_wrk(string scalar deps,
		    string scalar endogs,
		    string scalar exogs,
		    string scalar insts,
		    string scalar touse,
		    string scalar wts,
		    real scalar hasfv,
		    real scalar endog_c,
		    real scalar exogc_c,
		    real scalar inst_c,
		    string scalar kappas,
		    string scalar ZPXs,		// output
		    string scalar ZPZis		// output
) 
{
	real matrix endog, exog, wt, data, dataorig
	real matrix ZPZ, ZPZi
	real matrix ZPX, ALL
	real scalar kappa, i1, i2, j2
	
	pragma unset data
	
	if(hasfv) {
		st_view(dataorig=., ., 
			tokens(deps + " " + endogs + " " + exogs + " " + insts),
			touse)
		st_subview(data,dataorig,.,st_matrix(st_local("noomitcols")))
	}
	else {
		st_view(data=., ., 
			tokens(deps + " " + endogs + " " + exogs + " " + insts),
			touse)
	}

	i1 = 1 + endog_c
	if (i1 > 1) {
		st_subview(endog=., data, ., (2..i1))
	}
	else {
		endog = J(rows(data), 0, 0)	// no columns
	}

	i2 = i1 + exogc_c
	if (i2 > i1) {
		++i1
		st_subview(exog=., data, ., (i1..i2))
	}
	else {
		exog = J(rows(data), 0, 0)	// no columns
	}

	st_view(wt=., ., wts, touse)
	// Get cross products needed for all estimators
	ALL = quadcross(data, wt, data)
	// ZPX
	i1 = 2 + cols(endog)
	i2 = 1 + cols(endog) + cols(exog) + inst_c
	j2 = 1 + cols(endog) + cols(exog)
	ZPX = ALL[|i1, 2 \ i2, j2|]
	// ZPZ
	i1 = 2 + cols(endog)
	i2 = 1 + cols(endog) + cols(exog) + inst_c
	ZPZ = ALL[|i1, i1 \ i2, i2|]
	ZPZi = invsym(ZPZ)

	// kappa
	kappa = 1

	st_numscalar(kappas, kappa)
	st_matrix(ZPXs, ZPX)
	st_matrix(ZPZis, ZPZi)
}

end
exit
