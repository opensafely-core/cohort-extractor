*! version 2.0.1  08oct2019
program npregress, eclass byable(onecall)
        version 15
	
        if _by() {
                local BY `"by `_byvars'`_byrc0':"'
        }

	if replay() {
		local newzero `0'
	}
	else {
		_parse_reps `0'
		local newzero `"`s(newzero)'"'
	}
        `BY' _vce_parserun npregress, noeqlist nojackknife: ///
		`newzero'
        
        if "`s(exit)'" != "" {
                ereturn local cmdline `"npregress `newzero'"'
                exit
        }

        if replay() {
                if `"`e(cmd)'"' != "npregress" { 
                        error 301
                }
                else if _by() { 
                        error 190 
                }
                else if (`"`e(cmd_loco)'"'!="_npreg_series_two") {
                        Display `0'
                }
		else if (`"`e(cmd_loco)'"'=="_npreg_series_two") {
			Display_series `0'
		}
                exit
        }
	
	local estimator : word 1 of `0'
        local 0 : subinstr local 0 "`estimator'" ""
        CheckEstimator `estimator'
        local estimator `=s(estimator)'
	if ("`estimator'"=="series") {
		`vv'	///
		`BY' _npreg_series_two `0'
		ereturn local cmdline `"npregress series `0'"'
		exit 
	}
        `vv' ///
        `BY' Estimate `0'
        ereturn local cmdline `"npregress `newzero'"'

end

program Estimate, eclass byable(recall)
        
        local vv : di "version " string(_caller()) ":"
        syntax varlist(numeric ts fv) [if] [in] ///
                [,                		///
                KERNel(string)                  ///
		BWidth(string)			///
		SEBWidth(string)		///
		DERIVBWidth(string)		///
		MEANBWidth(string)		///
		IMAIC				///
		predict(string)			///
		noDERIVatives			///
		Level(cilevel)                  ///
		estimator(string)		///
                NOLOg LOg                       /// 
		from(string)			///
		TOLerance(real 1e-4)		///
                LTOLerance(real 1e-5)		///
		ITERate(integer 1000)		///
		NMsdelta(real 0.05)		///
		DIFficult			///
		TRace				///
		showstep			///
		DKERNel(string)			///
		vce(string)			///
		UNIDentsample(string)		///
		elnombredey(string)		/// UNDOCUMENTED
		elmargen(integer 0)		/// UNDOCUMENTED
		bwreplace			/// 
		Reps(string)			///
		citype(string)			///
                *                               /// 
		]

	// Parsing options 

	_get_diopts diopts rest, `options'
	qui cap Display, `diopts' `rest'
	if _rc==198 {
                Display, `diopts' `rest'
        }

	marksample touse	

	_var_simple `0'
	local varsimple = "`s(varsimple)'"
	gettoken lhs0 rh0: varsimple
	gettoken lhs rhs : varlist
        _fv_check_depvar `lhs0'	
	if ("`rhs'"=="") {
		display as error "You must specify at least one covariate"
		exit 198
	}
	_parse_uniq, mylista(`rhs')
	local varlist: list uniq varlist
	local rhs: list uniq rhs

	_yes_rhs `rh0'

	local yesrhs = r(yesrhs)
	local newvlst0 "`r(listnew)'"
	

	// Categorical variables as regressors 
	
	if (`yesrhs') {
		local knewvlst: list sizeof newvlst0	
		forvalues i=1/`knewvlst' {
			local xnewvlst: word `i' of `newvlst0'
			capture _ms_parse_parts `xnewvlst'
			local rc = _rc						
			if (`rc') {
				fvexpand `xnewvlst'
				local namevlst = r(varlist)
				local newvlst "`newvlst' `namevlst'"
				local k: list sizeof namevlst
				forvalues j=1/`k' {
					local xold: word `j' of  `namevlst'
					_ms_parse_parts `xold'
					local fvnom = r(name)
					local nameold "`nameold' `fvnom'"
					local nameold2 "`nameold2' `namevlst'"
					local nomf = r(type)
					if ("`nomf'"=="factor") {
						local disc0 "`disc0' `fvnom'"
						local disc00 "`disc00' `fvnom'"
					}
				}
			}
			else {
				local facnewvlst = r(type)
				local nomzero = r(name)
				if ("`facnewvlst'"=="factor") {
					local preniv = r(level)
					tempvar dfnew0 dfnew
					quietly generate byte `dfnew0' = ///
						`xnewvlst'
					fvexpand i.`dfnew0'
					local dfnew = r(varlist)
					local newvlst "`newvlst' `dfnew'"
					local nomzero "`preniv'.`nomzero'"
					local nameold ///
						"`nameold' `nomzero' `nomzero'"
					local disc0 "`disc0' `nomzero'"
					local disc00 ///
						"`disc00' `nomzero' `nomzero'"
					local nameold2 "`nameold2' `nomzero'"
				}
				else {
					local newvlst "`newvlst' `nomzero'"
					local nameold "`nameold' `nomzero'"
					local nameold2 "`nameold2' `nomzero'"
				}
			}
		}
	}
	else {
		local newvlst "`newvlst0'"
		local disc0 "vacio"
	}

	Check4Options, opcion(`rest')
	
	// vce
	
	if ("`vce'"!="") {
		_vce_npreg, `vce' vce(`vce')
	}
	
	// Working with weights 
	
	tempvar  newwgt ttot 
	tempname matsigmg nchk hinn
	matrix `nchk'      = .
	matrix `matsigmg'  = .

	generate `newwgt' = 1
	local wgtc = 0


	// Checking variables are present 
	
	if ("`rhs'"=="") {
		display as error "at least one regressor should be specified"
		exit 198
	}
	
	// Parsing the predict option options
	
	local pdydx   = 1
	local pmedia  = 1
	local predice = 0 
	if ("`predict'"!="") {
		_parse_predict_np `predict'
		local predijo = "`r(predijo)'"
		local pdydx   = "`r(pdydx)'"
		local pmedia  = "`r(pmedia)'"
		local predice = 1
	}
	
	// citype option 
	
	_ci_type, `citype'
	local citipo  = r(citipo)
	local scitipo "`r(scitipo)'"

	// Checking for collinearity and incorporating factor variables 
	
	tempname avars 
	_varlistcheck if `touse', variables(`newvlst0') yesrhs(`yesrhs')
	local varlist   = "`r(vars)'"
	matrix `avars' = r(A) 

	// Parsing optimization options 	

	OpTiMiZaCiOn_np,  `difficult'			///
			  tolerance(`tolerance')	///
			  ltolerance(`ltolerance')	///
			  iterate(`iterate')		///
			  `trace'			///
			  `showstep'			///
			  nmsdelta(`nmsdelta')		
	
	local show   = r(oshowstep) 
	local track  = r(otrace) 
	local dificil = r(odifficult) 	
	
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"	
	local logvar = 0 
	if ("`log'"!="") {
		local logvar = 1 
	}

	// Parsing gradient options 
	
	local grad    = 2 
	local sinvars = 0 
	
	if "`derivatives'"=="" {
		local gradient okgradient
	}
	if "`derivatives'"!="" {
		local grad    = 0
		local kgrad   = 0 
		local kderiv  = 0
		local sinvars = 1
		local sind "sinderivadas"
	}
	
	// Determining which regressors are continuous and which discrete

	tempname hin bandy bandse banda hinse hgradient deltah		///
		 hgradient2 lasbandas B basemat basevals uniqvals 	///
		 gbase bandgrad	fresults nhs rdos b V htablefin		///
		 basedisc basecont hinfc hinfd marginsg posmat matvals  ///
		 matbasep matfix naranjas ilog1 ilog2 ilog3 bboot
		 
	// collinearity checks 

	fvexpand `newvlst'
	local newvlst = r(varlist)
	
	varlist_sanity `newvlst', rhs(`newvlst0')
	local  varlist = "`r(varsfin)'"
	local rhs      = "`r(rhs)'"


	// positions 
	
	_quieto_movete `newvlst0'	
	local quieto   = "`s(quieto)'"
	local quieto2  = "`s(quieto2)'"
	local quieto3  = "`s(quieto3)'"
	local quieto4  = "`s(quieto4)'"
	local quieto5  = "`s(quieto5)'"
	local quieto6  = "`s(quieto6)'"
	local rhcero   = "`s(rhcero)'"

	// varlists for estimation 

	_contordisc if `touse', variables(`varlist') outcome(`lhs')	///
			       okgradient(`okgradient') rhs(`newvlst0')	///
			       avars(`avars') yesrhs(`yesrhs')		///
			       vzero(`newvlst0') oldnom(`nameold')	///
			       discero(`disc0') quieto(`quieto5')

	local cvars       = "`r(cvars)'"
	local dvars       = "`r(dvars)'"
	local forgen      = "`r(forgen)'"
	local cdnum       = "`r(cdnum)'"
	local allvars     = "`r(allvars)'"
	local htable      = "`r(htable)'"
	local baselevel   = "`r(base)'"
	local repito      = "`r(repito)'"
	local repito2     = "`r(repito2)'"
	local repitoall   = "`r(repitoall)'"
	local niveles     = "`r(niveles)'"
	local posfin      = "`r(posfin)'"
	local origins     = "`r(origins)'"
	local origins2    = "`r(origins2)'"
	local gradsizem   = "`r(gradsizem)'"
	matrix `hin'      = r(hvars)
	matrix `basemat'  = r(basemat)
	matrix `basevals' = r(basevals)
	matrix `uniqvals' = r(uniqvals)
	matrix `basecont' = r(basecont)
	matrix `basedisc' = r(basedisc)
	matrix `posmat'   = r(posmat)
	local k : word count `allvars'
 
	if (`yesrhs') {
		local origins: list uniq nameold
		local origins2: list uniq nameold
		local nameold2: list uniq nameold2
		local repito "`disc00'"
		local repito2 "`disc00'"
		local repitoall "`nameold'"
		local discrete: list uniq disc0
		local discrete4: list uniq disc0	
		local allvars "`cvars' `disc0'"	
		local allvars: list uniq allvars	
		local kyesrhs: list sizeof allvars
		forvalues i=1/`kyesrhs' {
			local xyesrhs: word `i' of `allvars'
			local htable "`htable' h_`xyesrhs'"
		}
	}

	// Getting kernel estimator 

	KeStImAtoR, kestimator(`estimator') `gradient' `okgradient'	///
		    cdnum(`cdnum')
	local kest   = "`s(kest)'"
	local klabel = "`s(klabel)'"
	local degree = "`s(degree)'"
	local kestnm = "`s(kestname)'"
	
	// Parsing bandwidth and from options
	
	if ("`derivbwidth'"!="" & "`sind'"!="") {
		display as error "option {bf:derivbwidth()} specified" ///
			" incorrectly"
		di as err "{p 2 2 2}" 
		di as smcl as err "You may not combine option"
		di as smcl as err " {bf:derivbwidth()} with" 
		di as smcl as err " option {bf:noderivatives}" 
		di as smcl as err "{p_end}"		
		exit 198 
	}
	
	local bwrep = 0
	if ("`bwreplace'"!="") {
		local bwrep = 1 
	}
	
	local bsnote = 1
	local prefix = c(prefix)
	local isbootstrap : list posof "bootstrap" in prefix
	local isloop      : list posof "_loop"     in prefix
	
	if ("`bwreplace'"!="" & !`isbootstrap') {  
		display as error "options {bf:bwreplace} only valid with" ///
			" {bf:vce(bootstrap)}"
		exit 198
	}
	
	if (`"`bwidth'"' == "" & `bwrep'==0) {
		if (`isbootstrap' & `isloop') {
			if `"`e(cmd)'-`e(bwidth)'"' == "npregress-matrix" {
				tempname bwidth
				matrix `bwidth' = e(bwidth)
			}
		}
	}
	
	if (`isbootstrap' & !`isloop') {
		local bsnote = 0 
	}
	
	_np_gets_band, bscont(`basecont') bsdisc(`basedisc')	///
		       cdnum(`cdnum') origins(`origins') 	///
		       allvars(`allvars') from(`from')		///
		       bwidth(`bwidth') 			///
		       derivbwidth(`derivbwidth')		///
		       meanbwidth(`meanbwidth')			///
		      `sind'

	local allfix     = "`r(allfix)'"
	local fixed      = "`r(fixed)'" 
	local fixedgrad  = "`r(fixedgrad)'"
	local fxgr       = 0 
	
	if (`fixed'>0 | "`from'"!="") { 
		matrix `hin'  = r(hin)
	}
	if (`fixedgrad' >0 | ("`from'"!="" & "`sind'"=="")) {
		matrix `hgradient' = r(hgradient) 
	}
	
	// noidsample errors 
	
	if ("`unidentsample'"!="") {
		capture quietly generate byte `unidentsample' = 0
		local rc = _rc
		if (`rc') {
			display as error "option" ///
				" {bf:unidentsample()} specified incorrectly;" 
			generate byte `unidentsample' = 0
		}
	}
	
	// Parsing the generate option

	tempvar  yhat ehat ehat2 sigma fden flhs selhs gradiente ///
		 dsigma lowbound uppbound


	if (`yesrhs') {
		local dvars2 "`disc0'"
		local dvars2: list uniq dvars2
		local forgen "`disc0'"
	}
	else {
		local dvars2 "`dvars'"
	}

	GeNeRaTiOn if `touse' `wgt', generate(`predijo') 		///
		gradient(`grad') lhs(`lhs') cvars(`cvars') 		///
		dvars(`dvars2') cdnum(`cdnum') base(`baselevel')	///
		forgen(`forgen') elmargen(`elmargen') pdydx(`pdydx')	///
		quieto(`quieto6')

	local namey   = "`s(name1)'"
	local namese  = "`s(name2)'" 
	local label1  = "`s(label1)'"
	local label2  = "`s(label2)'"
	local dcount  = "`s(dcount)'"
	local gradse  = "`s(gradse)'"
	local gradsed = "`s(gradsed)'"
	local gradkc = "`s(gradkc)'"
	local dvarlist    ""
	local sevarlist   ""
	local dgsevarlist ""	

	// Getting tempvars for mata function of gradients 


	if (`grad' > 0) {
		local kgrad = 0 
		if (`cdnum'==2|`cdnum'==3) {
			tempname gbase
			local kbase = rowsof(`basevals')
			matrix `gbase' = J(1,`kbase', 0)
			if (`cdnum'==2) {
				local kgrad: list sizeof gradse
				local k = `dcount'
			}
			else{
				local kgrad: list sizeof gradsed
				local k = `dcount'		
			}
			local gradsen "" 
			local condxg  ""
			local prein  ""
			forvalues i = 1/`kgrad' {
				tempvar gradse`i' cgx`i' prein`i'
				qui generate double `gradse`i'' = . if `touse'
				qui generate double `cgx`i'' = . if `touse'
				qui generate double `prein`i'' = . if `touse'
				local gradsen "`gradsen' `gradse`i''"	
				local condxg  "`condxg' `cgx`i''"
				local prein  "`prein' `prein`i''"
			}
		}
		forvalues i=1/`k' {
			tempvar d`i' se`i' dgse`i' 
			quietly generate double `d`i''   = . if `touse'
			quietly generate double `se`i''  = . if `touse'
			quietly generate double `dgse`i''   = . if `touse'
			local dvarlist    "`dvarlist' `d`i''"
			local sevarlist   "`sevarlist' `se`i''"
			local dgsevarlist "`dgsevarlist' `dgse`i''"
		}
		local kderiv = `k'
		quietly generate double `dsigma' = .  if `touse'
		local kgen = `k'
	}

	// Generating variables for estimation and getting bandwidth_0
	
	local k: list sizeof allvars
	
	// Kernel option 

	_d_kernel_parse, dkernel(`dkernel') kernel(`kernel') cdnum(`cdnum')
	local dkernel = "`r(dkernel)'"

	KeRnElParSe, `kernel' cdnum(`cdnum') dkernel(`dkernel')
	local ke    = r(knumber)
	local kname = "`r(kname)'"

	// Bandwidth selection method
	
	local aicm = 0 
	local optimizer "cross validation"

	if "`imaic'"!="" {
		local aicm = 1 
		local optimizer "improved AIC"
	}

	scalar `rdos' = .

	if (`logvar'==0) {
		display ""
		display as text "Computing mean function" 
	}
	
	local cellnum = 0 
	
	if ("`dkernel'"=="cellmeans") {
		local cellnum = 1 
	}
	
	quietly generate byte `naranjas'    = 1
	quietly count if `naranjas'==1
	local nnj = r(N)
	quietly generate double `yhat' = . if `touse'
	quietly generate double `sigma' = . if `touse'
	
	scalar converge1 = 0 
	scalar converge2 = 0  
	scalar converge3 = 0 
	matrix `ilog1'   = J(1, 20, 0)
	matrix `ilog2'   = J(1, 20, 0)
	matrix `ilog3'   = J(1, 20, 0)
	matrix `hinn'    = `hin'

	mata: _kernel_regression(`ke', "`cvars'", "`dvars'",	///
	"`lhs'", "`kest'", "`yhat'", `fixed', "`hin'", `aicm', 	///
	`cdnum', `logvar', "`rdos'", `dificil', `tolerance',	///
	`ltolerance', `iterate', `track', `show', `nmsdelta',	///
	 `cellnum', "`newwgt'", "`naranjas'", "converge1", 	///
	 "`ilog1'", "`touse'")

	summarize `touse', meanonly 
	local bt0 = r(mean)
	quietly replace `touse' = `touse'*`naranjas'
	summarize `touse', meanonly 
	local bt1 = r(mean)
	local ntwo = 0 
	
	if (float(`bt1')!=float(`bt0')) {
		local ntwo = 1 
		matrix `hinn' = `hin'
		quietly {
			mata: _kernel_regression(`ke', "`cvars'", 	///
			"`dvars'", "`lhs'", "`kest'", "`yhat'", 	///
			1, "`hinn'", `aicm', `cdnum', `logvar',		///
			"`rdos'", `dificil', `tolerance', `ltolerance',	///
			 `iterate', `track', `show', `nmsdelta',	///
			 `cellnum', "`newwgt'", "`naranjas'", 		///
			 "converge1", "`ilog1'", "`touse'")
		 }
	}
						
	quietly count if `naranjas'==1
	local nnj2 = r(N)
	quietly summarize `lhs' if `touse' `wgt'
	local N = r(N)
	local r2 = `rdos'
	
	// noidsample 
	
	summarize `naranjas', meanonly 
	local nnn = r(mean)
	
	if ("`unidentsample'"!="" & `nnj'!=`nnj2') {
		quietly replace `unidentsample' = abs(1-`naranjas')
		quietly count if `unidentsample' == 1	
		label var `unidentsample' "1 if no identification 0 otherwise"
		local nnj3 = r(N)
		if `nnj3'>1 {
			local verbo "observations were"
			local ellos "they"
			local quien "These observations are"
		}
		else {
			local verbo "observation was"
			local ellos "it"
			local quien "This observation is"
		}
		display ""
		di as txt "{p 0 9 2}" ///
		"warning: `nnj3' `verbo' not used to compute " ///
		"the mean function because `ellos' violated the model " ///
		 "identification assumptions. `quien' marked as 1 in "	  ///
		 "the variable {bf:`unidentsample'}.{p_end}"
	}
	if ("`unidentsample'"!="" & `nnj'==`nnj2') {
		capture drop `unidentsample'
	}
	if ("`unidentsample'"=="" & `nnj'!=`nnj2') {
		capture drop _unident_sample
		quietly generate byte _unident_sample = abs(1-`naranjas')
		quietly count if _unident_sample == 1
		label var _unident_sample "1 if no identification 0 otherwise"
		local link npregress##unidentsample:unidentsample
		local nnj3 = r(N)
		if `nnj3'>1 {
			local verbo "observations were"
			local ellos "they"
			local quien "These observations are"
		}
		else {
			local verbo "observation was"
			local ellos "it"
			local quien "This observation is"
		}
		display ""
		di as txt "{p 0 9 2}" ///
		"warning: `nnj3' `verbo' not used to compute " ///
		"the mean function because `ellos' violated the model " ///
		 "identification assumptions. `quien' marked as 1 in "	  ///
		 "the system variable _unident_sample. You may use the " ///
		 "{helpb `link'}{bf:()} option to use " ///
		 "a different variable name.{p_end}"
	}
	
	if (`nnn'==0) {
		display ""
		display as error "all observations violate identification" ///
			" condition"
		di as err "{p 4 4 2}" 
		di as smcl as err "Most likely, you have included a discrete " 
		di as smcl as err "covariate without specifying factor " 
		di as smcl as err "variable notation. {cmd:npregress}" 	
		di as smcl as err "interprets the variable to be continuous. " 
		di as smcl as err "Please " 
		di as smcl as err "use i.{it:varname} for discrete covariates."
		di as smcl as err "{p_end}"
		exit 198
	} 
	
	// bandwidths for gradients

	
	matrix `matfix' = 1
	if (`fixedgrad'== 1) {
		matrix `matfix' = `hin'
		if (`ntwo'==1) {
			matrix `matfix' = `hinn'			
		}
	}
	if (`fixedgrad'== 0 | `cdnum'==2) {
		matrix `hgradient' = `hin'
		if (`ntwo'==1) {
			matrix `hgradient' = `hinn'		
		}
	} 
	if (`grad'>0) { 
		mata: _kernel_regression_gradient(`ke', "`cvars'", 	 ///
		"`dvars'", "`lhs'", "`kest'", "`dvarlist'", "`gradsen'", ///
		"`gbase'", `fixedgrad', "`hgradient'", `cdnum', `grad',  ///
		"`hgradient'", "`basemat'", "`basevals'", "`uniqvals'",	 ///
		`logvar', `dificil', `tolerance', `ltolerance', 	///
		`iterate', `track', `show', `nmsdelta',	`cellnum', 	///
		"`newwgt'", "`matfix'", "converge3", "`ilog3'", 	///
		"`touse'") 
		matrix `bandgrad' = `hgradient'
	}

	local kp1: list sizeof dvarlist
	local kp2: list sizeof gradsen
	if (`ntwo'==1) {
		matrix `bandy'    = `hinn'
	}
	else {
		matrix `bandy'    = `hin'	
	}

	if ("`weight'"=="iweight") {
		local N = r(sum_w)
	}
	ereturn local N = `N'

	// Getting nhs 
	local khnhs: list sizeof cvars
	local nhs = 1 
	forvalues i = 1/`khnhs' {
		local nhs = `nhs'*`bandy'[1,`i']
	}

	// Displaying results
	local namey  =  substr("`namey'", 1, 32)
	quietly generate double `namey'  = `yhat' if `touse'
	quietly summarize `namey' if `touse' `wgt', meanonly
	local asf = r(mean)
	local minasf = r(min)
	local maxasf = r(max)
	label var `namey' "`label1'"	

	//  Generating gradient variables 

	local rname "Mean:`lhs'"
	local cigradnoms  ""
	local pdydxnames  ""
	local predictnoms ""

	if (`grad'> 0 & `cdnum'==1) {
		forvalues i=1/`kgen' { 
			local nnp: word `i' of `allvars'
			local x  : word `i' of `dvarlist'
			local xse: word `i' of `dgsevarlist' 
			local nombre    = substr("`s(d`i'name)'", 1, 32)
			local tnomdot "`nombre'"
			gettoken tnomdot tuno: tnomdot, parse(".")
			gettoken tuno tdos: tuno, parse(".")
			local lnombre   = "`s(labeld`i')'"
			if ("`tdos'"!="") {
				local nombre "`tnomdot'_`tdos'"
			}
			if (`pdydx') {
				quietly generate double ///
					`nombre' = `x' if `touse'
				label var `nombre' "`lnombre'" 
			}
			local predictnoms "`predictnoms' (`lnombre')"
			local rname "`rname' Effect:`nnp'"
			local cigradnoms "`cigradnoms' `nombre'"
		}
		local kpndn = `kgen'
	}
	if (`grad'> 0 & `cdnum'==2) {
		_more_striping, dvars(`repito') 
		local mnomd   = "`r(mnomd)'"
		local quietud = "`r(quietud)'"
		forvalues i=1/`kgen' { 
			local x  : word `i' of `dvarlist'
			local nombre    = substr("`s(d`i'name)'", 1, 32)
			local nombredos = "`s(d`i'contrast)'"
			local lnombre   = "`s(labeld`i')'"
			local tnomdot "`nombre'"
			local qxd : word `i' of `quietud'
			local nnp: word `i' of `mnomd'
			gettoken tnomdot tuno: tnomdot, parse(".")
			gettoken tuno tdos: tuno, parse(".")
			if ("`tdos'"!="") {
				local nombre "`tnomdot'_`tdos'"
			}
			if (`yesrhs' & "`qxd'"=="movete") {
				local nombredos "`nnp'"
				local preq "discrete change of mean function at"
				local lnombre  "`preq' `nnp'"
			}
			if (`pdydx') {
				quietly generate double ///
					`nombre' = `x' if `touse'
				*label var `nombre' "`lnombre'" 
			}
			local predictnoms "`predictnoms' (`lnombre')"
			local rname "`rname' Effect:`nombredos'"
			local cigradnoms "`cigradnoms' `nombre'"
		}
		local kpndn = `kgen' 
	}
	if (`grad'> 0 & `cdnum'==3) {
		forvalues i=1/`gradkc' { 
			local x  : word `i' of `dvarlist'
			local xse: word `i' of `dgsevarlist' 
			local nnp: word `i' of `allvars'
			local nombre    = substr("`s(d`i'namec)'", 1, 32)
			local lnombre   = "`s(labelc`i')'"
			local tnomdot "`nombre'"
			gettoken tnomdot tuno: tnomdot, parse(".")
			gettoken tuno tdos: tuno, parse(".")
			if ("`tdos'"!="") {
				local nombre "`tnomdot'_`tdos'"
			}
			if (`pdydx') {
				quietly generate double ///
					`nombre' = `x' if `touse'
				label var `nombre' "`lnombre'" 
			}
			local predictnoms "`predictnoms' (`lnombre')"
			local counter = `i' + 1
			local rname "`rname' Effect:`nnp'"
			local cigradnoms "`cigradnoms' `nombre'"
		}
		
		local kgen  = `kgen'-1
		local kfin  = wordcount("`dvarlist'")
		local kprin = `gradkc' + 1
		forvalues j =`kprin'/`kfin' { 
			local jl = `j' - `kprin' + 1 
			local x  : word `j' of `dvarlist'
			_more_striping, dvars(`repito') 
			local mnomd   = "`r(mnomd)'"
			local quietud = "`r(quietud)'"
			local qxd : word `jl' of `quietud'
			local nnp: word `jl' of `mnomd'
			local nombre    = substr("`s(d`jl'name)'", 1, 32)
			if (`yesrhs' & "`qxd'"=="movete") {
				local nombredos "`nnp'"
				local preq "discrete change of mean function at"
				local lnombre  "`preq' `nnp'"
			}
			else {
				local nombredos = "`s(d`jl'contrast)'"
				local lnombre   = "`s(labeld`jl')'"
			}
			local tnomdot "`nombre'"
			gettoken tnomdot tuno: tnomdot, parse(".")
			gettoken tuno tdos: tuno, parse(".")
			if ("`tdos'"!="") {
				local nombre "`tnomdot'_`tdos'"
			}
			if (`pdydx') {
				quietly generate double ///
					`nombre' = `x' if `touse'
				label var `nombre' "`lnombre'" 
			}
			local predictnoms "`predictnoms' (`lnombre')"
			local rname "`rname' Effect:`nombredos'"	
			local cigradnoms "`cigradnoms' `nombre'"
		}
		local kpndn = `gradkc' + `kfin' - 1 
	}	

	// Stripes for the coefficient table 

	StRiPeS_mat, allvars(`allvars') first(`rname') 		///
		     gradient(`grad') cvars(`cvars') orig(`origins')

	local rownames    = "`s(rownames)'"
	local newrownames = "`s(newrownames)'"
	local stbwmean    = "`s(stbwmean)'"
 	local stbderiv    = "`s(stbderiv)'"

	// Returning results 

	TaBlEnAtOr if `touse' `wgt', sevars(`cigradnomse') asf(`namey')	///
		    rnames(`rname') bandy(`bandy') 	///
		    bandg(`bandgrad') allvars(`allvars') cdnum(`cdnum') ///
		    dvars(`dvars') gradient(`grad') gradvars(`dvarlist')
			    
	matrix `b'  = r(awesome)
	local  ktab = r(ktab)
	matrix `V' = J(colsof(`b'), colsof(`b'), 0)
	matrix colnames `b' = `newrownames'
	matrix rownames `V' = `newrownames'
	matrix colnames `V' = `newrownames'
	
	// Bandwidth with cellnum 
	
	if ("`cellmean'"!="") {
		forvalues i=1/`k' {
			local cell1: word `i' of `allvars'
			local cell2: list dvars & cell1
			if ("`cell2'"!="") {
				matrix `bandy'[1,`i']     = 0 
				matrix `hgradient'[1,`i'] = 0 
			}
		}
	}

	// Bandwidth return 
	
	tempname pbandy pbandse phgradient mattable hagain
	
	matrix `pbandy'             = `bandy'
	if ("`sind'"=="") {
		matrix `phgradient'         = `hgradient'
		matrix `hagain'             = `bandy', `hgradient'
	}
	else {
		matrix `hagain'             = `bandy'
	}
	
	tempname bandy3 hgradient3
	_mat_mkvec_stripe, vars("`origins'") mean 
	local colsnoms1 = "`r(_mk_vec_str)'"
	_mat_mkvec_stripe, vars("`allvars'") mean 
	local colsnoms2 = "`r(_mk_vec_str)'"
	matrix colnames `bandy' = `colsnoms2'
	if ("`sind'"=="") {
		_mat_mkvec_stripe, vars("`origins'") deriv
		local colsnoms5 = "`r(_mk_vec_str)'"
		_mat_mkvec_stripe, vars("`allvars'") deriv
		local colsnoms6 = "`r(_mk_vec_str)'"
		matrix colnames `hgradient' = `colsnoms6'
		_mkvec `hgradient3', from(`hgradient') colnames(`colsnoms5')
	}
	_mkvec `bandy3', from(`bandy') colnames(`colsnoms1')
	tempname mattablenew
	if (`grad') {
		matrix `mattable'  = `bandy3'', `hgradient3''
		local cols = colsof(`mattable')
		local rows = rowsof(`mattable')
		matrix `mattablenew' = J(`rows', `cols', 0)
		mata: st_matrix("`mattablenew'", ///
			st_matrix("`mattable'")[1..`rows', 1..`cols'])
		matrix colnames `mattablenew'  = Mean Effect
		matrix rownames `mattablenew'  = `origins'
	}
	else {
		matrix `mattable'  = `bandy3''
		local cols = colsof(`mattable')
		local rows = rowsof(`mattable')
		matrix `mattablenew' = J(`rows', `cols', 0)
		mata: st_matrix("`mattablenew'", ///
			st_matrix("`mattable'")[1..`rows', 1..`cols'])
		matrix colnames `mattablenew'  = Mean
		matrix rownames `mattablenew'  = `origins'			
	}
	if ("`sind'"=="") {
		matrix `htablefin' = `bandy3', `hgradient3'
	}
	else {
		matrix `htablefin' = `bandy3'
	}
	*matrix colnames `htablefin' = `colsnoms'
	
	// Displaying generated variables 
	
	if (`pdydx'==0|`grad'==0) {
		quietly capture drop `cigradnoms' 
		local sinvars = 1 
	}

	if ("`namey'"=="__npreg__pre1") {
		local sinvars = 1 	
	}
	if ("`elnombredey'"!="") {
		local namey "`elnombredey'"
		capture replace `namey' = __npreg__pre1
		local rc = _rc
		if (`rc') {
			quietly generate double `namey' = __npreg__pre1
			label var `namey' "mean function"
		}
	}
	// Returning results 
	
	ereturn post `b', esample(`touse') obs(`N') ///
		findomitted dep(`lhs') buildfvinfo
		
	_post_vce_rank, checksize
	
	// Data signature  
	
	if (`sinvars'==1 & "`elnombredey'"!="") {
		quietly signestimationsample `lhs' `origins' 
	}
	else {
		quietly signestimationsample `lhs' `origins' `namey'
	}
	
	// Names for margins
	if (`yesrhs'==0) {
		_for_margins_stripe, origin(`varlist') nuevas(`allvars')
	}
	else {
		_for_margins_stripe, origin(`nameold2') nuevas(`allvars')	
	}
	local mimargen    = "`s(mimargen)'"
	
	// rzero 
	
	local rhcero: list rhcero & rhs
	
	// Return predictions
	
	if ("`coeflegend'"!="") {
		ereturn hidden scalar legend = 1
	} 
	else {
		ereturn hidden scalar legend = 0
	}
	
	if (`grad'>0) {
		ereturn scalar converged = converge1*converge3
		ereturn scalar converged_effect = converge3
		ereturn matrix ilog_effect = `ilog3'
		ereturn matrix ilog_mean   = `ilog1'
	}
	else {
		ereturn scalar converged = converge1
		ereturn matrix ilog_mean   = `ilog1'
	}
	ereturn scalar converged_mean   = converge1
	ereturn scalar mean   = `asf' 
	ereturn matrix meanbwidth    = `bandy3'
	if ("`sind'"=="") {
		ereturn matrix derivbwidth = `hgradient3'
		ereturn hidden matrix pbandwidthgrad = `phgradient'
	}
	ereturn hidden matrix pbandwidths    = `pbandy'
	ereturn hidden matrix bandtable = `mattablenew'
	ereturn hidden matrix hagain = `hagain'
	ereturn hidden matrix matsigmg = `matsigmg'
	ereturn hidden matrix nchk = `nchk'
	if (`cdnum'!=2) {
		ereturn local kname  = "`kname'"
	}
	ereturn local dkname = "`dkernel'"
	ereturn hidden local margins_cmd margins4npregress
	ereturn local cmd "npregress"
	ereturn local cmdline npregress `0'
	ereturn local bselector = "`optimizer'"
	ereturn hidden local cellnum = `cellnum'
	ereturn hidden local allfix  = `allfix'
	ereturn hidden local yname  "`namey'"
	ereturn hidden scalar degree = `degree'
	ereturn hidden local xnum    = `k'
	ereturn hidden local ke      = `ke'
	ereturn hidden local predijo = "`predijo'"
	ereturn hidden local predice = `predice'
	ereturn hidden local kgrad   = `kgrad'
	ereturn hidden local kderiv  = `kderiv'
	ereturn hidden local rhs "`rhs'"
	ereturn hidden local allvars "`allvars'"
	ereturn hidden local quieto "`quieto3'"
	ereturn hidden local quieto2 "`quieto4'"
	ereturn hidden local quieto3 "`quieto'"
	if (`yesrhs') {
		ereturn hidden local dvars "`dvars2'"
	}
	else {
		ereturn hidden local dvars "`dvars'"
	}
	ereturn hidden local cvars "`cvars'"
	ereturn local marginsok "default"
	ereturn local marginsprop "nochainrule"
	ereturn hidden local cigradnoms "`cigradnoms'"
	ereturn hidden matrix basecon  = `basecont' 
	ereturn hidden matrix basedisc = `basedisc' 
	ereturn hidden local variables  = "`mimargen'"
	ereturn hidden local scitipo "`scitipo'"
	ereturn hidden scalar kp1  = `kp1'
	ereturn hidden scalar kp2  = `kp2'
	ereturn hidden local sinvars = `sinvars'
	ereturn hidden local covariates = "`mimargen'"
	ereturn hidden local repito    = "`repito'"
	ereturn hidden local repito2   = "`repito2'"
	ereturn hidden local repitoall = "`repitoall'"
	ereturn hidden local ctipo   = `citipo'
	ereturn hidden local niveles   = "`niveles'"
	ereturn hidden local yesrhs    = "`yesrhs'"
	if (`k'==1) {
		ereturn hidden local xname "`allvars'"
	}
	if (`grad'>0) {
		local kscores: list sizeof cigradnoms
		if (`kscores'==0) {
			local kscores = `kpndn'
		}
		ereturn hidden scalar kscores = `kscores'
		ereturn hidden local predictnoms = "`predictnoms'"
	}
	else {
		if ("`gradsizem'"=="") {
			ereturn hidden scalar kscores = 0
		}
		else {
			ereturn hidden scalar kscores = `gradsizem'
		}
		
	}
	ereturn hidden scalar tolerance = `tolerance'
	ereturn hidden scalar ltolerance = `ltolerance'
	ereturn hidden scalar iterate    = `iterate'
	ereturn hidden scalar nmsdelta   = `nmsdelta' 
	ereturn matrix bwidth = `htablefin'
	ereturn local estimator = "`kestnm'"
	ereturn hidden local bwrep = `bwrep'
	ereturn local title = "`klabel'"
	ereturn hidden local mggrad = `grad'
	ereturn hidden local bsnote = `bsnote'
	ereturn hidden local lhs = "`lhs'"
	ereturn hidden scalar cdnum = `cdnum'
	ereturn hidden scalar ktab  = `ktab'
	ereturn hidden scalar nivel = `level'
	ereturn local estat_cmd npregress_kernel_estat
	ereturn scalar nh           = min(round(`nhs'*`N'), `N')
	ereturn hidden scalar nhreal = `nhs'*`N'
	ereturn scalar r2 = `r2'
	ereturn hidden local rhzero = "`rhcero'"
	ereturn hidden matrix basemat  = `basemat'
	ereturn hidden matrix basevals = `basevals'
	ereturn hidden matrix uniqvals = `uniqvals'
	ereturn hidden scalar aicm     = `aicm'
	ereturn local predict "npregress_kernel_p"
	ereturn hidden local vcetype = "None"
        ereturn local vce     = "none"
	ereturn hidden local kest   = "`kest'"
	ereturn hidden local kestnm = "`kestnm'"
	ereturn local wexp "`exp'"
	ereturn local wtype "`weight'"
	Display, `diopts' level(`level') 

end 

 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 /////////////////////////////// SUBROUTINES ///////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
  
program define Display
        syntax [, * CITYPE1(string)]
	
	_get_diopts diopts other, `options'        
        if "`other'"!=""{
                display "{err}option {bf:`other'} not allowed"
                exit 198
        }
          
	tempname A res H
	matrix `res' = e(results)
	local citipo = e(ctipo)
	if ("`citype1'"!="") {
		_ci_type, `citype1'
		local citipo = r(citipo)
	}
	matrix `A'   = e(htable)
	matrix `H'   = e(bandtable) 
	local vcet   "`e(vcetype)'"
	local cdnum  = e(cdnum)
	local allfix = e(allfix)
	local bsnote = e(bsnote)
	local celln  = e(cellnum)
	local ktab   = e(ktab)
	local r2     = e(r2)
	local kname  =  "`e(kname)'"
	local klabel = "`e(title)'"
	local bwsel  = "`e(bselector)'"
	local level  = e(nivel)
	local N      = e(N)
	local nh     = e(nh)
	
	display ""
	display as text "Bandwidth" _continue
	matlist `H', border(rows) aligncolnames(ralign) 
	if (`allfix'> 0 & `cdnum'>1) {
		di as txt "{p 0 6 2}" ///
		"Note: Effect bandwidths for discrete covariates"	///
		 " are the same as mean bandwidths.{p_end}"
	}
	di ""
	di as text "`klabel' " 		///
		as text _col(44) "Number of obs      =  "	///
		as result %13.0gc `N'
	if (`cdnum'==3) {
		noi display as text _continue ///
			"Continuous kernel : {result:`kname'}"
		noi display as text _col(43)  ///
		"{help n_npe_note##|_new: E(Kernel obs)}      =  "  ///
		as result %13.0gc `nh'
		if (`e(cellnum)'==0) {
			noi display as text _continue ///
			"Discrete kernel   : {result:liracine}"
		}
		else {
			noi display as text _continue ///
			"Discrete kernel   : {result:cell means}"		
		}
		noi display as text _col(44)  "R-squared          =  "  ///
		as result %13.4f `r2'
		noi display as text "Bandwidth         : {res:`bwsel'}"
	}
	if (`cdnum'==1) {
		noi display as text _continue "Kernel   : {result:`kname'}"
		noi display as text _col(43)  ///
		"{help n_npe_note##|_new: E(Kernel obs)}      =  "  ///
		as result %13.0gc `nh'
		noi display as text _continue	///
			"Bandwidth: {res:`bwsel'}"
		noi display as text _col(44)  "R-squared          =  "  ///
		as result %13.4f `r2'
	}
	if (`cdnum'==2) {
		if (`e(cellnum)'==0) {
			noi display as text _continue ///
			"Kernel   : {result:liracine}"
		}
		else {
			noi display as text _continue ///
			"Kernel   : {result:cell means}"		
		}
		noi display as text _col(44)  "R-squared          =  "  ///
		as result %13.4f `r2'		
		noi display as text "Bandwidth: {res:`bwsel'}"
	}
	
	local prefix = c(prefix)
	local isjackknife : list posof "jackknife" in prefix
	
	if ("`e(V)'" == "matrix" & !`isjackknife') {
		if (`citipo'==1) {
			local cmat "e(ci_percentile)"
			local ctit "Percentile"
		}
		if (`citipo'==2) {
			local cmat "e(ci_normal)"
			local ctit "Normal-based"
		}
		if (`citipo'==3) {
			local cmat "e(ci_bc)"
			local ctit "Bias-corrected"
		}
		local extra cimatrix(`cmat') cititle("`ctit'")
	}
	_coef_table, `diopts'  coeftitle("Estimate") `extra'
	
	if (`cdnum'==1) {
		di as txt "{p 0 6 2}" ///
		"Note: Effect estimates are averages of derivatives.{p_end}"
	}
	if (`cdnum'==2) {
		di as txt "{p 0 6 2}" ///
		"Note: Effect estimates are averages of contrasts of"	///
		 " factor covariates.{p_end}"
	}
	if (`cdnum'==3) {
		di as txt "{p 0 6 2}" ///
		"Note: Effect estimates are averages of derivatives for " ///
		"continuous covariates and averages of contrasts for "	  ///
		"factor covariates.{p_end}"	
	}
	if (`bsnote'==1) {
		di as txt "{p 0 6 2}" ///
		"Note: You may compute standard errors using" ///
		"{res: vce(bootstrap)} or {res:reps()}.{p_end}"	
	}
	ml_footnote
end

program define Display_series
        syntax [, bmatrix(passthru) vmatrix(passthru) noTABle *]

        _get_diopts diopts other, `options'
        local myopts `bmatrix' `vmatrix'
        tempname B V        
        if "`other'"!=""{
                display "{err}option {bf:`other'} not allowed"
                exit 198
        }
        local r2         = e(r2)
	local r2_a       = e(r2_a)
	local titulo     = "`e(title)'"
	local bwsel      = "`e(bselector)'"
	local root       = "`e(root)'"
	local crit       = "`e(criterion)'"
	local norsq      = e(norsq)
	local fijo       = e(fijo)
	local estis      = e(estis)
	local knots      = e(knots)
	local level      = e(nivel)
	local cvars      = "`e(cvars)'"
	local N          = e(N)      
	local order      = e(order)
	local comparison = e(comparison)
	local criterion  = e(ll)
	
	if (`fijo'==0) {
		local dcr ///
		`"noi display as text _continue "Criterion: {res:`crit'}""'	
	}
	else {
		local dcr display _continue
	}
	
	if (`estis'>1) {
		local root "Number of knots "
		local order = `knots'  
		if ("`cvars'"=="") {
			local order = 0 
		}
	}
	
        display ""
	di as text "`titulo' " 		///
		as text _col(44) "Number of obs      =  "	///
		as result %13.0gc `N'
		`dcr'
		if (`order'>0) {
			noi display as text _col(44)  "`root'   =  "  ///
			as result %13.0f `order'
		}
		if (`norsq'==0) {
			noi display as text ///
				_col(44)  "R-squared          =  "  ///
			as result %13.4f `r2'
			if (e(ll)!=.) {
				di as txt "`crit' = " as ///
				res %10.0g e(ll) as ///
				txt _col(44) ///
				"Adj R-squared" _col(62) " =  " as res ///
				%13.4f `r2_a'
			}
			else {
				di as txt _col(44) ///
				"Adj R-squared" _col(62) " =  " as ///
				res %13.4f `r2_a'		
			}
		}
	if ("`table'"=="") {
		_coef_table,  `diopts' `myopts' coeftitle("Effect") 
	}
        ml_footnote
