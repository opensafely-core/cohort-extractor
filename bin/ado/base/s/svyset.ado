*! version 3.6.1  21oct2019
program svyset
	if _caller() < 9 {
		svyset_8 `0'
		exit
	}

	capture Display
	if !c(rc) {
		local oldset `"`r(settings)'"'
	}
	capture noisily SvySet `0'
	if c(rc) {
		local rc = c(rc)
		capture SvySet `oldset'
		exit `rc'
	}
end

program SvySet
	version 9
	// -eclass- is undocumented
	capture syntax [, ECLASS CLEAR MI]
	if !c(rc) {
		if "`mi'" == "" {
			u_mi_not_mi_set svyset
		}
		if "`clear'" != "" {
			Clear
			Get
		}
		else	Display, `eclass'
		exit
	}
	if _N == 0 {
		di as err "no variables defined"
		exit 111
	}

	local commopts	VCE(passthru) MSE	///
			BRRweight(passthru)	///
			FAY(passthru)		///
			BSRweight(passthru)	///
			BSN(passthru)		///
			JKRweight(passthru)	///
			SDRweight(passthru)	///
			SINGLEunit(passthru)	///
			DOF(passthru)		///
			POSTstrata(passthru)	///
			POSTWeight(passthru)	///
			RAKE(passthru)		///
			REGress(passthru)	///
			CLEAR1(passthru)	///
			CLEAR NOCLEAR		///
			MI
	_parse expand stage global : 0, common(`commopts')

	// [if] and [in] are not allowed
	if `"`global_if'`global_in'"' != "" {
		local 0 `"`global_if' `global_in'"'
		syntax [, NOOPTIONS ]
	}

	if `"`global_op'"' != "" {
		ParseGlobals `stage_n' , `global_op'
		if "`s(noclear)'" != "" & `stage_n' {
			local 0 `"`stage_1'"'
			capture syntax [pw iw/]
			if c(rc) {
				di as err ///
"option {bf:noclear} is not allowed with {help svyset##design_options:design_options}"
				exit 198
			}
			_svyset set `weight' `exp'
			local stage_n 0
		}
		local noclear `s(noclear)'
		local mi `s(mi)'
	}
	else {
		u_mi_not_mi_set svyset
		Clear
	}

	local wgt_n 0
	local ignore 0
	forval i = 1/`stage_n' {
		ParseStage "`mi'" `i' `stage_n' `stage_`i''
		_svyset get fpc `i'
		if "`r(fpc`i')'" == "" & `stage_n' > `i' {
			di as txt "{p 0 6 2}" ///
"Note: Stage `i' is sampled with replacement;" ///
" further stages will be ignored for variance estimation.{p_end}"
			local stage_n `i'
			local ignore 1
		}
		_svyset get weight `i'
		if "`r(weight`i')'" != "" {
			local wgt_n = `i'
		}
	}
	if "`noclear'" == "" & `"`:char _dta[_svy_su1]'"' != "" {
		if `stage_n' == 0 {
			local stage_n 1
		}
		char _dta[_svy_stages] `stage_n'
	}
	if `wgt_n' {
		char _dta[_svy_stages_wt] `wgt_n'
	}
	if `stage_n' | `"`global_op'"' != "" {
		char _dta[_svy_version] 2
	}

	Display
end

