*! version 1.0.0  24oct2018
program cmsummarize, sortpreserve byable(recall)
	version 16

	syntax varlist(numeric) [fw] [if] [in] , ///
		CHOICE(varname numeric)		 ///
		[ ALTWISE			 ///
		  TIME				 ///
		  * ]

	// Use marksample to handle only `if' and `in'.

	local wt `weight'
	local weight  // erase macro so any weights ignored by marksample

	marksample ifin, novarlist

	tempvar touse

	// cmsample will issue errors and warnings.

	cmsample `varlist' [`wt'`exp'] if `ifin', ///
		gen(`touse')			  ///
		choice(`choice')		  ///
		`altwise'			  ///
		`cvopt'				  ///
		marksample

	local timevar `r(timevar)'
	local altvar  `r(altvar)'

	if ("`time'" != "" & "`timevar'" == "") {

di as error "{p}option {bf:time} requires time variable to be {bf:cmset}{p_end}"

		exit 198
	}

	// Compute chosen alternatives.

	if ("`altvar'" != "") {
		local chosen _chosen_alternative

		cap drop `chosen'

		qui gen `:type `altvar'' `chosen' = `altvar' ///
			if `choice' == 1 & `touse'

		local labval : value label `altvar'

		if ("`labval'" != "") {
			lab val `chosen' `labval'
		}

		lab var `chosen' "`choice' = 1"
	}

	// Do summarize.

	if ("`time'" != "") {
		TabStatTime `timevar' `touse' `choice' `varlist' ///
			[`wt'`exp'],                             ///
			chosen(`chosen') `options'
	}
	else {
		TabStat `touse' `choice' `varlist' [`wt'`exp'], ///
			chosen(`chosen') `options'
	}
end

program TabStat
	syntax varlist(numeric min=3) [fw iw] [, CHOSEN(string) ISCASEVAR * ]

	gettoken touse  varlist : varlist
	gettoken choice varlist : varlist

	if ("`chosen'" != "") {

di _n as text "{p}Statistics by chosen alternatives ({bf:`choice'} = 1){p_end}"

		local byvar `chosen'
	}
	else {

di _n as text "{p}Statistics by chosen or not chosen ({bf:`choice'}){p_end}"

		local byvar `choice'
	}

	SayCasevar `touse' `varlist'

	tabstat `varlist' [`weight'`exp']  if `touse', by(`byvar') `options'
end

program TabStatTime
	syntax varlist(numeric min=4) [fw iw] [, CHOSEN(string) ISCASEVAR * ]

	gettoken timevar varlist : varlist
	gettoken touse   varlist : varlist
	gettoken choice  varlist : varlist

	if ("`chosen'" != "") {

di _n as text "{p}Statistics by chosen alternatives ({bf:`choice'} = 1){p_end}"

		local byvar `chosen'
	}
	else {

di _n as text "{p}Statistics by chosen or not chosen ({bf:`choice'}){p_end}"

		local byvar `choice'
	}

	SayCasevar `touse' `varlist'

	tempname A timevalue

	qui tab `timevar' [`weight'`exp'] ///
		if `choice' == 1 & `touse', matrow(`A')

	local nrows = rowsof(`A')

	local fmt : format `timevar'

	forvalues i = 1/`nrows' {

		scalar `timevalue' = `A'[`i', 1]

		local timevalfmt : di `fmt' `timevalue'
		local timevalfmt `timevalfmt'  // trim

di _n as text "{p}time {bf:`timevar'} = " as res "`timevalfmt'{p_end}"

		tabstat `varlist' [`weight'`exp']              ///
			if `timevar' == `timevalue' & `touse', ///
			by(`byvar') `options'
	}
end

program SayCasevar
	syntax varlist(numeric min=2)
	gettoken touse varlist : varlist

	_cm 
	local caseid `r(caseid)'

	local ncasevars 0

	foreach var of local varlist {

		cap assertnested `var' `caseid' if `touse', missing
		if (c(rc) == 0) {
			local casevars `casevars' `var'
			local ncasevars = `ncasevars' + 1
		}
		else if (c(rc) == 1) {
			error 1
		}
	}

	if (`ncasevars' == 1) {

di _n as text "{p 4 4 2}{bf:`casevars'} is constant within case{p_end}"

	}
	else if (`ncasevars' > 1) {

di _n as text "{p 4 4 2}variables constant within case:{p_end}" _n

		foreach var of local casevars {

di as text "{p 8}{bf:`var'}{p_end}

		}
	}
end

