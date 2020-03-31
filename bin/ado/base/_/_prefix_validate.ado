*! version 1.0.0  03jun2009
program _prefix_validate
	version 11
	args prefix cmd

	if "`cmd'" == "anova" {
		// if e(repvars) is present and the "cmd" is anova then
		// produce an error message and error return code
		local pre_list bootstrap brr jackknife
		if `"`e(repvars)'"' != "" {
			if `:list prefix in pre_list' {
				di as err ///
			 "`prefix' not allowed with repeated() option of anova"
				exit 198
			}
		}
	}

end
exit

// _prefix_validate is to be called after the first full run of "cmd"
// by the "prefix" command (such as -jackknife- or -bootstrap-) before
// it runs the command multiple times.

// A command may want to keep certain prefix commands from operating
// depending on what the command produces when run on the full sample.

