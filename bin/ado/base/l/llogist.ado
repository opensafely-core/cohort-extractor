*! version 2.0.0  20jun2000
program define llogist, eclass byable(onecall)
	version 7
	if _by() { 
		by `_byvars'`_byrc0': llogistic `0'
	}
	else	llogistic `0'
end
