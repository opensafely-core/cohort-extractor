*! version 1.0.0  15dec2014
program define gr_close_namelist
	version 8
	syntax [ anything(name=grlist) ]
	local grlist : list uniq grlist
	if `"`grlist'"' == `"_all"' {
		_gs_clean_graphlist
		local grlist `._Gr_Global.graphlist'
	}
	foreach name of local grlist {
		capture window manage close graph `name'
	}
	local curgraph "`._Gr_Global.current_graph_resync'"  // current graph
	if 0`:list curgraph in grlist' {
		._Gr_Global.set_current_graph ""
	}

end
