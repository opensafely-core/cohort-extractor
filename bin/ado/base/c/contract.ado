*! version 1.2.5  09mar2016
* Based on version 1.1.0 of collfreq.ado   NJC 22 April 1998      STB-44 dm59
* Options percent(varname), cfreq(varname), cpercent(varname), format(format)
* and float based on version 1.0.0 of pcontract 31 July 2003 Roger Newson
program define contract
	version 6.0, missing
	syntax varlist [if] [in] [fw] [, Freq(string) CFreq(name) /*
	*/Percent(name) CPercent(name) FLOAT FORMat(string) Zero noMISS]
	
	* Set type and format for generated numeric variables *	
	if (`"`percent'"' == "" & `"`cpercent'"' == "") & /*
	*/ `"`float'"' != ""  {
		di as error "percent or cpercent must be specified"
		exit 198		
	}
	else if `"`float'"' == "" {
		local numtype "double"
	}
	else {
		local numtype "float"	
	}
	
	if (`"`percent'"' == "" & `"`cpercent'"' == "") & /*
	*/ `"`format'"' != ""  {
		di as error "percent or cpercent must be specified"
		exit 198		
	}
	else  if `"`format'"' == "" {
		local format "%8.2f"		
	}
	

	*Mark Observations* 
	if "`miss'"=="nomiss" {	
		marksample touse , strok 
	}
	else {			
		marksample touse , strok novarlist 
	}

	* Check generated variables *
	if "`zero'" != "" {
		capture confirm new variable _fillin
		if _rc != 0 {
			di as error "_fillin already defined"
			exit 110
		}
	}

	if `"`freq'"' == "" {
		capture confirm new variable _freq
		if _rc == 0 {
			local freq "_freq"
		}
		else {
			di as error "_freq already defined: " /*
			*/ "use freq() option to specify frequency variable"
			exit 110
		}
	}
	else {
		confirm new variable `freq'
	}
	
	if `"`cfreq'"' != "" {	
		confirm new variable `cfreq'
	}
	
	if `"`percent'"' != "" {
		confirm new variable `percent'
	}

	if `"`cpercent'"' != "" {	
		confirm new variable `cpercent' 
	} 
	
	*Create dataset*
	tempvar expvar
	if `"`exp'"' == "" { 
		local exp "= 1" 
	}
	qui gen `expvar' `exp'

	preserve

	qui keep if `touse'
	if _N == 0 { 
		error 2000 
	}
	keep `varlist' `expvar'
	sort `varlist'

	qui by `varlist' : gen long `freq' = sum(`expvar')
	label var `freq' "Frequency"
	qui by `varlist' : keep if _n == _N

	if "`zero'" != "" {
		fillin `varlist'
		qui replace `freq' = 0 if `freq' >= .
		qui drop _fillin
	}
	
	* Generate new variables for cfreq(varname), percent(varname),*  
	* cpercent(varname)*
	if `"`cfreq'"' == "" & `"`cpercent'"' != "" {
		tempvar cfreq
	}
	if "`cfreq'" != "" {
		qui gene `numtype' `cfreq' = sum(`freq')
		lab var `cfreq' "Cumulative frequency"
	} 	
	if `"`percent'"' != "" {
		qui summ `freq', meanonly
		local Ntot = r(sum)
		qui gene `numtype' `percent' = (100*`freq')/`Ntot'
		lab var `percent' "Percent"
		format `percent' `format'
	}
	if "`cpercent'" != "" {
		qui summ `freq', meanonly
		local Ntot = r(sum)
		qui gene `numtype' `cpercent' = (100*`cfreq')/`Ntot'
		lab var `cpercent' "Cumulative percent"
		format `cpercent' `format'
	}
	qui compress `freq' `percent' `cfreq' `cpercent'
	
	
	restore, not
end

