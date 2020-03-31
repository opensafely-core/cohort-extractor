*! version 1.0.1  08mar2019
program _mcmc_batchnote
	version 14.0
	args batch linesize

	if (`batch'==0) exit

	if (`"`linesize'"'=="") {
		local linesize = c(linesize)-2
	}
	//di as txt "{p 0 6 0 `linesize'}Note: Mean, Std. Dev., and MCSE"
	di as txt "{p 0 6 0 `linesize'}Note: Mean and MCSE"
	di as txt "are estimated using batch means.{p_end}"
end
