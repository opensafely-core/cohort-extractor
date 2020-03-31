*! version 1.0.5  23jan2019
program define npgraph
        version 15
        
	syntax [if][in], [*]	
	
	if "`e(cmd)'"!="npregress" {
		display as error ///
			"{bf:npgraph} valid only after {bf:npregress}"
		exit 198
	}
	
	if ("`e(margins_cmd)'"=="margins4series") {
		display as error ///
			"{bf:npgraph} not valid after {bf:npregress series}"
		exit 198		
	}
	
	local k = `e(xnum)'
	
	if (`k'>1) {
		display as error "{bf:npgraph} is only valid with one"	///
				 " covariate"
		exit 198
	}
	
	 _get_diopts diopts rest, `options'
	
	marksample touse
	tempname A
	
	local y   = "`e(depvar)'" 
	local yg  = "`e(yname)'"
	local x   = "`e(xname)'"
	local se  = .
	local dg  = `e(degree)'
	local krn = "`e(kname)'"
	
	matrix `A' = e(meanbwidth)
	local a    = `A'[1,1]
	
	lpoly_npreg `y' `x' if `touse', senpreg(`se')		///
					at(`x') 		///
					degree(`dg')		///
					bwidth("`a'")		///
					kernel(`krn') 		///
					ygorro(`yg')		///
					`rest' 

end
