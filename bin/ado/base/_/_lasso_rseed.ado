*! version 1.0.0  26mar2019
program _lasso_rseed
	syntax [, rseed(string) ]

	if (`"`rseed'"' == "") {
		exit
		// NotReached
	}

	cap confirm integer number `rseed'

	if (_rc) {
		di as err "option {bf:rseed()} allows only an integer " ///
			"number "
		exit 198
	}

	set seed `rseed'
end

