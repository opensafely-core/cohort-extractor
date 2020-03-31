*! version 1.0.0  02apr2019

program meta__parse_seadj
	args adjtype colon seadjspec
	
	_parse comma lhs rhs : seadjspec
		
	local 0 ", `lhs'"
	syntax [, KHartung HKnapp SJonkman *]
	
	local which `khartung' `hknapp' `sjonkman'
	
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:se()} specification: only one "  ///
		 "of {bf:khartung}, {bf:hknapp}, or {bf:sjonkman} "      ///
		  "can be specified{p_end}"
		exit 184
	}
	else {
		if "`options'" != "" {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:se()} specification: " ///
		 	 "SE adjustment {bf:`op'} not allowed{p_end}"
			exit 198
		}
		local which : list retokenize which
		if inlist("`which'", "hknapp", "sjonkman") {
			local which khartung
		}
	}
	
	if "`rhs'" == "" | "`rhs'" == "," {
		c_local `adjtype' "khartung"	
	}
	else {
		local 0 `rhs'
		syntax [, TRUNCated *]
		if "`options'" != "" {
			di as err "{p}in option {bf:se()}: " ///
			"suboption {bf:`options'} is not allowed{p_end}"
			exit 198
		}
		if !missing("`truncated'") {
			c_local `adjtype' "tkhartung"
		}
	} 
end
