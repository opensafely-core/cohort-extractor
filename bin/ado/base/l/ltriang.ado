*! version 1.0.0  15jul2003
program define ltriang
	version 8.0

// syntax ltriang,  mat(name) dimen(integer) value(real)

	syntax , mat(name) dimen(integer) value(real)

	confirm name `mat'
	
	if `dimen' < 2 {
		di as err "dimension must be at least 2"
		exit 498
	}

	mat `mat' = J(`dimen',`dimen', 0)

	forvalues i = 1/`dimen' {
		forvalues j = 1/`i' {
			mat `mat'[`i', `j'] = `value'
		}
	}
end	
