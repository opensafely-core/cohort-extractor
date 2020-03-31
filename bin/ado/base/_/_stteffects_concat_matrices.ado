*! version 1.0.0  03nov2015

program define _stteffects_concat_matrices, rclass
	version 14.0
	syntax, mat1(name) mat2(name)

	cap mat li `mat1'
	if (c(rc)) {
		return matrix cmat = `mat2'
		exit
	}
	local stripe1 : colfullnames `mat1'
	local stripe2 : colfullnames `mat2'
	local stripe0 `"`stripe1' `stripe2'"'
	local stripe0 : list retokenize stripe0

	tempname cmat
	/* concatenation will error if factor variable name conflict	*/
	mat `cmat' = (nullmat(`mat1'),`mat2')
	local stripe : colfullnames `cmat'
	if `"`stripe0'"' == `"`stripe'"' {
		return matrix cmat = `cmat'
		exit
	}
	/* concatenation quietly relabeled factor conflict		*/
	while `"`stripe'"' != "" {
		gettoken exp stripe : stripe, bind
		gettoken exp0 stripe0 : stripe0, bind

		if `"`exp'"' == `"`exp0'"' {
			continue
		}
		_ms_parse_parts `exp'
		if "`r(type)'" == "factor" {
			local base = r(base)
			local name `r(name)'
				
			_ms_parse_parts `exp0'
			local base0 = r(base)
			if `base' != `base0' {
				di as err "{p}`name': factor variable base " ///
				 "category conflict{p_end}"
				exit 198
			}	
		}
	}
	return matrix cmat = `cmat'
end

exit
