*! version 1.0.1  17oct2008

// Edit version of title parsing.
// Does not handle or even allow positioning options.

program _fr_tedits_parse_and_log , rclass

	gettoken log     0 : 0
	gettoken obj     0 : 0
	gettoken ttype   0 : 0
	gettoken parsenm 0 : 0

	local obname = cond("`obj'"=="" , "`ttype'" , "`obj'.`ttype'")

	local 0 , `0'
	syntax [ , `parsenm'(string asis) * ]
	local outer_rest `options'

	while `"``ttype''"' != `""' {		// allow option to be repeated
		local 0 `"``ttype''"'

		syntax [anything(name=text)] [ , PREFIX SUFFIX * ]

		if `"`text'"' != `""' {
			.`log'.Arrpush `obj'.`ttype'.edit ,		///
				mtextq(`"`text'"')  `prefix' `suffix'
		}

		_fr_sztextbox_parse_and_log `log' `obname' , `options'

		local 0 `", `r(rest)'"'
		syntax [, FAKE_OPT_FOR_BETTER_MSG ]

		local 0 `", `outer_rest'"'
		syntax [ , `parsenm'(string asis) * ]
		local outer_rest `options'
	}

	return local rest `outer_rest'
end

