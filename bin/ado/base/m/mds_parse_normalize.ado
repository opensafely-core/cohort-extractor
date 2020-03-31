*! version 1.0.1  21may2007
program mds_parse_normalize, sclass	
	version 10
	
	args opt
	local 0 `opt'
	capture syntax [anything] [, Copy]
	if _rc {
		opt_error normalize
	}
	local 0, `anything'

// NONE is undocumented
	capture syntax [, NONE Classical Principal Target(name) ]
	if _rc {
		di as err "normalize() may be principal, classical or target()"
		exit 198
	}

	local method `none' `classical' `principal' `target'
	if `:list sizeof method' > 1 {
		opt_error normalize "only one normalization method allowed"
	}
	if "`target'" == "" & "`copy'"!="" {
		di as err "normalize(): copy only valid with target()"
		exit 198
	}

	local arg .	
	if "`method'" == "" {
		local method principal
	}
	
	if "`target'" != "" {
		capture confirm matrix `target'
		if _rc {
			opt_error normalize "matrix `target' not found"
		}
		local method target
		local arg    `target'
	}

	sreturn clear
	sreturn local arg    `arg'
	sreturn local method `method'
	sreturn local copy `copy'
end

program opt_error
	args optname detail

	dis as err `"normalize() invalid"'
	if "`detail'" != "" {
		di as err "`detail'"
	}
	exit 198
end
exit
