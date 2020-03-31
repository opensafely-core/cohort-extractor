*! version 1.1.5  18jun2012
program define tsappend, sortpreserve
	version 8.0
	syntax , [add(passthru) last(string) tsfmt(passthru) panel(string)]

/* last() holds time series date (in same format as recorded by tsset) to be
 * in data after tsappend
 *   NOTE: it is not possible to check that last is specified in same format
 *   as held in tsset without requiring that the user give the format
 *
 * panel() holds unique panel id number for tsappend 
 */

	tempname pest
	tempvar samp

	_estimates hold `pest', copy restore nullok varname(`samp')

	if "`add'" != "" & "`tsfmt'" != "" {
		di as err "specify add() or tsfmt(), not both"
		exit 198
	}

	if "`add'`last'" == "" {
		di as err "you must specify either add() or last() "
		exit 198
	}	
	if "`add'" != "" & "`last'" != "" {
		di as err "you must specify either add() or last() , not both"
		exit 198
	}	

	qui tsset, noquery
	local pvar "`r(panelvar)'"
	
	if "`pvar'"  == "" {
		tsreport 
		if r(N_gaps) > 0 {
			tsfill
		}	
	}
	else {
		qui count if `pvar' >= . 
		if r(N) > 0 {
			di as err "missing values in panel variable not "/*
				*/ "allowed"
			_est unhold `pest'
			exit 198
		}	
		tsreport ,panel 
		if r(N_gaps) > 0 {
			tsfill
			capture confirm variable `samp'
			if _rc == 0 {
				qui replace `samp' = 0 if `samp' >= .
			}	
		}	
	}
	
	if "`panel'" != "" & "`pvar'" == "" {
		di as err "no panel variable has been tsset"
		exit 198
	}	
	
	if "`panel'" != "" {
		capture confirm integer number `panel'
		if _rc >0 {
			di as err "panel() must specify an integer "/*
				*/ "that corresponds to a panel"
			exit _rc
		}	
		qui count if `pvar' == `panel'
		if r(N) == 0 {
			di as err "no observations for which `pvar' == `panel'"
			exit 2000
		}
	}	
			

	if "`pvar'" == "" {
		_tsappend1 , last(`last') `tsfmt' `add'
		capture confirm variable `samp'
		if _rc == 0 {
			qui replace `samp' = 0 if `samp' >= .
		}	
		_est unhold `pest'
		exit
	}
	else {
		if "`panel'" != "" {
			qui _tsappend2 , last(`last') panel(`panel') /*
				*/ `tsfmt' `add'
		}
		else if "`panel'" == "" & "`last'" != "" {
			qui _tsappend3, last(`last') `tsfmt'
		}
		else {
			qui _tsappend4, `add'
		}
	}

	capture confirm variable `samp'
	if _rc == 0 {
		replace `samp' = 0 if `samp' >= .
	}	
	_est unhold `pest'

end	

program define _tsappend1, rclass
	version 8.0
	syntax , [ last(string) tsfmt(string) add(string)]

	qui tsset
	local pvar   "`r(panelvar)'"
	tempname tmax tmin
	scalar `tmax' = `r(tmax)'
	scalar `tmin' = `r(tmin)'
	local tvar   "`r(timevar)'"
	
	tempname delta
	scalar `delta' = `: char _dta[_TSdelta]'
	
	qui count if `tvar' >= .
	if r(N) > 0 {
		di as err "the time variable may not be missing"
		exit 198
	}	

	if "`last'" != "" {
		if "`tsfmt'" == "" {
			di as err "tsfmt() must be specified with last()"
			exit 198
		}	
		local lastt = `tsfmt'(`last')
	}
	else {
		capture confirm integer number `add'
		if _rc>0 {
			di as err "add() must specify a positive integer "
			exit 198
		}
		if `add'<=0 {
			di as err "add() must specify a strictly "/*
				*/ "positive integer "
			exit 198
		}
		local lastt `=`add' + `tmax''
	}
	
	if `lastt' <= `tmax' {
		di as txt "`lastt' is already in the dataset"
		ret scalar add = 0
		exit
	}
	if "`add'" == "" {
		local add `=(`lastt' - `tmax') / `delta''
	}	
	qui sort `tvar'
	qui des 
	local N = r(N)
	local newN = int(`N'+`add')
	qui set obs `newN'
	qui replace `tvar'=`tvar'[_n-1] + `delta' if _n > `N'
	ret scalar add = `add'

end

program define _tsappend2, rclass
	version 8.0
	syntax , [add(string) last(string) tsfmt(string) panel(string)]

	if "`panel'" == "" {
		di as err "panel() must be specified when not appending " ///
			"to all panels"
		exit 198
	}

	qui tsset, noquery
	local tvar   "`r(timevar)'"
	local pvar   "`r(panelvar)'"
	
	tempname delta
	scalar `delta' = `: char _dta[_TSdelta]'

	qui count if `tvar' >= .
	if r(N) > 0 {
		di as err "the time variable may not be missing"
		exit 198
	}	
	if "`pvar'" ==  "" {
		di as err "no panel specified in tsset"
		di as err "cannot specify panel() without" /*
			*/ " a panel variable in tsset"
		exit 198
	}
	tempvar touse
	qui gen byte `touse'=(`pvar'==`panel' & `pvar' < .)
	qui sum `pvar' if `touse'
	if r(max) > r(min) {
		di as err "more than one panel specified in "/*
			*/ "panel(`panel') "
		exit 198
	}
	qui sort `touse' `pvar' `tvar'
	local ptmax `=`tvar'[_N] '

	qui sum `tvar' if `touse'
	tempname tmax tmin
	scalar `tmax' = `r(max)'
	scalar `tmin' = `r(min)'

	
	if "`last'" != "" {
		if "`tsfmt'" == "" {
			di as err "tsfmt() must be specified with last()"
			exit 198
		}	
		local lastt `=`tsfmt'(`last')'
	}
	else {
		capture confirm integer number `add'
		if _rc>0 {
			di as err "add() must specify a positive integer "
			exit 198
		}
		if `add'<=0 {
			di as err "add() must specify a positive integer "
			exit 198
		}
		local lastt  `=`add' + `tmax''
	}
	
	
	if `tmax' >= `lastt' {
		di as err "`lastt' is already in panel `panel' "
		ret scalar add = 0
		exit 
	}
	if "`add'" == "" {
		local add `=(`lastt' - `tmax') / `delta''
	}	
	qui sort `touse' `pvar' `tvar'
	qui des 
	local N = r(N)
	local newN=int(`N'+`add')
	
	qui set obs `newN'
	qui replace `pvar'=`panel' if _n> `N' 
	qui replace `tvar'=`tvar'[_n-1] + `delta' if `tvar'>`tmax' & /*
		*/ `pvar' == `panel'
	ret scalar add = `add'

end

program define _tsappend3, rclass
	version 8.0
	syntax , [last(string) tsfmt(string)]

	qui tsset, noquery
	local tvar   "`r(timevar)'"
	local pvar   "`r(panelvar)'"
	tempname delta
	scalar `delta' = `: char _dta[_TSdelta]'

	qui count if `tvar' >= .
	if r(N) > 0 {
		di as err "the time variable may not be missing"
		exit 198
	}	
	tempvar touse
	qui gen byte `touse'= `pvar' < .
	qui sum `pvar' if `touse'
	local panel = r(max)
	qui sort `touse' `pvar' `tvar'
	local ptmax `=`tvar'[_N] '

	tempvar tmax tmin
	qui by `touse' `pvar' : egen `tmax' = max(`tvar')
	qui by `touse' `pvar' : egen `tmin' = min(`tvar')

	if "`last'" != "" {
		if "`tsfmt'" == "" {
			di as err "tsfmt() must be specified with last()"
			exit 198
		}	
		local lastt `=`tsfmt'(`last')'
	}
	
	if `lastt' <= `tmax' {
                di as err "Some panels have observations later than `lastt'"
        }

	tempvar add
	gen `add' = max((`lastt' - `tmax') / `delta' + 1, 1) if `touse'
	tempvar temp addind
	qui sort `touse' `pvar' `tvar'
	by `touse' `pvar' : replace `add' = 0 if _n != _N
	qui sum `add' if `touse'
	local added = r(sum) - `panel'
	qui expand `add', gen(`addind')
	qui sort `touse' `pvar' `tvar' `addind'
	qui by `touse' `pvar' : replace `tvar' = `tvar'[_n-1] + `delta' /*
                */ if `add'[_n-1] != 0 & _n!=1
	

	// replace the unintended carryover values by missing values in the
	// appended obs       
	foreach v of varlist * {
		if "`v'" != "`pvar'" & "`v'" != "`tvar'" & !regexm("`v'", "^_") {
			capture confirm numeric variable `v' 
			if !c(rc) {
				qui replace `v' = . if `addind'
			}
			else {
				qui replace `v' = "" if `addind'
			}
		}
	}
	
	
	ret scalar add = `added'
end
program define _tsappend4, rclass
	version 8.0
	syntax , [add(string)]

	qui tsset, noquery
	local tvar   "`r(timevar)'"
	local pvar   "`r(panelvar)'"
	tempname delta
	scalar `delta' = `: char _dta[_TSdelta]'

	qui count if `tvar' >= .
	if r(N) > 0 {
		di as err "the time variable may not be missing"
		exit 198
	}	
	tempvar touse
	qui gen byte `touse'= `pvar' < .
	qui sum `pvar' if `touse'
	local panel = r(max)
	qui sort `touse' `pvar' `tvar'
	local ptmax `=`tvar'[_N] '

	qui sum `tvar' if `touse'
	tempname tmax tmin
	scalar `tmax' = `r(max)'
	scalar `tmin' = `r(min)'

	capture confirm integer number `add'
	if _rc>0 {
		di as err "add() must specify a positive integer "
		exit 198
	}
	if `add'<=0 {
		di as err "add() must specify a positive integer "
		exit 198
	}
	local lastt  `=`add' + `tmax''
	
	
	if "`add'" == "" {
		local add `=(`lastt' - `tmax') / `delta''
	}	
	tempvar temp
	qui sort `touse' `pvar' `tvar'
	by `touse' `pvar' : gen `temp' = (_n==1)
	qui sum `temp'
	local numpanels = `r(sum)' 
	qui des 
	local N = r(N)
	local newN=int(`N'+`add'*`numpanels')
	by `touse' : replace `temp' = sum(`temp')	
	qui set obs `newN'
	replace `touse' = 1 if _n>`N'
	bysort `touse' : replace `temp' = 1 if /*
		*/mod((_n-`N'+`add'-1),`add')==0 & _n>`N'
	by `touse' : replace `temp' = sum(`temp') if _n>`N'
	sort `touse' `temp' `tvar'
	by `touse' `temp' : replace `tvar' = `tvar'[_n-1]+`delta' /*
		*/ if missing(`tvar') & (`tvar'>`tmax')
	by `touse' `temp' : replace `pvar' = `pvar'[_n-1] if missing(`pvar')
	ret scalar add = `add'
end

