*! version 1.0.2  10apr2019

program define menl_validate_tspanelvar, sclass sortpreserve
	syntax varlist(numeric min=1 max=2), touse(varname) [ path(string) ///
		quietly ]

	gettoken sorder panels: varlist

	cap tsset
	local rc = c(rc)
	if `rc' {
		/* should not happen here				*/
		di as err "{p}{helpb tsset} the data or use " ///
		 "option {bf:tsvar()}{p_end}"
		exit `rc'
	}
	local timevar `r(timevar)'
	local panelvar `r(panelvar)'

	if "`panels'" != "" {
		if "`panelvar'" == "" {
			di as err "{p}time-series panel variable not " ///
			 "found: {helpb tsset} with a panel variable{p_end}"
			exit 111
		}
	}
	else if "`panelvar'" != "" {
		/* user has defined a panel variable for evaluation
		 *  purposes						*/
		exit
	}
	/* sort order -sorder- generated using -menl- panel variable
	 *  -panels- and tsset time variable -timevar-
	 *  make sure panel variables from tsset and that generated from
	 *  the -menl- hierarchy agree					*/
	tempvar check touse1
	/* move estimation sample into one block			*/
	qui gen byte `touse1' = 1-`touse'
	sort `touse1' `panelvar' `timevar'

	if "`path'" != "" {
		local path: subinstr local path " " ">", all
		local path " {bf:`path'}"
	}
	/* check hierarchy order agrees with tsset order		*/
	qui gen long `check' = 0 
	qui by `touse1' `panelvar' (`timevar'): replace `check' = ///
		(`sorder'[_n]<=`sorder'[_n-1]) if `touse' & _n>1
/*
set more on
di `"list touse1 sorder panelvar panels timevar touse check, sepby(panelvar)"'
cap noi list `touse1' `sorder' `panelvar' `panels' `timevar' `touse' ///
	`check', sepby(`panelvar')
set more off
*/
	qui replace `check' = sum(`check') 
	if `check'[_N] != 0 {
		di as err "{p}panels and sort order generated from " ///
		 "hierarchy`path' does not agree with the sort order of " ///
		 "the {helpb tsset} panel and time variables " ///
		 "{bf:`panelvar'} and {bf:`timevar'}{p_end}"
		exit 459
	}
	if "`panelvar'"=="" {	// | "`panelvar'"=="`panels'" {
		exit
	}
	/* check for panelvar > panel					*/
	qui replace `check' = 0 
	qui by `touse1' `panelvar' (`timevar'): replace `check' = ///
		(`panels'[_n]!=`panels'[_n-1]) if `touse' & _n>1
/*
set more on
di `"list touse1 sorder panelvar panels timevar touse check, sepby(panelvar)"'
cap noi list `touse1' `sorder' `panelvar' `panels' `timevar' `touse' ///
	`check', sepby(`panelvar')
set more off
*/
	qui replace `check' = sum(`check') 
	if `check'[_N] != 0 {
		di as err "{p}panel variable generated from the random " ///
		 "effects hierarchy`path' is nested in {helpb tsset} panel " ///
		 "variable {bf:`panelvar'}; this is not allowed{p_end}"
		exit 459
	}

	/* check for panel > panelvar
	 *  not sure we can trip this; tsset panel variable becomes
	 *  menl group variable						*/
	qui replace `check' = 0 
	sort `touse1' `panels' `timevar'
	qui by `touse1' `panels' (`timevar'): replace `check' = ///
		(`panelvar'[_n]!=`panelvar'[_n-1]) if `touse' & _n>1
/*
set more on
di `"list touse1 sorder panels panelvar timevar touse check, sepby(panels)"'
cap noi list `touse1' `sorder' `panels' `panelvar' `timevar' `touse' ///
	`check', sepby(`panels')
set more off
*/
	qui replace `check' = sum(`check') 
	if `check'[_N] != 0 {
		di as err "{p}{helpb tsset} panel variable {bf:`panelvar'} " ///
		 "is nested in the panel variable generated from the " ///
		 "random effects hierarchy`path'; this is not allowed{p_end}"
		exit 459
	}
end

exit
