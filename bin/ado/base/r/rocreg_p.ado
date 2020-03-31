*! version 1.0.2  22oct2018
program rocreg_p
	version 12

	if "`e(cmd)'" != "rocreg" | "`e(link)'" == ""  {
		error 301
	}

	syntax  newvarlist(min=1 max=1 numeric)  [if] [in], ///
			[roc 				///
			invroc		 		///
			pauc	 			///
			auc  				///
			at(varname)			///
			bfile(string) 			///
			classvar(varname) 		/// 
			Level(str) 			///
			se(string) 			///
			ci(string) 			///
			btype(string)			///
			intpts(integer 50) ] 

	// check syntax
	if ("`at'"!= "" & "`auc'"!= "") {
		di as err "{p 0 4 2}only one of at() or" 
		di as err " auc may be specified{p_end}"
		exit 198
	}
	local haslevel = "`level'"!=""
	if `haslevel' {
		capture confirm number `level'
		if _rc {
			di as err "`level' invalid for level()"
			exit 198
		}
		if !(`level'>=10 & `level' < 100) {
			di as err "level() must be between 10 and " ///
			"99.99 inclusive, with at most two decimal places"
			exit 198
		}
		if "`ci'" == "" {
			di as err "ci() must be specified if level() is" ///
				" specified"
			exit 198
		}
                local oldlevel = c(level)
                local oldlevel = string(`oldlevel',"%9.0g")
                set level `level'
                local level = string(`level',"%9.0g")
                qui set level `oldlevel'
	}
	else {
		local level = c(level)
                local level = string(`level',"%9.0g")
	}
	
	if ("`e(ml)'" != "") {
		if "`btype'" != "" {
			di as error "option btype() not allowed after" ///
				" ml estimation"
			exit 198
		}
		if "`bfile'" != "" {
			di as error "option bfile() not allowed after" ///
				" ml estimation"
			exit 198
		}
	}
	if ! inlist("`btype'","n","p","bc","") {
		di as error "btype() must be n, p, bc"
		exit 198
	}
	if "`bfile'" == "" & "`btype'" != "" {
		di as error "bfile() must be specified if btype() is specified"
		exit 198
	}

	if ("`e(ml)'" == "" & "`se'`ci'" != "" & "`bfile'"=="") {
		di as error "{p 0 4 2}bfile() needed for "
		di as error "standard error and confidence interval "
		di as error "prediction{p_end}"
		exit 198
	}

	local f: subinstr local 0 "intpts(" "", all
	if (`"`f'"' != `"`0'"') {
		if "`pauc'" =="" {
			di as error "pauc() must be specified if intpts()" ///
				" is specified"
			exit 198
		}
		if `intpts' <= 1 {
			di as error "intpts() must be greater than 1"
			exit 198
		}
	}	

	if ("`classvar'"=="") {
		local f= wordcount("`e(classvars)'")
		if `f' != 1 {
			di as err "previous estimates include multiple" ///
				" classifiers;"
			di as err "classvar() must be specified"
			exit 198
		}
	}

	if ("`auc'" != "" & "`roc'`invroc'`pauc'" != "") {
		di as error "{p 0 4 2}option auc invalid, only one of" ///
		di as error " auc, roc, invroc, pauc is allowed  {p_end}"
		exit 198
	}
	if ("`roc'" != "" & "`pauc'`invroc'`auc'" != "") {
		di as error "{p 0 4 2}option roc invalid, only one of" ///
		di as error " auc, roc, invroc, pauc is allowed  {p_end}"
		exit 198
	}
	if ("`invroc'" != "" & "`auc'`roc'`pauc'" != "") {
		di as error "{p 0 4 2}option invroc invalid, only one of" ///
		di as error " auc, roc, invroc, pauc is allowed  {p_end}"
		exit 198
	}
	if ("`pauc'" != "" & "`roc'`invroc'`auc'" != "") {
		di as error "{p 0 4 2}option pauc invalid, only one of" ///
		di as error " auc, roc, invroc, pauc is allowed  {p_end}"
		exit 198
	}

	local astat `roc'`invroc'`pauc'`auc'
	if `"`astat'"' == "" {
		di as text ///
			"(option {bf:auc} assumed; area under the ROC curve)"
		local auc auc
		local astat auc
	}
	if(`"`roc'"' != "") {
		if "`at'" == "" {
			di as error ///
"{p 0 4 2}at() must be specified if roc is specified{p_end}"
				exit 198  
		}
		local roc `at'
	}
	if (`"`invroc'"' != "") {
		local invroc `at'
		if "`at'" == "" {
			di as error ///
"{p 0 4 2}at() must be specified if invroc is specified{p_end}"
			exit 198 
		}
		local invroc `at'
	}
		if (`"`pauc'"' != "") {
			local pauc `at'
			if "`at'" == "" {
				di as error ///
"{p 0 4 2}at() must be specified if pauc is specified{p_end}"
				exit 198  
			}
		}
	
	if (`"`e(ml)'"' == "" & `"`ci'"' != "") {
		if(`"`btype'"' == "") {
			local btype n
		}
	}
	if "`btype'" != "" {
		local `btype' `btype'
	}

	if ("`auc'" != "" & "`e(roccov)'" == "") {
		di as error "{p 0 4 2}previous estimates do not " ///
			"involve ROC covariates;{p_end}"
		di as error "AUC already estimated"
		exit 198 
	}


	// set sample
	marksample touse, novarlist

	if("`roc'" != "") {
		qui replace `touse' = 0 if `roc' <= 0 | `roc' >=1
	}
	if("`invroc'" != "") {
		qui replace `touse' = 0 if `invroc' <= 0 | `invroc' >=1
	}		
	if("`pauc'" != "") {
		qui replace `touse' = 0 if `pauc' <= 0 | `pauc' >1
	}	
	if("`e(roccov)'" != "") {
		qui markout `touse' `e(roccov)'
	}

	tokenize `varlist'
	qui gen `typlist' `1' = .
	local predvar `1'
	local storeseci `typlist'
	if (upper(`"`astat'"') == "ROC") {
		local astat ROC
	}
	if (upper(`"`astat'"') == "INVROC") {
		local astat invROC	
	}
	if (upper(`"`astat'"') == "PAUC") {
		local astat pAUC	
	}
	if (upper(`"`astat'"') == "AUC") {
		local astat AUC	
	}

	local abbert =  `"`astat'"'
	label variable `predvar' `"`abbert'"'	

	if (`"`se'"' == "" & `"`ci'"' != "") {
		tempname frogurt
		local se `frogurt'
	}
	
	if (`"`se'"' != "") {
		qui capture gen `storeseci' `se' = .
		if (_rc > 0) {
			local rc = _rc
			drop `predvar'
			di as error "se() must be valid new variable"
			exit `rc'
		}
		local predse `se'
		label variable `predse' "`abbert' S.E."
	}
	if (`"`ci'"' != "") {
		if(`"`e(ml)'"'  == "") {
			foreach a in `n' `bc' `p' {
				qui capture gen `storeseci' `ci'_l = .
				local rc = _rc
				if(`"`a'"' == "p") {
					local lb `level'% percentile CI 
					local lb `lb', `abbert'
					label variable `ci'_l `"`lb'"' 
				}
				if(`"`a'"' == "n") {
					local lb `level'% normal based CI
					local lb `lb', `abbert'
					label variable `ci'_l `"`lb'"' 
				}
				if(`"`a'"' == "bc") {
					local lb `level'% bias-corrected CI
					local lb `lb', `abbert'
					label variable `ci'_l `"`lb'"' 
				}
				local `ci'_`a'l `ci'_l
				if(`rc' > 0) {
					drop `predvar'
					capture drop `predse'
					di as error ///
"{p 0 4 2}ci(`ci') invalid, `ci'_l must be valid new variable{p_end}"
					exit `rc'
				}
				qui capture gen `storeseci' `ci'_u = .
				local rc = _rc
				if(`"`a'"' == "p") {
					local lb `level'% percentile CI 
					local lb `lb', `abbert'
					label variable `ci'_u `"`lb'"' 
				}
				if(`"`a'"' == "n") {
					local lb `level'% normal based CI
					local lb `lb', `abbert'
					label variable `ci'_u `"`lb'"' 
				}
				if(`"`a'"' == "bc") {
					local lb `level'% bias-corrected CI
					local lb `lb', `abbert'
					label variable `ci'_u `"`lb'"' 
				}
				local `ci'_`a'u `ci'_u
				if(`rc' > 0) {
					drop `predvar'
					drop `ci'_l
					capture drop `predse'
					di as error ///
"{p 0 4 2}ci(`ci') invalid, `ci'_u must be valid new variable{p_end}"
					exit `rc'
				}
			}
		}
		else {
			qui capture gen `storeseci' `ci'_l = .
			local rc = _rc
			label variable `ci'_l `"`level'% CI, `abbert'"'
			local `ci'_l `ci'_l
			if(`rc' > 0) {
				drop `predvar'
				capture drop `predse'
				di as error ///
"{p 0 4 2}ci(`ci') invalid, `ci'_l must be valid new variable{p_end}"
				exit `rc'
			}
			qui capture gen `storeseci' `ci'_u = .
			local rc = _rc
			label variable `ci'_u `"`level'% CI, `abbert'"'
			local `ci'_u `ci'_u
			if(`rc' > 0) {
				drop `predvar'
				capture drop `predse'
				drop `ci'_l
				di as error ///
"{p 0 4 2}ci(`ci') invalid, `ci'_u must be valid new variable{p_end}"
				exit `rc'
			}

		}
	}

	if (`"`e(ml)'"' == "") {
		RocregPestat_Pred if `touse', 	classvar(`classvar') 	///
						predvar(`predvar')  	///
						predse(`predse')  	///
						roc(`roc') 		///
						invroc(`invroc') 	///
						pauc(`pauc') 		///
						`auc' 			///
						bfile(`bfile') 		///
						level(`level') 		///
						intpts(`intpts') 	///
						ci_N_l(``ci'_nl') 	///
						ci_N_u(``ci'_nu') 	///
						ci_P_l(``ci'_pl') 	///
						ci_P_u(``ci'_pu') 	///
						ci_BC_l(``ci'_bcl') 	///
						ci_BC_u(``ci'_bcu')
	}
	else {
		RocregPestat_Pred_ML if `touse', classvar(`classvar')   ///
						 predvar(`predvar')     ///
						 predse(`predse')       ///
						 roc(`roc') 	        ///
						 invroc(`invroc')       ///
						 pauc(`pauc')           ///	
						 `auc' 	                ///
						 level(`level') 	///
						 intpts(`intpts')       ///
						 ci_l(``ci'_l')         ///	
						 ci_u(``ci'_u')
	}
end

program RocregPestat_Pred 
	syntax [if] [in], 	[bfile(string)] 	///
				[roc(varname) 		///
				INVroc(varname) 	///
				pauc(varname) 		///
				auc 			///
				Level(cilevel)  	///
				intpts(integer 50) 	///
				classvar(varname) 	///
				predvar(varname) 	///
				predse(varname) 	///
				ci_N_l(varname) 	///
				ci_N_u(varname)		///
				ci_P_l(varname) 	///
				ci_P_u(varname)		///
				ci_BC_l(varname) 	///
				ci_BC_u(varname)]

	if (`"`bfile'"' != "") {
		RocregPestat_Pred_Bstat `0'
	}
	else {
		qui marksample touse
		if(`"`e(roccov)'"' != "") {
			markout `touse' `e(roccov)'
		}
		
		// no bootstraps
		if (`"`classvar'"' == "") {
			local cv `e(classvars)'
		}
		else {
			local cv `classvar'
		}

		capture assert (`intpts' > 1) 
		if (_rc != 0) {
			di as error "Specify # integration points > 1.
			exit 198
		}
 
		local classvars `cv'
		local cvcnt: word count `classvars'
		tempname bmat
		matrix `bmat' = e(b)
	
		local varit = 1
		// First get slope and intercept for later use
		foreach var in `classvars' {
			local vic = colnumb(`bmat',"`var':i_cons")
			local vsc = colnumb(`bmat',"`var':s_cons")
			tempvar slope_`varit' intercept_`varit'
			qui gen double `intercept_`varit'' = ///
				`bmat'[1,`vic'] if `touse'
			qui gen double `slope_`varit'' = ///
				`bmat'[1,`vsc'] if `touse'
			if(`"`e(roccov)'"' != "") {
				local a `e(roccov)'
				foreach ivar of local a {
					local icr "`var':`ivar'"
					local icr = colnumb(`bmat',"`icr'")
					qui replace `intercept_`varit'' = ///
						`bmat'[1,`icr']*`ivar'+   ///
						`intercept_`varit'' if `touse'
				}
			}
			local varit = `varit' + 1
		}
		local varit = 1
		foreach var in `classvars' {
			tempvar stat_`varit'
			if (`"`roc'"' != "") {
				if(`"`e(link)'"'=="probit") {
					qui gen double `stat_`varit'' =     ///
						normal(`intercept_`varit''+ ///
						`slope_`varit''*  	    ///
						invnormal(`roc')) if `touse'
				}
			}
			if (`"`invroc'"' != "") {
				if ("`e(link)'"=="probit") {
					qui gen double `stat_`varit'' =     ///
						normal((1/`slope_`varit'')* ///
						(invnormal(`invroc')-	    ///
						`intercept_`varit''))       ///
						if `touse' & ///
						`slope_`varit'' > 1e-10
				}
			}
			if (`"`pauc'"' != "") {
				qui gen double `stat_`varit'' = .
				qui count if `touse'
				local a = r(N)
				mata: matninteg(  		///
					"`stat_`varit''", 	///
					`"`intpts'"',	  	///	
					"0",		  	///
					"`pauc'",	  	///
					"`intercept_`varit''", 	///
					"`slope_`varit''",	///
					"`e(link)'",		///
					"`touse'",		///
					"`a'")
			}
			if (`"`auc'"' != "") {
				if(`"`e(link)'"' == "probit") {
					qui gen double `stat_`varit'' =     ///
						normal(`intercept_`varit''  ///
						/sqrt(1+((`slope_`varit'')^2)))
				}
			}
			local varit = `varit' + 1
		}
		qui replace `predvar' = `stat_1' if `touse'
	}
end

program RocregPestat_Pred_Bstat, sortpreserve
	version 12
	syntax [if] [in], 	[bfile(string)] 	///
				[roc(varname) 		///
				INVroc(varname) 	///
				pauc(varname) 		///
				auc 			///
				Level(cilevel) 		///
				intpts(integer 50) 	///
				classvar(varname) 	///
				predvar(varname) 	///
				predse(varname) 	///
				ci_N_l(varname) 	///
				ci_N_u(varname)		///
				ci_P_l(varname) 	///
				ci_P_u(varname) 	///
				ci_BC_l(varname) 	///
				ci_BC_u(varname)]

	if (`"`classvar'"' == "") {
		local cv `e(classvars)'
	}
	else {
		local cv `classvar'
	}

	capture assert (`intpts' > 1) 
	if (_rc != 0) {
		di as error "{p 0 4 2}intpts() must be greater than 1{p_end}"
		exit 198
	}
 
	local refvar	`"`e(refvar)'"'
	local classvars `cv'

	local classvarcnt: word count `classvars'
	local stat `roc' `invroc' `pauc' `auc'

	qui marksample touse
	if(`"`e(roccov)'"' != "") {
		markout `touse' `e(roccov)'
		local roccov `e(roccov)'
	}
	tempvar oorder
	gen `oorder' = _n
	gsort -`touse' `oorder'

	preserve

	qui count if `touse' 
	local ncovobs = r(N)

	// get covariate values in matrix
	if(`"`e(roccov)'"'!="") {
		tempname rocvarsmat
		qui mkmat `e(roccov)' if `touse', matrix(`rocvarsmat')
	}

	// get prediction inputs into matrices
	// there should be just one of roc, invroc, and pauc provided
	if (`"`roc'`invroc'`pauc'"' != "") {
		tempname imat
		qui mkmat `roc' `invroc' `pauc' if `touse', matrix(`imat')
	}

	// get matrices to hold other variables
	local blag `"`predse' `ci_N_l' `ci_N_u' `ci_P_l'"'
	local blag `"`blag' `ci_P_u' `ci_BC_l' `ci_BC_u'"'
	foreach lname of local blag {
		tempname `lname'mat
		matrix ``lname'mat' = J(`ncovobs',1,.)
	}

	// store intercept for later ease
	tempname intercept 
	matrix `intercept' = J(`ncovobs',`classvarcnt',.)

	// will use for intermediate storage
	tempname predna
	matrix `predna' = J(`ncovobs',`classvarcnt',.)
		
	qui use `bfile', clear

	local keeplist 
	foreach verb of varlist _all {
		local f: variable label `verb'
		local vvit = 1
		foreach var in `classvars' {
			if (`"`f'"' == `"[`var']_b[i_cons]"') {
				rename `verb' _v`vvit'_b_i_cons
				local keeplist `keeplist' _v`vvit'_b_i_cons
			}
			if (`"`f'"' == `"[`var']_b[s_cons]"') {
				rename `verb' _v`vvit'_b_s_cons
				local keeplist `keeplist' _v`vvit'_b_s_cons				
			}
			local rcit = 1
			foreach rocvar in `roccov' {
				if (`"`f'"' == `"[`var']_b[`rocvar']"') {
					rename `verb' _v`vvit'_b_`rcit'
					local keeplist ///
						`keeplist' _v`vvit'_b_`rcit'
				}
				local rcit = `rcit' + 1
			}
			local vvit = `vvit' + 1
		}
	}
	keep `keeplist'

	tempname bmat
	matrix `bmat' = e(b)

	forvalues j = 1/`ncovobs' {
		local varit = 1
		foreach var in `classvars' {	
			tempvar binterceptit_`j'_`varit'
			qui gen double `binterceptit_`j'_`varit'' ///
				= _v`varit'_b_i_cons
			matrix `intercept'[`j',`varit'] ///
				= `bmat'[1,colnumb(`bmat',"`var':i_cons")]
			if (`"`e(roccov)'"' != "") {
				local inames:colfullnames `rocvarsmat'
				local rcit = 1
				foreach ivar of local inames {
					local cib = ///
						colnumb(`rocvarsmat',"`ivar'")
					qui replace ///
						`binterceptit_`j'_`varit''= ///
						(_v`varit'_b_`rcit'*	    ///
						`rocvarsmat'[`j',`cib'])+   ///
						`binterceptit_`j'_`varit'' 
					local bcib = ///
						colnumb(`bmat',"`var':`ivar'")
					local cib = ///
						colnumb(`rocvarsmat',"`ivar'")
					matrix `intercept'[`j',`varit'] ///
						= `bmat'[1,`bcib'] * ///
						`rocvarsmat'[`j',`cib'] ///
						+ `intercept'[`j',`varit']
					local rcit = `rcit' + 1		
				}
			}
			local varit = `varit' + 1
		}
	}	

	if (`"`roc'"'!="") {
		forvalues j = 1/`ncovobs' {
			local varit = 1
			foreach var in `classvars' {
				if(`"`e(link)'"'=="probit") {
					qui gen double stat_`j'_`varit' =  ///
						normal( 		   ///
						`binterceptit_`j'_`varit'' ///
						+(_v`varit'_b_s_cons)*     ///
						invnormal(`imat'[`j',1]))
					local si = ///
						colnumb(`bmat',"`var':s_cons")
					matrix `predna'[`j',`varit'] =     ///
						normal( 		   ///
						`intercept'[`j',`varit'] + ///
						`bmat'[1,`si']*		   ///
						invnormal(`imat'[`j',1]))
				}
				local varit = `varit' + 1
			}
		}
	}

	if (`"`invroc'"'!="") {
		forvalues j = 1/`ncovobs' {
			local varit=1	
			foreach var in `classvars' {
				if ("`e(link)'"=="probit") {
					qui gen double stat_`j'_`varit' = ///
						normal( 		  ///
						(1/(_v`varit'_b_s_cons))* ///
						(invnormal(`imat'[`j',1]) ///
						-`binterceptit_`j'_`varit''))
					qui replace stat_`j'_`varit' = . ///
						if _v`varit'_b_s_cons < 1e-10	
					local si = ///
						colnumb(`bmat',"`var':s_cons")
					matrix `predna'[`j',`varit'] = 	  ///
						normal(			  ///
						(1/(`bmat'[1,`si']))* 	  ///
						(invnormal(`imat'[`j',1]) ///
						-`intercept'[`j',`varit']))
				}
				local varit = `varit' + 1
			}
		}
	}

	if(`"`pauc'"' != `""') {
		qui gen double scalepauc = .
		qui gen unom = 1
		forvalues j = 1/`ncovobs' {
			local varit = 1
			qui replace scalepauc = `imat'[`j',1]
			foreach var in `classvars' {
				qui gen double stat_`j'_`varit' = .	
				qui count
				local a = r(N)
				mata: matninteg( 			///
					`"stat_`j'_`varit'"', 		///
					`"`intpts'"',			///
					"0",				///
					"scalepauc",			///
					"`binterceptit_`j'_`varit''",	///
					`"_v`varit'_b_s_cons"',		///
					`"`e(link)'"',			///
					`"`unom'"',			///
					`"`a'"')
				tempname integralscalar slopescale intscale
				local si = colnumb(`bmat',"`var':s_cons")
				scalar `slopescale' = `bmat'[1,`si']
				scalar `intscale' = `intercept'[`j',`varit']
				scalar `integralscalar' = .
				tempname scalepaucinp
				scalar `scalepaucinp' = `imat'[`j',1]
				mata: ninteg( 			///
					"`integralscalar'",	///
					"`intpts'",		///
					"0",			///
					"`scalepaucinp'",	///
					"`intscale'",		///
					"`slopescale'",		///
					"`e(link)'")
				matrix `predna'[`j',`varit']=`integralscalar'
				local varit = `varit' + 1
			}
		}
	}

	if (`"`auc'"' != "") {
		qui gen uno = 1
		qui gen unus = 1
		forvalues j = 1/`ncovobs' {
			local varit = 1
			foreach var in `classvars' {
				qui gen double stat_`j'_`varit' = .
				qui count
				local a = r(N) 
				if (`"`e(link)'"' == "probit") {
					qui replace stat_`j'_`varit' = 	   ///
						normal(			   ///
						`binterceptit_`j'_`varit'' ///
						/sqrt(1+_v`varit'_b_s_cons^2))
				}
				tempname integralscalar slopescale intscale
				local si = colnumb(`bmat',"`var':s_cons")
				scalar `slopescale' = `bmat'[1,`si']
				scalar `intscale' = `intercept'[`j',`varit']
				scalar `integralscalar' = .
				tempname unusscal
				scalar `unusscal' = 1
				if (`"`e(link)'"'=="probit") {
					scalar `integralscalar' = normal( ///
					`intscale'/sqrt(1+`slopescale'^2))
				}
				matrix `predna'[`j',`varit']=`integralscalar'
				local varit = `varit' + 1
			}
		}
	}
	
	// now calculate std errors and confidence intervals

	local alpha = 1-(`level'/100)
	local ciuba = 1-(`alpha'/2)
	local cilba = `alpha'/2
	local tcilba = 100*`cilba' 
	local tciuba = 100*`ciuba'
	
	forvalues j=1/`ncovobs' {
		if(`"`ci_N_l'"' != "" | `"`predse'"' != "") {
			qui sum stat_`j'_1
			matrix ``predse'mat'[`j',1] = r(sd)
		}	
		qui count
		local N = r(N)
		if (`"`ci_N_l'"' != "") {
			matrix ``ci_N_l'mat'[`j',1]= 	///
				`predna'[`j',1] - 	///
				invnormal(`ciuba')*	///
				``predse'mat'[`j',1]
			matrix ``ci_N_u'mat'[`j',1] = 	///
				`predna'[`j',1] + 	///
				invnormal(`ciuba')*	///
				``predse'mat'[`j',1]	
		}
		if (`"`ci_P_l'"' != "") {
			qui _pctile stat_`j'_1, ///
				percentile(`tcilba' `tciuba')
			matrix ``ci_P_l'mat'[`j',1] = r(r1)
			matrix ``ci_P_u'mat'[`j',1] = r(r2)
		}
		if (`"`ci_BC_l'"' != "") {	
			qui count if stat_`j'_1 <= `predna'[`j',1]
			tempname z0
			scalar `z0' = invnormal(r(N)/_N)
			local p1 = 100*normal(`z0'+ ///
				(`z0'-invnormal(`ciuba')))
			local p2 = 100*normal(`z0'+ ///
			        (`z0'+invnormal(`ciuba')))
			if(`p1' == . | `p2' == .) {
				matrix ``ci_BC_l'mat'[`j',1] = .
				matrix ``ci_BC_u'mat'[`j',1] = .
			}
			else {
				qui _pctile stat_`j'_1, ///
					percentile(`p1' `p2')
				matrix ``ci_BC_l'mat'[`j',1] = r(r1)
				matrix ``ci_BC_u'mat'[`j',1] = r(r2)
			}
		}
	}
	
	restore
	// we already sorted on touse and passed those inputs
	// into earlier matrices
	tempname xiv
	local vlist `"`predse' `ci_N_l' `ci_N_u' `ci_P_l'"'
	local vlist `"`vlist' `ci_P_u' `ci_BC_l' `ci_BC_u'"'
	foreach var in `vlist' {
		matrix colnames ``var'mat' = `"`xiv'"'
		qui svmat double ``var'mat', names(col)
		qui replace `var' = `xiv'
		drop `xiv'
	}
	matrix colnames `predna' = `"`xiv'"'
	qui svmat double `predna', names(col)
	qui replace `predvar' = `xiv'
	drop `xiv'
end	

program RocregPestat_Pred_ML, sortpreserve
	version 12
	syntax [if] [in],	[roc(varname) 		///
				INVroc(varname) 	///
				pauc(varname) 		///
				auc 			///
				Level(cilevel) 		///
				intpts(integer 50) 	///
				classvar(varname) 	///
				predvar(varname) 	///
				predse(varname)		///
				ci_l(varname) 		///
				ci_u(varname)]

	if (`"`classvar'"' == "") {
		local cv `e(classvars)'
	}
	else {
		local cv `classvar'
	}

	capture assert (`intpts' > 1) 
	if (_rc != 0) {
		di as error "{p 0 4 2}intpts() must be greater than 1{p_end}"
		exit 198
	}
 
	local classvars `cv'
	qui marksample touse
	if(`"`e(roccov)'"' != "") {
		markout `touse' `e(roccov)'
	}
	qui count if `touse'
	local tousecnt = r(N)
	gsort -`touse'

	tempname rb rV	
	forvalues i = 1/`tousecnt' {
		if (`"`pauc'"' == "") {
			local var `classvars'
			if (`"`roc'"' != "") {
				RocMacro `e(roccov)', ///
					rocinput(`roc') ///
					classvar(`var') ///
					mind(`i')	
				local statmac `r(rocmacro)'
			}		
			if (`"`invroc'"' != "") {
				InvRocMacro `e(roccov)', 	///
					invrocinput(`invroc') 	///
					classvar(`var') 	///
					mind(`i')
				local statmac `r(invrocmacro)'
			}
			if (`"`auc'"' != "") {
				AucMacro `e(roccov)', 	///
					classvar(`var') ///
					mind(`i')
				local statmac `r(aucmacro)'				
			}
			qui nlcom `statmac'
			matrix `rb' = r(b)
			matrix `rV' = r(V)		
		}
		else {
			local var `classvars'
			Test_Pauc_Singular `e(roccov)', 	///
				paucinput(`pauc') 		///
				classvar(`var') 		///
				mind(`i') 			///
				intpts(`intpts')
			matrix `rb' = r(b)
			matrix `rV' = r(V)
		}
		if (`"`predvar'"' != "") {
			qui replace `predvar' = `rb'[1,1] if _n == `i'
		}
		if (`"`predse'"' != "") {
			qui replace `predse' = sqrt(`rV'[1,1]) if _n == `i'
		}
	
		local alpha = 1-(`level'/100)
		local ciuba = 1-(`alpha'/2)
		local cilba = `alpha'/2

		if (`"`ci_l'"' != "") {
			qui replace `ci_l' = `predvar' - ///
				`predse'*invnormal(`ciuba') if _n == `i'	
		}
		if (`"`ci_u'"' != "") {
			qui replace `ci_u' = `predvar' + ///
				`predse'*invnormal(`ciuba') if _n == `i' 
		}
	}	
end

// ml
// returns macro that can be evaluated by nlcom to test ROC(rocinput)
// only to be used on one observation at a time
program AucMacro, rclass
	version 12
	syntax [varlist(default=none)] , classvar(string) mind(string)
	local intt `"[`classvar']_b[i_cons]"'
	local slope `"[`classvar']_b[s_cons]"'
	marksample touse
	if (`"`varlist'"' != "") {
		foreach var of varlist `varlist' {
			local intt ///
				`"`intt'+[`classvar']_b[`var']*`var'[`mind']"'
		}
	}
	return local aucmacro `"normal((`intt')/sqrt(1+(`slope')^2))"'
