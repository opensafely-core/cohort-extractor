*! version 1.0.4  17feb2020
program define _shortenpath, rclass
	version 8

	syntax anything, len(int) [ head(str) ]

	assert `len' > 0

	// not with quotes
	local pathfile `anything'

	if `:length local pathfile' <= `len' {
		return local pfilename `"`pathfile'"'
		exit
	}
	if index("`pathfile'", "http:")>0 | index("`pathfile'", "https:")>0 {
		return local pfilename `"`pathfile'"'
		exit
	}
// need to shorten the path, if possible

	if `"`head'"' == "" {
		local head "*"
	}
	local lhead = length(`"`head'"')

	local shortened  0

	// parse off "drive" information such as "C:"
	if "$S_OS" == "Windows" {
		gettoken drive tmp : pathfile , parse(":")
		gettoken sd    tmp : tmp, parse(":")
		if length("`drive'") == 1 & "`sd'" == ":" {
			local pathfile `"`tmp'"'
			local shortened 1
		}
	}

	// get rid of leading \/:
	gettoken tok: pathfile, parse("\/:")
	// this is not treated as -shortened-
	if inlist(`"`tok'"', "\", "/", ":") {
		gettoken tok pathfile: pathfile, parse("\/:")
		local sep `"`tok'"'
	}

	while `:length local pathfile' > `len'-1-`lhead' {
		gettoken dir mpathfile: pathfile, parse("\/:")
		if `"`mpathfile'"' == "" {
			continue, break
		}
		gettoken sep mpathfile: mpathfile, parse("\/:")
		if inlist(`"`dir'"', "\", "/", ":", "") | ///
		   !inlist(`"`sep'"', "\", "/", ":") {
		   di as err `"path-filename is invalid: `anything'"'
		   exit 198
		}
		local shortened 1
		local pathfile `"`mpathfile'"'

	}
	if `shortened' {
		return local pfilename `"`head'`sep'`pathfile'"'
	}
	else 	return local pfilename `anything'
end
exit
