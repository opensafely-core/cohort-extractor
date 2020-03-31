*! version 1.0.1  14apr2014
program _prefix_fvlabel
	version 12

	args ecmd

	if "`ecmd'" == "sem" {
		local gvar = "`e(groupvar)'"
		capture confirm numeric var `gvar'
		if c(rc) exit
		local glab : value label `gvar'
		if "`glab'" != "" {
			capture label list `glab'
			if c(rc) == 0 {
				label copy `glab' `gvar', eclass replace
			}
		}
	}
end
