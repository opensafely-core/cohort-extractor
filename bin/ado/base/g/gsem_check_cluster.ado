*! version 1.0.0  20may2013
program gsem_check_cluster
	gettoken touse 0 : 0
	gettoken clustvar 0 : 0

	capture by `0' : assert `clustvar' == `clustvar'[1] if `touse'
	if c(rc) {
		di as err ///
		"highest-level groups are not nested within `clustvar'"
		exit 459
	}
end
exit
