*! version 1.0.0  10mar2015
program _mcmc_mcsefailnote
	version 14.0
	args mcsefail linesize
	
	if (!`mcsefail') exit

	di as txt "{p 0 6 0 `linesize'}Note: MCSE estimation failed. "	///
		"This may happen when MCMC sample size is small.{p_end}"
end
