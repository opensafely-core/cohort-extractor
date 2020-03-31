*! version 1.3.0  29aug2014
program define varbasic, eclass
	local vv : display "version " string(_caller()) ":"
	version 8
	local cmdline : copy local 0
	syntax varlist(ts numeric) [if] [in] [,		///
		LAgs(numlist integer >0 sort)		///
		Step(numlist integer >0 max=1)		///
		Irf Fevd				///
		noGraph					///
		*					///
		]
		
	marksample touse

	_get_diopts diopts, `options'
		
	if "`lags'" == "" {
		local lags "1 2"
	}	

	if "`step'" == "" {
		local step 8
	}

	local nstats : word count `irf' `fevd'

	if `nstats' == 0 {
		local stat oirf
	}

	if `nstats' > 1 { 
		di as err "more than one statistic specified"
		exit 198
	}

	if "`irf'`fevd'" != "" & "`graph'" != "" {
		di as err "{cmd:nograph} cannot be specified with "	///
			"{cmd:`irf'`fevd'}"
		exit 198
	}	

	if `nstats' == 1 {
		local stat `irf' `fevd' 
	}

	`vv' var `varlist' if `touse' , lags(`lags') `diopts'
	ereturn local cmdline `"varbasic `cmdline'"'

	capture varirf create varbasic, step(`step') set(_varbasic, replace)
	if _rc > 0 {
		di as err "could not create varbasic.vrf"
		exit _rc
	}	

	if "`graph'" == "" {
		varirf graph `stat'
	}	

end

