*! version 1.0.0  27mar2009

/*
	u_mi_getstubname <macroname> : <stub>
*/

program u_mi_getstubname
	version 11
	args macroname colon stub

	local i = 0
	while (1) {
		local name `stub'`++i'_
		capture checknovars `name'
		if _rc {
			if (_rc==1) {
				exit 1
			}
			c_local `macroname' `name'
			exit
		}
	}
end

program checknovars
	local 0 `0'*
	syntax varlist
end
