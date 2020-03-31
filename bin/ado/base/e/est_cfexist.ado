*! version 1.0.1  06nov2002
* confirms that for an expanded list of names stored estimation results exist
program define est_cfexist
	version 8
	args names

	if `"`names'"' == "." {
		if "`e(cmd)'" == "" {
			error 301
		}
		exit
	}

	// only the estimation results saved by -est store-
	quietly _estimates dir, estimates
	local est_names `r(names)'

	foreach name of local names {
		est_cfname `name'
		local tmp : subinstr local est_names "`name'" "", /*
		 */ word all count(local nch)
		if `nch' == 0 {
			di as err "estimation results for `name' not found"
			exit 111
		}
	}
end
exit
