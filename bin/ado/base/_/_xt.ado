*! version 1.1.0  12feb2015
program _xt, rclass

	version 10

	syntax [, i(string) t(string) TREQuired ]
	
	if "`i'`t'`trequired'" == "" {
		GetPanelVar panvar
		if "`panvar'" == "" {
			di as error "must specify panelvar; use {bf:xtset}"
			exit 459
		}
		return local ivar `panvar'
		GetTimeVar timevar
		if "`timevar'" != "" {
			return local tvar `timevar'
		}
		exit
	}

	tempname delta

	if "`i'`t'" == "" {		// t required
		GetPanelVar panvar
		GetTimeVar  timevar
		if "`panvar'" == "" {
			di as error 	///
			"must specify panelvar and timevar; use {bf:xtset}"
			exit 459
		}
		else if "`timevar'" == "" {
			di as error "must specify timevar; use {bf:xtset}"
			exit 459
		}
		capture {	// In case pre-10 dataset w/out delta saved
			sca `delta' = `:char _dta[_TSdelta]'
			confirm scalar `delta'
		}
		if _rc {
			char _dta[_TSdelta] 1
			sca `delta' = 1
		}
		tempvar tdiff
		qui by `panvar' (`timevar'), sort: 	///
		    gen double `tdiff' = `timevar'-`timevar'[_n-1] 
		qui sum `tdiff', mean
		if r(min) == 0 {
			di as error "repeated time values within panel"
			exit 451
		}
		if r(min) < `delta' {
			di as error	///
				"time values with period less than delta found"
			exit 451
		}
		return local  ivar `panvar'
		return local  tvar `timevar'
		return scalar tdelta = `delta'
		exit
	}
	
	// At this point, caller specified i() and/or t()
	GetPanelVar panvar
	GetTimeVar  timevar
	if "`i'" != "" {
		confirm variable `i'
		unab i : `i'
		if "`panvar'" != "" & "`panvar'" != "`i'" {
			di as text 	///
"warning: existing panel variable is not `i'"
		}
	}
	else if "`i'" == "" & "`panvar'" == "" {
		di as err "must specify panelvar; use {bf:xtset}"
		exit 459
	}
	else {
		local i `panvar'
	}

	scalar `delta' = 1	// assume 1 by default
	if "`t'" != "" {
		confirm numeric variable `t'
		unab t : `t'
		if "`timevar'" != "" & "`timevar'" != "`t'" {
			di as text 		///
				"warning: existing time variable is not `t'" _c
			// If t not required, t could just arbitrarily mark
			// observations within i, in which case delta is
			// irrelevant
			if "`trequired'" != "" {
				di as text "; assuming delta = 1"
			}
			else {
				di
			}
		}
	}
	else {
		local t `timevar'
		if "`:char _dta[_TSdelta]'" != "" {
			sca `delta' = `:char _dta[_TSdelta]'
		}
	}
	if "`t'" == "" & "`trequired'" != "" {
		di as error "must specify timevar; use {bf:xtset}"
		exit 459
	}
	// NB: -xtset- to be called even if `i'=`panvar'
	// and `t'=`timevar' -- it will check delta for us
	if "`t'" != "" {
		capture xtset `i' `t', delta((`delta'))
		if _rc {
			if "`trequired'" != "" {
				// redo for full error msg
				xtset `i' `t', delta((`delta'))
			}
			else {
				// try without t -- after all, t not required
				qui xtset `i'
			}
		}
	}
	else {
		qui xtset `i'
	}
	return local ivar `i'
	if "`t'" != "" {
		return local tvar `t'
	}
	if "`:char _dta[_TSdelta]'" != "" {
		return scalar tdelta = `:char _dta[_TSdelta]'
	}

end

program GetPanelVar

	args target
	local p : char _dta[_TSpanel]
	if "`p'" == "" {
		local p2 : char _dta[iis]
		if "`p2'" != "" {
			char _dta[_TSpanel] `p2'
		}
		local p `p2'
	}
	
	c_local `target' `p'

end

program GetTimeVar

	args target
	local p : char _dta[_TStvar]
	if "`p'" == "" {
		local p2 : char _dta[tis]
		if "`p2'" != "" {
			char _dta[_TStvar] `p2'
		}
		local p `p2'
	}
	
	c_local `target' `p'

end

