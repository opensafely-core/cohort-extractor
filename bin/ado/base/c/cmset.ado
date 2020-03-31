*! version 1.0.0  18mar2019
program cmset
	version 16

	// Possibilities:
	//
	//	cmset caseid, noalt
	//	cmset caseid altvar
	//	cmset origpanelvar timevar, noalt
	//	cmset origpanelvar timevar altvar

	return clear

	syntax [varlist(max=3 default=none)] [,			///
						CLEAR 		///
						noALTernatives	///
						ALTWISE		/// undocumented
						FORCE		///
						* ]

	// Handle -cmset, clear- and -cmset-.

	if ("`varlist'" == "") {
		syntax [, CLEAR ]

		if ("`clear'" != "") {
			ClearSettings
			exit
		}
		else {
			_cm // check settings

			local caseid       : char _dta[_cm_caseid]
			local panelvar     : char _dta[_cm_panelvar]
			local origpanelvar : char _dta[_cm_origpanelvar]
			local timevar      : char _dta[_cm_timevar]
			local altvar       : char _dta[_cm_altvar]
			local replay	   : char _dta[_cm_replay]

			local 0 , `replay'
			syntax [, ALTWISE FORCE ]

			TypeOfSetting

			local nvars        `s(nvars)'
			local alternatives `s(alternatives)'

			sreturn clear
		}
	}

	if ("`clear'" != "") {

di as error "option {bf:clear} not allowed when variables specified"

		exit 198
	}

	if ("`alternatives'" != "" & "`altwise'" != "") {

di as error "option {bf:altwise} not allowed with {bf:noalternatives}"

		exit 198
	}

	// Put variable names in macros for new -cmset-.

	if ("`varlist'" != "") {

		ProcessVarlist `varlist', `alternatives'

		local caseid       `s(caseid)'
		local panelvar     `s(panelvar)'
		local origpanelvar `s(origpanelvar)'
		local timevar      `s(timevar)'
		local altvar       `s(altvar)'

		sreturn clear

		local nvars : list sizeof varlist
	}

	// Do data checks and set r().

	if (`nvars' == 1) {

		SetCaseidNoAlt `caseid', `options'
	}
	else if (`nvars' == 2) {

		if ("`alternatives'" == "") {

			SetCaseidAlt `caseid' `altvar', `altwise' `force' ///
							`options'
		}
		else {
			SetCaseidTimeNoAlt `caseid' `origpanelvar' ///
				`timevar', `options'
		}
	}
	else {  // `nvars' == 3
		SetCaseidTimeAlt `caseid' `panelvar' `origpanelvar' ///
			`timevar' `altvar', `altwise' `force' `options'
	}

	if ("`varlist'" != "") {
		SetChars
	}

	DisplaySettings
end

program TypeOfSetting, sclass

	local caseid       : char _dta[_cm_caseid]
	local panelvar     : char _dta[_cm_panelvar]
	local origpanelvar : char _dta[_cm_origpanelvar]
	local timevar      : char _dta[_cm_timevar]
	local altvar       : char _dta[_cm_altvar]

	if (  "`caseid'"       != ""   ///
	    & "`panelvar'"     == ""   ///
	    & "`origpanelvar'" == ""   ///
	    & "`timevar'"      == ""   ///
	    & "`altvar'"       == "" ) {

	          sreturn local nvars 1
	          sreturn local alternatives noalternatives
	          exit
	}

	if (  "`caseid'"       != ""   ///
	    & "`panelvar'"     == ""   ///
	    & "`origpanelvar'" == ""   ///
	    & "`timevar'"      == ""   ///
	    & "`altvar'"       != "" ) {

	          sreturn local nvars 2
	          exit
	}

	if (  "`caseid'"       != ""   ///
	    & "`panelvar'"     == ""   ///
	    & "`origpanelvar'" != ""   ///
	    & "`timevar'"      != ""   ///
	    & "`altvar'"       == "" ) {

	          sreturn local nvars 2
	          sreturn local alternatives noalternatives
	          exit
	}

	if (  "`caseid'"       != ""   ///
	    & "`panelvar'"     != ""   ///
	    & "`origpanelvar'" != ""   ///
	    & "`timevar'"      != ""   ///
	    & "`altvar'"       != "" ) {

	          sreturn local nvars 3
	          exit
	}

	di as error "{bf:cmset} settings invalid"
	di as error "{p 4 4 2}Rerun {bf:cmset} {it:caseidvar} ....{p_end}"
	exit 459
