*! version 1.0.0  09apr2019

program meta__validate_method_graph, sclass
	version 16
	syntax, [ meth(string) reml MLe SJonkman EBayes ///
		PMandel HEdges HSchmidt DLaird mm INVVARiance IVariance ///
		MHaenszel *]
	
	sreturn clear
	local which `reml' `mle' `sjonkman' `ebayes' `pmandel' `hedges' `mm'
	local which `which' `hschmidt' `dlaird' `invvariance' `ivariance'
	local which `which' `mhaenszel' 
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:`meth'()} specification: "  ///
		 "only one of {bf:reml}, {bf:mle}, {bf:ebayes}, "      ///
		 "{bf:ivariance}, {bf:mhaenszel}, {bf:hedges}, " ///
		 "{bf:hschmidt}, {bf:sjonkman}, or {bf:dlaird} "     ///
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
		local which : char _dta[_meta_method]
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
	else if inlist("`which'","invvariance","ivariance") {
		local methdesc = "Inverse-variance"
	} 
	else if "`which'" == "mle" local methdesc = "ML"
	else if "`which'" == "reml" local methdesc = "REML" 
	else if "`which'" == "ebayes" local methdesc = "Empirical Bayes"
	else if "`which'" == "hedges" local methdesc = "Hedges"
	else if "`which'" == "hschmidt" local methdesc = "Hunter-Schmidt"
	else if "`which'" == "sjonkman" local methdesc = "Sidik-Jonkman"
	else if "`which'" == "pmandel" local methdesc = "Paule-Mandel"
	
	sreturn local method `which'
	sreturn local methdesc `methdesc'
end
