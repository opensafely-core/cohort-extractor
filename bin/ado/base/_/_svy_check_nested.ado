*! version 1.0.0  03feb2014
program _svy_check_nested
	version 14
	gettoken touse 0 : 0
	_on_colon_parse `0'
	local by `s(before)'
	local sulist `s(after)'
	local sulist : list sulist - by

	foreach var of local sulist {
		capture by `by' : assert `var' == `var'[1] if `touse'
		if c(rc) {
			di as err ///
			"hierarchical groups are not nested within `var'"
			exit 459
		}
	}
end
