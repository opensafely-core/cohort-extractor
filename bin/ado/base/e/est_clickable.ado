*! version 1.0.0  05feb2002
program define est_clickable, rclass
	version 8
	args namelist command sep

	foreach name of local namelist {
		local t `"`t'{stata estimates `command' `name':`name'}"'
		if `"`ferest()'"' != ""  &  `"`sep'"' != "" {
			local t `"`t'`sep'"'
		}
	}
	return local clicktxt `"`t'"'
end
