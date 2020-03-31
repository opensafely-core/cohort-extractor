*! version 1.3.1  05dec2018
program define eteffects, eclass byable(onecall)
	version 14

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	`BY' _vce_parserun eteffects, noeqlist jkopts(eclass): `0'
        
	if "`s(exit)'" != "" {
		ereturn local cmdline `"eteffects `0'"'
		exit
	}

        if replay() {
                if `"`e(cmd)'"' != "eteffects" { 
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
	ereturn local cmdline `"eteffects `0'"'
end

program define Estimate, eclass byable(recall)
	syntax anything [if] [in] 			///
			[fweight iweight pweight],	///
			[				///
			ate 				///
			atet 				///
			POMeans        			///
			AEQuations              	///
			CONtrol(passthru)       	///
			TLEvel(passthru)        	///
			from(string)			///
			ITERate(string)			///
			vce(string)			///
			NOLOg LOg			///
			FRACtional			///
			noCONstant			///
			PSTOLerance(real 1e-5)		///
			OSample(string)			///
                        * 				///
			]

        // Getting options and invalid display options
        
        _get_diopts diopts other, `options' 
        quietly capture Display, `diopts' `other' 
	
        if _rc==198 {
                Display, `diopts' `other'	
	}
	
	marksample touse
	
	// noconstant
	
	if "`constant'"!="" {
		di as err "option {bf:`constant'} is not allowed"
		exit 198
	}

	// Getting weights 
	
	if "`weight'" != "" {
		local wgt [`weight' `exp']
	}
	
	local wtype "`weight'"
	local wexp  "`exp'"
	
	// Verifying that outcome and treatment model are well specified
	
	local 0 `anything'
	_parse expand eqn op : 0, gweight

        local tmp : subinstr local anything "(" "(", all count(local left)
        local tmp : subinstr local anything ")" ")", all count(local right)
        _parse canonicalize canon : eqn op

        local cannon : list retokenize cannon
        if `eqn_n' == 1 {
                local canon (`canon')
        }
        
        local k = 0
        forvalues i=`eqn_n'(-1)1 {
                local eqn_`i' : list retokenize eqn_`i'
                local tmp : subinstr local eqn_`i' "(" "(", all ///
                        count(local ki)
                local k = `k' + `ki'+1

               local eqn_`i' `"`eqn_`i''"'
        }
        if `left'!= `k' | `right'!=`k' {
		local modelos outcome-model or treatment-model
		di as err "invalid `modelos' specifications; "
                di as txt "{p 4 4 4}" 
		di as smcl as err "The model specifications should be" 
		di as smcl as err "enclosed in parentheses, or you are" 
		di as smcl as err "missing the comma preceding the options."
		di as smcl as err "{p_end}"
		 exit 198
        }
        local eqn_n = `eqn_n'
        local anything `"`canon'"'

	gettoken y first: eqn_1
	gettoken t second: eqn_2

	// Getting varlists, depvarlists, and options for estimation (parsing)
	
	tempvar y0n y1n 
	gettoken yconso: y, parse(",")
	gettoken tconso: t, parse(",")

	if "`y'"!="`yconso'" {
		CoNsYt `y' `first'
		local y `yconso'
		local ovarlist   = ""	
		local ocons      = "_cons"
		local oconst     = "constant"
		local omodel     = "`s(omodel)'"
	}
	else {
		gettoken ovarlist first:    first  , parse(",")   
		gettoken omodelopts first:  first  , parse(",")
		ChecK__TeIVomodEL, `first'
		local ocons  = "`s(ocons)'"
		local omodel = "`s(omodel)'"
		local oconst = "`s(oconst)'"
		capture VaRliS_T `ovarlist'
		if (_rc == 101|_rc ==111| _rc==109) {
			display as error "for the outcome model:"
			VaRliS_T `ovarlist'
		}
		else {
			local ovarlist = "`s(variables)'"
		}
	}
	if "`t'"!="`tconso'" {
		CoNsYt `t' `second' model(3)
		local t `tconso'
		local tvarlist = ""
		local tcons    = "_cons"
		local tmodel   = "`s(tmodel)'"
		local tconst   = "constant"
	}
	else {
		gettoken tvarlist second:   second , parse(",")
		gettoken tmodelopts second: second , parse(",")
		ChecK__TeIVtmodEL, `second'
		local tcons  = "`s(tcons)'"
		local tmodel = "`s(tmodel)'"
		local tconst = "`s(tconst)'"
		capture VaRliS_T `tvarlist'
		if (_rc == 101|_rc ==111| _rc==100| _rc==109) {
			display as error "for the treatment model:"
			VaRliS_T `tvarlist'
		}
		else {
			local tvarlist = "`s(variables)'"
		}
	}
	
	capture _fv_check_depvar `y'
	if _rc!=0 {
		di as err "for the outcome model;"
		_fv_check_depvar `y'
		exit _rc
	}
	quietly capture _fv_check_depvar `t'
	if _rc!=0 {
		di as err "for treatment model;"
		_fv_check_depvar `t'
		exit 198
	}

	quietly clonevar `y0n' = `y' `if' `in'
	quietly clonevar `y1n' = `y' `if' `in'

	// Getting factor, omitted, ## variables and varlist for gmm

	__uNo__LoCo if `touse' `wgt', lista(`ovarlist') outcome `oconst'
	
	local ovars = "`s(vars)'"
	local oiv   = "`s(vars)'"

	__uNo__LoCo if `touse' `wgt', lista(`tvarlist') `tconst'
	
	local tvars = "`s(vars)'"
	local tiv   = "`s(vars)'"

	// Getting stripes for the gmm functions 	

	tempvar  betat beta0 beta1
	tempname hate hatet pom1 pom0 init uhat	

	if "`ocons'"=="" {
		local ovars2  = "`ovars'"
		local ovars   = "`ovars' `uhat'"
		local econso = 0
	}
	else {
		local ovars2 = "`ovars' _cons"
		local ovars  = "`ovars' `uhat' _cons"
		local econso = 1
	}
	if "`tcons'"=="" {
		local tvars = "`tvars'"
		local econst = 0
	}
	else {
		local tvars = "`tvars' _cons"
		local econst = 1
	}
	
	local tn: list sizeof tvars
	local on: list sizeof ovars
	local newon = `on' - 1
	local permn: list sizeof ovars2  
	local teq   = ""
	local oeq0  = ""
	local oeq1  = ""
	local oeq02 = ""
	local oeq12 = ""
	
	local permcons = 0 			   // for permutation vector
	if (`permn'==1 & "`ovars2'"==" _cons") {
		local permcons = 1
	}

	forvalues i = 1/`tn' {
		local eqs: word `i' of `tvars'
		local teq = "`teq' `t':`eqs'"
	}
	forvalues i = 1/`on' {
		local eqs: word `i' of `ovars'
		local oeq0 = "`oeq0' `y0n':`eqs'"
		if (`i' < `on') {
			local eqs2: word `i' of `ovars2'
			local oeq02 = "`oeq02' `y0n':`eqs2'"
		}
	}
	forvalues i = 1/`on' {
		local eqs: word `i' of `ovars'
		local oeq1 = "`oeq1' `y1n':`eqs'"
		if (`i' < `on') {
			local eqs2: word `i' of `ovars2'
			local oeq12 = "`oeq12' `y1n':`eqs2'"
		}
	}


	// Parsing statistic options
	
	local stat "`ate'`atet'`pomeans'" 
	local suma = ("`ate'"!="") + ("`atet'"!="") + ("`pomeans'"!="") 
	
	if `suma'>1 {
		display as err "at most one of {bf:ate}, {bf:atet}, or " ///
			       "{bf:pomeans} may be specified"
		exit 198
	}
	if "`stat'"=="" {
		local estadistica = "ate"
	}
	else {
		local estadistica = "`stat'"
	}

	// Getting t - E(t|x,z) and starting values 

	INIT__vAlUeS if `touse' `wgt', yo(`y') ovars(`oiv') 		///
			oconst(`oconst') yt(`t') tvars(`tiv')		///
			tconst(`tconst') uhat(`uhat') omodel(`omodel')	///
			pstolerance(`pstolerance') osample(`osample')	///
			estad(`estadistica')
		
	matrix `beta0' = e(beta0)
	matrix `beta1' = e(beta1)
	matrix `betat' = e(betat)
	scalar `hate'  = e(ate)
	scalar `hatet' = e(atet)
	scalar `pom0'  = e(pom0)
	scalar `pom1'  = e(pom1)
	local nt       = e(nt)
	local N        = e(N)



	// Getting options for display table

	local coeftab = 0 
	
	if "`aequations'"!="" {
		local coeftab = 1
	}
	if ("`estadistica'"=="pomeans" & "`aequations'"=="") {
		local coeftab = 2
	}

	// Getting initial values
	
	local oiv2 = "`oiv'"
	local oiv  =  "`oiv' `uhat'"
	
	if "`estadistica'"== "ate"{
		matrix `init'  = `hate', `pom0', `betat', `beta0', `beta1', ///
				 `pom1', `hatet'
		local equations  ate pom0 t y0 y1  pom1 atet
		local parameters ate:_cons pom0:_cons `teq' `oeq02' `oeq12'  ///	
				 pom1:_cons atet:_cons
	}
	if "`estadistica'"=="atet"{
		matrix `init'  =`hatet', `pom0', `betat', `beta0', `beta1', ///
				 `pom1', `hate'
		local equations  atet pom0  t y0 y1 pom1 ate
		local parameters atet:_cons pom0:_cons `teq' `oeq02' `oeq12' ///	
				 pom1:_cons ate:_cons
	}
	if "`estadistica'"=="pomeans"{
		matrix `init'  =`pom0', `pom1', `betat', `beta0', `beta1',  ///
				 `hate', `hatet'
		local equations  pom0 pom1 t y0 y1  ate atet
		local parameters pom0:_cons pom1:_cons `teq' `oeq02' `oeq12' ///	
				  ate:_cons atet:_cons
	}

	local fromcheck = colsof(`init')

	// Parsing the from option 
	
	tempname betafrom 
	local tnfrom = colsof(`betat')
	local bnfrom = colsof(`beta1')


	if ("`from'" !="" & "`estadistica'"=="ate") {
		_mkvec `betafrom', from(`from') error("from()")
		matrix `init' = `betafrom', `pom1', `hatet'
		local fromcheck2 = colsof(`init')
		if `fromcheck2'!=`fromcheck' {
			display as err "initial matrix must have as many" ///
				" columns as parameters in model"
			exit 480
		}
		mata: _IVteFFEcts__PeRmuTEs_from(`bnfrom', `tnfrom', ///
						 "`init'", `econso')
	} 
	if ("`from'" !="" & "`estadistica'"=="atet") {
		_mkvec `betafrom', from(`from') error("from()")
		matrix `init' = `betafrom', `pom1', `hate'
		
		local fromcheck2 = colsof(`init')
		if `fromcheck2'!=`fromcheck' {
			display as err "initial matrix must have as many" ///
				" columns as parameters in model"
			exit 480
		}
		mata: _IVteFFEcts__PeRmuTEs_from(`bnfrom', `tnfrom', ///
						  "`init'", `econso')
	}
	if ("`from'" !="" & "`estadistica'"=="pomeans") {
		_mkvec `betafrom', from(`from') error("from()")
		matrix `init' = `betafrom', `hate', `hatet'
		
		local fromcheck2 = colsof(`init')
		if `fromcheck2'!=`fromcheck' {
			display as err "initial matrix must have as many" ///
				" columns as parameters in model"
			exit 480
		}
		mata: _IVteFFEcts__PeRmuTEs_from(`bnfrom', `tnfrom', ///
						  "`init'", `econso')
	}

	
	// Parsing vce() option 
	
	 local nvce: list sizeof vce
	
	if `nvce' == 0 {
		local clust = ""
		local tvce  = "robust"
		local type  = "Robust" 
	}
	if `nvce' == 1 {
		cap qui Variance, `vce'
		if _rc!=0 {
			display as error "invalid {bf:vce()} option"
			exit _rc
		}
		local clust = ""
		local tvce robust
		local type Robust
	}
	if `nvce' == 2 {                
		local cluster: word 1 of `vce'
		local clustervar: word 2 of `vce'

		tempvar cuentasclust 
		Clusters `clustervar', `cluster'
		local clust = e(clustervar)
		quietly egen `cuentasclust' = group(`clustervar')
		quietly sum `cuentasclust' if `touse'
		local cuentasclusts = r(max)
		local var = e(var)
		local tvce cluster
		local type Robust
	}
	
	if  ("`weight'" == "pweight") {
		local clust = ""
		local tvce robust
		local type Robust
	}
	
	if "`iterate'" == "" {
		local iterate = 16000
	}
	else {
		local iterate  = real("`iterate'")
	}
	
	if (`iterate' < 0| `iterate' > 16000| ///
	int(`iterate')!=`iterate'| `iterate'==.) {
		display as err  "{bf:iterate()} must be an integer" ///
				" between 0 and 16,000"
		exit 198
	} 

	// Selecting appropriate GMM evaluator 
	
	local estimadorgmm _iv__treat2
		
	if "`omodel'" == "exponential" {
		local estimadorgmm _iv__treat3
	}
	if ("`omodel'" == "probit"| "`omodel'" == "fractional"){
		local estimadorgmm _iv__treat4
	}

	// Using GMM to compute standard errors

	
	tempvar tD
	quietly summarize `t', meanonly
	quietly generate `tD' = `t'-r(min)
	quietly replace `tD'  = 1 if `tD'>0
	quietly replace `tD'  = 1 if (`tD'>0 & !missing(`tD'))
	markout `touse' `y0n' `y1n' `tD' `oiv2' `tiv' `uhat'

	// Reordering initial values 
	
	tempname inicio2
	matrix `inicio2' = `init'
	local fin   = `on'*2 + `tn' + 4
	local fin1  = 2 + `tn' + `newon' -`econso'
	local init1 = `fin1' + 2
	local fin2  = `fin1' + 1 + `newon'
	local init2 = `fin2' + 2
	mata: st_matrix("`init'", ///
	      st_matrix("`init'")[1,(1..`fin1', `init1'..`fin2', ///
				`init2'..`fin', `fin1'+1, `fin2'+1)])

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'`s(log)'"
	if ("`log'"== "log" | "`log'"== ""){
		if "`from'" == "" {
			display ""
			cap noi gmm `estimadorgmm'		///
			`wgt' if `touse' , y0(`y0n') y1(`y1n') ty(`tD') ///
			equations("`equations' uhat0 uhat1") 		///
			parameters("`parameters' uhat0:`uhat' uhat1:`uhat'") ///
			instruments(y0:`oiv2', `oconst') 		///
			instruments(y1:`oiv2', `oconst')		///
			instruments(t: `tiv', `tconst') 		///
			quickderivatives				///
			winit(unadjusted, independent) onestep		///
			valueid("EE criterion") 			///
			from(`init') iterlogonly			///
			 stat("`estadistica'") 		 		///
			conv_maxiter(`iterate') vce(`vce') 		///
			tn(`nt') nn(`N')  uhat(`uhat') haslfderivatives ///
			fin(`fin') `log'
		}
		else {
			display ""
			cap noi gmm `estimadorgmm'		///
			`wgt' if `touse' , y0(`y0n') y1(`y1n') ty(`tD') ///
			equations("`equations' uhat0 uhat1") 		///
			parameters("`parameters' uhat0:`uhat' uhat1:`uhat'") ///
			instruments(y0:`oiv2', `oconst') 		///
			instruments(y1:`oiv2', `oconst')		///
			instruments(t: `tiv', `tconst') 		///
			quickderivatives				///
			winit(unadjusted, independent) onestep		///
			valueid("EE criterion") 			///
			from(`init') iterlogonly			///
			 stat("`estadistica'") 		 		///
			conv_maxiter(`iterate') vce(`vce') 		///
			tn(`nt') nn(`N')  uhat(`uhat') haslfderivatives ///
			fin(`fin') `log'
		}
	}
	else {
		if "`from'" == "" {
			display ""
			cap noi gmm `estimadorgmm'		///
			`wgt' if `touse' , y0(`y0n') y1(`y1n') ty(`tD') ///
			equations("`equations' uhat0 uhat1") 		///
			parameters("`parameters' uhat0:`uhat' uhat1:`uhat'") ///
			instruments(y0:`oiv2', `oconst') 		///
			instruments(y1:`oiv2', `oconst')		///
			instruments(t: `tiv', `tconst') 		///
			quickderivatives				///
			winit(unadjusted, independent) onestep		///
			valueid("EE criterion") 			///
			from(`init') iterlogonly			///
			 stat("`estadistica'") 		 		///
			conv_maxiter(`iterate') vce(`vce') 		///
			tn(`nt') nn(`N')  uhat(`uhat') haslfderivatives ///
			fin(`fin') `log'
		}
		else {
			display ""
			cap noi gmm `estimadorgmm'		///
			`wgt' if `touse' , y0(`y0n') y1(`y1n') ty(`tD') ///
			equations("`equations' uhat0 uhat1") 		///
			parameters("`parameters' uhat0:`uhat' uhat1:`uhat'") ///
			instruments(y0:`oiv2', `oconst') 		///
			instruments(y1:`oiv2', `oconst')		///
			instruments(t: `tiv', `tconst') 		///
			quickderivatives				///
			winit(unadjusted, independent) onestep		///
			valueid("EE criterion") 			///
			from(`init') iterlogonly			///
			 stat("`estadistica'") 		 		///
			conv_maxiter(`iterate') vce(`vce') 		///
			tn(`nt') nn(`N')  uhat(`uhat') haslfderivatives ///
			fin(`fin') `log'
		}	
	}

	tempvar samplepg
	local N  = e(N)
	local rc = c(rc)
	local rank = e(rank)
	local converged = e(converged)
	quietly generate `samplepg'  = e(sample)
	
	if `rc' {
                if (`rc'>1) di as err "{bf:gmm} estimation failed"
                exit `rc'
	}
	
	// Reordering final computations 
	
	tempname A V 
	
	matrix `A' = e(b)
	matrix `V' = e(V)
	local testing = colsof(`A')
	mata: st_matrix("`A'", st_matrix("`A'")[(1..(`testing'-4), ///
	(`testing'-1)..(`testing'))])
	mata: st_matrix("`V'", st_matrix("`V'")[(1..(`testing'-4), ///
	(`testing'-1)..(`testing'))', (1..(`testing'-4), ///
	(`testing'-1)..(`testing'))]) 
	
	// Presenting output and prediction 

	
	tempname betas varianza betaf varf
	
	matrix `betas'    = `A'
	matrix `varianza' = `V'
	local kn  	  = colsof(`betas')
	local bn          = colsof(`beta0')-1
	local btn         = colsof(`betat')

	tempname beta1p beta0p beta1t beta0t

	if ((`econso'==1 & `permcons'==0)) {
		matrix `beta0p' = `inicio2'[1, 2+`btn' + 1..2+`btn'+`bn'-1], ///
			          `inicio2'[1, 2+`btn'+`bn'+1], ///
				  `inicio2'[1, 2+`btn'+`bn']
		matrix `beta1p' = `inicio2'[1, 2+`btn'+`bn'+2..2+ ///
				   `btn'+`bn'*2], ///
				   `inicio2'[1,2+`btn'+`bn'*2 +2], ///
				   `inicio2'[1,2+`btn'+`bn'*2 +1]
	}
	if ((`econso'==1 &  `permcons'==1)) {
		matrix `beta0p' = `inicio2'[1, 2+`btn' + 2], ///
			          `inicio2'[1, 2+`btn'+1]
		matrix `beta1p' = `inicio2'[1, 2+`btn'+ 4], ///
				  `inicio2'[1, 2+`btn'+ 3]
	}
	if (`econso'==0) {
		matrix `beta0p' = `inicio2'[1, 2+`btn' + 1..2+`btn'+`bn'+1]
		matrix `beta1p' = `inicio2'[1, 2+`btn'+`bn'+2..2+`btn'+`bn'+2 ///
					  + `bn']
	}

	local kn2       =  colsof(`beta0p')
	matrix `beta0t' = `beta0p'[1, 1..`kn2'-1]
	matrix `beta1t' = `beta1p'[1, 1..`kn2'-1]
	
	if "`estadistica'"=="ate" {
		local hate = `betas'[1,1]
		local pom0 = `betas'[1,2]
	}
	
	if "`estadistica'"=="atet" {
		local hatet = `betas'[1,1]
		local pom0 = `betas'[1,2]
	}
	
	if "`estadistica'"=="pomeans" {
		local pom0 = `betas'[1,1]
		local pom1 = `betas'[1,2]
	}

	Stri_PE_S, stat(`estadistica') tr(`t') ovars(`ovars2') tvars(`tvars')

	local stripe = "`s(stripe)'"


	/*matrix `betas'             = `betas'[1,1..`kn'-2]
	matrix `varianza'          = `varianza'[1..`kn'-2,1..`kn'-2]*/
	
	/*mata: _IVteFFEcts__PeRmuTEs(`bn', `btn', "`betas'", "`varianza'", ///
					`econso', `permcons')*/

	matrix colnames `betas'    = `stripe'
	matrix colnames `varianza' = `stripe'
	matrix rownames `varianza' = `stripe'

	ereturn post `betas' `varianza', esample(`samplepg') obs(`N')  ///
		buildfvinfo
		
	ereturn local depvar "`y'"
	ereturn local tvar   "`t'"
	ereturn local stat   "`estadistica'"
	ereturn local omodel "`omodel'"
	ereturn hidden local tmodel "`tmodel'"
	ereturn local vce "`tvce'"
        ereturn local clustvar "`clust'"
	ereturn local vcetype "`type'"
	ereturn hidden local coeftab  = `coeftab'
	ereturn scalar converged      = `converged'
	ereturn scalar rank   	      = `rank'
	ereturn hidden matrix beta0   = `beta0p'
	ereturn hidden matrix beta1   = `beta1p'
	ereturn hidden matrix beta0t  = `beta0t'
	ereturn hidden matrix beta1t  = `beta1t'
	ereturn hidden matrix betat   = `betat'
	ereturn hidden scalar hate    = `hate'
	ereturn hidden scalar hatet   = `hatet'
	ereturn hidden scalar pom0    = `pom0'
	ereturn hidden scalar pom1    = `pom1' 
	ereturn hidden local  tvars   = "`tiv'"
	ereturn hidden local  ovars   = "`oiv2'"
	ereturn hidden scalar conso   = `econso'
	ereturn hidden scalar const   = `econst'
	ereturn hidden scalar control = 0
	ereturn hidden scalar treated = 1
	ereturn local tlevels  = "0 1"  
	
	if "`cuentasclusts'" != "" {
		ereturn scalar N_clust  = `cuentasclusts'
	}
	if "`estadistica'"=="pomeans"{
		ereturn scalar k_eq = 6	
	}
	else {
		ereturn scalar k_eq = 7
	}
	
	ereturn scalar k_levels = 2
	ereturn scalar n1       = `N'-`nt'
	ereturn scalar n0       = `nt'
	ereturn local predict "eteffects_p"
	ereturn local estat_cmd eteffects_estat
	ereturn local cmd    "eteffects"
	ereturn local wtype "`wtype'"
	ereturn local wexp  "`wexp'"
	ereturn local marginsnotok _ALL
	ereturn hidden local _contrast_not_ok "_ALL"
	ereturn local title "Endogenous treatment-effects estimation"
	
	local diopts `diopts'
	Display, bmatrix(e(b)) vmatrix(e(V))  `other'	///
		versus `aequations' `diopts' 		

end

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// Auxiliary programs /////////////////////////////
//////////////////////////////////////////////////////////////////////////////

program define Display
        syntax [, bmatrix(passthru) vmatrix(passthru) versus *]

        _get_diopts diopts rest, `options'
        local myopts `bmatrix' `vmatrix' 
	
	local omodel = "`e(omodel)'"
	local tmodel = "`e(tmodel)'"
	local stat   = e(coeftab)
	
	if `"versus"' !="" {
		local vs = "versus"
        }

        if (("`rest'"!="aequations"&"`rest'"!="aequation"&	///
		"`rest'"!="aequatio"&"`rest'"!="aequati"&	///
		"`rest'"!="aequat" & "`rest'"!="aequa" &	///
		"`rest'"!="aequ" & "`rest'"!="aeq") & "`rest'"!=""){
                display "{err}option `rest' not allowed"
                exit 198
        }
	
	local taball = 0 
	
	if ("`rest'"=="aequations"|"`rest'"=="aequation"|	///
		"`rest'"=="aequatio"|"`rest'"=="aequati"|	///
		"`rest'"=="aequat" |"`rest'"=="aequa" |	///
		"`rest'"=="aequ" | "`rest'"=="aeq") {
			local taball = 1
	}

	_coef_table_header, title(Endogenous treatment-effects estimation) 
        noi display as text "Outcome model  : {res:`omodel'}"
	noi display as text "Treatment model: {res:`tmodel'}"
	if (`stat'==1 | `taball'==1) {
		_coef_table,  `diopts' `myopts' notest  `vs'
        }
	if (`stat'==0 & `taball'==0) {
		_coef_table,  `diopts' `myopts' notest neq(2) `vs'
	}
	if (`stat'==2 &`taball'==0) {
		_coef_table,  `diopts' `myopts' notest neq(1) `vs'
	}
end


program define VaRliS_T, sclass
	syntax varlist(fv numeric)
	sreturn local variables = "`varlist'"
end

program define INIT__vAlUeS, eclass 
	syntax [if][in]			///
	[fweight iweight pweight],	///
	yo(string)			///
	yt(string)			///
	[tvars(string)			///
	ovars(string)			///
	uhat(string)			///
	oconst(string)			///
	tconst(string)			///
	omodel(string)			///
	PSTOLerance(real 1e-5)		///
	osample(string)			///
	estad(string)			///
	]
	
	marksample touse
	markout `touse' `yt' `yo' `tvars' `ovars'
	
	tempvar  y0 y1 pate patet that tcomp probite yt3 lny
	tempname betat ate atet pom0 pom1 beta1 beta0 xb1 xb0 pte pate ///
		 pscore expint 
	
	if "`weight'" != "" {
		local wgt [`weight' `exp']
		local wgt2 [`weight' `exp']
		if ("`weight'"== "pweight") { 
			local wgt2 [iw `exp']
		}
	}
	
	quietly tab `yt'
	local yt2 = r(r)
	
	if `yt2'!=2 {
		display as err ///
		"treatment variable {bf:`yt'} must have two distinct values"
		exit 459
	}
	
	quietly summarize `yt' if `touse', meanonly 
	local menor = r(min)
	capture assert `menor' > = 0 
	local rc = _rc
	if `rc' {
		di as err "treatment variable {bf:`yt'} must be positive " 
		exit 459
	}
	quietly generate `yt3' = `yt' - r(min)
	quietly replace `yt3' = 1 if (`yt3'>0 & !missing(`tD'))
	quietly capture _teffects_validate_catvar `yt3', ///
		argname(treatment variable) touse(`touse') binary 
	local rc = _rc
	if (`rc'==459) {
		local argname treatment variable
                di as err "{p}`argname' {bf:`yt'} must contain " ///
                 "nonnegative integers{p_end}"
                exit 459
	}
	quietly capture _teffects_validate_catvar `yt', ///
		argname(treatment variable) touse(`touse') binary 
	local rc = _rc
	if (`rc'==459) {
		local argname treatment variable
                di as err "{p}`argname' {bf:`yt'} must contain " ///
                 "nonnegative integers{p_end}"
                exit 459
	}

	quietly summarize `yt3' if (`touse' & `yt3'==1) `wgt2'
	local tn = r(N)
	
	if `tn'==0 {
		display as err _newline "for the treatment model:"
		display as err "no observations"
		exit 2000
	}

	capture _rmcoll `yt3' if `touse', `tconst' probit
	local rc = _rc
	
	if (`rc'==2000) {
		display as text _newline "for the treatment model:" 
		_rmcoll `yt3' if `touse', `tconst' probit
	}

	quietly capture probit `yt3' `tvars' `wgt' if `touse', `tconst' 
	local rc = _rc
	local converge = e(converged) 
	generate `probite'= e(sample)
	
	
	if (`rc'!= 0) {
		di as err "{p}{it:tmodel} {cmd:`tmodel'} initial " ///
			"estimates failed{p_end}"
		exit `rc' 
	}
	if `converge'== 0 {
		di as err "{p}{it:tmodel} {cmd:`tmodel'}" ///
		"estimates did not converge {p_end}"
		exit 430	
	}
	
	// Overlaps 

	quietly predict double `that' if `touse'
	quietly count if ///
		(abs(1-`that') < `pstolerance' & `touse')
	local ptolt1 = r(N)
	qui count if (missing(`that') & `touse' & `probite'==1)
	local faltap = r(N)
	quietly count if ///
		(abs(`that') < `pstolerance'& `touse')
	local ptolt2 = r(N)
	
	if "`osample'" != "" {
		qui gen byte `osample' = 0 
		qui replace `osample' = 1 ///
				if (abs(1-`that') < `pstolerance' | ///
				abs(`that') < `pstolerance'| `faltap'>0)
		label variable `osample' "overlap violation indicator"
		exit 498
	}
	else {
		if `faltap'>0 {
			di as err ///
			"predicted probabilities from probit generate " ///
			"`faltap' missing values"
		}
		if `ptolt1'>0 {
			di as err 					///
			"probability of being untreated" 		///
			" yields `ptolt1' propensity scores less" 	///
			" than"  %9.3e `pstolerance'
		}
		if (`ptolt2'>0) {
			di as err ///
			"probability of being treated" 			///
			" yields `ptolt2' propensity scores less" 	///
			" than"  %9.3e `pstolerance'
		}
		if (`ptolt2'>0 | `ptolt1'>0| `faltap'>0) {
			di as err ///
			"{p}treatment overlap assumption has been " ///
			 "violated" _c
			local link eteffects##osample:osample
			if "`osample'" != "" {
				di as err ///
				" by observations identified in variable " ///
				 "{helpb `link'}{bf:(`osample')}{p_end}"
			}
			else {
				di as err ///
				"; use option {helpb `link'}" ///
			     "{bf:()} to identify the overlap violators{p_end}"
			}
			exit 498
		}
	}
	quietly generate double `uhat' = `yt3' - `that' if `touse'
	matrix `betat' = e(b)
	
	if "`omodel'"=="linear" {
		quietly capture reg `yo' `ovars' `uhat' ///
			if (`yt3'==1 & `touse') `wgt', `oconst'
		local rc = _rc
		local converge = e(converged) 
		if (`rc'!=0) {
			di as err "{p}{it:omodel} {cmd:`omodel'} initial " ///
				"estimates failed{p_end}"
			exit `rc' 
		}
		if `converge'== 0 {
			di as err "{p}{it:omodel} {cmd:`omodel'}" ///
			"estimates did not converge {p_end}"
			exit 430	
		}
		
		if "`estad'"=="atet" {
			quietly predict double `y1' if `touse' 
			matrix `beta1'     = e(b)

			quietly summarize `y1' `wgt2' if (`touse' & `yt3'==1)
			scalar `pom1' = r(mean)
			
			quietly capture reg `yo' `ovars' `uhat'  ///
				if (`yt3'==0 & `touse') `wgt', `oconst'
			local rc = _rc
			local converge = e(converged) 
			if (`rc'!= 0) {
				di as err ///
				"{p}{it:omodel} {cmd:`omodel'} initial " ///
				"estimates failed{p_end}"
				exit `rc' 
			}
			if `converge'== 0 {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				"estimates did not converge {p_end}"
				exit 430	
			}
			
			matrix `beta0' = e(b)

			quietly predict double `y0'  if `touse'
			quietly summarize `y0' `wgt2' if (`touse' & `yt3'==1)
			scalar `pom0' = r(mean)
			quietly generate double `pate'  = `y1'-`y0' if `touse'
			quietly summarize `pate' `wgt2' if `touse'
			scalar `ate' = r(mean)
			local N      = r(N)
			quietly generate double `patet' = ///
					(`y1'-`y0')*(`N'/`tn')*`yt3' if `touse'
			quietly summarize `patet' `wgt2' if `touse'
			scalar `atet' = r(mean)	
		}
		else {
			quietly predict double `y1' if `touse' 
			matrix `beta1'     = e(b)

			quietly summarize `y1' `wgt2' if `touse'
			scalar `pom1' = r(mean)
			
			quietly capture reg `yo' `ovars' `uhat'  ///
				if (`yt3'==0 & `touse') `wgt', `oconst'
			local rc = _rc
			local converge = e(converged) 
			if (`rc'!= 0) {
				di as err ///
				"{p}{it:omodel} {cmd:`omodel'} initial " ///
				"estimates failed{p_end}"
				exit `rc' 
			}
			if `converge'== 0 {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				"estimates did not converge {p_end}"
				exit 430	
			}
			
			matrix `beta0' = e(b)

			quietly predict double `y0'  if `touse'
			quietly summarize `y0' `wgt2' if `touse' 
			scalar `pom0' = r(mean)
			quietly generate double `pate'  = `y1'-`y0' if `touse'
			quietly summarize `pate' `wgt2' if `touse'
			scalar `ate' = r(mean)
			local N      = r(N)
			quietly generate double `patet' = ///
					(`y1'-`y0')*(`N'/`tn')*`yt3' if `touse'
			quietly summarize `patet' `wgt2' if `touse'
			scalar `atet' = r(mean)	
		}
		ereturn scalar ate   = `ate'
		ereturn scalar atet  = `atet'
		ereturn scalar pom1  = `pom1'
		ereturn scalar pom0  = `pom0'
		ereturn matrix beta0 = `beta0'
		ereturn scalar N     = `N'
		ereturn matrix beta1 = `beta1'
	}
	if "`omodel'"=="exponential" {
	
		local ovars `ovars' `uhat'
		local nb: list sizeof ovars
		local expcons = 0 

	
		if ("`oconst'"==""|"`oconst'"=="constant") {
			local expcons = 1
			local nb = `nb' +  1
		}
		
		quietly generate double `tcomp' = 1 - `yt3'
		quietly generate `lny' = ln(`yo')
		quietly regress `lny' `ovars', `oconst'
		matrix `expint' = e(b)
		
		local on: list sizeof ovars
		local oeq0 = ""

		forvalues i = 1/`on' {
			local eqs: word `i' of `ovars'
			local oeq0 = "`oeq0' `yo':`eqs'"
		}
		if (`expcons'==1) {
			local oeq0 = "`oeq0' `yo':_cons"
		}
	
		quietly gmm _iv__treat5				///
		 `wgt' if `touse', y1(`yo') ty(`yt3')		///
		equations("`yo'") 				///
		parameters("`oeq0'") 				///
		instruments(`yo':`ovars', `oconst') 		///
		onestep quickderivatives 			///
		winit(unadjusted, independent) 			///
		from(`expint') 					///
		conv_maxiter(100) vce(`vce') 			///
		haslfderivatives 
		matrix `beta1'   = e(b)
		matrix score double `y1' = `beta1' 
		quietly replace `y1'      = exp(`y1')

		quietly gmm _iv__treat5				///
		 `wgt' if `touse', y1(`yo') ty(`tcomp')		///
		equations("`yo'") 				///
		parameters("`oeq0'") 				///
		instruments(`yo':`ovars', `oconst') 		///
		onestep quickderivatives 			///
		winit(unadjusted, independent) 			///
		from(`expint') 					///
		conv_maxiter(100) vce(`vce') 			///
		haslfderivatives 
		matrix `beta0'   = e(b)
		matrix score double `y0' = `beta0'  
		quietly replace `y0'      = exp(`y0')
		
		if "`estad'"=="atet" {
			quietly summarize `y0' `wgt2' if (`touse' & `yt3'==1)
			scalar `pom0' = r(mean)
			quietly summarize `y1' `wgt2' if (`touse' & `yt3'==1)
			scalar `pom1' = r(mean)
			quietly generate double `pate'  = `y1'-`y0'
			quietly summarize `pate' `wgt2' if `touse'
			scalar `ate' = r(mean)
			local N      = r(N)
			quietly generate double `patet' = ///
					(`y1'-`y0')*(`N'/`tn')*`yt3'
			quietly summarize `patet' `wgt2' if `touse'
			scalar `atet' = r(mean)	
			ereturn scalar ate   = `ate'
			ereturn scalar atet  = `atet'
			ereturn scalar pom1  = `pom1'
			ereturn scalar pom0  = `pom0'
			ereturn matrix beta0 = `beta0'
			ereturn scalar N     = `N'
			ereturn matrix beta1 = `beta1'		
		}
		else {
			quietly summarize `y0' `wgt2' if `touse'
			scalar `pom0' = r(mean)
			quietly summarize `y1' `wgt2' if `touse'
			scalar `pom1' = r(mean)
			quietly generate double `pate'  = `y1'-`y0'
			quietly summarize `pate' `wgt2' if `touse'
			scalar `ate' = r(mean)
			local N      = r(N)
			quietly generate double `patet' = ///
					(`y1'-`y0')*(`N'/`tn')*`yt3'
			quietly summarize `patet' `wgt2' if `touse'
			scalar `atet' = r(mean)	
			ereturn scalar ate   = `ate'
			ereturn scalar atet  = `atet'
			ereturn scalar pom1  = `pom1'
			ereturn scalar pom0  = `pom0'
			ereturn matrix beta0 = `beta0'
			ereturn scalar N     = `N'
			ereturn matrix beta1 = `beta1'
		}
	}
	if "`omodel'"=="probit" {
		capture _rmcoll `yo', probit
		if _rc==2000 {
			di as err ///
				"invalid dependent variable for outcome model" 	
			di as txt "{p 4 4 2}"				
			di as smcl as err ///
				"either outcome does not vary or" ///
				" you have a fractional response and" ///
				" should use {bf:fractional} outcome model"
			di as smcl as err  "{p_end}"
			exit 2000	
		}

		quietly capture probit `yo' `ovars' `uhat' ///
			if (`yt3'==1 & `touse') `wgt', `oconst'

		local rc = _rc
		local converge = e(converged) 
		if (`rc'!=0) {
			di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				  " initial estimates failed{p_end}"
			exit `rc' 
		}
		if `converge'== 0 {
			di as err "{p}{it:omodel} {cmd:`omodel'}" ///
			"estimates did not converge {p_end}"
			exit 430	
		}
		if "`estad'"=="atet" {
			quietly predict double `y1'
			matrix `beta1'     = e(b)

			quietly summarize `y1' `wgt2' if (`touse' & `yt3'==1)
			scalar `pom1' = r(mean)
			
			quietly capture probit `yo' `ovars' `uhat'  ///
				if (`yt3'==0 & `touse') `wgt', `oconst'
			local rc = _rc
			local converge = e(converged) 
			if (`rc'!= 0) {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
					" initial estimates failed{p_end}"
				exit `rc' 
			}
			if `converge'== 0 {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				"estimates did not converge {p_end}"
				exit 430	
			}
			
			matrix `beta0' = e(b)

			quietly predict double `y0'
			quietly summarize `y0' `wgt2' if (`touse' & `yt3'==1)
			scalar `pom0' = r(mean)
			quietly generate double `pate'  = `y1'-`y0' 
			quietly summarize `pate' `wgt2' if `touse' 
			scalar `ate' = r(mean)
			local N      = r(N)
			quietly generate double `patet' = ///
						(`y1'-`y0')*(`N'/`tn')*`yt3'
			quietly summarize `patet' `wgt2' if `touse'
			scalar `atet' = r(mean)	
			ereturn scalar ate   = `ate'
			ereturn scalar atet  = `atet'
			ereturn scalar pom1  = `pom1'
			ereturn scalar pom0  = `pom0'
			ereturn matrix beta0 = `beta0'
			ereturn scalar N     = `N'
			ereturn matrix beta1 = `beta1'
		}
		else {
			quietly predict double `y1'
			matrix `beta1'     = e(b)

			quietly summarize `y1' `wgt2' if `touse'
			scalar `pom1' = r(mean)
			
			quietly capture probit `yo' `ovars' `uhat'  ///
				if (`yt3'==0 & `touse') `wgt', `oconst'
			local rc = _rc
			local converge = e(converged) 
			if (`rc'!= 0) {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
					" initial estimates failed{p_end}"
				exit `rc' 
			}
			if `converge'== 0 {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				"estimates did not converge {p_end}"
				exit 430	
			}
			
			matrix `beta0' = e(b)
			quietly predict double `y0'
			quietly summarize `y0' `wgt2' if `touse'
			scalar `pom0' = r(mean)
			quietly generate double `pate'  = `y1'-`y0'
			quietly summarize `pate' `wgt2' if `touse'
			scalar `ate' = r(mean)
			local N      = r(N)
			quietly generate double `patet' = ///
						(`y1'-`y0')*(`N'/`tn')*`yt3'
			quietly summarize `patet' `wgt2' if `touse'
			scalar `atet' = r(mean)	
			ereturn scalar ate   = `ate'
			ereturn scalar atet  = `atet'
			ereturn scalar pom1  = `pom1'
			ereturn scalar pom0  = `pom0'
			ereturn matrix beta0 = `beta0'
			ereturn scalar N     = `N'
			ereturn matrix beta1 = `beta1'
		}
	}	
	if "`omodel'"=="fractional"{
		if "`estad'"=="atet" {
			quietly capture glm `yo' `ovars' `uhat' ///
				if (`yt3'==1 & `touse') `wgt', `oconst' ///
				family(binomial) link(probit)

			local rc = _rc
			local converge = e(converged) 
			if (`rc'!=0) {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
					  " initial estimates failed{p_end}"
				exit `rc' 
			}
			if `converge'== 0 {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				"estimates did not converge {p_end}"
				exit 430	
			}

			quietly predict double `y1'
			matrix `beta1'     = e(b)

			quietly summarize `y1' `wgt2' if (`touse' & `yt3'==1)
			scalar `pom1' = r(mean)
			
			quietly capture glm `yo' `ovars' `uhat'  ///
				if (`yt3'==0 & `touse') `wgt', `oconst' ///
				family(binomial) link(probit)
				
			local rc = _rc
			local converge = e(converged) 
			if (`rc'!= 0) {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
					" initial estimates failed{p_end}"
				exit `rc' 
			}
			if `converge'== 0 {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				"estimates did not converge {p_end}"
				exit 430	
			}

			matrix `beta0' = e(b)

			quietly predict double `y0'
			quietly summarize `y0' `wgt2' if (`touse' & `yt3'==1)
			scalar `pom0' = r(mean)
			quietly generate double `pate'  = `y1'-`y0'
			quietly summarize `pate' `wgt2' if `touse'
			scalar `ate' = r(mean)
			local N      = r(N)
			quietly generate double `patet' = ///
						(`y1'-`y0')*(`N'/`tn')*`yt3'
			quietly summarize `patet' `wgt2' if `touse'
			scalar `atet' = r(mean)	
			ereturn scalar ate   = `ate'
			ereturn scalar atet  = `atet'
			ereturn scalar pom1  = `pom1'
			ereturn scalar pom0  = `pom0'
			ereturn matrix beta0 = `beta0'
			ereturn scalar N     = `N'
			ereturn matrix beta1 = `beta1'
		}
		else {
			quietly capture glm `yo' `ovars' `uhat' ///
				if (`yt3'==1 & `touse') `wgt', `oconst' ///
				family(binomial) link(probit)

			local rc = _rc
			local converge = e(converged) 
			if (`rc'!=0) {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
					  " initial estimates failed{p_end}"
				exit `rc' 
			}
			if `converge'== 0 {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				"estimates did not converge {p_end}"
				exit 430	
			}

			quietly predict double `y1'
			matrix `beta1'     = e(b)

			quietly summarize `y1' `wgt2' if `touse'
			scalar `pom1' = r(mean)
			
			quietly capture glm `yo' `ovars' `uhat'  ///
				if (`yt3'==0 & `touse') `wgt', `oconst' ///
				family(binomial) link(probit)
				
			local rc = _rc
			local converge = e(converged) 
			if (`rc'!= 0) {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
					" initial estimates failed{p_end}"
				exit `rc' 
			}
			if `converge'== 0 {
				di as err "{p}{it:omodel} {cmd:`omodel'}" ///
				"estimates did not converge {p_end}"
				exit 430	
			}

			matrix `beta0' = e(b)

			quietly predict double `y0'
			quietly summarize `y0' `wgt2' if `touse'
			scalar `pom0' = r(mean)
			quietly generate double `pate'  = `y1'-`y0'
			quietly summarize `pate' `wgt2' if `touse'
			scalar `ate' = r(mean)
			local N      = r(N)
			quietly generate double `patet' = ///
						(`y1'-`y0')*(`N'/`tn')*`yt3'
			quietly summarize `patet' `wgt2' if `touse'
			scalar `atet' = r(mean)	
			ereturn scalar ate   = `ate'
			ereturn scalar atet  = `atet'
			ereturn scalar pom1  = `pom1'
			ereturn scalar pom0  = `pom0'
			ereturn matrix beta0 = `beta0'
			ereturn scalar N     = `N'
			ereturn matrix beta1 = `beta1'
		}
	}
	
	ereturn scalar nt    = `tn'
	ereturn matrix betat = `betat'
end

program define ChecK__TeIVomodEL, sclass
	syntax, 			///
	[				///
	noCONstant			///
	linear				///
	probit				///
	EXPonential			///
	FRACtional			///
	*				///
	]
	
	local opciones: list sizeof options
	local erra = word("`options'", 1)

	if (`opciones'>0) {
		display as err "for outcome model, option {bf:`erra'} invalid"
		exit 198
	}
	
	local modelo "`linear'`probit'`exponential'`fractional'" 
	local suma = ("`exponential'"!="") + ("`linear'"!="")+ ///
		     ("`probit'"!="") + ("`fractional'"!="")
	if `suma'>1 {
		di as err "only one outcome model may be specified"
		exit 198
	}
	if `suma'== 0 {
		sreturn local omodel = "linear"
	}
	else {
		sreturn local omodel = "`modelo'"
	}

	if ("`constant'"==""|"`constant'"=="constant") {
		sreturn local ocons = "_cons"
	}
	else {
		sreturn local ocons = ""
	}
	
	sreturn local oconst = "`constant'"
	
end

program define ChecK__TeIVtmodEL, sclass
	syntax, 			///
	[				///
	noCONstant			///
	probit				///
	*				///
	]
	
	local opciones: list sizeof options
	local erra = word("`options'", 1)

	if (`opciones'>0) {
		display as err "for treatment model, option {bf:`erra'} invalid"
		exit 198
	}

	local modelo "probit" 

	local suma = ("`probit'"!="") 

	if `suma'== 0 {
		sreturn local tmodel = "probit"
	}
	else {
		sreturn local tmodel = "`modelo'"
	}
	
	if ("`constant'"==""|"`constant'"=="constant") {
		sreturn local tcons = "_cons"
	}
	else {
		sreturn local tcons = ""
	}
	
	sreturn local tconst = "`constant'"
end

program define Stri_PE_S, sclass
	syntax,  		///
	stat(string) 		///
	tvars(string)		///
	ovars(string)		///
	tr(string)
	
	
	local tn: list sizeof tvars
	local on: list sizeof ovars
	local teq  = ""
	local oeq0 = ""
	local oeq1 = ""
	
	forvalues i = 1/`tn' {
		local eqs: word `i' of `tvars'
		local teq = "`teq' TME1:`eqs'"
	}
	forvalues i = 1/`on' {
		local eqs: word `i' of `ovars'
		local oeq0 = "`oeq0' OME0:`eqs'"
	}
	forvalues i = 1/`on' {
		local eqs: word `i' of `ovars'
		local oeq1 = "`oeq1' OME1:`eqs'"
	}
	
	local uh0 = "TEOM0:_cons"
	local uh1 = "TEOM1:_cons"
	
	if "`stat'"=="ate" {
		local first = "ATE:r1vs0.`tr' POmean:0.`tr'"
		local names = "`first' `teq' `oeq0' `oeq1' `uh0' `uh1'"
	}
	if "`stat'"=="atet" {
		local first = "ATET:r1vs0.`tr' POmean:0.`tr'"
		local names = "`first' `teq' `oeq0' `oeq1' `uh0' `uh1'"
	}
	if "`stat'"=="pomeans" {
		local first = "POmeans:0bn.`tr' POmeans:1.`tr'"
		local names = "`first' `teq' `oeq0' `oeq1' `uh0' `uh1'"
	}
	sreturn local stripe = "`names'"
end

program define Variance, rclass
        syntax , Robust

        return scalar var = 2
end

program define Clusters, eclass
        syntax varname, CLuster

        gettoken 0:0, parse(",")
        ereturn local clustervar "`0'"
        ereturn scalar var = 3
end

program define CoNsYt, sclass
        syntax  anything, 		///
		[			///
		model(integer 1) 	///	
		probit			///
		EXPonential		///
		linear			///
		noCONstant		///
		FRACtional		///
		*			///
		]
	
		local opciones: list sizeof options
		local erra = word("`options'", 1)
	
	if `model'== 1 {
		if (`opciones'>0) {
			display as err "for outcome model, option" ///
				" {bf:`erra'} invalid"
			exit 198
		}
		local modelo "`linear'`probit'`exponential'`fractional'" 
		local suma = ("`exponential'"!="") + ("`linear'"!="")+ ///
			     ("`probit'"!="") + ("`fractional'"!="")
			    
		if `suma'>1 {
			di as err "only one outcome model may be specified"
			exit 198
		}
		
		sreturn local omodel = "`modelo'"
	}
	else {
		if (`opciones'>0) {
			display as err "for treatment model, option" ///
					" {bf:`erra'} invalid"
			exit 198
		}
		local modelo "probit" 
		local suma = ("`probit'"!="") 
		if `suma'>1 {
			di as err "only one treatment model may be specified"
			exit 198
		}
		sreturn local tmodel = "`modelo'"
	}

	if `model'== 1 {
		if ("`constant'"=="noconstant"){
			di as err "too few variables specified;" 	
			di as txt "{p 4 4 4}"				
			di as smcl as err "Outcome model specification" 
			di as smcl as err  "must have a constant"	
			di as smcl as err  "{p_end}"
			exit 102
		}
	}
	else {
		if ("`constant'"=="noconstant"){
			di as err "too few variables specified;" 	  
			di as txt "{p 4 4 4}"				  
			di as smcl as err "Treatment model specification" 
			di as smcl as err  "must have a constant."	  
			di as smcl as err  "{p_end}"
			exit 102
		}
	}

end

program define __uNo__LoCo, sclass
        syntax  [if][in]				///
		[fweight iweight pweight], 		///
		[					///
		lista(string)				///
		outcome					///
		noCONstant				///
		]
	
	marksample touse
	
	if "`weight'" != "" {
		local wgt [`weight' `exp']
	}
	
	if "`outcome'" == "" {
		local model treatment
	}
	else {
		local model outcome
	}
	
	if "`lista'"!="" {
		qui fvexpand `lista' if `touse'
		local fvom = r(fvops)
		local ovars = r(varlist)
		local nl: list sizeof ovars
		local suma = 0 
		
		forvalues i=1/`nl'{	
			local eqs: word `i' of `ovars'
			_ms_parse_parts `eqs'
			local adds = r(omit)
			local suma = `suma' + `adds'
		 }
		 
		qui _rmcoll `ovars' `wgt' if `touse', `constant'
		local suma2 = r(k_omitted)

		if  (`suma2'>`suma') {
			display as text _newline "for the `model' model;"
			_rmcoll `ovars' `wgt' if `touse', `oconst' expand
			local vars = r(varlist)
		}
		else {
			fvexpand `lista' if `touse'
			local vars = r(varlist)
		}
	}
	else {
		local vars = "`lista'"
	}
	
	sreturn local vars = "`vars'" 


end 
