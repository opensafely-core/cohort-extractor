*! version 1.0.0  10sep2018
program _cm, rclass
	version 16

	// No display except errors.

	syntax [, ALTREQUIRED PANEL ]

	local caseid       : char _dta[_cm_caseid]
	local panelvar     : char _dta[_cm_panelvar]
	local origpanelvar : char _dta[_cm_origpanelvar]
	local timevar      : char _dta[_cm_timevar]
	local altvar       : char _dta[_cm_altvar]

	// Check if cmset.

	if ("`caseid'`altvar'`origpanelvar'`panelvar'`timevar'" == "") {

di as error "data not {bf:cmset}"

		if ("`panel'" != "") {

di as error "{p 4 4 2}Use {bf:cmset} {it:panelvar} ....{p_end}"

		}
		else {

di as error "{p 4 4 2}Use {bf:cmset} {it:caseidvar} ....{p_end}"

		}

		exit 459
	}

	// Check settings for allowed combinations.

	CheckCombinations "`caseid'" "`panelvar'" "`origpanelvar'" ///
			  "`timevar'" "`altvar'"

	// altrequired.

	if ("`altvar'" == "" & "`altrequired'" != "") {

di as error "alternatives variable {it:altvar} not set"

		if ("`panel'" != "") {

di as error "{p 4 4 2}Use {bf:cmset} {it:panelvar} {it:timevar} {it:altvar}{p_end}"

		}
		else {

di as error "{p 4 4 2}Use {bf:cmset} {it:caseidvar} {it:altvar}{p_end}"

		}

		exit 459
	}

	// Check whether _caseid and _panelaltid might have been dropped.

	CheckUnderscore `caseid'  _caseid
	CheckUnderscore `panelvar _panelaltid

	// Check existence of variables.

	foreach x in `caseid' `panelvar' `origpanelvar' `timevar' {
		confirm numeric variable `x'
	}

	if ("`altvar'" != "") {
		confirm variable `altvar'  // can be string
	}

	// Check -xtset- settings.

	if ("`panelvar'" != "") {
		CheckXtset `panelvar' `timevar'
	}

	// Set r().

	return local timevar      `timevar'
	return local origpanelvar `origpanelvar'
	return local panelvar     `panelvar'
	return local altvar       `altvar'
	return local caseid       `caseid'
end

program CheckCombinations
	args caseid panelvar origpanelvar timevar altvar

// Allowed possibilities:
//
//	caseid	panelvar  origpanelvar  timevar  altvar        command
//	------  --------  ------------  -------  ------  -------------------
//	  1        0          0            0       0     cmset caseid, noalt
//	  1        0          0            0       1     cmset caseid altvar
//	  1        0          1            1       0     cmset id timevar, noalt
//	  1        1          1            1       1     cmset panel timevar altvar

	if ( !(  (  "`caseid'"       != ""   ///
	          & "`panelvar'"     == ""   ///
	          & "`origpanelvar'" == ""   ///
	          & "`timevar'"      == ""   ///
	          & "`altvar'"       == "" ) ///
	       | (  "`caseid'"       != ""   ///
	          & "`panelvar'"     == ""   ///
	          & "`origpanelvar'" == ""   ///
	          & "`timevar'"      == ""   ///
	          & "`altvar'"       != "" ) ///
	       | (  "`caseid'"       != ""   ///
	          & "`panelvar'"     == ""   ///
	          & "`origpanelvar'" != ""   ///
	          & "`timevar'"      != ""   ///
	          & "`altvar'"       == "" ) ///
	       | (  "`caseid'"       != ""   ///
	          & "`panelvar'"     != ""   ///
	          & "`origpanelvar'" != ""   ///
	          & "`timevar'"      != ""   ///
	          & "`altvar'"       != "" ) ) ) {

di as error "{bf:cmset} settings invalid"
di as error "{p 4 4 2}Rerun {bf:cmset} {it:caseidvar} ....{p_end}"

		exit 459
	}
end

program CheckUnderscore
	args x name

	if ("`x'" != "`name'") {
		exit
	}

	cap confirm variable `x'
	if (c(rc) == 111) {

di as error "{p}variable {bf:`x'} not found{p_end}"
di as error "{p 4 4 2}Variable {bf:`x'} was created by {bf:cmset} " ///
	    "and is required for {bf:cmxt} commands.{p_end}"

		exit 111
	}
end

program CheckXtset
	args panelvar timevar

	// Call _xt not only to get settings, but to run checks.

	_xt

	if (  "`panelvar'" != "`r(ivar)'" ///
	    | "`timevar'"  != "`r(tvar)'" ) {

di as error "conflict between {bf:cmset} settings and {bf:xtset} settings"
di as error "{p 4 4 2}Rerun {bf:cmset} {it:panelvar} {it:timevar} ....{p_end}"

		exit 459
	}
end

