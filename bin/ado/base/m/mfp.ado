*! version 2.1.0  12apr2013
program define mfp, eclass 
	local VV : di "version " string(_caller()) ", missing:"
	version 10

	set prefix mfp

	local cmdline : copy local 0
	mata: _parse_colon("hascolon", "rhscmd")	// _parse_colon() is stored in _parse_colon.mo
	if (`hascolon') {
	        `VV' newmfp `"`0'"' `"`rhscmd'"'
	}
	else {
	        `VV' mfp_10 `0'
	}
	// ereturn cmdline overwrites e(cmdline) from mfp_10
	ereturn local cmdline `"mfp `cmdline'"'
end

program define newmfp
	local VV : di "version " string(_caller()) ", missing:"
	version 9.2
	args 0 statacmd

	// Extract mfp options
	syntax, [*]
	local mfpopts `options'

/*
	It is important that the mfpoptions precede the Stata command options.
	To ensure this, must extract the Stata options and reconstruct the command
	before presenting it to mfp_10.
*/
	local 0 `statacmd'
	syntax [anything] [if] [in] [aw fw pw iw], [*]
	if `"`weight'"' != "" local wgt [`weight'`exp']
	local options `options' hascolon
	`VV' mfp_10 `anything' `if' `in' `wgt', mfpopts(`mfpopts') `options'
end