end

program CheckEstimator, sclass
        args input

        if ("`input'" == "kernel") {
                sreturn local estimator "kernel"
                exit
        }
        
        if ("`input'" == "series") {
                sreturn local estimator "series"
                exit
        }
	
        display as error "{bf:`input'} not a valid estimator"
	di as err "{p 4 4 2}" 
	di as smcl as err "The correct syntax is {bf:npregress}" 
	di as smcl as err " {bf:kernel} {it:depvar} {it:indepvars}" 
	di as smcl as err "or {bf:npregress} {bf:series} {it:depvar}"
	di as smcl as err " {it:indepvars}. " 
	di as smcl as err "You forgot to type the word {bf:kernel} or" 	
	di as smcl as err " {bf:series} after {bf:npregress}." 
	di as smcl as err "{p_end}"
	exit 198
                
end

program Check4Options, sclass
        syntax, [opcion(string)]
	
	local lista "kernel bwidth bwidthse nolog notable aicm noheader"
	local inter: list opcion - lista
	local error: word 1 of `inter'
	if "`inter'"!="" {
		display as error "option {bf:`error'} not allowed"
		exit 198
	}

end

program _varlistcheck, rclass
	syntax [if] [in] [fw pw iw], [variables(string) yesrhs(integer 0)]
	marksample touse 
	tempname A B
	if "`weight'" != "" {
                local wgt "[`weight'`exp']"
        }
	
	if (`yesrhs'==0) {
		local 0 "`variables'"
		syntax varlist(fv)
		local variables "`varlist'"
	}
	
	local k : word count `variables'
	local varsnew0 ""
	matrix `A' = 0
	forvalues i=1/`k' {
		local x: word  `i' of `variables'
		cap _ms_parse_parts `x'
		local rc   = _rc 
		local voy  = 0
		if (`rc'==0) {
			local type  = r(type)
			local name  = r(name)
			local base  = r(base)
			local level = r(level)
			if ("`type'"=="factor") {
				matrix `A' = `A', `level', `level'
				local voy = 1
			}
			if ("`type'"=="variable") {
				matrix `A' = `A', -1
			}
		}
		else {
			fvexpand `x'
			local kv = r(varlist)
			local b: list sizeof kv
			matrix `B' = J(1, `b', -1) 
			matrix `A' = `A', `B'
		}
	}

	matrix `A' = `A'[1, 2..colsof(`A')]
	quietly _rmcoll `variables' `wgt' if `touse'
	local varsnew = r(varlist)
	fvexpand `varsnew' if `touse'
	local vars = r(varlist)
	return local vars = "`vars'" 
	return matrix A   = `A'
	return local voy  = "`voy'"