program ParseGlobals, sclass
	gettoken stage_n 0 : 0, parse(" ,")
	if `stage_n' == 0 {
		// These are undocumented options that were allowed in a
		// single stage -svyset- in Stata 8.

		local oldopts PSU(passthru) STRata(passthru) FPC(passthru) SRS
	}
	syntax [,				///
		VCE(string)			///
		MSE				///
		BRRweight(varlist numeric)	///
		FAY(numlist max=1 >=0 <=2)	///
		BSRweight(varlist numeric)	///
		BSN(numlist int max=1 >0)	///
		JKRweight(string asis)		///
		SDRweight(string asis)		///
		DOF(numlist max=1 >0)		///
		POSTstrata(varname)		///
		POSTWeight(varname numeric)	///
		SINGLEunit(name)		///
		RAKE(string)			///
		REGress(string)			///
		NOCLEAR				///
		CLEAR				///
		CLEAR1(namelist)		///
		MI				///
		`oldopts'			///
	]

	if `"`poststrata'`postweight'"' != "" {
		if "`postweight'" == "" {
			di as err ///
"option {bf:poststrata()} requires option {bf:postweight()}"
			exit 198
		}
		if "`poststrata'" == "" {
			di as err ///
"option {bf:postweight()} requires option {bf:poststrata()}"
			exit 198
		}
		if `"`rake'"' != "" {
			opts_exclusive "poststrata() rake()"
		}
		if `"`regress'"' != "" {
			opts_exclusive "poststrata() regress()"
		}
	}
	else if `"`rake'"' != "" {
		if `"`regress'"' != "" {
			opts_exclusive "rake() regress()"
		}
	}

	if "`mi'" == "" {
		u_mi_not_mi_set svyset
		local micheck "*"
	}
	else	local micheck "u_mi_check_setvars settime svyset"

	// NOTE: the -clear- option is accepted here, but it is ignored since
	// it is the default unless -noclear- or -clear()- are specified

	// initialize s(noclear)
	sreturn local noclear
	sreturn local mi `mi'
	if "`noclear'" == "" & "`clear1'" == "" {
		Clear
	}
	else {
		if "`clear'" != "" {
			if "`clear1'" != "" {
				opts_exclusive "clear clear()"
			}
			if "`noclear'" != "" {
				opts_exclusive "clear noclear"
			}
		}
		Clear, `clear1' noclear
		if `stage_n' > 1 | `"`psu'`strata'`fpc'`srs'"' != "" {
			di as err ///
"option {bf:noclear} is not allowed with {help svyset##design_options:design_options}"
			exit 198
		}
		local noclear noclear
	}

	if `"`vce'`mse'"' != "" {
		_svyset set vce `vce', `mse'
		local defpsu _n
	}
	if `"`brrweight'"' != "" {
		`micheck' `brrweight'
		_svyset set brrweight `brrweight'
	}
	if `"`fay'"' != "" {
		_svyset set fay `fay'
	}
	if `"`bsrweight'"' != "" {
		`micheck' `bsrweight'
		_svyset set bsrweight `bsrweight'
	}
	if `"`bsn'"' != "" {
		_svyset set bsn `bsn'
	}
	if `"`jkrweight'"' != "" {
		`micheck' `jkrweight'
		JKnifeVChars `jkrweight'
		_svyset set jkrweight `s(varlist)'
	}
	if `"`sdrweight'"' != "" {
		`micheck' `sdrweight'
		sdrChars `sdrweight'
		_svyset set sdrweight `s(varlist)'
		_svyset set sdrfpc `s(fpc)'
	}
	if `"`dof'"' != "" {
		_svyset set dof `dof'
	}
	if `"`poststrata'`postweight'"' != "" {
		`micheck' `poststrata' `postweight'
		_svyset set poststrata `poststrata'
		_svyset set postweight `postweight'
		local defpsu _n
	}
	if `"`rake'"' != "" {
		capture	///
		ParseCal rake `rake'
		if c(rc) {
			di as err "option {bf:rake()} invalid;"
			ParseCal rake `rake'
			exit 198	// [sic]
		}
		`micheck' `s(varlist)'
	}
	if `"`regress'"' != "" {
		capture ///
		ParseCal regress `regress'
		if c(rc) {
			di as err "option {bf:regress()} invalid;"
			ParseCal regress `regress'
			exit 198	// [sic]
		}
		`micheck' `s(varlist)'
	}
	if `"`singleunit'"' != "" {
		capture _svyset set singleunit `singleunit'
		if c(rc) {
			di as err "option {bf:singleunit()} invalid"
			exit 198
		}
	}
	if `stage_n' == 0 & "`noclear'" == "" {
		if "`srs'" != "" {
			if "`strata'" != "" {
				opts_exclusive "strata() srs"
			}
			if "`psu'" != "" {
				opts_exclusive "psu() srs"
			}
			local mypsu _n
		}
		else if "`psu'" == "" {
			local mypsu `defpsu'
		}
		if "`mypsu'`psu'`strata'`fpc'" != "" {
			ParseStage "`mi'" 1 1 `mypsu', `psu' `strata' `fpc'
		}
	}
	sreturn local noclear `noclear'
end

program RWerror
	args rwtype wtype wvar
	di as err "{p 0 0 2}"
	di as err ///
"invalid {bf:`rwtype'()} option;{break}"
	di as err ///
"the {bf:`rwtype'()} varlist may not contain {bf:`wtype'} variable {bf:`wvar'}"
	di as err "{p_end}"
	exit 198
end

program ParseCal, sclass
	svycal parse `0'
	local method	`"`s(method)'"'
	local model	`"`s(model)'"'
	local options	`"`s(options)'"'
	fvrevar `model', list
	local varlist	`"`r(varlist)'"'
	_svyset set calmethod	`method'
	_svyset set calmodel	`model'
	_svyset set calopts	`options'
	sreturn clear
	sreturn local varlist	`"`varlist'"'
	sreturn local method	`"`method'"'
	sreturn local model	`"`model'"'
	sreturn local options	`"`options'"'
end

program ParseStage, rclass
	gettoken mi	0 : 0
	gettoken i	0 : 0
	gettoken last	0 : 0
	if "`mi'" == "" {
		local micheck "*"
	}
	else	local micheck "u_mi_check_setvars settime svyset"
	if `i' == 1 {
		local uspec `"[anything(name=su id="psuid")]"'
		local oldopts PSU(varname)
	}
	else {
		local uspec `"anything(name=su id="ssuid")"'
	}
	syntax `uspec' [pweight iweight/] [,		///
		STRata(varname)				///
		FPC(varname numeric)			///
		Weight`i'(varname numeric)		///
		`oldopts'				///
	]
	if "`psu'" != "" {
		if "`su'" != "" & "`su'" != "`psu'" {
			di as err "option {bf:psu()} invalid"
			exit 198
		}
		else	local su `psu'
	}
	else if "`su'" == "" {
		if "`weight`i''`weight'`strata'`fpc'" == "" {
			di as err "psuid required"
			exit 198
		}
		local su _n
	}
	if `"`su'"' == "_n" & `i' < `last' {
		di as err "invalid use of _n; " ///
"observations can only be sampled in the final stage"
		exit 198
	}
	// else `su' was given
	local wtype	`weight'
	local wvar	`"`exp'"'
	if `"`wtype'"' != "" {
		_svyset get wvar
		if `"`r(wvar)'"' != "" {
			di as err "sampling weights may only be specified once"
			exit 198
		}
		`micheck' `wvar'
		_svyset set `wtype' `wvar'
		_svyset get brr
		local RW `"`r(brrweight)'"'
		if `:list wvar in RW' {
			RWerror brrweight `wtype' `wvar'
		}
		_svyset get bsr
		local RW `"`r(bsrweight)'"'
		if `:list wvar in RW' {
			RWerror bsrweight `wtype' `wvar'
		}
		_svyset get jkr
		local RW `"`r(jkrweight)'"'
		if `:list wvar in RW' {
			RWerror jkrweight `wtype' `wvar'
		}
		_svyset get sdr
		local RW `"`r(sdrweight)'"'
		if `:list wvar in RW' {
			RWerror sdrweight `wtype' `wvar'
		}
	}
	if !inlist("`su'", "", "_n") {
		capture confirm variable `su'
		if c(rc) {
			local psu = cond(`i' == 1, "psu", "ssu")
			di as err `"{bf:`su'} invalid `psu' variable name"'
			exit c(rc)
		}
	}
	if `"`su'"' != "_n" {
		`micheck' `su'
	}
	_svyset set su `i' `su'
	if "`strata'" != "" {
		`micheck' `strata'
		_svyset set strata `i' `strata'
	}
	else	_svyset clear strata `i'
	if "`fpc'" != "" {
		`micheck' `fpc'
		_svyset set fpc `i' `fpc'
	}
	else	_svyset clear fpc `i'
	if "`weight`i''" != "" {
		`micheck' `weight`i''
		_svyset set weight `i' `weight`i''
	}
	else	_svyset clear weight `i'
