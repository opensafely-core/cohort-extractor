*! version 1.1.0  13jan2019

program define _pss_chk_fpc, sclass
	args fpc n

	cap numlist `"`fpc'"', range(>=0 <1)
	if !c(rc) > 0 {
		sreturn local lab "Sampling rate"
		sreturn local symlab "{&gamma}"
		exit
	}
	sreturn local lab "Population size"
	sreturn local symlab "N{sub:pop}"

	cap numlist `"`n'"'
	local nlist `r(numlist)'
	local kn : list sizeof nlist

	if `kn' == 1 {
		cap numlist `"`fpc'"', range(>`nlist')
		local rc = c(rc)
		if !(`rc') exit
	
		fpcerr	
	}
	else {
		/* table, but ensure fpc > 1				*/
		cap numlist `"`fpc'"', range(>1)
		local rc = c(rc)
		if !(`rc') {
			local flist `r(numlist)'
			local kf : list sizeof flist
			if `kf' == 1 {
				sreturn local fpc = `flist'
			}
			exit
		}
	}
	fpcerr
end

program fpcerr
	di as err "option {bf:fpc()}: incorrect specification;"
	di as err "{p 4 4 2}Option {bf:fpc()} must contain either values in [0,1) "
	di as err "representing sampling rates or values greater than the "
	di as err "sample size representing population sizes.  {bf:fpc()} "
	di as err "may not contain a mixture of sampling rates and "
	di as err "population sizes.{p_end}"
	exit 198
end	

exit