end 

program GeNeRaTiOn, sclass
	syntax [if] [in] [fw pw iw], [lhs(string) 		///
					generate(string) 	///
					gradient(real 0)	///
					cvars(string)		///
					dvars(string)		///
					cdnum(integer 1)	///
					base(string)		///
					forgen(string)		///
					elmargen(integer 0)	///
					pdydx(integer 1)	///
					quieto(string)		///
					]
						
	local prefix = c(prefix)
	local isbootstrap : list posof "bootstrap" in prefix
	local isloop      : list posof "_loop"     in prefix
		
	if (`gradient'==0 & "`generate'"!="") {
		local cadena `generate'
		gettoken vars cadena: cadena, parse(,)
		gettoken cadena tipo: cadena, parse(,)
		if ("`tipo'"==" replace"|(`isbootstrap' & `isloop')) {
			local aster1 `vars'
			gettoken aster1 aster: aster1, parse(*)
			if "`aster'"!="" {
				capture drop `aster1'1 
			}
			else { 
				capture drop `aster1'
			}
		}
		if ("`vars'"==",") {
			display as error ///
				"option {bf:predict()} incorrectly specified"
			 exit 198
		}
		if ("`tipo'"!=" replace" & "`tipo'"!="") {
			display as error ///
				"option {bf:predict()} incorrectly specified"
			di as err "{p 4 4 2}" 
			di as smcl as err "unrecognized option {bf:`tipo'}" 
			di as smcl as err "{p_end}"
			 exit 198
		}
		capture quietly _stubstar2names `vars', nvars(1)
		local rc = _rc 
		if `rc'>0 {
			display as error ///
			"option {bf:predict()} specified incorrectly; " _c
			_stubstar2names `vars', nvars(1)
		}
		local varlist "`s(varlist)'"
		local name1: word 1 of `varlist'
		sreturn local name1  = "`name1'" 
	}
	if (`gradient'==0 & "`generate'"=="") {
		sreturn local name1  = "_Mean_`lhs'" 
		capture drop _Mean_`lhs' 
		capture drop *_Mean_*
	}
	if (`gradient'>0  & "`generate'"=="") {
		if (`cdnum'==1) {
			local k : word count `cvars'
		}
		if (`cdnum'==2) {
			local k1: word count `dvars'
		}
		if (`cdnum'==3) {
			local kd1: word count `dvars'
			local kc1: word count `cvars'
			local kd = 0
			local kc = `kc1'
			forvalues i = 1/`kd1' {
				local dk : word `i' of `dvars'
				cap quietly tab `dk'
				local rc = _rc
				if (`rc') {
					tempvar night
					quietly generate `night' = `dk'
					quietly tab `night'
				}
				local kd = `kd' + (r(r) - 1)
			}
			local k = `kd' + `kc'
		}	
		if (`cdnum'==1) {
			local nomcontador ""
			forvalues i=1/`k' {
				local x: word `i' of `cvars'
				sreturn local d`i'name  = "_d_Mean_`lhs'_d`x'"
				local nomcontador ///
					"`nomcontador' _d_Mean_`lhs'_d`x'"
				local clause derivative of mean function
				sreturn local labeld`i' = "`clause' w.r.t `x'"
				capture drop _d_Mean_* 
			}
			_my_contador_dydx, nom("`nomcontador'")
		}
		if (`cdnum'==2) { 
			DiSGrAdNaMeS `dvars', base(`base') lhs(`lhs')	///
				      k(`k1') forgen(`forgen') 		///
				      quieto(`quieto')
		}
		if (`cdnum'==3) {
			ThReENaMeS, dvars(`dvars') cvars(`cvars') ///
				    lhs(`lhs') base(`base') 	  ///
				   forgen(`forgen') quieto(`quieto')
		}
		capture drop _Mean_`lhs' 
		capture drop _se_Mean_`lhs'
		sreturn local name1  = "_Mean_`lhs'" 
		sreturn local name2  = "_se_Mean_`lhs'"
		sreturn local gradse = "`s(gradse)'"
		capture drop _Mean_`lhs' 
		capture drop _se_Mean_`lhs'
	}
	if (`gradient'>0 & "`generate'"!="") {
		if (`elmargen'==0) {
			capture drop *_Mean_*
		}
		else {
			capture drop d_Mean*
			local cadena `generate'
			gettoken vars cadena: cadena, parse(,)
			gettoken cadena tipo: cadena, parse(,)
		}
		if (`cdnum'==1) {
			local k2 : word count `cvars'
			local k = `k2'*`pdydx' + 1
		}
		if (`cdnum'==2) {
			local k1: word count `dvars'
			local k = 0
			forvalues i = 1/`k1' {
				local dk : word `i' of `dvars'
				cap quietly tab `dk'
				local rc = _rc
				if (`rc') {
					tempvar night
					quietly generate `night' = `dk'
					quietly tab `night'
				}
				local k = `k' + (r(r) - 1)
			}
			local k = `k'*`pdydx' + 1
		}
		if (`cdnum'==3) {
			local kd1: word count `dvars'
			local kc: word count `cvars'
			local kd = 0
			forvalues i = 1/`kd1' {
				local dk : word `i' of `dvars'
				cap quietly tab `dk'
				local rc = _rc
				if (`rc') {
					tempvar night
					quietly generate `night' = `dk'
					quietly tab `night'
				}
				local kd = `kd' + (r(r) - 1)
			}
			local k = `kd'*`pdydx' + `kc'*`pdydx' + 1
		}
		local cadena `generate'
		gettoken vars cadena: cadena, parse(,)
		gettoken cadena tipo: cadena, parse(,)
		if ("`tipo'"==" replace"|(`isbootstrap' & `isloop')) {
			local aster1 `vars'
			gettoken aster1 aster: aster1, parse(*)
			if "`aster'"!="" {
				capture drop `aster1'*
			}
			else {
				local kfd: list sizeof aster1
				forvalues i=1/`kfd' {
					local xd: word `i' of `aster1'
					capture drop `xd'
				}
			}
		}
		if ("`vars'"==",") {
			display as error ///
				"option {bf:predict()} " ///
				"incorrectly specified"
			 exit 198
		}
		if ("`tipo'"!=" replace" & "`tipo'"!="") {
			display as error ///
				"option {bf:predict()} incorrectly" ///
				" specified"
			di as err "{p 4 4 2}" 
			di as smcl as err "unrecognized option "
			di as smcl as err "{bf:`tipo'}" 
			di as smcl as err "{p_end}"
			 exit 198
		}
		capture _stubstar2names `vars', nvars(`k')
		local rc = _rc 
		if `rc'==102 {
			display as error ///
				"too few variables specified with " ///
				"{bf:predict()}"
			di as err "{p 4 4 2}" 
			di as smcl as err "There should be a variable"
			di as smcl as err " name for the mean"
			di as smcl as err " function"
			di as smcl as err " and for the derivatives"
			di as smcl as err " of the mean function."
			di as smcl as err "{p_end}"
			 exit 102			
		}
		if `rc'==103 {
			display as error ///
				"too many variables specified with " ///
				"{bf:predict()}"
			di as err "{p 4 4 2}" 
			di as smcl as err "There should be a variable"
			di as smcl as err " name for the mean " 
			di as smcl as err " function and for"
			di as smcl as err " the derivatives"
			di as smcl as err " of the mean function."
			di as smcl as err "{p_end}"
			 exit 103			
		}
		if `rc'>0 {
			display as error ///
		   "option {bf:predict()} specified incorrectly; " _c
			_stubstar2names `vars', nvars(`k') nosubcommand
		}
		local varlist "`s(varlist)'"
		local name1: word 1 of `varlist'

		if (`cdnum'==1) {
			local j = 1 
			local l = 1 
			forvalues i=2/`k' {
				local x: word `i' of `varlist'
				local z: word `j' of `cvars'
				sreturn local d`j'name  = "`x'"
				sreturn local labeld`j' = ///
			    "derivative of mean function w.r.t `z'"
				local j = `j' + 1
			}
		}
		if (`cdnum'==2) {
			DiSGrAdNaMeS `dvars', base(`base') lhs(`lhs')	///
				k(`k1') generates forgen(`forgen')	///
				quieto(`quieto')
			sreturn local gradse = "`s(gradse)'"
			local j = 1 
			forvalues i=2/`k' {
				local x: word `i' of `varlist'
				local z: word `j' of `dvars'
				sreturn local d`j'name  = "`x'"
				local j = `j' + 1
			}
		}
		if (`cdnum'==3) {
			ThReENaMeS, dvars(`dvars') cvars(`cvars')	///
				    lhs(`lhs') base(`base') generates	///
				    forgen(`forgen')  quieto(`quieto')
			sreturn local gradse = "`s(gradse)'"
			local gkc  = "`s(gradkc)'"
			local kc   = `gkc' + 1
			local j = 1 
			forvalues i=2/`kc' {
				local x: word `i' of `varlist'
				sreturn local d`j'namec  = "`x'"
				local j = `j' + 1
			}
			local s0 = `kc'+1
			local j  = 1 
			forvalues i=`s0'/`k' {
				local x: word `i' of `varlist'
				sreturn local d`j'name  = "`x'"
				local j = `j' + 1
			}
		}
		sreturn local name1  = "`name1'" 
		sreturn local name2  = "`name2'"
	}

	local label1 mean function
	local label2 mean function standard errors
	sreturn local label1 = "`label1'"
	sreturn local label2 = "`label2'"
end 

program KeRnElParSe, rclass
	syntax, [EPanechnikov epan2 BIweight COSine GAUssian PARzen ///
		RECtangle TRIangle TRIWeight cdnum(integer 1) dkernel(string)]
	
	local kern1 `gaussian' `epanechnikov' `epan2' `rectangle' `triangle'
	local kern2 `parzen' `biweight' `cosine' `triweight' 
	local kern `kern1' `kern2'
	local comp1 gaussian epanechnikov epan2 rectangle triangle
	local comp2 parzen biweight cosine triweight 
	local comp `comp1' `comp2'
	
	forvalues i = 1/9 {
		if `i'<3 {
			local j = `i'
		}
		else {
			local j = `i' + 2
		}
		local y: word  `i' of `comp'
		if "`y'"=="`kern'" {
			local knumber = `j'
			local kname   = "`kern'"
		}
	}
	if "`kern'"=="" {
		local knumber = 2
		local kname   = "epanechnikov"
	}
	if ("`dkernel'"=="liracine" & `cdnum'==2) {
		local knumber = 3
	}
	if ("`dkernel'"=="cellmean" & `cdnum'==2) {
		local knumber = 14
	}
	return local knumber = `knumber'
	return local kname   = "`kname'"
end 

program BaNdWiThPaRsE, rclass
	syntax, BWidth(string) [columna(integer 1) se(integer 0)	///
		cdnum(integer 1) bscont(string) bsdisc(string) 		///
		grad(integer 0)	from(integer 0) allb(integer 0)		///
		colnames(string) cambia(integer 0)]
	
	tempname hmat hinfd hinfc bsc bsd sinozero sinozero1
	
	local opcion bwidth()
	if (`from'==1) {
		local opcion from()
	}
	if (`se'==1) {
		local opcion sebwidth()
	}
	if (`grad'==1) {
		local opcion derivbwidth()	
	}
	
	// Checking problems  

	
	capture _mkvec `hmat', from("`bwidth'") colnames("`colnames'")
	local rc = _rc
	
	if (`rc') {
		di as error "{bf:`opcion'} specified incorrectly; " _c
		_mkvec `hmat', from("`bwidth'")	colnames("`colnames'")
	}
	local colcheck = colsof(`hmat')
	local ktrc = 0  
	if (`cdnum'==3) {
		matrix `sinozero1' = `bsdisc'
		matrix `sinozero' = `sinozero1', `sinozero1'
	}	
	if (`colcheck'==`columna') {
		forvalues i=1/`columna' {
			local a = `hmat'[1, `i']
			if (`cdnum'==3) {
				local an = `sinozero'[1, `i']
				if (`a'<=0 & `an'==0) {
					local ktrc = `ktrc' + 1
				}
				if (`a'< 0 & `an'==1) {
					local ktrc = `ktrc' + 1
				}
			}
			else if (`cdnum'==1){
				if (`a'<=0) {
					local ktrc = `ktrc' + 1
				}
			}
			else if (`cdnum'==2){
				if (`a'<0) {
					local ktrc = `ktrc' + 1
				}
			}
		}
	}
	
	if (`colcheck'!=`columna'| `ktrc' > 0) {
		if (`ktrc'!=`columna') {
			local colcheck = `ktrc'
		}
	        di as error "{bf:`opcion'} specified incorrectly" 
	        di as err "{p 4 4 2}" 
                di as smcl as err "You must specify" 
                di as smcl as err " numbers greater than zero for continuous"
		di as smcl as err " covariates "
		di as smcl as err " and greater than or equal to zero for"
		di as smcl as err " discrete covariates."
		di as smcl as err "{p_end}"
		exit 198
	}
	
	mata: _bwidth_error_check("`hmat'")

	return matrix hmat = `hmat'
end 

program DiSGrAdNaMeS, sclass
	syntax anything(name=nvariables) [if] [in], [base(string) ///
		lhs(string) k(int 1) generates forgen(string) 	  ///
		quieto(string)]
	tempname A 
	local d = 1 
	local gradse ""
	local varlist "`nvariables'"
	if ("`generates'"=="") {
		forvalues j = 1/`k' {
			local x  : word `j' of `varlist'
			local y  : word `j' of `base'
			local qto: word `j' of `quieto'
			local xz "`x'"
			cap quietly tab `x', matrow(`A')
			local rc = _rc
			if (`rc') {
				tempvar night
				quietly generate `night' = `x'
				quietly tab `night', matrow(`A')
				_ms_parse_parts `x'
				local mults = r(level)
				matrix `A' = `A'*`mults'
			}
			local kdvars = rowsof(`A')
	           local txa discrete change of mean function at `xz' from  
		   local txa2 discrete change of mean function at `xz'  
			local nomcontador ""
			forvalues i = 1/`kdvars' {
				tempname grad`i'`j'
				local sub = `A'[`i', 1]
				local gradse "`gradse' `grad`i'`j''"
				if (`sub'!=`y' & "`qto'"=="quieto") {
					local ddd "_d_Mean_`lhs'd`xz'_`sub'"
					local nomcontador "`nomcontador' `ddd'"
					sreturn local d`d'name = ///
						"_d_Mean_`lhs'd`xz'_`sub'"
					sreturn local d`d'contrast = ///
						"r`sub'vs`y'.`xz'"
					sreturn local sed`d'name = ///
						"_se_d_Mean_`lhs'd`xz'_`sub'"
					sreturn local labeld`d' = ///
						"`txa' `y' to `sub'"
					sreturn local selabeld`d' = ///
						"s.e. `txa' `y' to `sub'"
					capture drop _d_Mean_* 
					local d = `d' + 1
				}
				if (`sub'!=`y' & "`qto'"=="movete") {
					local ddd "_d_Mean_`lhs'd`xz'_`sub'"
					local nomcontador "`nomcontador' `ddd'"
					sreturn local d`d'name = ///
						"_d_Mean_`lhs'd`xz'_`sub'"
					sreturn local d`d'contrast = ///
						"`xz'"
					sreturn local sed`d'name = ///
						"_se_d_Mean_`lhs'd`xz'_`sub'"
					sreturn local labeld`d' = "`txa2'"
					sreturn local selabeld`d' = ///
						"s.e. `txa' `y' to `sub'"
					capture drop _d_Mean_* 
					local d = `d' + 1
				}
			}
			_my_contador_dydx, nom("`nomcontador'")	
		}
	}
	else {
		forvalues j = 1/`k' {
			local x  : word `j' of `varlist'
			local y  : word `j' of `base'
			local qto: word `j' of `quieto'
			local xz "`x'"
			cap quietly tab `x', matrow(`A')
			local rc = _rc
			if (`rc') {
				tempvar night
				quietly generate `night' = `x'
				quietly tab `night', matrow(`A')
			}
			local kdvars = rowsof(`A')
	           local txa discrete change of mean function at `xz' from  
		   local txa2 discrete change of mean function at `xz'  
			local nomcontador ""
			forvalues i = 1/`kdvars' {
				tempname grad`i'`j'
				local sub = `A'[`i', 1]
				local gradse "`gradse' `grad`i'`j''"
				if (`sub'!=`y'  & "`qto'"=="quieto") {
					sreturn local labeld`d' = ///
						"`txa' `y' to `sub'"
					sreturn local d`d'contrast = ///
						"r`sub'vs`y'.`xz'"
					sreturn local selabeld`d' = ///
						"s.e. `txa' `y' to `sub'"
					capture drop _d_Mean_* 
						
					local d = `d' + 1
				}
				if (`sub'!=`y' & "`qto'"=="movete") {
					local ddd "_d_Mean_`lhs'd`xz'_`sub'"
					local nomcontador "`nomcontador' `ddd'"
					sreturn local d`d'name = ///
						"_d_Mean_`lhs'd`xz'_`sub'"
					sreturn local d`d'contrast = ///
						"`xz'"
					sreturn local sed`d'name = ///
						"_se_d_Mean_`lhs'd`xz'_`sub'"
					sreturn local labeld`d' = "`txa2'"
					sreturn local selabeld`d' = ///
						"s.e. `txa' `y' to `sub'"
					capture drop _d_Mean_* 
					local d = `d' + 1
				}
			}
			_my_contador_dydx, nom("`nomcontador'")	
		}	
	}
	sreturn local dcount = `d' - 1
	sreturn local gradse = "`gradse'" 
end

program ThReENaMeS, sclass
	syntax [if] [in], [dvars(string) cvars(string) lhs(string) ///
			   base(string) generates forgen(string)   ///
			   quieto(string) ]

	local kd: word count `dvars'
	local kc: word count `cvars'
	DiSGrAdNaMeS `dvars', base(`base') lhs(`lhs') k(`kd') ///
			      `generates' forgen(`forgen') quieto(`quieto')
	local gradsed = "`s(gradse)'"
	local gradsec ""
	local dcount  = "`s(dcount)'"
	local txa derivative of mean function w.r.t 
	if ("`generates'"=="") {
		local nomcontador ""
		forvalues j = 1/`kc' {
			tempname gradc`j'
			local gradsec "`gradsec' `gradc`j''"
			local x: word `j' of `cvars'
			sreturn local d`j'namec   = "_d_Mean_`lhs'_d`x'"
			local nomcontador "`nomcontador' _d_Mean_`lhs'_d`x'"
			sreturn local sed`j'namec = "_se_d_Mean_`lhs'_d`x'"
			sreturn local labelc`j'  = "`txa' `x'"
			sreturn local selabelc`j' = "s.e. `txa' `x'"
			capture drop _d_Mean_* 
		}
		_my_contador_dydx, nom("`nomcontador'")	
	}
	else {
		forvalues j = 1/`kc' {
			tempname gradc`j'
			local gradsec "`gradsec' `gradc`j''"
			local x: word `j' of `cvars'
			sreturn local labelc`j'  = "`txa' `x'"
			sreturn local selabelc`j' = "s.e. `txa' `x'"
			capture drop _d_Mean_* 
		}	
	}
	local gradse          = "`gradsec' `gradsed'"
	sreturn local gradse  = "`gradse'" 
	sreturn local gradsed = "`gradsed'"
	sreturn local gradkc  = "`kc'"
	sreturn local dcount  = `kc' + `dcount'
