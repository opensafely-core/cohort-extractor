*! version 1.0.1  29jun2009
/*
	mi erase {<name>|.} [, clear]
*/

program mi_cmd_erase
	version 11

	/* you do not have to be set to use this command */
	gettoken name 0 : 0, parse(" ,[]()-")
	if ("`name'"=="," | "`name'"=="") { 
		di as smcl as err "nothing found where name expected"
		di as smcl as err ///
			"    syntax is {bf:mi erase} {it:name}{cmd:, ...}"
		exit 198
	}

	if ("`name'"!=".") {
		confirm name `name'
	}
	syntax [, clear]

	if ("`_dta[_mi_marker]'" == "_mi_ds_1"  &  ///
	   "`_dta[_mi_style]'"  == "flongsep"   &  ///
	   "`_dta[_mi_name]'"   == "`name'") { 
		if ("`clear'"=="") {
			di as err "no; data in memory would be lost"
			di as err as smcl "{p 4 4 2}"
			di as err as smcl "type {bf:mi erase `name', clear}"
			di as err as smcl "or type {bf:mi erase .}"
			di as err as smcl "{p_end}"
			exit 4
		}
	}
	if ("`name'"==".") {
		if ("`_dta[_mi_style]'"!="flongsep") {
			di as err "flongsep data not currently in use"
			exit 198
		}
		nobreak {
			local name "`_dta[_mi_name]'"
			drop _all
			mata: u_mi_flongsep_erase("`name'", 0, 2)
		}
	}
	else {
		if ("`clear'"!="") {
			drop _all
		}
		mata: u_mi_flongsep_erase("`name'", 0, 2)
	}
end
