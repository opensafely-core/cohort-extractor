*! version 1.2.0  27aug2019
program _prefix_varblocklist
	// Syntax:
	//
	//	<c_vblist> <c_vlist> <c_k> <c_stub> "[if]" : <varblocklist>
	//
	// the <c_*> are names for local macros to create for the caller:
	//
	// <c_vblist>	- the parsed <varblocklist>
	// <c_vlist>	- the corresponding varlist
	// <c_k>	- the number of blocks
	// <c_stub>	- stub to use to return the individual blocks
	version 9.1
	local vv : di "version " string(_caller()) ", missing:"
	_on_colon_parse `0'
	local after `"`s(after)'"'
	tokenize `s(before)'
	args c_vblist c_vlist c_k c_stub IF
	confirm name `c_vblist'
	confirm name `c_vlist'
	confirm name `c_k'
	confirm name `c_stub'
	local 0 `"`after'"'
	syntax anything(id="varblocklist" name=varblocklist)

	local k 0
	while `"`:list retok varblocklist'"' != "" {
		local ++k
		gettoken varblock varblocklist : varblocklist, bind match(par)
		if "`par'" == "" {
			// `varblock' is not a block of variable names
			`vv' MyUnab `varblock' `IF'
			local varblock `"`s(varlist)'"'
			// check for expanded wildcard
			if `:word count `varblock'' != 1 {
				gettoken varblock rest : varblock
				local varblocklist `"`rest' `varblocklist'"'
			}
			local vblist `vblist' `varblock'
		}
		else {
			// `varblock' is a block of variable names
			if "`varblock'" != "" {
				`vv' MyUnab `varblock' `IF'
				local varblock `"`s(varlist)'"'
				local vblist `vblist' (`varblock')
			}
		}
		c_local `c_stub'`k' `varblock'
		local vlist `vlist' `varblock'
	}
	c_local `c_vlist' `vlist'
	c_local `c_vblist' `vblist'
	c_local `c_k' `k'
end

program MyUnab, sclass
	version 9.1
	local vv : di "version " string(_caller()) ", missing:"

	if _caller() >= 16 {
		`vv' fvexpand `0'
		local varlist `"`r(varlist)'"'
	}
	else {
		`vv' fvunab varlist : `0'
	}
	sreturn local varlist `"`varlist'"'
end

exit
