*! version 1.0.0  03apr2019

program meta__validate_random, sclass
	version 16
	syntax, [ reml MLe SJonkman EBayes PMandel HEdges HSchmidt DLaird mm *]
	
	sreturn clear
	local which `reml' `mle' `sjonkman' `ebayes' `pmandel' `hedges' `mm'
	local which `which' `hschmidt' `dlaird'
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:random()} specification: "  ///
		 "only one of {bf:reml}, {bf:mle}, {bf:ebayes}, {bf:hedges}," ///
		 " {bf:sjonkman}, {bf:hschmidt}, or {bf:dlaird} " ///
		 "can be specified{p_end}"
		exit 184
	}
	if !`k' { //k = 0
		if "`options'" != "" {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:random()} specification: " ///
		 	 "estimation method {bf:`op'} not allowed{p_end}"
			exit 198
		}
		// Not needed 
		local which : char _dta[_meta_method]	
		if missing("`which'") local which reml
	}
	else {	// k = 1
		if "`options'" != "" {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:random()} specification: " ///
		 	 "estimation method {bf:`op'} not allowed{p_end}"
			exit 198
		}
		local which : list retokenize which
	}
	sreturn local remodel `which'
end
