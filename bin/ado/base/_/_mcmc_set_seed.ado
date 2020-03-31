*! version 1.0.0  12nov2018

program _mcmc_set_seed
	version 16
	args mcmcobject rseed

	if "`mcmcobject'" == "" {
		exit
	}
	if "`rseed'" != "" {
		// set seed
		cap confirm number `rseed'
		if _rc == 0 {
			if `rseed' < 0 {
di as err "random-number seed in option {bf:rseed()} cannot be negative"
				exit 198
			}
			mata: `mcmcobject'.set_seed("`rseed'")
		}
		else {
			di as err "option {bf:rseed()} incorrectly specified"
			exit 198
		}
	}
end
