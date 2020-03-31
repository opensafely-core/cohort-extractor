*! version 1.0.1  15may2018
program gsem_check_mgroupvar
	gettoken mgroupvar 0 : 0
	gettoken outcome xvars : 0

	if "`mgroupvar'" == "" {
		exit
	}

	if "`outcome'" != "" {
		fvrevar `outcome', list
		local varlist `"`r(varlist)'"'
		if `:list mgroupvar in varlist' {
			di as err "invalid path specification;"
			di as err "{p 0 0 2}"
			di as err "{bf:group()} variable {bf:`mgroupvar'} is"
			di as err "not allowed to be an outcome variable"
			di as err "{p_end}"
			exit 198
		}
	}

	fvrevar `xvars', list
	local varlist `"`r(varlist)'"'
	if `:list mgroupvar in varlist' {
		di as err "invalid path specification;"
		di as err "{p 0 0 2}"
		di as err "{bf:group()} variable {bf:`mgroupvar'} is"
		di as err "not allowed to be an independent variable"
		di as err "{p_end}"
		exit 198
	}
end
exit
