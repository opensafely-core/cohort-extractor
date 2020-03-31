*! version 1.0.0  07may2009
program mi_cmd_svyset
	version 11

	// canonicalize the supplied arguments so that 'mi_cmd_genericset' can
	// add -mi- to the list of global options to -svyset-
	_parse expand stage global : 0
	_parse canon 0 : stage global

	mi_cmd_genericset `"svyset `0'"'
end
