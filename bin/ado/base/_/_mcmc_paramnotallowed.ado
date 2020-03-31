*! version 1.0.0  11mar2015
program _mcmc_paramnotallowed
	args param type
	
	if `"`type'"' == "matrix" {
		di as err "matrix specification " ///
			"{bf:{c -(}`param',matrix{c )-}} not allowed"
		
		di as err "{p 4 4 2}If you want to refer to elements of "  ///
			"the matrix, use, for example, " 		   ///
			"{bf:{c -(}Sigma{c )-}} to refer to all elements " ///
			"of the matrix {bf:Sigma} or " 			   ///
			"{bf:{c -(}Sigma_}{it:#}{bf:_}{it:#}{bf:{c )-}} "  ///
			"to refer to an individual element "               ///
			"of a 2x2 matrix, such as " 		           ///
			"{bf:{c -(}Sigma_1_1{c )-}} to refer to the "	   ///
			"first element.{p_end}"
	}
	else {
		if `"`type'"' != "" {
			local type ,`type'
		}
		di as err "specification {bf:{c -(}`param'`type'{c )-}} "  ///
			"not allowed"
	}
	exit 198
end
