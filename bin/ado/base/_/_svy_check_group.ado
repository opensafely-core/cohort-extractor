*! version 1.0.0  18feb2007
program _svy_check_group, sortpreserve
	version 10
	syntax, group(varname) [lastunit(varname) optname(name)]

	if (!`:length local optname') local optname group

	if !`:length local lastunit' {
		local rc = 459
	}
	else {
		sort `group'
		capture by `group': assert `lastunit' == `lastunit'[1]
		local rc = c(rc)
	}
	if `rc' {
		di as err ///
"the `optname'() variable is not nested within the final stage sampling units"
		exit 459
	}
end
