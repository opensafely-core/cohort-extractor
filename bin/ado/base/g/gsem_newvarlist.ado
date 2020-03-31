*! version 1.0.0  25jan2013
program gsem_newvarlist, sclass
	syntax anything(name=vlist) , nvars(integer)
	if `nvars' <= 0 {
		di as err "invalid nvar() option;"
		di as err "only positive integer values are allowed"
		exit 198
	}
	local 0 `vlist'
	syntax newvarlist(min=`nvars' max=`nvars')
	sreturn local varlist `"`varlist'"'
	sreturn local typlist `"`typlist'"'
end
exit
