*! version 2.1.2  23jul2007
program define renpfix, rclass
	version 6
	gettoken prefix 0 : 0
	gettoken new 0 : 0
	if trim(`"`0'"') != "" {
		error 198
	}

	local 0 "`prefix'*"
	syntax varlist

	local loc = length("`prefix'") + 1
	local i = 1
	foreach var of local varlist {
		local newn = "`new'" + substr("`var'",`loc',.)
		rename `var' `newn'
		if `i' == 1 {
			local vars "`newn'"
		}
		else {
			local vars "`vars' `newn'"
		}
		local ++i
	}
	return local varlist "`vars'"
end
