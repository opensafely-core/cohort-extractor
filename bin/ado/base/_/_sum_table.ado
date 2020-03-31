*! version 2.2.0  26jun2018
program _sum_table, rclass
	version 9
	if (!c(noisily) & c(coeftabresults) == "off") {
		exit
	}
	if "`e(cmd)'" == "" {
		error 301
	}
	if "`e(mi)'"=="mi" {
		local MIOPTS BMATrix(string) VMATrix(string) DFMATrix(string)
		local MIOPTS `MIOPTS' PISEMATrix(string) EMATrix(string)
		local MIOPTS `MIOPTS' DFTable NOCLUSTReport NOEQCHECK DFONLY
		local MIOPTS `MIOPTS' ROWMATrix(string) ROWCFormat(string) 
		local MIOPTS `MIOPTS' NOROWCI 
        }

	syntax [,	Level(cilevel)		///
			COEFLegend		///
			SELEGEND		///
			cformat(passthru)	///
			noLSTRETCH		///
			NOOMITted		///
			OMITted			///
			vsquish			///
			NOEMPTYcells		///
			EMPTYcells		///
			NOBASElevels		///
			BASElevels		///
			NOALLBASElevels		///
			ALLBASElevels		///
			NOFVLABel		///
			FVLABel			///
			FVWRAP(passthru)	///
			FVWRAPON(passthru)	///
			`MIOPTS'		///
			CITYPE(string)		/// NOT DOCUMENTED
			percent			/// NOT DOCUMENTED
	]
	local diopts	`coeflegend'		///
			`selegend'		///
			`cformat'		///
			`nolstretch'		///
			`noomitted'		///
			`omitted'		///
			`vsquish'		///
			`noemptycells'		///
			`emptycells'		///
			`nobaselevels'		///
			`baselevels'		///
			`noallbaselevels'	///
			`allbaselevels'		///
			`nofvlabel'		///
			`fvlabel'		///
			`fvwrap'		///
			`fvwrapon'
	_get_diopts ignore, `cformat'
	_get_diopts diopts, `diopts'
	local cformat `"`s(cformat)'"'
	local diopts : list diopts - ignore

	if ("`e(mi)'"=="mi") {
		is_svysum `e(cmd_mi)'
	}
	else {
		is_svysum `e(cmd)'
	}
	if !r(is_svysum) {
		error 301
	}

	local type `coeflegend' `selegend' `dfonly'
	opts_exclusive "`type'"
	if "`type'" == "" {
		local type nopvalues
	}
	if `"`e(over_labels)'"' != "" {
		local depname `"Over"'
	}
	else	local depname `" "'
	if !missing("`percent'") {
		local coefttl Percent
		if `"`s(cformat)'"'=="" local cformat %9.2f
	}
	else 	local coefttl "`e(depvar)'"
	local cmdextras cmdextras

	mata: _coef_table()
	return add
	local plural = colsof(return(table)) > 1
	if "`percent'" != "" {
		if `plural' {
			local ttl "Estimated Percentages"
		}
		else {
			local ttl "Estimated Percent"
		}
	}
	else {
		local ttl = "Estimated " + proper("`e(cmd)'")
		if `plural' {
			local ttl "`ttl's"
		}
	}
	if "`e(prefix)'" == "svy" {
		local ttl "Survey: `ttl'"
	}
	return hidden local title "`ttl'"
end

exit
