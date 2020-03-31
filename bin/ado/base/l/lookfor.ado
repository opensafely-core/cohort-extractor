*! version 3.3.2  27jan2007
program lookfor, rclass
	version 8

	if `"`0'"' == "" {
		di as err "nothing to look for"
		exit 198
	}

	foreach W of local 0 {
		local w = lower(`"`W'"')
		local looklist `"`looklist' `"`w'"'"'
	}

	local 0 "_all"
	syntax varlist

	foreach v of local varlist {
		local lbl : variable label `v'
		local lbl : subinstr local lbl "'" "", all
		local lbl : subinstr local lbl "`" "", all
		foreach w of local looklist {
			if index(lower(`"`v'"'),`"`w'"') | index(lower(`"`lbl'"'),`"`w'"') {
				local list "`list'`v' "
				continue, break
			}
		}
	}

	if "`list'" != "" {
		describe `list'
		return local varlist `list'
	}
end
exit

3.3.2  phrase support: -lookfor word "some phrase"-

3.3.0  ported to Stata 8
       small speed-ups and simplifications; better error message on no
input
3.2.0  ported to Stata 7
       lookfor now returns varlist in r(varlist)