end

program ProcessVarlist, sclass
	syntax varlist(min=1 max=3) [, noALTERNATIVES ]

	local nvars : list sizeof varlist

	if (`nvars' == 1) {

		confirm numeric variable `varlist'

		AlternativesVariableRequired, `alternatives'

		sreturn local caseid `varlist'
		exit
	}

	if (`nvars' == 2) {

		if ("`alternatives'" == "") {  // cmset caseid altvar

			local caseid : word 1 of `varlist'

			confirm numeric variable `caseid'

			sreturn local caseid `caseid'
			sreturn local altvar `: word 2 of `varlist''
			exit
		}

		// cmset origpanelvar timevar, noalt

		foreach x of local varlist {
			confirm numeric variable `x'
		}

		GenCaseidNoAlt `varlist'

		sreturn local caseid       _caseid
		sreturn local origpanelvar `: word 1 of `varlist''
		sreturn local timevar      `: word 2 of `varlist''
		exit
	}

	// `nvars' == 3.

	local origpanelvar : word 1 of `varlist'
	local timevar      : word 2 of `varlist'

	confirm numeric variable `origpanelvar'
	confirm numeric variable `timevar'

	NoAlternativesNotAllowed, `alternatives'

	GenCaseidAndPanelvar `varlist'

	sreturn local caseid       _caseid
	sreturn local panelvar     _panelaltid
	sreturn local origpanelvar `origpanelvar'
	sreturn local timevar      `timevar'
	sreturn local altvar       `: word 3 of `varlist''
end

program AlternativesVariableRequired
	syntax [, noALTERNATIVES ]

	if ("`alternatives'" == "") {

di as error "alternatives variable required"
di as error "{p 4 4 2}Use option {bf:noalternatives} to have unspecified " ///
	    "alternatives.{p_end}"

		exit 198
	}
end

program NoAlternativesNotAllowed
	syntax [, noALTERNATIVES ]

	if ("`alternatives'" != "") {

di as error "option {bf:noalternatives} not allowed when 3 variables specified"
di as error "{p 4 4 2}Option {bf:noalternatives} requires 1 variable " ///
	    "for nonpanel data and 2 variables for panel data.{p_end}"

		exit 198
	}
end

program ClearSettings
	char _dta[_cm_caseid]
	char _dta[_cm_panelvar]
	char _dta[_cm_origpanelvar]
	char _dta[_cm_timevar]
	char _dta[_cm_altvar]
	char _dta[_cm_replay]
end

program SetChars
	char _dta[_cm_caseid]       `r(caseid)'
	char _dta[_cm_panelvar]     `r(panelvar)'
	char _dta[_cm_origpanelvar] `r(origpanelvar)'
	char _dta[_cm_timevar]      `r(timevar)'
	char _dta[_cm_altvar]       `r(altvar)'
	char _dta[_cm_replay]       `r(replay)'
end

