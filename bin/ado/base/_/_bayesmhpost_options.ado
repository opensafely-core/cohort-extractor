*! version 1.0.3  28may2019
program _bayesmhpost_options, sclass
	version 14.0
	args opts

	local 0 , `opts'
	syntax [, 			///
		SKIP(string)		///
		CORRLAG(string)		///
		CORRTOL(string)		///
		noLEGend 		///
		MCMCSIZE(string)	///
		*]
	
	local nolegend `legend'
	
	// check display options
	_get_diopts diopts, `options'
	local 0 ,`diopts'
	syntax [, BASElevels ALLBASElevels *]
	local nobaselevels
	if "`baselevels'" == "" & "`allbaselevels'" == "" {
		local nobaselevels nobaselevels
	}
	
	// check skip()
	if (`"`skip'"'!="") {
		local max = floor(e(mcmcsize)/2)-1
		if (`max'<=0) {
			di as err "MCMC sample size must be larger " ///
				  "to use {bf:skip()}"
			exit 198
		}
		cap confirm integer number `skip'
		local rc = _rc
		if (!`rc') {
			if (`skip'<0 | `skip'>`max') {
				local rc 198
			}
		}
		if `rc' {
			di as err "{p}option {bf:skip()} must contain integer "
			di as err "between 0 and `max'{p_end}"
			exit `rc'
		}
		_bayesmh_note_skip `skip' `e(mcmcsize)'
	}
	else {
		local skip 0
	}

	scalar smcmcsize = e(mcmcsize)
	scalar nchains   = e(nchains)
	if nchains != . {
		scalar smcmcsize = floor(smcmcsize/nchains)
	}
	if `"`mcmcsize'"' != "" {
		scalar smcmcsize = `mcmcsize'
	}
	if (`"`corrlag'"'=="") {
		local corrlag  = min(500,floor(smcmcsize/2))
	}
	if (`"`corrtol'"'=="") {
		local corrtol 0.01
	}

	// check corrlag() and corrtol()
	_bayesmh_chk_corropts `"`corrlag'"' `"`corrtol'"'

	// store results
	sreturn local skip	   "`skip'"
	sreturn local corrlag      "`corrlag'"
	sreturn local corrtol 	   "`corrtol'"
	sreturn local nolegend     "`nolegend'"
	sreturn local nobaselevels "`nobaselevels'"
	sreturn local diopts	   `"`diopts'"'
end
