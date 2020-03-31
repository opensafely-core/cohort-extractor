*! version 1.0.0  05dec2014
program define gr_drop_namelist
	version 8

	syntax [ anything(name=grlist) ] [, LEAVEinlist noFREE ]

	local grlist : list uniq grlist

	if `"`grlist'"' == `""' {
		di as err "nothing found where graph name expected"
		exit 198
	}
	if `"`grlist'"' == `"_all"' {
		_gs_clean_graphlist
		local grlist `._Gr_Global.graphlist'
	}

	local sum  0 
	foreach name of local grlist {
		capture noisily gs_stat exists `name'
		local sum = `sum' + _rc 
	}
	if `sum' {
		di as error "no graphs dropped"
		exit 111
	}

	foreach name of local grlist {
		if ("`free'" == "")  _cls free `name'
		capture window manage close graph `name'
	}

	if "`leaveinlist'" == "" {			// maintain graph list
		local list `._Gr_Global.graphlist'	
		local list : list list - grlist
		._Gr_Global.graphlist = "`list'"
	}

	local curgraph "`._Gr_Global.current_graph_resync'"  // current graph
	if 0`:list curgraph in grlist' {
		._Gr_Global.set_current_graph ""
	}

end
