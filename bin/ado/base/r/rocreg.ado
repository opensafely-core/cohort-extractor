*! version 1.2.0  12apr2018
program rocreg, eclass sortpreserve
	version 12
	if replay() {
		if "`e(cmd)'" != "rocreg" {
			error 301
		}
		if (`"`e(link)'"'!="") {
			DisplayP `0'
			
		}
		else {
			qui capture DisplayNP `0'	
			if (_rc) {
				di as error "last estimates nonparametric;"
				DisplayNP `0'
			}
			DisplayNP `0'
		}

		exit
	}
	capt drop _fpr_* 
	capt drop _roc_*
	Estimate `0'
end

program Estimate, eclass sortpreserve
	syntax varlist [if] [in] [fweight iweight pweight] ///
		[, 	auc				///	
			roc(numlist) 			///
			invroc(numlist) 		///
			pauc(numlist) 			///
			roccov(varlist) 		///	
			probit				///
			FROM(string)			///
			fprpts(str)	 		///
			CTRLFPRall			///
			ml				///
			ctrlcov(varlist) 		///	
			CTRLMODel(string) 		///	  
			pvc(string) 			///
			TIECorrected 			///
			Level(cilevel) 			///
			BREPs(str)	  		///
			BFILE(str)			///
			bseed(string)			///
			noBOOTstrap 			///
			bootcc 				///
			noBSTRata 			///
			CLuster(varlist) 		///
			bsave(string)			///
			noDOTS				///
			srobust		/* nodoc */     ///
			NOLOg LOg *]

	// 0 check syntax
	local rocregcmd rocreg `0'
	local vars `varlist'
	local VARLIST: copy local varlist
	local IF: copy local if
	local IN: copy local in
	local WEIGHT: copy local weight
	local EXP: copy local exp


	local isml = "`ml'" != "" 

	// special error for replay argument
	if "`bfile'" != "" {
		di as err "option bfile() is only allowed when replaying" ///
			" rocreg results"
		exit 198
	}


	// check numeric arguments breps, fprpts	
	if "`breps'" != "" {
		local hasbreps 1
		capture confirm integer number `breps'
		if _rc {
			di as err "breps() must be an integer greater" ///
				" than one"
			exit 198
		}
		if `breps' <= 1 {
			di as err "breps() must be an integer greater" ///
				" than one"
			exit 198
		}
	}
	else {
		local hasbreps 0
		local breps 1000
	}
	if "`fprpts'" != "" {
		local hasfpr 1
		capture confirm integer number `fprpts'
		if _rc {
			di as err "fprpts() must be an integer greater" ///
				" than one"
			exit 198
		}
		if `fprpts' < 1 {
			di as err "fprpts() must be an integer greater" ///
				" than one"
			exit 198
		}
	}
	else {
		local hasfpr 0
		local fprpts 10
	}
	
	if `hasfpr' {
		if "`probit'" == "" {
			di as err ///
			"{p 0 4 2}probit must be specified if fprpts() is " ///
			"specified{p_end}"
			exit 198
		}
		if "`ctrlfprall'" != "" {
			di as err "{p 0 4 2}only one of fprpts() or" 
			di as err " ctrlfprall may be specified{p_end}"
			exit 198
		}
	}

	// check parametric options ctrlfprall, roccov, probit, pvc
	if "`ctrlfprall'" != "" & "`probit'" == "" {
        	di as err "{p 0 4 2}probit must be specified if" 
		di as err "ctrlfprall is specified{p_end}"
                exit 198
	}
	if "`probit'" != "" {
		local link "probit"
	}
	if "`roccov'" != "" & "`probit'" == "" {
		di as error "probit must be specified if roccov() is specified"
		exit 198
	}
	if("`pvc'" == "normal" & "`tiecorrected'" != "") {
		di as error "{p 0 4 2}only one of tiecorrected or"
		di as error " pvc(normal) may be specified{p_end}"
		exit 198
	}

	// initialize for ml log
	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	local qn = cond("`log'"=="nolog","qui","noi ")

	// check for duplicate variables
	local fa `vars'
	local uvar: list uniq fa
	if ("`uvar'" != "`vars'") {
		di as err "duplicated variables in varlist"
		exit 198
	}
	if "`ctrlcov'" != "" {
		local ucvar: list uniq ctrlcov
		if ("`ctrlcov'" != "`ucvar'") {
			di as err "duplicated variables in ctrlcov()"
			exit 198
		}	
	}
	if "`roccov'" != "" {
		local ucrc: list uniq roccov
		if ("`roccov'" != "`ucrc'") {
			di as err "duplicated variables in roccov()"
			exit 198
		}	
	}

	// check if ml when from, weights, log/nolog
        if !`isml' & "`from'" != "" {
                di as err "{p 0 4 2}ml must be specified if from() "
                di as err "is specified{p_end}"
                exit 198
        }
	if !`isml' & "`weight'" != "" {
		di as err "{p 0 4 2}ml must be specified if weights "
		di as err " are specified{p_end}"
		exit 198
	}
	if "`from'" == "" & `isml' {
		local mlsearch search(off)
	}
	local f: subinstr local 0 "log" "", word
	if "`f'" != "`0'" & !`isml' {
                di as err "{p 0 4 2} ml must be specified if log"
                di as err " is specified {p_end}"
                exit 198
        }
	local f: subinstr local 0 "nolog" "", word
	if "`f'" != "`0'" & !`isml' {
                di as err "{p 0 4 2} ml must be specified if nolog"
                di as err " is specified{p_end}"
                exit 198
        }

	// expand abbreviations
	local a = length(`"`pvc'"')
	if (`a' > 0) {
		if (abbrev(`"`pvc'"',`a')==abbrev("empirical",`a')) {
			local pvc empirical
		}
		if (abbrev(`"`pvc'"',`a')==abbrev("normal",`a')) {
			local pvc normal
		}
	}
	local a = length(`"`ctrlmodel'"') 
	if (`a' > 0) {
		if (abbrev(`"`ctrlmodel'"',`a')==abbrev("strata",`a')) {
			local ctrlmodel strata
		}
		if (abbrev(`"`ctrlmodel'"',`a')==abbrev("linear",`a')) {
			local ctrlmodel linear
		}
	}


	// check that ROC statistics not specified when probit
	local isprobit = "`probit'"!=""
	if (`isprobit' & !`isml') {
	        if "`auc'" != "" {
        	        di as err "{p 0 4 2}only one of auc or probit"
                	di as err " may be specified{p_end}"
	                exit 198
 		}
	        if "`roc'" != "" {
        	        di as err "{p 0 4 2}only one of roc() or probit"
                	di as err " may be specified{p_end}"
	                exit 198
 		}
	        if "`invroc'" != "" {
        	        di as err "{p 0 4 2}only one of invroc() or probit"
                	di as err " may be specified{p_end}"
	                exit 198
 		}
	        if "`pauc'" != "" {
        	        di as err "{p 0 4 2}only one of pauc() or probit"
                	di as err " may be specified{p_end}"
	                exit 198
 		}       	       	
	}
	// check that bsave only specified when probit
	if (!`isprobit') {
		if "`bsave'" != "" {
			di as err "probit must be specified if bsave()" ///
			" is specified"
			exit 198
		}
	}
	// check that illegal options not specified with ml
	if `isml' {
		if "`probit'" == "" {
			di as err "probit must be specified if ml" ///
			" is specified"
			exit 198
		}
	        if "`auc'" != "" {
        	        di as err "{p 0 4 2}only one of auc or probit"
                	di as err " may be specified{p_end}"
	                exit 198
 		}
	        if "`roc'" != "" {
        	        di as err "{p 0 4 2}only one of roc() or probit"
                	di as err " may be specified{p_end}"
	                exit 198
 		}
	        if "`invroc'" != "" {
        	        di as err "{p 0 4 2}only one of invroc() or probit"
                	di as err " may be specified{p_end}"
	                exit 198
 		}
	        if "`pauc'" != "" {
        	        di as err "{p 0 4 2}only one of pauc() or probit"
                	di as err " may be specified{p_end}"
	                exit 198
 		}      
		if "`tiecorrected'"!="" {
			di as err "only one of tiecorrected or ml" ///
				" may be specified"
			exit 198
		}
	        if "`ctrlfprall'" != "" {
        	        di as err "{p 0 4 2}only one of ctrlfprall or" ///
				" ml may be specified{p_end}"
	                exit 198
	        }
        	if `hasfpr' {
	        	di as err "{p 0 4 2}only one of fprpts() or ml"
        		di as err " may be specified{p_end}"
                	exit 198
		}
		if "`pvc'" == "empirical" {
			di as err "pvc(empirical) not allowed with ml; "
			di as err "specify pvc(normal) instead"
			exit 198
		}
		// not allowed with bootstrap options: breps(), bseed(), 
		// bootcc, nobstrata, nodots, bsave(), nobootstrap
		if `hasbreps' {
	                di as err "{p 0 4 2}only one of breps() or ml may be"
        	        di as err " specified{p_end}"
                	exit 198
		}
	        if "`bseed'" != "" {
        	        di as err "{p 0 4 2}only one of bseed() or ml"
                	di as err " may be specified{p_end}"
	                exit 198
 		}       	
        	if "`bootcc'"!="" {
	                di as err "only one of bootcc or ml may be specified"
        	        exit 198
	        }
		if "`bstrata'" != "" {
        	        di as err "{p 0 4 2}only one of nobstrata or ml"
                	di as err " may be specified{p_end}"
	                exit 198
		}
		local f: subinstr local 0 "bstr" "", word
		local isbstrata = "`f'" != "`0'"
		local f: subinstr local 0 "bstra" "", word
		local isbstrata = `isbstrata' | ("`f'" != "`0'")
		local f: subinstr local 0 "bstrat" "", word
		local isbstrata = `isbstrata' | ("`f'" != "`0'")	
		local f: subinstr local 0 "bstrata" "", word
		local isbstrata = `isbstrata' | ("`f'" != "`0'")		
		if `isbstrata' {
        	        di as err "{p 0 4 2} only one of bstrata or"
	                di as err " ml may be specified{p_end}"
        	        exit 198
	        }
        	if "`dots'" != "" {
                	di as err "{p 0 4 2}only one of nodots or ml"
	       		di as err " may be specified{p_end}"
        		exit 198
		}
		local f: subinstr local 0 "dots" "", word
		if "`f'" != "`0'" {
	                di as err "{p 0 4 2} only one of dots or"
	                di as err " ml may be specified{p_end}"
        	        exit 198
	        }

		if "`bsave'" != "" {
	        	di as err "{p 0 4 2}only one of bsave() or ml"
        		di as err " may be specified{p_end}"
                	exit 198
		}
		if "`bootstrap'" != "" {
	        	di as err "{p 0 4 2}only one of nobootstrap or ml"
        		di as err " may be specified{p_end}"
                	exit 198
		}
		local f: subinstr local 0 "boot" "", word
		local isboot = "`f'" != "`0'"
		local f: subinstr local 0 "boots" "", word
		local isboot = `isboot' | ("`f'" != "`0'")
		local f: subinstr local 0 "bootst" "", word
		local isboot = `isboot' | ("`f'" != "`0'")	
		local f: subinstr local 0 "bootstr" "", word
		local isboot = `isboot' | ("`f'" != "`0'")
		local f: subinstr local 0 "bootstra" "", word
		local isboot = `isboot' | ("`f'" != "`0'")
		local f: subinstr local 0 "bootstrap" "", word
		local isboot = `isboot' | ("`f'" != "`0'")	
		if `isboot' {
	                di as err "{p 0 4 2} only one of bootstrap or "
                	di as err " ml may be specified{p_end}"
        	        exit 198
	        }
	}
	// bootstrap options can't be specified with nobootstrap
	if "`bootstrap'" == "nobootstrap" {
		// not allowed with bootstrap options: breps(), bseed(), 
		// bootcc, nobstrata, nodots, bsave()
        	if `hasbreps' {
	                di as err "{p 0 4 2}only one of breps() or"
        	        di as err " nobootstrap may be specified{p_end}"
			exit 198
	        }
        	if "`bseed'" != "" {
	                di as err "{p 0 4 2}only one of bseed() or"
        	        di as err " nobootstrap may be specified{p_end}"
			exit 198
	        }
	        if "`bootcc'" != "" {
			di as err "{p 0 4 2}only one of bootcc or"
        	        di as err " nobootstrap may be specified{p_end}"
			exit 198	                
	        }
	        if "`bstrata'" != "" {
			di as err "{p 0 4 2}only one of nobstrata or"
        	        di as err " nobootstrap may be specified{p_end}"
			exit 198	                
	        }
		local f: subinstr local 0 "bstr" "", word
		local isbstrata = "`f'" != "`0'"
		local f: subinstr local 0 "bstra" "", word
		local isbstrata = `isbstrata' | ("`f'" != "`0'")
		local f: subinstr local 0 "bstrat" "", word
		local isbstrata = `isbstrata' | ("`f'" != "`0'")	
		local f: subinstr local 0 "bstrata" "", word
		local isbstrata = `isbstrata' | ("`f'" != "`0'")		
		if `isbstrata' {
        	        di as err "{p 0 4 2} only one of bstrata or"
	                di as err " nobootstrap may be specified{p_end}"
        	        exit 198
	        }
        	if "`dots'" != "" {
	                di as err "{p 0 4 2}only one of nodots or"
        	        di as err " nobootstrap may be specified{p_end}"
			exit 198
	        }
		local f: subinstr local 0 "dots" "", word
		if "`f'" != "`0'" {
	                di as err "{p 0 4 2} only one of dots or"
	                di as err " nobootstrap may be specified{p_end}"
        	        exit 198
	        }
        	if "`bsave'" != "" {
	                di as err "{p 0 4 2}only one of bsave() or"
        	        di as err " nobootstrap may be specified{p_end}"
			exit 198
	        }
        }
	if ("`ctrlcov'" != "" & ("`ml'`ctrlmodel'"== "")) {
		local ctrlmodel strata
	}
	
	tokenize `vars'
	local refvar `1'

	// make sure that display options are only specified for ml
	_get_diopts diopts mlopts, `options'
	if (length("`diopts'") > 0 | "`log'" == "nolog") & !`isml' {
		di as err "ml must be specified if display options" ///
			" are specified"
		exit 198
	}
	// they are, now parse them 
	local 0 ",`diopts'"
	syntax [,			///
		NOOMITted		///
		OMITted			///
		NOLSTRETCH		///
		LSTRETCH		///
		cformat(string)		///
		sformat(string)		///
		pformat(string)		///
		]


	//make sure that only ml opts are passed in
	// need to let mlopts contain `mllog' so -log- overwrites c(iterlog)
	// in -ml model-
	mlopts mlopts rest, `mlopts' `mllog'
	
	if length("`mlopts'") > 0 & !`isml' {
		di as err "ml must be specified if maximize options" ///
			" are specified"
		exit 198
	}
	if "`s(constraints)'" != "" {
		di as err "constraints() not allowed with rocreg"
		exit 198
	}
	
	// they are, now parse them
	local 0 ",`mlopts'"
	syntax [,				///
		TECHnique(passthru)		///
		noCNSNOTEs			///
		VCE(passthru)			///
		*				///
		]
	if ("`technique'" == "technique(bhhh)") {
		di as err "technique(bhhh) not allowed with rocreg"
		exit 198
	}
	if ("`vce'" != "" ) { 
		di as err "vce() not allowed with rocreg"
		exit 198
	}
	if ("`cnsnotes'" != "" ) {
		di as err "nocnsnotes not allowed with rocreg"
		exit 198
	}
	// catch any illegal options
	local 0 ", `rest' `ml'"
	syntax [, ML ] 


	// check proper variable types
	confirm numeric variable `vars'
	
	if ("`ctrlcov'" != "") {
		confirm numeric variable `ctrlcov'
	}
	if ("`roccov'" != "") {
		confirm numeric variable `roccov'
	}	

	// check ctrlmodel, ctrlcov
	if "`ctrlmodel'" != "" & "`ctrlcov'" == "" {
		di as err "{p 0 4 2}ctrlcov() must be specified if" 
		di as err " ctrlmodel() is specified{p_end}"
		exit 198
	}
	local modlinear = bsubstr("linear",1,length("`ctrlmodel'"))	
	local modstrata = bsubstr("strata",1,length("`ctrlmodel'"))	
	if "`ctrlcov'" != "" {
		if !(inlist("`ctrlmodel'","","`modlinear'","`modstrata'")) {
			di as err "ctrlmodel(`ctrlmodel') invalid;"
			di as err "ctrlmodel() must be linear or strata"
			exit 198
		}
	}
	if (`isml' & !(inlist("`ctrlmodel'","","`modlinear'"))) {
		di as err "ctrlmodel(`ctrlmodel') not allowed with ml;"
		di as err "specify ctrlmodel(linear) instead"
		exit 198
	}

	// check pvc
	local pvcemp = bsubstr("empirical",1,length("`pvc'"))	
	local pvcnorm = bsubstr("normal",1,length("`pvc'"))	
	if !inlist("`pvc'","","`pvcemp'","`pvcnorm'") {
		di as err "pvc(`pvc') invalid;"
		di as err "pvc() must be empirical or normal"
		exit 198
	}	

	if (`"`bstrata'"' == "nobstrata") {
		local ignstrata ignstrata
	}
		
	tokenize `vars'
	local di `1'

	if (`"`save'"'=="nosave") {
        	local nosave nosave
        }
        else {
                local nosave ""
        }

	local 1 `" "'
	local classvars `"`*'"'
	local classvars = ltrim(rtrim(`"`classvars'"'))

	local nobootstrap `bootstrap'	
	local i = 1
	foreach var of varlist `vars' {
		if(`i' > 1) {
		capture assert length(`"`var'"') < 27  	///  32-5
			if `"`nosave'"' == ""
			if (_rc > 0) {
				di as error ///
"{p 0 4 2}one of the classifier variables " 
				di as error ///
"names is too long, "
				di as error ///
"false-positive and true-positive rate variables "
				di as error ///
"are created as _fpr_`var', _roc_`var'{p_end}"
				exit 198
			}
		}
		local i = `i' + 1	
	}

	local par `ml'`roccov'`link'
	local npstat `roc'`invroc'`pauc'`auc'
	if (`"`par'"' == "" & `"`npstat'"' == "") {
		local auc auc
	}
	if (`"`nobootstrap'"'=="" & `"`ml'"' == "") {
		if (`"`auc'`pauc'`invroc'`roc'`roccov'"' != "") {
			if (`"`bseed'"' == "") {
				local a = c(seed)
				local bseed `a'
			}
		}
	}

	local cvcnt: word count `classvars'
		
	local nodots nodots
	if (`"`dots'"' != "nodots") {
		local nodots ""
	}
		
	local vvit = 1
		// declare fpr, roc tempvars
		// index by classifier sequence #
		// this lets us have any length of classifiers
		// not absolutely determined if long variable names allowed
		// but using sequence # will sidestep this problem until the 
		// final initialization of fpr, roc variables
	foreach var of varlist `classvars' {
		tempvar fpr_`vvit' roc_`vvit'
		local vvit = `vvit' + 1
	}

	local f: word count `cluster'
	if (`f' > 1) {
		di as error `"only one variable may be specified in cluster()"'
		exit 198
	}

	if `isml' {
		local link "probit"
		local pvc "normal"
		capture assert ///
			`"`ctrlmodel'"' == "linear" | `"`ctrlmodel'"' == ""
		if (_rc > 0) {
			di as error "{p 0 4 2}covariate controls are "
			di as error "done by linear regression under " 
			di as error "ml estimation{p_end}"
			exit 198
		} 
		local ctrlmodel linear
	}
		
	if ("`roccov'" != "" & "`link'"=="") {
		local link `"probit"'
	}
	
	if ("`pvc'"' == "") {
		local pvc "empirical"
	}
	if (`"`link'"' != `""' & `"`ctrlfprall'"' == "") {
		// default used by Pepe et al. is interval(0 1 10).
		// discussion is given on page 155 of the 
		// "Statistical Evaluation of Medical Tests 
		// for Classification and Prediction"
		local interval "0 1 `fprpts'"
	}
	else if (`"`link'"' != "") {
		local interval "0 1 10"
	}

	// check proper domain for ROC statistics
	if("`roc'" != "") {
		foreach num of numlist `roc' {
			if `num' <= 0 | `num' >= 1 {
				di as error `"roc() must be in (0,1)"'
				exit 198
			}
		}
	}

	if("`invroc'" != "") {
		foreach num of numlist `invroc' {
			if `num' <= 0 | `num' >= 1 {
				di as error ///
				`"invroc() must be in (0,1)"'
				exit 198
			}
		}
	}
	
	if("`pauc'" != "") {
		foreach num of numlist `pauc' {
			if `num' <= 0 | `num' > 1 {
				di as error ///
				`"pauc() must be in (0,1]"'
				exit 198
			}
		}
	}

	local varlist: copy local VARLIST
	local if: copy local IF
	local in: copy local IN
	local weight: copy local WEIGHT
	local exp: copy local EXP
		
	// 1	syntax checked, set sample
	qui marksample touse
	qui count if `touse'
	if `r(N)' == 0 {
		error 2000
	}

	qui count if (`refvar'==0 & `touse')
	if `r(N)' == 0 {
		di as err "reference variable must be 0/1;"
		di as err "insufficient observations = 0"
		exit 2001
	}
	qui count if (`refvar'==1 & `touse')
	if `r(N)' == 0 {
		di as err "reference variable must be 0/1;"
		di as err "insufficient observations = 1"
		exit 2001
	}

	if (`"`cluster'"' != "") {
		qui markout `touse' `cluster', strok
	}
	
	if (`"`ctrlcov'`roccov'"' != `""') {
		qui	markout `touse' `ctrlcov'
		qui	marksample btouse
		qui markout `btouse' `roccov' 
		qui replace `touse' = `touse' & `btouse' if `di' == 1	
	}
	qui count if `touse' == 1
	if (r(N)==0) {
		error 2000
	}


	tempname uniquedi
	qui tab `di' if `touse', matrow(`uniquedi')
	
	capture assert (`uniquedi'[1,1] == 0 & `uniquedi'[2,1] ==1) & ///
	rowsof(`uniquedi') == 2
	
	if(_rc >0) {
		di as error `"true status variable `di' must be 0 or 1"'
		exit 198
	}

	if "`classvars'" == "" {
		di as error `"classification variables are required"'
		exit 198
	} 



	// first touse will get eaten
	tempvar toused
	gen `toused' = `touse'

        //ml initial values
        if `"`from'"' != "" {
                local initopt `"init(`from')"'
        }
        if (`"`probit'"' != "" & `"`ml'"' != "") & `"`from'"'== "" {
		foreach var of varlist `classvars' {
			qui sum `var' if `refvar' == 0
			local m0 = r(mean)
			local s0 = r(sd)
			qui sum `var' if `refvar' == 1
			local m1 = r(mean)-`m0'
			local s1 = r(sd)
			local fromit`var' ctrlsd:_cons=`s0' ///
				ctrlcov:_cons=`m0'	   ///
                                casecov:_cons=`m1'         ///
                                casesd:_cons=`s1'         
			local initopt`var' `"init(`fromit`var'')"'
	     }
        }

	
	// 2 adjust for covariate stratification
	if (`"`ctrlcov'"' != "" & `"`ctrlmodel'"'==`"strata"') {
			// for later sorting 
		tempvar oorder
		gen `oorder' = _n
		// stratification only relevant for strata 
		// that have cases in them
		// as the ROC curve is formulated under D=1, di=1
		// number strata with cases, stratano
		// number of cases per strata, strcaseno
		// number of controls per strata, strctrlno
		tempvar stratano strcaseno strctrlno iscasestrat
		qui {
			bysort `touse' `ctrlcov' (`di' `oorder'): ///
				gen byte `iscasestrat' = (`di'[_N] == 1)
			bysort `iscasestrat' `touse' `ctrlcov' (`oorder'): ///
			gen `stratano' = _n == 1 if `iscasestrat' & `touse'
			by `iscasestrat' `touse': ///
				replace `stratano' = sum(`stratano') ///
					if `iscasestrat' & `touse'
			bysort `stratano' (`oorder'): ///
				gen `strctrlno' = sum(`di'==0) ///
				if `stratano' != .
			by `stratano': replace `strctrlno' = `strctrlno'[_N]
			by `stratano': gen `c(obs_t)' `strcaseno' = _N - `strctrlno'
		}

		// cut off rules not well documented, as far as I can find
		// Pepe et al. warn at 10 observations per strata and 
		// say that you should re-design your strata at 1 obs/strata
		// we will throw an error in the latter case and not warn 
		// on the prev

		qui sum `strctrlno',meanonly
		if (r(min) < 2) {
			di as error "{p 0 4 2}some covariate strata have "
			di as error "less than 2 control cases{p_end}"
			exit 459
		}
		// renew sort order 
		sort `oorder'
	}

	// 3	Fit ML model
	if (`isml') {
		local cvcnt: word count `classvars'
		if(`"`cluster'"' != "") {
			local ocluster `"`cluster'"'
			local clustvar `cluster'
			local cluster `"vce(cluster `cluster')"'		
		}
		if "`weight'" != "" {
			local wgt "[`weight'`exp']"
			local wtype `weight'
			local wexp "`exp'"
		}
		local inoiml inoiml
		_coef_table_header
		di ""
		// Display first time
                if(`"`ctrlcov'"' != "") {
	                di as text ///
                       		`"Covariate control      : "' ///
				as result ////
				`"linear regression"'
                        di as text ///
                           	`"Control variables      : "' ///
                                as result `"`ctrlcov'"'
                }
                di as text `"Control standardization: "' as result `"normal"'
                di as text `"ROC method             : "' as result ///
                        `"parametric"'          ///
                        _col(51) as text `"Link: "' /// 
			as result `"probit"'

                di ""
                di as text `"  Status     : "' as result `"`refvar'"'
                di as text `"  Classifiers: "' as result `"`classvars'"'

		if (`cvcnt' > 1) {
               

			local suestmac
			foreach classvar of varlist `classvars' {
				di ""
				di as text `"  Classifier : "' ///
					as result "`classvar'"
				di as text ///
"  Covariate control adjustment model:"
				`qn' ml model lf2 rocreg_lf2 ///
				(casecov: `classvar' `di' = `roccov') ///
				(casesd: ) ///
				(ctrlcov: `ctrlcov') ///
				/ctrlsd /// 
				`wgt' if `touse', ///
				maximize missing ///
				`mlopts' `diopts' `initopt' ///
				wald(0) `mlsearch' `initopt`classvar''
				//noi ml display,	`diopts'
				_coef_table, level(`level') `diopts'

                                ereturn repost
       	                        ereturn local predict ml_p_allowmissscores
				qui estimates store rr_f_`classvar' 

                        	if("`weight'"=="pweight") {
                        	        tempvar pweightsub
                	                qui gen double  `pweightsub' `exp'
        	                        local uwgt [iweight=`pweightsub']
                                	qui ml model lf2 rocreg_lf2 ///
                                	(casecov: `classvar' `di'=`roccov') ///
                                	(casesd: ) ///
                                	(ctrlcov: `ctrlcov') ///
                                	/ctrlsd ///
                                	`uwgt' if `touse', ///
                                	maximize missing ///
                                	`mlopts' `diopts' `initopt' ///
                                	wald(0) `mlsearch' `initopt`classvar''

				}

                                ereturn repost
                                ereturn local predict ml_p_allowmissscores
				qui estimates store rr_`classvar' 
				local suestmac `suestmac' rr_`classvar'	
			}
	
			qui suest `suestmac', `cluster'
			foreach classvar of varlist `classvars' {
				capture drop _est_rr_`classvar'
				capture drop _est_rr_f_`classvar'
			}
			qui estimates store _rocreg_suest_1, novarname
		}
		else {
			if ("`srobust'" != "") {
				local srobust vce(robust)
			}
			di ""
                        di as text `"  Classifier : "' ///
                           as result "`classvars'"
			di as text "  Covariate control adjustment model:"
			// we have only one classifier
			`qn' ml model lf2 rocreg_lf2 ///
			(casecov: `classvars' `di' = `roccov') ///
			(casesd: ) ///
			(ctrlcov: `ctrlcov') ///
			/ctrlsd /// 
			`wgt' if `touse', `srobust' maximize missing ///
			`mlopts' `diopts' `initopt' ///
			 `cluster'  ///
			wald(0) `mlsearch' `initopt`classvars''
			ereturn repost 
			ereturn local predict ml_p_allowmissscores	
			_coef_table, level(`level') `diopts'
			estimates store rr_`classvars', novarname
		}
			// prepare nlcom macro
			// 1 classifier 
		if (`cvcnt' == 1) {				
			tempname 1_ctrlint
			tempname 1_ctrlslope
			scalar `1_ctrlint' = [ctrlcov]_b[_cons]
			scalar `1_ctrlslope' = [ctrlsd]_b[_cons]
			local nlcomexp 
local nlcomexp `nlcomexp' (i_cons: [casecov]_b[_cons]/[casesd]_b[_cons])
			if(`"`roccov'"' != "") {
				foreach var of varlist `roccov' {
local nlcomexp `nlcomexp' (`var': [casecov]_b[`var']/[casesd]_b[_cons])
				}
			}
local nlcomexp `nlcomexp' (s_cons: [ctrlsd]_b[_cons]/[casesd]_b[_cons])
			if (`"`roccov'"' == "") {
local nlcomexp `nlcomexp' (auc: normal(([casecov]_b[_cons]/[casesd]_b[_cons])/sqrt(1+(([ctrlsd]_b[_cons]/[casesd]_b[_cons])^2))))
			}
		}
			//multiple classifiers
		if (`cvcnt' > 1) {
			local nlcomexp 
			local vvit = 1
			foreach classvar of varlist `classvars' {
				tempname `vvit'_ctrlint
				tempname `vvit'_ctrlslope
				scalar ``vvit'_ctrlint' /// 
					= [rr_`classvar'_ctrlcov]_b[_cons]
				scalar ``vvit'_ctrlslope' ///
					= [rr_`classvar'_ctrlsd]_b[_cons]
local nlcomexp `nlcomexp' (`classvar'__i_cons: [rr_`classvar'_casecov]_b[_cons]/[rr_`classvar'_casesd]_b[_cons])
				if(`"`roccov'"' != "") {
					foreach var of varlist `roccov' {
local nlcomexp `nlcomexp' (`classvar'__`var': [rr_`classvar'_casecov]_b[`var']/[rr_`classvar'_casesd]_b[_cons])
					}
				}
local nlcomexp `nlcomexp' (`classvar'__s_cons: [rr_`classvar'_ctrlsd]_b[_cons]/[rr_`classvar'_casesd]_b[_cons])
				if (`"`roccov'"' == "") {
local nlcomexp `nlcomexp' (`classvar'__auc: normal(([rr_`classvar'_casecov]_b[_cons]/[rr_`classvar'_casesd]_b[_cons])/sqrt(1+(([rr_`classvar'_ctrlsd]_b[_cons]/[rr_`classvar'_casesd]_b[_cons])^2))))
				}
				local vvit = `vvit' + 1
			}
		}	
		qui nlcom `nlcomexp', post
		qui estimates store _rocreg_fml, novarname
		
		//adjust format of output estimates			
		if (`cvcnt' > 1) {
			tempname matty
			tokenize
			matrix `matty' = e(b)
			local g: colfullnames `matty'
			local gn =colsof(`matty')
			tokenize `g'
			local i = 1
			forvalues i = 1/`gn' {
				local `i': subinstr local `i' `"__"' `":"', all
			}	
			local g =`"`*'"'
			matrix colnames `matty' = `g'
			tempname vmatty
			matrix `vmatty' = e(V)
			matrix colnames `vmatty' = `g'
			matrix rownames `vmatty' = `g'
			ereturn post `matty' `vmatty'
		}
		else {
			tempname matty
			tokenize
			matrix `matty' = e(b)
			local g: colfullnames `matty'
			local gn =colsof(`matty')
			tokenize `g'
			local i = 1
			forvalues i = 1/`gn' {
				local `i'  `"`classvars':``i''"'
			}	
			local g =`"`*'"'
			matrix colnames `matty' = `g'
			tempname vmatty
			matrix `vmatty' = e(V)
			matrix colnames `vmatty' = `g'
			matrix rownames `vmatty' = `g'
			ereturn post `matty' `vmatty'
		}

		// add sample to estimates
		ereturn repost, esample(`toused')
			
		// if no covariates, estimate AUC
		// and update temp fpr variables
		if(`"`roccov'"' == "") {
			local cnt: word count `classvars'
			local vvit = 1
			foreach y of varlist `classvars' {
				local f: variable label `y'
				qui gen double `fpr_`vvit'' = ///
					1 - normal((`y'-``vvit'_ctrlint' ///
					)/``vvit'_ctrlslope') if `touse'
				label variable `fpr_`vvit'' `"`f'"'
				qui gen double `roc_`vvit'' = ///
					normal([`y']_b[i_cons] + ///
					[`y']_b[s_cons]*  ///
					invnormal(`fpr_`vvit'')) ///
					if `touse'
				label variable `roc_`vvit'' `"`f'"'
				local vvit = `vvit' + 1
			}
		}	
	} 

	// 4	no ML, initialize temp fpr, roc vars for bootstrap		
	if (!`isml') {
		// macros that will hold names of temp fpr, roc vars
		local fprs = `""'
		local rocs = `""'
		local vvit = 1
		foreach var of varlist `classvars' {
			qui gen double `fpr_`vvit'' = .
			local f: variable label `var'
			label variable `fpr_`vvit'' `"`f'"'
			local fprs `"`fprs' `fpr_`vvit''"'
			qui gen double `roc_`vvit'' = .
			local rocs `"`rocs' `roc_`vvit''"'
			label variable `roc_`vvit'' `"`f'"'
			local vvit = `vvit' + 1
		}
	}
		
	// 5 point estimate before bootstrap
	// we also get fpr, roc variables from this call
	if (!`isml') {
		// Initialize macro to show model if we linearly regress
		if(`"`ctrlmodel'"' == "linear") {
			local retctrlcov = "retctrlcov"
		}
		rocregstat if `touse',  di(`di') 			///
					classvars(`classvars') 		///
					ctrlcov(`ctrlcov') 		///
					ctrlmodel(`"`ctrlmodel'"')  	///
					pvc(`"`pvc'"') 			///
					`tiecorrected' 		///
					roccov(`roccov') 		///
					link(`"`link'"') 		///
					interval(`interval') 		///
					roc(`roc')			///
					invroc(`invroc')		///
					pauc(`pauc') 			///
					`auc' 				/// 
					stratano(`stratano') 		///
					strcaseno(`strcaseno') 		///
					strctrlno(`strctrlno') 		///
					fprvars(`fprs') 		///
					rocvars(`rocs') 		///
					`retctrlcov' 			///
					`ctrlfprall' 			///
					clvar(`cluster') 		
	}

	if(`"`link'`roc'`invroc'`pauc'`auc'"' == "" | `isml' ) {
		//nothing worth bootstrapping
		local nobootstrap nobootstrap
	}
	
			
	// 6	set macro to skip rocvar generation 
	//		in bootstrap of parametric case
	if(`"`link'"' != "") {
		local bskip bskip
	}


	// 7 Bootstrap if necessary
	if (`"`nobootstrap'"' != "") {		
		// return estimation results for rocregstat in 5
		ereturn repost
		if(`"`link'"' == "") {			
			ereturn local roc 	`"`roc'"'
			ereturn local invroc	`"`invroc'"'
			ereturn local pauc	`"`pauc'"'
			ereturn local auc	`"`auc'"'
			ereturn scalar level  = `level'
			ereturn local clustvar `cluster'
		}
		else {
			ereturn local ml `ml'
			ereturn local probit `probit'
			ereturn hidden local link `"`link'"'
			ereturn local roccov `"`roccov'"'
			ereturn local predict "rocreg_p"	
			if (!`isml') {
				ereturn local fprpts `fprpts'
			}
			if (`isml') {
				ereturn hidden local fprpts `fprpts'
			}
			ereturn local ctrlfprall `ctrlfprall'
			ereturn local clustvar `clustvar'
			if(!`isml') {
				ereturn local clustvar `cluster'
			}
			ereturn hidden local cluster `e(cluster)'
		}
		if (`isml') {
			_post_vce_rank, checksize
			ereturn local wtype `wtype'
			ereturn local wexp "`wexp'"
			if (`"`clustvar'"'!="") {
				ereturn local vcetype Robust
				ereturn local vce cluster
			}
			else if (`cvcnt'>1 | `"`wtype'"'=="pweight") {
				ereturn local vcetype Robust
			}
		}
		
			
		ereturn local pvc "`pvc'"
		ereturn local cmd `"rocreg"'
		ereturn hidden local cmdname `"rocreg"'
		ereturn hidden local estat_cmd "rocreg_estat"	
		ereturn local classvars `"`classvars'"'
		ereturn local refvar	`"`di'"'
		ereturn local ctrlmodel	`"`ctrlmodel'"'
		ereturn local ctrlcov	`"`ctrlcov'"'
		ereturn local cmdline `rocregcmd'
		if (!`isml') {
			ereturn local nobootstrap `nobootstrap'
		}
		else {
			ereturn hidden local nobootstrap `nobootstrap'
		}
		ereturn local tiecorrected `tiecorrected'
                if(`"`e(link)'"' != "") {
                        ereturn local title "Parametric ROC estimation"
                }
                else {
                        ereturn local title "Nonparametric ROC estimation"
                }

		// should be hidden to user
		if( e(N) == .) {
			qui count if  e(sample)
			ereturn scalar N = r(N)
		}
		//N_clust, only return under ml, otherwise 
		// no variance estimation
		if(`"`e(clustvar)'"' != "") {
			if(`isml') {	
				tempvar oclust
				tempvar touseclust
				tempvar clustind
				qui gen `touseclust' = e(sample)
				qui gen `oclust' = _n
				qui bysort `touseclust' `e(clustvar)' ///
					 (`oclust'): ///
					gen `clustind' = 1 if _n == 1 & ///
					`touseclust'
				qui replace `clustind' = sum(`clustind')
				ereturn scalar N_clust = `clustind'[_N]
				sort `oclust'
			}
		}
	}
	else {			
			//prepare bootstrap strata argument
		local stratarg `""'
		if(`"`bootcc'"'!= `""') {
			local stratarg `"`stratarg' `di'"'
		}
		if(`"`ignstrata'"' == `""') {
			local stratarg `"`stratarg' `stratano'"'
		}
			//prepare bootstrap saved dataset
		local abert = strpos(`"`bsave'"',`","')
		if(`abert'== 0 & `"`bsave'"' != `""') {
			local bsave `"`bsave', double"'
		}
		else if (`"`bsave'"' != "") {
			local bsave `"`bsave' double"'
		}
		if (`"`bsave'"' != "") {
			local savemac "saving(`bsave')"
		}
			// at least one parameter was estimated
		if(`e(np)' > 0) {
			preserve
			//keep only relevant variables
			keep `di' `classvars' `ctrlcov' `stratano' ///
			 `strcaseno' `strctrlno' `cluster' `roccov' `toused'
			local quimac qui
			if(`"`nodots'"' == "") {
				local quimac ""
			} 
			`quimac' bootstrap,		///
			notable 			///
			strata(`stratarg') 		///
			cluster(`cluster') 		///
			reps(`breps') 			///
			`savemac' 			///
			level(`level') 			///
			seed(`bseed') 			///
			`nodots': 			///
			rocregstat if `toused', di(`di') ///
						classvars(`classvars') 	   ///
						ctrlcov(`ctrlcov') 	   ///
						ctrlmodel(`"`ctrlmodel'"') ///
						pvc(`"`pvc'"')             ///
						`tiecorrected' 	   	   ///
						roccov(`roccov') 	   ///
						link(`"`link'"') 	   ///
						interval(`interval') 	   ///
						roc(`roc') 		   ///
						invroc(`invroc') 	   ///
						pauc(`pauc') 		   ///
						`auc' 		           ///
						stratano(`stratano') 	   ///
						strcaseno(`strcaseno') 	   ///
						strctrlno(`strctrlno') 	   ///
						`ctrlfprall'  		   ///
						`bskip'  		   ///
						bskiplr			   
			estimates store _rocreg_bootstrap, novarname
			restore
		}
		ereturn local vce bootstrap
		ereturn hidden local cluster `e(cluster)'
		tempname eblegend
		matrix `eblegend' = e(blegend)
		ereturn hidden matrix blegend =`eblegend'
		ereturn hidden local title  `e(title)'
		ereturn hidden local np  `e(np)'
		ereturn hidden local vcetype `e(vcetype)'
		ereturn hidden local seed `e(seed)'
		ereturn hidden scalar bs_version =  e(bs_version) 
		ereturn hidden scalar N_misreps = e(N_misreps) 
             	ereturn hidden scalar N_reps =  e(N_reps)
		ereturn scalar  rank =  e(rank) 
               	ereturn hidden scalar k_eq = e(k_eq)
		ereturn hidden scalar k_exp =  e(k_exp)
		ereturn hidden scalar k_eexp =  e(k_eexp)
		ereturn hidden scalar k_extra = e(k_extra)
		ereturn hidden local strata  `e(strata)'
		ereturn hidden local command `e(command)'
 
		if(`"`link'"' == "") {
			ereturn local roc 	`"`roc'"'
			ereturn local invroc	`"`invroc'"'
			ereturn local pauc	`"`pauc'"'
			ereturn local auc	`"`auc'"'	
			ereturn scalar level = `level'
		}
		else {
			ereturn local roccov `"`roccov'"'
			ereturn local probit `"`probit'"'
			ereturn hidden local link `"`link'"'
			ereturn local fprpts `fprpts'
			ereturn local ctrlfprall `ctrlfprall'
			ereturn local predict "rocreg_p"
		}
		ereturn repost
		ereturn local cmd "rocreg"
		ereturn local weightexp  `wgt'
		ereturn local bootcc `bootcc'
		if(`"`ignstrata'"' != "") {
			ereturn local nobstrata "nobstrata"
		}
		ereturn hidden local estat_cmd "rocreg_estat"
		ereturn local pvc "`pvc'"
		ereturn hidden local cmdname `"rocreg"'
		ereturn local cmdline `rocregcmd'
		ereturn local nobootstrap `nobootstrap'
		ereturn local classvars `"`classvars'"'
		ereturn local refvar	`"`di'"'
		ereturn local ctrlmodel	`"`ctrlmodel'"'
		ereturn local ctrlcov	`"`ctrlcov'"'
		ereturn hidden local bseed `bseed'
		ereturn local breps `breps'
		ereturn local cmd rocreg
		ereturn hidden local cmdname rocreg
		ereturn local tiecorrected `tiecorrected'
                if(`"`e(link)'"' != "") {
                        ereturn local title "Parametric ROC estimation"
                }
                else {
                        ereturn local title "Nonparametric ROC estimation"
                }
		if (`"`e(prefix)'"' == "bootstrap") {
			ereturn local prefix "" 
		}
		if( e(N) == .) {
			qui count if e(sample)
			ereturn scalar N = r(N)
		}
	}
		ereturn hidden local _estimates_name `e(_estimates_name)'

	
	// 8	save fpr, roc variables
	if (`"`nosave'"' == "" & `"`roccov'"' == "") {
		local vvit = 1
		foreach y of varlist `classvars' {
			qui capture gen double _roc_`y' = ///
				`roc_`vvit'' if `touse'
			if(_rc > 0) {
				drop _roc_`y'
				qui gen double _roc_`y' = ///
					`roc_`vvit'' if `touse'
			}
			label variable _roc_`y' `"ROC value for `y'"'
			qui capture gen double _fpr_`y' = ///
			`fpr_`vvit'' if `touse'
			if (_rc > 0) {
				drop _fpr_`y'
				qui gen double _fpr_`y' = ///
					`fpr_`vvit'' if `touse'
			}
			label variable _fpr_`y' `"false-positive rate for `y'"'
			local vvit = `vvit' + 1
		}
	}
	local dotted dotted
	if(`"`nodots'"'=="nodots") {
		local dotted
	}
	// 9 output
	if (`"`e(link)'"'!="") {
		DisplayP, level(`level') `dotted' `inoiml' `diopts'
	}
	else {
		DisplayNP, `dotted' 	
	}
	
end



program DisplayP
	syntax, [Level(cilevel)	///
		dotted		///
		inoiml		///
		bfile(string)	///
		*		///
		]
	
	local isml = "`e(ml)'" == "ml"
	local haslevel = "`e(level)'" != "`level'"
	_get_diopts diopts rest, `options'

	if (length("`diopts'") > 0 & !`isml') {
		di as err "rocreg results are not ml;"
		di as err "display options are not allowed"
		exit 198
	}
	local 0 ",`diopts'"
	syntax [,			///
		NOOMITted		///
		OMITted			///
		NOLSTRETCH		///
		LSTRETCH		///
		cformat(string)		///
		sformat(string)		///
		pformat(string)		///
		]
	
	// catch any illegal options
	local 0 ", `rest' `ml'"
	syntax [, ML ] 

	if `isml' & "`bfile'" != "" {
		di as err "rocreg results are not parametric bootstrap;"
		di as err "bfile() not allowed"
		exit 198
	}
        if(!`isml') {
		if ("`e(level)'" != "") {
			if !`haslevel' {
				local level = `e(level)'
			        local level = string(`level',"%9.0g")
			}
			if (reldif(`level', `e(level)')>1e-3 & "`bfile'"=="") {
				di as err "bfile() must be specified"
				exit 198
			}
			if (reldif(`level',`e(level)')>1e-3) {
				Adjuste, level(`level') bfile(`bfile')
			}
		}	
	        if (`"`e(nobootstrap)'"' == "" & `"`dotted'"' != "dotted") {
                        tempname curest
                        qui estimates store `curest'
                        qui estimates restore _rocreg_bootstrap
                        bootstrap, notable
                	qui estimates restore `curest'
        	        qui estimates drop `curest'
	        }
		
		if (`"`e(nobootstrap)'"' != "") {
			_coef_table_header
		}
		else {
			di
			di as text "`e(title)'"
		}
		
		di ""

                if(`"`e(ctrlmodel)'"' == "strata") {
	                di as text ///
				`"Covariate control      : "' ///
				as result ///
				`"stratification"' 
		}
		if(`"`e(ctrlmodel)'"' == "linear") {
                        di as text ///
				`"Covariate control      : "' ///
				as result ///
				`"linear regression"'
		}
		if(`"`e(ctrlcov)'"' != "") {
                        di as text ///
				`"Control variables      : "' ///
                                as result `"`e(ctrlcov)'"'
                }
                if (`"`e(tiecorrected)'"' != "") {
                        di as text ///
				`"Control standardization: "' ///
                                as result `"`e(pvc)', corrected for ties"' 
                }
                else if (`"`e(pvc)'"'=="empirical") {
                        di as text `"Control standardization: "' ///
                                as result `"`e(pvc)'"' 
                }
		else {
                        di as text `"Control standardization: "' ///
                                as result `"`e(pvc)'"' 
		}
		if (`"`e(link)'"' != "") {
	                di as text `"ROC method             : "' as result ///
				`"parametric"' _col(49) as text ///
				`"Link: "' ///
				as result `"`e(link)'"'
		}
		else {
	                di as text `"ROC method             : "' ///
				as result `"empirical"'
		}	
        }
	else if (`"`inoiml'"' == "") {
		_coef_table_header
		di ""
                if(`"`e(ctrlcov)'"' != "") {
	                di as text ///
				`"Covariate control      : "' as result ///
				`"linear regression"'
                        di as text ///
				`"Control variables      : "' ///
				as result `"`e(ctrlcov)'"'
                }
                di as text `"Control standardization: "' as result `"`e(pvc)'"'
                di as text `"ROC method             : "' as result ///
                	`"parametric"'          ///
	                _col(51) as text ///
			`"Link: "' as result `"`e(link)'"'
	}	

	local cvcnt: word count `e(classvars)'
	if (`isml' & `"`inoiml'"' == "") {
		di ""
	
		di as text `"  Status     : "' as result `"`e(refvar)'"'
		di as text `"  Classifiers: "' as result `"`e(classvars)'"' 	

		if(`cvcnt' > 1) {			
			foreach classvar of varlist `e(classvars)' {
				di 
				di as text `"  Classifier : "' ///
					as result "`classvar'"
				di as text ///
"  Covariate control adjustment model:"
				tempname curest
				qui estimates store `curest'
				qui estimates restore rr_f_`classvar'
				_coef_table, level(`level') `diopts'
				qui estimates restore `curest'
				qui estimates drop `curest'
			}
			di ""
			tempname curest
			qui estimates store `curest'
			qui estimates restore _rocreg_suest_1
			qui estimates restore `curest'
			qui estimates drop `curest'			
		}
		else {
			di ""
                        di as text `"  Classifier : "' ///
                           as result "`e(classvars)'"
			di as text "  Covariate control adjustment model:"
			tempname curest
			qui estimates store `curest'
			qui estimates restore rr_`e(classvars)'
			_coef_table, level(`level') `diopts'
			qui estimates restore `curest'			
			qui estimates drop `curest'
		}
	}


	if (`isml' & `"`inoiml'"' == "") {
	        di ""
	}


	if (`isml') {
                di ""
       		di as text `"   Status    : "' as result `"`e(refvar)'"'
		di as text `"   ROC Model : "'
                ereturn display, level(`level') `diopts'
                if(`"`e(roccov)'"' === "") {
                        if (`cvcnt' > 1) {
                                DispcontTOTAUC, ml ///
                                        classvars(`e(classvars)')
                        }
                }
	}
	

	if (!`isml') {
		if (`"`e(ctrlmodel)'"' == "linear") {
			local refvar `e(refvar)'
			foreach var of varlist `e(classvars)' {
				tempname curest
				qui estimates store `curest'
				qui estimates ///
				restore _rr_`var'
				di ""
				di as text "Status    : " ///
					as result `"`refvar'"'
				di as text "Classifier: " as result `"`var'"' 	
				di as text ///
					"Covariate control adjustment model:"
				regress, level(`level')
				qui estimates restore `curest'
				qui estimates drop `curest'
			}
		}
	}

	if (!`isml' & `"`e(link)'"' != "") {
		foreach var of varlist `e(classvars)' {
			di `""'
			di as text `"   Status    : "' as result `"`e(refvar)'"'
			di as text `"   Classifier: "' as result `"`var'"'
			di as text `"   ROC Model : "'
			Dispmodel, 	classvar(`"`var'"') 	///
					link(`"`e(link)'"') 	///
					roccov(`"`e(roccov)'"')	///
					`e(nobootstrap)' level(`level')	
			if(`"`e(roccov)'"'=="") {
				di ""
				Disempauc, 	classvar(`"`var'"') ///
						`e(nobootstrap)' level(`level')
			}
		}
		if(`"`e(roccov)'"'=="") {
			if (`cvcnt' > 1) {
				if (`"`e(nobootstrap)'`e(ml)'"' == "") {  
					DispcontTOTAUC, ///
						classvars(`e(classvars)') ///
						`e(nobootstrap)'
				}
			}
		}
	}
end

program DisplayNP
	syntax, [dotted]
	local level = e(level)
	local level = string(`level',"%9.0g")	
        if(`"`e(ml)'"' == "") {
	        if (`"`e(nobootstrap)'"' == "" & `"`dotted'"' != "dotted") {
                        tempname curest
                        qui estimates store `curest'
                        qui estimates restore _rocreg_bootstrap
                        bootstrap, notable
                	qui estimates restore `curest'
        	        qui estimates drop `curest'
	        }
		
		if (`"`e(nobootstrap)'"' != "") {
			_coef_table_header
		}
		else {
			di
			di as text "`e(title)'"
		}
	
		di ""
                if(`"`e(ctrlmodel)'"' == "strata") {
	                di as text ///
				`"Covariate control      : "' ///
				as result ///
				`"stratification"' 
		}
		if(`"`e(ctrlmodel)'"' == "linear") {
                        di as text ///
				`"Covariate control      : "' ///
				as result ///
				`"linear regression"'
		}
		if(`"`e(ctrlcov)'"' != "") {
                        di as text ///
				`"Control variables      : "' ///
                                as result `"`e(ctrlcov)'"'
                }
                if (`"`e(tiecorrected)'"' != "") {
                        di as text ///
				`"Control standardization: "' ///
                                as result `"`e(pvc)', corrected for ties"' 
                }
                else if (`"`e(pvc)'"'=="empirical") {
                        di as text `"Control standardization: "' ///
                                as result `"`e(pvc)'"' 
                }
		else {
                        di as text `"Control standardization: "' ///
                                as result `"`e(pvc)'"' 
		}
		if (`"`e(link)'"' != "") {
	                di as text `"ROC method             : "' as result ///
				`"parametric"' _col(49) as text ///
				`"Link: "' ///
				as result `"`e(link)'"'
		}
		else {
	                di as text `"ROC method             : "' ///
				as result `"empirical"'
		}	
        }
	local cvcnt: word count `e(classvars)'


	if (`"`e(ml)'"'=="") {
		if (`"`e(ctrlmodel)'"' == "linear") {
			local refvar `e(refvar)'
			foreach var of varlist `e(classvars)' {
				tempname curest
				qui estimates store `curest'
				qui estimates ///
				restore _rr_`var'
				di ""
				di as text "Status    : " ///
					as result `"`refvar'"'
				di as text "Classifier: " as result `"`var'"' 	
				di as text ///
					"Covariate control adjustment model:"
				regress, level(`level')
				qui estimates restore `curest'
				qui estimates drop `curest'
			}
		}
	}

	if(`"`e(link)'"' == "") {
		if(`"`e(roc)'"' != `""') {
			di `""'
			di as text `"ROC curve"'
			foreach var of varlist `e(classvars)' {
				di `""'
				di as text `"   Status    : "' ///
				as result `"`e(refvar)'"'
				di as text `"   Classifier: "' ///
				as result `"`var'"'	
				Disemp, classvar(`"`var'"') 	///
					stat("roc") 		///
					statlist(`e(roc)') 	///
					`e(nobootstrap)' 	///
					level(`level')
			}
			local cnt: word count `e(classvars)'
			if(`cnt' > 1) {
				if (`"`e(nobootstrap)'`e(ml)'"' == "") {  
					DispcontTOT,			///
						classvars(`e(classvars)') ///
						stat(`"roc"') 		 ///
						statlist(`"`e(roc)'"') 	 ///
						`e(nobootstrap)'
				}
			}
		}
		if(`"`e(invroc)'"' != `""') {
			di `""'
			di as text `"False-positive rate"'
			foreach var of varlist `e(classvars)' {
				di `""'
				di as text `"   Status    : "' ///
				as result `"`e(refvar)'"'
				di as text ///
				`"   Classifier: "' as result `"`var'"' 	
				Disemp, classvar(`"`var'"') 	///
					stat("invroc") 		///
					statlist(`e(invroc)') 	///
					`e(nobootstrap)' 	///
					level(`level')
			}
			local cnt: word count `e(classvars)'
			if (`cnt' > 1) {
				if (`"`e(nobootstrap)'`e(ml)'"' == "") {  
					DispcontTOT, 			///
						classvars(`e(classvars)') ///
						stat(`"invroc"') 	  ///
						statlist(`"`e(invroc)'"') ///
						`e(nobootstrap)'	 
				}
			}
		}

		if(`"`e(pauc)'"' != `""') {
			di `""'
			di as text `"Partial area under the ROC curve"' 
			foreach var of varlist `e(classvars)' {
				di `""'
				di as text `"   Status    : "' ///
					as result `"`e(refvar)'"'
				di as text `"   Classifier: "' ///
					as result `"`var'"' 	
				Disemp,	classvar(`"`var'"') 	///
					stat("pauc") 		///
					statlist(`e(pauc)') 	///
					`e(nobootstrap)' 	///
					level(`level')	
			}
			local cnt: word count `e(classvars)'
			if (`cnt' > 1) {
				if (`"`e(nobootstrap)'`e(ml)'"' == "") {  
					DispcontTOT, ///
						classvars(`e(classvars)') ///
						stat(`"pauc"') 		///
						statlist(`"`e(pauc)'"') ///
						`e(nobootstrap)'		
				}	
			}
		}

		if(`"`e(auc)'"' != `""') {
			di `""'
			di as text `"Area under the ROC curve"'
			foreach var of varlist `e(classvars)' {
				di `""'
				di as text `"   Status    : "' ///
					as result `"`e(refvar)'"'
				di as text ///
					`"   Classifier: "' as result `"`var'"' 
				Disempauc, classvar(`"`var'"') 		///
						`e(nobootstrap)' 	///	
						level(`level')		
			}
			local cnt: word count `e(classvars)'
			if (`cnt' > 1) {
				if (`"`e(nobootstrap)'`e(ml)'"' == "") {  
					DispcontTOTAUC, ///
						classvars(`e(classvars)') ///
						`e(nobootstrap)'
				}
			}
		}

	}
end



program DispcontTOTAUC 
	syntax, classvars(varlist) [nobootstrap] [ml]
	if (`"`bootstrap'"'=="nobootstrap") {
		local nobootstrap nobootstrap
	}
	else {
		local nobootstrap ""
	}
	di `""'
	di as text "Ho: " as text "All classifiers have equal AUC values."
	di as text "Ha: " as text ///
		"At least one classifier has a different AUC value."
	di ""
	local cvnt: word count `classvars'
	local testlist ""
	local j = 1
	foreach var of local classvars {
		local testlist `testlist' "[`var']_b[auc]"
		if (`j' < `cvnt') {
			local testlist `testlist' =
		}
		local j = `j' + 1
	}

	if (`"`ml'"' == "") {
		if (`"`nobootstrap'"' == "") {
			qui test `testlist'
			di "P-value: " as result _col(13) ///
				%9.0g r(p) as text ///
				_col(40) ///
				"Test based on bootstrap (N) assumptions." 
		}
		else {
			di "P-value: " as result _col(13) %9.0g .
		}
	}
	else {
		if (`"`nobootstrap'"' == "") {
			qui test `testlist'
			di "P-value: " as result _col(13) %9.0g r(p)
		}
		else {
			di "P-value: " as result _col(13) %9.0g .
		}	
	}

end

program Dispmodel
	syntax, classvar(varlist) 		///
			link(string) 		///
			[roccov(varlist)] 	///
			level(cilevel) 		///
			[nobootstrap]		
	DC
	if (`"`bootstrap'"'=="nobootstrap") {
		local nobootstrap nobootstrap
	}
	else {
		local nobootstrap ""
	}
	if(`"`nobootstrap'"' == "") {
		di as text "{hline 13}{c TT}{hline 64}"
		local tvv = abbrev(`"`classvar'"',9)
		local dcol = 14-length("`tvv' ")

		di as text  _col(14) "{c |}" _col(19) ///
		"Observed" _col(42) "Bootstrap"
		local llen = 0
		// 10s place
		local llen = `llen' + 2
		if (floor(`level') != `level') {
			// decimal point
			local llen = `llen' + 1
		}
		if (100*(`level'-floor(`level')) > 9) {
			// tenth's place
			local llen = `llen' + 1
		}
		if (100*(`level'-floor(`level'))/10 != ///
			floor(100*(`level'-floor(`level'))/10)) {
			// hundredth's place
			local llen = `llen' + 1
		}
		local al = 58 -`llen'

		di as text _col(`dcol') `"`tvv'"' _col(14) "{c |}" ///
			 _col(22) "Coef." _col(34) ///
			"Bias" _col(42) "Std. Err." _col(`al') ///
			`"[`=strsubdp("`level'")'% Conf. Interval]"'
		di as text "{hline 13}{c +}{hline 64}"
		local dcol = 14-length("_cons ")
		tempname eb
		matrix `eb' = e(b)
		tempname ecin
		matrix `ecin' = e(ci_normal)
		tempname ecip
		matrix `ecip' = e(ci_percentile)
		tempname ecibc 
		matrix `ecibc' = e(ci_bc)
		tempname bias
		matrix `bias' = e(bias)
		tempname semat
		matrix `semat' = e(se)

		di as text _col(`dcol') "_cons " _col(14) "{c |}" as result ///
			_col(18) %9.0g ///
			`eb'[1,colnumb(`eb',`"`classvar':i_cons"')] ///
			_col(29)  %9.0g ///
			`bias'[1,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(41) %9.0g ///
			`semat'[1,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(54) %9.0g ///
			`ecin'[1,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(65) %9.0g ///
			`ecin'[2,colnumb(`bias',`"`classvar':i_cons"')] ///  
			_col(76) as text "(N)"
		di as txt _col(14) "{c |}" as res ///
			_col(54) %9.0g ///
			`ecip'[1,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(65) %9.0g ///
			`ecip'[2,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(76) as text "(P)"
		di as txt _col(14) "{c |}" as res ///
			_col(54) %9.0g ///
			`ecibc'[1,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(65) %9.0g ///
			`ecibc'[2,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(75) as text "(BC)"
		if (`"`roccov'"' != "") {
			foreach var of varlist `roccov' {
				local tv = abbrev(`"`var'"',9)
				local dcol = 14-length("`tv' ")
				di as text _col(`dcol') ///
					"`tv' " _col(14) "{c |}" as result ///
					_col(18) %9.0g ///
					`eb'[1,colnumb(`eb', ///
					`"`classvar':`var'"')] ///
					_col(29)  %9.0g ///
					`bias'[1,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(41) %9.0g ///
					`semat'[1,colnumb(`bias', /// 
					`"`classvar':`var'"')] ///
					_col(54) %9.0g ///
					`ecin'[1,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(65) %9.0g ///
					`ecin'[2,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(76) as text "(N)"
				di as txt _col(14) "{c |}" as res ///
					_col(54) %9.0g ///
					`ecip'[1,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(65) %9.0g ///
					`ecip'[2,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(76) as text "(P)"
				di as txt _col(14) "{c |}" as res ///
					_col(54) %9.0g ///
					`ecibc'[1,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(65) %9.0g ///
					`ecibc'[2,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(75) as text"(BC)"
			}
		}

		di as text "{hline 13}{c +}{hline 64}"
		local dcol = 14-length("`link' ")
		di as text _col(`dcol') "`link' " _col(14) "{c |}" 
		di as text "{hline 13}{c +}{hline 64}"

		local dcol = 14-length("_cons ")

		di as text _col(`dcol') "_cons " _col(14) "{c |}" as result ///
			_col(18) %9.0g /// 
			`eb'[1,colnumb(`eb',`"`classvar':s_cons"')] ///
			_col(29)  %9.0g ///
			`bias'[1,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(41) %9.0g ///
			`semat'[1,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(54) %9.0g ///
			`ecin'[1,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(65) %9.0g ///
			`ecin'[2,colnumb(`bias',`"`classvar':s_cons"')] ///  
			_col(76) as text "(N)"
		di as txt _col(14) "{c |}" as res ///
			_col(54) %9.0g ///
			`ecip'[1,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(65) %9.0g ///
			`ecip'[2,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(76) as text "(P)"
		di as txt _col(14) "{c |}" as res ///
			_col(54) %9.0g ///
			`ecibc'[1,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(65) %9.0g ///
			`ecibc'[2,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(75)  as text "(BC)"
		di as text "{hline 13}{c BT}{hline 64}"
	}

	else {
		di as text "{hline 13}{c TT}{hline 64}"
		local tvv = abbrev(`"`classvar'"',9)
		local dcol = 14-length("`tvv' ")
		di as text _col(14) ///
			"{c |}" _col(19) "Observed" _col(42) "Bootstrap"

		local llen = 0
		// 10s place
		local llen = `llen' + 2
		if (floor(`level') != `level') {
			// decimal point
			local llen = `llen' + 1
		}
		if (100*(`level'-floor(`level')) > 9) {
			// tenth's place
			local llen = `llen' + 1
		}
		if (100*(`level'-floor(`level'))/10 != ///
			floor(100*(`level'-floor(`level'))/10)) {
			// hundredth's place
			local llen = `llen' + 1
		}
		local al = 58 -`llen'
		di as text _col(`dcol') `"`tvv'"' _col(14) "{c |}" ///
			_col(22) "Coef." _col(34) "Bias" ///
			_col(42) "Std. Err." _col(`al') ///
			"[`=strsubdp("`level'")'% Conf. Interval]"
		di as text "{hline 13}{c +}{hline 64}"
		local dcol = 14-length("_cons ")
		tempname eb
		matrix `eb' = e(b)
		tempname ecip
		matrix `ecip' = J(2,colsof(`eb'),.)
		tempname bias
		matrix `bias' = J(1,colsof(`eb'),.)
		tempname semat
		matrix `semat' = J(1,colsof(`eb'),.)

		di as text _col(`dcol') "_cons " _col(14) "{c |}" ///
			as result _col(18) ///
			%9.0g `eb'[1,colnumb(`eb',`"`classvar':i_cons"')] ///
			_col(29)  %9.0g ///
			`bias'[1,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(41) %9.0g ///
			`semat'[1,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(54) %9.0g ///
			`ecip'[1,colnumb(`bias',`"`classvar':i_cons"')] ///
			_col(65) %9.0g ///
			`ecip'[2,colnumb(`bias',`"`classvar':i_cons"')]
 
		if (`"`roccov'"' != "") {
			foreach var of varlist `roccov' {
				local tv = abbrev(`"`var'"',9)
				local dcol = 14-length("`tv' ")
				di as text _col(`dcol') "`tv' " ///
					_col(14) "{c |}" as result ///
					_col(18) %9.0g ///
					`eb'[1,colnumb(`eb', ///
					`"`classvar':`var'"')] ///
					_col(29)  %9.0g ///
					`bias'[1,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(41) %9.0g ///
					`semat'[1,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(54) %9.0g ///
					`ecip'[1,colnumb(`bias', ///
					`"`classvar':`var'"')] ///
					_col(65) %9.0g ///
					`ecip'[2,colnumb(`bias', ///
					`"`classvar':`var'"')]    
			}
		}

		di as text "{hline 13}{c +}{hline 64}"
		local dcol = 14-length("`link' ")
		di as text _col(`dcol') "`link' " _col(14) "{c |}" 
		di as text "{hline 13}{c +}{hline 64}"
		local dcol = 14-length("_cons ")

		di as text _col(`dcol') /// 
			"_cons " _col(14) "{c |}" as result ///
			_col(18) %9.0g /// 
			`eb'[1,colnumb(`eb',`"`classvar':s_cons"')] ///
			_col(29) %9.0g /// 
			`bias'[1,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(41) %9.0g ///
			`semat'[1,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(54) %9.0g ///
			`ecip'[1,colnumb(`bias',`"`classvar':s_cons"')] ///
			_col(65) %9.0g ///
			`ecip'[2,colnumb(`bias',`"`classvar':s_cons"')]  
		di as text "{hline 13}{c BT}{hline 64}"
	}
end     

program Disempauc
	syntax, classvar(varlist) [nobootstrap] level(cilevel)

	if (`"`bootstrap'"'=="nobootstrap") {
		local nobootstrap nobootstrap
	}
	else {
		local nobootstrap ""
	}
        DC
	di as text "{hline 13}{c TT}{hline 64}"
	local dcol = 14 - length(`"auc "')
	di as text  _col(14) "{c |}" _col(19) ///
		"Observed" _col(42) "Bootstrap"

	local llen = 0
	// 10s place
	local llen = `llen' + 2
	if (floor(`level') != `level') {
		// decimal point
		local llen = `llen' + 1
	}
	if (100*(`level'-floor(`level')) > 9) {
		// tenth's place
		local llen = `llen' + 1
	}
	if (100*(`level'-floor(`level'))/10 != ///
		floor(100*(`level'-floor(`level'))/10)) {
		// hundredth's place
		local llen = `llen' + 1
	}
	local al = 58 -`llen'

	di as text _col(`dcol') `"AUC "' _col(14) "{c |}" ///
		_col(22) "Coef." _col(34) ///
		"Bias" _col(42) "Std. Err." _col(`al') ///
		`"[`=strsubdp("`level'")'% Conf. Interval]"'
	di as text "{hline 13}{c +}{hline 64}"

	tempname eb
	matrix `eb' = e(b)
	tempname ecin
	tempname ecip
	tempname ecibc 
	tempname bias
	tempname semat
	if(`"`nobootstrap'"' == "") {
		matrix `ecin' = e(ci_normal)
		matrix `ecip' = e(ci_percentile)
		matrix `ecibc' = e(ci_bc)
		matrix `bias' = e(bias)
		matrix `semat' = e(se)
	}
	else {
		local matnames: colfullnames `eb'
		matrix `ecin' = J(2,colsof(`eb'),.)
		matrix colnames `ecin' = `matnames'
		matrix `ecip' = J(2,colsof(`eb'),.)
		matrix colnames `ecip' = `matnames'
		matrix `ecibc' = J(2,colsof(`eb'),.)
		matrix colnames `ecibc' = `matnames'
		matrix `bias' = J(1,colsof(`eb'),.)
		matrix colnames `bias' = `matnames'
		matrix `semat' = J(1,colsof(`eb'),.)
		matrix colnames `semat' = `matnames'
	}	

	di as text _col(4) %9.0g `num' _col(14) "{c |}" as result ///
		_col(18) %9.0g ///
		`eb'[1,colnumb(`eb',`"`classvar':auc"')] ///
		_col(29) %9.0g /// 
		`bias'[1,colnumb(`bias',`"`classvar':auc"')] ///
		_col(41) %9.0g /// 
		`semat'[1,colnumb(`bias',`"`classvar':auc"')] ///
		_col(54) %9.0g ///
		`ecin'[1,colnumb(`bias',`"`classvar':auc"')] ///
		_col(65) %9.0g ///
		`ecin'[2,colnumb(`bias',`"`classvar':auc"')] ///
		_col(76) as text "(N)"
	di as txt _col(14) "{c |}" as res ///
		_col(54) %9.0g ///
		`ecip'[1,colnumb(`bias',`"`classvar':auc"')] ///
		_col(65) %9.0g /// 
		`ecip'[2,colnumb(`bias',`"`classvar':auc"')] ///
		_col(76) as text "(P)"
	di as txt _col(14) "{c |}" as res ///
		_col(54) %9.0g /// 
		`ecibc'[1,colnumb(`bias',`"`classvar':auc"')] ///
		_col(65) %9.0g /// 
		`ecibc'[2,colnumb(`bias',`"`classvar':auc"')] ///  
		_col(75) as text "(BC)"
	di as text "{hline 13}{c BT}{hline 64}"
end

program Disemp
	syntax, classvar(varlist) 		///
			stat(string) 		///
			statlist(numlist) 	///
			[nobootstrap] 		///
			level(cilevel)
	if (`"`bootstrap'"'=="nobootstrap") {
		local nobootstrap nobootstrap
	}
	else {
		local nobootstrap ""
	}
	DC
	di as text "{hline 13}{c TT}{hline 64}"
	local dcol = 14 - length(`"`stat' "')
	di as text  _col(14) "{c |}" ///
		 _col(19) "Observed" ///
		_col(42) "Bootstrap"
	local llen = 0
	// 10s place
	local llen = `llen' + 2

	if (floor(`level') != `level') {
		// decimal point
		local llen = `llen' + 1
	}
	if (100*(`level'-floor(`level')) > 9) {
		// tenth's place
		local llen = `llen' + 1
	}
	if (100*(`level'-floor(`level'))/10 != ///
		floor(100*(`level'-floor(`level'))/10)) {
		// hundredth's place
		local llen = `llen' + 1
	}
	local al = 58 -`llen'

	if (`"`stat'"' == "pauc") {
		local stabat pAUC
	}
	else if (`"`stat'"' == "invroc") {
		local stabat invROC
	}
	else {
		local stabat = upper(`"`stat'"') 
	}	
	di as text _col(`dcol') `"`stabat' "' _col(14) "{c |}" _col(22) ///
		"Coef." _col(34) "Bias" _col(42) ///
		"Std. Err." _col(`al') /// 
		"[`=strsubdp("`level'")'% Conf. Interval]"

	di as text "{hline 13}{c +}{hline 64}"
	tempname eb
	matrix `eb' = e(b)
	tempname ecin
	tempname ecip
	tempname ecibc 
	tempname bias
	tempname semat
	if(`"`nobootstrap'"' == "") {
		matrix `ecin' = e(ci_normal)
		matrix `ecip' = e(ci_percentile)
		matrix `ecibc' = e(ci_bc)
		matrix `bias' = e(bias)
		matrix `semat' = e(se)
	}
	else {
		local matnames: colfullnames `eb'
		matrix `ecin' = J(2,colsof(`eb'),.)
		matrix colnames `ecin' = `matnames'
		matrix `ecip' = J(2,colsof(`eb'),.)
		matrix colnames `ecip' = `matnames'
		matrix `ecibc' = J(2,colsof(`eb'),.)
		matrix colnames `ecibc' = `matnames'
		matrix `ecin' = J(2,colsof(`eb'),.)
		matrix colnames `ecin' = `matnames'
		matrix `bias' = J(1,colsof(`eb'),.)
		matrix colnames `bias' = `matnames'
		matrix `semat' = J(1,colsof(`eb'),.)
		matrix colnames `semat' = `matnames'
	}	

	local i = 1
	foreach num of numlist `statlist' {
		di as text _col(4) %9.0g `num' _col(14) "{c |}" as result ///
			_col(18) %9.0g ///
			`eb'[1,colnumb(`eb',`"`classvar':`stat'_`i'"')] ///
			_col(29) %9.0g ///
			`bias'[1,colnumb(`bias',`"`classvar':`stat'_`i'"')] ///
			_col(41) %9.0g ///
			`semat'[1,colnumb(`bias',`"`classvar':`stat'_`i'"')] ///
			_col(54) %9.0g ///
			`ecin'[1,colnumb(`bias',`"`classvar':`stat'_`i'"')] ///
			_col(65) %9.0g ///
			`ecin'[2,colnumb(`bias',`"`classvar':`stat'_`i'"')] ///
			_col(76) as text "(N)"
		di as txt _col(14) "{c |}" as res ///
			_col(54) %9.0g ///
			`ecip'[1,colnumb(`bias',`"`classvar':`stat'_`i'"')] ///
			_col(65) %9.0g ///
			`ecip'[2,colnumb(`bias',`"`classvar':`stat'_`i'"')] ///
			_col(76) as text "(P)"
		di as txt _col(14) "{c |}" as res ///
			_col(54) %9.0g ///
			`ecibc'[1,colnumb(`bias',`"`classvar':`stat'_`i'"')] ///
			_col(65) %9.0g ///
			`ecibc'[2,colnumb(`bias',`"`classvar':`stat'_`i'"')] ///
			_col(75)  as text "(BC)"
		local i = `i'+1
	}
	di as text "{hline 13}{c BT}{hline 64}"
end

// p-value for total test
program DispcontTOT 
	syntax, classvars(varlist)  stat(string) statlist(numlist) [nobootstrap]
	if (`"`bootstrap'"'=="nobootstrap") {
		local nobootstrap nobootstrap
	}
	else {
		local nobootstrap ""
	}
	di `""'
	
	if (`"`stat'"' == "pauc") {
		local stabat pAUC
	}
	else if (`"`stat'"' == "invroc") {
		local stabat invROC
	}
	else {
		local stabat = upper(`"`stat'"') 
	}
	
	di as text "Ho: " as text ///
		"All classifiers have equal " `"`stabat'"' " values."
	di as text "Ha: " as text ///