program DisplaySettings, rclass
	syntax

	// Display.

	local caseid       : char _dta[_cm_caseid]
	local altvar       : char _dta[_cm_altvar]
	local panelvar     : char _dta[_cm_panelvar]     // = _dta[_TSpanel]
	local timevar      : char _dta[_cm_timevar]      // = _dta[_TStvar]
	local origpanelvar : char _dta[_cm_origpanelvar]

	if ("`panelvar'" == "") {
		local indent 6
	}
	else {
		local indent 15
	}

	local col = 7 + `indent'
	di _n as text _col(`col') "caseid variable:  " as res "`caseid'"

	if ("`altvar'" != "") {
		local col = 1 + `indent'
		di as text _col(`col') "alternatives variable:  " ///
		   as res "`altvar'"
	}
	else {
		local col = `indent' - 2
		di as text _col(`col') "no alternatives variable"
	}

	if ("`panelvar'" == "") {

		if ("`timevar'" != "") {

			if (r(n_gaps) == 1) {
				local note ", but with a gap"
			}
			else if (r(n_gaps) > 1) {
				local note ", but with gaps"
			}

			local unit = plural(r(tdelta), "unit")

			local col = 9 + `indent'
			di as text _col(`col') "time variable:  " ///
			   as res "`timevar', `r(tmin)' to `r(tmax)'`note'"

			local col = 17 + `indent'
			di as text _col(`col') "delta:  " ///
			   as res `r(tdelta)' " `unit'"
		}

		return add
		exit
	}

	// If here, there are altvar, panelvar, and timevar.

	// Save r().

	tempname n_cases n_alt_min n_alt_avg n_alt_max altvar_min altvar_max

	scalar `n_cases'    = r(n_cases)
	scalar `n_alt_min'  = r(n_alt_min)
	scalar `n_alt_avg'  = r(n_alt_avg)
	scalar `n_alt_max'  = r(n_alt_max)
	scalar `altvar_min' = r(altvar_min)
	scalar `altvar_max' = r(altvar_max)

	// Display from xtset.

	cap noi xtset, panelname("panel by alternatives") ///
		       displayindent(`indent')
	if (c(rc)) {

		if (c(rc) == 1) {
			error 1
		}

		di as error _n "error from {bf:xtset}"
		exit c(rc)
	}

	di _n as text "note: data have been {bf:xtset}"

	return add

	return scalar altvar_max = `altvar_max'
	return scalar altvar_min = `altvar_min'
	return scalar n_alt_max  = `n_alt_max'
	return scalar n_alt_avg  = `n_alt_avg'
	return scalar n_alt_min  = `n_alt_min'
	return scalar n_cases    = `n_cases'

	return local origpanelvar `origpanelvar'
	return local altvar       `altvar'
	return local caseid       `caseid'
end

program CheckCaseidAndCreateTouse
	syntax varlist(min=1 max=1 numeric) , TOUSE(name)
	local caseid `varlist'

	marksample tmptouse

	rename `tmptouse' `touse'

	qui count if `touse'
	if (r(N) == 0) {
		error 2000
	}

	cap assert `caseid' == trunc(`caseid') if `touse'
	if (c(rc)) {

		if (c(rc) == 1) {
			error 1
		}

di as error "{p}{it:caseid} variable {bf:`caseid'} must be integer valued{p_end}"

		exit 459
	}

	tempvar  todrop

	qui bysort `caseid': gen byte `todrop' = (_N == 1) if `touse'

	qui replace `touse' = 0 if `todrop' == 1

	qui count if `touse'

	if (r(N) == 0) {
		ErrorAllChoiceSetsSizeOne
	}

	qui count if `todrop' == 1

	if (r(N) > 0) {
		di as text "{p 0 6 2}note: `r(N)' "            ///
			   plural(r(N), "case")                ///
			   " ignored because "                 ///
			   plural(r(N), "it has", "they have") ///
			   " only one alternative{p_end}"
	}
end

program ErrorAllChoiceSetsSizeOne
	syntax [, FORCE ]

	if ("`force'" == "") {
		di as error "all choice sets have only one alternative"
		exit 2000
	}

di as text "{p 0 6 2}note: all choice sets have only one alternative{p_end}"

end

