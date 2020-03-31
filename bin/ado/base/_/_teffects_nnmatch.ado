*! version 1.1.3  24apr2015

program define _teffects_nnmatch, byable(onecall)
	version 13

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if ("`e(cmd)'" != "teffects") error 301
		if ("`e(subcmd)'" != "nnmatch") error 301
		if (_by()) error 190
		global S_1 = e(chi2_c)
		_teffects_replaym `0'
		exit
	}
	_teffects_parse_canonicalize nnmatch : `0'
	if `s(eqn_n)' == 1 {
		_teffects_error_msg, cmd(nnmatch) case(1)
	}		
	if `s(eqn_n)' > 2 {
		_teffects_error_msg, cmd(nnmatch) case(2)
	}
	local omodel `"`s(eqn_1)'"'
	local tmodel `"`s(eqn_2)'"'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local wt `"`s(wt)'"'
	local options `"`s(options)'"'

	`BY' Estimate `if'`in' `wt', omodel(`omodel') tmodel(`tmodel') `options'
end

program define Estimate, eclass byable(recall)
	syntax [if] [in] [fw],		///
		omodel(string) 		///
		tmodel(string) [ 	///
		NNeighbor(passthru)	///
		ate atet atc		///
		model(string)		///
		CONtrol(passthru)	///
		TLEvel(passthru)	///
		Type(string)		///
		Ematch(string)          ///
		Metric(string)		///
		BIASadj(string)		///
		vce(string)		///
		DTOLerance(passthru)	///
		CALiper(passthru)       ///
		OSample(name)		///
		GENerate(string)	///
		noDISPLAY		///
		DMVariables		///
		log			///
		sample * ]

	/* undocumented options: 					*/
	/*  sample		- sample estimates for standard errors	*/
	/*  atc			- avg treat effect for the controls	*/
	/*  log			- display which matching phase is occur	*/

	_get_diopts diopts rest, `options'
	if "`rest'" != "" {
		local wc: word count `rest'
		di as err `"{p}`=plural(`wc',"option")' {bf:`rest'} "' ///
		 `"`=plural(`wc',"is","are")' not allowed{p_end}"'
		exit 198
	}
	if "`osample'" != "" {
		cap confirm variable `osample', exact
		if !c(rc) {
			di as err "{p}invalid " ///
			 "{bf:osample({it:newvarname})} specification; " ///
			 "variable {bf:`osample'} already exists{p_end}"
			exit 110
		}
	}
	ExtractVarlist `omodel'
	local varlist `s(varlist)'

	if "`ate'"!="" & "`atet'"!="" {
		di as err "{p}options {bf:ate} and {bf:atet} cannot " ///
		 "both be specified{p_end}"
		exit 184
	}
	local stat1 `ate'`atet'`atc'
	if ("`stat1'"=="") local stat1 ate

	local stat `stat1'
	if ("`stat'"=="atet") local stat att

	local type `sample'
	if ("`type'"=="") local type population

	marksample touse
	_teffects_count_obs `touse'

	if "`weight'" != "" {
		tempvar wvar
		qui gen double `wvar'`exp' if `touse'
		local wts [`weight'`exp']
		local wopt freq(`wvar')
	}


	ExtractTVar `tmodel'
	local tvar `s(tvar)'
	local tops `s(options)'

	/* check tvar, update `touse', check for control group		*/
	_teffects_parse_tvar `tvar', touse(`touse') `wopt' binary ///
		stat(`stat') `tops' `control' `tlevel' cmd(nnmatch)
	local tvar `s(tvar)'
	local control = `s(control)'
	local tlevels "`s(levels)'"
	local treated : list tlevels - control
	local treated : list retokenize treated
	
	/* -rmcoll- omitts -depvar- from checking collinearity		*/
	_teffects_parse_dvarlist `varlist', touse(`touse') wtype(`weight') ///
		wvar(`wvar') rmcoll nomarkout
	local depvar `s(depvar)'
	local dvarlist `s(dvarlist)'
	local fvdvarlist `s(fvdvarlist)'
	local kdvar = `s(k)'
	local kfvdvar = `s(kfv)'
	if "`dvarlist'" != "" {
		_teffects_vlist_exclusive2, vlist1(`dvarlist') ///
			vlist2(`tvar') case(2)

		fvrevar `fvdvarlist' if `touse'
		local fvdrevar `r(varlist)'	
		_teffects_omit_vars, klev(1) fvdvlist(`fvdvarlist') ///
			fvdrevar(`fvdrevar')

		local fvodrevar `"`r(fvodrevar)'"'
		local kfvdrevar : list sizeof fvodrevar
		local komit = `r(komit)'
		if `komit' {
			/* first index is for treatment effect		*/
			local k = -1
			foreach j of numlist `r(index)' {
				if !`++k' {
					continue
				}
				local fvodindex `fvodindex' `=`j'-1'
			}
			local kfvar = `r(k)'-1
		}
	}
	_teffects_vlist_exclusive2, vlist1(`depvar')  ///
		vlist2(`tvar') case(1)
	if "`biasadj'" != "" {
		ParseBiasadj `biasadj' `wts', touse(`touse') tvar(`tvar') ///
			depvar(`depvar')
		local biasadj `s(varlist)'
		local fvbiasadj `s(fvexpand)'
		local kbiasadj = `s(k)'
		local kfbiasadj = `s(kf)'
	}
	else {
		local kbiasadj = 0
		local kfbiasadj = 0
	}
	if "`ematch'" != "" {
		gettoken ematch opts: ematch, parse(",")

		if ("`opts'"=="") local opts ,

		ParseEmatch `ematch' `wts' `opts' touse(`touse')
		local ematch `s(varlist)'
		local fvematch `s(fvexpand)'
		local kematch = `s(k)'
		local kfematch = `s(kf)'

		local emg "the treatment variable {bf:`tvar'} cannot be"	
		local emg "`emg' specified in the exact-match varlist"	
		local emg "`emg' {bf:ematch({it:varlist})}"

		_teffects_vlist_exclusive2, vlist1(`ematch') 	///
			vlist2(`tvar') wh1(`emg') case(3)

		local emg "the outcome variable {bf:`depvar'} cannot be"	
		local emg "`emg' specified in the exact-match varlist"	
		local emg "`emg' {bf:ematch({it:varlist})}"

		_teffects_vlist_exclusive2, vlist1(`ematch') 	///
			vlist2(`depvar') wh1(`emg') case(3)
	}
	else if !`kdvar' {
		di as err "{p}{it:omvarlist} or {bf:ematch({it:varlist})} " ///
		 "must be specified{p_end}"
		exit 100
	}
	else {
		local kematch = 0
		local kfematch = 0
		local edrop error
	}
	tempvar t01
	qui gen byte `t01' = cond(`tvar'==`control',0,1) if `touse'

	/* recount treated & controls					*/
	_teffects_count_obs `touse', why(observations with missing values) ///
		`wopt' tabulate(`t01', levels(2))
	local n0 = `r(n0)'
	local n1 = `r(n1)'
	local nmin = min(`n1',`n0')

	if "`dtolerance'" != "" {
		ParseDTolerance, `dtolerance'
		local dtolerance = `s(dtolerance)'
	}
	else local dtolerance = sqrt(epsdouble())

	if "`caliper'" != "" {
		ParseCaliper, `caliper' limit(`dtolerance')
		local caliper = `s(caliper)'
	}
	else local caliper = .

	if "`nneighbor'" != "" {
		ParseNNeighbor, `nneighbor' nmin(`nmin')
		local nneighbor = `s(nneighbor)'
	}
	else local nneighbor = 1

	if "`generate'" != "" {
		_teffects_parse_generate, generate(`generate') ///
			nvars(`nneighbor')
		local generate `s(stub)'
		local genty `s(type)'
	}
	if "`vce'" != "" {
		ParseVCE `nmin' : `vce'
		local robust = `s(robust)'
	}
	else local robust = 2

	if "`metric'" != "" {
		tempname mmatrix
		ParseMetric `kfvdvar' `fvodindex', `metric'
		local metric `r(metric)'

		if !`kdvar' & "`metric'"!="mahalanobis" & ///
			"`metric'"!="matrix" {
			di as err "{p}{it:omvarlist} must be specified " ///
			 "with option {bf:metric(`metric')}{p_end}"
			exit 198
		}
		if "`metric'" == "matrix" {
			local matname `r(matrix)'
			mat `mmatrix' = r(nzmatrix)
		}
	}
	else local metric = "mahalanobis"

	tempname mean stdev
	if "`fvodrevar'" != "" {
		forvalues i=1/`kfvdrevar' {
			tempvar var`i'
			local sdvarlist `sdvarlist' `var`i''
		}
		DoStandardize `sdvarlist' `wts', metric(`metric') ///
			vlist(`fvodrevar') touse(`touse') 

		mat `mean' = r(mean)
		mat `stdev' = r(stdev)
	}
	if "`osample'" != "" {
		qui gen byte `osample' = 0 if `touse'
		label variable `osample' "overlap violation indicator"
	}
	local itype = ("`type'"=="population")

	tempvar ts cs
	qui gen double `cs' = .
	qui gen double `ts' = .

	mata: _matchnn_estimates(`nneighbor',`itype',`robust',`dtolerance', ///
			`caliper',"`osample'","`stat'","`depvar'","`t01'",  ///
			"`fvbiasadj'","`weight'","`wvar'",		    ///	
			("`generate'","`genty'"),"`touse'","`sdvarlist'",   ///
			"`fvematch'","`metric'","`mmatrix'",("`log'"!=""))

	local indexvar `"`r(indexvar)'"'
	local n0 = r(n0)
	local n1 = r(n1)
	local mmin = r(mmin)
	local mmax = r(mmax)
	if "`metric'"=="mahalanobis" | "`metric'"=="matrix" {
		tempname mscale
		mat `mscale' = r(mscale)
	}
	if `kbiasadj' {
		tempname bias_adj
		mat `bias_adj' = r(Badj)
	}
	/* store results in ereturn and display			*/
	local cmp r`treated'vs`control'
	local STAT = upper("`stat1'")
	if ("`type'"=="population") local name `STAT':`cmp'.`tvar'
	else local name S`STAT':`cmp'.`tvar'

	tempname b V

	mat `b' = r(tau)
	mat coln `b' = "`name'"
	mat rown `b' = "`depvar'"

	mat `V' = r(var)
	mat rown `V' = "`name'"
	mat coln `V' = "`name'"
	local N = r(N)

	ereturn post `b' `V' `wts', depname("`depvar'") obs(`N') ///
		esample(`touse')

	signestimationsample `depvar' `tvar' `dvarlist' `indexvar'
	if "`fvdvarlist'" != "" {
		local kr = 1
		local jr = 1
		local rnames mean
		tempname M ind
		if "`metric'" == "ivariance" {
			/* must have space before `stdev'		*/
			mat `mean' = (`mean'\ `stdev')
			local rnames `rnames' stddev
			local `++kr'
			local jr (1\2) 
		}
		else if "`mscale'" != "" {
			/* mahalanobis or user matrix			*/
			if `komit' {
				mata: {					///
					`M' = J(`kfvar',`kfvar',0);	///
					`ind' = strtoreal(		///
						tokens("`fvodindex'"));	///
					`M'[`ind',`ind'] = 		///
						st_matrix("`mscale'");	///
					st_matrix("`mscale'",`M');	///
				}
			}
			mat colnames `mscale' = `fvdvarlist'
			mat rownames `mscale' = `fvdvarlist'
			ereturn hidden matrix mscale = `mscale'
		}
		if `komit' {
			tempname M ind
			mata: {						  ///
				`M' = J(`kr',`kfvar',0); 		  ///
				`ind' = strtoreal(tokens("`fvodindex'")); ///
				`M'[`jr',`ind''] = st_matrix("`mean'");	  ///
				st_matrix("`mean'",`M');		  ///
			}
		}
		mat colnames `mean' = `fvdvarlist'
		mat rownames `mean' = `rnames'
		ereturn hidden matrix mstats = `mean'
	}
	ereturn scalar n`control' = `n0'
	ereturn scalar n`treated' = `n1'
	ereturn scalar treated = `treated'
	ereturn scalar control = `control'
	/* can remove !e(sample) without data signature changing	*/
	/* indices from -generate()- will be invalid			*/
	ereturn hidden scalar Nobs = _N
	ereturn scalar k_nneighbor = `nneighbor'
	ereturn scalar k_nnmin = `mmin'
	ereturn scalar k_nnmax = `mmax'
	ereturn scalar k_robust = `robust'
	ereturn scalar k_levels = 2
	ereturn local tlevels "`tlevels'"
	local title "Treatment-effects estimation"
	ereturn local title `"`title'"'
	if "`weight'" != "" {
		ereturn local wexp "`exp'"
		ereturn local wtype "`weight'"
	}
	ereturn local stat `stat1'
	if ("`metric'"=="matrix") ereturn local metric matrix `matname'
	else ereturn local metric `metric'
	if "`ematch'" != "" {
		ereturn local emvarlist `"`ematch'"'
		ereturn hidden local fvematch `"`fvematch'"'
		ereturn hidden local edrop `edrop'
	}
	ereturn local bavarlist `"`biasadj'"'
	ereturn local mvarlist `"`dvarlist'"'
	ereturn local subcmd "nnmatch"
	ereturn local tvar `tvar'
	ereturn local depvar `depvar'
	if `robust' {
		ereturn local vce robust
		ereturn local vcetype AI Robust
	}
	ereturn hidden scalar dtolerance = `dtolerance'
	ereturn hidden local type `type'
	if "`indexvar'" != "" {
		local i = 0
		/* option -generate-, save matching indices		*/
		foreach var of varlist `indexvar' {
			label variable `var' "nearest-neighbor index `++i'"
		}
	}
	if (`kbiasadj') ereturn hidden matrix bias_adj = `bias_adj'

	ereturn local indexvar `"`indexvar'"'
	ereturn hidden local fvbavarlist `fvbiasadj'
	ereturn hidden local fvdvarlist `"`fvdvarlist'"'
	ereturn hidden local dvarlist `"`dvarlist'"'

	if ("`display'"=="") _teffects_replaym, `dmvariables' `diopts'

	return clear
	sreturn clear
end

program define ExtractTVar, sclass
	cap noi syntax varname(numeric), [ * ]
	local rc = c(rc)

	if `rc' == 103 {
		_teffects_error_msg, cmd(nnmatch) case(6) rc(`rc')
	}

	if `rc' {
		_teffects_error_msg, cmd(nnmatch) case(5) rc(`rc')
	}
	sreturn local tvar `"`varlist'"'
	sreturn local options `"`options'"'
end

program define ExtractVarlist, sclass
	cap noi syntax varlist(numeric fv)
	local rc = c(rc)
	if `rc' {
		_teffects_error_msg, cmd(nnmatch) case(7) rc(`rc')
	}
	sreturn local varlist `"`varlist'"'
	sreturn local options `"`options'"'
end

program define ParseNNeighbor, sclass
	syntax, nneighbor(integer) nmin(integer)

	if `nneighbor'<1 | `nneighbor'>`nmin' {
		di as err "{p}{bf:nneighbor({it:#})} must be an integer "    ///
		 "between 1 and the number of observations in the smallest " ///
		 "group = `nmin'{p_end}"
		exit 198
	}
	sreturn local nneighbor = `nneighbor'
end

program define ParseVCE, sclass
	cap noi syntax anything(name=vce id=vce) [, nn(string) ]

	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:vce()}"
		exit `rc'
	}
	_on_colon_parse `vce'
	local vce `s(after)'
	local nmax `s(before)'
	local vce : list retokenize vce

	if "`vce'" == "iid" {
		if "`nn'" != "" {
			di as err "{p}invalid {bf:vce()} specification; " ///
			 "suboption {bf:nn()} may not be combined with "  ///
			 "{bf:iid}{p_end}"

			exit 184
		}
		sreturn local robust = 0
		exit
	}
	else if "`vce'" == bsubstr("robust",1,length("`vce'")) {
		if "`nn'" == "" {
			sreturn local robust = 2
			exit
		}
		cap confirm integer number `nn'
		local rc = c(rc)
		if !`rc' {
			local rc = (`nn'<=1 | `nn'>`nmax')
		}
		if `rc' {
			di as err "{p}invalid {bf:vce()} specification; "  ///
			 "{bf:nn({it:#})} must be an integer between 2 "   ///
			 "and the number of observations in the smallest " ///
			 "group = `nmax'{p_end}"
			exit 198
		}
		sreturn local robust = `nn'
		exit
	}
	di as err "{bf:vce(`vce')} is not allowed"
	exit 198
end

program define ParseDTolerance, sclass
	syntax, dtolerance(real)

	if `dtolerance' <= 0 {
		di as error "{p}{bf:dtolerance({it:#})} must be a real " ///
		 "greater than zero{p_end}"
		exit 198
	}
	sreturn local dtolerance = `dtolerance'
end

program define ParseCaliper, sclass
	syntax, caliper(real) limit(real)

	if `caliper' <= `limit' {
		di as err "{p}{bf:caliper({it:#})} must be greater than " ///
		 "the difference tolerance " %10.4g `limit' "{p_end}"
		exit 198
	}
	sreturn local caliper = `caliper'
end

program define ParseBiasadj, sclass
	cap noi syntax varlist(numeric fv) [fw iw pw], touse(varname) ///
		tvar(varname numeric) depvar(varname)

	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:biasadj()}"
		exit `rc'
	}
	local k : word count `varlist'
	sreturn local k = `k'

	local emg "the treatment variable {bf:`tvar'} cannot be specified"	
	local emg "`emg' in the bias-adjustment varlist"	
	local emg "`emg' {bf:biasadj({it:varlist})}"


	_teffects_vlist_exclusive2, vlist1(`varlist') vlist2(`tvar') ///
	  wh1(`emg') case(3)

	local emg "the outcome variable {bf:`depvar'} cannot be specified"
	local emg "`emg' in the bias-adjustment varlist"	
	local emg "`emg' {bf:biasadj({it:varlist})}"

	_teffects_vlist_exclusive2, vlist1(`varlist') vlist2(`depvar') ///
	  wh1(`emg') case(3)

	if ("`weight'"!="") local wt [`weight'`exp']

	/* remove collinear bias adjustment variables by treatment	*/
	forvalues i=0/1 {
		RmcollTreatvar `varlist' `wt', tvar(`tvar') ///
			touse(`touse') at(`i')
		local varlist `r(varlist)'
	}
	/* terms varlist						*/
	local 0 `varlist'
	syntax varlist(numeric fv)

	/* expanded varlist						*/
	fvexpand `varlist' if `touse'
	local fvexpand "`r(varlist)'"

	markout `touse' `fvexpand'

	_teffects_count_obs `touse', why(observations with missing values)

	sreturn local varlist `varlist'
	sreturn local fvexpand `fvexpand'
	sreturn local k : word count `varlist'
	sreturn local kf : word count `fvexpand'
end

program define RmcollTreatvar, rclass 
	syntax varlist(numeric fv) [fw iw aw], tvar(varname numeric fv) ///
		touse(varname) at(integer)

	if ("`weight'"!="") local wt [`weight'`exp']

	/* expand the varlist, do not count fv base levels as dropped	*/
	fvexpand `varlist'
	local varlist `r(varlist)'

	qui _rmcoll `varlist' if `touse' & `tvar'==`at' `wt' //, forcedrop

	if (r(k_omitted)) {
		local varlist1 `r(varlist)'
		fvexpand `varlist1'
		local varlist1 `r(varlist)'

		/* do not count fv base levels as dropped		*/
		local varlist2 : list varlist & varlist1
		local dvarlist : list varlist - varlist2
		local k : list sizeof dvarlist
		
		if (`k') {
			local variables = plural(`k',"variable")
			local have = plural(`k',"has","have")
			di as txt "{p 0 6 2}note: {bf:biasadj()} "          ///
			 "`variables' {bf:`dvarlist'} `have' been dropped " ///
			 "due to collinearity with other variables at "     ///
			 "treatment level `at'{p_end}"
		}
		local varlist `varlist1'
	}
	local 0 `varlist'

	/* return in expanded form					*/
	return local varlist `varlist'
end

program define ParseEmatch, sclass
	cap noi syntax varlist(numeric fv) [fw iw aw], touse(varname) 
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:ematch()}"
		exit `rc'
	}
	if ("`weight'"!="") local wt [`weight'`exp']

	/* remove collinear ematch variables				*/
	_rmcoll `varlist' if `touse' `wt', noconstant
	if (r(k_omitted)!=0) local varlist "`r(varlist)'"

	markout `touse' `varlist'

	_teffects_count_obs `touse', why(observations with missing values)

	cap fvexpand `varlist' if `touse'
	local fvexpand "`r(varlist)'"

	sreturn local varlist `varlist'
	sreturn local k : word count `varlist'
	sreturn local fvexpand `fvexpand'
	sreturn local kf : word count `fvexpand'
end

program define ParseMetric, rclass
	syntax [ anything(name=index) ], [ MAHAlanobis IVARiance EUCLidean ///
		MATrix * ]

	local which `mahalanobis' `ivariance' `euclidean' `matrix'
	local k : word count `which' 
	if `k' == 0 {
		if "`options'" != "" {
			di as err "{p}{bf:metric(`options')} is not " ///
			 "allowed{p_end}"
			exit 198
		}
		return local metric mahalanobis
		exit
	}
	if `k' > 1 {
		di as err "{p}options {bf:`which'} may not be combined{p_end}"
		exit 184
	}
	if "`matrix'" != "" {
		ParseMetricMatrix `options'

		tempname z nzmat j
		local matname `r(matrix)'
		mat `nzmat' = `r(matrix)'
		gettoken kvar index: index
		if !`kvar' {
			di as err "{p}{bf:metric(matrix)} is not allowed " ///
			 "when no varlist is specified for the outcome "   ///
			 "model{p_end}"
			exit 198
		}
		if colsof(`nzmat') != `kvar' {
			di as err "{p}metric matrix {bf:`matname'} must " ///
			 "be `kvar' by `kvar' corresponding to the "      ///
			 "number of variables in the outcome-model "      ///
			 "varlist; this includes any " 			  ///
			 "{help fvvarlist ##|new:factor variable} "       ///
			 "expansions{p_end}"
			exit 503
		}
		local index : list retokenize index
		if "`index'" != "" {
			cap mata {				///
				`j' = strtoreal(tokens("`index'"));	///
				`z' = st_matrix("`nzmat'");	///
				st_matrix("`nzmat'",`z'[`j'',`j']);	///
			}
			if c(rc) {
				/* programmer error			*/
				di as err "{p}failed to subset metric "      ///
				 "matrix {bf:`matname'} to exclude omitted " ///
				 "factor variables}{p_end}"
				exit 503
			}
			local extra "after removing rows and columns"
			local extra "`extra' associated with the omitted"
			local extra "`extra' factor variables"
		}
		mat `z' = invsym(`nzmat')
		if diag0cnt(`z') > 0 {
			di as err "{p}matrix {bf:`matname'} is not " ///
			 "positive definite `extra'{p_end}"
			exit 506
		}
		return add
		return mat nzmatrix = `nzmat'
	}
	else {
		return local metric `mahalanobis'`ivariance'`euclidean'
	}
end

program define ParseMetricMatrix, rclass
	cap noi syntax anything(name=matname id="matname")
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:metric(matrix {it:matname})}"
		exit `rc'
	}
	local k : word count `matname'
	if `k' > 1 {
		di as err "{p}{bf:metric(matrix)} cannot specify more than " ///
		 "one matrix{p_end}"
		exit 198
	}
	cap mat li `matname'
	if _rc {
		di as err "{p}matrix {bf:`matname'} does not exist{p_end}"
		exit _rc
	}
	local n = matmissing(`matname')
	if `n' == 1 {
		di as err "{p}matrix {bf:`matname'} contains missing " ///
		 "values{p_end}"
		exit 504
	}
	local n = issymmetric(`matname')
	if `n' != 1 {
		di as err "{p}matrix {bf:`matname'} is not symmetric{p_end}"
		exit 505
	}
	return local metric matrix
	return local matrix `matname'
end

program define DoStandardize, rclass
	syntax newvarlist [fw iw aw], metric(string) touse(varname) ///
		vlist(string) [ wscale(name) ]

	local k : word count `varlist'
	if ("`weight'"!="") local wt [`weight'`exp']

	tempname sd avg mean stdev

	mat `mean' = J(1,`k',.)
	mat `stdev' = J(1,`k',.)
	forvalues i=1/`k' {
		local nvr : word `i' of `varlist'
		local var : word `i' of `vlist'

		qui gen double `nvr' = `var' if `touse'
		label variable `nvr' "`var'"

		qui summarize `nvr' `wt' if `touse'
		scalar `sd'  = r(sd)
		scalar `avg' = r(mean)
		mat `mean'[1,`i'] = `avg'
		mat `stdev'[1,`i'] = `sd'
		/* center 	 					*/
		qui replace `nvr' = `nvr'-`avg' if `touse'
		if "`wscale'" != "" {
			qui replace `nvr' = `nvr'*scalar(`wscale') if `touse'
		}
		/* scale for ivar    					*/
		if "`metric'" == "ivariance" {
			/* sd == 0 if factor variable base		*/
			if (`sd'>0) qui replace `nvr' = `nvr'/`sd' if `touse'
		}
	}
	return mat mean = `mean'
	return mat stdev = `stdev'
end

exit