end

program Clear
	syntax [, noCLEAR	///
		PWeight		///
		IWeight		///
		Weight		///
		vce		///
		mse		///
		BRRweight	///
		FAY		///
		BSRweight	///
		BSN		///
		JKRweight	///
		SDRweight	///
		DOF		///
		POSTstrata	///
		POSTweight	///
		RAKE		///
		REGress		///
		SINGLEunit	///
	]

	// clear the current settings
	if "`clear'" == "" {
		quietly svyset_8, clear
		_svyset clear wtype
		_svyset clear vce
		_svyset clear brrweight
		_svyset clear fay
		_svyset clear bsrweight
		_svyset clear bsn
		_svyset clear jkrweight
		_svyset clear sdrweight
		_svyset clear dof
		_svyset clear poststrata
		_svyset clear calmethod
		_svyset clear singleunit
		_svyset clear stages 1
		_svyset clear stages_wt 1
		char _dta[_svy_version]
		exit
	}
	if "`pweight'`iweight'`weight'" != "" {
		_svyset clear wtype
	}
	if "`vce'" != "" {
		_svyset clear vce
	}
	if "`mse'" != "" {
		_svyset clear mse
	}
	if "`brrweight'" != "" {
		_svyset clear brrweight
	}
	if "`fay'" != "" {
		_svyset clear fay
	}
	if "`bsrweight'" != "" {
		_svyset clear bsrweight
	}
	if "`bsn'" != "" {
		_svyset clear bsn
	}
	if "`jkrweight'" != "" {
		_svyset clear jkrweight
	}
	if "`sdrweight'" != "" {
		_svyset clear sdrweight
	}
	if "`dof'" != "" {
		_svyset clear dof
	}
	if "`poststrata'`postweight'" != "" {
		_svyset clear poststrata
	}
	if "`rake'`regress'" != "" {
		_svyset clear calmethod
	}
	if "`singleunit'" != "" {
		_svyset clear singleunit
	}
