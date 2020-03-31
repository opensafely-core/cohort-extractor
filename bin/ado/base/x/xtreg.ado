*! version 1.9.0  21jun2018
program define xtreg, eclass byable(onecall) sort prop(xt xtbs mi)
	version 6, missing
	local version : di "version " string(_caller()) ", missing:"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if `"`e(cmd)'"'==`"xtreg"' {
			if _by() { error 190 }
			`version' xtreg_`e(model)' `0'
			exit `e(rc)'
		}
		else if `"`e(cmd2)'"' == "xtreg" {
			if _by() { error 190 }
			`version' `e(cmd)' `0'
			exit `e(rc)'
		}
		error 301
		/*NOTREACHED*/
	}
	
	quietly							///
	syntax varlist(fv ts) [if] [in] [aw fw pw iw] [,	///
		I(varname) BE FE RE MLE PA GEE			///
		VCE(passthru)					///
		*						///
	]
	
	gettoken depvar rest: varlist
	_fv_check_depvar `depvar'
	
	local cmdline : copy local 0
	if ("`be'"!="") + ("`fe'"!="") + ("`re'"!="") + ("`pa'"!="") + 	///
		("`gee'"!="")>1 { 
		di in red "choose only one of be, fe, re, or pa"
		exit 198 
	}

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() & `"`vce'"' != "" {
		di as err "the by prefix may not be used with vce() option"
		exit 198
	}
	if `"`vce'"' != "" {
		local options `"`options' `vce'"'
	}

	if "`gee'" != "" { local pa "pa " }

	if `"`be'"'!=`""' | `"`fe'"'!=`""' { 
		if `"`mle'"'!=`""' | `"`pa'"'!=`""' { error 198 } 
	}
	else {
		if `"`mle'"'!=`""' & `"`pa'"'!=`""' { error 198 }
	}

	if "`be'"=="" & "`fe'"=="" & "`re'"=="" & "`pa'"=="" ///
		& "`gee'"=="" & "`mle'"=="" {
		local re = "re"
	}
					/* check collinearity */
	_xt, i(`i')
	local ivar "`r(ivar)'"
	if subinword("`varlist'","`ivar'","",.) != "`varlist'" {
			di as err "the panel variable `ivar' may not be " /*
			*/ as err "included as an independent variable"
			exit 198
		}
	if `fvops' {
		local rmcoll "version 11: _rmcoll"
		local fvexp expand
	}
	else	local rmcoll _rmcoll
	qui `rmcoll' `varlist', `fvexp'
	local retlist `"`r(varlist)'"'

	tempvar ivar2
	qui sum `ivar'
	qui gen double `ivar2' = (`ivar'-r(mean))/r(sd)
	local retlist `retlist' `ivar2'
	qui `rmcoll' `retlist', `fvexp'
	if !`fvops' {
		if "`r(varlist)'" ~= "`retlist'" {
			di as err "independent variables " _c
			di as err "are collinear with the panel variable" _c
			di as err " `ivar'"
			exit 198
		}
	}

	local options `options' i(`i')

	if `"`be'"'!=`""' {
		`version' `BY' xtreg_be `cmdline'
	}
	else if `"`fe'"'!=`""' {
		`version' `BY' xtreg_fe `cmdline'
	}
	else {
		if `"`mle'"' == `""'  & `"`pa'"' == `""' {
			`version' `BY' xtreg_re `cmdline'
			version 10: ereturn local cmdline `"xtreg `cmdline'"'
			exit
		}
		if `"`mle'"' == `""' {
			local 0 `"`cmdline'"'
			syntax [anything(everything name=args)] ///
				[iw fw pw] [, PA GEE *]
			`version' `BY' xtgee `args' [`weight'`exp'], `options'
			est local predict xtreg_pa_p
			est local estat_cmd ""	// reset from xtgee
			est local cmd2 "xtreg"
			est local model "pa"
			version 10: ereturn local cmdline `"xtreg `cmdline'"'
			exit
		}
		else {
			`version' `BY' xtreg_ml `cmdline'
		}
	}
	version 10: ereturn local cmdline `"xtreg `cmdline'"'
	if "`be'`re'" != "" {
		est local wtype
		est local wexp
	}
	exit `e(rc)'
end
