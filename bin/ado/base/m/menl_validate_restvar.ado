*! version 1.0.2  24feb2020

program define menl_validate_restvar, sortpreserve
	syntax varlist(numeric min=1 max=2), touse(varname) [ ///
		restvar(string) vivar(varname) rescor(string) ///
		rescov(string) resvar(string) tsvar(varname)  ///
		tsset path(string) quietly ]

	gettoken sorder panels: varlist
	gettoken restvar itvar : restvar


	tempvar check touse1

	/* keep estimation sample in a contiguous block			*/
	qui gen byte `touse1' = 1-`touse'
	if "`panels'" != "" {
		sort `touse1' `panels' `sorder'

		local withinpanels " within panels"
	}
	else {
		sort `touse1' `sorder'
	}
	if "`vivar'" != "" {		
		qui gen int `check' = 0
		qui by `touse1' `panels' (`sorder'): replace `check' = ///
			`vivar'[_n]==`vivar'[_n+1] if _n<_N & `touse'
		qui count if `check'==1
		if r(N) {
			if "`rescov'" != "" {
				local what rescovariance(`rescov')
			}
			else {
				local what resvariance(`resvar')
			}
			/* could be a generated tempvar; name cached
			 *  as a char					*/
			local vivar1 : char `vivar'[name]
			if "`vivar1'" == "" {
				local vivar1 `vivar'
			}
			di as err "{p}index-variable {bf:`vivar1'} in "    ///
			 "option {bf: `what'} has repeated values within " ///
			 "panels; this is not allowed{p_end}"
			exit 459 
		}
		cap drop `check'
	}
	/* rescor and resvar always have content			*/
	if "`rescor'"!="identity" | "`resvar'"=="distinct" |	///
		("`rescov'"!="" & "`rescov'"!="identity") {
		if "`rescov'" != "" {
			local what rescovariance(`rescov')
		}
		else if "`rescor'" != "identity" {
			local what rescorrelation(`rescor')
		}
		else { // "`resvar'" == "distinct"
			local what resvariance(`resvar')
		}
		/* max panel size					*/
		qui gen `check' = 1
		qui by `touse1' `panels' (`sorder') : replace `check' = ///
			sum(`check') if `touse'
		qui by `touse1' `panels' (`sorder') : replace `check' = ///
			`check'[_N] if (_n<_N) & `touse'

		summarize `check', meanonly
		local pminsz = r(min)
		local pmaxsz = r(max)
		if `pmaxsz' == 1  {
			/* if called by margins allow this condition
			 *  through 					*/
			if "`c(marginscmd)'" != "on" {
				di as err "{p}maximum panel size is 1; " ///
				 "{bf:`what'} specification is not " ///
				 "allowed{p_end}"
				exit 498
			}
		}
		if "`rescor'"=="unstructured" | "`resvar'"=="distinct" | ///
		 	"`rescov'"=="independent" {
			/* restvar is the correlation index variable	*/
			summarize `restvar' if `touse', meanonly
			if "`itvar'" == "" {
				local itvar `vivar'
			}
			local tmin = r(min)
			local tmax = r(max)
			if `tmax' > `pmaxsz' & "`quietly'"=="" {
				/* could be a generated tempvar
				 *  name cache as a char		*/
				local itvar1 : char `itvar'[name]
				if "`itvar1'" == "" {
					local itvar1 `itvar'
				}
				if "`panels'" != "" {
					local size "maximum panel size"
				}
				else {
					local size "sample size"
				}
				di as txt "{p 0 6 2}note: index variable " ///
				 "{bf:`itvar1'} in specification "         ///
				 "{bf:`what'} has a maximum of `tmax' "    ///
				 "which exceeds the `size', `pmaxsz'{p_end}"
			}
		}
		cap drop `check'
	}
	if "`restvar'" == "" {
		exit
	}
	qui gen int `check' = 0
	qui by `touse1' `panels' (`sorder'): replace `check' = ///
		`restvar'[_n]-`restvar'[_n-1] if `touse' & _n>1

	qui count if `check' < 0
	if r(N) {
		if "`panels'"!="" {
			local path: subinstr local path " " ">", all
			local msg "hierarchy {bf:`path'}"
			local and " and"
			local sp " "
		}
		if "`tsvar'" != "" {
			local msg "`msg'`and'"
			if "`tsset'" != "" {
				local msg "`msg'`sp'{helpb tsset}"
				local sp " "
			}
			local msg "`msg'`sp'time/order variable {bf:`tsvar'}"
		}
		local name : char `restvar'[name]
		if "`name'" == "" {
			local name `restvar'
		}
		di as err "{p}invalid residual time variable " ///
		 "{bf:`name'}; order is inconsistent with the `msg'{p_end}"
		exit 451
	}
	tempvar check1
	qui gen byte `check1' = 0
	if ("`rescor'"=="ar" | "`rescor'"=="ma") & "`quietly'"=="" {
		if "`panels'" != "" {
			qui by `touse1' `panels' (`sorder'): replace  ///
				`check1' = `check'[_n]!=`check'[_n-1] ///
				if `touse' & _n>2
		}
		else {
			qui by `touse1' (`sorder'): replace `check1' = ///
				`check'[_n]!=`check'[_n-1] if `touse' & _n>2
		}
		qui count if `check1'!=0

		local name : char `restvar'[name]
		if "`name'" == "" {
			local name `restvar'
		}
		if r(N)>0 & "`quietly'"=="" {
			di as txt "{p 0 6 2}note: gaps exist in residual " ///
			 "time variable {bf:`name'}{p_end}"
		}
	}
	qui replace `check' = 0
	qui by `touse1' `panels' (`order'): replace `check' = ///
		`restvar'[_n]==`restvar'[_n+1] if _n<_N & `touse'
	qui count if `check'==1
	if r(N) {
		if "`rescov'" != "" {
			local what rescovariance(`rescov')
		}
		else if "`rescor'" != "" {
			local what rescorrelation(`rescor')
		}
		if "`rescor'"=="unstructured" {
			local type index
		}
		else {
			local type time
		}
		if "`itvar'" != "" {
		/* generated tempvar name cache as char			*/
			local itvar1 : char `itvar'[name]
			if "`itvar1'" == "" {
				local itvar1 `itvar'
			}
		}
		else {
			local itvar1 `tvar'
		}
		if "`what'" != "" {
			local what "in option {bf:`what'} "
		}
		di as err "{p}`type'-variable {bf:`itvar1'} `what'" ///
			 "has repeated values`withinpanels'; this " ///
			 "is not allowed{p_end}"
		exit 459
	}

end

exit
