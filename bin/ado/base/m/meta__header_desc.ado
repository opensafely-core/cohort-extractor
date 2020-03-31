*! version 1.0.1  22oct2019
program meta__header_desc, rclass
	version 16
	syntax, [ ANALtyp(string) nobs(string)		///
		  tau2(string) i2(string) h2(string)	///
		  model(string) METHod(string)		///
		  eslab(string) col(real 43) 		///
		  SUBGRoup(string) CUMULative(string)	///
		  se(string) fixparam(string) wgt(string) sortvar(string)]
	
	local meta = cond(missing("`analtyp'"), "Meta", "meta")
	di _n as txt strltrim("`analtyp' `meta'-analysis summary") ///
		_col(`col') "Number of studies = " as res %6.0f = `nobs' 
	
	local lnsz = c(linesize)-1
	
	// display het stats
	if "`model'"!= "common" & missing("`subgroup'`cumulative'") {
		local heterttl `"_col(`col') "Heterogeneity:" "'	
local i2info `"_col(`=`col'+ 10') "I2 (%) = " as res %7.2f `i2' "'
local h2info `"_col(`=`col'+ 14') "H2 = " as res %7.2f `h2' "'
		if "`model'"=="random" {
local tau2info `"_col(`=`col'+ 12') "tau2 = " as res %7.4f `tau2'"'	
		}
		else {	// display only i2 and h2
			local tau2info `"`i2info'"'
			local i2info `"`h2info'"'
			local h2info ""
		}
	}
	
	if !missing("`fixparam'") local fixparam=cond("`fixparam'" == "i2", ///
		"I2", "tau2")
	
	// model and method descriptions
	local moddesc = cond("`model'" == "common", "Common-effect model", ///
			cond("`model'"=="fixed", "Fixed-effects model", ///
			"Random-effects model"))	
	
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

	return hidden local moddesc `"`moddesc'"'
	return hidden local methdesc `"`methdesc'"'
	
	if missing("`eslab'") local eslab : char _dta[_meta_eslabel]
	
	if !missing("`se'") {
		local adjtyp = cond("`se'"=="khartung", "Knapp-Hartung", ///
			"Truncated Knapp-Hartung")
		local SEadjText `"as txt "SE adjustment: `adjtyp'" "' 
	}
	
	di as txt "`moddesc'" as txt `heterttl'
	
	if "`model'"!="random" & !missing("`wgt'") {
		di as txt "Weights: " as res "`wgt'" as txt `tau2info'
		local user "; User-specified weights by variable {bf:`wgt'}"
		local method 
		local methdesc ""
		local space ""
	} 
	else {
		di as txt  "Method: " as txt "`methdesc' " ///
		as res "`fixparam'" as txt `tau2info'
	}
	
	
	if "`model'"!= "common" & missing("`subgroup'`cumulative'") {
		di `SEadjText' as txt `i2info'
		di as txt `h2info'
	}
	if !missing("`wgt'") & "`model'" == "random" {
		di as txt "Weights: " as res "`wgt'"
		local user "; User-specified weights by variable {bf:`wgt'}"
	}
	
	if !missing("`subgroup'") di as txt ///
		"{p 0 7 0 `lnsz'}Group: {res}`subgroup'{p_end}"
	
	if !missing("`cumulative'") {	
		_parseCumul ordervar byvar direction : `"`cumulative'"'
		if missing("`direction'") local direction ascending
		if "`direction'"=="descending" {
local extra `"as txt " (" as res "descending" as txt ")""'
		}
		di as txt "Order variable: " as res "`ordervar'" `extra'
				
		if !missing("`byvar'") {			
			di as txt "Stratum: " as res "`byvar'"
		}
	}
	
	// for forest plot
	local space " "
	local moddesc = cond("`model'" == "common", "Common-effect", ///
			cond("`model'"=="fixed", "Fixed-effects", ///
			"Random-effects"))
	
	if inlist("`method'","invvariance","ivariance") {
		local methdesc = "inverse-variance"
	}
	else if "`method'" == "ebayes" local methdesc = "empirical Bayes"
	else if "`method'" == "sa" {
		local user = cond("`fixparam'" == "I2", ///
				"; User-specified I{sup:2}", ///
				"; User-specified {&tau}{sup:2}")
		local methdesc
		local space ""
	}		
	
	if !missing("`sortvar'") local note2 `"Sorted by: `sortvar'"'
	if !missing("`se'") {
		local note2 "`adjtyp' standard errors" 
		if !missing("`sortvar'") local note3 ///
			`"Sorted by: `sortvar'"'
	}
	
	local note1 "`moddesc'`space'`methdesc' model`user'"
	local note1 : list retokenize note1
	return hidden local note `""`note1'"  "`note2'" "`note3'""'
end

program _parseCumul
	args ordervar byvar direction colon cumulspec
	
	_parse comma lhs rhs : cumulspec
	local 0 `lhs'
	cap syntax varname(numeric)
	local rc = _rc
	if _rc {
		di as err "in option {bf:cumulative()}: " _c
		error `rc'
	}
	c_local `ordervar' "`varlist'"

	if "`rhs'" == "" | "`rhs'" == "," {
		c_local `byvar' ""	
	}
	else {
		local 0 `rhs'
		syntax [, by(varname) ASCending DESCending *]
		if "`options'" != "" {
			di as err "in option {bf:cumulative()}: " _c
			di as err "option {bf:`options'} is not allowed"
			exit 198
		}
		if !missing("`by'") {
			cap confirm variable `by'
			if _rc {
				di as err "{p}in option {bf:cumulative()}: " ///
				  "variable {bf:`by'} not found in " ///
				  "suboption {bf:by()}{p_end}" 
				exit _rc
			}
			else if `: word count `by'' > 1 {
				di as err "invalid option {bf:by()}: too " ///
				" many variables specified"
				exit 103
			}
			c_local `byvar' "`by'"
		}
		
		c_local `direction' "`ascending'`descending'"
	} 
end