program SetCaseidNoAlt, rclass
	syntax varlist(min=1 max=1 numeric) [, TOUSE(name) ]
	local caseid `varlist'

	if ("`touse'" == "") {
		tempvar touse
	}

	CheckCaseidAndCreateTouse `caseid', touse(`touse')

	tempvar size

	qui bysort `caseid': gen double `size' ///
		= cond(_n == _N & sum(`touse'), sum(`touse'), .)
		
	// Note: Data is left sorted by `caseid'.

	su `size', meanonly

	if (r(min) != r(max)){

di as text "{p 0 6 2}note: alternatives are unbalanced across choice sets; " ///
	   "choice sets of different sizes found{p_end}"

	}

	return scalar n_alt_max = r(max)
	return scalar n_alt_avg = r(mean)
	return scalar n_alt_min = r(min)
	return scalar n_cases   = r(N)

	return local caseid `caseid'
end

program SetCaseidAlt, rclass
	syntax varlist(min=2 max=2) [, ALTWISE FORCE ]
	gettoken caseid altvar : varlist

	tempvar touse

	CheckCaseidAndCreateTouse `caseid', touse(`touse')

	if ("`altwise'" == "") {

		// If there are any missing `altvar', then whole case omitted.

		tempvar hasmiss

		qui bysort `caseid': gen byte `hasmiss'	                ///
			= cond(_n == _N, sum(missing(`altvar')) > 0, .) ///
			  if `touse'

		qui count if `hasmiss' == 1

		if (r(N) > 0) {
			di as text "{p 0 6 2}note: `r(N)' "               ///
				   plural(r(N), "case has", "cases have") ///
				   " missing values of {bf:`altvar'}{p_end}"
		}

		qui by `caseid': replace `touse' = 0 if `hasmiss'[_N] == 1
	}
	else {
		markout `touse' `altvar', strok
	}

	qui count if `touse'
	if (r(N) == 0) {
		di as err "no cases remain after removing cases with " ///
			"missing observations"
		exit 2000
	}

	tempvar size
	tempname n_cases min max mean

	qui bysort `touse' `caseid' (`altvar'): gen double `size' ///
		= _N if _n == 1 & `touse'

	su `size', meanonly

	scalar `n_cases' = r(N)
	scalar `min'     = r(min)
	scalar `max'     = r(max)
	scalar `mean'    = r(mean)

	local didmsg 0

	if (`min' == 1 & `max' == 1) {

		ErrorAllChoiceSetsSizeOne, `force'

		local didmsg 1
	}

	// Error or warning: Repeated nonmissing alternatives in a choice set.

	if (!`didmsg') {

		cap bysort `touse' `caseid' (`altvar'): assert ///
			`altvar' != `altvar'[_n - 1] if _n > 1 & `touse'
		if (c(rc)) {

			if (c(rc) == 1) {
				error 1
			}

			if ("`force'" == "") {

di as error "{p}at least one choice set has more than one instance of the " ///
	    "same alternative{p_end}"

				exit 459
			}

di as text "{p 0 6 2}note: at least one choice set has more than one " ///
	   "instance of the same alternative{p_end}"

			local didmsg 1
		}
	}

	// Warnings.

	if (!`didmsg') {

		if (`min' != `max') {

di as text "{p 0 6 2}note: alternatives are unbalanced across choice sets; " ///
	   "choice sets of different sizes found{p_end}"

		}
		else {
			tempname mtouse obs

			qui gen byte `mtouse' = -`touse'

			qui bysort `mtouse' `caseid' (`altvar'): gen double ///
				`obs' = _n if `touse'

			cap assert `altvar' == `altvar'[`obs'] if `touse'
			if (c(rc)) {

				if (c(rc) == 1) {
					error 1
				}

di as text "{p 0 6 2}note: alternatives are unbalanced across choice sets; " ///
	   "at least one choice set does not have all possible values of "   ///
	   "{bf:`altvar'}{p_end}"

			}
		}
	}

	// Leave data sorted by `caseid' `altvar'.
	
	sort `caseid' `altvar'

	cap confirm numeric variable `altvar'
	if (!c(rc)) {
		su `altvar', meanonly

		return scalar altvar_max = r(max)
		return scalar altvar_min = r(min)
	}

	return scalar n_alt_max = `max'
	return scalar n_alt_avg = `mean'
	return scalar n_alt_min = `min'
	return scalar n_cases   = `n_cases'

	return local altvar `altvar'
	return local caseid `caseid'

	return hidden local replay `altwise' `force'	
end

program GenCaseidNoAlt
	syntax varlist(min=2 max=2 numeric)
	gettoken panelvar timevar : varlist

	tempvar ptvar

	qui egen double `ptvar' = group(`panelvar' `timevar')
	qui compress `ptvar'

	lab var `ptvar' "Case identifier (from `panelvar' `timevar')"

	cap drop _caseid
	rename `ptvar' _caseid

di as text "{p 0 6 2}panel data: panels {bf:`panelvar'} and " ///
	   " time {bf:`timevar'}{p_end}"

di as text "{p 0 6 2}note: case identifier {bf:_caseid} generated from " ///
	   "{bf:`panelvar'} {bf:`timevar'}{p_end}"
end

program SetCaseidTimeNoAlt, rclass
	syntax varlist(min=3 max=3 numeric) [, FORCE ]  // need comma
	gettoken caseid       varlist : varlist
	gettoken origpanelvar timevar : varlist

	tempvar touse

	SetCaseidNoAlt `caseid', touse(`touse')

	tempname n_cases n_alt_min n_alt_avg n_alt_max

	scalar `n_cases'   = r(n_cases)
	scalar `n_alt_min' = r(n_alt_min)
	scalar `n_alt_avg' = r(n_alt_avg)
	scalar `n_alt_max' = r(n_alt_max)

	// Compute r(tdelta), r(tmin), r(tmax), r(gaps) like tsset computes.

	tempvar distinct tvar tdiff
	qui bysort `timevar' (`touse'): gen byte `distinct' ///
			= (_n == _N) if `touse'
	qui gen `:type `timevar'' `tvar' = `timevar' if `distinct' == 1

	sort `tvar'
	qui gen `:type `tvar'' `tdiff' = `tvar' - `tvar'[_n - 1]

	tempname tdelta tmin tmax gaps

	su `tdiff', meanonly
	scalar `tdelta' = r(min)
	local has_gaps = (r(max) != r(min))

	su `tvar', meanonly
	scalar `tmin' = r(min)
	scalar `tmax' = r(max)

	if (`has_gaps') {
		qui count if `tdiff' != `tdelta' & `tdiff' != .
		return hidden scalar n_gaps = r(N)
	}
	else {
		return hidden scalar n_gaps = 0
	}
	
	// Leave data sorted by `caseid'.
	
	sort `caseid'

	return scalar gaps      = `has_gaps'
	return scalar tmax      = `tmax'
	return scalar tmin      = `tmin'
	return scalar tdelta    = `tdelta'
	return scalar n_alt_max = `n_alt_max'
	return scalar n_alt_avg = `n_alt_avg'
	return scalar n_alt_min = `n_alt_min'
	return scalar n_cases   = `n_cases'

	return local origpanelvar `origpanelvar'
	return local timevar      `timevar'
	return local caseid       `caseid'
