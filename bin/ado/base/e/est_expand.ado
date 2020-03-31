*! version 1.0.2  21feb2015
program define est_expand, rclass
	version 8

	syntax anything [, min(int 0) max(int 32000) Default(str) starok ]

	local names `anything'
	if "`names'" == "" {
		local names `default'
	}
	if "`names'" == "" {
		exit
	}

	// only the estimates saved with the -estimates- flag
	qui _estimates dir, estimates
	local est_names `r(names)'

	foreach name of local names {
		if "`name'" == "_all" {
			local expnames `expnames' `est_names'
		}
		else if "`starok'"!="" & "`name'" == "*" {
			local expnames `expnames' `est_names'
		}
		else if "`name'" == "." {
			if "`e(cmd)'" == "" {
				di as err "last estimates (.) not found"
				exit 301
			}
			else if "`e(_estimates_name)'" != "" {
				local expnames `expnames' `e(_estimates_name)'
			}
			else 	local expnames `expnames' .
		}
		else {
			local enames
			foreach ename of local est_names {
				if match("`ename'", "`name'") {
					local enames `enames' `ename'
				}
			}
			if "`enames'" == "" {
				di as err "estimation result `name' not found"
				exit 111
			}
			local expnames `expnames' `enames'
		}
	}

	// check that number of names satisfies conditions
	local nnames : word count `expnames'
	if (`min' != 0)  &  (`nnames' < `min') {
		di as err "too few names specified"
		exit 198
	}
	if (`max' != 32000)  &  (`nnames' > `max') {
		di as err "too many names specified"
		exit 198
	}

	return local names `expnames'
end
exit
