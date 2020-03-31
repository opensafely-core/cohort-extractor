*! version 1.0.0  02may2019

program define meta__parse_cctyp, sclass
	version 16
	syntax, [cc(string) es(string) name(string)]
	
	local zcopt : char _dta[_meta_zcopt]
	
	
	if !inlist("`es'", "lnoratio", "lnrratio") & !missing("`cc'") {
			if inlist("`es'", "lnorpeto", "rdiff") {				
				di as txt "note: zero-cells " ///
				"adjustment ignored"
			}
			else {
				di as err "{p}option {bf:`name'()} is not " ///
				"allowed with effect size {bf:`es'}{p_end}"
				exit 184
			}
					
	}
	
	local msg "{p 4 4 2}zero-cell adjustment in option {bf:`name'()} " 
	local msg `"`msg' must be a number in [0,1), or one of "'
	local msg `"`msg' {bf:tacc} or {bf:none}{p_end}"'

	local pos = ustrpos("`cc'",",")
	if `pos' > 0 {
		local l = strlen("`cc'")
		local lhs = usubstr("`cc'", 1, `=`pos'-1')
		local rhs = usubstr("`cc'", `pos', `l')
	}
	else {
		local lhs `cc'
		local rhs
	}	 

	if missing("`lhs'") local lhs 0.5 // -cc()- unspecified - use default

	sreturn clear
	cap confirm number `lhs'
	if _rc {
		if !inlist("`lhs'", "tacc", "tacc2", "none") {
			di as err "invalid {bf:`lhs'} in option {bf:`name'()}"
			di as err `"`msg'"'
			exit 198
		}
		else {   // DO NOT use if "`es'"!="oratio" { 
			if "`es'"=="lnrratio" & "`lhs'" != "none" { 
				/*
				di as txt "{p 0 6 2}"			  ///
				"note: zero-cells adjustment ignored;" 	  ///
				" zero-cell adjustment method {bf:`lhs'}" ///
				" is only available with "		  ///
				"{bf:esize(lnoratio)}{p_end}"
				*/
				di as err "option {bf:`name'()} invalid"
				di as err "{p 4 4 2}zero-cell adjustment " ///
				"method {bf:`lhs'} is only available with " ///
				"{bf:esize(lnoratio)}.{p_end}"
				exit 198
				
			}
			local ccm `lhs'
			local lhs .5
			sreturn local ccmethod `ccm'
		}
		
	}
	else {
		cap assert (`lhs'>=0) & (`lhs'<1)
		if _rc {
			di as err `"`msg'"'
			exit _rc
		}
	}
	local 0 `rhs'
	syntax, [  only0 all allif0 *]
	
	local which `only0' `all' `allif0' // `none'
						   	
	
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:`name'()} specification: "  ///
		 "only one of {bf:only0} or {bf:allif0} "      ///
		 "can be specified{p_end}"
		exit 184
	}
	if !`k' {
		if `"`options'"' != `""' {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:`name'()} specification: " ///
		 	 "zero-cell adjustment type {bf:`op'} not " ///
			 "allowed{p_end}"
			exit 198
		}
		local which only0
	}
	else {	// k = 1	
		if `"`options'"' != `""' {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:`name'()} specification: " ///
		 	 "zero-cell adjustment type {bf:`op'} not " ///
			 "allowed{p_end}"
			exit 198
		}
		local which : list retokenize which
		if !missing("`ccm'") {
			di as err "invalid option {bf:`name'()} specification"
			di as err "{p 4 4 2}zero-cell adjustment method " ///
			"{bf:`ccm'} may not be combined with adjustment " ///
			"type {bf:`which'}. " ///
			"Syntax for option {bf:`name'()} is:" ///
			" {bf:`name'({it:#}, {it:zcadj} | {bf:tacc})}" ///
			".{p_end}"
			exit 198
		}
	}
	sreturn local cctyp `which'
	sreturn local cc `lhs'	
end
