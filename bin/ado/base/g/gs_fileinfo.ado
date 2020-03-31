*! version 1.2.1  07oct2015
program gs_fileinfo, rclass
	version 8
	local 0 `"using `macval(0)'"'
	syntax using/ [, SUFFIX]

	gs_filetype `"`using'"', `suffix'
	return add
	if return(ft) != "live" {
		exit
	}

	tempname h
	file open `h' using `"`return(fn)'"', read text
	file read `h' line		// StataFileTM line
	file read `h' line		// .gph line

	while (1) {
		file read `h' line
		gettoken h1 line : line
		gettoken h2 line : line
		if "`h1'" != "*!" {
			exit
		}
		if ("`h2'"=="end") {
			exit
		}
		else if "`h2'"=="family:" {
			ret local family `line'
		}
		else if "`h2'"=="command:" {
			ret local command `line'
		}
		else if "`h2'"=="command_date:" {
			ret local command_date `line'
		}
		else if "`h2'"=="command_time:" {
			ret local command_time `line'
		}
		else if "`h2'"=="datafile:" {
			ret local dtafile `line'
		}
		else if "`h2'"=="datafile_date:" {
			ret local dtafile_date `line'
		}
		else if "`h2'"=="scheme:" {
			ret local scheme `line'
		}
		else if "`h2'"=="ysize:" {
			ret local ysize `line'
		}
		else if "`h2'"=="xsize:" {
			ret local xsize `line'
		}
	}
end

