*! version 6.0.1  16sep2004
program define bitowt, rclass
	version 6.0, missing
	syntax varlist(min=2) [in] [if] [, Case(string) Weight(string) ]
	tokenize `varlist'
	local D "`1'"
	local N "`2'"
	tempvar touse
	mark `touse' `if' `in'
	markout `touse' `varlist', strok
	qui drop if `touse'==0
	local n=_N
	tempvar cs wt C
	qui gen `C'=`N'-`D'
	qui gen `cs'=1
	qui expand 2
	qui replace `cs' =0 if _n>`n'
	gen long `wt'= `D' 
	qui replace `wt'= `C' if `cs'==0
	if "`case'"=="" {
		gen _case=`cs'
	}
	else {
		gen `case'=`cs'
	}
	if "`weight'"=="" {
		gen _weight=`wt'
	}
	else {
		gen `weight'=`wt'
	}

end
