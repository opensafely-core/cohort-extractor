*! version 2.0.12  15oct2019
program define separate, rclass sortpreserve
	version 6, missing

	syntax varname [if] [in], BY(str asis) [Generate(str) /*
	*/ Indicator(str) MISSing SEQuential SHORTlabel VERYSHORTlabel ]

	if "`shortlabel'" != "" & "`veryshortlabel'" != "" { 
		version 7: di as err "options {bf:shortlabel} and {bf:veryshortlabel} may not be specified together"
		exit 198 
	}	

					/* verify by(varname|exp)	*/
	capture confirm var `by'
	if _rc == 0 {
		_nostrl error : `by'
		unab by: `by', max(1) name(by())
	}
	else {
		capt assert (`by')==0 | (`by')==1 | (`by')>=.
		if _rc { 
			di in red `"by(`by') invalid"'
			exit _rc 
			/*NOTREACHED*/
		}
		local indicat `"`by'"'
		tempvar by
		qui gen byte `by' = `indicat'
	}


					/* ...parsing complete		*/

					/* identify sample...		*/

	tempvar touse group
	mark `touse' `if' `in'
	if "`missing'" == "" {
		markout `touse' `by', strok
	}
	qui count if `touse'
	if r(N) == 0 {
		di in red "no observations satisfy conditions"
		exit 2000
	}
					/* ...end identify sample	*/

					/* set group...			  */
					/* group is `group'==1 ... `max'  */

	local btype : type `by'
	if "`missing'"!="" & bsubstr("`btype'",1,3)=="str" {
		tempvar ismis 
		qui gen byte `ismis' = `by'==""
	}

	sort `touse' `ismis' `by'
	qui by `touse' `ismis' `by': gen `group' = _n == 1 if `touse'
	qui replace `group' = sum(`group')
	local max = `group'[_N]
	if `max' > 1500 {
		di in red "too many groups"
		exit 134
	}
					/* ...end set group 		*/


					/* set stubname...		*/
	if `"`generat'"'=="" {
		local generat `"`varlist'"'
		local maytrim 1
	}
	else 	local maytrim 0
					/* ...end set stubname		*/



					/* orig. values feasible?...	*/
	local useorig 0
	local maxv `max'
	if "`sequent'"=="" {
		capture confirm string var `by'
		if _rc {
        		capture assert `by' >= 0 & int(`by')==`by' & /*
				*/ `by'<9999 if `touse' & `by'<.
			if _rc==0 {
				local useorig 1
				qui summ `by' if `touse'
				local maxv = r(max)
			}
		}
	}
					/* ...end orig. value feasible	*/


					/* trim name...			*/
	if _caller() < 7 {				
		if (length(`"`generat'`maxv'"')>32) {
			if `maytrim' {
				local generat = ubsubstr(`"`generat'"',1,/*
						*/ 32-length("`maxv'"))
			}
			else {
				version 7: di in red `"{bf:`generat'}:  name too long"'
				exit 198
			}
		}
	}
	else {
		if (ustrlen(`"`generat'`maxv'"')>32) {
			if `maytrim' {
				local generat = usubstr(`"`generat'"',1,/*
						*/ 32-ustrlen("`maxv'"))
			}
			else {
				version 7: di in red `"{bf:`generat'}:  name too long"'
				exit 198
			}
		}	
	}
					/* ...end trim name		*/

					/* make the variables...	*/
	local bylab : value label `by'
	local type : type `varlist'
	local fmt : format `varlist'
	local vallab : value label `varlist'


	local i 1
	qui count if !`touse'
	local j = 1 + r(N)
	qui while `i' <= `max' {
		local byval = `by'[`j']

		if missing(`by'[`j']) {  
			local vname `"`generat'_`=`by'[`j']'"'
			local vname : subinstr local vname "." "", all
		}
		else if `useorig' {
			local vname `"`generat'`byval'"'
		}
		else 	local vname `"`generat'`i'"'

		tempname tname

		confirm new var `vname'
		local rlist `"`rlist' `vname'"'
		local tlist "`tlist' `tname'"

		gen `type' `tname' = `varlist' if `group' == `i'
		compress `tname'
		format `tname' `fmt'
		if `"`indicat'"' != "" {
			if `byval' == 0 {
				if "`veryshortlabel'`shortlabel'" != "" {
				  label var `tname' `"!(`indicat')"'
				}
				else {
				  label var `tname' `"`varlist', !(`indicat')"'
				}
			}
			else if `byval'==1 {
				if "`veryshortlabel'`shortlabel'" != "" {
				  label var `tname' `"`indicat'"'
				}
				else {
				  label var `tname' `"`varlist', `indicat'"'
				}
			}
		}
		else {
			if `"`bylab'"' != "" {
				local byval : label `bylab' `byval'
			}
			if "`veryshortlabel'" != "" {
			  label var `tname' `"`byval'"'
			}
			else if "`shortlabel'" != "" {
			  label var `tname' `"`by' == `byval'"'
			}
			else {
			  label var `tname' `"`varlist', `by' == `byval'"'
			}
			if `"`vallab'"' != "" {
				label val `tname' `vallab'
			}
		}
		count if `group' == `i'
		local j = `j' + r(N)
		local i = `i' + 1
	}
					/* ...end make the variables	*/


					/* make variables real...	*/
	tokenize `tlist'
	local i 1
	while "``i''" != "" {
		local vname : word `i' of `rlist'
		rename ``i'' `vname'
		local i = `i' + 1
	}
					/* ...end make variables real	*/

	return local varlist `rlist'
	describe `rlist'
end
