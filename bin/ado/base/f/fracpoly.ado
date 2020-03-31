*! version 2.1.0  12apr2013
program define fracpoly, eclass
	local VV : di "version " string(_caller()) ":"
	version 10

	set prefix fracpoly

	local cmdline : copy local 0
	mata: _parse_colon("hascolon", "rhscmd")	// _parse_colon() is stored in _parse_colon.mo
	if (`hascolon') {
		`VV' newfracpoly `"`0'"' `"`rhscmd'"'
	}
	else {
		`VV' fracpoly_10 `0'
	}
	// ereturn cmdline overwrites e(cmdline) from fracpoly_10
	ereturn local cmdline `"fracpoly `cmdline'"'
end

program define newfracpoly
	local VV : di "version " string(_caller()) ":"
	version 9.2
	args 0 statacmd

	// Extract fracpoly options
	syntax, [*]
	local fracpolyopts `options'

/*
	It is important that the fracpoly options precede the Stata command options.
	To ensure this, must extract the Stata options and reconstruct the command
	before presenting it to fracpoly_10.
*/
	local 0 `statacmd'
	syntax [anything] [if] [in] [aw fw pw iw], [*]
	if `"`weight'"' != "" local wgt [`weight'`exp']

	`VV' fracpoly_10 `anything' `if' `in' `wgt', `fracpolyopts' `options'
end
