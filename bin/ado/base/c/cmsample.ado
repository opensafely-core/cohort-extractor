*! version 1.0.0  12feb2019
program cmsample, rclass sortpreserve
	version 16

	// Note: Only does one sort: sort caseid altvar.

	syntax [varlist(default=none numeric fv ts)] [fw pw iw] [if] [in] ///
		[, 							  ///
		GENerate(string)					  ///
		CASEVars(varlist numeric fv ts)				  ///
		CHOICE(varname numeric)         			  ///
		ALTWISE							  ///
		RANKs 							  ///
		MISSing							  /// undocumented; skip markout for missing varlist and casevars
		ZEROweight						  /// undocumented; zero weights treated like nonzero weights
		SINGLEtons						  /// undocumented; do not categorize or markout choice sets of size one
		MESSAGE							  /// undocumented; no output other than warnings and errors
		MARKsample						  /// undocumented; for commands that use -cmsample- to mark sample
		noCHECK						  	  /// undocumented; for commands that use -cmsample- to mark sample
		noERROR2000					  	  /// undocumented; for commands that use -cmsample- to mark sample
		CASEVARTYPE(string)					  /// undocumented; for commands that use -cmsample- to mark sample
		TEMPCASEID(varname numeric)				  /// undocumented; for commands that use -cmsample- to mark sample
		]

	if ("`marksample'" != "" & "`generate'" == "") {

di as error "option {bf:generate()} must be specified when {bf:marksample} specified"

		exit 198
	}

	if ("`marksample'" == "") {

		if ("`check'" != "") {

di as error "option {bf:nocheck} can only be used with {bf:marksample}"

			exit 198
		}

		if ("`error2000'" != "") {

di as error "option {bf:noerror2000} can only be used with {bf:marksample}"

			exit 198
		}

		if ("`casevartype'" != "") {

di as error "option {bf:casevartype()} can only be used with {bf:marksample}"

			exit 198
		}
	}
	else { 
		local message message
	}

	if ("`ranks'" != "" & "`choice'" == "") {

di as error "option {bf:ranks} can only be specified when {bf:choice()} specified"

		exit 198
	}

	if ("`missing'" != "" & "`varlist'" == "" & "`casevars'" == "") {

di as error "{p}{it:varlist} or {bf:casevars()} must be specified when option {bf:missing} specified{p_end}"

		exit 198
	}

	// Check that `choice' is not in `varlist' or `casevars'.

	if ("`choice'" != "" & "`varlist'" != "") {

		local itisin : list choice in varlist

		if (`itisin') {

di as error "{p}{bf:choice()} variable {bf:`choice'} cannot be included in {it:varlist}{p_end}"

			exit 198
		}
	}

	if ("`choice'" != "" & "`casevars'" != "") {

		local itisin : list choice in casevars

		if (`itisin') {

di as error "{p}{bf:choice()} variable {bf:`choice'} cannot be included in {bf:casevars()}{p_end}"

			exit 198
		}
	}

	ParseGenerate `generate'
	local generate `s(generate)'

	if ("`altwise'" != "") {
		local marktype altwise
	}
	else {
		local marktype casewise
	}

	// Process -if- or -in- exclusion.

	local tmpweight `weight'
	local weight  // erase macro to avoid markout

	marksample reason, novarlist

	local weight `tmpweight'

	qui replace `reason' = !`reason'

	// Label `reason'.

	if ("`marksample'" == "") {

		if ("`generate'" != "") {

			if (substr("`generate'", 1, 2) == "__") {  // tempvar
				local labelname `generate'
			}
			else {
				local labelname _cmsample
			}
		}
		else {
			local labelname `reason'
		}

		lab var `reason' "Reason for exclusion"

		LabelReason `reason' `labelname' `: list sizeof casevars'
	}

	// Process fv and ts before sorting and after any r() in -if- handled.

	fvrevar `varlist'
	local varlist `r(varlist)'

	fvrevar `casevars'
	local casevars `r(varlist)'

	// Fill in reason variable.

	Reason_`marktype' `varlist' [`weight'`exp'] if !`reason', ///
		choice(`choice')				  ///
		casevars(`casevars')				  ///
		`ranks'						  ///
		`missing'					  ///
		`check'						  ///
		`zeroweight'					  ///
		`singletons'					  ///
		tempcaseid(`tempcaseid')			  ///
		reason(`reason')

	local caseid  `r(caseid)'
	local timevar `r(timevar)'
	local altvar  `r(altvar)'

	return local marktype `marktype'
	return local altvar   `altvar'
	return local timevar  `timevar'
	return local caseid   `caseid'

	// If nocheck, exit.

	if ("`marksample'" != "" & "`check'" != "") {
		qui replace `reason' = !`reason'
		cap drop `generate'
		rename `reason' `generate'
		exit
	}

	// Display.

	tempname R A

	if ("`message'" != "") {  // no tab display
		local qui qui
	}

	`qui' tab `reason', matrow(`R') matcell(`A')

	// If tabulations has categories that represent errors,
	// display footnote.

	cap assert !inlist(`reason', 10, 14, 15, 16)
	if (c(rc) == 9) {
		`qui' di _n as text "* indicates an error"
	}

	// Return names: N_`rname*' (# obs) and nc_`rname*' (# cases).

	local ncat 16

	local rname0  "included"
	local rname1  "ex_if_in"
	local rname2  "ex_caseid"
	local rname3  "ex_time"
	local rname4  "ex_altvar"
	local rname5  "ex_varlist"
	local rname6  "ex_wt"
	local rname7  "ex_casevar"
	local rname8  "ex_choice"
	local rname9  "ex_size_1"
	local rname10 "err_choice"
	local rname11 "ex_choice_0"
	local rname12 "ex_choice_1"
	local rname13 "ex_choice_011"
	local rname14 "err_wt_nc"
	local rname15 "err_altvar"
	local rname16 "err_casevar_nc"

	// Criterion for whether r() exists.

	local exist0  = 1
	local exist1  = 1
	local exist2  = 1
	local exist3  = ("`timevar'" != "")
	local exist4  = ("`altvar'" != "")
	local exist5  = ("`varlist'" != "")
	local exist6  = ("`weight'" != "")
	local exist7  = ("`casevars'" != "")
	local exist8  = ("`choice'" != "")
	local exist9  = 1
	local exist10 = ("`choice'" != "")
	local exist11 = ("`choice'" != "")
	local exist12 = ("`choice'" != "")
	local exist13 = ("`choice'" != "")
	local exist14 = ("`weight'" != "")
	local exist15 = ("`altvar'" != "")
	local exist16 = ("`casevars'" != "")

	local j = rowsof(`R')

	forvalues i = `ncat'(-1)0 {
		local k = `R'[`j', 1]

		if (`k' == `i') {
			return scalar N_`rname`i'' = `A'[`j', 1]
			local --j
		}
		else if (`exist`i'') {
			return scalar N_`rname`i'' = 0
		}
	}

	return scalar N = r(N)

	// Get casewise counts for the always casewise possibilities
	// (0, 9-ncat), and those (4-8) that are casewise
	// when -altwise- is not specified.

	if ("`marktype'" == "casewise") {
		local casenumlist `ncat'(-1)4 0
	}
	else {
		local casenumlist `ncat'(-1)9 0
	}

	foreach i of numlist `casenumlist' {

		CasewiseCounts `caseid' `reason' `i' `return(N_`rname`i'')'
		if (r(N) != .) {
			return scalar nc_`rname`i'' = r(N)
		}
	}

	// Issue errors and warnings.

	if ("`message'" != "") {

		ErrorChoiceNot_0_1 `choice', nc(`return(nc_err_choice)')

		ErrorAltvarRepeated, nc(`return(nc_err_altvar)')

		ErrorWeightsNotConstant, nc(`return(nc_err_wt_nc)') ///
		                         n(`return(N_err_wt_nc)')

		ErrorCasevarsNotConstant `caseid' `reason' `casevars',   ///
				 	 nc(`return(nc_err_casevar_nc)') ///
			                 n(`return(N_err_casevar_nc)')   ///
			                 `casevartype'

		WarningSizeOne, nc(`return(nc_ex_size_1)')

		WarningChoice `choice', nc0(`return(nc_ex_choice_0)')     ///
					n0(`return(N_ex_choice_0)')       ///
					nc1(`return(nc_ex_choice_1)')     ///
					n1(`return(N_ex_choice_1)')       ///
					nc011(`return(nc_ex_choice_011)') ///
					n011(`return(N_ex_choice_011)')

		if (return(N_included) == 0 & "`error2000'" == "") {
			return clear
			return scalar N = 0
			error 2000
		}
	}

	// Save `reason'.

	if ("`generate'" != "") {
		if ("`marksample'" != "") {
			qui replace `reason' = !`reason'
		}

		cap drop `generate'
		rename `reason' `generate'
	}
	else {
		lab drop `labelname'
	}
end

program ParseGenerate, sclass
	syntax [name] [, REPLACE ]

	if ("`namelist'" == "") {

		if ("`replace'" != "") {

di as error "option {bf:replace} must be specified after a {it:newvarname}"

			exit 198
		}
	}
	else if ("`replace'" == "") {
		confirm new variable `namelist'
	}

	sreturn local generate `namelist'
end

program LabelReason
	args reason labelname ncasevars

	local saycasevar = plural(`ncasevars', "casevar")

	lab def `labelname'  				    ///
		0  "observations included"           	    ///
		1  "if or in exclusion"      		    ///
		2  "caseid variable missing" 		    ///
		3  "time variable missing"   		    ///
		4  "alternatives variable missing"	    ///
		5  "varlist missing"			    ///
		6  "weight missing"			    ///
		7  "`saycasevar' missing"		    ///
		8  "choice variable missing"		    ///
		9  "choice sets of size one"                /// warning
		10 "choice variable not 0/1*"	   	    /// error
		11 "choice variable all 0"		    /// warning
		12 "choice variable all 1"	   	    /// warning
		13 "choice variable multiple 1s"	    /// warning
		14 "weight not constant within case*"	    /// error
		15 "repeated alternatives within case*"     /// error
		16 "`saycasevar' not constant within case*" /// error
		, modify

	lab val `reason' `labelname'
end

program Reason_casewise, rclass
	syntax [varlist(default=none numeric)] [fw pw iw] if	///
		[, 						///
		CHOICE(varname numeric)                     	///
		CASEVars(varlist numeric)		    	///
		RANKs 						///
		MISSing						///
		noCHECK						///
		ZEROweight					///
		SINGLEtons					///
		TEMPCASEID(varname numeric)			///
		REASON(varname numeric)				///
		]

	// 1. Create touse from -if- only.

	local tmpweight `weight'
	local weight  // erase macro to avoid markout

	marksample touse, novarlist

	// Get -cmset- variables.

	_cm

	if ("`tempcaseid'" != "") {
		local caseid `tempcaseid'
	}
	else {
		local caseid `r(caseid)'  // must exist
	}
	
	local timevar `r(timevar)'  // optional
	local altvar  `r(altvar)'   // optional; can be str

	return local altvar   `altvar'
	return local timevar  `timevar'
	return local caseid   `caseid'

	// Only needs to be sorted once.

	sort `caseid' `altvar'

	// 2. caseid missing.

	markout `touse' `caseid'
	Update `reason' 2 `touse' 0

	// 3. timevar missing.

	if ("`timevar'" != "") {
		markout `touse' `timevar'
		Update `reason' 3 `touse' 0
	}

	// 4. altvar missing.

	if ("`altvar'" != "") {
		CaseMarkOutMissing `caseid' `touse' `altvar', strok
		Update `reason' 4 `touse' 0
	}

	// 5. varlist missing.

	if ("`varlist'" != "" & "`missing'" == "") {
		marksample newtouse
		CaseMarkOut_0_1 `caseid' `touse' `newtouse'
		Update `reason' 5 `touse' 0
		drop `newtouse'
	}

	// 6. Weights missing.

	if ("`tmpweight'" != "") {
		local weight `tmpweight'
		marksample newtouse, novarlist `zeroweight'
		CaseMarkOut_0_1 `caseid' `touse' `newtouse'
		Update `reason' 6 `touse' 0
		drop `newtouse'
	}

	// 7. Casevars missing.

	if ("`casevars'" != "" & "`missing'" == "") {
		CaseMarkOutMissing `caseid' `touse' `casevars'
		Update `reason' 7 `touse' 0
	}

	// 8. Choice variable missing.

	if ("`choice'" != "") {
		CaseMarkOutMissing `caseid' `touse' `choice'
		Update `reason' 8 `touse' 0
	}

	// Exit if nocheck.

	if ("`check'" != "") {
		exit
	}

	// 9. Choice sets of size one.

	if ("`singletons'" == "") {
		ChoiceSetSize `caseid' `touse'
		Update `reason' 9 `touse' 0
	}

	// 10. Choice variable not 0/1. Error.
	// 11. Choice variable all 0.
	// 12. Choice variable all 1.
	// 13. Choice variable multiple 1s.

	if ("`choice'" != "" & "`ranks'" == "") {
		tempname flagchoice

		ChoiceVar `caseid' `touse' `choice' `flagchoice'

		Update `reason' 10 `flagchoice' 1
		Update `reason' 11 `flagchoice' 2
		Update `reason' 12 `flagchoice' 3
		Update `reason' 13 `flagchoice' 4

		qui replace `touse' = 0 if inrange(`reason', 10, 13)
	}

	// 14. Weights not constant within case.

	if ("`tmpweight'" != "") {
		tempvar wtvar
		qui gen double `wtvar' `exp' if `touse'
		VarsConstant `caseid' `touse' `wtvar'
		Update `reason' 14 `touse' 0
		drop `wtvar'
	}

	// 15. Repeated alternatives within case.

	if ("`altvar'" != "") {
		AltRepeated `caseid' `touse' `altvar'
		Update `reason' 15 `touse' 0
	}

	// 16. Casevars not constant within case.

	if ("`casevars'" != "") {
		VarsConstant `caseid' `touse' `casevars'
		Update `reason' 16 `touse' 0
	}
end

program Update
	args reason rval flag fval

	qui replace `reason' = `rval' if `reason' == 0 & `flag' == `fval'
end

program CaseMarkOutMissing
	syntax varlist(min=3) [, STROK ]
	gettoken caseid varlist : varlist
	gettoken touse  varlist : varlist

	marksample notmiss, `strok'

	CaseMarkOut_0_1 `caseid' `touse' `notmiss'
end

program CaseMarkOut_0_1
	syntax varlist(numeric min=3 max=3)
	gettoken caseid varlist : varlist
	gettoken touse  notmiss : varlist

	quietly {
		tempvar hasmiss

		bysort `caseid': gen byte `hasmiss' = ///
			(sum(`notmiss' == 0 & `touse') > 0)

		by `caseid': replace `touse' = 0 if `hasmiss'[_N] == 1
	}
end

program ChoiceSetSize
	syntax varlist(numeric min=2 max=2)
	gettoken caseid touse : varlist

	quietly {
		tempvar oneobs

		bysort `caseid': gen byte `oneobs' = (sum(`touse') == 1)

		by `caseid': replace `touse' = 0 if `oneobs'[_N] == 1
	}
end

program AltRepeated
	syntax varlist(min=3 max=3)
	gettoken caseid varlist : varlist
	gettoken touse  altvar  : varlist

	quietly {
		tempvar v rep

		gen `:type `altvar'' `v' = `altvar' if `touse'

		// Lag down values of altvar across !touse obs.

		bysort `caseid' (`altvar'): replace `v' = ///
			cond(`touse', `v', `v'[_n - 1])

		by `caseid': gen byte `rep' = ///
			(sum(`v' == `v'[_n - 1] & `touse') > 0)

		by `caseid': replace `touse' = 0 if `rep'[_N] == 1
	}
end

program VarsConstant
	syntax varlist(numeric min=3)
	gettoken caseid varlist : varlist
	gettoken touse  varlist : varlist

	foreach var of local varlist {
		Casevar `caseid' `touse' `var'
	}
end

program Casevar
	args caseid touse var

	quietly {
		tempvar v

		gen `:type `var'' `v' = `var' if `touse'

		// Lag down first touse value of var
		// then compare to other values.

		bysort `caseid': replace `v' =			  ///
				 cond(`v'[_n - 1] == . & `touse', ///
				      `v', `v'[_n - 1])

		by `caseid': replace `v' = (sum(`var' != `v'[_N] & `touse') > 0)

		// v is 1 when var is nonconstant.

		by `caseid': replace `touse' = 0 if `v'[_N] == 1
	}
end

program ChoiceVar
	args caseid touse var flag

	quietly {
		tempvar n n0

		// Not 0/1 variable.

		bysort `caseid': gen byte `flag' =  ///
			(sum(`var' != 0 & `var' != 1 & `touse') > 0)

		by `caseid': replace `flag' = `flag'[_N]

		// Count number of obs and number of obs with choicevar 0.

		by `caseid': gen double `n' = ///
			cond(sum(`touse'), sum(`touse'), .)

		by `caseid': gen double `n0' = ///
			cond(sum(`touse'), sum(`var' == 0 & `touse'), .)

		// All zero.

		by `caseid': replace `flag' = 2 ///
			if `n0'[_N] == `n'[_N] & `n'[_N] < .

		// All nonzero.

		by `caseid': replace `flag' = 3 ///
			if `n0'[_N] == 0 & `flag' != 1

		// More than one nonzero and at least one zero.

		by `caseid': replace `flag' = 4         ///
			if `n'[_N] - `n0'[_N] > 1       ///
			   & `n0'[_N] > 0 & `n'[_N] < . ///
			   & `flag' != 1
	}
end

program CasewiseCounts, rclass
	args caseid reason number value

	if ("`value'" == "") {
		exit
	}

	if (`value' == 0) {
		return scalar N = 0
		exit
	}

	quietly {
		tempvar flag

		bysort `caseid': gen byte `flag' = ///
			_n == _N & sum(`reason' == `number') > 0

		count if `flag' == 1
	}

	return add
end

program Reason_altwise, rclass
	syntax [varlist(default=none numeric)] [fw pw iw] if	///
		[, 						///
		CHOICE(varname numeric)                     	///
		CASEVars(varlist numeric)		    	///
		RANKs 						///
		MISSing						///
		noCHECK						///
		ZEROweight					///
		SINGLEtons					///
		TEMPCASEID(varname numeric)			///
		REASON(varname numeric)				///
		]

	// 1. Create touse from -if- only.

	local tmpweight `weight'
	local weight  // erase macro to avoid markout

	marksample touse, novarlist

	// Get -cmset- variables.

	_cm

	if ("`tempcaseid'" != "") {
		local caseid `tempcaseid'
	}
	else {
		local caseid `r(caseid)'  // must exist
	}

	local timevar `r(timevar)'  // optional
	local altvar  `r(altvar)'   // optional; can be str

	return local altvar   `altvar'
	return local timevar  `timevar'
	return local caseid   `caseid'

	// Only needs to be sorted once.

	sort `caseid' `altvar'

	// 2. caseid missing.

	markout `touse' `caseid'
	Update `reason' 2 `touse' 0

	// 3. timevar missing.

	if ("`timevar'" != "") {
		markout `touse' `timevar'
		Update `reason' 3 `touse' 0
	}

	// 4. altvar missing.

	if ("`altvar'" != "") {
		markout `touse' `altvar', strok
		Update `reason' 4 `touse' 0
	}

	// 5. varlist missing.

	if ("`varlist'" != "" & "`missing'" == "") {
		markout `touse' `varlist'
		Update `reason' 5 `touse' 0
	}

	// 6. Weights missing.

	if ("`tmpweight'" != "") {
		local weight `tmpweight'
		marksample newtouse, novarlist `zeroweight'
		qui replace `touse' = 0 if `newtouse' == 0
		Update `reason' 6 `touse' 0
		drop `newtouse'
	}

	// 7. Casevars missing.

	if ("`casevars'" != "" & "`missing'" == "") {
		markout `touse' `casevars'
		Update `reason' 7 `touse' 0
	}

	// 8. Choice variable missing.

	if ("`choice'" != "") {
		markout `touse' `choice'
		Update `reason' 8 `touse' 0
	}

	// Exit if nocheck.

	if ("`check'" != "") {
		exit
	}

	// 9. Choice sets of size one.

	if ("`singletons'" == "") {
		ChoiceSetSize `caseid' `touse'
		Update `reason' 9 `touse' 0
	}

	// 10. Choice variable not 0/1. Error.
	// 11. Choice variable all 0.
	// 12. Choice variable all 1.
	// 13. Choice variable multiple 1s.

	if ("`choice'" != "" & "`ranks'" == "") {
		tempname flagchoice

		ChoiceVar `caseid' `touse' `choice' `flagchoice'

		Update `reason' 10 `flagchoice' 1
		Update `reason' 11 `flagchoice' 2
		Update `reason' 12 `flagchoice' 3
		Update `reason' 13 `flagchoice' 4

		qui replace `touse' = 0 if inrange(`reason', 10, 13)
	}

	// 14. Weights not constant within case.

	if ("`tmpweight'" != "") {
		tempvar wtvar
		qui gen double `wtvar' `exp' if `touse'
		VarsConstant `caseid' `touse' `wtvar'
		Update `reason' 14 `touse' 0
		drop `wtvar'
	}

	// 15. Repeated alternatives within case.

	if ("`altvar'" != "") {
		AltRepeated `caseid' `touse' `altvar'
		Update `reason' 15 `touse' 0
	}

	// 16. Casevars not constant within case.

	if ("`casevars'" != "") {
		VarsConstant `caseid' `touse' `casevars'
		Update `reason' 16 `touse' 0
	}
end

program ErrorAltvarRepeated
	syntax [, nc(string) ]

	if ("`nc'" == "" | "`nc'" == "0") {
		exit
	}

// -asclogit- message:
//
// variable myalt has replicate levels for one or more cases;
// this is not allowed
//
// -cmset- message:
//
// at least one choice set has more than one instance of the same alternative

di as error "repeated alternatives found"
di as error "{p 4 4 2}`nc' " plural(`nc', "case has", "cases have") ///
            " more than one instance of the same alternative.{p_end}"

	exit 459
end

program ErrorChoiceNot_0_1
	syntax [varname (default=none)] [, nc(string) ]

	if ("`nc'" == "" | "`nc'" == "0") {
		exit
	}

// asclogit message:
//
// depvar yy must be a 0/1 variable indicating which alternatives are chosen

di as error "{p}choice variable {bf:`varlist'} must be a 0/1 variable{p_end}"
di as error "{p 4 4 2}`nc' " plural(`nc', "case has", "cases have") ///
	    " values of {bf:`varlist'} that are not 0/1.{p_end}"

	exit 459
end

program ErrorWeightsNotConstant
	syntax [, nc(string) n(string) ]

	if ("`nc'" == "" | "`nc'" == "0") {
		exit
	}

di as error "weights must be constant within case"
di as error "{p 4 4 2}Weights are not constant within case for `nc' " ///
            plural(`nc', "case") " (`n' obs).{p_end}"

	exit 407
end

program ErrorCasevarsNotConstant
	syntax varlist(min=2) ///
		[,	      ///
		nc(string)	    ///
		n(string)	    ///
		OVER		    ///
		WITHIN		    ///
		SUBPOP		    ///
		SVY		    ///
		]

	opts_exclusive "`over' `within' `subpop' `svy'" casevartype

	if ("`nc'" == "" | "`nc'" == "0") {
		exit
	}

	gettoken caseid varlist : varlist
	gettoken reason varlist : varlist

	if (`:list sizeof varlist' == 1 | "`subpop'" != "" | "`svy'" != "") {

		SayCasevarNotConstant `varlist' ///
			"`over'`within'`subpop'`svy'" `nc' `n'
	}

	tempvar newtouse

	local oldtouse (!inrange(`reason', 1, 15))

	qui gen byte `newtouse' = `oldtouse'

	fvrevar `varlist'
	local varlist `r(varlist)'

	foreach var of local varlist {

		Casevar `caseid' `newtouse' `var'

		cap assert `newtouse' == `oldtouse'
		if (c(rc)) {

			if (c(rc) == 1) {
				exit 1
			}

			qui count if `newtouse' == `oldtouse'
			local n `r(N)'

			tempvar flag

			qui bysort `caseid': gen byte `flag' = ///
				_n == _N & sum(`newtouse' != `oldtouse') > 0

			qui count if `flag' == 1
			local nc `r(N)'

			SayCasevarNotConstant `var' "`over'`within'" ///
				`nc' `n'
	    	}
	}
end

program SayCasevarNotConstant
	args var casevartype nc n

	local name `: char `var'[fvrevar]' ///
		   `: char `var'[tsrevar]'

	if ("`name'" == "") {
		local name `var'
	}

	if ("`casevartype'" == "") {

di as error "casevar not constant within case"
di as error "{p 4 4 2}Casevar {bf:`name'} is not constant within case for " ///
	    "`nc' " plural(`nc', "case") " (`n' obs).{p_end}"
	}
	else if ("`casevartype'" == "subpop") {

di as error "cases not nested within {bf:subpop()}"
di as error "{p 4 4 2}{bf:subpop()} differs within case for " ///
	    "`nc' " plural(`nc', "case") " (`n' obs).{p_end}"
	}
	else if ("`casevartype'" == "svy") {

di as error "cases not nested within {bf:svy} design variables"
di as error "{p 4 4 2}{bf:svy} design differs within case for " ///
	    "`nc' " plural(`nc', "case") " (`n' obs).{p_end}"
	}
	else { // over() or within()

di as error "cases not nested within {bf:`casevartype'()}"
di as error "{p 4 4 2}{bf:`name'} in {bf:`casevartype'()} differs within case for " ///
	    "`nc' " plural(`nc', "case") " (`n' obs).{p_end}"
	}

	exit 459
end

program WarningSizeOne
	syntax [, nc(string) ]

	if ("`nc'" == "" | "`nc'" == "0") {
		exit
	}

// asclogit message:
//
// note: 303 cases dropped because they have only one alternative
//
// _cm message:
//
// note: 303 cases ignored because they have only one alternative.

di as text "{p 0 6 2}note: `nc' " plural(`nc', "case") " dropped because " ///
	   plural(`nc', "it has", "they have") " only one alternative{p_end}"

end

program WarningChoice
	syntax [varname (default=none)] [,               ///
					   nc0(string)   ///
					   n0(string)    ///
					   nc1(string)   ///
					   n1(string)    ///
					   nc011(string) ///
					   n011(string)  ///
					]

	if ("`nc0'" == "") {
		exit
	}

	if (`nc0' > 0) {

di as text "{p 0 6 2}note: `nc0' " plural(`nc0', "case")               ///
	   " (`n0' obs) dropped due to {bf:`varlist'} having no positive " ///
	   "outcome per case{p_end}"

	}

	if (`nc1' > 0) {

di as text "{p 0 6 2}note: `nc1' " plural(`nc1', "case")                ///
	   " (`n1' obs) dropped due to {bf:`varlist'} having all positive " ///
	   "outcomes per case{p_end}"

	}

	if (`nc011' > 0) {

di as text "{p 0 6 2}note: `nc011' " plural(`nc011', "case")                ///
	   " (`n011' obs) dropped due to {bf:`varlist'} having multiple " ///
	   "positive outcomes per case{p_end}"

	}
end

exit

   Reason  Explanation

	0  "observations included"           	    ///
	1  "if or in exclusion"      		    ///
	2  "caseid variable missing" 		    ///
	3  "time variable missing"   		    ///
	4  "alternatives variable missing"	    ///
	5  "varlist missing"			    ///
	6  "weight missing"			    ///
	7  "casevar missing"		            ///
	8  "choice variable missing"		    ///
	                                            <-- exits here if nocheck
	9  "choice sets of size one"                /// warning
	10 "choice variable not 0/1*"	   	    /// error
	11 "choice variable all 0"		    /// warning
	12 "choice variable all 1"	   	    /// warning
	13 "choice variable multiple 1s"	    /// warning
	14 "weight not constant within case*"	    /// error
	15 "repeated alternatives within case*"     /// error
	16 "casevar not constant within case*" 	    /// error

Undocumented options:

	MISSing

		Treat missing values of varlist and casevars like any other
		value.

	ZEROweight

		Zero weights not treated as missing. Treated like any nonzero
		value.

	SINGLEtons

		Ignore choice sets of size one. Do not add category to reason.
		Do not markout when doing -marksample-.

	MESSAGE

		Issue warnings and errors, but no other output. When option
		-marksample- is specified, it does the same thing. This 
		option is used when not doing a markout.

	MARKsample

		Generate a 0/1 touse variable instead of a reason variable.

	The following options can only be specified when -marksample-
	specified:

	noCHECK

		Do not perform any checks. Do not give any warnings or errors.
		See reason table above to see where exit occurs.

	noERROR2000

		Do not issue error 2000 "no observations".

	CASEVARTYPE([ "subpop" | "svy" | string ])

		This string is used to produce a custom wording of the error
		message when casevars are not constant within case.

END

