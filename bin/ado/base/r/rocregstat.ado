*! version 1.0.4  09feb2015
program rocregstat, eclass
	version 12
	syntax [if] [in] 					///
		[,di(varname)					///
		classvars(varlist) 				///
		ctrlcov(varlist)  				///
		CTRLMODel(string)  				///
        	retctrlcov					///
		pvc(string) 					///
		tiecorrected 					///
		roccov(varlist)					///
		link(string)		 			///
		interval(numlist min=3 max=3) 			///
		roc(numlist)  					///
		INVroc(numlist) 				///
		pauc(numlist) 					///
		auc 						///
		stratano(varname)				///
		strcaseno(varname) 				///
		strctrlno(varname) 				///
		fprvars(varlist) 				///
		rocvars(varlist) 				///
		ctrlfprall 					///
		clvar(varlist) 					///
		bskip 						///
		bskiplr	]					

	//1 Mark sample
	qui marksample touse
	// called under proper sample in rocreg with if condition

	//2 Covariate Control 
	local vvit = 1
	foreach y of varlist `classvars' {
		tempvar pvc_`vvit'
		if(`"`pvc'"' == "normal" & `"`ctrlmodel'"' != "linear") {      
			//`stratano' is missing if `strata' is not specified
			tempvar stratad0mean stratad0sd
			tempvar oorder
			qui gen `c(obs_t)' `oorder' = _n
			qui bysort `touse' `stratano' `di' (`oorder'): ///
			egen double `stratad0sd'=sd(`y') if `di' == 0 & `touse'
			qui by `touse' `stratano' `di' (`oorder'): ///
			egen double `stratad0mean'=mean(`y') if ///
				`di' == 0 & `touse'
			qui by `touse' `stratano': ///
			replace `stratad0sd' = `stratad0sd'[1] if `touse'
			qui by `touse' `stratano': ///
			replace `stratad0mean' = `stratad0mean'[1] if `touse'
			qui gen double `pvc_`vvit'' = ///
				(`y'-`stratad0mean')/`stratad0sd' if `touse'
		}
		else if(`"`ctrlmodel'"'=="linear") {
			local cluclvar
			if (`"`clvar'"' != "") {
				local cluclvar vce(cluster `clvar')
			}
			qui capture regress `y' `ctrlcov' if ///
				`touse' & `di'==0, ///
				`cluclvar'
			if(`"`bskiplr'"'=="") {
				estimates store _rr_`y', novarname
			}
			if(_rc > 0) {
di as error "{p 0 4 2}problem with the covariate control "
di as error "population regression for marker `y'{p_end}"
				exit _rc
			}
			tempname sigma 
			scalar `sigma' = e(rmse)
			qui predict double `pvc_`vvit'' if `touse', resid
			qui replace `pvc_`vvit'' =`pvc_`vvit''/`sigma' ///
			if `touse' 		
		}
		else {
			// empirical and no adjustment, at least 
			// until actual percentile value calculation
			// pass it all in, we need the d=0 values 
			qui gen double `pvc_`vvit'' = `y' if `touse'
		}
		local vvit = `vvit' + 1
	}

	//3 Percentile values
	local i = 1
	qui count if `di' == 0 & `touse'
	local nit = r(N)
	local vvit = 1
	foreach y of varlist `classvars' {
		if(`"`pvc'"' == "normal") {
			qui replace `pvc_`vvit'' = ///
				normal(`pvc_`vvit'') if `touse'
		}
		else {
			EmpPctVal, pctval(`pvc_`vvit'') 	///
						di(`di') 	///
						touse(`touse') 	/// 
						`tiecorrected' ///
						covstrata(`stratano') 	///
						covstrctrlcnt(`strctrlno') ///
						nval(`nit')
		}
		//get FPR value from percentile values
		tempvar fpr_`vvit'
		qui gen double `fpr_`vvit'' = 1- `pvc_`vvit''
		label variable `fpr_`vvit'' `"FPR `y'"'

		local i = `i' + 1
		local vvit = `vvit' + 1
	}

	// so now we have percentile values based on potential covariate 
	// adjustment of `di'==0 distribution
	
	// it's time to estimate the ROC curve parameters

	// if link used, do expansion and get parameters
	// fill out roc values after expansion removed

	//4 Parametric estimation
	if (`"`link'"'!="" & `"`ctrlfprall'"'=="") {
		// add fpr fit points via expansion
		preserve
		qui keep if `touse' & `di' == 1
		tokenize `interval'
		local a `1'
		local b `2'
		
		local numpts `3'
		tempvar oorder fk s_cons i_cons expanded

		qui gen `c(obs_t)' `oorder' = _n		
		qui expand `numpts'
		tempvar oorder1
		qui gen `oorder1' = _n
		qui bysort `oorder' (`oorder1'): gen double `fk' = ///
			_n*(`b'-`a')/(`numpts'+1) + `a'
		if (`"`link'"'=="probit") {
			qui gen double `s_cons'=invnormal(`fk')
		}
		else {	
			qui gen double `s_cons'=logit(`fk')
		}
	}
	if (`"`link'"'!="" & `"`ctrlfprall'"'=="") {
		local vvit = 1
		foreach y of varlist `classvars' {
			// see Alonzo, Pepe 2002 p. 425

			tempvar u_`vvit'
			qui gen double `u_`vvit'' =  1-`pvc_`vvit'' <= `fk'
			qui `link' `u_`vvit'' `roccov' `s_cons'

			tempname rocregB_`vvit'
			matrix `rocregB_`vvit'' = e(b)
			local g: colnames `rocregB_`vvit''
			local gn =colsof(`rocregB_`vvit'')
			tokenize `g'
			forvalues i =1/`gn' {
				local `i' `"`y':``i''"'
			}
			local g =`"`*'"'
			local g = subinstr(`"`g'"',"_cons","i_cons",.)
			local g = subinstr(`"`g'"',`"`s_cons'"', `"s_cons"',.)
	
			matrix colnames `rocregB_`vvit''= `g' 	

			if (`"`eb'"' != "") {
				matrix `eb' =  `eb',`rocregB_`vvit''
			}
			else {
				tempname eb
				matrix `eb' = `rocregB_`vvit''
			}
			local vvit = `vvit' + 1	
		}
	}

	if (`"`link'"' != "" & `"`ctrlfprall'"' == "") {
		// fitting performed, restore data
		restore
	}	

		// now handle ctrlfprall != "" case	
	if (`"`link'"'!="" & `"`ctrlfprall'"'!="") {
		local vvit = 1
		foreach y of varlist `classvars' {
			if (`"`ctrlcov'"' == "") {
				tempvar ctrlcovit 
				qui gen `ctrlcovit' = 1 
			}
			else  {
				local ctrlcovit `ctrlcov'
			}
			preserve
			
			tokenize `interval'
			local a `1'
			local b `2'
			
			local dm (`di'==0 & _n > 1)
			local dma   1-`pvc_`vvit'' > `a'
			local dma  `dma' & 1-`pvc_`vvit'' < `b'
			local dma  (`di'==0 & !(`dma'))
			local dm `dm' | `dma'
				
			qui keep if `touse'
			tempvar numinstrata oorder fk s_cons i_cons
			qui gen long `oorder' = _n
			qui bysort `di' `ctrlcovit' ///
				`pvc_`vvit'' (`oorder'): ///
				drop if `dm'

			// remove fpr 1's, as explained on 
			// page 159 of 2003 text
			// we just use 1.. n - 1 fraction
			qui drop if `di' == 0 & `pvc_`vvit'' == 0
			
			qui bysort `ctrlcovit' (`oorder'): ///
				egen long `numinstrata' = total(`di'==0) 
			
			// put an ordering on unique fpr's 
			// within each control covariate strata
			// for matching with diseased in that strata

			tempvar sort_fpr
			qui bysort `di' `ctrlcovit' ///
				(`pvc_`vvit'' `oorder'): ///
				gen long `sort_fpr' = _n if `di' == 0

			// we essentially just dummy up 
			// `di' == 1 for each of the `di' == 0     
			// covariate cases

		        qui expand `numinstrata' if `di' == 1
			tempvar oorder1
			gen `oorder1' = _n
			
			// we expanded on all the fpr's in 
			// each covariate strata
			// so there will be a match for each 
			// `sort_fpr' in 
			qui bysort `oorder' (`oorder1'): ///
				replace `sort_fpr' = _n if `di' == 1
			
			// now fill in the fpr from `di' == 0 
			// into the `di' == 1 dummy
			local dm 1-`pvc_`vvit''[1] > `a'
			local dm `dm' & 1-`pvc_`vvit''[1] < `b'
				
			qui bysort `ctrlcovit' `sort_fpr' ///
				(`di' `oorder1'): ///
				gen double `fk'=1-`pvc_`vvit''[1] ///
				if `dm'
		
			if (`"`link'"'=="probit") {
				qui gen double `s_cons' = invnormal(`fk')  ///
					if `touse' & `di'==1
			}
			tempvar u_`vvit'
			qui gen double `u_`vvit'' = 1-`pvc_`vvit'' <= `fk' ///
				if `touse' & `di' == 1
					
			qui `link' `u_`vvit'' `roccov' 	`s_cons' ///
					if `touse' & `di' == 1

			tempname rocregB_`vvit'
			matrix `rocregB_`vvit'' = e(b)
			local g: colnames `rocregB_`vvit''
			local gn =colsof(`rocregB_`vvit'')
			tokenize `g'
			forvalues i =1/`gn' {
				local `i' `"`y':``i''"'
			}
			local g =`"`*'"'
			local g = subinstr(`"`g'"',"_cons","i_cons",.)
			local g =  subinstr(`"`g'"',`"`s_cons'"',`"s_cons"',.)
			matrix colnames `rocregB_`vvit''= `g' 			
			if(`"`eb'"' != "") {
				matrix `eb' =  `eb',`rocregB_`vvit''
			}
			else {
				tempname eb
				matrix `eb' = `rocregB_`vvit''
			}
			restore
			local vvit = `vvit' + 1	
		}
	}


	// estimation done, now create fpr, roc vars if requested

	// bskip indicates that variables should not be created
	// only turned on for parametric case before bootstrap

	if (`"`bskip'"' == "") {
		qui count if `di' == 1 & `touse'
		local nit = r(N)

		// now generate fpr and rocvars
		local vvit = 1
		foreach y of varlist `classvars' {
			//	pvc_classvar stores the percentile values
			//	roc_classvar will store the roc values

			//5 Create FPR/ROC values

			tempvar roc_`vvit'
			if(`"`link'"' != "") {
				local ic = colnumb(`eb',`"`y':i_cons"')
				local sc = colnumb(`eb',`"`y':s_cons"')
				local ifc 1-`pvc_`vvit''>=`a' 
				local ifc `ifc' & 1-`pvc_`vvit''<=`b'
				local ifc `touse' & (`ifc')
			}
			if (`"`link'"' == "") {
				qui gen double `roc_`vvit'' = .
				EmpRoc, fprval(`fpr_`vvit'') 	///
					rocval(`roc_`vvit'') 	///
					di(`di') 		///
					touse(`touse') 		///
					actvar(`y') 		///
					nval(`nit') 
			}

			else {
				if(`"`link'"'== "probit") {
					local lirc ///
						invnormal(1-`pvc_`vvit'') 
					local irc ///
						normal(`roc_`vvit'')
				}
				else {
					local lirc ///
						logit(1-`pvc_`vvit'') 
					local irc ///
						1/(1+exp(-`roc_`vvit''))

				}
				qui gen double `roc_`vvit''= ///
					`eb'[1,`ic'] + ///
					`eb'[1,`sc']*`lirc' ///
					if `ifc'
				if (`"`rocov'"'!= "") { 
					foreach var of varlist 	`roccov' {
						local coli = colnumb(`eb', ///
							`"`y':`var'"')
						qui replace `roc_`vvit'' = ///
							`roc_`vvit'' + 	   ///
							`eb'[1,`coli']*	   ///
							`var' if `ifc'
					}
				}
				qui replace `roc_`vvit'' = `irc'
			}
			
			
			// parametric roc vars created
			// now if parametric was not specified, 
			// we estimated non-parametric roc and fpr vars
			// bskip will never be turned on when fitting a 
			// nonparametric model

			// 6 Estimate ROC curve statistics
			local f: word count `roc'
			if (`f' > 0) {
				tempname rocest_`vvit'
				matrix `rocest_`vvit'' = J(1,`f',.)
				local i = 1
				foreach num of numlist `roc' {
					// Pepe 2003 
					// ROC = Sd1(Sd0^(-1)) 
					// sample survival fcns/quantiles
					// mirror definitions for cdf 
					qui sum `roc_`vvit'' if  ///
						(`di' == 1 & `touse') & ///
						1-`pvc_`vvit'' <= `num'
					matrix `rocest_`vvit''[1,`i'] = r(max)
					local i = `i'+1
				}

				tokenize `roc'
				local gn: word count `roc'
				forvalues i = 1/`gn' {
					local `i' = `"`y':roc_`i'"'
				}
				matrix colnames `rocest_`vvit'' = `*'
				if(`"`eb'"' != "") {
					matrix `eb' = `eb',`rocest_`vvit''
					tempname tempmat
					matrix `tempmat' = `rocest_`vvit''
					local i = 1
					foreach num of numlist `roc' {
						matrix `tempmat'[1,`i'] = `num'
					}
					matrix `eblegend' = ///
						`eblegend',`tempmat'
				}
				else {			
					tempname eb
					matrix `eb' = `rocest_`vvit''
					tempname eblegend
					matrix `eblegend' = `rocest_`vvit''
					local i = 1
					foreach num of numlist `roc' {
						matrix `eblegend'[1,`i']=`num'
						local i = `i' + 1
					}
				}		
			}
	
			local f: word count `invroc'
			if (`f' > 0) {
				tempname irt_`vvit'
				matrix `irt_`vvit'' = J(1,`f',.)
				local i = 1
				foreach num of numlist `invroc' {
					// Pepe 2003
					// ROC^-1 = sd0(sd1^-1)
					tempvar abc
					qui gen double `abc' = 1-`pvc_`vvit''
					qui sum `abc' if /// 
						(`di' == 1 & `touse') & ///
						`roc_`vvit''>= `num'
					matrix `irt_`vvit''[1,`i']=r(min)
					local i = `i' + 1
				}

				tokenize `invroc'
				local gn: word count `invroc'

				forvalues i = 1/`gn' {
					local `i' = `"`y':invroc_`i'"'
				}
				matrix colnames `irt_`vvit'' = `*'

				if(`"`eb'"' != "") {
					matrix `eb' = `eb',`irt_`vvit''
					tempname tempmat
					matrix `tempmat' = `irt_`vvit''
					local i = 1
					foreach num of numlist `invroc' {
						matrix `tempmat'[1,`i'] = `num'
						local i = `i' + 1
					}
					matrix `eblegend' = ///
						`eblegend',`tempmat'
 				}
				else {
					tempname eb
					matrix `eb' = `irt_`vvit''
					tempname eblegend
					matrix `eblegend' = `irt_`vvit''
					local i = 1
					foreach num of numlist `invroc' {
						matrix `eblegend'[1,`i'] ///
							= `num'
						local i = `i' + 1
					}
				}
			}
	
			local f: word count `pauc'
			if (`f' > 0) {
				tempname pt_`vvit'
				matrix `pt_`vvit'' = J(1,`f',.)
				local i = 1
				foreach num of numlist `pauc' {
					qui count if (`touse' & `di'==1)  ///
							& `pvc_`vvit''!=.
					local nit = r(N)

					// Dodd & Pepe 2003

					tempvar tmppvc_`vvit'
					qui gen double `tmppvc_`vvit'' = ///
						max(`pvc_`vvit''-(1-`num'),0)
					qui sum `tmppvc_`vvit'' ///
						if `touse' & `di'== 1
					matrix `pt_`vvit''[1,`i'] = r(mean)
					local i = `i' + 1
				}

				tokenize `pauc'
				local gn: word count `pauc'
				forvalues i = 1/`gn' {
					local `i' = `"`y':pauc_`i'"'
				}
				matrix colnames `pt_`vvit'' = `*'

				if(`"`eb'"' != "") {
					matrix `eb' = `eb',`pt_`vvit''
					tempname tempmat
					matrix `tempmat' = `pt_`vvit''
					local i = 1
					foreach num of numlist `pauc' {
						matrix `tempmat'[1,`i']=`num'
						local i = `i' + 1
					}
					matrix `eblegend'=`eblegend',`tempmat'
				}
				else {
					tempname eb
					matrix `eb' = `pt_`vvit''
					tempname eblegend
					matrix `eblegend' = `pt_`vvit''
					local i = 1
					foreach num of numlist `pauc' {
						matrix `eblegend'[1,`i']=`num'
						local i = `i' + 1	
					}
				}
			}
			if (`"`auc'"' != "") {
				tempname auc_`vvit'
				qui sum `pvc_`vvit'' if `di' == 1 & `touse'
				matrix `auc_`vvit'' = J(1,1,r(mean))
				matrix colnames `auc_`vvit'' = "`y':auc"
				if(`"`eb'"' != "") {
					matrix `eb' = `eb',`auc_`vvit''
				}
				else {
					tempname eb
					matrix `eb' = `auc_`vvit''
				}
			}

			//and return results in e(b)
			label variable `roc_`vvit'' `"TPR `y'"'
	
			if(`"`fpr_`y''"'=="") {
				//get FPR value from percentile values
				tempvar fpr_`vvit'
				qui gen double `fpr_`vvit'' = 1- `pvc_`vvit''
				label variable `fpr_`vvit'' `"FPR `y'"'
			}
			local vvit = `vvit' + 1
		}
		
		

		// 7 pass calculated fpr, roc values back to argument variables
		if (`"`fprvars'"' != "") {
			tokenize `fprvars'
			local i = 1
			local vvit = 1
			foreach y of varlist `classvars' {
				qui replace ``i'' = `fpr_`vvit''	
				local i = `i' + 1
				local vvit = `vvit' + 1
			}
		}
		if (`"`rocvars'"' != "") {
			tokenize `rocvars'
			local i = 1
			local vvit = 1
			foreach y of varlist `classvars' {
				qui	replace ``i'' = `roc_`vvit''	
				local i = `i' + 1
				local vvit = `vvit' + 1
			}
		}
	}

	// 8 post parameters
	if(`"`eb'"' != "") {
		if (`"`roccov'"'=="" & `"`link'"' != "") {
			// post AUC as parameter
			tempname AUCmat slope intercept
			local cvcnt: word count `classvars'
			matrix `AUCmat' = J(1,`cvcnt',.)
			local AUCmatnames 
			local i = 1
			foreach var of varlist `classvars' {
				scalar `slope'= ///
					`eb'[1,colnumb(`eb',`"`var':s_cons"')]
				scalar `intercept'= ///
					`eb'[1,colnumb(`eb',`"`var':i_cons"')]
				local AUCmatnames `AUCmatnames' `"`var':auc"'
				if (`"`link'"' == "probit") {			
					matrix `AUCmat'[1,`i'] = 	///
						normal(`intercept'/( 	///
						sqrt(1+(`slope'^2))))
				}
				local i = `i' + 1
			}
			matrix colnames `AUCmat' = `AUCmatnames'
			matrix `eb' = `eb',`AUCmat'
		}
		local np = colsof(`eb')
		qui ereturn post `eb', esample(`touse')
		qui ereturn local np= `np'
		if(`"`eblegend'"' != "") {
			qui ereturn hidden matrix blegend = `eblegend'
		}
	}
	else {
		qui ereturn post, esample(`touse')
		qui ereturn local np = 0
	}
