*! version 1.0.0  22apr2019
program cmchoiceset, sortpreserve byable(recall)
	version 16

	syntax [varlist(numeric default=none max=1)] [if] [in] [, ///
		ALTWISE						  ///
		MISSing					 	  ///
		OBServations					  ///
		SIZE						  ///
		TIME                            		  ///
		TRANSpose					  ///
		GENerate(string)				  ///
		G(passthru)					  ///
		GE(passthru)					  ///
		* ]

	// Tabulation of choice sets will be versus either
	//
	//	1. timevar when option time specified;
	//	2. varlist treated as casevar, otherwise error;
	//	3. varlist not treated as casevar with option -observations-;
	//	4. nothing -- a one-way tabulation.

	if (`"`g'"' != "") {
		di as error "option {bf:g()} not allowed"
		exit 198
	}

	if (`"`ge'"' != "") {
		di as error "option {bf:ge()} not allowed"
		exit 198
	}

	if ("`time'" != "" & "`varlist'" != "") {
		di as error "{it:varname} not allowed when {bf:time} specified"
		exit 198
	}

	if ("`missing'" != "") {

		if ("`varlist'" == "") {

di as error "{p}{it:varname} required when option {bf:missing} specified{p_end}"

			exit 100
		}

		local options `"`options' missing"'
	}
	else if ("`varlist'" != "") {

		if ("`observations'" != "") {

			local varmarkout `varlist'
		}
		else {
			local cvopt casevar(`varlist')
		}
	}

	if ("`transpose'" != "" & "`varlist'" == "" & "`time'" == "") {

di as error "{p}option {bf:transpose} not allowed for one-way tabulations{p_end}"

		exit 100
	}
	
	if (_by() & `"`generate'"' != "") {
	
di as error "{p}option {bf:generate()} not allowed with {bf:by}{p_end}"

		exit 198
	}
	
	ParseGenerate `generate'
	local generate `s(generate)'
	local label    `s(label)'

	if ("`label'" != "" & "`size'" != "") {
		di as error "option {bf:label()} cannot be used with " ///
			    "option {bf:size}"
		exit 198
	}

	tempvar ifin touse 
	
	marksample ifin, novarlist  // to handle -by-

	// cmsample will issue errors and warnings.

	cap noi cmsample `varmarkout' if `ifin', ///
		gen(`touse')			 ///
		`altwise'		 	 ///
		`cvopt'			 	 ///
		marksample			 ///
		singletons

	if (c(rc)) {
		SayUseObservations `varlist'
		exit c(rc)
	}

	local caseid  `r(caseid)'
	local timevar `r(timevar)'
	local altvar  `r(altvar)'

	if ("`time'" != "" & "`timevar'" == "") {

