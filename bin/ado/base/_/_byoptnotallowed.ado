*! version 1.0.1  08jun2000
program define _byoptnotallowed
	version 7
	args optname optval
	if `"`optval'"' != "" {
		di as err /* 
		*/ `"option `optname' may not be combined with by"'
		exit 190
	}
end
