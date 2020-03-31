*! version 1.0.0  03may2019

/* following _get_diopts.ado */
program meta__parse_format, sclass
	version 16
	
	syntax [, pformat(string)			///
		ordformat(string)			///
		cformat(string)				///
		wgtformat(string)			///
		sformat(string)				///
		studies(string)				///
		iscumul]
	
	sreturn clear
	
	if missing("`cformat'") local cformat "`c(cformat)'"
	if missing("`sformat'") local sformat "`c(sformat)'"
	if missing("`pformat'") local pformat "`c(pformat)'"
	
	if `:length local cformat' {	// fmt ES, ES_se, CI
		confirm numeric format `cformat'
		if fmtwidth(`"`cformat'"') > 9 {
			local cformat "%9.3f"
			di "{txt}note: invalid {bf:cformat()}, using default"
		}
		mata: __validate_format("`cformat'", "cformat")
		sreturn local cformat `"`cformat'"'
	}
	else {
		sreturn local cformat = cond(missing("`studies'"), ///
		"%9.3f", cond(missing("`iscumul'"),"%9.0g", "%9.3f"))
	}
	if `:length local ordformat' {	// fmt sortvar in CMA
		confirm numeric format `ordformat'
		if fmtwidth(`"`ordformat'"') > 9 {
			local ordformat "%9.0g"
			di "{txt}note: invalid {bf:ordformat()}, using default"
		}
		mata: __validate_format("`ordformat'", "ordformat")
		sreturn local ordformat `"`ordformat'"'
		
	}
	else sreturn local ordformat "%9.0g"
	if `:length local sformat' {	// fmt test statistics
		confirm numeric format `sformat'
		if fmtwidth(`"`sformat'"') > 8 {
			local sformat "%8.2f"
			di "{txt}note: invalid {bf:sformat()}, using default"
		}
		mata: __validate_format("`sformat'", "sformat")
		sreturn local sformat `"`sformat'"'
	}
	else sreturn local sformat "%7.2f"
	if `:length local wgtformat' {	// fmt weights
		confirm numeric format `wgtformat'
		if fmtwidth(`"`wgtformat'"') > 5 {
			local pformat "%5.2f"
			di "{txt}note: invalid {bf:wgtformat()}, using default"
		}
		sreturn local wgtformat `"`wgtformat'"'
	}
	else sreturn local wgtformat "%5.2f"
	if `:length local pformat' {	// fmt pval
		confirm numeric format `pformat'
		if fmtwidth(`"`pformat'"') > 5 {
			local pformat "%5.3f"
			di "{txt}note: invalid pformat(), using default"
		}
		sreturn local pformat `"`pformat'"'
	}
	else sreturn local pformat "%5.3f"
end