end


// ml
// returns macro that can be evaluated by nlcom to test ROC(rocinput)
// only to be used on one observation at a time
program RocMacro, rclass
	version 12
	syntax [varlist(default=none)], rocinput(string) ///
					classvar(string) ///
					mind(string)
	local intt `"[`classvar']_b[i_cons]"'
	local slope `"[`classvar']_b[s_cons]"'
	marksample touse
	if (`"`varlist'"' != "") {
		foreach var of varlist `varlist' {
			local intt ///
				`"`intt'+[`classvar']_b[`var']*`var'[`mind']"'
		}
	}
	return local rocmacro ///
		`"normal(`intt' + `slope'*invnormal(`rocinput'[`mind']))"'
end

// ml
// returns macro that can be evaluated by nlcom to test INVROC(rocinput)
// only to be used on one observation at a time
program InvRocMacro, rclass
	version 12
	syntax [varlist(default=none)],	invrocinput(string) ///
					classvar(string)    ///
					mind(string)
	local intt `"[`classvar']_b[i_cons]"'
	local slope `"[`classvar']_b[s_cons]"'
	if (`"`varlist'"' != "") {
		foreach var of varlist `varlist' {
			local intt ///
				`"`intt'+[`classvar']_b[`var']*`var'[`mind']"'
		}
	}
	return local invrocmacro ///
	`"normal((invnormal(`invrocinput'[`mind'])-(`intt'))/(`slope'))"'
end

// ml
// returns the b and V matrices (actually scalars in this case) needed for
// wald tests of pauc at classvar
program Test_Pauc_Singular, rclass
	version 12
	syntax [varlist(default=none)],	paucinput(string)		///
					classvar(string) 		///
					mind(string) 			///
					[intpts(integer 50)] 
	local intt `"[`classvar']_b[i_cons]"'
	local slope `"[`classvar']_b[s_cons]"'
	if (`"`varlist'"' != "") {
		foreach var of varlist `varlist' {
			local intt ///
				`"`intt'+[`classvar']_b[`var']*`var'[`mind']"'
		}
	}
	tempname slopeval interceptval rb rv
	scalar `interceptval' = `intt'
	scalar `slopeval' = `slope'
	// get point estimate of pauc
	scalar `rb' = .
	tempname scalepaucinp
	scalar `scalepaucinp' = `paucinput'[`mind']
	mata: ninteg(	`"`rb'"',		///	
			"`intpts'",		///
			"0",			///
			`"`scalepaucinp'"',	///
			"`interceptval'",	///
			"`slopeval'",		///
			"`e(link)'")
	local f: word count `varlist'			
	// now formulate Derivative matrix for delta method  
	// note that we only need alpha parameters and coefficients
	// other terms (if auc is there for marginal model) 
	// are just generated parameters from these

	tempname orb orV
	matrix `orb' = e(b)
	mata: getlabelsright("`orb'")
	matrix `orV' = e(V)
	mata: getlabelsrightC("`orV'")

	tempname Dmat
	matrix `Dmat' = J(1,colsof(`orb'),0)
	local f: colfullnames `orb'
	matrix colnames `Dmat' = `f'

	tempname tdint
	scalar `tdint' = .
	// get d theta intercept
	mata: dxninteg(	`"`tdint'"', 		///
			"`intpts'",		///
			"0",			///
			`"`scalepaucinp'"',	///
			"`interceptval'",	///
			"`slopeval'")

	tempname tdalpha
	scalar `tdalpha' = .
	// get d alpha
	mata: dalphaninteg(	`"`tdalpha'"', 		///
				"`intpts'",		///
				"0",			///
				`"`scalepaucinp'"',	///
				"`interceptval'",	///
				"`slopeval'")
	if (`"`varlist'"' != "") {
		foreach var of varlist `varlist' {
			local Dmi=colnumb(`Dmat',`"`classvar':`var'"')
			matrix `Dmat'[1,`Dmi'] = ///
				`tdint'*`var'[`mind']
		}
	}
	matrix `Dmat'[1,colnumb(`Dmat',`"`classvar':i_cons"')] = `tdint'
	matrix `Dmat'[1,colnumb(`Dmat',`"`classvar':s_cons"')] = `tdalpha'

	matrix `rv' = `Dmat' * `orV' * (`Dmat'')
	matrix `rb' = (`rb')
	matrix colnames `rb' = "`classvar'"
	matrix colnames `rv' = "`classvar'"
	matrix rownames `rv' = "`classvar'"
	return matrix b = `rb'
	return matrix V = `rv'
