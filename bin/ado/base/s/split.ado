*! version 2.0.6  04mar2015
program define split, rclass
	version 8
	syntax varname(str) [if] [in] /*
	*/ [, Generate(str) noTrim Parse(str asis) DESTRING /*
	*/ force float Ignore(string asis) percent Limit(numlist int >0 max=1) ]

	local verpre : display "version " %4.1f _caller() ":"

	* check for errors in specifying -destring- options without using -destring-
	if "`destring'"=="" {
		foreach option in force float ignore percent {
			if `"``option''"'!="" {
				display as error "may not specify `option' without specifying destring"
				exit 198
			}
		}
	}
	else {
		if `"`ignore'"'!="" {
			if _caller() >= 14 {
				if ustrfindfirst(`"`ignore'"',",") & ///
				  !ustrfindfirst(`"`ignore'"',`"""')  { // " required if , used
					display as error `"ignore string must be enclosed with quotes to ignore commas or use options"'
					exit 198
				}
			}
			`verpre' _parse_ignore `ignore'
		}
	}
	
	* observations to use
	marksample touse, strok
	qui count if `touse'
	if r(N) == 0 {
		error 2000
	}

	* parsing on spaces by default, otherwise words of -parse()-

	if `"`parse'"' == `""' | `"`parse'"' == `""""' {
		if "`trim'" != "" {
			di as err "parsing on spaces incompatible with notrim"
			exit 198
		}
		local parse `"" ""'
		local trm "trim"
	}
	if `"`parse'"' == `""' | `"`parse'"' == `""""' {
		local parse `"" ""'
		local trm "trim"
	}
	local nparse : word count `parse'
	tokenize `"`parse'"'

	* initial check that generate() is valid name (will be used as stub)
	if `"`generate'"' != "" {
		* check it is a valid name
		confirm name `generate'
		* only 1 word allowed
		if `: word count `generate'' > 1 {
			di as err "invalid stub `generate'"
			exit 198
		}
	}

	* set up variables
	* vw = variable worked on
	* tp = position of this parse string
	* mp = minimum position of parse string(s)
	* pl = parse string length
	qui {
		tempvar vw tp mp pl
		gen int `tp' = 0
		gen int `mp' = 0
		gen int `pl' = 0

		gen str1 `vw' = ""
		if "`trim'" == "" {
			replace `vw' = trim(`varlist') if `touse'
		}
		else {
			replace `vw' = `varlist' if `touse'
		}
	}

	* initialize macros for main loop
	if "`generate'" == "" {
		local generate "`varlist'"
	}
	local j = 0
	local go = 1
	if "`limit'" == "" {
		local limit .
	}

	* main loop: try to chop at parse strings
	qui while `go' & `j' < `limit' {
		replace `mp' = .
		replace `pl' = 0
		forval i = 1 / `nparse' {
			replace `tp' = index(`vw', `"``i''"')
			replace `mp' = min(`tp', `mp') if `tp'
			replace `pl' = length(`"``i''"') if `mp' == `tp'
		}
		local ++j
		tempvar part`j'
		gen str1 `part`j'' = ""
		replace `part`j'' = substr(`vw', 1, `mp'-1) if `mp' < .
		replace `vw' = `trm'(substr(`vw', `mp'+`pl', .)) if `mp' < .
		replace `part`j'' = `vw' if `mp' >= .
		replace `vw' = "" if `mp' >= .
		local newvars "`newvars'`generate'`j' "
		capture assert `vw' == ""
		local go = _rc
	}

	* are new variable names OK?
	* it is late in the day to check for possibly fatal error,
	* but only now do we know which new variables needed
	capture confirm new var `newvars'
	if _rc {
		di as err "cannot generate new variables using stub `generate'"
		exit _rc
	}

	* -generate- new variables
	qui forval i = 1 / `j' {
		gen str1 `generate'`i' = ""
		replace `generate'`i' = `part`i''
	}

	* say what we have -generated-
	return local varlist "`newvars'"
	return local nvars "`j'"
	local s = cond(`j' > 1, "s", "")
	if "`destring'" != "" {
		di as res "variable`s' born as string: "
	}
	else di as res "variable`s' created as string: "
	ds `newvars'

	* -destring- if desired
	if "`destring'" != "" {
		if `"`ignore'"' != "" {
			local ignore `"ignore(`ignore')"'
		}
		`verpre' destring `newvars', replace `force' `float' `ignore' `percent'
	}
end

