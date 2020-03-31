*! version 1.0.0  26apr2019

program meta__validate_esize, sclass
	version 16
	
	syntax, [DType(string) EStype(string) EFORM1 or rr EForm(string)]
	
	sreturn clear
	
	_parse comma lhs rhs : estype
	if `"`rhs'"'!=`""' {
		local l = strlen("`lhs'")
		local 0 `rhs' // contains comma
		if "`lhs'"=="rmd" | ///
		  "`lhs'"==bsubstr("unstandardized", 1, max(3,`l')) | ///
			"`lhs'"== bsubstr("mdiff", 1, max(2,`l')) {	
			cap noi syntax, [ UNEqual]
			local rc = c(rc)
			if `rc' {
				di as err "invalid option {bf:esize()}" 
				exit `rc'
			}
			sreturn local unequal `unequal'

		}
		else if "`lhs'" == bsubstr("hedgesg", 1, max(3,`l')) {
			cap noi syntax, [ HOLKINse EXact]
			local rc = c(rc)
			if `rc' {
				di as err "invalid option {bf:esize()}" 
				exit `rc'
			}
			
			if !missing("`exact'") {
				sreturn local hedgesexact `exact'
			}
			sreturn local holkinse `holkinse'
		}
		else if "`lhs'" == bsubstr("cohend", 1, max(3,`l')) | ///
			"`lhs'" == bsubstr("cohensd", 1, max(3,`l')) {
			cap noi syntax, [ HOLKINse ]
			local rc = c(rc)
			if `rc' {
				di as err "invalid option {bf:esize()}" 
				exit `rc'
			}
			sreturn local holkinse `holkinse'
		}
		else {
			gettoken comma rest : rhs, parse(", ")
			di as err "{p}invalid option {bf:esize()}; " ///
			  "suboption {bf:`rest'} is not allowed with " ///
			  "{bf:`lhs'}{p_end}"
			exit 198  
		} 
	}
	local 0, `lhs'
	if "`dtype'" == "continuous" {
		syntax, [ cohend GLAssdelta glassdelta1 glassdelta2 ///
			HEDgesg COHensd rmd MDiff UNStandardized *]
		char _dta[_meta_datatype] "continuous"	
	}
	if "`dtype'" == "binary" {
		syntax, [  LNORatio lnorpeto LNRRatio RDiff *]
		char _dta[_meta_datatype] "binary"
	}

	
	local which `lnoratio' `lnorpeto' `lnrratio' `rdiff' `cohend' `cohensd' 
	local which `which' `glassdelta' `hedgesg' `mdiff'
	local which `which' `glassdelta1' `glassdelta2' `unstandardized' `rmd'
	local k : word count `which'
	if `k' > 1 {
		if "`dtype'" == "binary" {
			di as err "{p}invalid {bf:esize()} specification: "  ///
			"only one of {bf:lnoratio}, {bf:lnrratio}, " ///
			"{bf:rdiff}, or {bf:lnorpeto} may be specified{p_end}"
			exit 184
		}
		if "`dtype'" == "continuous" {
			di as err "{p}invalid {bf:esize()} specification: "  ///
			"only one of {bf:hedgesg}, {bf:cohend}, " 	    ///
			"{bf:glassdelta2}, {bf:glassdelta1}, or {bf:mdiff} " ///
			"may be specified{p_end}"
			exit 184
		}	
	}
	if !`k' {
		if "`options'" != "" {
			gettoken op options : options, bind
			if "`dtype'" == "binary" {
di as err "{p}invalid {bf:esize()} specification: specify {bf:lnoratio}, " ///
	"{bf:lnrratio}, {bf:rdiff}, or {bf:lnorpeto}{p_end}"
exit 184
			}
			if "`dtype'" == "continuous" {
di as err "{p}invalid {bf:esize()} specification: specify {bf:hedgesg}, " ///
	"{bf:cohend}, {bf:glassdelta2}, {bf:glassdelta1}, or {bf:mdiff}{p_end}"
exit 184
			}
			
		}
		local which = cond("`dtype'" == "continuous", "hedgesg", ///
			cond("`dtype'" == "binary", "lnoratio", "ES"))
	}
	else {
		local which : list retokenize which
	}
	
	if "`which'" == "unstandardized" local which rmd
	
	     if "`which'"=="lnoratio" local eslab=cond("`eform1'"=="", ///
		"Log Odds-Ratio", "Odds Ratio")
        else if "`which'"== "lnrratio" local eslab = cond("`eform1'"=="", ///
		"Log Risk-Ratio", "Risk Ratio")
        else if "`which'"== "rdiff" local eslab = "Risk Diff."
        else if "`which'"== "lnorpeto" local eslab = cond("`eform1'"=="", ///
		"Log Peto's OR", "Peto's OR")
        else if inlist("`which'","cohend","cohensd") local eslab = "Cohen's d"
        else if "`which'"== "hedgesg" local eslab = "Hedges's g"
	else if "`which'" == "glassdelta" | "`estype'" == "glassdelta2" {
		local eslab = "Glass's Delta2"
	}
	else if "`which'" == "glassdelta1" {
		local eslab = "Glass's Delta1"
	}
	else if inlist("`which'","rmd","mdiff") local eslab = "Mean Diff."
	else {
		local esl : char _dta[_meta_eslabel]
	
		if "`esl'"!="Effect Size" {
			local eslab = cond("`eform1'"=="","`esl'","exp(`esl')")
		}
		else {
			local eslab = cond("`eform1'"=="", "Effect Size", ///
				"exp(ES)")	
		}
	}
	
	sreturn local estype `which'
	sreturn local eslab `eslab'
end

