*! version 1.0.1  28apr2004
program define vecnorm_w, rclass
	version 8.2
	
	syntax , 			///
		rmac(name)		///
		[ 			///
		Usece(varlist)		/// undocumented
		dfk			///
		ESTimates(string)	///
		*			///
		]


	tempname kurtosis skewness jb  c_est var_est
	tempvar smp0

	capture noi _vec_postvar , cmd(vecnorm) cestname(`c_est') 	///
		`dfk' var_est(`var_est') usece(`usece')			///
		estimates(`estimates') rmacname(`rmac')			///
		cestsmp(`smp0') betaiden
	local rc = _rc	

	if "``rmac''" == "" {
		c_local `rmac' 0
	}
	else {
		c_local `rmac' ``rmac''
	}	

	if `rc' > 0 {
		exit `rc'
	}

	varnorm , `options' estimates(`var_est')	

	mat `kurtosis' = r(kurtosis)
	mat `skewness' = r(skewness)
	mat `jb' = r(jb)


	return clear

	ret mat kurtosis = `kurtosis'
	ret mat skewness = `skewness'
	ret mat jb = `jb'
	ret local dfk "`dfk'"
	
end