end

program EmpRoc , sortpreserve 
	syntax [,	fprval(varname) /* store percentile values FPR
		*/ 	rocval(varname) /* will store ROC curve values TPR
		*/	di(varname)  	/* true status/disease variable
		*/	touse(varname)	/* use this data
		*/	actvar(varname)	/*
		*/	nval(string) ]
	// mark k
	//	.
	//	.
	// mark 1
	// fpr is P(y > i|D0)
	// tpr will be P(1-F0(y) <= c | D1)  1-pctval is our sample of 1-F0(y)
	tempvar oorder1
	qui gen `oorder1' = _n
	tempvar cdfemp
	qui bysort `touse' (`fprval' `oorder1'): ///
		gen `cdfemp' = sum(`di'==1) if `touse'
	qui bysort `touse' `fprval' (`cdfemp' `oorder1'): ///
		replace `cdfemp' =`cdfemp'[_N] if `touse'
	qui replace `rocval' = `cdfemp'/`nval'
end

program EmpPctVal, sortpreserve
	syntax [, pctval(varname) /* pre-perc value calculated in rocregstat				  *//* actual percentile value will 
			*/ /* be saved under same variable name  
			*/ di(varname) 	/* true status variable
			*/ touse(varname) /*
			*/ tiecorrected /* tie correction flag
			*/ covstrata(varlist) /* strata # of control adjt covs
			*/ covstrctrlcnt(varlist) /*count of # control cases in
			*/ nval(string)/*
			*/] 
	//mark k
	//      .
	//      .
	//mark 1
 	tempvar oorder1
	qui gen `oorder1' = _n
	tempvar sortpctval
	qui gen double `sortpctval' = - `pctval' if `touse' 
	tempvar cdfemp
	qui bysort `touse' `covstrata' (`sortpctval' `oorder1'): ///
		gen `cdfemp' = sum(`di'==0) if `touse'
	qui bysort `touse' `covstrata' `sortpctval' (`cdfemp' `oorder1'): ///
		replace `cdfemp'=`cdfemp'[_N] 
	if ("`tiecorrected'" != "") {
		tempvar tieADJ
			qui by `touse' `covstrata' `sortpctval': ///
			gen double `tieADJ' = sum(`di'==0) if `touse'
		qui bysort `touse' `covstrata' ///
			`sortpctval' (`tieADJ' `oorder1'): ///
			replace `tieADJ' = `tieADJ'[_N]/2 if `touse'
		local tieadj `"-`tieADJ'"'
	}
	
	if (`"`covstrctrlcnt'"' != "") {
		qui replace `pctval' = 1-(`cdfemp'`tieadj')/`covstrctrlcnt'
	}
	else {
		qui replace `pctval' = 1-(`cdfemp'`tieadj')/(`nval')
	}
	// mark k P(y>=k | D0)
	//	.
	//	.
	// mark 1 P(y>=1 | D0)
	// mark k P(y<k | D1)
	//      .
	//	.
	// mark 1 P(y<1 | D1)
end

exit

