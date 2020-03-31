*! version 1.0.0  04nov2002
program _gs_addgrname
	version 8

	syntax name(name=name) 

	if ! 0`.`name'.isofclass graph_g' {
		di in white as error "`name' does not exist or is not a graph"
		exit 198
	}

	local grlist `._Gr_Global.graphlist'
	local grlist : list grlist | name
	._Gr_Global.graphlist = "`grlist'"

end

