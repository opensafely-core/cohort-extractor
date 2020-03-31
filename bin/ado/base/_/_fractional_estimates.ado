*! version 1.2.0  11feb2019

program define _fractional_estimates, eclass

	syntax varlist(numeric fv ts) [if] [in]				///
			[fweight pweight iweight],			///
			[						///
			het(string)					///
			noCONstant					///
			CONSTraints(string)				///
			vce(string)					///
			Level(cilevel)					///
			NOLOg LOg					///
			TRace						///
			GRADient					///
			showstep					///
			HESSian						///
			SHOWTOLerance					///
			TOLerance(real 1e-6)				///
			LTOLerance(real 1e-7)				///
			llzeropollito(real 0)				///
			NRTOLerance(real 1e-5)				///
			TECHnique(string)				///
			ITERate(integer 16000)				///
			NONRTOLerance					///
			from(string)					///
			DIFficult					///
			OFFset(varname numeric)				///
			collinear					///
			estimator(string)				///
			moptobj(string)					///
                        *          					///
			]

	marksample touse
	gettoken yvar varlist: varlist 
	
	if "`weight'" != "" {
		local wgt [`weight' `exp']
	}

	local wtype "`weight'"
        local wexp  "`exp'"
	gettoken peso pesos: exp            // weights for moptimize
	
	if "`het'" != "" {
		OfFsEt__hEt `het'
		local het     = "`s(vars)'"
		local  hoff   = "`s(hoff)'"
		__Vars_FRAC if `touse' `wgt', lista(`het') `constant' ///
					      `collinear'				
		local hvarlist = "`s(vars)'" 
	}

	__Vars_FRAC if `touse' `wgt', lista(`varlist') `constant' `collinear'				
	local varlist   = "`s(vars)'" 
	
	if "`constant'" == "" {
		local noconsm = 0
	}
	else {
		local noconsm = 1
	}

	///////////////////// Optimization options /////////////////////
	
	// 2. Iterate
		
	if  `iterate' < 0 {
		display as error "{bf:iterate()} must be a nonnegative integer"
		exit 125
	}

	// 3. Tolerance, ltolerance, nrtolerance
		
	if `nrtolerance' < 0 {
		display as error "{bf:nrtolerance()} should be nonnegative"
		exit 125
	}
	  
	if `tolerance' < 0 {
		display as error "{bf:tolerance()} should be nonnegative"
		exit 125
	} 

	if `ltolerance' < 0 {
		display as error "{bf:ltolerance()} should be nonnegative"
		exit 125
	} 

	//  4. Tracelevel options
		

	if "`showstep'" != "" {
		local step = 1
	}
	else {
		local step = 0
	}

	if "`gradient'" != "" {
		local grad = 1
	}
	else {
		local grad = 0
	}

	if "`hessian'" != "" {
		local hess = 1
	}
	else {
		local hess = 0
	}

	if "`trace'" != "" {
		local trace = 1
	}
	else {
		local trace = 0
	}

	if "`showtolerance'" != "" {
		local showtol = "on"
	}
	else {
		local showtol = "off"
	}
	if "`nonrtolerance'" != "" {
		local  nonrtol = "on"
	}
	else {
		local  nonrtol = "off"
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" {
		local  nolog = 1
	}
	else {
		local  nolog = 0
	}

	//  5. Technique
		
	if "`technique'" == "" {
		local technique = "nr"
	}

	local techs nr dfp bfgs bhhh
	local check: list techs & technique

	if "`check'" == "" {		
		local tecnicas = "nr, dfp, bfgs, or, bhhh"
		display as error "{bf:technique()} `technique'"		///
		    " not found; only one of `tecnicas' is allowed"
		exit 111
	}

	//  6. Difficult

	if "`difficult'" != "" {
		local difficult = "hybrid"
	}
	else {
		local difficult = "m-marquardt"
	}

	//////////////////////// Parsing vce options ///////////////////////

	local nvce: list sizeof vce
	
	if ("`vce'"=="oim") {
		display as error "vcetype {bf:oim} not allowed; default" ///
			" vcetype for {bf:fracreg} is {bf:robust}"
		exit 198	
	}
	
	if ("`vce'"=="oim"|"`vce'"=="") {
		local nvce = 1
		local vce robust
	}

	if (`nvce' == 1|`nvce'==0) {
		cap qui Variance , `vce'
		
		if _rc!=0 { 		
			display as error "invalid {bf:vce()} option"
			exit _rc
		}
		
		local var  = r(var)
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
		local clust2 =  e(clustervar)
		capture local sclust = string(`clust')
		if _rc!=0 {
			tempvar clust 
			encode `clustervar', generate(`clust')
		}
		quietly egen `cuentasclust' = group(`clustervar')
		quietly sum `cuentasclust' if `touse'
		local cuentasclusts = r(max)
		local var = e(var)
		local tvce cluster
		local type Robust
	}

	/*if  ("`weight'" == "pweight") {
		local var   = 2
		local clust = ""
		local tvce robust
		local type Robust
	}*/
	
	//////////////////////// Constraints and from ///////////////////////
	
	
	if `"`from'"' != "" {
		tempname theta
		_mkvec `theta', from(`from') error("from()")
	}

	tempname theta b V vm1 converge loglike llog gradient rcfrac nic ///
		 rknum
	
	local zeta = 0 
	
	if "`het'"=="" {
		qui regress `yvar' `varlist' if `touse' `wgt', `constant'
		matrix `theta'	= e(b)
		matrix `b'	= e(b)
		matrix `V'	= e(V)
		matrix `vm1'	= e(V)
		local numk      = colsof(`b')
	}
	else {
		qui reg `yvar' `hvarlist' if `touse' `wgt', noconstant
		qui glm `yvar' `varlist' if `touse' `wgt', `constant' ///
			family(binomial) link(probit)
		local zeta : list sizeof hvarlist
		matrix `theta'	= e(b)
		matrix `b'	= e(b), J(1,`zeta',0)
		local numk      = colsof(`b')
		matrix `V'	= J(`numk', `numk', 0)
		matrix `vm1'	= J(`numk', `numk', 0)
			
	}

	/// Stripes for constraints 
	
	if ("`wtype'"!="pweight") {
		qui summarize `touse' if `touse'==1 `wgt'
		local N = r(N)
	}
	else {
		qui mean `touse' if `touse'==1 `wgt'
		local N = e(N)	
	}
	
	local wi   : list sizeof varlist
	local eqlatent    = ""
	local eqlatentchi = ""
	local eqhet       = ""
	tempname mns0 mns
	matrix `mns0' = J(1,1,1)

	if `wi'>0 {
		forvalues i=1/`wi' {
			local eqw: word `i' of `varlist'
			local eqlatent    = "`eqlatent' `yvar':`eqw'" 
			local eqlatentchi = "`eqlatentchi' [`yvar']`eqw'" 
			qui sum `eqw' 
			matrix `mns0' = r(mean), `mns0'
		}
	}

	local stripe `eqlatent'

	if ("`constant'" == "") {
		local stripe `eqlatent' `yvar':_cons
	}
	
	if `zeta'>0 {
		forvalues i=1/`zeta' {
			local eqz: word `i' of `hvarlist'
			local eqhet = "`eqhet' lnsigma:`eqz'" 
		}
		local stripe = "`stripe' `eqhet'"	
	}

	_b_post0 `stripe'

	matrix colnames `b'  = `stripe' 
	matrix rownames `V'  = `stripe' 
	matrix colnames `V'  = `stripe' 
	
	if "`constraints'" == "" {	
		local C = 1
	}
	else {
		tempname Cns
		makecns `constraints'
		cap matrix `Cns' = get(Cns)
		local C st_matrix("`Cns'")
	}

	if _rc {
		local Cns = ""
		local C = 1	
	}
	
	local consmod = 0
	
	if "`varlist'"=="" {
		local consmod = 1
	}

	if "`het'"!="" {
		local estimator hetprobit 
	}
	
	display ""
	
	mata: _FrAcTiOnAl_GetEstimates(`iterate', `tolerance',	///
		`ltolerance', `nrtolerance', `step',`grad',	///
		`hess', `trace', "`nonrtol'", "`technique'",	///
		"`difficult'", "`showtol'", `nolog', "`theta'",	///
		"`yvar'", "`varlist'", `C', `var', "`clust'",	///
		"`touse'", `noconsm', "`pesos'", "`weight'",	///
		"`b'", "`V'", "`vm1'", "`converge'", 		///
		"`loglike'", "`llog'", "`gradient'", 		///
		"`rcfrac'", "`nic'", "`rknum'", "`offset'",	///
		"`estimator'", "`hvarlist'", "`hoff'",		///
		`consmod')

	/////////////////////// e(mns)

	if "`constant'"== "" {
		matrix `mns' = `mns0'
		matrix rownames `mns' = r1
		matrix colnames `mns' = `varlist' _cons
	}
	else {
		matrix `mns' = `mns0'[1,1..`wi']
		matrix rownames `mns' = r1
		matrix colnames `mns' = `varlist'		
	}
	
	// Stripes for V_modelbased 
	
	matrix rownames `vm1'  = `stripe' 
	matrix colnames `vm1'  = `stripe' 

	///////////////////// Returning results to probit 

	matrix colnames `b' = `stripe' 
	matrix rownames `V'  = `stripe' 
	matrix colnames `V'  = `stripe' 

	ereturn post, depname(`yvar')
	if "`Cns'" != "" {
		ereturn post `b' `V' `Cns', obs(`N') buildfvinfo ///
			esample(`touse') 
	}
	else {
		ereturn post `b' `V', esample(`touse') ///
			buildfvinfo
	}
	
	_post_vce_rank, checksize
	ereturn local vce "`tvce'"
	ereturn local clustvar "`clust2'"
	ereturn local vcetype "`type'"
	ereturn local depvar "`yvar'"
	ereturn local technique "`technique'"
	ereturn local which     "max"
	ereturn local opt       "moptimize"
        ereturn local ml_method "lf2"
	ereturn local wtype "`wtype'"
	ereturn local wexp  "`wexp'"
	ereturn hidden local crittype "log pseudolikelihood"
	ereturn hidden local frac  "fractional"
	ereturn hidden local zvars "`hvarlist'"
	ereturn hidden local xvars "`varlist'"
	ereturn hidden scalar cons = `noconsm'
	ereturn local offset "`offset'"
	ereturn local marginsnotok "stdp scores"
	ereturn scalar N           = `N'
	ereturn scalar ic          = `nic'-1
	ereturn scalar k           = `numk'
	if "`het'"=="" {
		ereturn scalar k_eq	   = 1
	}
	else {
		ereturn scalar k_eq	   = 2	
		ereturn hidden local offset2 "`hoff'"
	}
	ereturn scalar k_dv        = 1
	ereturn scalar converged   = `converge'
	ereturn scalar rc          = `rcfrac'
	ereturn scalar ll          = `loglike'
	ereturn scalar ll_0        = `llzeropollito'
	ereturn matrix ilog        = `llog'
	ereturn matrix gradient    = `gradient'
	ereturn matrix mns         = `mns'
	
	if "`cuentasclusts'" != "" {
		ereturn scalar N_clust  = `cuentasclusts'
	}

	if !missing(e(ll_0)) {
		ereturn scalar r2_p = 1 - e(ll)/e(ll_0)
	}
	
	if `nvce' > 0 {
		ereturn matrix V_modelbased = `vm1' 
	}
	
	if (`nvce' > 0 & "`varlist'"!="") {
		qui test `eqlatentchi'
		local df = r(df)
		ereturn scalar df_m        = `df'
		ereturn scalar k_eq_model = 1
		local chisq               = r(chi2)
		ereturn scalar chi2       =  `chisq'
		ereturn local chi2type    = "Wald"
	}

	ereturn scalar p         =  chi2tail(e(df_m), e(chi2))
end 

//////////////////////////////////////// 

program define __Vars_FRAC, sclass
        syntax  [if][in]				///
		[fweight pweight iweight], 		///
		[					///
		lista(string)				///
		noCONstant				///
		collinear				///
		]
	
	marksample touse
	
	if "`weight'" != "" {
		local wgt [`weight' `exp']
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
		 
		qui _rmcoll `ovars' `wgt', `constant' `collinear'
		local suma2 = r(k_omitted)

		if  (`suma2'>`suma') {
			qui _rmcoll `ovars' `wgt', `constant' expand `collinear'
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

program define OfFsEt__hEt, sclass
	syntax varlist(numeric fv ts), [offset(varname)]
	
	if "`offset'"=="" {
		sreturn local vars = "`varlist'"
		sreturn local hoff   = ""
	}
	else {
		sreturn local vars   = "`varlist'"
		sreturn local hoff   = "`offset'"
	}
end

