*! version 1.0.1
program define _egennoby
	version 7
	args fcn stuff
	if `"`stuff'"' != "" { 
		di as err "egen ... `fcn' may not be combined with by"
		exit 190
	}
end
