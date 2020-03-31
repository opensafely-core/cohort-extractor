*! version 1.0.0  24oct2014

program define _stteffects_split_vlist, sclass
	syntax, [ vlist(string) ]

	if "`vlist'" == "" {
		sreturn local vlist
		sreturn local constant
		exit
	}
	gettoken vlist constant : vlist, parse(",") bind
	if "`constant'" != "" {
		gettoken comma constant : constant, parse(",")
	}
	else if ("`vlist'"==",") local vlist

	sreturn local vlist `"`vlist'"'
	sreturn local constant `constant'
end

exit
