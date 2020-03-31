*! version 2.2.2  08nov2017
program manova, eclass byable(onecall)
	version 11
	local version : di "version " string(_caller()) ", missing :"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if _caller() < 11 {
		// the following line forces the default weight msg
		syntax [anything(equalok)] [if] [in] [aw fw] [, *]

		`version' `BY' _manova10 `0'
		exit
	}

	if replay() {
		if _by() {
			error 190
		}

		if `"`e(cmd)'"' != "manova" {
			error 301
		}

		if `"`e(version)'"' == "" {	// version 1:  _manova10
			`version' _manova10 `0'
			exit
		}
		else if `"`e(version)'"' != "2" { // Some future version ?
			di as err ///
			`"manova e(version) == `e(version)' is not supported"'
			exit 198
		}

		Replay `0'

		exit
	}

	syntax [anything(equalok)] [if] [in] [aw fw] [,	///
		noCONStant			///
		DROPEMPtycells			///
		NOMVREGstats			///
		CAtegory(passthru)		/// Old opt; not supported
		CLass(passthru)			/// Old opt; not supported
		CONTinuous(passthru)		/// Old opt; not supported
		Detail				/// Old opt; not supported
		]
		// "c." and "i." are used in the model specification so
		// that the old version 10 -category()-, -class()-, and
		// -continuous()- options are no longer allowed.

	OldOpt , `detail' `category' `class' `continuous'

	local opts `constant'

	ParseMod `anything'	// provides r(depvars) and r(anomod)
	local depvars `r(depvars)'
	local anomod `r(anomod)'

	if _by() {
		`BY' BYMANO `anomod' `if' `in' [`weight'`exp'], ///
				depvars(`depvars') `opts'
	}
	else {
		Collin_Y `depvars' `if' `in'

		if "`dropemptycells'" != "" {
			set emptycells drop	// orig is auto restored
		}
		// done quietly to suppress messages about omitted cells etc.
		qui _manova `depvars' = `anomod' ///
					`if' `in' [`weight'`exp'], `opts'

		WgtMsg
		// then replay to get the manova table
		_manova
	}

	// compute/save e(rmse), e(r2), e(F), e(p_F) -- used by -mvreg- when
	// it acts in replay mode after a -manova-
	if "`nomvregstats'" == "" {
		RMSE_etc , `opts'
	}

	local neq = e(k_eq)
	forval i = 1/`neq' {
		gettoken y depvars : depvars
		local mdflt `mdflt' predict(xb equation(`y'))
	}
	ereturn local marginsdefault `"`mdflt'"'

	ereturn local marginsnotok stdp Residuals STDDp
	ereturn hidden scalar version = 2	// before Stata 11 
						// e(version) was blank
	ereturn local cmdline `"manova `0'"'
end

program BYMANO, byable(recall)

	syntax varlist(fvanova) [if] [in] [aw fw] ///
			[, depvars(varlist numeric) DROPEMPtycells *]
        marksample touse
	markout `touse' `depvars'

	// Handle case with by group having no or insufficient observations.
	// Not an error, but must put out message
	qui count if `touse'
	if r(N) == 0 {
		di as text "no observations"
		exit	// not treated as an error when happens with by:
	}
	else if r(N) == 1 {
		di as text "insufficient observations"
		exit	// not treated as an error when happens with by:
	}

	Collin_Y `depvars' if `touse'

	if "`dropemptycells'" != "" {
		set emptycells drop	// orig is auto restored
	}
	// done quietly to suppress messages about omitted cells etc.
	capture noisily qui _manova `depvars' = `varlist' if `touse' ///
						[`weight'`exp'], `options'

	WgtMsg
	// then replay to get the manova table
	_manova
end

program Replay

	if "`e(prefix)'" != "" {
		_prefix_display, `0'
		exit
	}

	syntax [,			/// options allowed on replay
		Detail			/// Old opt; not supported
		]

	OldOpt , `detail'

	_manova  // called for replay
end

program ParseMod, rclass

	gettoken yvar 0 : 0 , parse(" /:=")  // no need for comma in list here
	if inlist(`"`yvar'"',":","=") {
		di as err "at least one dependent variable required"
		exit 198
	}
	if `"`yvar'"' == "/" {
		di as err "invalid use of /"
		exit 198
	}

	while !inlist(`"`yvar'"',":","=") {
		if `"`yvar'"' == "" || `"`yvar'"' == "," {
			di as err ///
	"equal sign required between dependent variables and terms of the model"
			exit 198
		}
		if `"`yvar'"' == "/" {
			di as err ///
		      "invalid use of /; not allowed among dependent variables"
			exit 198
		}
		local yvars `yvars' `yvar'
		
		gettoken yvar 0 : 0 , parse(" /:=,")
	}

	Chkyvars `yvars'
	local yvars `r(varlist)'

	gettoken chk : 0 , parse(" /")
	if `"`chk'"' == "/" {
		// slash cannot directly follow the depvars
		di as err "invalid use of /"
		exit 198
	}

	if `"`0'"' == "" { // no right-hand-side vars
		di as err "at least one independent variable required"
		exit 198
	}

	_anovaparse `0'

	return local anomod "`r(varlist)'"
	return local depvars "`yvars'"
end

program Chkyvars, rclass
	capture syntax varlist(numeric)
	if c(rc) == 101 {
		di in smcl as err "{p}factor variables and time-series"
		di in smcl as err "operators not allowed among the dependent"
		di in smcl as err "variables{p_end}"
		exit `c(rc)'
	}
	else if c(rc) { // let syntax produce the error message
		syntax varlist(numeric)
	}

	return local varlist "`varlist'"
end

program Collin_Y
	syntax varlist(numeric) [if] [in]
	quietly _rmcoll `varlist' `if' `in'
	if 0`r(k_omitted)'>0 {
		di as err "collinearity among the dependent variables"
		exit 506
	}
end

program OldOpt
	// The old options that are not supported below are allowed in
	// Version 10 -manova-.  They are not needed with the newer -manova-;
	// users can use "i." and "c." to tell what is categorical or
	// continuous.  We trap these options in order to provide better
	// error messages.

	syntax [, Detail CAtegory(string) CLass(string) CONTinuous(string)]

	if "`detail'`category'`class'`continuous'" == "" {
		exit	// all is well
	}

	if `"`category'"'        != "" local badopt category(`category')
	else if `"`class'"'      != "" local badopt class(`class')
	else if `"`continuous'"' != "" local badopt continuous(`continuous')
	else                           local badopt `detail'

	di as smcl as err `"option `badopt' not allowed"'

	di as smcl as err "{p 4 4 2}"
	di as smcl as err ///
		`"Option `badopt' only allowed under version control with"'
	di as smcl as err ///
		"version < 11."
	if bsubstr(`"`badopt'"',1,8)=="category" || ///
				bsubstr(`"`badopt'"',1,5)=="class" {
		di as smcl as err ///
	"Or, use the i. factor variable operator on your categorical variables."
	}
	else if bsubstr(`"`badopt'"',1,10)=="continuous" {
		di as smcl as err ///
	"Or, use the c. factor variable operator on your continuous variables."
	}
	else if `"`badopt'"'=="detail" {
		di as smcl as err ///
			"Or, use {bf:regress, coeflegend} after {bf:manova}."
	}
	di as smcl as err "{p_end}"

	exit 198
end

// compute/save e(rmse), e(r2), e(F), e(p_F) -- used by -mvreg- when
// it acts in replay mode after a -manova-
program RMSE_etc, eclass

	syntax [, noCONStant *]		// just need to know if nocons */

	tempname rcv idfe matE
	tempvar yy
	local dfe = e(df_r)
	scalar `idfe' = 1/`dfe'
	mat `matE' = e(E)
	mat `rcv' = `matE' * `idfe'

	forvalues i = 1/`e(k_eq)' {
		local dep : word `i' of `e(depvar)'
		local t : display string(sqrt(`rcv'[`i',`i']), "%9.0g")
		local rmse `rmse' `t'
		if "`constant'"=="" {
			qui summ `dep' if e(sample) [`e(wtype)'`e(wexp)']
			local t = 1 - `matE'[`i',`i'] / (r(N)-1)/r(Var)
		}
		else {
			qui gen double `yy' = `dep'*`dep' if e(sample)
			qui summ `yy' if e(sample) [`e(wtype)'`e(wexp)']
			local t = 1 - `matE'[`i',`i'] / r(sum)
			qui drop `yy'
		}
		local t : display string(`t', "%6.4f")
		local r2 `r2' `t'
 		qui test [`dep']
		local t : display string(r(F), "%9.0g")
		local F  `F' `t'
		local t : display string(fprob(r(df),r(df_r),r(F)), "%6.4f")
		local p_F `p_F' `t'
	}

	ereturn local rmse `rmse'
	ereturn local r2   `r2'
	ereturn local F    `F'
	ereturn local p_F  `p_F'
end

program WgtMsg
	// _manova called quietly and any messages saying
	// "(sum of wgt is #)" were lost.  We reproduce the message here.

	if `"`e(wtype)'"' != "aweight" {
		exit
	}

	tempvar tmp
	qui gen double `tmp' `e(wexp)' if e(sample)
	qui summ `tmp', meanonly
	di as text "(sum of wgt is " %12.4e r(sum) ")"
end
