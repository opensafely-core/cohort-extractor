*! version 1.0.0  11oct2017
/*
	syntax is
		objname : 0
	set objname in local OBJ
	set 0 in local 0
*/
program _pglm_parse_colon
	version 16.0

	_on_colon_parse `0'
	c_local OBJ `s(before)'
	c_local 0 `s(after)'
end
