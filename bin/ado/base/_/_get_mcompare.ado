*! version 1.0.0  25apr2011
program _get_mcompare, sclass
	// Syntax:
	// _get_mcompare [<caller>] [, <options>]
	//
	// Examples:
	// 	_get_mcompare , `options'
	// 	_get_mcompare pwcompare, `options'
	//
	// Results:
	//
	// Macros
	//
	// 	s(method)		multiple comparison method
	// 	s(adjustall)		"" or "adjustall"
	// 	s(options)		remaining unparsed options
	version 11

	local cmd `"`e(cmd)'"'
	syntax [name(name=caller)] [, *]
	local is_pwc =	inlist("pwcompare", "`cmd'", "`caller'") | ///
			inlist("pwmean", "`cmd'", "`caller'")
	local is_marg = inlist("margins", "`cmd'", "`e(cmd2)'", "`caller'")

	local OPTIONS	NOADJust		///
			BONferroni		///
			DUNCan			///
			DUNNett			///
			SCHeffe			///
			SIDak			///
			SNK			///
			TUKey			///
			ADJustall		///
						 // blank

	if `is_pwc' {
		syntax [name] [, `OPTIONS' MCOMPare(string) *]
	}
	else {
		syntax [name] [, MCOMPare(string) *]
		local suboption mcompare()
	}
	sreturn clear
	sreturn local options `"`options'"'
	if `is_pwc' {
		local METHOD 	`noadjust'		///
				`bonferroni'		///
				`duncan'		///
				`dunnett'		///
				`scheffe'		///
				`sidak'			///
				`snk'			///
				`tukey'
		local METHOD : list uniq METHOD
		opts_exclusive "`METHOD'"
		local ALL `adjustall'
		opts_exclusive "`noadjust' `ALL'"
	}
	local 0 `", `mcompare'"'
	capture syntax [, `OPTIONS']
	if c(rc) {
		di as err "invalid mcompare() option;"
		di as err "method '`mcompare'' not allowed"
		error 198
	}
	local METHOD 	`METHOD'		///
			`noadjust'		///
			`bonferroni'		///
			`duncan'		///
			`dunnett'		///
			`scheffe'		///
			`sidak'			///
			`snk'			///
			`tukey'
	local METHOD : list uniq METHOD
	local ALL `ALL' `adjustall'
	local ALL : list uniq ALL
	opts_exclusive "`METHOD'" `suboption'
	if "`METHOD'" == "" {
		if "`ALL'" != "" {
			di as err ///
"multiple comparison method required with the adjustall option"
			exit 198
		}
		local METHOD noadjust
		local noadjust noadjust
	}
	opts_exclusive "`ALL' `noadjust'" `suboption'

	local EXCLUDE duncan dunnett snk tukey
	if `:list METHOD in EXCLUDE' {
		if `is_pwc' {
			local opt : copy local METHOD
		}
		else {
			local opt "mcompare(`METHOD')"
		}
		local cmdlist anova manova regress mvreg pwmean
		if "`cmd'" == "pwcompare" {
			local cmd `"`e(cmd_est)'"'
		}
		if `is_marg' {
			local cmd margins
		}
		if !`:list cmd in cmdlist' | !`is_pwc' {
			di as err ///
`"method `opt' is not allowed with results from `cmd'"'
			exit 322
		}
		if `"`e(prefix)'"' == "svy" {
			di as err ///
`"method `opt' is not allowed with results using the svy prefix"'
			exit 322
		}
		local vce `"`e(vce)'"'
		if !inlist("`vce'", "", "ols") {
			di as err ///
`"method `opt' is not allowed with results using vce(`vce')"'
			exit 322
		}
	}
	local EXCLUDE duncan dunnett snk tukey scheffe
	if `:list METHOD in EXCLUDE' {
		if "`ALL'" != "" {
			di as err ///
`"option adjustall is not allowed with method `METHOD'"'
			exit 198
		}
	}
	sreturn local method `"`METHOD'"'
	sreturn local adjustall `"`ALL'"'
end
