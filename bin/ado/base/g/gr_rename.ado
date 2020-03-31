*! version 1.0.6  09apr2007
program define gr_rename
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

	local curgraph "`._Gr_Global.current_graph_resync'"

	if "`replace'" != "" {
		gs_stat type : `to'
		if ("`type'"=="exists") graph drop `to'
		else 	di as txt "(note: graph `to' not found)"
	}
	else	gs_stat !exists `to'

	capture window manage rename graph `from' `to'
	.`to' = .`from'.ref
	gr_drop `from'

	_gs_addgrname `to'				// register to name

							// may be current graph
	if "`curgraph'" == "`from'" {	
		._Gr_Global.set_current_graph "`to'"
	}
end