end

/*
	returns in r():
	Scalars:
		r(stages)	number of sampling stages	or missing
	Macros:
		r(wtype)	"pweight" or "iweight"		or ""
		r(wexp)		"= <varname>"			or ""
		r(vce)		vcetype				or ""
		r(mse)		"mse"				or ""
		r(brrweight)	varlist				or ""
		r(fay)		#				or ""
		r(bsrweight)	varlist				or ""
		r(bsn)		#				or ""
		r(jkrweight)	varlist				or ""
		r(sdrweight)	varlist				or ""
		r(sdrfpc)	#				or ""
		r(dof)		#				or ""
		r(poststrata)	poststrata varname		or ""
		r(postweight)	postweight varname		or ""
		r(rake)		rake() arguments		or ""
		r(regress)	regress() arguments		or ""
		r(su#)		stage # ssu varname		or ""
		r(strata#)	stage # strata varname		or ""
		r(fpc#)		stage # fpc varname		or ""
		r(weight#)	stage # weight varname		or ""
		r(settings)	svyset args to reproduce current settings
*/
program Get, rclass
	syntax [, eclass]
	if "`eclass'" != "" {
		if "`e(prefix)'" != "svy" {
			di as err "svy estimation results not found"
			exit 301
		}
		GetEclass
		return add
		exit
	}
	local version : char _dta[_svy_version]
	capture confirm integer number `version'
	if c(rc) {
		GetOld
		return add
		exit
	}
	local is_set 0
	// get the global options
	_svyset get wvar
	if `"`r(wvar)'"' != "" {
		local wt `"[`r(wtype)'`r(wexp)']"'
		return add
		local is_set 1
	}
	_svyset get brr
	if "`r(brrweight)'" != "" {
		local gsets `"`gsets' brrweight(`r(brrweight)')"'
		return add
		local is_set 1
	}
	_svyset get fay
	if !inlist("`r(fay)'", "", "0") {
		local gsets `"`gsets' fay(`r(fay)')"'
		return add
		local is_set 1
	}
	_svyset get bsr
	if "`r(bsrweight)'" != "" {
		local gsets `"`gsets' bsrweight(`r(bsrweight)')"'
		return add
		local is_set 1
	}
	_svyset get bsn
	if !inlist("`r(bsn)'", "", "1") {
		local gsets `"`gsets' bsn(`r(bsn)')"'
		return add
		local is_set 1
	}
	_svyset get jkr
	if "`r(jkrweight)'" != "" {
		local gsets `"`gsets' jkrweight(`r(jkrweight)')"'
		return add
		local is_set 1
	}
	_svyset get sdr
	if "`r(sdrweight)'" != "" {
		local sdrw "`r(sdrweight)'"
		if "`r(sdrfpc)'" != "" {
			local fpc ", fpc(`r(sdrfpc)')"
		}
		local gsets `"`gsets' sdrweight(`sdrw'`fpc')"'
		return add
		local is_set 1
	}
	_svyset get dof
	if "`r(dof)'" != "" {
		local gsets `"`gsets' dof(`r(dof)')"'
		return add
		local is_set 1
	}
	_svyset get posts
	if `"`r(poststrata)'`r(postweight)'"' != "" {
		local gsets `"`gsets' poststrata(`r(poststrata)')"'
		local gsets `"`gsets' postweight(`r(postweight)')"'
		return add
		local is_set 1
	}
	_svyset get calmethod
	if `"`r(calmethod)'"' != "" {
		local spec `"`r(calmodel)', `r(calopts)'"'
		local gsets `"`gsets' `r(calmethod)'(`spec')"'
		return local `r(calmethod)' `"`spec'"'
		return add
		local is_set 1
	}
	_svyset get singleunit
	if `"`r(singleunit)'"' != "" {
		local gsets `"`gsets' singleunit(`r(singleunit)')"'
		return add
		local is_set 1
	}
	else	local gsets `"`gsets' singleunit(missing)"'
	_svyset get vce
	if `"`r(vce)'"' != "" {
		local gsets `"`gsets' vce(`r(vce)')"'
		if "`r(mse)'" != "" {
			local gsets `"`gsets' mse"'
		}
		return add
		local is_set 1
	}
	else {
		local gsets `"`gsets' vce(linearized)"'
		return local vce linearized
	}

	// get the stage specific settings
	local stages : char _dta[_svy_stages]
	capture confirm integer number `stages'
	if c(rc) {
		local stages 0
	}
	else	local is_set 1
	local stages_wt : char _dta[_svy_stages_wt]
	capture confirm integer number `stages_wt'
	if c(rc) {
		local stages_wt 0
	}
	if `stages_wt' {
		if "`return(wtype)'" != "" {
			di as err "invalid weight specification;"
			di as err ///