end

program StRiPeS_mat, sclass
	syntax, [allvars(string) first(string) gradient(integer 1)	////
		 cvars(string) orig(string) yesrhs(integer 0) ]

	local k: word count `allvars'
	local k2: word count `cvars'
	local gradname   ""
	local sfname     ""
	local stbwmean   ""
	local stbwmeanse ""
	local stbderiv   ""
	if `gradient'>0 {
		forvalues i=1/`k' {
			local x: word `i' of `allvars'
			local w: word `i' of `orig'
			local sfname `"`sfname' Mean_bwidth:`x'"'
			local stbwmean `"`stbwmean' mean:`w'"'
			local stbderiv `"`stbderiv' Effect:`w'"'
		}
		forvalues i=1/`k2' {
			local x: word `i' of `cvars'
			local gradname `"`gradname' dydx_bwidth:`x'"'		
		}
		local rownames "`first' `sfname' `gradname'"
	}
	else {
		forvalues i=1/`k' {
			local x: word `i' of `allvars'
			local sfname `"`sfname' Mean_bwidth:`x'"'
			local stbwmean `"`stbwmean' mean:`w'"'
			local stbderiv `"`stbderiv' Effect:`w'"'
		}
		local rownames "`first' `sfname'"	
	}
	
	sreturn local stbderiv   "`stbderiv'"
	sreturn local stbwmean   "`stbwmean'"
 	sreturn local rownames   "`rownames'"
	sreturn local newrownames "`first'"

