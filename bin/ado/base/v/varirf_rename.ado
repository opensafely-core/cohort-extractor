*! version 1.1.4  10jun2013
program define varirf_rename, rclass
	version 8
	syntax anything(id="irf list" name=irfs) [, set(string) ]

	local n : word count `irfs'
	if `n' != 2 {
		di as err "irf rename requires exactly two names"
		exit 198
	}
	else {
		gettoken oldname newname : irfs
	}

	local oldname : subinstr local oldname " " "", all
	local newname : subinstr local newname " " "", all

	if `"`oldname'"' == `"`newname'"' {
		di as err "the old name is the same as the new name"
		exit 198
	}	

	if `"`set'"' != "" {
		irf set `set'
	}

	if `"$S_vrffile"' == "" {
		di as err "no irf file active"
		exit 198
	}	

	preserve
	_virf_use `"$S_vrffile"'

	_virf_char , rename irf(`irfs')
	local irfnames `r(irfnames)'
	local oldnew `irfs'
	qui save `"$S_vrffile"' , replace
	
	ret local irfnames `irfnames'	
	ret local oldnew `irfs'	
end

exit

syntax 
	varirf_rename <old_irfname> <new_irfname> [ , set(set command) ]

usage 
        by default, varirf_rename renames <old_irfname> to <new_irfname> in
	the currently active .vrf file.  One can use the set(set command)
	option to first reset the active .vrf to the one specified by the
	set(cmd) and then apply the rename in to the <old_irfname> in that
	file.
        t

	local newname = ltrim("`newname'")
	local newname = rtrim("`newname'")
	qui count if irfname=="`oldname'"
	di as txt "{p 0 5 5} in " as res r(N) as txt " observations the " /*
		*/ "irfname will be changed from `oldname' to `newname'"
	qui replace irfname = "`newname'" if irfname == "`oldname'"
