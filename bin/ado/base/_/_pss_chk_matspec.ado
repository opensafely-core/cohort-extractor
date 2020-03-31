*! version 1.0.0  27jun2013

program define _pss_chk_matspec, rclass
	version 13
	/* decorate `option' with smcl: 				*/
	/*  e.g. {it:meanspec} or {bf:covmatrix()}			*/
	/* `extra' contains options for _pss_chk_matrix, e.g. cov	*/
	_on_colon_parse `0'
	local before `"`s(before)'"'
	local matspec `"`s(after)'"'

	gettoken option extra : before, bind
	/* no idea where the colon comes from				*/
	if (`"`extra'"'==":") local extra
	else local extra : list clean extra

	local 0 `matspec'
	cap syntax anything(name=matspec)
	if c(rc) {
		di as err "invalid `option'"
		exit 198
	}
	local k : list sizeof matspec

	if `k' == 1 {
		cap confirm name `matspec'
		if !c(rc) {
			_pss_chk_matrix `matspec', option(`option') `extra'
			return mat mat = `matspec', copy
			return local nrows = `s(nrows)'
			return local ncols = `s(ncols)'
			return local which matrix
			exit
		}
	}
	local values `matspec'
	local i = 1
	local j = 0
	local ncols = 0
	local nrows = 0
	local mat (
	while ("`values'" != "") {
		gettoken v values : values, parse(" \") bind
		if "`v'" == "\" {
			/* end of row					*/
			if (!`j') {
				di as err "invalid `option': empty row `i'"
				exit 198
			}
			if (!`ncols') local ncols = `j'
			else if `j' != `ncols' {
				di as err "{p}invalid `option': expected "   ///
				 "`ncols' elements in row `i', but got `j' " ///
				 "{p_end}"

				exit 198
			}
			local mat `"`mat' \\"'
			local c
			local `++i'
			local j = 0
		}
		else {
			local `++j'
			cap confirm number `v'
			local rc = c(rc)
			if `rc' {
				local rc = ("`v'"!=".")
			}
			if `rc' {
			
				di as err "{p}invalid `option': expected " ///
				 "a numeric but got {bf:`v'} for element " ///
				 "(`i',`j'){p_end}"
				exit 198
			}
			local mat `"`mat'`c' `v'"' 

			local c ,
		}
	}
	if (!`ncols') local ncols = `j'
	else if `j' != `ncols' {
		di as err "{p}invalid `option': expected `ncols' elements " ///
		 "in row `i', but got `j'{p_end}"

		exit 198
	}
	local mat `"`mat')"'

	tempname x
	mat `x' = `mat'
	_pss_chk_matrix `x', option(`option') `extra'

	return mat mat = `x'
	return local nrows = `s(nrows)'
	return local ncols = `s(ncols)'
	return local which string
end

exit
