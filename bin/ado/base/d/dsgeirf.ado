*! version 1.0.4  21feb2019
program define dsgeirf
	syntax  anything                       ///
		[,                             ///
		set(string)                    ///
	        response(string)               ///
		STep(integer 8)                ///
		ESTimates(string)              ///
		REPLACE]

	version 15


	if ("`estimates'" == "") {
		local estimates .
	}

	if ("`estimates'" != ".") {
		capture confirm name `estimates'
		if (_rc > 0) {
			di as err "estimates(`estimates') specifies an" _cont
			di as err " invalid name"
			exit 198
		}
	}

	local irfname "`anything'"
	tempname pest
	tempvar samp

	_estimates hold `pest', copy restore nullok varname(`samp') 
	capture estimates restore `estimates'
	if (_rc > 0) {
		di as err "could not restore estimates(`estimates')"
		exit _rc
	}
	
	if ("`e(cmd)'" != "dsge" & ///
		("`e(cmd)'"!="dsgenl" & "`e(solvetype)'"!="firstorder")) error 301

	if ("`set'" != "") {
		irf set `set'
	}

	if `step'<1 {
	    di "{err}step() must specify an integer greater than or equal to 1"
	    exit 198
	}

	_ckirfset, set(`set')
	_virf_nlen `irfname'

	if("$S_vrffile" == "") {
		disp as error "no irf file active"
		exit 111
	}
	
	tempfile irfwork

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
	drop _all
	
	local impulse: colnames e(shock_coeff)
	if ("`response'"=="") local response = e(state) + " " + e(control)

	foreach impu in `impulse' {
		drop _all
		tempfile `impu'file
		local nobs = `step'+1
		qui set obs `nobs'
		
		local allimp: colnames e(shock_coeff) 
		local estate = ""
		foreach imp in `allimp' {
			gen e`imp' = 0
			local estate = "`estate' e`imp'"
		}
		
		qui replace e`impu' = 1 in 1

		dsgesim `estate', stub(`anything'_)
		keep `anything'_*
		gen step = _n-1

		qui reshape long `anything'_ `anything'_sd, i(step) j(response) string
		sort response step
		gen impulse = "`impu'"
		gen irfname = "`anything'"
		rename `anything'_ irf
		rename `anything'_sd stdirf

		order irfname impulse response step irf
		qui save `"``impu'file'"', replace
	}
	clear
	foreach impu in `impulse' {
		append using `"``impu'file'"'
	}
	
	qui {
	char _dta[irfnames] "`anything'"      
	char _dta[`anything'_model] "`e(cmd)'"
	char _dta[`anything'_shocks] "`allimp'"
	local allvar  "`impulse' `response'"
	local theorder: list uniq allvar
	char _dta[`anything'_order] "`theorder'"
	char _dta[`anything'_tsfmt] `e(tsfmt)'
	char _dta[`anything'_tmin] `e(tmin)'
	char _dta[`anything'_tmax] `e(tmax)'
	char _dta[`anything'_stderror] "asymptotic"
	char  _dta[`anything'_step] `step'
	gen cirf     = .
	gen stdcirf  = . 
	gen oirf     = . 
	gen stdoirf  = . 
	gen coirf    = . 
	gen stdcoirf = .
	gen fevd     = . 
	gen stdfevd  = . 
	gen mse      = .  
	gen sirf     = . 
	gen stdsirf  = . 
	gen sfevd    = . 
	gen stdsfevd = .
	}

	qui save "`irfwork'", replace
	varirf_add `anything', using(`irfwork') exact

	restore
	_estimates unhold `pest'

end

exit


