*! version 2.1.3  15oct2019
program anova, eclass byable(onecall)
	version 11
	local version : di "version " string(_caller()) ", missing :"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if _caller() < 11 {
		`version' `BY' _anova10 `0'
		exit
	}

	if replay() {
		if _by() {
			error 190
		}

		if `"`e(cmd)'"' != "anova" {
			error 301
		}

		if `"`e(version)'"' == "" {	// version 1:  _anova10
			`version' _anova10 `0'
			exit
		}
		else if `"`e(version)'"' != "2" { // Some future version ?
			di as err ///
			`"anova e(version) == `e(version)' is not supported"'
			exit 198
		}

		Replay `0'

		exit
	}

	syntax [anything] [if] [in] [aw fw] [,	///
		Partial				///
		SEquential			///
		noCONStant			///
		DROPEMPtycells			///
		REPeated(varlist numeric max=4)	///
		BSE(string)			///
		BSEUNIT(varname)		///
		GROUPing(varname)		///
		CAtegory(passthru)		/// Old opt; not supported
		CLass(passthru)			/// Old opt; not supported
		CONTinuous(passthru)		/// Old opt; not supported
		Detail				/// Old opt; not supported
		NOANova				/// Old opt; not supported
		ANova				/// Old opt; not supported
		Regress				/// Old opt; not supported
		Level(passthru)			/// Old opt; not supported
		]
		// "c." and "i." are used in the model specification so
		// that the old version 10 -category()-, -class()-, and
		// -continuous()- options are no longer allowed.

	OldOpt , `detail' `anova' `noanova' `regress' `level' `category' ///
			`class' `continuous'

	opts_exclusive "`partial' `sequential'"

	local opts `partial' `sequential' `constant'
	if `"`repeated'"' != "" {
		local opts `opts' repeated(`repeated')
		if "`weight'" == "aweight" {
			di as err "aweights not allowed with option {bf:repeated()}"
			exit 406
		}
	}
	if `"`bseunit'"' != "" {
		local opts `opts' bseunit(`bseunit')
		if `"`repeated'"' == "" {
			di as err ///
			"option {bf:bseunit()} allowed only with option {bf:repeated()}"
			exit 198
		}
	}
	if `"`grouping'"' != "" {
		local opts `opts' grouping(`grouping')
		if `"`repeated'"' == "" {
			di as err ///
			"option {bf:grouping()} allowed only with option {bf:repeated()}"
			exit 198
		}
	}
	if `"`bse'"' != "" {
		local opts `opts' bse(`bse')
		if `"`repeated'"' == "" {
			di as err ///
			    "option {bf:bse()} allowed only with option {bf:repeated()}"
			exit 198
		}
	}

	local regopts `constant'

	ParseMod `anything'	// provides r(depvar) and r(anomod)
	local depvar `r(depvar)'
	local anomod `r(anomod)'

	if _by() {
		`BY' BYANO `depvar' `anomod' `if' `in' [`weight'`exp'], ///
				justregopts(`regopts') `dropemptycells' `opts'
	}
	else {
		if "`dropemptycells'" != "" {
			set emptycells drop	// orig is auto restored
		}
		// create the _b and VCE
		qui: _regress `depvar' `anomod' ///
			`if' `in' [`weight'`exp'], `regopts' AnovaExtras

		WgtMsg
		// build the anova based off _b and VCE
		     // if, in, and weights passed in so repeated() option
		     // can operate
		_reg_to_anova `if' `in' [`weight'`exp'], `opts' buildit
	}

	ereturn hidden scalar version = 2 	// before Stata 11
						// e(version) was blank
	ereturn local cmdline `"anova `0'"'
end

program BYANO, byable(recall)

	syntax varlist(fvanova) [if] [in] [aw fw] ///
				[, justregopts(str asis) DROPEMPtycells *]
        marksample touse

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

	if "`dropemptycells'" != "" {
		set emptycells drop	// orig is auto restored
	}
	// create the _b and VCE
        qui: _regress `varlist' if `touse' [`weight'`exp'], ///
						`justregopts' AnovaExtras

	WgtMsg
	// build the anova based off _b and VCE
	     // if and weights passed in so repeated() option can operate
	_reg_to_anova if `touse' [`weight'`exp'], `options' buildit
end

program Replay

	if "`e(prefix)'" != "" {
		_prefix_display, `0'
		exit
	}

	syntax [,			/// options allowed on replay
		Partial			///
		SEquential		///
		Detail			/// Old opt; not supported
		NOANova			/// Old opt; not supported
		ANova			/// Old opt; not supported
		Regress			/// Old opt; not supported
		Level(passthru)		/// Old opt; not supported
		]

	OldOpt , `detail' `anova' `noanova' `regress' `level'

	opts_exclusive "`partial' `sequential'"

	local opts `partial' `sequential'

	_reg_to_anova , `opts' /* omit the buildit option so it does replay */
end

program ParseMod, rclass

	gettoken yvar 0 : 0 , parse(" /")
	confirm numeric variable `yvar'

	gettoken chk : 0 , parse(" /")
	if `"`chk'"' == "/" {
		// slash cannot directly follow the depvar
		di as err "invalid use of /"
		exit 198
	}

	if `"`0'"' == "" { // no right-hand-side vars
		return local depvar "`yvar'"
		exit
	}

	_anovaparse `0'

	return local anomod "`r(varlist)'"
	return local depvar "`yvar'"
end


program OldOpt
	// The old options that are not supported below are allowed in
	// Version 10 -anova-.  They are not needed with the newer -anova-;
	// users can call -regress- as a replayer for -anova- to get what
	// they desire and use "i." and "c." to tell what is categorical or
	// continuous.  We trap these options in order to provide better
	// error messages.

	syntax [, Detail NOANova ANova Regress Level(str) ///
		  CAtegory(string) CLass(string) CONTinuous(string)]

	if ///
    "`detail'`anova'`noanova'`regress'`level'`category'`class'`continuous'" ///
	== "" {
		exit	// all is well
	}

	if `"`level'"'           != "" local badopt level(`level')
	else if `"`category'"'   != "" local badopt category(`category')
	else if `"`class'"'      != "" local badopt class(`class')
	else if `"`continuous'"' != "" local badopt continuous(`continuous')
	else local badopt `: word 1 of `detail' `anova' `noanova' `regress''

	di as smcl as err `"option {bf:`badopt'} not allowed"'

	di as smcl as err "{p 4 4 2}"
	di as smcl as err ///
		`"Option {bf:`badopt'} only allowed under version control with"'
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
	else if `"`badopt'"'=="noanova" {
		di as smcl as err ///
	    "Or, use prefix command {cmd:quietly} to suppress the ANOVA table."
	}
	else if `"`badopt'"'=="detail" {
		di as smcl as err ///
			"Or, use {bf:regress, coeflegend} after {bf:manova}."
	}
	else if `"`badopt'"'=="regress" | bsubstr(`"`badopt'"',1,5)=="level" {
		di as smcl as err ///
			"Or, use command {cmd:regress} after your {cmd:anova}"
		di as smcl as err "to display the coefficient table."
	}
	di as smcl as err "{p_end}"

	exit 198
end

program WgtMsg
	// _regress was called quietly and any messages saying
	// "(sum of wgt is #)" were lost.  We reproduce the message here.

	if `"`e(wtype)'"' != "aweight" {
		exit
	}

	tempvar tmp
	qui gen double `tmp' `e(wexp)' if e(sample)
	qui summ `tmp', meanonly
	di as text "(sum of wgt is " %12.4e r(sum) ")"
end