"`return(wtype)'s not allowed with stage-level {bf:weight()} options"
			exit 198
		}
		if "`return(brrweight)'" != "" {
			di as err "invalid weight specification;"
			di as err ///
"option {bf:brrweight()} not allowed with stage-level {bf:weight()} options"
			exit 198
		}
		if "`return(bsrweight)'" != "" {
			di as err "invalid weight specification;"
			di as err ///
"option {bf:bsrweight()} not allowed with stage-level {bf:weight()} options"
			exit 198
		}
		if "`return(jkrweight)'" != "" {
			di as err "invalid weight specification;"
			di as err ///
"option {bf:jkrweight()} not allowed with stage-level {bf:weight()} options"
			exit 198
		}
		if "`return(sdrweight)'" != "" {
			di as err "invalid weight specification;"
			di as err ///
"option {bf:sdrweight}() not allowed with stage-level {bf:weight()} options"
			exit 198
		}
	}
	if `stages_wt' > `stages' {
		local I = `stages_wt'
	}
	else	local I = `stages'
	local comma ","
	forval i = 1/`I' {
		local comma ","
		_svyset get su `i'
		local su `r(su`i')'
		if `"`su'"' != "" {
			local sets "`sets'`oror'`su'"
			if `"`su'"' == "_n" {
				if `i' < `stages' {
					di as err "invalid use of _n; " ///
"observations can only be sampled in the final stage"
					exit 198
				}
				local su
			}
			else	return add
		}
		else if `i' < `I' {
			di as err ///
