*! version 1.0.6  02dec2013
program define vecirf_create
	version 8.2

	syntax name(id=irfname name=irfname)		///
		[,					///
		STep(numlist integer >0 max=1)		///
		replace 				///
		set(string)				///
		noDFK					/// undocumented
		]


	preserve
	_ckirfset , set(`set')	

	if "`step'" == "" local step 1

	local stepm1 = `step' - 1

	_virf_nlen `irfname'  /* note this returns length of name in r(len)
			    *  but only checking is needed so do not
			    * store length
			    */
	qui varirf des

	if "`replace'" != "" {
		capture irf drop `irfname'
		if _rc > 0 { 
			di as txt `"irfname `irfname' not found in $S_vrffile"'
		}
	}	
	
	local cnames `r(irfnames)'
	local tmp : subinstr local cnames "`irfname'" "`irfname'", 	/*
	 	*/ word count(local found)
	if `found' > 0 {
		di as err `"irfname `irfname' is already in $S_vrffile"'
		exit 498
	}	

	_ckvec vecirf_create

	local k = e(k_eq)
	local trend "`e(trend)'"
	local lags = e(n_lags)
	local tmin = e(tmin)
	local tmax = e(tmax)
	local tsfmt "`e(tsfmt)'"
	local tvar "`e(tvar)'"
	local veccns "`e(aconstraints)'"
	if "`veccns'" != "" {
		local veccns "`veccns':`e(bconstraints)'"
	}
	else{
		local veccns "`e(bconstraints)'"
	}
	local rank = e(k_ce)
	local sind "`e(sindicators)'"

	forvalues i = 0/`step' {
		tempname phi`i' theta`i' fevd`i' mse`i'
		local phi_names `phi_names'  `phi`i''
		local theta_names `theta_names' `theta`i''  
		local fevd_names `fevd_names' `fevd`i''
		local mse_names `mse_names' `mse`i''
	}

	tempname omega dfks p0

	if "`dfk'" == "" {
		scalar `dfks' = e(N)/(e(N)-e(df_m))
	}
	else {
		scalar `dfks' = 1
	}	

	mat `omega' = `dfks'*e(omega)
	mat `p0' = cholesky(`omega')

	vec_mkphi `phi_names' 
	vec_mkphi `theta_names' , p0mat(`p0') 
	vec_fevd  `fevd_names', pmats(`theta_names')
	vec_fevd  `mse_names', pmats(`theta_names') mse

	tsunab names : `e(endog)'
	local names : subinstr local names "." "_", all

	tempfile irfwork
	tempname tmp_results

	local mylabs step responseid impulseid
	local mylabs "`mylabs' irf cirf oirf coirf sirf stdirf stdcirf stdoirf"
	local mylabs "`mylabs' stdcoirf stdsirf fevd sfevd mse"
	local mylabs "`mylabs' stdfevd stdsfevd" 

	qui postfile `tmp_results' `mylabs' using  "`irfwork'", double replace

	forvalues s=0/`step' {
		forvalues j = 1/`k' {
			forvalues i = 1/`k' {
post `tmp_results' (`s') (`i') (`j')					///
	(`phi`s''[`i',`j']) (`phi`s''[`i',`j']) 			///	
	(`theta`s''[`i',`j']) (`theta`s''[`i',`j']) (.) (.) (.) (.)	///
	(.) (.) (`fevd`s''[`i',`j']) (.) (`mse`s''[`i',`i']) (.) (.) 
			}
		}
	}
	postclose `tmp_results'

	qui use "`irfwork'", clear
	sort impulseid responseid step
	qui by impulseid responseid: replace cirf = sum(cirf)
	qui by impulseid responseid: replace coirf = sum(coirf)
	qui gen str15 irfname = "`irfname'"
	qui gen str13 response = ""
	qui gen str13 impulse = ""

	forvalues i = 1/`k' {
		local nme : word `i' of `names'
		qui replace response = "`nme'" if responseid == `i'
		qui replace impulse  = "`nme'" if impulseid  == `i'
	}
	
	qui label var cirf "cumulative irf"
	qui label var irf  "impulse-response function (irf)"
	qui label var oirf "orthogonalized irf"
	qui label var coirf "cumulative orthogonalized irf"
	qui label var sirf  `"structural irf"'
	qui label var mse  "SE of forecast of response var"
	qui label var fevd "fraction of mse due to impulse"
	qui label var sfevd "(structural) fraction of mse due to impulse"
	qui label var step  "step"
	qui label var irfname "name of results"
	qui label var impulse "impulse variable"
	qui label var response "response variable"
	qui replace stdirf=sqrt(stdirf)
	qui replace stdcirf=sqrt(stdcirf)
	qui replace stdoirf=sqrt(stdoirf)
	qui replace stdcoirf=sqrt(stdcoirf)
	qui replace stdsirf=sqrt(stdsirf)
	qui label var stdirf "std error of irf"
	qui label var stdoirf "std error of oirf"
	qui label var stdcirf "std error of cirf"
	qui label var stdcoirf "std error of coirf"
	qui label var stdsirf "std error of sirf"
	qui replace mse=sqrt(mse)
	qui replace stdfevd=sqrt(stdfevd)
	qui label var stdfevd "std error of fevd"
	qui replace stdsfevd=sqrt(stdsfevd)
	qui label var stdsfevd "std error of sfevd"
	
	_virf_char , put(irfname(`irfname') vers(1.1) /*
		*/ order(`names') step(`step') 		/*
		*/ model(vec) exog(none)		/*
		*/ constant(`trend') 			/*
		*/ varcns(unconstrained)		/*
		*/ stderr(none)				/*
		*/ reps(.)				/*
		*/ tmin(`tmin')				/*
		*/ tmax(`tmax')				/*
		*/ tsfmt(`tsfmt')			/*
		*/ timevar(`tvar')			/*
		*/ lags(`lags')				/*
		*/ svarcns(".")				/*
		*/ rank(`rank')				/*
		*/ trend(`trend')			/*
		*/ veccns(`veccns')			/*
		*/ sind(`sind')				/*
		*/)

	drop impulseid responseid
	sort impulse response
	qui save "`irfwork'", replace

	varirf_add `irfname' , using("`irfwork'") exact	
	restore	


end
