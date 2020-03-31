*! version 1.0.0  03jan2005
program _restore_labels
	version 9
	syntax varlist [, labels(namelist)]

	local nvars : word count `varlist'
	local nlabs : word count `labels'
	if `nlabs' == 0 {
		di as err "option labels() required"
		exit 198
	}
	if `nvars' != `nlabs' {
		if `nvars' < `nlabs' {
			di as err "too many label names in labels() option"
		}
		else {
			di as err "too few label names in labels() option"
		}
		exit 198
	}
	if `nvars' == 0 {
		exit
	}

	forval i = 1/`nvars' {
		local var : word `i' of `varlist'
		local lab : word `i' of `labels'
		label values `var' `lab'
	}

end
exit
