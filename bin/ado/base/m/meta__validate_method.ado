*! version 1.0.0  27apr2019

program meta__validate_method, sclass
	version 16
	syntax, [ meth(string) reml MLe SJonkman EBayes ///
		PMandel HEdges HSchmidt DLaird fixed common ///
		MHaenszel *]
	
	sreturn clear
	if !missing("`mhaenszel'") {
		di as err "{p}the trim-and-fill algorithm cannot be applied" ///
		  " with the Mantel-Haenszel method{p_end}"
		exit 198  
	}
	
	local which `reml' `mle' `sjonkman' `ebayes' `pmandel' `hedges' 
	local which `which' `hschmidt' `dlaird' `fixed' `common'
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:`meth'()} specification: "  	///
		 "only one of {bf:fixed}, {bf:common}, {bf:reml}, "   	///
		 "{bf:mle}, {bf:ebayes}, {bf:hedges}, " 		///
		 "{bf:hschmidt}, {bf:sjonkman}, or {bf:dlaird} "     	///
		 "can be specified{p_end}"
		exit 184
	}
	if !`k' {
		if "`options'" != "" {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:`meth'()} specification: " ///
		 	 "estimation method {bf:`op'} not allowed{p_end}"
			exit 198
		}
		local glbl_meth : char _dta[_meta_method]
		local glbl_mod : char _dta[_meta_model]
	
		local which = cond("`glbl_mod'" == "fixed", "fixed", ///
			cond("`glbl_mod'"=="common", "common", "`glbl_meth'"))
	}
	else {	// k = 1	
		if "`options'" != "" {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:`meth'()} specification: " ///
		 	 "estimation method {bf:`op'} not allowed{p_end}"
			exit 198
		}
		local which : list retokenize which
	}
	
	     if "`which'" == "dlaird" local methdesc = "DerSimonian-Laird"
	else if "`which'" == "fixed" {
		local modeldesc "Fixed-effects"
		local model "fixed"
		local methdesc = "Inverse-variance"
		local which "ivariance"
	}
	else if ("`which'" == "common") {
		local modeldesc "Common-effect"
		local model "common"
		local methdesc = "Inverse-variance"
		local which "ivariance"
	} 	
	else if "`which'" == "mle" local methdesc = "ML"
	else if "`which'" == "reml" local methdesc = "REML" 
	else if "`which'" == "ebayes" local methdesc = "Empirical Bayes"
	else if "`which'" == "hedges" local methdesc = "Hedges"
	else if "`which'" == "hschmidt" local methdesc = "Hunter-Schmidt"
	else if "`which'" == "sjonkman" local methdesc = "Sidik-Jonkman"
	else if "`which'" == "pmandel" local methdesc = "Paule-Mandel"
	
	if inlist("`which'","reml","mle","ebayes", "hedges", "hschmidt" , ///
		"sjonkman", "pmandel", "dlaird", "mm") {
		local modeldesc "Random-effects"
		local model "random"
	}
	
	sreturn local method `which'
	sreturn local methdesc `methdesc'
	sreturn local modeldesc `modeldesc'
	sreturn local model `model'
end
