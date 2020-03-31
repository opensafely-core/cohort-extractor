*! version 1.3.1  22sep2014
program _rmcollright, rclass
	if _caller() < 11 {
		_rmcollright_10 `0'
		return add
		exit
	}
	version 11
	syntax anything(id="varblocklist" name=vblist)	///
		[if] [in] [fw aw iw pw] [, noCONStant COLLinear]

	local rmopts nowgtmsg expand `constant' `collinear'

	marksample touse, novarlist
	local wgt [`weight'`exp']

	local hold : copy local vblist
	while `"`:list retok hold'"' != "" {
		gettoken varblock hold : hold, bind match(par)
		markout `touse' `varblock'
	}

	local k 0
	while `"`:list retok vblist'"' != "" {
		local ++k
		gettoken varblock vblist : vblist, bind match(par)
		if "`par'" == "" {
			fvunab varblock : `varblock'
			gettoken varblock rest : varblock, bind
			if `:length local rest' {
				local vblist `"`rest' `vblist'"'
			}
		}
		fvexpand `varblock' if `touse' `in'
		local vb0_`k' `r(varlist)'
		_rmcoll `varblock' if `touse' `in' `wgt', `rmopts'
		local vb_`k' `r(varlist)'
		local drop_`k' : list vb0_`k' - vb_`k'
		local vlist `vlist' `vb_`k''
		local dlist `drop_`k'' `dlist'
	}

	_rmcoll `vlist' if `touse' `in' `wgt', `rmopts'
	local vlist2 `r(varlist)'
	local drop : list vlist - vlist2
	while `:list sizeof drop' {
		gettoken dvar drop : drop
		forval i = `k'(-1)1 {
			if `:list dvar in vb_`i'' {
				Drop vb_`i' : `dvar' `vb_`i''
				continue, break
			}
		}
		local dlist `dvar' `dlist'
	}

	return scalar k = `k'
	return local dropped `dlist'
	forval i = 1/`k' {
		local newvblist `newvblist' (`vb_`i'')
		return local block`i' `vb_`i''
	}
	return local varblocklist `newvblist'
	return local varlist `vlist2'
end

program Drop
	gettoken c_block 0 : 0
	gettoken COLON 0 : 0
	gettoken drop block : 0

	fvunab odrop : o.`drop'
	while `:list sizeof block' {
		gettoken var block : block
		local rlist `var' `rlist'
	}
	local rlist : subinstr local rlist "`drop'" "`odrop'", word
	while `:list sizeof rlist' {
		gettoken var rlist : rlist
		local block `var' `block'
	}
	c_local `c_block' `block'
end
exit
