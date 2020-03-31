*! version 1.2.1  12sep2007
program _rmcollright_10, rclass
	version 9.1
	syntax anything(id="varblocklist" name=vblist)	///
		[if] [in] [fw aw iw pw] [, noCONStant COLLinear]

	marksample touse, novarlist
	local wgt [`weight'`exp']
	_prefix_varblocklist vblist vlist k block : `vblist'

	markout `touse' `vlist'

	// key to list macros:
	//	clist -- current varlist
	//	rlist -- r(varlist) from _rmcoll
	//	dvar  -- currently deleted variable
	//	dlist -- list of variables to delete from vlist/vblist

	// remove duplicate variable names
	local dlist : list dups vlist
	foreach dvar of local dlist {
		di as txt "note: `dvar' dropped because of collinearity"
	}
	local vlist : list vlist - dlist
	// reverse the order so we can work left to right
	foreach var of local vlist {
		local clist `var' `clist'
	}

	quietly _rmcoll `clist' if `touse' `wgt', `constant' `collinear'
	local rlist `r(varlist)'
	local i 1
	while !`:list rlist == clist' {
		local dvar : word `i' of `clist'
		local clist2 : list clist - dvar
		local rlist2 : list rlist - dvar
		quietly _rmcoll `clist2' if `touse' `wgt',	///
			`constant' `collinear'
		local rlist3 `r(varlist)'

		if `:list rlist3 == clist2' {
			// we're finished
			local dlist `dlist' `dvar'
			local clist `clist2'
			local rlist `clist2'
		}
		else if !`:list dvar in rlist' {
			// drop `dvar'
			local dlist `dlist' `dvar'
			local clist `clist2'
			local rlist `rlist2'
		}
		else if `:list rlist2 == rlist3' {
			// keep `dvar'
			local dvar
			local ++i
		}
		else if `:list rlist2 in rlist3' {
			// drop `dvar'
			local dlist `dlist' `dvar'
			local clist `clist2'
			local rlist `rlist3'
		}
		else {
			// keep `dvar'
			local dvar
			local ++i
		}
		if "`dvar'" != "" {
			di as txt ///
"note: `dvar' dropped because of collinearity"
		}
	}

	// revert to the original order
	local clist : list clist - dlist
	local vlist
	local vblist
	foreach var of local clist {
		local vlist `var' `vlist'
	}

	// Saved results
	return local dropped `dlist'
	return local varlist `vlist'
	local i `k'
	while `i' > 0 {
		local dvars : list block`i' & dlist
		local block`i' : list block`i' - dvars
		if `"`:list retok block`i''"' != "" {
			if `:word count `block`i''' == 1 {
				local vblist `block`i'' `vblist'
			}
			else	local vblist (`block`i'') `vblist'
		}
		local dlist : list dlist - dvars
		local --i
	}
	return local varblocklist `vblist'
	gettoken block vblist : vblist, bind match(par)
	local i 0
	while `"`block'"' != "" {
		local ++i
		return local block`i' `block'
		gettoken block vblist : vblist, bind match(par)
	}
	return scalar k = `i'
end
exit