"At least one classifier has a different " `"`stabat'"' " value."
	di ""
	di as text "Test based on bootstrap (N) assumptions."
	di ""                                    
 	local f : word count `statlist'
	if (`f' > 1) {
		di as text "P-values not adjusted for multiple comparisons."
		di ""
	} 
	di as text `"`stabat'"' _col(11)  "{c |}" "   P-value"
	di as text `"{hline 10}{c +}{hline 10}"'
	local i = 1
	local cvnt: word count `classvars'
	foreach num of numlist `statlist' {
		local testlist ""
		local j = 1
		foreach var of local classvars {
			local testlist `testlist' "[`var']_b[`stat'_`i']"
			if (`j' < `cvnt') {
				local testlist `testlist' =
			}
			local j = `j' + 1
		}
		if (`"`nobootstrap'"' == "") {
			qui test `testlist'
			di as result %9.0g ///
				`num' _col(11) as txt "{c |}" ///
				as res _col(13) %9.0g r(p)
		}
		else {
			di as result %9.0g ///
				`num' _col(11) as txt "{c |}" ///
				as res _col(13) %9.0g .
		}
		local i = `i' + 1
	}
end


program Adjuste, eclass
syntax, level(real) bfile(string)
	local alpha = 1-(`level'/100)
	local ciuba = 1-(`alpha'/2)
	local cilba = `alpha'/2
	local tcilba = 100*`cilba' 
	local tciuba = 100*`ciuba'

	tempfile abbert
	tempname samp
	gen `samp' = e(sample)
qui	save `"`abbert'"'
qui	use `"`bfile'"', clear
	tempname eb
	tempname ese
	tempname ecin
	tempname ecibc
	tempname ecip
	local classvars `e(classvars)'
	local roccov `e(roccov)'
	local other i_cons s_cons auc	
	local tog `roccov' `other'
	matrix `eb' = e(b)
	matrix `ese' = e(se)
	matrix `ecin' = e(ci_normal)
	matrix `ecibc' = e(ci_bc)
	matrix `ecip' = e(ci_percentile)
	foreach var of local classvars {
		foreach rvar of local tog {
			foreach verb of varlist _all {
				local vlabel: variable label `verb'
				if (`"`vlabel'"'==  ///
					`"[`var']_b[`rvar']"') {
					// verb is the one we want
					local cin = ///
					colnumb(`eb',`"`var':`rvar'"')
					// normal 
					matrix `ecin'[2,`cin'] = ///
						 `eb'[1,`cin']+ ///
						 `ese'[1,`cin']* ///
						 invnormal(`ciuba')
					matrix `ecin'[1,`cin'] = ///
						 `eb'[1,`cin']- ///
						 `ese'[1,`cin']* ///
						 invnormal(`ciuba')
					// percentile
					qui _pctile `verb', ///
					percentile(`tcilba' `tciuba')
					matrix `ecip'[1,`cin'] = r(r1)
					matrix `ecip'[2,`cin'] = r(r2)
					// bias corrected
					qui count if `verb' <= ///
						`eb'[1,`cin']
					tempname z0
					scalar `z0' = ///
						invnormal(r(N)/_N)
					local p1 = 100*normal(`z0'+ ///
						(`z0'- ///
						invnormal(`ciuba')))
					local p2 = 100*normal(`z0'+ ///
				        	(`z0'+ ///
						invnormal(`ciuba')))
					if(`p1' == . | `p2' == .) {
						matrix `ecibc'[1, ///
							`cin'] = .
						matrix `ecibc'[2, ///
							`cin'] = .
					}
					else {
						qui _pctile `verb', ///
							percentile( ///
							`p1' `p2')
						matrix `ecibc'[1, ///
							`cin'] = r(r1)
						matrix `ecibc'[2, ///
							`cin'] = r(r2)
					}
				}
			}
		}
	}	
	ereturn matrix ci_normal = `ecin'
	ereturn matrix ci_bc = `ecibc'
	ereturn matrix ci_percentile = `ecip'
	ereturn scalar level = `level'
qui	use `"`abbert'"', clear
	ereturn repost , esample(`samp') 
end

program DC
	if (`"`e(clustvar)'"' != "" & `"`e(nobootstrap)'"'=="") {
		local a = e(N_clust)
		local b = string(`a',"%12.0fc")
		di ///
			as text "{ralign 78:(Replications based on " ///
			as result "`b'" as text " clusters in " ///
			"`e(clustvar)')}"
	}
end
exit
