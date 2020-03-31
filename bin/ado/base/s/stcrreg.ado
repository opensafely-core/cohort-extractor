*! version 1.7.1  08oct2019
program stcrreg, eclass byable(onecall) prop(st hr nohr shr noshr sw mi)
	if replay() {
		version 11
		syntax [if] [in] [, COMPete(string) *]
		if `"`compete'"' == "" {
			if "`e(cmd)'" != "stcrreg" {
				error 301
			}
			if _by() {
				error 190
			}
			Display `0'
			exit
		}
	}

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	version 11
	local version : di "version " string(_caller()) ":"
	`version' `by' _vce_parserun stcrreg, /// 
		mark(OFFset CLuster) stdata noneedvarlist ///
		numdepvars(0) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"stcrreg `0'"'
		capture mata: _stcrr_cleanup_st()
		exit
	}

	capture noisily `version' `by' Estimate `0'
	local rc = _rc
	ereturn local cmdline `"stcrreg `0'"'
	capture mata: _stcrr_cleanup_st()
	exit `rc'
end

program Estimate, sortpreserve eclass byable(recall)
	local vv : di "version " string(_caller()) ", missing:"
	version 11
	syntax [varlist(default=none fv)] 	///
		  [if] [in] 			///
		  [fw iw pw], 			///
		  COMPete(string) [   		///
		  Level(cilevel)    		///
		  FROM(string)	    		///
		  OFFset(varname numeric)	///
		  noADJust			///
		  vce(passthru)			///
		  Robust CLuster(passthru)	///
		  noSHR				///
		  noHR				/// (synonym)
		  noSHow			///
		  noHEADer			///
		  notable			///
		  nodisplay			///
		  tvc(varlist fv numeric)	///
		  texp(string)			///
		  scorelike(string)		/// (internal use only)
		  scoretype(string)		/// (internal use only)
		  predict(string)		/// (internal use only)
		  predtype(string)		/// (internal use only)
		  llonly(string)		/// (internal use only)
		  OIM		    		/// (undocumented)
		  *				/// (mlopts)
	]

	local fvops = ("`s(fvops)'" == "true")

	if "`display'" != "" {
		local table notable
		local header noheader
	}
	if "`weight'" != "" {
		di as err "weights must be stset"
		exit 101
	}

	st_is 2 analysis

	marksample touse
	markout `touse' `offset' `_dta[st_wv]' `tvc'
	qui replace `touse' = 0 if _st==0

	local xvars `varlist'

	// Parse tvc() and texp()
	
	if `"`texp'"' != "" & "`tvc'" == "" {
		di as err "{p 0 4 2}texp() only allowed with tvc(){p_end}"
		exit 198
	}

	if "`tvc'" != "" {
		tempvar foft1
		if `"`texp'"' == "" {
			local texp _t
		}
		local texp: subinstr local texp " " "", all
		cap gen double `foft1' = `texp' if `touse'
		if _rc {
			di as err "{p 0 4 2}texp() invalid{p_end}"
			exit 198
		}
		qui count if `touse' & missing(`foft1')
		if `r(N)' {
			di as err "{p 0 4 2}texp() evaluates to missing for "
			di as err "`r(N)' observations{p_end}"
			exit 459
		}
		FunctionOfTime `foft1' if `touse'
		local tvcopt `"tvc(`tvc') texp(`texp')"'
	}

	// Find last records in multiple record data
	
	tempvar lastrec
	local id : char _dta[st_id]
	if "`id'" != "" {
		sort `id' `touse' _t
		qui by `id': gen byte `lastrec' = (_n==_N) & `touse'
	}
	else {
		qui gen byte `lastrec' = `touse'
	}

	// Error out if multiple-failure data
	
	qui count if `touse' & !`lastrec' & _d != 0 
	if `r(N)' {
		di as err "{p 0 4 2}data with multiple failures per subject "
		di as err "not supported by stcrreg{p_end}"
		exit 459
	}

	// Record the above sort order for mata structure (placing of 
	// scores within observations)

	tempvar obsno
	qui gen `c(obs_t)' `obsno' = _n 

	// Competing risks event indicator
	
	tempvar crvar
	ParseCompete `"`compete'"' `crvar' `lastrec'
	local crevent `"`s(crevent)'"'
	local crmult  `s(crmult)'
	local crnz    `s(crnz)'
	local iscox   `s(iscox)'

	GetFailEvents
	local fevent `"`s(fevent)'"'
	local fmult `s(fmult)'
	local fnz   `s(fnz)'

	// Weights (stset handles the marking out)
	
	tempvar wtvar
	local wt : char _dta[st_w]
	if `"`wt'"' != "" {
		local hoptions `options'
		local 0 `wt'
		syntax [fw iw pw/]
		qui gen double `wtvar' = `exp' if `touse'
		qui sum `wtvar' if `touse'
		local sumw = r(sum)
		local nw   = r(N)
		if "`weight'" == "pweight" {
			qui replace `wtvar' = `wtvar'/`sumw'*`nw' if `touse'
		}
		if "`weight'" == "iweight" {
			cap assert `wtvar' > 0 if `touse'
			if _rc {
				di as err "{p 0 4 2}iweights may not be "
				di as err "negative in stcrreg{p_end}"
				exit 498
			}
		}
		local wtopt `"[`weight'=`wtvar']"'
		local options `hoptions'
	}
	else {
		qui gen byte `wtvar' = 1 if `touse'
	}

	// Offset
	
	if "`offset'" != "" {
		local offopt "offset(`offset')"
	}

	// vce()
	
	local vceopt = `:length local vce'		| 	///
		       `:length local cluster'		|	///
		       `:length local robust'		
	
	if `vceopt' {
		_vce_parse, argopt(CLuster) opt(Robust) old	///
		:, `vce' `cluster' `robust'

		if "`r(cluster)'" != "" {
			local clustvar `r(cluster)'
			local clustopt cluster(`clustvar')
		}
	}

	if "`clustvar'" != "" {
		markout `touse' `clustvar', strok
	}

	// Failure type variable, in order, for mata structure
	
	tempvar failtype
	qui gen byte `failtype' = 4 if `touse'
	qui replace  `failtype' = 3 if (_d==0)    & `touse' & `lastrec'
	qui replace  `failtype' = 2 if `crvar'    & `touse' & `lastrec'
 	qui replace  `failtype' = 1 if (_d==1)    & `touse' & `lastrec'

	// Do some counting

	if "`weight'" != "" & "`weight'" != "pweight" {
		local swtopt `wtopt'
	}
	local iw = ("`weight'" == "iweight")
	local fw = ("`weight'" == "fweight")
	qui sum if `lastrec' `swtopt', meanonly  
	local nsubj = cond(`iw', r(sum_w), r(N))
	qui sum if `failtype' == 1 `swtopt', meanonly
	local nfail = cond(`iw', r(sum_w), r(N))
	qui sum if `failtype' == 2 `swtopt', meanonly
	local ncomp = cond(`iw', r(sum_w), r(N))
	qui sum if `failtype' == 3 `swtopt', meanonly
	local ncensor = cond(`iw', r(sum_w), r(N))
	if `iw' | `fw' {
		if "`clustvar'" != "" {
			tempvar cl
			qui egen long `cl' = group(`clustvar') if `touse'
			qui sum `cl', meanonly
			local nclust = r(max)
		}
		else {
			local nclust = `nsubj'
		}	
	}

	// DiOpts
	
	_get_diopts diopts options, `options'

	// ML
	
	mlopts mlopts, `options'
	local coll `s(collinear)'

	// Remove collinear variables; put weights in too 
	
	_rmcoll `xvars' `wt' if `touse', expand `coll'
	local xvars `r(varlist)'

	if `"`tvc'"' != "" {
		_rmcoll `tvc' `wt' if `touse', expand `coll'
		local tvc `r(varlist)'
	}

	// Setup mata structure
	// Requires: touse, failtype, xvars, obsno, offset, tvc, foft1, fvops
	
	mata: _stcrr_setup_st()

	// Log-likelihood only, calculate and exit
	
	if `"`llonly'"' != "" {
		confirm matrix `llonly'
		mata: _stcrr_lf_st("`llonly'")
		di as txt "log pseudolikelihood is " as res r(ll)
		ereturn scalar llonly = r(ll)
		exit
	}

        // If I only want score-like residuals, then get them and exit.  This
        // assumes e(b) is valid for the model.

        if `"`scorelike'"' != "" { 
		GetScoreLike `scorelike', type(`scoretype')
		exit
        }
	if `"`predict'"' != "" {
		GetPrediction `predict', type(`predtype')
		exit
	}

	// Survival settings
	
	if "`show'" == "" & `"`_dta[st_show]'"' == "" {
		st_show 
	}

	// Null model
	if "`xvars'" == "" & "`tvc'" == "" {
		tempname bb bc vc
		// Grab null e(b) and e(V) to repost
		qui stcox if `touse', estimate
		mat `bc' = e(b)
		mat `vc' = e(V)
		mat `bb' = 0
		mata: _stcrr_lf_st("`bb'")
		local ll0 = r(ll)
		qui sum `wtvar' if `touse', meanonly
		local N = cond(`iw' | `fw', r(sum_w), r(N))
		if "`id'" != "" {
			local nclust = `nsubj'	
		}
		if "`clustvar'" != "" {
			tempvar gr
			qui egen long `gr' = group(`clustvar') if `touse'
			qui sum `gr', meanonly
			local nclust = r(max)
		}
		ereturn post `bc' `vc' `wt', depname(_t) ///
		                             esample(`touse') obs(`N') ///
					     buildfvinfo ADDCONS
		ereturn scalar ll = `ll0'
		ereturn hidden local crittype log pseudolikelihood
		ereturn scalar chi2 = 0
		ereturn scalar df_m = 0
		ereturn scalar p = .
		ereturn local chi2type Wald
		ereturn local offset1 `offset'
		ereturn local vcetype "Robust"
		ereturn local vce robust
		ereturn local properties "b V"
		if "`id'" != "" {
			ereturn local clustvar `id'
			ereturn local vce cluster
			ereturn scalar N_clust = `nclust'
		}
		if "`clustvar'" != "" {
			ereturn local clustvar `clustvar'
			ereturn local vce cluster
			ereturn scalar N_clust = `nclust'
		}
	}
	else {
		// Starting values 
		if `"`from'"' == "" {
			tempname bb
			local k1 : word count `xvars'
			local k2 : word count `tvc'
			cap stcox `xvars' if `touse', iter(10) ///
			          `offopt' norefine `tvcopt'
			if _rc {
				local initzero initzero
				mat `bb' = J(1, `=`k1'+`k2'', 0)
				local initopt init(`bb', copy)
			}
			else {
				mat `bb' = e(b)
				local k = colsof(`bb') 
				if `k' != `k1' + `k2' {
					mat `bb' = J(1, `=`k1'+`k2'', 0)
				}
				local initopt init(`bb', copy)
			}
		}
		else {
			local initopt `"init(`from')"'
		}

		if "`tvc'" != "" {
			if "`xvars'" != "" {
			 	local maineq (main:_t = `xvars', 
				local maineq `maineq' `offopt' noconstant)
			}
			local tvceq  (tvc: = `tvc', noconstant)	
		}
		else {
			if "`xvars'" != "" {
				local maineq (_t = `xvars', 
				local maineq `maineq' `offopt' noconstant)
			}
		}

		`vv'					///
		ml model d2 stcrr_lf 			///
		    	`maineq'			///
		    	`tvceq'				///
		    	if `touse',			///
		    	`initopt'	       		///
		    	search(off)			///
		    	missing				///
		    	nopreserve			///
		    	crittype(log pseudolikelihood) 	///
		    	`mlopts'			///
		    	maximize

		// You need robust standard errors; Hessians don't cut it

		if ("`oim'" == "") {			// undocumented option
			local nc = `:word count `xvars'' + `:word count `tvc''	
			forval i = 1/`nc' {
				tempvar sc`i'
				local scvars `scvars' `sc`i''
			}
			GetScoreLike `scvars', type(scores)
			if "`id'" != "" & `"`clustopt'"' == "" {
				local clustopt cluster(`id')
			}
			if "`adjust'" != "" {
				local minusopt minus(0)
			}
			// I treat fw/iw as whole new subjects with their
			// own multiple records, not expanded records within
			// the same subject. This requires manual calculations.
			if `iw' | `fw' {
				tempvar iwght
				qui gen double `iwght' = sqrt(`wtvar') ///
						if `touse'
				if "`adjust'" == "" {
					qui replace `iwght' = `iwght' * ///
					        sqrt(`nclust'/(`nclust'-1)) ///
						if `touse'
				}
				local wtopt `"[iw=`iwght']"'
				local minusopt minus(0)
			}

			_robust2 `scvars' `wtopt' if `touse', ///
		        	`minusopt' allcons `clustopt'

			if (`iw' | `fw') & `"`clustopt'"' != "" {
				ereturn scalar N_clust = `nclust'
			}
		}

		// Wald test

		qui test [#1]
		if "`tvc'" != "" {
			if "`xvars'" != "" {
				qui test [#2], accum
			}
		}
		if `r(df)' < `e(rank)' {
			ereturn scalar chi2 = . 
			ereturn scalar p = .
			ereturn scalar df_m = r(df)
		}
		else {
			ereturn scalar chi2 = r(chi2)
			ereturn scalar p = r(p)
			ereturn scalar df_m = r(df)
		}
	}

	// Returned results

	ereturn repost, buildfvinfo ADDCONS
	if "`weight'" == "fweight" | "`weight'" == "iweight" {
		ereturn scalar N = `sumw'
	}
	ereturn local cmd stcrreg
	ereturn hidden local marginsprop addcons allcons
	ereturn local marginsnotok SCOres ESR DFBeta SCHoenfeld
	ereturn local predict stcrreg_p
	ereturn hidden local marginsfootnote _multirecordcheck
	ereturn local wtype `weight'
	ereturn local wexp   `"= `exp'"'
	ereturn local compete `"`compete'"'
	ereturn local crevent `"`crevent'"'
	ereturn local fevent `"`fevent'"'
	ereturn local mainvars `xvars'
	ereturn local tvc `"`tvc'"'
	ereturn local texp `"`texp'"'
	ereturn local initzero `initzero'	// undocumented
	if "`tvc'" != "" {
		if "`xvars'" != "" {
			ereturn hidden scalar k_eform = 2
			ereturn scalar k_eq_model = 2
		}
		else {
			ereturn hidden scalar k_eform = 1
			ereturn scalar k_eq_model = 1
			if "`offset'" != "" {
				ereturn local mainoff `offset'
			}
		}
	}
	ereturn local title Competing-risks regression

	ereturn scalar fmult  = "`fmult'" != ""
	ereturn scalar crmult = "`crmult'" != ""
	ereturn scalar fnz    = "`fnz'" != ""
	ereturn scalar crnz   = "`crnz'" != ""

	ereturn scalar N_sub     = `nsubj'
	ereturn scalar N_fail    = `nfail'
	ereturn scalar N_compete = `ncomp'
	ereturn scalar N_censor  = `ncensor'

	Display, level(`level')	`table' `header' `hr' `shr' `diopts'
end

program Display
	syntax [, Level(cilevel) notable noHEADer noHR noSHR *]

	_get_diopts diopts, `options'

	local fnote 0
	local cnote 0
	if "`header'" == "" {
		DiHeader
		local fnote = r(fnum)
		local cnote = r(cnum)
	}
	if "`table'" == "" {
		if "`hr'" == "" & "`shr'" == "" {
			local eform eform(SHR)
		}
		if "`e(tvc)'" != "" {
			local showeqns showeqns
		}
		di
		_coef_table, level(`level') `eform' `showeqns' `diopts'
	}
	if "`table'" == "" {
		if !`e(N_compete)' {
			di as txt "{p 0 4 2}Warning: no competing risks events "
			di as txt "found; model is Cox regression{p_end}"
		}
	}
	if "`header'" == "" {
		if `fnote' {
			di as txt "{p 0 4 2}(`fnote') " as res `"`e(fevent)'"' 
			di as txt "{p_end}"
		}
		if `cnote' {
			di as txt "{p 0 4 2}(`cnote') " as res `"`e(crevent)'"' 
			di as txt "{p_end}"
		}
	}
	if "`table'" == "" {
		if "`e(tvc)'" != "" {
			di as txt "{p 0 4 2}Note: Variables in " as res "tvc "
			di as txt "equation interacted with `e(texp)'.{p_end}"
		}
		if "`e(mainoff)'" != "" {
			di as txt "{p 0 6 2 79}Note: Model includes the linear "
			di as txt "offset " as res "`e(mainoff)'" 
			di as txt " in equation "
			di as res "main" as txt ".{p_end}"
		}
	}
end

program DiHeader, rclass
	di 
	local cc 16
	if `e(crmult)' {
		local s2 s
		local cc 17
	}
	if `e(fmult)' {
		local s s
	}
	local crtype =  upper(bsubstr(`"`e(crittype)'"',1,1)) + ////
	                      bsubstr(`"`e(crittype)'"',2,.)
	di as txt "`e(title)'" _c 
	di as txt _col(50) "No. of obs" 		_col(67) "=" /// 
		_col(69) as res %10.0fc e(N)
	di as txt _col(50) "No. of subjects" 	_col(67) "=" ///
		_col(69) as res %10.0fc e(N_sub)
	local fnum 0
	local fevent `e(fevent)'
	if `:length local fevent' <= 25 {
		di as txt "Failure event`s'" _col(`cc') ": " ///
			as res `"`e(fevent)'"' _c
		if `"`e(fevent)'"' == "1" {
			di as txt " (meaning all fail)" _c
		}
		if `e(fnz)' {
			di as txt " nonzero, nonmissing" _c
		}
	}
	else {
		local ++fnum
		di as txt "Failure event`s'" _col(`cc') ": " /// 
			as txt "(`fnum')" _c
	}
	di as txt _col(50) "No. failed"         _col(67) "=" ///
		_col(69) as res %10.0fc e(N_fail)
	local cnum 0
	local crevent `e(crevent)'
	if `:length local crevent' <= 25 {
		di as txt "Competing event`s2'" _col(`cc') ": " as res /// 
			`"`e(crevent)'"' _c
		if `e(crnz)' {
			di as txt " nonzero, nonmissing" _c
		}
	}
	else {
		local cnum = 1 + `fnum'
		di as txt "Competing event`s2'" _col(`cc') ": " as txt /// 
			"(`cnum')" _c
	}

	di as txt _col(50) "No. competing" _col(67) "=" /// 
		_col(69) as res %10.0fc e(N_compete)
	di as txt _col(50) "No. censored"         _col(67) "=" ///
		_col(69) as res %10.0fc e(N_censor)
	di

	if inlist("`e(vce)'", "bootstrap", "jackknife") {
		di _col(50) as txt "Replications" _col(67) "=" /// 
			_col(69) as res %10.0fc e(N_reps)
	}
	if inlist("`e(vce)'", "jackknife") {
		if missing(`e(F)') {
			local h help j_robustsingular
			di _col(50) as smcl "{`h':F(`e(df_m)', `e(df_r)')}" _c
		}
		else {
			di _col(50) as txt "F(" /// 
				as res %4.0g e(df_m) as txt "," /// 
				as res %7.0g e(df_r) as txt ")" _c
		}
		di _col(67) as txt "=" _col(70) as res %9.2f e(F)
		di as txt "`crtype'" " = " as res %10.0g e(ll) ///
			_col(50) as txt "Prob > F" _col(67) "=" _col(73) ///
			as res %6.4f e(p)
	}	
	else {
		if missing(`e(chi2)') {
			local h help j_robustsingular
			di _col(50) as smcl "{`h':Wald chi2(`e(df_m)')}" _c
		}
		else {
			di _col(50) as txt "`e(chi2type)' chi2(" /// 
				as res e(df_m) as txt ")" _c
		}
 		di _col(67) as txt "=" _col(70) as res %9.2f e(chi2)
		di as txt "`crtype'" " = " as res %10.0g e(ll) ///
			_col(50) as txt "Prob > chi2" _col(67) "=" _col(73) ///
			as res %6.4f e(p)
	}
	return local fnum = `fnum'
	return local cnum = `cnum'
end

program GetScoreLike
	syntax newvarlist, type(string)

	foreach i of local varlist {
		qui gen double `i' = . 
	}
	capture noi mata: _stcrr_get_scorelike_st("`varlist'", "`type'")
	if _rc {
		di as err "{p 0 4 2}error calculating scorelike "
		di as err "predictions{p_end}"
		cap drop `varlist'
		exit 459
	}
end

program GetPrediction
	syntax newvarname, type(string)

	qui gen double `varlist' = . 
	capture noi mata: _stcrr_get_pred_st("`varlist'", "`type'")
	if _rc {
		di as err "{p 0 4 2}error calculating predictions{p_end}"
		cap drop `varlist'
		exit 459
	}
end

program ParseCompete, sclass sortpreserve
	args comp cvar touse

	gettoken name   comp : comp, parse(" =")
	gettoken eqsign comp : comp, parse(" =")
	if !(`"`eqsign'"'=="" | `"`eqsign'"'=="=" | `"`eqsign'"'=="==") {
		di as err "{p 0 4 2}option compete(): syntax error"
		di as err "{p_end}"
		exit 198
	}
	unab name: `name', max(1)
	local bd `name'
	local abd = abbrev("`bd'",10)
	cap confirm variable `bd', exact
	if _rc {
		di as err "{p 0 4 2}option compete(): varname required"
		di as err "{p_end}"
		exit 198
	}
	if `"`eqsign'"' != "" {
		numlist `"`comp'"', missingok
		local event `"`r(numlist)'"'
		local event : list uniq event
	}

	// save stset info
	local st_bt `_dta[st_bt]'
	local st_bd `_dta[st_bd]'
	local st_ev `_dta[st_ev]'

	if `"`st_ev'"' != "" {
		st_cmd, failure(`st_bd' == `st_ev')
		local oldcmd `"`s(st_cmd)'"'
	}
	else {
		st_cmd, failure(`st_bd')
		local oldcmd `"`s(st_cmd)'"'
	}

	if `"`event'"' != "" {
		st_cmd, failure(`bd'==`event')
		local compcmd `"`s(st_cmd)'"'
	}
	else {
		st_cmd, failure(`bd')
		local compcmd `"`s(st_cmd)'"'
	}

	qui stset `st_bt' `compcmd'

	qui gen byte `cvar' = 0
	qui replace `cvar' = 1 if _d & `touse'
	
	if `"`event'"' != "" {
		local crevent `abd' == `event'
		if `:word count `event'' > 1 {
			local crmult crmult
		}	
	}
	else {
		local crevent `abd' 
		local crnz crnz
		local crmult crmult
	}

	qui stset `st_bt' `oldcmd'

	qui count if `touse' & `cvar' & _d
	if r(N) {
		di as err "{p 0 4 2}option compete(): competing risks "
		di as err "events must be stset as censored{p_end}"
		exit 459
	}

	qui count if `touse' & `cvar' 
	if !r(N) {
		local iscox iscox
	}
	
	sreturn local crevent `"`crevent'"'
	sreturn local crmult `crmult'
	sreturn local crnz `crnz'
	sreturn local iscox `iscox'
end

program GetFailEvents, sclass
	if `"`_dta[st_bd]'"' != "" {
		local abd = abbrev("`_dta[st_bd]'",10)
		if `"`_dta[st_ev]'"' != "" {
			local fevent : di `"`abd' == `_dta[st_ev]'"'
			if `:word count `_dta[st_ev]'' > 1 {
				local fmult fmult
			}
		}
		else {
			local fevent : di `"`abd'"'
			local fmult fmult
			local fnz fnz
		}
	}
	else {
		local fevent 1
	}
	sreturn local fevent `"`fevent'"'
	sreturn local fmult `fmult'
	sreturn local fnz `fnz'
end

program FunctionOfTime, sortpreserve
	syntax varname [if]

	marksample touse
	tempvar gr
	qui egen long `gr' = group(_t `touse')
	sort `gr'
	cap by `gr': assert `varlist' == `varlist'[1] if `touse'
	if _rc {
		di as err "{p 0 4 2}texp() is not a proper function of time "
		di as err "{p_end}"
		exit 459
	}
end

program define st_cmd, sclass
	

	syntax [, failure(string) * ]	

	if `"`_dta[st_full]'"'=="" {
		local enter `"`_dta[st_enter]'"'
		local exit `"`_dta[st_exit]'"'
		local orig `"`_dta[st_orig]'"'
		local if `"`_dta[st_if]'"'
		local ever `"`_dta[st_ever]'"'
		local before `"`_dta[st_befor]'"'
		local after `"`_dta[st_after]'"'
	}
	else {
		local enter `"`_dta[st_fente]'"'
		local exit `"`_dta[st_fexit]'"'
		local orig `"`_dta[st_forig]'"'
		local if `"`_dta[st_fif]'"'
		local ever `"`_dta[st_fever]'"'
		local before `"`_dta[st_fbefo]'"'
		local after `"`_dta[st_fafte]'"'
	}

	if `"`_dta[st_wt]'"' != "" {
		local cmd `"`cmd' [`_dta[st_wt]'=`_dta[st_wv]']"'
	}

	if `"`_dta[st_ifexp]'"' != "" {
		local cmd `"`cmd' if `_dta[st_ifexp]'"'
	}

	local cmd `"`cmd',"'

	if "`_dta[st_id]'" != "" {
		local cmd `"`cmd' id(`_dta[st_id]')"'
	}

	if `"`failure'"' != "" {
		local cmd `"`cmd' failure(`failure')"'
	}

	if `"`_dta[st_bt0]'"' != "" {
		local cmd `"`cmd' time0(`_dta[st_bt0]')"'
	}

	if `"`enter'"' != "" {
		local cmd `"`cmd' enter(`enter')"'
	}

	if `"`exit'"' != "" {
		local cmd `"`cmd' exit(`exit')"'
	}

	if `"`orig'"' != "" {
		local cmd `"`cmd' origin(`orig')"'
	}

	if `"`_dta[st_bs]'"' != "1" {
		local cmd `"`cmd' scale(`_dta[st_bs]')"'
	}

	if `"`if'"' != "" {
		local cmd `"`cmd' if(`if')"'
	}

	if `"`ever'"' != "" {
		local cmd `"`cmd' ever(`ever')"'
	}

	if `"`_dta[st_never]'"' != "" {
		local cmd `"`cmd' never(`_dta[st_never]')"'
	}

	if `"`after'"' != "" {
		local cmd `"`cmd' after(`after')"'
	}

	if `"`before'"' != "" {
		local cmd `"`cmd' before(`before')"'
	}

	if `"`_dta[st_show]'"' != "" {
		local cmd `"`cmd' `_dta[st_show]'"'
	}

	sreturn local st_cmd `"`cmd'"'
end

exit
