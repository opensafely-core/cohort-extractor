*! version 1.1.1  07oct2019
program _prefix_depvarblocklist
	// Syntax:
	//
	//	<cmd> : <c_*> "[if]" : <varblocklist>
	//
	// the <c_*> are names for local macros to create for the caller:
	//
	// <c_depvar>	- the depvar
	// <c_vblist>	- the parsed <varblocklist>
	// <c_vlist>	- the corresponding varlist
	// <c_k>	- the number of blocks
	// <c_stub>	- stub to use to return the individual blocks
	version 9.1
	local vv : di "version " string(_caller()) ", missing:"

	_on_colon_parse `0'
	local cmd `"`s(before)'"'
	_on_colon_parse `s(after)'
	local after `"`s(after)'"'
	tokenize `s(before)'
	args c_depvar c_vblist c_vlist c_k c_stub IF
	confirm name `c_depvar'
	confirm name `c_vblist'
	confirm name `c_vlist'
	confirm name `c_k'
	confirm name `c_stub'
	local 0 `"`after'"'
	syntax anything(id="varblocklist" name=vblist)

	local stcmds streg stcox stcrr stcrre stcrreg stintreg
	local is_st : list cmd in stcmds

	// there is no <depvar> for -stcox-, -streg-, and -stcrreg-
	// otherwise it is required
	if !`is_st' {
		gettoken depvar vblist : vblist, bind match(par)
		if "`par'" != "" {
			di as err "depvar cannot be part of a variable block"
			exit 198
		}
		_fv_check_depvar `depvar'
		fvunab depvar : `depvar'
		if trim("`cmd'") == "intreg" {
			gettoken depvar2 vblist : vblist, bind match(par)
			if "`par'" != "" {
				di as err ///
				"depvar cannot be part of a variable block"
				exit 198
			}
			unab depvar2 : `depvar2'
			local depvar `depvar' `depvar2'
		}
	}

	c_local `c_depvar'	`depvar'
	`vv' _prefix_varblocklist vblist vlist k stub "`IF'" : `vblist'
	c_local `c_vblist'	`vblist'
	c_local `c_vlist'	`vlist'
	c_local `c_k'		`k'
	forval i = 1/`k' {
		c_local `c_stub'`i' `stub`i''
	}
end
exit