end

// ml
// returns the b and V matrices needed for
// wald tests of pauc over classvars
program Test_Pauc, rclass
	version 12
	syntax [varlist(default=none)],	paucinput(string)	///
					mind(string) 		///
					[intpts(integer 50)] 
	tempname orb orV
	matrix `orb' = e(b)
	mata: getlabelsright("`orb'")
	matrix `orV' = e(V)
	mata: getlabelsrightC("`orV'")

	tempname rb rV

	local f: word count `e(classvars)'
	matrix `rb' = J(1,`f',.)
	matrix colnames `rb' = `e(classvars)'

	tempname Dmat
	matrix `Dmat' = J(`f',colsof(`orb'),0)
	local f: colfullnames `orb'
	matrix colnames `Dmat' = `f'
	matrix rownames `Dmat' = `classvars'

	local cvit = 1
	foreach classvar of varlist `e(classvars)' {
		local intt `"[`classvar']_b[i_cons]"'
		local slope `"[`classvar']_b[s_cons]"'
		if (`"`varlist'"' != "") {
			foreach var of varlist `varlist' {
				local tm [`classvar']_b[`var']
				local tm `tm'*`var'[`mind']
				local intt `"`intt'+`tm'"'
			}
		}
		tempname slopeval interceptval rbpt
		scalar `interceptval' = `intt'
		scalar `slopeval' = `slope'
		// get point estimate of pauc
		scalar `rbpt' = .
		tempname scalepaucinp
		scalar `scalepaucinp' = `paucinput'[`mind']
		mata: ninteg(	`"`rbpt'"',		///
				"`intpts'",		///
				"0",			///
				`"`scalepaucinp'"',	///
				"`interceptval'",	///
				"`slopeval'",		///
				"`e(link)'")
		tempname tdint
		scalar `tdint' = .
		// get d theta intercept
		mata: dxninteg(	`"`tdint'"',		///
				"`intpts'",		///
				"0",			///
				`"`scalepaucinp'"',	///
				"`interceptval'",	///
				"`slopeval'")
		tempname tdalpha
		scalar `tdalpha' = .
		// get d alpha
		mata: dalphaninteg(	`"`tdalpha'"', 		///
					"`intpts'",		///
					"0",			///
					`"`scalepaucinp'"',	///
					"`interceptval'",	///
					"`slopeval'")
		if(`"`varlist'"' != "") {
			foreach var of varlist `varlist' {
				matrix `Dmat'[`cvit', ///
					colnumb(`Dmat', ///
					`"`classvar':`var'"')] = ///
					`tdint'*`var'[`mind']
			}
		}
		matrix `Dmat'[`cvit', ///
		 	colnumb(`Dmat',`"`classvar':i_cons"')] = `tdint'
		matrix `Dmat'[`cvit', ///
			colnumb(`Dmat',`"`classvar':s_cons"')] = `tdalpha'
		matrix `rb'[1,`cvit'] = `rbpt'
		local cvit = `cvit' + 1
	}

	matrix `rV' = `Dmat' * `orV' * (`Dmat'')
	matrix colnames `rV' = `e(classvars)'
	matrix rownames `rV' = `e(classvars)'
	return matrix b = `rb'
	return matrix V = `rV'
end

mata:

void matninteg(	string scalar scalstorinvar, 	
		string scalar integpoints, 	
		string scalar a, 		
		string scalar paucinpvar, 	
		string scalar scalinterceptvar,	
		string scalar scalslopevar, 
		string scalar link, 		
		string scalar selectvar, 	
		string scalar selectvarcnt) {

	real scalar npoints, lb, ntouse
	real matrix mslope, mintercept, mpaucval, mscalstorinvar
	real scalar i, ub, intercept, slope, dist, intinc
	real matrix x, y 

	npoints = strtoreal(integpoints)
	lb = strtoreal(a)
	ntouse = strtoreal(selectvarcnt)
	mslope= J(ntouse,1,.)
	mintercept= J(ntouse,1,.)
	mpaucval = J(ntouse,1,.)
	mscalstorinvar = J(ntouse,1,.)
	st_view(mintercept,.,scalinterceptvar,selectvar)
	st_view(mslope,.,scalslopevar,selectvar)
	st_view(mpaucval,.,paucinpvar,selectvar)
	st_view(mscalstorinvar,.,scalstorinvar,selectvar)
	for (i=1;i<=ntouse;i++) {
		ub = mpaucval[i,1]
		intercept = mintercept[i,1]
		slope = mslope[i,1]
		dist = ub - lb
		intinc = dist/(npoints-1)
		x = (1::npoints) :- 1
		x = (x:*intinc):+lb
		if(link == "logit") {
			y = invlogit((logit(x):*slope):+intercept)
		}
		else {
			y =  normal((invnormal(x):*slope) :+ intercept)
		}
		if (x[1,1] == 0) {
			y[1,1] = 0
		}
		if (x[npoints,1] == 1) {
			y[npoints,1] = 1
		}
		mscalstorinvar[i,1] =tintreg(x,y)

		if (slope==.) {
			mscalstorinvar[i,1] =.
		}
                if (intercept==.) {
                        mscalstorinvar[i,1] =.
                }

	}
}

// ml
// for pauc derivative, multiply integral by xvals, along with intercept
void dxninteg(	string scalar scalstorin, 	
		string scalar integpoints, 	
		string scalar a, 		
		string scalar paucinp, 		
		string scalar scalintercept, 	
		string scalar scalslope) {

	real scalar npoints, lb, ub, intercept, slope, dist, intinc, s
	real matrix x, y

	npoints = strtoreal(integpoints)
	lb = strtoreal(a)
	ub = st_numscalar(paucinp)
	intercept = st_numscalar(scalintercept)
	slope = st_numscalar(scalslope)

	dist = ub - lb
	intinc = dist/(npoints-1)
	x = (1::npoints) :- 1
	x = (x:*intinc):+lb

	// droc intercept
	// normaldens(x+sx*invnormal(u))*value at x

	y =  normalden((invnormal(x):*slope) :+ intercept)

	// see notes, density invoked at distant points

	if (x[1,1] == 0) {
		y[1,1] = 0
	}
	if (x[npoints,1] == 1) {
		y[npoints,1] = 0
	}

	s = tintreg(x,y)
        if (slope==.) {
             s =.
        }
        if (intercept==.) {
             s =.
        }

	st_numscalar(scalstorin, s)
}

// ml
// last component of derivative
void dalphaninteg(string scalar scalstorin,     
                  string scalar integpoints, 
		  string scalar a, 
		  string scalar paucinp, 
		  string scalar scalintercept, 
		  string scalar scalslope) {

	real scalar npoints, lb, ub, intercept, slope, dist, intinc, s
	real matrix x, y

	npoints = strtoreal(integpoints)
	lb = strtoreal(a)
	ub = st_numscalar(paucinp)
	intercept = st_numscalar(scalintercept)
	slope = st_numscalar(scalslope)

	// so we'll have integpoints - 2 interior points at which we 
	// integrate leading to integpoints-1 interior equal intervals

	dist = ub - lb
	intinc = dist/(npoints-1)
	x = (1::npoints) :- 1
	x = (x:*intinc):+lb

	// droc intercept

	y =  normalden((invnormal(x):*slope) :+ intercept):*invnormal(x)

	// see notes, boils down to ratio of invnormal to e^(invnormal)^2,  
	// squaring means that bound
	// behavior the same at 0,1

	if (x[1,1] == 0) {
		y[1,1] = 0
	}
	if (x[npoints,1] == 1) {
		y[npoints,1] = 0
	}

	s = tintreg(x,y)

        if (slope==.) {
             s =.
        }
        if (intercept==.) {
             s =.
        }

	st_numscalar(scalstorin, s)
}

void ninteg(	string scalar scalstorin, 	
		string scalar integpoints, 	
		string scalar a, 		
		string scalar paucinp, 	
		string scalar scalintercept, 	
		string scalar scalslope, 	
		string scalar link) { 

	real scalar npoints, lb, ub, intercept, slope, dist, intinc, s
	real matrix x, y

	npoints = strtoreal(integpoints)
	lb = strtoreal(a)
	ub = st_numscalar(paucinp)
	intercept = st_numscalar(scalintercept)
	slope = st_numscalar(scalslope)
	dist = ub - lb
	intinc = dist/(npoints-1)
	x = (1::npoints) :- 1
	x = (x:*intinc):+lb

	if(link == "logit") {
		y = invlogit( (logit(x):*slope):+intercept)
	}
	else {
		y =  normal((invnormal(x):*slope) :+ intercept)
	}
	if (x[1,1] == 0) {
		y[1,1] = 0
	}
	if (x[npoints,1] == 1) {
		y[npoints,1] = 1
	}

	s = tintreg(x,y)

        if (slope==.) {
            s =.
        }
        if (intercept==.) {
            s =.
        }

	st_numscalar(scalstorin, s)
}

// numeric integration
// parametric AUC (logit,  normal is defined pepe 2003
// pAUC logit and normal (no closed form for normal, Pepe 2003)

real scalar tintreg(real matrix x, real matrix y) {
	real scalar n

	n = length(x)
	return(colsum(((x[2::n,.]-x[1::(n-1),.])
	       :*(y[2::n,.]+y[1::(n-1),.]))[1::(n-1),.]:/2))
}

void getlabelsright(string scalar mat) {
	real matrix X, s, xlist
	real scalar i

	X = st_matrix(mat)
	s = st_matrixcolstripe(mat)
	xlist = J(1,0,.)
	for(i=1;i<=cols(X);i++) { 	
			if (s[i,2] != "auc") {
				xlist = xlist,i;
			}
	}

	s = s[xlist,(1,2)]
	X = X[1,xlist]
	st_matrix(mat,X)
	st_matrixcolstripe(mat,s)
}

void getlabelsrightC(string scalar mat) {
	real matrix X, s, xlist
	real scalar i

	X = st_matrix(mat)
	s = st_matrixcolstripe(mat)
	xlist = J(1,0,.)
	for(i=1;i<=cols(X);i++) { 
		if (s[i,2] != "auc") {
			xlist = xlist,i;
		}
	}
	
	s = s[xlist,(1,2)]
	X = X[xlist,xlist]

	st_matrix(mat,X)
	st_matrixcolstripe(mat,s)
	st_matrixrowstripe(mat,s)
}

end

exit
