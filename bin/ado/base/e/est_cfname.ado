*! version 1.0.0  21jan2002
program define est_cfname
	version 8
	args name

	if `"`name'"' == "" {
		di as err "nothing found where name expected"
		exit 6
	}

	if `"`name'"' == "." {
		// reference to last estimation result
		if "`e(cmd)'" == "" {
			error 301
		}
		exit 0
	}

	confirm name `name'
end
