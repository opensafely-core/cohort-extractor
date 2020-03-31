*! version 1.0.0  13dec2018
program _get_dots_option, sclass
	version 16
	syntax [,		///
		NODOTS		///
		DOTS1		///
		DOTS(string)	///
		NOIsily		///
		*		///
	]

	if `"`dots'"' != "" {
		capture {
			confirm integer number `dots'
			assert `dots' >= 0
		}
		if c(rc) {
			di as err "invalid {bf:dots()} option;"
			di as err ///
		"{bf:`dots'} found where non-negative integer expected"
			exit 198
		}
		if `dots' > 0 {
			if `dots' > 1 & "`dots1'" != "" {
				opts_exclusive "dots(`dots') dots"
			}
			opts_exclusive "dots() `nodots'"
			opts_exclusive "dots() `noisily'"
		}
		else {
			if `"`dots1'"' != "" {
				opts_exclusive "dots(0) dots"
			}
			local nodots nodots
		}
	}
	else if `"`dots1'"' != "" {
		opts_exclusive "dots `nodots'"
		opts_exclusive "dots `noisily'"
		local dots 1
	}
	else if `"`nodots'"' != "" {
		local dots 0
	}
	else if `"`c(dots)'"' == "on" {
		local dots 1
	}
	else {	// c(dots) == "off"
		local nodots nodots
		local dots 0
	}

	if `"`noisily'"' != "" {
		local nodots nodots
		local dots 0
	}

	sreturn clear
	if `dots' {
		sreturn local dotsopt dots(`dots')
	}
	sreturn local dots	`"`dots'"'
	sreturn local nodots	`"`nodots'"'
	sreturn local noisily	`"`noisily'"'
	sreturn local options	`"`options'"'
end
exit
