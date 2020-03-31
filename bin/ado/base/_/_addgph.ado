*! version 1.0.0  11dec2002
program define _addgph
	version 8

	gettoken macnm  0 : 0 , parse(" :")
	gettoken colon  0 : 0 , parse(" :")
	gettoken filenm 0 : 0 , parse(" :")

	local filenm `filenm'					// sic

	local unused : subinstr local filenm "." "." , count(local ct)
	if (! `ct')  local gph .gph

	c_local `macnm' `"`filenm'`gph'"'

end
