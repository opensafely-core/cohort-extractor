*! version 1.0.0  26apr2019

program meta__model_method, sclass
	syntax [, random(string) RANDOM1 FIXED1 fixed(string) COMMON1 ///
		common(string) suppressclocal dtype(string) estype(string) iv]
	
	if missing("`dtype'") {
		local dtype : char _dta[_meta_datatype]
	}
	if missing("`estype'") {
		local estype : char _dta[_meta_estype]
	}
	
		if !missing("`random'") {
			meta__validate_random, `random'
			local method `s(remodel)'
			local model random
		}
		else if !missing("`random1'") {
			local method reml
			local model random 
		}
		else if !missing("`fixed'") {
			meta__validate_fixed, meth(fixed) `fixed'
			local method `s(femodel)'
			local model fixed
		}
		else if !missing("`common'") {
			meta__validate_fixed, meth(common) `common'
			local method `s(femodel)'
			local model common
		}
		else if !missing("`fixed1'") {
			if ("`dtype'" == "binary") {
				local method = 				///
				cond(missing("`iv'"), 			///
					cond("`estype'"=="lnorpeto", 	///
					"invvariance", 			///
					"mhaenszel"), 			///
				"invvariance")
			}
			else local method invvariance 
			local model fixed
		}
		else if !missing("`common1'") {
			if ("`dtype'" == "binary") {
				local method = 				///
				cond(missing("`iv'"), 			///
					cond("`estype'"=="lnorpeto", 	///
					"invvariance", 			///
					"mhaenszel"), 			///
				"invvariance")
			}
			else local method invvariance
			local model common 
		}
		else {	// grab _meta_method from -meta set- or -meta esize-
			local method   : char _dta[_meta_method] 
			local model : char _dta[_meta_model]	 		
		}
	
	
	// for meta db
	local moddesc = cond("`model'" == "common", "Common-effect", ///
			cond("`model'"=="fixed", "Fixed-effects", ///
			"Random-effects"))	
			
	     if "`method'" == "dlaird" local methdesc = "DerSimonian-Laird"
	else if inlist("`method'","invvariance","ivariance") {
		local methdesc = "Inverse-variance"
	}
	else if "`method'" == "mhaenszel" local methdesc = "Mantel-Haenszel" 
	else if "`method'" == "mle" local methdesc = "ML"
	else if "`method'" == "reml" local methdesc = "REML" 
	else if "`method'" == "ebayes" local methdesc = "Empirical Bayes"
	else if "`method'" == "hedges" local methdesc = "Hedges"
	else if "`method'" == "hschmidt" local methdesc = "Hunter-Schmidt"
	else if "`method'" == "sjonkman" local methdesc = "Sidik-Jonkman"
	else if "`method'" == "pmandel" local methdesc = "Paule-Mandel"
	else if "`method'" == "sa" local methdesc = "User-specified"		
	
	if missing("`suppressclocal'") {
		c_local model "`model'"
		c_local method "`method'"
	}
	
	sreturn local modeldesc "`moddesc'"
	sreturn local methdesc "`methdesc'"
end	