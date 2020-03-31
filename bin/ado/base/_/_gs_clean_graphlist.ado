*! version 1.0.1  13nov2002
program _gs_clean_graphlist

	foreach graph in `._Gr_Global.graphlist' {
		if 0`.`graph'.isofclass graph_g' {
			local list `"`list' `graph'"'
		}
	}

	._Gr_Global.graphlist = "`list'"
end