"invalid survey characteristics;" _n ///
"sampling unit variable is not set for stage `i' of `I' stages"
			exit 459
		}
		if "`wt'" != "" {
			local sets "`sets' `wt'"
			local wt
		}
		_svyset get strata `i'
		local strata `r(strata`i')'
		if `"`strata'"' != "" {
			return add
			local sets `"`sets'`comma' strata(`strata')"'
			local comma
		}
		_svyset get weight `i'
		local weight `r(weight`i')'
		if `"`weight'"' != "" {
			local wlist `wlist' `weight'
			return add
			local sets `"`sets'`comma' weight(`weight')"'
			local comma
		}
		_svyset get fpc `i'
		local fpc `r(fpc`i')'
		if `"`fpc'"' != "" {
			return add
			local sets `"`sets'`comma' fpc(`fpc')"'
			local comma
		}
		else if `i' < `stages' {
			di as err ///
"invalid survey characteristics;" _n ///
"FPC variable is not set for stage `i' of `stages' stages"
			exit 459
		}
		local oror " || "
	}

	if `is_set' == 0 {
		return clear
		local sets ", clear"
	}
	else {
		if `"`gsets'"' != "" {
			local sets `"`sets'`comma' `:list retok gsets'"'
		}
		if `"`return(singleunit)'"' == "" {
			return local singleunit missing
		}
	}
	return local settings `"`sets'"'
	if `stages' {
		return scalar stages = `stages'
	}
	if `stages_wt' {
		return scalar stages_wt = `stages_wt'
	}
	else	return hidden scalar stages_wt = 0
	return hidden local wlist `"`wlist'"'
end

program GetEclass, rclass
	// get the global options
	if `"`e(wexp)'"' != "" {
		local wt `"[`e(wtype)'`e(wexp)']"'
		return local wtype `"`e(wtype)'"'
		return local wexp  `"`e(wexp)'"'
		local wexp `"`e(wexp)'"'
		gettoken equal wvar : wexp
		return local wvar  `"`:list retok wvar'"'
	}
	if "`e(brrweight)'" != "" {
		local gsets `"`gsets' brrweight(`e(brrweight)')"'
		return local brrweight `e(brrweight)'
	}
	if !inlist("`e(fay)'", "", "0") {
		local gsets `"`gsets' fay(`e(fay)')"'
		return scalar fay = e(fay)
	}
	if "`e(bsrweight)'" != "" {
		local gsets `"`gsets' bsrweight(`e(bsrweight)')"'
		return local bsrweight `e(bsrweight)'
	}
	if !inlist("`e(bsn)'", "", "1") {
		local gsets `"`gsets' bsn(`e(bsn)')"'
		return scalar bsn = e(bsn)
	}
	if "`e(jkrweight)'" != "" {
		local gsets `"`gsets' jkrweight(`e(jkrweight)')"'
		return local jkrweight `e(jkrweight)'
	}
	if "`e(sdrweight)'" != "" {
		local gsets `"`gsets' sdrweight(`e(sdrweight)')"'
		return local sdrweight `e(sdrweight)'
		if "`e(sdrfpc)'" != "" {
			return local sdrfpc `"`e(sdrfpc)'"'
		}
	}
	if "`e(dof)'" != "" {
		local gsets `"`gsets' dof(`e(dof)')"'
		return scalar dof = e(dof)
	}
	if `"`e(poststrata)'`e(postweight)'"' != "" {
		local gsets `"`gsets' poststrata(`e(poststrata)')"'
		local gsets `"`gsets' postweight(`e(postweight)')"'
		return local poststrata `e(poststrata)'
		return local postweight `e(postweight)'
	}
	if `"`e(singleunit)'"' != "" {
		local gsets `"`gsets' singleunit(`e(singleunit)')"'
		return local singleunit `e(singleunit)'
	}
	else {
		local gsets `"`gsets' singleunit(missing)"'
		return local singleunit missing
	}
	if `"`e(vce)'"' != "" {
		local gsets `"`gsets' vce(`e(vce)')"'
		if "`e(mse)'" != "" {
			local gsets `"`gsets' mse"'
			return local mse mse
		}
		return local vce `"`e(vce)'"'
	}

	// get the stage specific settings
	local stages = e(stages)
	capture confirm integer number `stages'
	if c(rc) {
		local stages 0
	}
	local stages_wt = e(stages_wt)
	capture confirm integer number `stages_wt'
	if c(rc) {
		local stages_wt 0
	}
	local comma ","
	if `stages_wt' > `stages' {
		local I = `stages_wt'
	}
	else	local I = `stages'
	forval i = 1/`I' {
		local comma ","
		local su `e(su`i')'
		if `"`su'"' != "" {
			return local su`i' `su'
		}
		else	local su _n
		local sets "`sets'`oror'`su'"
		if "`wt'" != "" {
			local sets "`sets' `wt'"
			local wt
		}
		local strata `e(strata`i')'
		if `"`strata'"' != "" {
			return local strata`i' `strata'
			local sets `"`sets'`comma' strata(`strata')"'
			local comma
		}
		local weight `e(weight`i')'
		if `"`weight'"' != "" {
			return local weight`i' `weight'
			local sets `"`sets'`comma' weight(`weight')"'
			local comma
		}
		local fpc `e(fpc`i')'
		if `"`fpc'"' != "" {
			return local fpc`i' `fpc'
			local sets `"`sets'`comma' fpc(`fpc')"'
			local comma
		}
		local oror " || "
	}

	if `"`gsets'"' != "" {
		local sets `"`sets'`comma' `:list retok gsets'"'
	}
	return local settings `"`sets'"'
	if `stages' {
		return scalar stages = `stages'
	}
	if `stages_wt' {
		return scalar stages_wt = `stages_wt'
	}
	else	return hidden scalar stages_wt = 0
end

program GetOld, rclass
	quietly svyset_8
	if "`r(_svy)'" != "set" {
		local sets ", clear"
	}
	else {
		local comma ","
		if "`r(psu)'" != "" {
			return local su1 `"`r(psu)'"'
			local sets `"`r(psu)'"'
		}
		else {
			local sets _n
		}
		if "`r(wtype)'" != "" {
			return local wtype `"`r(wtype)'"'
			return local wexp  `"`r(wexp)'"'
			local wexp `"`r(wexp)'"'
			gettoken equal wvar : wexp
			return local wvar  `"`:list retok wvar'"'
			local sets `"`sets' [`r(wtype)'`r(wexp)']"'
		}
		if "`r(strata)'" != "" {
			return local strata1 `"`r(strata)'"'
			local sets ///
			`"`sets'`comma' strata(`r(strata)')"'
			local comma
		}
		if "`r(fpc)'" != "" {
			return local fpc1 `"`r(fpc)'"'
			local sets ///
			`"`sets'`comma' fpc(`r(fpc)')"'
		}
		return local singleunit missing
		return scalar stages = 1
		return local vce "linearized"
		local vce "`comma' vce(linearized)"
	}
	return local settings `"`:list retok sets'`vce'"'
end

program Display
	syntax [, eclass ]
	Get, `eclass'
	if `"`r(settings)'"' == ", clear" {
		di as txt "no survey characteristics are set"
		exit
	}
	di
	// display global settings
	local c2 16
	local sfmt %13s
	if `"`r(wtype)'"' != "" {
		local wvar `"`r(wvar)'"'
		di as txt `sfmt' "`r(wtype)'" ":" _col(`c2') as res "`wvar'"
	}
	else {
		di as txt `sfmt' "pweight" ":" _col(`c2') "<none>"
	}
	if `"`r(vce)'"' != "" {
		di as txt `sfmt' "VCE" ":" _col(`c2') as res "`r(vce)'"
		if !inlist("`r(vce)'", "", "linearized") {
			if "`r(mse)'" == "" {
				local mseas as txt
				local onoff off
			}
			else {
				local mseas as res
				local onoff on
			}
			di as txt `sfmt' "MSE" ":" _col(`c2') `mseas' "`onoff'"
		}
	}
	else {
		di as txt `sfmt' "VCE" ":" _col(`c2') "linearized"
	}
	local colsets 1 `c2' `c2' 2
	if `"`r(brrweight)'"' != "" {
		FirstLast result `r(brrweight)'
		di "{p2colset `colsets'}{...}"
		di as txt "{p2col:{space 4}brrweight:}" ///
		   as res "`result'{p_end}"
		di "{p2colreset}{...}"
	}
	if `"`r(fay)'"' != "" {
		di "{p2colset `colsets'}{...}"
		di as txt "{p2col:{space 10}fay:}" ///
		   as res `r(fay)' "{p_end}"
		di "{p2colreset}{...}"
	}
	if `"`r(bsrweight)'"' != "" {
		FirstLast result `r(bsrweight)'
		di "{p2colset `colsets'}{...}"
		di as txt "{p2col:{space 4}bsrweight:}" ///
		   as res "`result'{p_end}"
		di "{p2colreset}{...}"
	}
	if `"`r(bsn)'"' != "" {
		di "{p2colset `colsets'}{...}"
		di as txt "{p2col:{space 10}bsn:}" ///
		   as res `r(bsn)' "{p_end}"
		di "{p2colreset}{...}"
	}
	if `"`r(jkrweight)'"' != "" {
		FirstLast result `r(jkrweight)'
		di "{p2colset `colsets'}{...}"
		di as txt "{p2col:{space 4}jkrweight:}" ///
		   as res "`result'{p_end}"
		di "{p2colreset}{...}"
	}
	if `"`r(sdrweight)'"' != "" {
		FirstLast result `r(sdrweight)'
		di "{p2colset `colsets'}{...}"
		di as txt "{p2col:{space 4}sdrweight:}" ///
		   as res "`result'{p_end}"
		di "{p2colreset}{...}"
	}
	if `"`r(dof)'"' != "" {
		di "{p2colset `colsets'}{...}"
		di as txt "{p2col:{space 4}Design df:}" ///
		   as res `r(dof)' "{p_end}"
		di "{p2colreset}{...}"
	}
	if `"`r(poststrata)'"' != "" {
		di as txt `sfmt' "Poststrata" ":" ///
			_col(`c2') as res "`r(poststrata)'"
	}
	if `"`r(postweight)'"' != "" {
		di as txt `sfmt' "Postweight" ":" ///
			_col(`c2') as res "`r(postweight)'"
	}
	if `"`r(calmethod)'"' != "" {
		di as txt `sfmt' "Calibration" ":" ///
			_col(`c2') as res "`r(calmethod)'"
	}
	if `"`r(singleunit)'"' != "" {
		di as txt `sfmt' "Single unit" ":" ///
			_col(`c2') as res "`r(singleunit)'"
	}
	if !missing(r(stages)) {
		local stages = r(stages)
	}
	else {
		local stages = 0
	}
	if !missing(r(stages_wt)) {
		local stages_wt = r(stages_wt)
	}
	else {
		local stages_wt = 0
	}
	if `stages_wt' > `stages' {
		local I = `stages_wt'
	}
	else {
		local I = `stages'
	}
	forval i = 1/`I' {
		if `"`r(strata`i')'"' != "" {
			di as txt `sfmt' "Strata `i'" ":" ///
				_col(`c2') as res "`r(strata`i')'"
		}
		else { // if `i' == 1 {
			di as txt `sfmt' "Strata `i'" ":" ///
				_col(`c2') "<one>"
		}
		if !inlist(`"`r(su`i')'"', "", "_n") {
			di as txt `sfmt' "SU `i'" ":" ///
				_col(`c2') as res "`r(su`i')'"
		}
		else {
			di as txt `sfmt' "SU `i'" ":" ///
				_col(`c2') "<observations>"
		}
		if `"`r(fpc`i')'"' != "" {
			di as txt `sfmt' "FPC `i'" ":" ///
				_col(`c2') as res "`r(fpc`i')'"
		}
		else {
			di as txt `sfmt' "FPC `i'" ":" ///
				_col(`c2') as txt "<zero>"
		}
		if `"`r(weight`i')'"' != "" {
			di as txt `sfmt' "Weight `i'" ":" ///
				_col(`c2') as res "`r(weight`i')'"
		}
		else if `stages_wt' {
			di as txt `sfmt' "Weight `i'" ":" ///
				_col(`c2') "<none>"
		}
	}
	di as txt "{p2colreset}{...}"
end

program FirstLast
	gettoken c_result varlist : 0
	local first : word 1 of `varlist'
	local k : list sizeof varlist
	if `k' == 1 {
		c_local `c_result' `first'
	}
	else if `k' > 2 {
		local last : word `k' of `varlist'
		c_local `c_result' `first' .. `last'
	}
	else {
		c_local `c_result' `varlist'
	}
end

program ParseOld
	quietly svyset_8 `0'
	if "`r(psu)'" == "" | "`r(srs)'" != "" {
		local uni1 _n
	}
	else	local uni1 `r(psu)'
	if "`r(wtype)'" != "" {
		local wt [`r(wtype)'`r(wexp)']
	}
	if "`r(strata)'" != "" {
		local strata strata(`strata')
	}
	if "`r(fpc)'" != "" {
		local fpc fpc(`fpc')
	}
	c_local 0 `"`psu' `wt', `strata' `fpc'"'
end

program JKnifeVChars, sclass
	capture noisily				///
	syntax [varlist(default=none)] [,	///
		STRatum(numlist integer)	///
		FPC(numlist >=0)		///
		MULTiplier(numlist >0)		///
		reset				///
	]
	local nvar  : word count `varlist'
	local nstr  : word count `stratum'
	local nfpc  : word count `fpc'
	local nmult : word count `multiplier'
	local invalid `c(rc)'
	if `nvar' == 0 & ( `nstr'`nfpc'`nmult' | "`reset'" != "") {
		jkrInvalid
	}
	if `nstr' > 1 & `nstr' != `nvar' {
		di as err "invalid number of stratum identifiers"
		if `nstr' < `nvar' {
			jkrInvalid 103
		}
		else	jkrInvalid 102
	}
	if `nfpc' > 1 & `nfpc' != `nvar' {
		di as err "invalid number of FPC values"
		if `nfpc' < `nvar' {
			jkrInvalid 103
		}
		else	jkrInvalid 102
	}
	if `nmult' > 1 & `nmult' != `nvar' {
		di as err "invalid number of jackknife multiplier values"
		if `nmult' < `nvar' {
			jkrInvalid 103
		}
		else	jkrInvalid 102
	}

	local noreset = "`reset'" == ""
	if `nstr'`nfpc'`nmult' | `"`reset'"' != "" {
		local str `"`stratum'"'
		if `nstr' > 1 {
			local strlist `"`stratum'"'
			local stratum
		}
		if `nfpc' > 1 {
			local fpclist `"`fpc'"'
		}
		local mult  `"`multiplier'"'
		if `nmult' > 1 {
			local multlist `"`multiplier'"'
			local multiplier
		}
		forval i = 1/`nvar' {
			local var : word `i' of `varlist'
			if `nstr' > 1 {
				local str : word `i' of `strlist'
			}
			if `nfpc' > 1 {
				local fpc : word `i' of `fpclist'
			}
			if `nmult' > 1 {
				local mult : word `i' of `multlist'
			}
			local char : char `var'[jk_stratum]
			if `noreset' ///
			 & !inlist(`"`char'"',"","`str'") {
				di as err "{p 0 0 2}" ///
"characteristic {bf:`var'[jk_stratum]} already exists " ///
"and is different from the value supplied to option {bf:stratum()}{p_end}"
				exit 459
			}
			else	char `var'[jk_stratum] `str'
			local char : char `var'[jk_fpc]
			if `noreset' ///
			 & !inlist(`"`char'"',"","`fpc'") {
				di as err "{p 0 0 2}" ///
"characteristic {bf:`var'[jk_fpc]} already exists " ///
"and is different from the value supplied to option {bf:fpc()}{p_end}"
				exit 459
			}
			else	char `var'[jk_fpc] `fpc'
			local char : char `var'[jk_multiplier]
			if `noreset' ///
			 & !inlist(`"`char'"',"","`mult'") {
				di as err "{p 0 0 2}" ///
"characteristic {bf:`var'[jk_multiplier]} already exists " ///
"and is different from the value supplied to option {bf:multiplier()}{p_end}"
				exit 459
			}
			else	char `var'[jk_multiplier] `mult'
		}
	}
	sreturn local varlist `"`varlist'"'
end

program jkrInvalid
	args rc
	di as err "option {bf:jkrweight()} incorrectly specified"
	if "`rc'" == "" {
		exit 198
	}
	else	exit `rc'
end

program sdrChars, sclass
	capture noisily				///
	syntax [varlist(default=none)] [, FPC(numlist max=1 >=0)]

	sreturn local varlist `"`varlist'"'
	sreturn local fpc `fpc'
end

program sdrInvalid
	args rc
	di as err "option {bf:sdrweight()} incorrectly specified"
	if "`rc'" == "" {
		exit 198
	}
	else	exit `rc'
end

exit
