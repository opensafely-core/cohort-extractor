*! version 1.0.0  03jan2005
program is_svysum, rclass
	version 9
	local SvySum mean prop proportion ratio total
	if `"`0'"' != "" & `:list 0 in SvySum' {
		return scalar is_svysum = 1
	}
	else	return scalar is_svysum = 0
end
exit
