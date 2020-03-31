*! version 1.0.0  21mar2008
program mvtest_dups
	version 11
	args varlist

	local dp : list dups varlist
	if "`dp'"!="" {
		dis as err "duplicate variables: `dp'"
		exit 198
	}
end
exit