end

program _for_margins_stripe, sclass
	syntax, [origin(string) nuevas(string)]
	
	local l: list sizeof origin
	local k: list sizeof nuevas
	local listanpmarg ""
	forvalues i=1/`k' {
		local x: word `i' of `nuevas'
		forvalues j=1/`l' {
			local y: word `j' of `origin'
			_ms_parse_parts `y'
			local yname = "`r(name)'"
			local intxy: list yname & x
			local intxy2: list y & x
			if ("`intxy'"!="") {
				local listanpmarg "`listanpmarg' `y'"
			}
			else if ("`intxy2'"!="") {
				local listanpmarg "`listanpmarg' `y'"			
			}
		}
	}
	sreturn local mimargen "`listanpmarg'"
end

program KeStImAtoR, sclass
	syntax, [kestimator(string) gradient okgradient cdnum(integer 1)]
	
	if "`kestimator'"=="" {
		local  kest  ll
		local  kestimator "linear"
		local  klabel "Local-linear regression"
		local  degree = 1
		local  kestname "linear"
	}
	if ("`kestimator'"!="") { 
		if ("`kestimator'"!="constant" & "`kestimator'"!="linear") {
			display as error ///
			"invalid {bf:estimator()} `kest'"
			di as err "{p 4 4 2}" 
			di as smcl as err "{bf:estimator()} should be"
			di as smcl as err "constant or linear"
			di as smcl as err "{p_end}"
			exit 198
		}
		if ("`kestimator'"=="constant") {
			local  klabel "Local-constant regression"
			local degree = 0
			local kest lc 
			local kestname "constant"
		}
		else {
			local  klabel "Local-linear regression"
			local degree = 0 
			local kest ll
			local kestname "linear"
		}
	}
	if (`cdnum'==2) {
		local kest lc
		local degree = 0 
		local  klabel "Local-constant regression"
		local kestname "constant"
		if ("`kestimator'"=="linear") {
			display ""
			di as txt "{p 0 6 2}" 
			di as txt "note: Local-linear regression"
			di as txt "not available for estimation with"
			di as txt "discrete variables only."
			di as txt "The kernel estimator"
			di as txt "has been changed to local constant."
			di as txt "{p_end}"
		}
	}

	if (("`kest'" == "lc" & (`cdnum'==1| `cdnum'==3)) & ///
		("`gradient'"!=""|"`okgradient'"!="")) {
		display ""
		di as txt "{p 0 6 2}" 
		di as txt "note: Derivatives for continuous regressors" 
		di as txt "are only valid with default local-linear"
		di as txt "estimator. Estimator has been changed"
		di as txt "to local linear. If you want the"
		di as txt "local-constant estimator, specify the"
		di as txt "{bf:noderivative} option."
		di as txt "{p_end}"	
		local  kest ll
		local  klabel "Local-linear regression"
		local  degree = 1
		local  kestname "linear"
	}
	sreturn local kest "`kest'"
	sreturn local klabel "`klabel'"
	sreturn local degree "`degree'"
	sreturn local kestname "`kestname'"

end 

program _parse_predict_np, rclass
	capture syntax anything, [noDERIVatives replace]
	local rc = _rc
	if ("`anything'"=="" & `rc'>0) {
		display as error "option {bf:predict()} incorrectly specified"
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:predict()} expected a list of names " 
		di as smcl as err "and you have provided none."
		di as smcl as err "{p_end}"	
		exit 100	
	}
	if (`rc'>0) {
		display as error "option {bf:predict()} incorrectly specified"
		syntax anything, [noDERIVatives replace]
	}
	local pmedia = 1
	local pdydx  = 1
	local predijo "`anything'"
	capture quietly opts_exclusive "`mean' `meanuno'"
	local rc = _rc
	if (`rc') {
		display as error "only one of {bf:mean} and {bf:nomean}" ///
			" is allowed"
		exit 198
	}
	if ("`mean'"=="" & "`derivatives'"=="") {
		local pmedia = 1
		local pdydx  = 1	
	}
	if ("`mean'"=="" & "`derivatives'"!="") {
		local pmedia = 1
		local pdydx  = 0	
	}
	if ("`mean'"!="" & "`derivatives'"!="") {
		local pmedia = 0
		local pdydx  = 0	
	}
	if ("`mean'"!="" & "`derivatives'"=="") {
		local pmedia = 0
		local pdydx  = 1	
	}
	
	if ("`replace'"!="") {
		local predijo "`anything', replace"
	}
	return local predijo = "`predijo'"
	return local pmedia  = "`pmedia'"
	return local pdydx   = "`pdydx'"
end

program TaBlEnAtOr, rclass
	syntax [if][in] [fw iw], [sevars(string) asf(string)		///
		asfse(string) rnames(string) bandy(string) 		///
		bandg(string) allvars(string) cdnum(integer 1) 		///
		dvars(string) gradient(integer 2) gradvars(string)]
			 
	tempname awesome temporal hasf hdydx vawesome
	marksample touse 
	if ("`weight'" != "") {
                local wgt "[`weight'`exp']"
	}
	matrix `hasf'  = `bandy'
	local k2 = 0 
	if `gradient'>0 {
		matrix `hdydx' = `bandg'
		local k2       = colsof(`hdydx')
	}
	
	local disc = 0 
	if (`cdnum'>1 & `gradient'>0) {
		local disc: word count `dvars'
	}
	
	local k: word count `gradvars'
	local k1   = colsof(`hasf')
	local k3   = `k' + `k1' + `k2' + 1 - `disc'
	local k4   = `k' + 2
	local k5   = `k4' + `k1' -1
	local k6   = `k5' + 1 
	local ktab = `k' + 1
	matrix `awesome' = J(`ktab', 2 , 0)
	quietly summarize `asf' if `touse' `wgt'
	local a = r(mean)
	quietly summarize `asfse' if `touse' `wgt', meanonly
	local d = r(mean)^2
	matrix `awesome'[1,1] = `a'
	matrix `awesome'[1,2] = `d'

	if `gradient'>0 {
		forvalues i = 1/`k' {
			local j = `i' + 1
			local x: word `i' of `gradvars'
			local y: word `i' of `sevars'
			quietly summarize `x' if `touse' `wgt'
			local a = r(mean)
			quietly summarize `y' if `touse' `wgt'
			local d = r(mean)
			matrix `awesome'[`j',1] = `a'
			matrix `awesome'[`j',2] = `d'^2
		}
	}

	matrix `vawesome' = diag(`awesome'[1..rowsof(`awesome'),2])
	matrix `awesome' = `awesome'[1..rowsof(`awesome'),1]'
	mata: st_matrix("`vawesome'", editmissing(st_matrix("`vawesome'"), 0))
	mata: st_matrix("`awesome'", editmissing(st_matrix("`awesome'"), 0))
	return matrix vawesome = `vawesome'
	return matrix awesome  = `awesome'
	return scalar ktab     = `ktab'

end

program OpTiMiZaCiOn_np, rclass
	syntax, [DIFficult 			///
		TOLerance(real 1e-4)		///
                LTOLerance(real 1e-5)		///
		ITERate(integer 1000)		///
		TRace				///
		showstep			///
		NMsdelta(real 0.05)		///
		]
	
	local odifficult  = 0
	local otrace      = 0 
	local oshowstep   = 0 
	local tolcheck	  = 10*`tolerance'	 
	
	if `tolerance' < 0 {
                display as error "{bf:tolerance()} should be nonnegative"
                exit 125
        } 
	if (`tolerance'!=1e-4 & (10*`tolerance'>`nmsdelta')) {
		local valid = 10*`tolerance'
		display as error "invalid {bf:tolerance()} value"
		di as err "{p 4 4 2}" 
		di as smcl as err "When you modify the tolerance of the" 
		di as smcl as err "coefficient vector you modify the range"
		di as smcl as err "of valid deltas for the Nelder-Mead"
		di as smcl as err "optimization technique. With "
		di as smcl as err "{bf:tolerance()} at `tolerance' "
		di as smcl as err "{bf:nmsdelta()} should be at least "
		di as smcl as err "`valid'."
		di as smcl as err "{p_end}"
		exit 125
	}
        if `ltolerance' < 0 {
                display as error "{bf:ltolerance()} should be nonnegative"
                exit 125
        } 
	if  `iterate' < 0 {
                display as error "{bf:iterate()} must be a nonnegative integer"
                exit 125
        }
	if (`nmsdelta' < 1e-3) {
		display as error "delta must be greater than 0.001"
		exit 125
	}
	if ("`showstep'"!="") {
		local oshowstep = 1 
	}
	if ("`trace'"!="") {
		local otrace = 1 
	}
	if ("`difficult'"!="") {
		local odifficult = 1 
	}
	
	return local odifficult = `odifficult'
	return local otrace     = `otrace'
	return local oshowstep  = `oshowstep'
end

program _contordisc, rclass
	syntax [if] [in] [fw pw iw], variables(string) outcome(string) ///
				    [ okgradient(string) avars(string) ///
				      rhs(string) yesrhs(integer 0)    ///
				      vzero(string) oldnom(string)     ///
				      discero(string) quieto(string)]

	if "`weight'" != "" {
                local wgt "[`weight'`exp']"
        }
	
	marksample touse
	local vars "`variables'"
	local vars: list uniq vars

        local nl: list sizeof vars
	
	local continuous ""
	local discrete 	 ""
	local discrete2  ""
	local discrete3  ""
	local discrete4  ""
	local discrete5  ""
	local htabled	 ""
	local htablec	 ""
	local base       ""
	local selector   ""
	local niveles    ""
	local levlist    ""
	local dpos       ""
	local cpos       ""
	local origins    ""
	tempname basemat basevals baseval uniqvals basecont basedisc	///
		 domit avar 
		 
	matrix `basemat'  = 1 
	matrix `basecont' = 0
	matrix `basedisc' = 0 
	matrix `domit'    = 0 
	matrix `avar'     = `avars'
	local jc          = 1 
	local jd          = 1 	
	local jom         = 0 

	forvalues i=1/`nl'{ 
		local eqs: word `i' of `vars'
		local muevete: word `i' of `quieto'
		_ms_parse_parts `eqs'
		local type     = r(type)
		local name     = r(name)
		local nivelazo = r(level)
		local opname `r(op)'
		local dops     = r(omit)
		local aw       = `avars'[1,`i']
		local baselevel = r(base)
		local name2 "`name'"
		if ("`type'"=="factor") {
			local jmll: list eqs & rhs
			local jmltst "`opname'.`name'"
			if ("`jmll'"!="") {
				local name2 "`eqs'"
			}
		}
		if ( ("`type'"=="factor" & (`baselevel'==`dops')) | ///
		   ("`type'"=="variable" & "`opname'"=="") ) {
		   local origins "`origins' `name2'"
		   local origins2 "`origins2' `name'"
			if (`i'==1) {
				local posicion 1
				local j = 1
				local nameold = "`name'"
				local posj = `i'
			}
			else {
				local namenew  = "`name'"
				local pj = `i'-1
				if ("`namenew'"!="`nameold'") {
					local j = `j' + 1 
				}
				local posicion "`posicion' `j'"
				local posj = `j'
				local nameold = "`name'"
			}
		}
		if ("`type'"=="factor" & (`baselevel'==`dops')) {
			local basenum   = r(level)
			if (`aw'>-1) {
				local rho "`nivelazo'."
				local rho2 "`nivelazo'."
				local baselevel = 1
				local basenum = 0 
				local discrete5 = ///
					"`discrete5' `rho'`name' `rho'`name'"
			}
			else {
				local rho ""
				local discrete5 = "`discrete5' `rho'`name'"
			}
			local discrete  = "`discrete' `rho'`name'"
			local discrete3 = "`discrete3' `rho'`name'"
			local discrete4 = "`discrete4'  `name'"
			local htabled   = "`htabled' h_`rho'`name'"
			local niveles   = "`niveles' `nivelazo'"
			local dpos      = "`dpos' `posj'"
			if (`dops'==0) {
				local discrete2 = "`discrete2' `rho'`name'"				
			}
			if (`baselevel'==1 &	///
			   ("`muevete'"=="quieto"|"`muevete'"=="movete1"| ///
			    "`muevete'"=="")) {
				local base "`base' `basenum'" 
				matrix `basemat' = `basemat', `basenum'
			}
			local ksd: list uniq discrete
			local jkd: list sizeof ksd
			if (`jkd' >= `jd') {
				matrix `basedisc' = `basedisc', 1
				matrix `basecont' = `basecont', 0
				local jd = `jd' + 1	
			}
		}
		if ("`type'"=="variable" & "`opname'"=="") {
			local continuous = "`continuous' `name'"
			local cpos       = "`cpos' `posj'"				
			local htablec    = "`htablec' h_`name'"
			local ksc: list uniq continuous
			local jkc: list sizeof ksc
			if (`jkc' >= `jc') {
				matrix `basecont' = `basecont', 1
				matrix `basedisc' = `basedisc', 0
				local jc = `jc' + 1
			}
		}
		if "`type'"=="interaction" {
		display as error "interactions are unnecessary"
                di as err "{p 4 4 2}" 
                di as err "You are estimating an arbitrary function" 
                di as err "of the regressors. Interactions are" 
                di as err "accounted for implicitly."
                di as smcl as err "{p_end}"
			exit 198
		}
	} 

	matrix `basecont' = `basecont'[1,2..colsof(`basecont')]
	matrix `basedisc' = `basedisc'[1,2..colsof(`basedisc')]
	
	local origins: list uniq origins
	local origins2: list uniq origins2
	local posicion: list uniq posicion
	local discrete: list uniq discrete2
	local discrete4: list uniq discrete4
	local continuous: list uniq continuous
	local htabled: list uniq htabled
	local htablec: list uniq htablec
	local allvars "`continuous' `discrete'"
	local htable  "`htablec' `htabled'"
	local repito "`discrete3'"
	local repito2 "`discrete5'"
	local repitoall "`continuous'`discrete3'"
	local posfin "`cpos' `dpos'"
	local posfin: list uniq posfin	
	local posk: list sizeof posfin 
	
	tempname posmat
	matrix `posmat' = J(1,`posk', 0)
	forvalues i=1/`posk' {
		local px: word `i' of `posfin'
		matrix `posmat'[1,`i'] = `px'
	}
	
	if ("`continuous'"!="" & "`discrete'"!="") {
		local cdnum = 3
	}
	if ("`continuous'"=="" & "`discrete'"!="") {
		local cdnum = 2
	}
	if ("`continuous'"!="" & "`discrete'"=="") {
		local cdnum = 1
	}

	
	local kc: list sizeof continuous
	local kd: list sizeof discrete
	local k    = `kc' + `kd'
	quietly count if `touse'
	local n    = r(N)
	local nh   = `n'^(-1/(`k'+4))
	local xone: word 1 of `allvars'
	quietly summarize `xone'
	local hmat = r(sd)*`nh'
	
	forvalues i=1/`kc' {
		tempname h`i' x`i'
		local x`i': word  `i' of `allvars'
		quietly summarize `x`i'' if `touse'
		local `h`i'' = r(sd)*`nh'
		local hmat `hmat', ``h`i'''
	}
	
	matrix `basevals' = 1 
	matrix `uniqvals' = 1 

	forvalues i=1/`kd' { 
		local x`i': word  `i' of `discrete'
		capture quietly tab `x`i'', matrow(`baseval')
		local rc = _rc
		if (`rc'> 0) {
			tempvar night
			quietly generate `night' = `x`i''
			_ms_parse_parts `x`i''
			local basenumv = r(level)
			quietly tab `night', matrow(`baseval')
			matrix `baseval' = `baseval'*`basenumv'
		}
		matrix `basevals' = (`basevals')\(`baseval')
		matrix `uniqvals' = `uniqvals', rowsof(`baseval')
	}
	
	tempname hin hind
	
	if (`cdnum'==1) {
		matrix `hin'  = (`hmat')
		matrix `hin'  = `hin'[1,2..`k'+1]
	}
	if (`cdnum'==2) {
		matrix `hind'     = J(1,`kd', .5)
		matrix `hin'      = (`hind')
		matrix `basemat'  = `basemat'[1, 2..colsof(`basemat')]
		matrix `basevals' = `basevals'[2..rowsof(`basevals'), 1]
		matrix `uniqvals' = `uniqvals'[1, 2..colsof(`uniqvals')]
	}
	if (`cdnum'==3) {
		matrix `hind' = J(1,`kd', .5)
		matrix `hin'  = (`hmat'), (`hind')
		matrix `hin'  = `hin'[1,2..`k'+1]
		matrix `basemat'  = `basemat'[1, 2..colsof(`basemat')]
		matrix `basevals' = `basevals'[2..rowsof(`basevals'), 1]
		matrix `uniqvals' = `uniqvals'[1, 2..colsof(`uniqvals')]
	}
	
	local gradsize         = rowsof(`basevals') + `kc' - colsof(`basemat')
	
	
	return local gradsizem = "`gradsize'"
	return local cvars     = "`continuous'"
	return local origins   = "`origins'"
	return local origins2  = "`origins2'"
	return local dvars     = "`discrete'"
	return local cdnum     = "`cdnum'"
	return local allvars   = "`allvars'"
	return local htable    = "`htable'"
	return local base      = "`base'"
	return local repito    = "`repito'"
	return local repito2   = "`repito2'"
	return local repitoall = "`repitoall'"
	return local forgen    = "`discrete4'"
	return local niveles   = "`niveles'"
	return matrix hvars    = `hin'
	return matrix basemat  = `basemat'
	return matrix basevals = `basevals'
	return matrix uniqvals = `uniqvals'
	return matrix basecont = `basecont' 
	return matrix basedisc = `basedisc'
	return matrix posmat   = `posmat'
	return local posfin    = "`posfin'"    
end 

program define varlist_sanity, rclass
	syntax varlist(fv), rhs(string)
	quietly _rmcoll `varlist'
	local varlist = r(varlist)
	fvexpand `varlist' 
	tempname matbasep matvals
	local varlist = r(varlist)
	local k: list sizeof varlist
	local kt = `k'
	local varsnew ""
	local names ""
	local nameomit ""

	forvalues i=1/`k' {
		local x: word `i' of `varlist'
		_ms_parse_parts `x' 
		local a = r(base)
		local b = r(omit)
		local c = r(type)
		local d = r(name)
		if ((`a'==1 & `b'==1) | (`a'==0 & `b'==0) | ///
				("`c'"=="variable"|`b'==0)) {
			local varsnew "`varsnew' `x'"
		}
		local names "`names' `d'"
		if ((`a'!=`b' & "`c'"=="factor")| ///
			("`c'"=="variable" & `b'==1)) {
			local nameomit "`nameomit' `d'"
		}
	}

	local colin: list uniq names
	local namomit: list uniq nameomit
	local k2: list sizeof namomit
	forvalues i=1/`k2' {
		local x: word `i' of `namomit'
		display as txt "note: `x' omitted because of collinearity"
	}
 
	local k: list sizeof varsnew
	local varsfin ""
	forvalues i=1/`k' {
		local x: word `i' of `varsnew'
		_ms_parse_parts `x' 
		local a = r(name)	
		local b: list a & namomit
		if ("`b'"=="") {
			local varsfin "`varsfin' `x'"
		}	
	}
	local k: list sizeof rhs
	local newrhs ""
	forvalues i=1/`k' {
		local x: word `i' of `rhs'
		capture _ms_parse_parts `x'
		local rc = _rc
		if (`rc') {
			fvexpand `x'
			local a = r(varlist)
			local b: word 1 of `a'
			_ms_parse_parts `b'
			local c = r(name)
			local d: list c & namomit
			if ("`d'"=="") {
				local newrhs "`newrhs' `x'"
			}
		}
		else {
			local nom  = r(name)
			local d: list nom & namomit
			if ("`d'"=="") {
				local newrhs "`newrhs' `x'"
			}
		}
	}	
	if ("`newrhs'"=="") {
		di as error "no valid covariates available for estimation" 
		di as err "{p 4 4 2}" 
		di as smcl as err "Most likely you have introduced a set" 
		di as smcl as err " of covariates which are all constant."
		di as smcl as err "{p_end}"
		exit 198
	}
	return local rhs "`newrhs'"
	return local varsfin "`varsfin'"
end

program define _mat_mkvec_stripe, rclass 
	syntax, vars(string) [all mean se deriv sinderivadas]
	local k: list sizeof vars
	if ("`all"!="") {
		if ("`sinderivadas'"=="") {
			local all "Mean Effect"
			local kdv = 2
		}
		else {
			local all "Mean"	
			local kdv = 1	
		}
		local _mk_vec_str ""
		forvalues i=1/`kdv' {
			local x: word `i' of `all'
			forvalues j=1/`k' {
				local y: word `j' of `vars'
				local _mk_vec_str "`_mk_vec_str' `x':`y'"
			}
		}
	}
	if ("`deriv'"!="") {
		local _mk_vec_str ""
		forvalues j=1/`k' {
			local y: word `j' of `vars'
			local _mk_vec_str "`_mk_vec_str' Effect:`y'"
		}
	}
	if ("`mean'"!="") {
		local _mk_vec_str ""
		forvalues j=1/`k' {
			local y: word `j' of `vars'
			local _mk_vec_str "`_mk_vec_str' Mean:`y'"
		}
	}
	return local _mk_vec_str "`_mk_vec_str'"
end

program define _vce_npreg, rclass
	capture syntax, [none vce(string)]
	local rc = _rc
	if (`rc') {
		display as error "invalid {bf:vce()} option"
		exit 198
	}
end

program define _np_gets_band, rclass 
	syntax, [				///
			from(string)		///
			bwidth(string)		///
			derivbwidth(string)	///
			meanbwidth(string)	///
			allvars(string) 	///
			origins(string)		///
			cdnum(integer 1)	///
			bscont(string)		///
			bsdisc(string)		///
			sinderivadas]
	
	tempname hin bandy bandse banda  hgradient sinozero sinozero1 sinozero2
	
	local k : word count `allvars'
	
	local fixed      = 0
	local fixedse    = 0 
	local fixedgrad  = 0 
	local kfrom      = `k'*2
	if ("`sinderivadas'"!="") {
		local kfrom = `k'
		local sind "sinderivadas"
	}	
	if ("`from'"!="") {
		tempname meanbwidth derivbwidth hfrom	
		local copyopt "`from'"
		gettoken one two: copyopt, parse(",")
		gettoken tres cuatro: two, parse(",")
		if (`"`cuatro'"'==" copy") {
			tempname from2
			_mat_mkvec_stripe, vars("`origins'") all `sind'
			local colsnoms = "`r(_mk_vec_str)'"
			capture _mkvec `from2', from(`from') ///
				colnames(`colsnoms')	
			local rc = _rc
			if (`rc') {
			di as err "option {bf:from()} specified" ///
				    " incorrectly; " _c	
				_mkvec `from2', from(`from') ///
					colnames(`colsnoms')				   
			}
			local from2 `"`from2'"'
		}
		else {
			local from2 `"`from'"'
		} 
		_mat_mkvec_stripe, vars("`allvars'") all `sind'
		local colsnoms = "`r(_mk_vec_str)'"
		BaNdWiThPaRsE, bwidth(`from2') columna(`kfrom')		///
			       bscont(`basecont') cdnum(`cdnum') 	///
			       bsdisc(`bsdisc') from(1) 		///
			       colnames("`colsnoms'")			    
		matrix `hfrom'       = r(hmat)
		matrix `meanbwidth'  = `hfrom'[1,1..`k']
		if ("`sind'"=="") {
			matrix `derivbwidth' = `hfrom'[1,(`k'+1)..2*`k']
		}
	}
	if ("`derivbwidth'"!="" & "`sind'"=="") {
		local copyopt "`derivbwidth'"
		gettoken one two: copyopt, parse(",")
		gettoken tres cuatro: two, parse(",")
		if (`"`cuatro'"'==" copy") {
			tempname derivbwidth2
			_mat_mkvec_stripe, vars("`origins'") deriv
			local colsnoms = "`r(_mk_vec_str)'"
			capture _mkvec `derivbwidth2', from(`derivbwidth') ///
				colnames(`colsnoms')	
			local rc = _rc
			if (`rc') {
			di as err "option {bf:derivbwidth()} specified" ///
				    " incorrectly; " _c	
				_mkvec `derivbwidth2', from(`derivbwidth') ///
				colnames(`colsnoms')
			}
			local derivbwidth2 `"`derivbwidth2'"'
		}
		else {
			local derivbwidth2 `"`derivbwidth'"'
		} 
		_mat_mkvec_stripe, vars("`allvars'") deriv
		local colsnoms = "`r(_mk_vec_str)'"
		BaNdWiThPaRsE, bwidth(`derivbwidth2') columna(`k')	///
			       bscont(`basecont') cdnum(`cdnum') 	///
			       bsdisc(`bsdisc') colnames("`colsnoms'")
		matrix `hgradient' = r(hmat)
		if ("`from'"=="") {
			local fixedgrad    = 1 
		}
	}
	if ("`meanbwidth'"!="") {
		local ktrc: list sizeof meanbwidth
		local copyopt "`meanbwidth'"
		gettoken one two: copyopt, parse(",")
		gettoken tres cuatro: two, parse(",")
		if (`"`cuatro'"'==" copy") {
			tempname meanbwidth2
			_mat_mkvec_stripe, vars("`origins'") mean
			local colsnoms = "`r(_mk_vec_str)'"
			capture _mkvec `meanbwidth2', from(`meanbwidth') ///
				colnames(`colsnoms')
			local rc = _rc
			if (`rc') {
			di as err "option {bf:meanbwidth()} specified" ///
				    " incorrectly; " _c	
				_mkvec `meanbwidth2', from(`meanbwidth') ///
					colnames(`colsnoms')
			}
			local meanbwidth2 `"`meanbwidth2'"'
		}
		else {
			local meanbwidth2 `"`meanbwidth'"'
		} 
		_mat_mkvec_stripe, vars("`allvars'") mean
		local colsnoms = "`r(_mk_vec_str)'"
		BaNdWiThPaRsE, bwidth(`meanbwidth2') columna(`k')	///
			       bscont(`basecont') cdnum(`cdnum') 	///
			       bsdisc(`bsdisc') colnames("`colsnoms'")
		matrix `hin'  = r(hmat)
		if ("`from'"=="") {
			local fixed   = 1 
		}	
	}
	if ("`bwidth'"!="") {
		local copyopt "`bwidth'"
		gettoken one two: copyopt, parse(",")
		gettoken tres cuatro: two, parse(",")
		if (`"`cuatro'"'==" copy") {
			tempname bwidth2
			_mat_mkvec_stripe, vars("`origins'") all `sind'
			local colsnoms = "`r(_mk_vec_str)'"
			capture _mkvec `bwidth2', from(`bwidth') ///
				colnames(`colsnoms')	
			local rc = _rc
			if (`rc') {
				di as err "option {bf:bwidth()} specified" ///
				    " incorrectly; " _c
				_mkvec `bwidth2', from(`bwidth') ///
					colnames(`colsnoms')
			}
			local bwidth2 `"`bwidth2'"'
		}
		else {
			local bwidth2 `"`bwidth'"'
		} 
		tempname bwidthuno bwidthdos bwidthtres hmat
		_mat_mkvec_stripe, vars("`allvars'") all `sind'
		local colsnoms = "`r(_mk_vec_str)'"
		capture _mkvec `hmat', from("`bwidth2'") colnames("`colsnoms'")
		local rc = _rc
		if (`rc') {
			di as error "option {bf:bwidth()} specified"	///
				    " incorrectly; " _c
			_mkvec `hmat', from("`bwidth2'") colnames("`colsnoms'")
		}
		local colcheck = colsof(`hmat')		
		local ktrc = 0  

		matrix `sinozero1' = `bsdisc'
		matrix `sinozero' = `sinozero1', `sinozero1'

		if (`colcheck'==`kfrom') {
			forvalues i=1/`kfrom' {
				local a  = `hmat'[1, `i']
				local an = `sinozero'[1, `i']
				if (`a'<=0 & `an'==0) {
					local ktrc = `ktrc' + 1
				}
				if (`a'< 0 & `an'==1) {
					local ktrc = `ktrc' + 1
				}
			}
		}	
		if (`colcheck'!=`kfrom' | `ktrc'>0) {
			if (`ktrc'!=`kfrom') {
				local colcheck = `ktrc'
			}
			di as error "{bf:bwidth()} specified incorrectly" 
			di as err "{p 4 4 2}" 
			di as smcl as err "The bandwidth vector should be of" 
			di as smcl as err " dimension `kfrom' and have no"
			di as smcl as err " negative values or zero values"
			di as smcl as err " for continuous covariates."
			di as smcl as err "{p_end}"
			exit 198
		}	
		local copyopt "`bwidth'"
		gettoken one two: copyopt, parse(",")
		gettoken tres cuatro: two, parse(",")
		
		local cambia = 0 
		if ("`cuatro'"=="copy") {
			local cambia = 1 
		}
		matrix `bwidthuno'  = `hmat'[1,1..`k']
		if ("`sind'"=="") {
			matrix `bwidthtres' = `hmat'[1,(`k'+1)..2*`k']
		}
		_mat_mkvec_stripe, vars("`allvars'") mean
		local colsnomsuno = "`r(_mk_vec_str)'"
		BaNdWiThPaRsE, bwidth(`bwidthuno') columna(`k') 	///
			       cdnum(`cdnum') bscont(`basecont')	///
			       bsdisc(`bsdisc') cambia(`cambia')	///
			       colnames("`colsnomsuno'") 
		matrix `hin'        = r(hmat)
		if ("`sind'"=="") {
			_mat_mkvec_stripe, vars("`allvars'") deriv
			local colsnomstres = "`r(_mk_vec_str)'"
			BaNdWiThPaRsE, bwidth(`bwidthtres') columna(`k')    ///
				       cdnum(`cdnum') bscont(`basecont')    ///
				       bsdisc(`bsdisc')  cambia(`cambia') ///
				       colnames("`colsnomstres'")			    		
			matrix `hgradient'  = r(hmat)
		}
		if ("`from'"=="") {
			local fixed         = 1
			local fixedgrad     = 1 
		}
	}
	local allfix = `fixed' + `fixedgrad' 
	
	if (`fixed' > 0|"`from'"!="") {
		return matrix hin       = `hin'
	}
	if ((`fixedgrad'>0 & "`sind'"=="") | ("`from'"!="" & "`sind'"=="")) {
		return matrix hgradient = `hgradient'
	}
	return local allfix     = `allfix'
	return local fixed      = `fixed'
	return local fixedgrad  = `fixedgrad'
end 

program _d_kernel_parse, rclass
	syntax, [kernel(string) dkernel(string) cdnum(integer 2)]
	
	local lkey =  length(`"`dkernel'"')

	if (`"`dkernel'"' == bsubstr("liracine",1,max(2,`lkey'))) {
		local dkernel "liracine" 
	}
	if (`"`dkernel'"' == bsubstr("cellmeans",1,max(4,`lkey'))) {
		local dkernel "cellmeans" 
	}
	
	if (("`kernel'"=="liracine"| "`kernel'"=="cellmeans")) {
		display as error "option {bf:kernel()} incorrectly specified"
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:liracine} and {bf:cellmeans}"
		di as smcl as err " arguments are only" 
		di as smcl as err " valid with the {bf:dkernel()} option"
		di as smcl as err "{p_end}"
		exit 198		
	}
	if ((`cdnum'==1) & ///
		("`kernel'"=="liracine"| "`kernel'"=="cellmeans"| ///
			"`dkernel'"=="liracine"| "`dkernel'"=="cellmeans")) {
		display as error "option {bf:kernel()} incorrectly specified"
		di as err "{p 4 4 2}" 
		di as smcl as err "You are asking for a discrete kernel" 
		di as smcl as err " and your variable is continuous."
		di as smcl as err " Please use factor variable notation"
		di as smcl as err " if your variables are discrete."
		di as smcl as err "{p_end}"
		exit 198		
	}
	if ((`cdnum'==2) & ("`kernel'"!="")) {
		display as error "option {bf:kernel()} incorrectly specified"
		di as err "{p 4 4 2}" 
		di as smcl as err "You can only specify {bf:kernel()}" 
		di as smcl as err " for continuous covariates."
		di as smcl as err "{p_end}"
		exit 198		
	}
	if ("`dkernel'"!="cellmeans" & "`dkernel'"!="liracine" & "`dkernel'"!="") {
		display as error "option {bf:dkernel()} incorrectly specified"
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:liracine} and {bf:cellmeans}"
		di as smcl as err " are the only valid arguments for the" 
		di as smcl as err " {bf:dkernel()} option."
		di as smcl as err "{p_end}"
		exit 198			
	}
	if ("`dkernel'"=="") {
		local dkernel "liracine"
	}
	else {
		local dkernel "`dkernel'"	
	}
	if (`cdnum'>1) {
		local dkernel = "`dkernel'"
		return local dkernel "`dkernel'"
	}
	
end

program define _parse_reps, sclass
	quietly ///
	syntax [anything][if][in][fw pw iw], [Reps(string) seed(string) *]
	if (`"`reps'"'=="" & "`seed'"!="") {
		display as error ///
			"option {bf:seed()} must be specified with option" ///
			" {bf:reps()}"
		exit 198		
	}
	if (`"`reps'"'!="") {
		local reps = real("`reps'")
		if (`reps'==.) {
			display as error ///
				"option {bf:reps()} incorrectly specified"
			exit 198
		}
		if (`reps'>1 & "`seed'"!="") {
			local vce vce(bootstrap, reps(`reps') seed(`seed')) 
		}
		if (`reps'>1 & "`seed'"=="") {
			local vce vce(bootstrap, reps(`reps')) 
		}
		if (`reps'<2) {
			display as error ///
				"option {bf:reps()} incorrectly specified"
			exit 198
		}
		local vce `"`vce'"'
	}
	gettoken uno dos: 0, parse(",")
	local newzero `"`uno', `options' `vce'"'	
	sreturn local newzero `"`newzero'"'
end 	
	
program define _parse_uniq, rclass 
	syntax [anything], mylista(string)
	
	fvexpand `mylista'
	local mylista2 = r(varlist)
	local orig: list uniq mylista2
	local menos: list mylista2 - orig 
	local k: list sizeof menos
	forvalues i=1/`k' {
		local x: word `i' of `menos'
		if ("`x'"!="") {
			display as txt ///
				"note: `x' omitted because of collinearity" 
		}
	}
	return local rhs `"`orig'"'
end	

program define _var_simple, sclass
	syntax anything(name=vlist) [if][in], [*]
	sreturn local varsimple "`vlist'"
end
	
program define _yes_rhs, rclass 
	syntax anything(name=rh0) 
	
	local k: list sizeof rh0
	local cuenta = 0 

	forvalues i=1/`k' {
		local x: word `i' of `rh0'
		capture fvexpand `x'
		local rc = _rc
		if (`rc'==0) {
			local x2 = r(varlist)
			local k2: list sizeof x2
		}
		capture _ms_parse_parts `x'
		local rc = _rc
		if (`rc') {
			local cuenta = `cuenta' + 0 
		}
		else {
			local tipo = r(type)
			if ("`tipo'"=="variable") {
				local cuenta = `cuenta' + 0 
			}
			if ("`tipo'"=="factor") {
				local cuenta = `cuenta' + 1
			}
		}
	}
	if (`cuenta') {
		local yesrhs = 1
	}
	else {
		local yesrhs = 0	
	}
	
	if (`yesrhs') {
		_nzero_yes_rhs `rh0'
		local rh0 = "`r(nombre)'"
	}
	else {
		local 0 "`rh0'"
		syntax varlist(fv)
		local rh0 "`varlist'"
	}
	
	return local yesrhs = `yesrhs'	
	return local listnew "`rh0'"
end

program define _nzero_yes_rhs, rclass 
	syntax anything(name=rh0)

	local k: list sizeof rh0 
	local j = 1 
	local pro = 0 

	while (`j'<=`k') {
		local v: word `j' of `rh0'
		if (`pro'>0) {
			local v "`v2' `v'"
		}
		capture _ms_parse_parts `v'
		local rc = _rc 
		if (`rc') {
			capture fvexpand `v'
			local rc = _rc 
			if (`rc') {
				local v2 "`v2' `v'"
				local pro = `pro' + 1 
				local j   = `j' + 1
			}
			else {
				local nzero = r(varlist)
				local pro = 0 
				local j   = `j' + 1
				local namezero "`namezero' `nzero'"
			}
		}
		else {
			capture fvexpand `v'
			local rc = _rc 
			if (`rc') {
				local v2 "`v2' `v'"
				local pro = `pro' + 1 
				local j   = `j' + 1
			}
			else {
				local nzero = r(varlist)
				local pro = 0 
				local j   = `j' + 1
				local namezero "`namezero' `nzero'"
			}
		}
	}

	local bli "`namezero'"
	local k: list sizeof bli 
	local inter: list rh0 & bli
	
	local k: list sizeof inter
	
	local n = 1 
	local j = 1
	forvalues i=1/`k' {
		local x: word `i' of `inter'
		_ms_parse_parts `x'
		local nameb = r(name)
		local tipo  = r(type)
		if ("`tipo'"=="factor") {
			if(`i'==1) {
				local namea "`nameb'"
			}
			if ("`namea'"=="`nameb'") {
				local name`n' "`name`n'' `x'"
			}
			else {
				local n = `n' + 1 
				local name`n' "`name`n'' `x'"
			}
			local namea "`nameb'"
		}
	}
	
	forvalues i=1/`n' {
		fvexpand `name`i''
		local x = r(varlist)
		local k2: list sizeof x 
		forvalues j=1/`k2' {
			local y: word `j' of `x'
			_ms_parse_parts `y'
			local base  = r(base)
			local level = r(level)
			local nom   = r(name) 
			if (`base'==0) {
				local namec "`namec' `level'.`nom'"
			}
			local namesc "`namesc' `nom'"
		}
	}
	
	local k: list sizeof namec
	local k2: list sizeof bli

	forvalues j=1/`k2' {
		local y: word `j' of `bli'
		_ms_parse_parts `y'
		local nom1  = r(name)
		local lev1  = r(level)
		local tipo1 = r(type)
		if ("`tipo1'"=="factor") {
			local nomd0 "`lev1'.`nom1'"
			local inter: list nomd0 & namec
			local inter2: list namesc & nom1
			if ("`inter'"!="") {
				local nomd "`nomd' `inter'"
			}
			else if ("`inter2'"=="") {
				local nomd "`nomd' i.`nom1'"
			}
		}
		else {
			local nomd "`nomd' `y'"
		}
	}

	local nomd: list uniq nomd
	return local nombre = "`nomd'"


end

program define _quieto_movete, sclass 
	syntax anything(name=rh0)
	local k: list sizeof rh0
	forvalues i=1/`k' {
		local x: word `i' of `rh0'
		capture _ms_parse_parts `x'
		local rc = _rc 
		if (`rc') {
			fvexpand `x'
			local x2   = r(varlist)
			local k2: list sizeof x2
			forvalues i=1/`k2' {
				local x3: word `i' of `x2'
				local dmov "`dmov' quieto"
				local dmov3 "`dmov3' quieto"
				_ms_parse_parts `x3'
				local tipo = r(type)
				local x4 = r(name)
				local dmov2 "`dmov2' quieto=`x4'"
			}
			if ("`tipo'"=="factor") {
				local dorig "`dorig' `x'"
				local dmov4 "`dmov4' quieto"
			}
			else {
				local corig "`corig' `x'"
			}
		}
		else {
			local tipo = r(type)
			local x4   = r(name)
			local nv   = r(level)
			if ("`tipo'"=="factor") {
				local dmov "`dmov' movete"
				local dmov3 "`dmov3' movete1 movete2"
				local dmov2 "`dmov2' movete=`nv'.`x4'"
				local dorig "`dorig' `x'"
				local dmov4 "`dmov4' movete"
			}
			else {
				local cmov "`cmov' quieto"
				local dmov3 "`dmov3' quieto"
				local cmov2 "`dmov2' quieto=`x4'"
				local corig "`corig' `x'"
			}
		}
	}

	local quieto "`cmov' `dmov'"
	local quieto2 "`cmov2' `dmov2'"
	local quieto3 "`dmov'"
	local quieto4 "`dmov2'"
	local quieto5 "`dmov3'"
	local quieto6 "`dmov4'"
	local rhcero "`corig' `dorig'"
	sreturn local quieto "`quieto'"
	sreturn local quieto2 "`quieto2'"
	sreturn local quieto3 "`quieto3'"
	sreturn local quieto4 "`quieto4'"
	sreturn local quieto5 "`quieto5'"
	sreturn local quieto6 "`quieto6'"
	sreturn local rhcero "`rhcero'"
end

program define _hinn, rclass
	syntax [if] [in], [dvars(string) cvars(string) cdnum(integer 1)]
	
	marksample touse 
	
	tempname hmat hind hin
	
	local kc: list sizeof cvars
	local kd: list sizeof dvars
	local k    = `kc' + `kd'
	quietly count if `touse'
	local n = r(N)
	local nh   = `n'^(-1/(`k'+4))
	
	local allvars "`cvars' `dvars'"
	
	if (`cdnum'==1) {
		forvalues i=1/`kc' {
			tempname h`i' x`i'
			local x`i': word  `i' of `allvars'
			quietly summarize `x`i'' if `touse'
			local `h`i'' = r(sd)*`nh'
			matrix `hmat' = nullmat(`hmat'), ``h`i'''
			matrix `hin' = `hmat'
		}		
	}
	if (`cdnum'==2) {
		matrix `hind'     = J(1,`kd', .5)
		matrix `hin' = `hind'
	}
	if (`cdnum'==3) {
		forvalues i=1/`kc' {
			tempname h`i' x`i'
			local x`i': word  `i' of `allvars'
			quietly summarize `x`i'' if `touse'
			local `h`i'' = r(sd)*`nh'
			matrix `hmat' = nullmat(`hmat'), ``h`i'''
		}	
		matrix `hind'     = J(1,`kd', .5)
		matrix `hin'      = `hmat', `hind'
	}
	return matrix hinn = `hin'
end

program define _more_striping, rclass
	syntax, [dvars(string)]  
	local k1: list sizeof dvars
	local j = 1
	local l = 1 
	forvalues i=1/`k1' {
		local x: word `i' of `dvars'
		capture tab `x'
		local rc = _rc
		if (`rc') {
			if (`j'==1) {
				local nombre "`nombre' `x'"
				local j = `j' + 1
				local nombre0 "`x'"
				local quietud "`quietud' movete"
			}
			if ("`x'"!="`nombre0'") {
				local nombre "`nombre' `x'"
				local nombre0 "`x'"
				local quietud "`quietud' movete"
			}
			
		}
		else {
			fvexpand i.`x'
			local y = r(varlist)
			local k: list sizeof y
			local k = `k' - 1 
			local y1: word 1 of `y'
			_ms_parse_parts `y1'
			local nom = r(name)
			if (`l'==1) {
				local prelim = "`nom' "*`k'
				local preq   = "quieto "*`k'
				local quietud "`quietud' `preq'"
				local nombre "`nombre' `prelim'"
				local nom0 "`nom'"
				local l = `l' + 1
			}
			if ("`nom'"!="`nom0'") {
				local prelim = "`nom' "*`k'
				local preq   = "quieto "*`k'
				local quietud "`quietud' `preq'"
				local nombre "`nombre' `prelim'"
				local nom0 "`nom'"			
			}
		}
	}
	return local mnomd "`nombre'"
	return local quietud "`quietud'"
