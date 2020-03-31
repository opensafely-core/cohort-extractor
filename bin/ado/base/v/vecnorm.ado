*! version 1.0.1  28apr2004
program define vecnorm, rclass sortpreserve
	version 8.2

	tempname rmac
	syntax , [ * ]
	capture noi vecnorm_w , `options' rmac(`rmac')
	local rc = _rc
	local r = ``rmac''

	capture noi _vecpclean, rank(`r')
	local rc2 = _rc

	if `rc' == 0 & `rc2' > 0 {
		local rc = `rc2'
	}


	if `rc' == 0 {
		tempname kurtosis skewness jb 

		mat `kurtosis' = r(kurtosis)
		mat `skewness' = r(skewness)
		mat `jb' = r(jb)
		local dfkm "`r(dfk)'"

		ret mat kurtosis = `kurtosis'
		ret mat skewness = `skewness'
		ret mat jb       = `jb'
		ret local dfk      "`dfkm'"
	}
	else {
		exit `rc'
	}
end	
