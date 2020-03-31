*!  version 1.0.2  31mar2008
*!   parse memory(#) option for exlogistic and exlogistic_estat

program _parsememsize, sclass
	args sz 

	gettoken k m: sz, parse("KkMmGgbB")

	local m = upper("`m'")

	if "`m'"=="K" | "`m'"=="KB" {
		local m = 1024
	}
	else if "`m'"=="M" | "`m'"=="MB" {
		local m = 1048576
	}
	else if "`m'"=="G" | "`m'"=="GB" {
		local m = 1073741824
	}
	else if "`m'"=="" | "`m'"=="B" {
		local m = 1	
	}
	else {
		di as err "{p}invalid `opt' specification memory(`sz')" ///
		 "{p_end}"
		exit 198
	}
	tempname s
	cap scalar `s' = `k'
	if _rc {
		di as err "{p}invalid `opt' specification memory(`sz')" ///
		 "{p_end}"
		exit 198
	}
	if `s'<=0 {
		di as err "{p}invalid `opt' specification memory(`sz')" ///
		 "{p_end}"
		exit 198
	}
	scalar `s' = round(`s'*`m')
	if `s' < 1048576 {
		di as err "{p}minimum memory size is memory(1Mb){p_end}"
		exit 198
	}
	if `s' > 2147483648 {
		di as err "{p}maximum memory size is memory(2Gb){p_end}"
		exit 198
	}
	sreturn local size = `s'
end

