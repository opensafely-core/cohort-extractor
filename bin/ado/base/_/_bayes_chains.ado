*! version 1.0.3  29oct2018

program _bayes_chains
	gettoken cmd 0 : 0
	_bayes_chains_`cmd' `0'
end

program _bayes_chains_opt, rclass
	args nchains
	local chainserr ///
		option {bf:nchains()} must contain an integer greater than 1
	if `"`nchains'"' != "" {
		gettoken nchains chainsdetail : nchains, parse(",")
		gettoken tok chainsdetail : chainsdetail, parse(",")
		local chainsdetail `chainsdetail'
		cap confirm integer number `nchains'
		if !_rc {
			if `nchains' < 1 {
				di as err "`chainserr'"
				exit 198
			}
		}
		if _rc {
			di as err "`chainserr'"
			exit 198
		}
		local options `"`options' nchains(`nchains')"'
		if "`chainsdetail'" == "detail" {
			local options `"`options' chainsdetail"'
		}
		else if "`chainsdetail'" != "" {
	di as err "nchains suboption {bf:`chainsdetail'} not supported"
			exit 198
		}
		if `nchains' < 2 {
			di as err "at least 2 chains must be specified " ///
				"in option {bf:nchains()}"
			exit 198
		}
	}
	else {
		local nchains 1
	}
	return local nchains = `nchains'
	return local options = `"`options'"'
end

program _bayes_chains_parse, rclass
	args chains
	local allchains `e(allchains)'
	if `"`chains'"' == "_all" {
		local chains
		cap confirm e(nchains)
		if !_rc {
			local chains `allchains'
		}
	}
	if `"`chains'"' != "" {
		numlist `"`chains'"'
		local chains `r(numlist)'
	}
	
	local notavailable : list chains - allchains
	local pref : word count "`notavailable' "
	if `"`notavailable'"' != "" {
		if `pref' > 1 {
			local pref s
		}
		else {
			local pref
		}
		di as err "chain`pref' {bf:`notavailable'} not available"
		exit 198
	}
	return local chains = `"`chains'"'
end
