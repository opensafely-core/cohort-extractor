*! version 1.6.0  21jun2018
program define xtrchh, eclass byable(onecall) prop(xtbs)

	version 8, missing
	if _by() {
		by `_byvars'`_byrc0': xtrc `0'
	}
	else {
		xtrc `0'
	}

end
