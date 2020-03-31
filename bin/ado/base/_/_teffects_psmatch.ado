*! version 1.2.2  21oct2015

program define _teffects_psmatch, byable(onecall)
	version 13.0

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if ("`e(cmd)'" != "teffects") error 301
		if ("`e(subcmd)'" != "psmatch") error 301
		if (_by()) error 190
		global S_1 = e(chi2_c)
		_teffects_replaym `0'
		exit
	}
	_teffects_parse_canonicalize psmatch : `0'
	if `s(eqn_n)' == 1 {
		_teffects_error_msg, cmd(psmatch) case(1)
	}		
	if `s(eqn_n)' > 2 {
		_teffects_error_msg, cmd(psmatch) case(2)
	}
	local depvar `"`s(eqn_1)'"'
	local tmodel `"`s(eqn_2)'"'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local wt `"`s(wt)'"'
	local options `"`s(options)'"'

	`BY' Estimate `if'`in' `wt', omodel(`depvar') tmodel(`tmodel') `options'
end

program define Estimate, eclass byable(recall) sortpreserve
	syntax  [if] [in] [fw],  		///
		omodel(string)			///
		tmodel(string) [		///
		NNeighbor(passthru)	    	///
		vce(string)			///
		ate atet atc			///
		CONtrol(passthru)		///
		TLEvel(passthru)		///
		PSTOLerance(passthru)		///
		OSample(name)			///
		CALiper(passthru)         	///
		GENerate(string)		///
		noDISPLAY noCORRECTion	 	///
		TRace PSIterate(integer 250) 	///
		first sample			///
		NOSORT				///
		log				///
		* ]

	/* undocumented options: 					*/
	/*  nocorrection	- no Abadie & Imbens correction		*/
	/*  trace 		- display details of estimation		*/
	/*  psiterate(#)	- -iterate(#)- option for pscores	*/
	/*  first		- display the PS model coef. table	*/
	/*  sample		- sample estimates for standard errors	*/
	/*  atc			- avg treat effect for the controls	*/
	/*  nosort		- do not sort propensity scores, debug	*/
	/*  log			- prompt which matching phase is occur	*/

	_get_diopts diopts rest, `options'

	if "`rest'" != "" {
		local wc: word count `rest'
		di as err `"{p} `=plural(`wc',"option")' {bf:`rest'} "' ///
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
		local osopt osample(`osample')
	}

	ParseDepvar `omodel'
	local depvar `s(varlist)'
	local varlist `omodel'

	local k : word count `ate' `atet'
	if `k' > 1 {
		di as err "{p}options {bf:ate} and {bf:atet} "		///
			"cannot both be specified{p_end}"
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
	ExtractVarlist `tmodel'
	local tvarlist `s(varlist)'
	local tops `s(options)'

	_teffects_parse_tvarlist `tvarlist', `tops' touse(`touse') `wopt' ///
			binary stat(`stat') `control' `tlevel' cmd(psmatch)
	local tvar `s(tvar)'
	local psvarlist `s(tvarlist)'
	local fvpsvarlist `s(fvtvarlist)'
	/* tvarlist specified with factor notation			*/
	local fvops `s(fvops)'
	local kpsvar = `s(k)'
	local kfpsvar = `s(kfv)'
	local tmodel `s(tmodel)'
	local linear `s(linear)'
	if "`tmodel'" == "hetprobit" {
		local hvarlist `s(hvarlist)'
		local fvhvarlist `s(fvhvarlist)'
	}
	local constant `s(constant)'
	local covopt psvarlist(`psvarlist')
	local tlevels `s(levels)'
	local control = `s(control)'
	local treated : list tlevels - control
	local treated : list retokenize treated
	/* treated/control counts					*/
	local n0 = `s(n`control')'
	local n1 = `s(n`treated')'
	local nmin = min(`n1',`n0')

	if `kpsvar' == 0 {
		di as err "{p}{it:varlist} for treatment model is "	///
		   "missing; propensity scores cannot be estimated{p_end}"
		exit 198
	}

	_teffects_vlist_exclusive2, vlist1(`depvar')  ///
		vlist2(`tvar') case(1)
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
	if "`pstolerance'" != "" {
		ParsePSTolerance, `pstolerance'
		local pstolerance = `s(pstolerance)'
	}
	else local pstolerance = 1e-5 /* function of # obs?		*/

	if "`caliper'" != "" {
		ParseCaliper, `caliper'
		local caliper = `s(caliper)'
	}
	else local caliper = .

	if "`vce'" != "" {
		ParseVCE `nmin' : `vce'
		local robust = `s(robust)'
	}
	else local robust = 2

	if ("`trace'"!="") local cap cap noi
	else local cap cap

	tempvar t01
	qui gen byte `t01' = cond(`tvar'==`control',0,1) if `touse'

	if "`trace'" != "" {
		di as txt _n "computing p-scores using `tmodel'"
	}
	if "`tmodel'"=="logit" | "`tmodel'"=="probit" {
		`cap' `tmodel' `t01' `fvpsvarlist' `wts' if `touse', ///
			iterate(`psiterate') `nolog'
		local rules = 1
	}
	else {  
		`cap' hetprobit `t01' `fvpsvarlist' `wts' if `touse', ///
			het(`fvhvarlist') iterate(`psiterate') `nolog'
		local rules = 0
	}
	if "`first'" != "" {
		_prefix_display, depname(`depvar')
	}
	if (e(converged)==0 & _rc==0) local rc = 430
	else local rc = c(rc)

	if `rc' > 1 {
		di as err "{p}{bf:`tmodel'} failed to estimate propensity " ///
		 "scores; computations cannot proceed{p_end}"
	}
	if (`rc') exit `rc'

	if (`rules') {
		if el(e(rules),1,1) != 0 {
			tempname rules
			matrix `rules' = e(rules)
			di
			_binperfout `rules'
	
			di as err "{p}perfect predictors are not allowed; " ///
			 "try estimating your {bf:`tmodel'} model before "  ///
			 "calling {bf:teffects psmatch}{p_end}"
			exit 459
		}
	}

	tempname fI bps Vps
	mat `bps' = e(b)
	mat `Vps' = e(V)

	local pstripe : colfullnames `bps'
	local pstripe : subinstr local pstripe "`t01'" "`tvar'", all
	mat colnames `bps' = `pstripe'
	mat colnames `Vps' = `pstripe'
	mat rownames `Vps' = `pstripe'

	local nc = `kfpsvar'+1
	mat `fI' = `Vps'[1..`nc',1..`nc']

	tempvar pscorev xb sigma
	qui predict double `pscorev' if `touse', pr
	qui predict double  `xb' if `touse', xb
	if "`tmodel'" == "hetprobit" {
		qui predict double `sigma' if `touse', sigma
	}
	CheckOverlap `pscorev', touse(`touse') pstol(`pstolerance') ///
		stat(`stat') `osopt'

	/* recount treatment variable					*/
	_teffects_count_obs `touse', `wopt' tabulate(`t01', levels(2)) ///
		why(observations with missing values)
	local n0 = `r(n0)'
	local n1 = `r(n1)'
	local N = `n0' + `n1'
	local nmin = min(`n1',`n0')

	if "`trace'" != "" {
		cap graph drop matchps_PSCORE
		cap graph drop matchps_XB
		graph box `xb' `t01' if `touse', name(matchps_XB)
		graph box `pscorev' `t01' if `touse', name(matchps_PSCORE)
		if "`tmodel'" == "hetprobit" {
			cap graph drop matchps_SIGMA
			graph box `sigma' `t01' if `touse', name(matchps_SIGMA)
		}
	} 
	if "`nosort'"=="" {
		tempvar index
		gen `c(obs_t)' `index' = _n
		sort `t01' `pscorev' `index'
	}
	local itype = ("`type'"=="population")
	local novarc = ("`correction'"!="")

	mata: _matchps_estimates(`nneighbor',`robust',`itype',`caliper',   ///
		`novarc',"`pscorev'","`xb'","`sigma'","`stat'","`tmodel'", ///
		"`depvar'","`fvpsvarlist'","`t01'","`weight'","`wvar'",    ///
		"`fI'",("`generate'","`genty'"),"`touse'","`osample'",     ///
		"`index'",("`log'"!=""))

	local indexvar `"`r(indexvar)'"'
	local n0 = r(n0)
	local n1 = r(n1)
	local novarc = (r(novarc)!=0)
	local mmin = r(mmin)
	local mmax = r(mmax)

	/* store results in ereturn and display 			*/
	local treated : list tlevels - control
	local treated : list retokenize treated
	local cmp r`treated'vs`control'
	local STAT = upper("`stat1'")
	if ("`type'"=="population") local name `STAT':`cmp'.`tvar'
	else local name S`STAT':`cmp'.`tvar'

	tempname b V v

	mat `b' = r(tau)
	mat coln `b' = "`name'"
	mat rown `b' = "`depvar'"
	mat `V' = r(var)
	scalar `v' = `V'[1,1]
	mat rown `V' = "`name'"
	mat coln `V' = "`name'"
	local N = r(N)

	ereturn post `b' `V' `wts', depname("`depvar'") obs(`N') ///
		esample(`touse')

	signestimationsample `depvar' `tvar' `psvarlist' `indexvar'
	ereturn matrix bps = `bps'
	ereturn matrix Vps = `Vps'
	ereturn scalar n`control' = `n0'
	ereturn scalar n`treated' = `n1'
	/* can remove !e(sample) without data signature changing	*/
	/* indices from -generate()- will be invalid			*/
	ereturn hidden scalar Nobs = _N
	ereturn scalar caliper = `caliper'
	ereturn scalar treated = `treated'
	ereturn scalar control = `control'
	ereturn scalar k_nneighbor = `nneighbor'
	ereturn scalar k_nnmin = `mmin'
	ereturn scalar k_nnmax = `mmax'
	ereturn hidden scalar conserv_se = `novarc'
	ereturn scalar k_robust = `robust'
	ereturn hidden local type "`type'"
	if `robust' & `v' {
		ereturn local vcetype "AI Robust"
		ereturn local vce "robust"
	}
	if "`tmodel'" == "hetprobit" {
		ereturn local hvarlist `"`hvarlist'"'
		ereturn hidden local htvarlist `"`hvarlist'"'
		ereturn hidden local fvhtvarlist `"`fvhvarlist'"'
	}
	if "`indexvar'" != "" {
		local i = 0
		foreach var of varlist `indexvar' {
			label variable `var' "nearest-neighbor index `++i'"
		}
	}
	ereturn local indexvar `"`indexvar'"'
	ereturn local psvarlist `"`psvarlist'"'
	ereturn hidden local tvarlist `"`psvarlist'"'
	ereturn hidden local fvtvarlist `"`fvpsvarlist'"'
	ereturn scalar k_levels = 2
	ereturn local tlevels "`tlevels'"
	local title "Treatment-effects estimation"
	ereturn local title `title'
	if "`weight'" != "" {
		ereturn local wexp "`exp'"
		ereturn local wtype "`weight'"
	}
	ereturn local stat "`stat1'"
	if ("`linear'"=="") ereturn local tmodel "`tmodel'"
	else ereturn local tmodel "`linear' `tmodel'"
	ereturn local subcmd "psmatch"
	ereturn local tvar "`tvar'"
	ereturn local depvar "`depvar'"

	if ("`display'"=="") _teffects_replaym, `diopts'
	
	return clear
	sreturn clear
end

program define ParseDepvar, sclass
	cap noi syntax varname(numeric)
	local rc = c(rc)
	if `rc' {
		if `rc' == 103 {
			_teffects_error_msg, cmd(psmatch) case(7) rc(`rc')
		} 
		else {
			di as txt "{phang}The outcome model is "	///
				"misspecified.{p_end}"
			exit `rc'
		}
	}
	sreturn local varlist `"`varlist'"'
end

program define ExtractVarlist, sclass
	cap noi syntax varlist(numeric fv), [ * ]
	local rc = c(rc)
	if `rc' {
		_teffects_error_msg, cmd(psmatch) case(5) rc(`rc')
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

program define ParsePSTolerance, sclass
	syntax, pstolerance(real)

	if `pstolerance' < 0 {
		di as error "{p}{bf:pstolerance({it:#})} must be a real " ///
		 "greater than or equal to 0{p_end}"
		exit 198
	}
	sreturn local pstolerance = `pstolerance'
end

program define ParseCaliper, sclass
	syntax, caliper(real) 

	if `caliper' <= 0 {
		di as err "{p}{bf:caliper({it:#})} must be greater than " ///
		 "0{p_end}"
		exit 198
	}
	sreturn local caliper = `caliper'
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
			 "suboption {bf:nn()} cannot be specified with "  ///
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
			di as err "{p}invalid {bf:vce()} specification; " ///
			 "{bf:nn({it:#})} must be an integer between 2 " ///
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

program define CheckOverlap
	syntax varname(numeric), touse(varname) pstol(real) stat(string) ///
		[ osample(string) ]

	tempname nm
	scalar `nm' = 0
	if "`osample'" != "" {
		qui gen byte `osample' = 0 if `touse'
		label variable `osample' "overlap violation indicator"
	}
	CheckOverlap1 `varlist', tol(`pstol') touse(`touse') ///
		direction(missing) count(`nm')
	if "`stat'"=="ate" | "`stat'"=="atc" {
		CheckOverlap1 `varlist', tol(`pstol') touse(`touse') ///
			direction(less) os(`osample') count(`nm')
	}
	if "`stat'"=="ate" | "`stat'"=="att" {
		CheckOverlap1 `varlist', tol(`pstol') touse(`touse') ///
			direction(greater) os(`osample') count(`nm')
	}
	if `nm' {
		di as err "{p}treatment overlap assumption has been " ///
		 "violated" _c
		if "`osample'" != "" {
			local link teffects##osample:osample
			di as err " by observations identified in variable " ///
			 "{helpb `link'}{bf:(`osample')}{p_end}"
		}
		else {
			di as err "; use the "                       ///
			 "{helpb teffects psmatch##osample:osample}" ///
			 "{bf:()} option to identify the observations{p_end}"
		}
		exit 459
	}
	_teffects_count_obs `touse', ///
		why(missing observations and invalid propensity scores)
end

program define CheckOverlap1
	syntax varname(numeric), tol(real) touse(varname) direction(string) ///
		count(name) [ os(string) ]

	tempvar cnt
	qui gen byte `cnt' = 0
	if "`direction'" == "less" {
		qui replace `cnt' = (`varlist'<`tol') if `touse'
	}
	else if "`direction'" == "greater" {
		qui replace `cnt' = (`varlist'>1-`tol') if `touse'
		local extra "1 -"
	}
	else {
		local missing " missing"
		qui replace `cnt' = missing(`varlist') if `touse'
	}
	qui count if `cnt' 
	local k = r(N)
	if (`k'<=0) exit

	scalar `count' = `count' + `k'
	if "`os'" != "" {
		qui replace `os' = 1 if `cnt'
	}
	if `k' > 1 {
		local exp "there are `k'`missing' propensity scores"
	}
	else {
		local exp "there is `k'`missing' propensity score"
	}
	
	di as err "{p}`exp' " _c
	if "`direction'" != "missing" {
		local stol  %10.0e `tol'
		di as err "`direction' than `extra'" %9.3e `tol'
	}
	di as err "{p_end}"
end

exit
