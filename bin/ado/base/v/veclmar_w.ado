*! version 1.0.0  08mar2004
program define veclmar_w, rclass
	version 8.2
	
	syntax , 			///
		rmac(name)		///
		[ 			///
		Usece(varlist)		///  undocumented
		ESTimates(string)	///
		*			///
		]


	tempname c_est var_est 
	tempvar smp0 

	capture noi _vec_postvar , cmd(veclmar)			///
		cestname(`c_est') usece(`usece') 		///
		estimates(`estimates') 	rmacname(`rmac')	///
		var_est(`var_est') cestsmp(`smp0')  betaiden 
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

	tempname lm

	varlmar , `options' estimates(`var_est')

	mat `lm' = r(lm)

	return clear
	ret mat lm = `lm'
	
end

