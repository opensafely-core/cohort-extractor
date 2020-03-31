*! version 1.1.0  30jan2020

program meta__eform_err
	version 16
	
	syntax [, EFORM1 EForm(string) or rr transform(string)]
		
	local ef = subinstr(`"`eform'"', " ", "_", .)
	local tr = subinstr(`"`transform'"', " ", "_", .)

	local msg "{p 4 4 2}only one of options {bf:eform()}, {bf:eform}, " ///
		"{bf:or}, {bf:rr}, or {bf:transform()} may be specified" ///
		"{p_end}"
	
	local which `"`ef' `eform1' `rr' `or' `tr'"'
	// if  (`:word count `which'' > 1) {
	if  (wordcount(`"`which'"') > 1) {
		local which : list retokenize which
		local which : subinstr local which "eform1" "eform"
		if !missing(`"`tr'"') {
			local which : subinstr local which ///
				`"`tr'"' `"transform(`transform')"'
		}
		if !missing(`"`ef'"') {
			local which : subinstr local which ///
				`"`ef'"' `"eform(`eform')"'
		}
		di as err `"{p}options {bf:`which'} may not be combined{p_end}"'
		di as err "`msg'"
		exit 184	  
	}
	
	syntax [, EFORM1 EForm(string) or rr TRANSForm(string)]
	
	local estyp : char _dta[_meta_estype]
	local dtype : char _dta[_meta_datatype]
	
	
	local eformopt = cond(`"`eform1'`eform'"' == "`eform1'",`"eform"', ///
		"eform()")
	
	if !missing(`"`eform1'`eform'"') {		
		if "`dtype'" == "continuous" {
			di as err "option {bf:`eformopt'} is not valid " ///
				"with continuous data"	
			exit 198
		}
		else if ("`dtype'" == "binary" & "`estyp'" == "rdiff") {
			di as err "option {bf:`eformopt'} is not valid " ///
				"when the effect size is risk difference"	
			exit 198
		}
	}
	
	if !missing("`or'") & "`estyp'" != "lnoratio" {			
		di as err "{p}option {bf:or} may only be specified " ///
			"when the effect size is log odds-ratio" ///
			"{p_end}"
		exit 198		
	}
	if !missing("`rr'") & "`estyp'" != "lnrratio" {			
		di as err "{p}option {bf:rr} may only be specified " ///
			"when the effect size is log risk-ratio" ///
			"{p_end}"
		exit 198		
	}
end