end


program define _ci_type, rclass
	capture syntax [anything], [bc NORmal Percentile *]
	_get_diopts diopts rest, `options'
	local citype "`percentile'`normal'`bc'"
	local ctipo = inlist("`citype'", "percentile", "normal", "bc")
	if (`ctipo'==0 & "`options'"!="") {
		display as error "{bf:`options'} invalid {bf:citype()}"
		exit 198
	} 
	local citipo = 1 
	if "`citype'"=="percentile" {
		local citipo = 1 
		local scitipo "percentile"
	}
	if "`citype'"=="normal" {
		local citipo = 2
		local scitipo "normal"
	}
	if "`citype'"=="bc" {
		local citipo = 3
		local scitipo "bias-corrected"
	}
	return scalar citipo = `citipo'
	return local scitipo "`scitipo'"
end

program define _my_contador_dydx 
	syntax [anything], [ nom(string)]
	*substr("`s(d`i'name)'", 1, 32)
	
	local x0: word 1 of `nom'
	local x = substr("`x0'", 1, 32)
	local k: list sizeof nom
	local cuentas = 0
	if (`k'>1) {
		forvalues i=2/`k' {
			local y0: word `i' of `nom'
			local y = substr("`y0'", 1, 32)
			local inter: list y & x
			if ("`inter'"!="") {
				local cuentas = `cuentas' + 1
				if (`cuentas'==1) {
					local nom1 "`y0'"
				}
			}
		}
	}
	
	if (`cuentas'>0) {
		display as error "`nom1' is an invalid name"
		di as err "{p 4 4 2}" 
		di as smcl as err "Because your variable names are too long,"
		di as smcl as err "the system variable, {bf:`nom1'}, generated "
		di as smcl as err "by default by {bf:npregress}"  
		di as smcl as err "is too long. Please use the"
		di as smcl as err "{bf:predict()} option to provide"
		di as smcl as err "more adequate names for the mean and "
		di as smcl as err "the effects."
		di as smcl as err "{p_end}"
		exit 198	
	}
end

