*! version 1.0.9  02may2005
program define gr_current
	version 8

	gettoken namemac 0 : 0, parse(" :")
	gettoken colon   0 : 0, parse(" :")
	assert "`colon'"==":"

	syntax [anything(name=name)] [ , DRAWifchg Newgraph Query	///
					 REPLACE NOFREE ]

	gettoken prefix rest : name , parse(".")
	if "`prefix'" == "Global" | "`prefix'" == "Local" {
		gettoken dot name : rest , parse(".")
	}

	if "`._Gr_Global.isa'" == "" {
		._Gr_Global = .global_g.new
	}

	if "`query'"!="" {
		if "`name'" == "" {
			local name `._Gr_Global.current_graph_resync'
		}
		gs_stat exists `name'
		c_local `namemac' `name'
		exit
	}
		
	if "`newgraph'" == "" {			/* this is an existing graph */
		OldGraph realname : `name' , `drawifchg'
		c_local `namemac' `realname'
		exit
	}

	capture class free _Gr_Cglobal
	._Gr_Cglobal = .cglobal_g.new
						/* this is to be a new graph */

	if ("`name'" == "") local name Graph

	if ("`replace'" != "") {
		gs_stat status : `name'
		if "`status'" == "exists" {
			gr_drop `name' , leaveinlist `nofree'
		}
	}
	else	gs_stat !exists `name'

	._Gr_Global.set_current_graph "`name'"

	c_local `namemac' `name'

end

program define OldGraph				/* an existing graph */
	gettoken namemac 0 : 0, parse(": ")
	gettoken colon   0 : 0, parse(": ")
	syntax [name(name=name)] [ , DRAWifchg Newgraph REPLACE ]

	if "`name'"=="" {
		local name = cond("`._Gr_Global.current_graph_resync'"=="",  ///
				  "Graph", "`._Gr_Global.current_graph_resync'")
	}

	gs_stat exists `name'
	capture window manage forward graph `name'

	if "`name'" != "`._Gr_Global.current_graph_resync'" & 		///
	   "`drawifchg'" != "" {
		._Gr_Global.set_current_graph "`name'"			// sic
		.`name'.drawgraph
	}
	._Gr_Global.set_current_graph "`name'"

	if "`.`name'._scheme.isa'" != "" {
		set curscm `.`name'._scheme.objkey'
	}
	c_local `namemac' `name'
end

exit

Usage:
	gr_current macname : [graph_name] [ , Newgraph REPLACE ] /* new graph */

	gr_current name : `name'


Purpose:  Centralizes management of graph names and more importantly tracking 
	  of current default graph.
	  Will delete existing graphs if replace option is specified.


