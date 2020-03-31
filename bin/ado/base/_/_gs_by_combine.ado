*! version 1.0.0  18aug2006

/* Example:
 *	_gs_by_combine by options : `"`options'"'
 */

program _gs_by_combine
	version 10.0
	args byMac optsMac colon options
	MergeBy mergedOpts : , `options'
	local 0 , `mergedOpts'
	syntax [, BY(passthru) *]
	c_local `optsMac' `"`options'"'
	c_local `byMac' `"`by'"'
end


// Merge multiple by()'s into a single by

program MergeBy
	gettoken resmac 0 : 0
	gettoken colon  0 : 0

	syntax [, BY(string asis) * ]
	while `"`by'"' != `""' {
		ByParts byvlist byopts : `by'

		if "`byvlist'" != "" {
			local byvarlist "`byvlist'"
		}

		if `"`byopts'"' != `""' {
			local byoptions `"`byoptions' `byopts'"'
		}

		local 0 `", `options'"'
		syntax [, BY(string asis) * ]
	}

	if `"`byvarlist'`byoptions'"' == "" {
		c_local `resmac' `"`options'"'
	}
	else {
		if `"`byvarlist'"' == `""' {
			di as error "varlist required in by()"
			exit 100
		}
		c_local `resmac' `"`options' by(`byvarlist', `byoptions')"'
	}
end

program ByParts
	gettoken vlmac  0 : 0
	gettoken optmac 0 : 0
	gettoken colon  0 : 0

	syntax [varlist(default=none)] [, *]

	c_local `vlmac' `varlist'
	c_local `optmac' `options'
end
