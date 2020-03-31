*! version 1.0.0  28oct2016

program threshold, eclass byable(onecall)
	version 15.0

	if _by() {
		local by `"by `_byvars' `_byrc0':"'
	}
	if replay() {
		if _by() {
			error 190
		}
		if ("`e(cmd)'"!="threshold") {
			error 301
		}
		_threshold_print `0'
		exit
	}

	`by' _threshold `0'

end
