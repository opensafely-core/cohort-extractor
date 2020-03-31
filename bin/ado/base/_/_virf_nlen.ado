*! version 1.0.2  07nov2002
program define _virf_nlen, rclass
	version 8.0
	syntax anything(name=name)

	local words : word count `name'
	if `words' > 1 {
		di as err "`name' is not a valid name"
		exit 198
	}

	capture confirm name `name'
	if _rc > 0 {
		di as err "`name' is not a valid name"
		exit 198
	}	

	local tmp : subinstr local name " " "" , /* 
		*/ count(local n1)

	if `n1' > 0 {
		di as err "`name' is not a vaid irfname"
		exit 198
	}	
	
	local n = length("`name'")
	if `n' > 24 {
		di as err "`name' is not a vaid irfname"
		exit 198
	}	
	
	ret scalar len = `n'
end

exit

_virf_nlen <name>
	
	checks that the specified name is valid and returns the length of
	valid names in r(len)

