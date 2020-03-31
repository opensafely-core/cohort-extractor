*! version 1.0.3  21feb2019
program define arfimairf_create
	version 13
	
	syntax	anything(name=irfname id="irf name")	///
		[,					///
		STep(integer 8)				///
		replace					///
		set(string)				///
	 	noSE 					///
		ESTimates(string)			///
		Level(cilevel)		 		///
		SMEMory					///
		]
	
	if "`estimates'" == "" local estimates .
	if "`estimates'" != "." {
		capture confirm name `estimates'
		if _rc > 0 {
		    di "{err}estimates(`estimates') specifies an invalid name"
		    exit 198
		}
	}
	
	tempname pest
	tempvar samp
	
	_estimates hold `pest', copy restore nullok varname(`samp') 
	
	capture estimates restore `estimates'
	if _rc > 0 {
		di "{err}could not restore estimates(`estimates')"
		exit _rc
	}
	
	local cmd `e(cmd)'
	if "`cmd'"=="arch" local cmd arima
	
	if "`cmd'"=="arima" & "`smemory'"=="smemory" {
		di "{err}option smemory not allowed after arima"
		exit 198
	}
	
	if "`cmd'" == "arima" {
		if "`e(seasons)'"=="" {
			di "{err}the model must contain AR and/or MA term(s)"
			exit 198
		}
	}
	
	_ckirfset , set(`set')
	
	if `step'<1 {
	    di "{err}step() must specify an integer greater than or equal to 1"
	    exit 198
	}
	
	if "`level'"=="" local level 95
	
	tempname b V
	_arma_getb
	mat `b' = r(b)
	mat `V' = r(V)
	local mult `r(mult)'
	
	local names : colfullnames `b'
	local hasd ARFIMA:d
	local hasd : list hasd in names
	local hasd = `hasd'
	if (`hasd') local diff = _b[ARFIMA:d]
	
	if "`smemory'"!="" {
		local hasd 0
		local cmd arima
	}
	
	local steps = `step'+1
	
	if "`se'"=="" local se 1
	else local se 0
	
	tempfile irfwork
	
	_virf_nlen `irfname'
	
	qui varirf des
	
	if "`replace'" != "" {
		capture varirf drop `irfname'
		if _rc > 0 { 
			di as txt `"irfname `irfname' not found in $S_vrffile"'
		}
	}
	
	local cnames `r(irfnames)'
	local tmp : subinstr local cnames "`irfname'" "`irfname'", ///
		word count(local found)
	if `found' > 0 {
		di as err `"irfname `irfname' is already in $S_vrffile"'
		exit 498
	}
		
	preserve
	
	clear
	qui set obs `steps'
		
	qui gen step = _n-1
	qui tsset step
	
	qui gen str15 irfname = "`irfname'"
	qui gen str13 response = "`e(depvar)'"
	qui gen str13 impulse = "`e(depvar)'"
			
	qui generate double irf = .
	qui generate double cirf = .
	qui generate double stdirf = .
	qui generate double stdcirf = .
	
	mata: `cmd'`mult'_irf("`b'","`V'",`steps',`se')
	
	qui label var irfname "name of results"
	qui label var impulse "impulse variable"
	qui label var response "response variable"
	
	qui label var step  "step"
	qui label var irf  "impulse-response function (irf)"
	qui label var cirf "cumulative irf"
	qui label var stdirf "std error of irf"
	qui label var stdcirf "std error of cirf"
		
	qui gen double oirf = irf
	qui gen double stdoirf = stdirf
	qui gen double coirf = cirf
	qui gen double stdcoirf = stdcirf
	qui gen double sirf = irf
	qui gen double stdsirf = stdirf
	
	qui label var oirf "orthogonalized irf"
	qui label var stdoirf "std error of oirf"
	qui label var coirf "cumulative orthogonalized irf"
	qui label var stdcoirf "std error of coirf"
	qui label var sirf "structural irf"
	qui label var stdsirf "std error of sirf"
	
	// not used in arima/arfima
	qui gen double fevd = .
	qui gen double stdfevd = .
	qui gen double mse = .
	qui gen double sfevd = .
	qui gen double stdsfevd = .
	qui label var fevd "fraction of mse due to impulse"
	qui label var stdfevd "std error of fevd"
	qui label var mse  "SE of forecast of response var"
	qui label var sfevd "(structural) fraction of mse due to impulse"
	qui label var stdsfevd "std error of sfevd"
	
	_virf_char , put(				///
		irfname(`irfname')			///
		vers(1.1) 				///
		order(`e(depvar)')			///
		step(`step') 				///
		model(`e(cmd)') 			///
		exog(`e(covariates)')			///
		constant("")	 			///
		varcns(unconstrained)			///
		stderr(none)				///
		reps(.)					///
		tmin(`e(tmin)')				///
		tmax(`e(tmax)')				///
		tsfmt(`e(tsfmt)')			///
		timevar(`e(timevar)')			///
		lags(`lags')				///
		svarcns(".")				///
		rank(`rank')				///
		trend(`trend')				///
		veccns(`veccns')			///
		sind(`sind')				///
		diff(`diff')				///
		)
	
	order step irfname response impulse
	
	qui save "`irfwork'", replace
	
	varirf_add `irfname', using(`irfwork') exact
	
	restore
	
	_estimates unhold `pest'
		
end

exit
