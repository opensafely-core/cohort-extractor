*! version 1.0.3  19jan2019
program _bayesmh_summaryopts, sclass
	version 14.0
	
	local 0 , `0'
	syntax [, 			///
		BATCH(string)		///
		CLEVel(crlevel)		///
		Level(string)		///
		HPD			///
		CORRLAG(string)		///
		CORRTOL(string)		///
		MCMCSIZE(string)	/// internal
		*]
	if (`"`level'"'!="") {
		di as err "option {bf:level()} not allowed; specify " ///
			  "option {bf:clevel()}"
		exit 198
	}
	if (`"`batch'"'!="") {
		if (`"`corrtol'`corrlag'"'!="") {
			di as err "{p}options {bf:corrlag()} and {bf:corrtol()}"
			di as err "may not be combined with {bf:batch()}{p_end}"
			exit 198
		}
		cap confirm integer number `batch'
		local rc = _rc
		if (`"`mcmcsize'"'!="") {
			local max = floor(`mcmcsize'/2)
		}
		else {
			local max = floor(e(mcmcsize)/2)
		}
		if (`max'==0) {
			di as err "insufficient MCMC sample size"
			exit 2001
		}
		local ++max
		if (!`rc') {
			if (`batch'<0 | `batch'>`max') {
				local rc 198
			}

		}
		if (`rc') {
			di as err "{p}option {bf:batch()} must contain a"
			di as err "nonnegative integer less than `max'{p_end}"
			exit `rc'
		}
	}
	else local batch 0
	
	local options `options' corrlag(`corrlag') corrtol(`corrtol') mcmcsize(`mcmcsize')
	_bayesmhpost_options `"`options'"'
	sret local batch    "`batch'"
	sret local clevel   "`clevel'"
	sret local hpd      "`hpd'"
end
