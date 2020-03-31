*! version 1.0.0  24oct2018
program cmtab, sortpreserve byable(recall)
	version 16

	syntax [varlist(numeric default=none max=1)] [fw iw] [if] [in] , ///
		CHOICE(varname numeric)				         ///
		[ ALTWISE						 ///
		  MISSing					 	 ///
		  M							 ///
		  MI							 ///
		  MIS							 ///
		  TIME						 	 ///
		  TRANSpose					 	 ///
		  COMPact				       		 ///
		  TIMELAST			       			 ///
		  * ]

	if (`"`m'"' != "") {
		di as error "option {bf:m} not allowed"
		exit 198
	}

	if (`"`mi'"' != "") {
		di as error "option {bf:mi} not allowed"
		exit 198
	}

	if (`"`mis'"' != "") {
		di as error "option {bf:mis} not allowed"
		exit 198
	}

	local options `"`options' `missing'"'

	if ("`missing'" == "") {

		local varmarkout `varlist'
	}

	if ("`missing'" != "" & "`varlist'" == "") {

di as error "{p}{it:varname} required when option {bf:missing} specified{p_end}"

		exit 100
	}

	if ("`transpose'" != "" & "`varlist'" == "" & "`time'" == "") {

di as error "{p}option {bf:transpose} not allowed for one-way tabulations{p_end}"

		exit 198
	}

	local wt `weight'
	local weight  // erase macro so any weights ignored by marksample

	marksample ifin, novarlist

	tempvar touse

	// cmsample will issue errors and warnings.

	cmsample `varmarkout' [`wt'`exp'] if `ifin', ///
		gen(`touse')			     ///
		choice(`choice')		     ///
		`altwise'			     ///
		marksample

	local timevar `r(timevar)'
	local altvar  `r(altvar)'
	local caseid  `r(caseid)'

	if ("`time'" != "" & "`timevar'" == "") {

di as error "{p}option {bf:time} requires time variable to be {bf:cmset}{p_end}"

		exit 198
	}

	// Determine whether varlist is a casevar.

	if ("`varlist'" != "") {
		cap assertnested `varlist' `caseid' if `touse', missing
		if (c(rc) == 0) {
			local iscasevar iscasevar
		}
		else if (c(rc) == 1) {
			error 1
		}
	}

	// Do tabulations.

	if ("`time'" != "") {
		TabTime `touse' `choice' `timevar' `varlist'   ///
			[`wt'`exp'],			       ///
			altvar(`altvar') 		       ///
			`transpose' 			       ///
			`compact'			       ///
			`timelast'			       ///
			`iscasevar'			       ///
			`options'
	}
	else {
		Tab `touse' `choice' `varlist' [`wt'`exp'], ///
			altvar(`altvar') `transpose' `iscasevar' `options'
	}
end

program Tab, rclass
	syntax varlist(numeric min=2 max=3) [fw iw] [, ///
		ALTVAR(string) 			       ///
		TRANSPOSE      			       ///
		ISCASEVAR			       ///
		* ]

	gettoken touse  varlist : varlist
	gettoken choice xvar    : varlist

	if ("`altvar'" != "" & "`xvar'" == "") {

di _n as text "{p 0 4 2}Tabulation of chosen alternatives ({bf:`choice' = 1}){p_end}"

		tab `altvar' [`weight'`exp'] ///
			if `choice' == 1 & `touse', `options'
	}
	else if ("`altvar'" != "" & "`xvar'" != "") {

di _n as text "{p 0 4 2}Tabulation for chosen alternatives ({bf:`choice' = 1}){p_end}"

		SayCasevar `xvar', `iscasevar'

		if ("`transpose'" == "") {
			tab `altvar' `xvar' [`weight'`exp'] ///
				if `choice' == 1 & `touse', `options'
		}
		else {
			tab `xvar' `altvar' [`weight'`exp'] ///
				if `choice' == 1 & `touse', `options'
		}
	}
	else if ("`altvar'" == "" & "`xvar'" != "") {

di _n as text "{p 0 4 2}Tabulation of {bf:`xvar'} by chosen or not chosen ({bf:`choice'}){p_end}"

		SayCasevar `xvar', `iscasevar'

		if ("`transpose'" == "") {
			tab `choice' `xvar' [`weight'`exp'] ///
				if `touse', `options'
		}
		else {
			tab `xvar' `choice' [`weight'`exp'] ///
				if `touse', `options'
		}
	}
	else {

di _n as text "{p 0 4 2}Tabulation of {bf:`choice'}{p_end}"

		tab `choice' [`weight'`exp'] if `touse', `options'
	}

	return add

	if (return(c) == .) {
		return scalar c = 1
	}
end

program TabTime, rclass
	syntax varlist(numeric min=3 max=4) [fw iw] [, ///
		ALTVAR(string) 			       ///
		TRANSPOSE      			       ///
		COMPACT				       ///
		TIMELAST			       ///
		ISCASEVAR			       ///
		* ]

	gettoken touse   varlist : varlist
	gettoken choice  varlist : varlist
	gettoken timevar xvar    : varlist

	if ("`altvar'" != "" & "`xvar'" == "") {

		di _n as text "{p 0 4 2}Tabulation of chosen alternatives " ///
			      "({bf:`choice' = 1}) by time "                ///
			      "{bf:`timevar'}{p_end}"

		if ("`transpose'" == "") {
			tab `altvar' `timevar' [`weight'`exp'] ///
				if `choice' == 1 & `touse', `options'
		}
		else {
			tab `timevar' `altvar' [`weight'`exp'] ///
				if `choice' == 1 & `touse', `options'
		}
	}
	else if ("`altvar'" != "" & "`xvar'" != "") {

		if ("`compact'" == "") {
			TabTimeOver `0'
		}
		else {
			TabTimeTable `0'
		}
	}
	else if ("`altvar'" == "" & "`xvar'" != "") {

di _n as text "{p 0 4 2}Tabulation for all chosen alternatives ({bf:`choice' = 1}){p_end}"

		SayCasevar `xvar', `iscasevar'

		if ("`transpose'" == "") {
			tab `xvar' `timevar' [`weight'`exp'] ///
				if `choice' == 1 & `touse', `options'
		}
		else {
			tab `timevar' `xvar' [`weight'`exp'] ///
				if `choice' == 1 & `touse', `options'
		}
	}
	else if ("`transpose'" == "") {

di _n as text "{p 0 4 2}Tabulation of {bf:`choice'} by time {bf:`timevar'}{p_end}"

		tab `choice' `timevar' [`weight'`exp'] if `touse', `options'
	}
	else {

di _n as text "{p 0 4 2}Tabulation of time {bf:`timevar'} by {bf:`choice'}{p_end}"

		tab `timevar' `choice' [`weight'`exp'] if `touse', `options'
	}

	return add

	if (return(c) == . & "`compact'" == "") {
		return scalar c = 1
	}
end

program TabTimeOver, rclass
	syntax varlist(numeric min=4 max=4) [fw iw] , ///
		ALTVAR(string) 			      ///
		[ TRANSPOSE      		      ///
		  TIMELAST			      ///
		  ISCASEVAR			      ///
		  * ]

	gettoken touse   varlist : varlist
	gettoken choice  varlist : varlist
	gettoken x1	 x2    : varlist

di _n as text "{p 0 4 2}Tabulations by chosen alternatives ({bf:`choice' = 1}){p_end}"

	SayCasevar `x2', `iscasevar'

	if ("`timelast'" != "") {
		local tmp `x1'
		local x1  `x2'
		local x2  `tmp'
	}
	else {
		local saytime `"time "'
	}

	tempname A x1value

	qui tab `x1' [`weight'`exp'] ///
		if `choice' == 1 & `touse', matrow(`A')

	local nrows = rowsof(`A')

	local fmt : format `x1'

	forvalues i = 1/`nrows' {

		scalar `x1value' = `A'[`i', 1]

		local x1valfmt : di `:format `x1'' `x1value'
		local x1valfmt `x1valfmt'  // trim

di _n as text "{p 4 4 2}`saytime'{bf:`x1'} = " as res "`x1valfmt'{p_end}"

		if ("`transpose'" == "") {
			tab `altvar' `x2' [`weight'`exp']          ///
				if `x1' == `x1value'          ///
				& `choice' == 1 & `touse', ///
				`options'
		}
		else {
			tab `x2' `altvar' [`weight'`exp']          ///
				if `x1' == `x1value'          ///
				& `choice' == 1 & `touse', ///
				`options'
		}
	}

	return add

	if (return(c) == .) {
		return scalar c = 1
	}
end

program TabTimeTable
	syntax varlist(numeric min=4 max=4) [fw iw] , ///
		ALTVAR(string) 			      ///
		COMPACT				      ///
		[ TRANSPOSE      		      ///
		  TIMELAST			      ///
		  ISCASEVAR			      ///
		  * ]

	gettoken touse   varlist : varlist
	gettoken choice  varlist : varlist
	gettoken x1	 x2    : varlist

di _n as text "{p 0 4 2}Tabulations by chosen alternatives ({bf:`choice' = 1}){p_end}"

	SayCasevar `x2', `iscasevar'

	if ("`timelast'" != "") {
		local tmp `x1'
		local x1  `x2'
		local x2  `tmp'
	}

	if ("`transpose'" == "") {
		table `altvar' `x2' `x1' [`weight'`exp'] ///
			if `choice' == 1 & `touse', `options'
	}
	else {
		table `x2' `altvar' `x1' [`weight'`exp'] ///
			if `choice' == 1 & `touse', `options'
	}
end

program SayCasevar
	syntax varname [, ISCASEVAR ]

	if ("`iscasevar'" != "") {

di _n as text "{p 4 4 2}{bf:`varlist'} is constant within case{p_end}"

	}
end

