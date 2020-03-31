*! version 1.0.0  05mar2018
program _parse_iterlog, sclass
	version 16

	* NOLOG must appear before LOG in syntax
	syntax [, NOLOG LOG]

	if "`log'`nolog'" != "" {
		opts_exclusive "`log' `nolog'"
	}
	else if "`c(iterlog)'" == "on" {
		local log log
	}
	else {
		local nolog nolog
	}

	sreturn local log `log'
	sreturn local nolog `nolog'
end
