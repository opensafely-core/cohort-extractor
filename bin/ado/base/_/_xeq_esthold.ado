*! version 1.0.0  04feb2009

/*
	Always restores current estimation results (if any) after 
	executing <cmdline> (in macro 0).  
*/
program _xeq_esthold

	nobreak {
		tempname esthold
		_estimates hold `esthold', copy restore nullok
		capture noisily break `0'
		_estimates unhold `esthold'
	}
	exit _rc
end
