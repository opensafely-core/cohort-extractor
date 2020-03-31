*! version 1.0.0  25feb2019

program define meta__parse_random, sclass
	version 16
	syntax, [RANDom(string) ]
	
	sreturn clear
	
	local pos = ustrpos("`random'",",")
	local l = strlen("`random'")
	local lhs = usubstr("`random'", 1, `=`pos'-1')
	local rhs = usubstr("`random'", `pos', `l')
	
	meta__ValidateRandom, `lhs'
	local lhs `s(remodel)'
	
	
	local 0 `rhs'
	syntax, [ mkh hksj tkhartung khartung *]
	
	local which `mkh' `hksj' `tkhartung' `khartung' 	
	
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:random()} specification: "  ///
		 "only one of {bf:mkh}, {bf:hksj}, {bf:tkhartung}, "      ///
		 "or {bf:khartung} can be specified{p_end}"
		exit 184
	}
	if !`k' {
		if `"`options'"' != `""' {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:random()} specification: " ///
		 	 "standard-error adjustment {bf:`op'} not " ///
			 "allowed{p_end}"
			exit 198
		}
 
	}
	else {	// k = 1	
		if `"`options'"' != `""' {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:random()} specification: " ///
		 	 "standard-error adjustment {bf:`op'} not " ///
			 "allowed{p_end}"
			exit 198
		}
		local which : list retokenize which
		
	}
	sreturn local adj `which'
	sreturn local method `lhs'	
end