di as error "{p}option {bf:time} requires time variable to be {bf:cmset}{p_end}"

		exit 198
	}

	if ("`size'" == "" & "`altvar'" == "") {

di as error "{p}option {bf:size} must be specified when no alternatives " ///
	    "variable has been set{p_end}"

		exit 198
	}

	if ("`time'" == "") {
		local timevar  // erase macro
	}

	// Check that varlist is a casevar. When -missing- not specified,
	// -cmsample- call above already did this check.

	if ("`missing'" != "" & "`observations'" == "") {
		cap noi cmsample if `touse', casevar(`varlist') message missing

		if (c(rc)) {
			SayUseObservations `varlist'
			exit c(rc)
		}
	}
	
	if ("`size'" != "") {
		TabSizeOfChoiceSet `caseid' `touse' `varlist' `timevar', ///
				   `observations' `time' `transpose'     ///
				   generate(`generate') `options'
	}
	else {
		TabChoiceSet `caseid' `altvar' `touse' `varlist' `timevar', ///
			     `observations' `time' `transpose'              ///
			     generate(`generate') label(`label')	    ///
			     `options'
	}
end

program ParseGenerate, sclass
	syntax [name(name=name)] [, REPLACE LABEL(name) ]
	
	if ("`name'" == "") {
	
		if ("`replace'" != "") {

di as error "option {bf:replace} must be specified after a {it:newvarname}"
		
			exit 198
		}
		
		if ("`label'" != "") {

di as error "option {bf:label()} must be specified after a {it:newvarname}"
		
			exit 198
		}
	}
	else {
		if ("`label'" != "" & "`replace'" == "") {
			cap label list `label'
			if (c(rc) == 0) {

di as error "{p}label {bf:`label'} already defined{p_end}"
			
				exit 110
			}
		}

		if ("`replace'" == "") {
			confirm new variable `name'
		}
	}
	
	sreturn local generate `name'
	sreturn local label    `label'
end

program SayUseObservations
	args varlist

	if (r(N_err_casevar_nc) != . & r(N_err_casevar_nc) > 0) {

di as error "{p 4 4 2}Use option {bf:observations} when {bf:`varlist'} is not a casevar.{p_end}"

	}
end

program TabSizeOfChoiceSet
	syntax varlist(min=2 max=3) [,			///
					OBSERVATIONS	///
					TIME		///
					TRANSPOSE	///
					GENERATE(name)	///
					* ]

	gettoken caseid varlist : varlist
	gettoken touse  xvar    : varlist  // xvar optional

	if ("`generate'" == "") {
		tempvar generate
	}

	SizeOfChoiceSet `caseid' `touse', generate(`generate')

	Tab `caseid' `touse' `generate' `xvar', ///
		`observations' `time' `transpose' message("size") `options'
end

program SizeOfChoiceSet
	syntax varlist(min=2 max=2) , GENERATE(name)

	gettoken caseid touse : varlist

	quietly {
		tempvar sizevar

		gen byte `sizevar' = . in 1

		bysort `caseid': replace `sizevar' ///
			= cond(_n == _N & sum(`touse'), sum(`touse'), .)

		bysort `caseid': replace `sizevar' = `sizevar'[_N]

		cap drop `generate'

		rename `sizevar' `generate'

		lab var `generate' "Size of choice set"
	}
end

program TabChoiceSet
	syntax varlist(min=3 max=4) [,			///
				       OBSERVATIONS	///
				       TIME		///
				       TRANSPOSE	///
				       GENERATE(name)	///
				       LABEL(name)	///
					* ]

	gettoken caseid varlist : varlist
	gettoken altvar varlist : varlist
	gettoken touse  xvar    : varlist  // xvar optional

	if ("`generate'" == "") {
		tempvar generate
	}

	if ("`label'" == "") {
		local label `generate'
	}

	PossibleAlt `caseid' `altvar' `touse', ///
		generate(`generate') label(`label')

	cap noi {
		Tab `caseid' `touse' `generate' `xvar',	   ///
			`observations' `time' `transpose'  ///
			message("possibilities") `options'
	}

	if (c(rc)) {
		if (c(rc) == 134) {

di as error "{p 4 4 2}"
di as error "There are too many choice-set possibilities to tabulate."

			if ("`xvar'" != "" & "`time'" == "") {
di as error "Try running {bf:cmchoiceset} without a {it:varlist}."
			}
			else if ("`time'" != "") {
di as error "Try running {bf:cmchoiceset} without the option {bf:time}."
			}

di as error "{p_end}"
			exit 134
		}

		exit c(rc)
	}
end

program Tab, rclass
	syntax varlist(min=3 max=4) , MESSAGE(string)	///
				      [ OBSERVATIONS 	///
					TIME 		///
					TRANSPOSE 	///
					* ]

	gettoken caseid varlist : varlist
	gettoken touse  varlist : varlist
	gettoken x1     x2      : varlist  // x2 optional

	if ("`observations'" == "") {
		tempvar tabtouse

		bysort `touse' `caseid': gen byte ///
			`tabtouse' = (_n == _N & `touse')
	}
	else {
		local tabtouse `touse'
	}

	if ("`x2'" == "") {
		di _n as text "Tabulation of choice-set `message'"

		tab `x1' if `tabtouse', `options'

		SayWhatTotalIs, `observations'

		return add

		return scalar c = 1

		exit
	}

	if ("`time'" != "") {
		local saytime `"time "'
	}

	if ("`transpose'" == "") {
di
di as text "{p 0 4 2}"
di as text "Tabulation of choice-set `message' by `saytime'{bf:`x2'}"
di as text "{p_end}"

		tab `x1' `x2' if `tabtouse', `options'
	}
	else {
di
di as text "{p 0 4 2}"
di as text "Tabulation of `saytime'{bf:`x2'} by choice-set `message'"
di as text "{p_end}"

		tab `x2' `x1' if `tabtouse', `options'
	}

	SayWhatTotalIs, `observations'

	return add
end

program SayWhatTotalIs
	syntax [, OBSERVATIONS ]

	if ("`observations'" != "") {

		di _n as text "Total is number of observations."
	}
	else {
		di _n as text "Total is number of cases."
	}
end

program PossibleAlt
	syntax varlist(min=3 max=3) , GENERATE(name) LABEL(name)

	gettoken caseid varlist : varlist
	gettoken altvar touse   : varlist

	quietly {
		tempvar pvar enpvar

		gen str `pvar' = "" in 1

		cap confirm numeric variable `altvar'
		if (c(rc)) {
			bysort `touse' `caseid' (`altvar'): replace ///
				`pvar' = cond(_n > 1,		    ///
				         `pvar'[_n - 1] + " ", "")  ///
				         + `altvar' if `touse'
		}
		else {
			bysort `touse' `caseid' (`altvar'): replace ///
				`pvar' = cond(_n > 1,		    ///
				         `pvar'[_n - 1] + " ", "")  ///
				         + strofreal(`altvar') if `touse'
		}

		bysort `touse' `caseid' (`altvar'): replace `pvar' ///
			= `pvar'[_N] if `touse'

		cap lab drop `label'

		cap drop `generate'

		encode `pvar', gen(`generate') label(`label')

		compress `generate'

		lab var `generate' "Choice set"
	}
end

