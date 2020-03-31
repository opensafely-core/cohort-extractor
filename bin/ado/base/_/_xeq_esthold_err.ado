*! version 1.0.0  04feb2009

/*
	Restores current estimation results (if any) only when
	<cmdline> (in macro 0) results in error.  
*/
program _xeq_esthold_err

	nobreak {
		tempname esthold
		_estimates hold `esthold', copy nullok
		capture noisily break `0'
		if (_rc) {
			_estimates unhold `esthold'
		}
	}

	exit _rc
end
