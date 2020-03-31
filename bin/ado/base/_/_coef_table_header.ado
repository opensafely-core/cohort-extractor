*! version 1.8.0  15jan2019
program _coef_table_header
/* 
  also see _censobs_header.ado and gsem_depvar_header.ado for changes to 
  censored obs. output
*/
	version 9
	if !c(noisily) {
		exit
	}
	syntax [,			///
		rclass			///
		noHeader		///
		obj(string)		///
		*			///
	]

	if ("`header'" != "") exit

	local has_obj = `"`obj'"' != ""
	if `has_obj' == 0 {
		tempname obj
	}

	if "`rclass'" != "" {
		tempname rhold
		_return hold `rhold'
	}
	.`obj' = ._coef_table__header.new, `rclass' `options'
	if "`rclass'" != "" {
		_return restore `rhold'
		.`obj'.New4r
	}

	.`obj'.build

	if `has_obj' == 0 {
		.`obj'.display
	}
end
exit