end

program GenCaseidAndPanelvar
	syntax varlist(min=3 max=3)

	gettoken origpanelvar varlist : varlist
	gettoken timevar      altvar  : varlist

	marksample touse, strok

	tempvar ptvar pavar

	qui egen double `ptvar' = group(`origpanelvar' `timevar') if `touse'
	qui compress `ptvar'

	qui egen double `pavar' = group(`origpanelvar' `altvar') if `touse'
	qui compress `pavar'

lab var `ptvar' "Case identifier (from `origpanelvar' `timevar')"
lab var `pavar' "Panel by alternatives identifier (from `origpanelvar' `altvar')"

	cap drop _caseid
	cap drop _panelaltid
	rename `ptvar' _caseid
	rename `pavar' _panelaltid

di as text "{p 0 6 2}panel data: panels {bf:`origpanelvar'} and " ///
	   " time {bf:`timevar'}{p_end}"

di as text "{p 0 6 2}note: case identifier {bf:_caseid} generated from " ///
	   "{bf:`origpanelvar'} {bf:`timevar'}{p_end}"

di as text "{p 0 6 2}note: panel by alternatives identifier " ///
	   "{bf:_panelaltid} generated from {bf:`origpanelvar'} " ///
	   "{bf:`altvar'}{p_end}"
end

program SetCaseidTimeAlt, rclass
	syntax varlist(min=5 max=5) [, ALTWISE FORCE * ]  // * = options for tsset
	gettoken caseid       varlist : varlist
	gettoken panelvar     varlist : varlist
	gettoken origpanelvar varlist : varlist
	gettoken timevar      altvar  : varlist

	SetCaseidAlt `caseid' `altvar', `altwise' `force'

	tempname n_cases n_alt_min n_alt_avg n_alt_max altvar_min altvar_max

	scalar `n_cases'    = r(n_cases)
	scalar `n_alt_min'  = r(n_alt_min)
	scalar `n_alt_avg'  = r(n_alt_avg)
	scalar `n_alt_max'  = r(n_alt_max)
	scalar `altvar_min' = r(altvar_min)
	scalar `altvar_max' = r(altvar_max)

	// xtset. It does not omit obs from touse.

	if ("`isset'" == "") {  // xtset variables

		cap noi qui xtset `panelvar' `timevar', `options'
		if (c(rc)) {

			if (c(rc) == 1) {
				error 1
			}

			if (`"`options'"' != "") {
				local options `", `options'"'
			}

di as error "{p 4 4 2}Error occurred when attempting to {bf:xtset} data."
di as error "The following command gave the error:{p_end}"
di as error `"{p 4 4 2}{bf:xtset `panelvar' `timevar'`options'}{p_end}"'

			exit c(rc)
		}
	}
	else {
		cap noi qui xtset
		if (c(rc)) {

			if (c(rc) == 1) {
				error 1
			}

di as error "{p 4 4 2}Error occurred when running {bf:xtset}."

			exit c(rc)
		}
	}

	return add

	return scalar altvar_max = `altvar_max'
	return scalar altvar_min = `altvar_min'
	return scalar n_alt_max  = `n_alt_max'
	return scalar n_alt_avg  = `n_alt_avg'
	return scalar n_alt_min  = `n_alt_min'
	return scalar n_cases    = `n_cases'

	return local origpanelvar `origpanelvar'
	return local altvar       `altvar'
	return local caseid       `caseid'
end

