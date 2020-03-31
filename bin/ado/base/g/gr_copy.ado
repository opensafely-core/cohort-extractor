*! version 1.0.1  18nov2002
program define gr_copy
	version 8

	syntax namelist(min=1 max=2) [ , replace ]
	local n : word count `namelist'
	if (`n'==1) {
		gr_current from : , query
		local to `namelist'
	}
	else {
		gettoken from to : namelist
		local to `to'					// sic
	}

	gs_stat exists `from'

	if ("`from'"=="`to'") exit

	if "`replace'" != "" {
		gs_stat type : `to'
		if ("`type'"=="exists") graph drop `to'
		else 	di as txt "(note: graph `to' not found)"
	}
	else	gs_stat !exists `to'

	gr_replay `from', name(`to') nodraw
end
