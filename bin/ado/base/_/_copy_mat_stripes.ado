*! version 1.0.1  08jul2008
program _copy_mat_stripes
	version 9
	_on_colon_parse `0'
	local matlist `s(before)'
	local 0 `"`s(after)'"'
	syntax [anything(name=b)] [, novar norow ]
	local coln : coln `b'
	local cole : cole `b', quote
	confirm matrix `b'
	foreach mat of local matlist {
		confirm matrix `mat'
		version 11: matrix coln `mat' = `coln'
		matrix cole `mat' = `cole'
		if "`row'" != "" {
			continue
		}
		if "`var'" != "" | rowsof(`mat') != colsof(`mat') {
			version 11: matrix rown `mat' = y1
			matrix rowe `mat' = _
		}
		else {
			version 11: matrix rown `mat' = `coln'
			matrix rowe `mat' = `cole'
		}
	}
end
