*! version 1.1.1  10sep2018
program _get_eqspec
	version 9
	args c_eqlist c_stub c_k COLON b
	confirm name `c_eqlist'
	confirm name `c_stub'
	confirm name `c_k'
	confirm matrix `b'
	if "`COLON'" != ":" {
		error 198
	}
	tempname tb

	local cons _cons
	local eqlist : coleq `b'
	local nlist : colnames `b'

	local i 1
	local names
	local nocons noconstant
	local noconslag noconstant
	gettoken eq0 : eqlist
	while "`nlist'" != "" {
		local freeparm
		gettoken eq eqlist : eqlist
		gettoken name nlist : nlist
		if "`eq'" == "/" {
			local freeparm freeparm
			local eq0
			local eq `name'
			local name _cons
			local nocons
		}
		local EQLIST `EQLIST' `eq'
		if ("`eq'" != "`eq0'") {
			// post spec for previous equation
			c_local `c_stub'`i'xvars `names'
			c_local `c_stub'`i'nocons `noconslag'
			local ++i
			local names
			local nocons noconstant
			if "`freeparm'" != "" {
				c_local `c_stub'`i'freeparm `freeparm'
				local nocons
			}
		}
		if "`name'" == "_cons" | "`name'" == "o._cons" {
			local nocons
		}
		else {
			local names `names' `name'
		}
		local eq0 `"`eq'"'
		local noconslag `nocons'
	}
	// post spec for last equation
	local EQLIST : list uniq EQLIST
	c_local `c_eqlist' `EQLIST'
	c_local `c_stub'`i'xvars `names'
	c_local `c_stub'`i'nocons `nocons'
	c_local `c_k' `i'
end
exit
