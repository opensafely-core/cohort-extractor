*! version 1.0.0  03sep2019
program _rmcollblocks, rclass
	version 16

	// Stata 16 reimplementation of _rmcollright.ado with better
	// support for factor variables.

	syntax anything(id="varblocklist" name=vblist)	///
		[if] [in] [fw aw iw pw]			///
		[,					///
			noCONStant			///
			COLLinear			///
			DROP				///
		]

	if "`drop'" != "" {
		local action drop
	}
	else {
		local action omit
	}

	local rmopts nowgtmsg expand `constant' `collinear'

	marksample touse, novarlist
	local wgt [`weight'`exp']

	local VBLIST : copy local vblist
	local i 0
	while `:length local vblist' > 0 {
		local ++i
		gettoken BLOCK vblist : vblist, bind match(par)
		markout `touse' `BLOCK'
	}
	local k = `i'

	if `k' == 0 {
		return scalar k = 0
		exit
	}

	local i 0
	while `:length local VBLIST' > 0 {
		gettoken BLOCK VBLIST : VBLIST, bind match(par)
		fvexpand `BLOCK' if `touse' `in'
		local BLOCK `"`r(varlist)'"'
		if "`par'" != "" {
			local ++i
			local block`i' : copy local BLOCK
			continue
		}
		local dim : list sizeof BLOCK
		forval j = 1/`dim' {
			local ++i
			gettoken block`i' BLOCK : BLOCK
		}
	}
	local k = `i'

	forval i = 1/`k' {
		local BLOCK : copy local block`i'
		_rmcoll `BLOCK' if `touse' `in' `wgt', `rmopts'
		local block`i' `r(varlist)'
		local omit : list block`i' - BLOCK
		local vlist `vlist' `block`i''
		local olist `olist' `omit'
	}
	local dim : list sizeof vlist

	if `dim' == 0 {
		return scalar k = `k'
		return local varblocklist `"`VBLIST'"'
		exit
	}

	_rmcoll `vlist' if `touse' `in' `wgt', `rmopts'
	local vlist2 `r(varlist)'
	local dim2 : list sizeof vlist2
	local dropped : list vlist - vlist2

	foreach drop of local dropped {
		forval i = `k'(-1)1 {
			_ms_mark_omitted `action' `drop' `block`i''
			if `"`s(found)'"' == "yes" {
				local block`i' `"`s(list)'"'
				continue, break
			}
		}
	}

	return scalar k = `k'
	local olist `olist' `dropped' `omitted'
	return local dropped `:list retok olist'
	forval i = 1/`k' {
		local newvblist `newvblist' (`block`i'')
		local newvarlist `newvarlist' `block`i''
		return local block`i' `block`i''
	}
	return local varblocklist `newvblist'
	return local varlist `newvarlist'
end

exit
