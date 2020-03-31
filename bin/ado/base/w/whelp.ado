*! version 1.0.8  31jan2020
program whelp
	version 9

	if "`c(console)'" == "console" | "$S_MODE"=="batch" {
		chelp `0'
	}
	else {
		syntax [anything(everything)] [, noNew name(name) MARKer(name)]

		if ("`new'" == "" | "`new'"=="new") & "`name'" == "" {
			local name _new
		}
		if ("`new'" == "nonew") & "`name'" == "" {
			local name _nonew
		}

		if "`name'`marker'" != "" {
			if (strpos(`"`anything'"',"##")) {
				local suffix "`marker'|`name'"
			}
			else {
				local suffix "##`marker'|`name'"
			}
		}

		if `"`anything'"' == "" {
			view help help_advice`suffix'
		}
		else {
			view help `anything'`suffix'
		}
	}
end
