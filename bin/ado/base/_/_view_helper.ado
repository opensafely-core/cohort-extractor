*! version 1.0.0  17feb2011
program _view_helper
	version 12

	syntax [anything(everything)] [, noNew name(name) *]

	if (index(`"`anything'"', "|") == 0) {
		if ("`new'" == "" | "`new'"=="new") & "`name'" == "" {
			local name _new
		}

		if ("`new'" == "nonew") & "`name'" == "" {
			local name _nonew
		}

		if "`name'" != "" {
			local suffix "##|`name'"
		}
	}

	if `"`anything'"' == "" {
		local anything "help contents"
	}

	if `"`options'"' == "" {
		_view `anything'`suffix'
	}
	else {
		_view `anything', `options' `suffix'
	}
end
