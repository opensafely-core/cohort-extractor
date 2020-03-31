*! version 1.0.2  08jan2005
program _sunflower_binar, rclass
	syntax [name] [, by(passthru) DIsplay ADJust ]
	// get name of current graph
	if "`namelist'" == "" {
		local namelist `._Gr_Global.current_graph_resync'
	}
	// point to first plotregion
	if `"`by'"' != "" {
		local gid `namelist'.plotregion1.plotregion1[1]
	}
	else	local gid `namelist'.plotregion1
	tempname yran ysiz xran xsiz rran rsiz
	// information from the y axis
	// range of y axis
	scalar `yran' = `.`gid'.yscale.curmax' - `.`gid'.yscale.curmin'
	// size of y axis on graph
	scalar `ysiz' = `.`gid'.yscale.size'
	// information from the x axis
	// range of x axis
	scalar `xran' = `.`gid'.xscale.curmax' - `.`gid'.xscale.curmin'
	// size of x axis on graph
	scalar `xsiz' = `.`gid'.xscale.size'
	// range and size ratios
	scalar `rran' = `yran'/`xran'
	scalar `rsiz' = `ysiz'/`xsiz'
	if "`adjust'" == "" {
		local adjust 1
	}
	else	local adjust (2/sqrt(3))
	return scalar binar = (`rran'/`rsiz')*`adjust'
	if "`display'" != "" {
		di as txt "Graph `namelist':"
		di as txt "binar = " as res return(binar)
	}
end

exit
