*! version 1.0.2  17oct2008

// ---------------------------------------------------------------------------
//  Parse axis title settings and options and push the associated edits of the
//  named object onto the specified log.
//
//	Usage:  ._gs_parse_and_log_axtitle log name
//		<settings and options>

program _gs_parse_and_log_axtitle
	gettoken log  0 : 0
	gettoken name 0 : 0

	_parse comma mtext 0 : 0
	syntax [ , PREFIX SUFFIX AXis(passthru) * ]	// axis() ignored

	if `:word count `prefix' `suffix'' > 1 {
		di as error "options prefix and suffix may not be combined"
		exit 198
	}
	if "`prefix'`suffix'" == "" {
		local replace replace
	}

	if `"`mtext'"' != `""' {
		.`log'.Arrpush .`name'.edit , mtextq(`"`mtext'"')	///
			`prefix' `suffix' `replace'
	}

	if `"`options'"' != `""' {
		_fr_sztextbox_parse_and_log `log' `name' , `options'
		local 0 `", `r(rest)'"'
		syntax [, FAKE_OPT_FOR_BETTER_MSG ]
	}
end

