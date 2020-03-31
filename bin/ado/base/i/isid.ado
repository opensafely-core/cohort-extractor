*! version 1.0.5  29oct2019
program define isid
	version 7

	foreach word of local 0 {
		if `"`word'"' == "using" {
			Isid_using `0'
			local break break
			continue, break
		}
	}
	if "`break'" != "" {
		exit
	}

	syntax varlist [, Sort Missok ]
	CheckId "`varlist'" "`missok'"
	if "`sort'" != "" {
		CheckAlreadySorted "`varlist'"
		if r(sorted) {
			di as txt `"(data already sorted by {bf:`varlist'})"'
		}
		else {
			sort `varlist'
			di as txt `"(data now sorted by {bf:`varlist'})"'
		}
	}

	CheckStrings "`varlist'" "`missok'"
end


program define CheckId, sortpreserve
	args varlist missok

	CheckUniq "`varlist'" "`missok'"
end


program define CheckUniq
	args varlist missok

	if "`missok'" == "" {
		tempvar touse
		gen byte `touse' = 1
		markout `touse' `varlist', strok
		qui count if `touse'
		if r(N) < _N {
			local n : word count `varlist'
			local var = cond(`n'==1, "variable", "variables")
			di as err "`var' {bf:`varlist'} should never be missing"
			exit 459
		}
	}

	sort `varlist'
	capture by `varlist' : assert _N==1
	if _rc {
		if _rc == 1 { exit 1 }
		local n : word count `varlist'
		local var  = cond(`n'==1, "variable", "variables")
		local does = cond(`n'==1, "does", "do")
		di as err /*
		   */ "`var' {bf:`varlist'} `does' not uniquely identify the observations"
		exit 459
	}
end


program define Isid_using
	version 7

	gettoken name rest : 0
	while `"`name'"' != "using" {
		gettoken name 0 : 0
		local vars `vars' `name'
		gettoken name rest : 0
		local hasname TRUE
	}
	if "`hasname'" == "" {
		di as err "{it:varlist} required"
		exit 100
	}
	syntax using/ [, Sort Missok]
	local myusing `"`using'"'

	preserve
	quietly use `"`myusing'"', clear
	local 0 `"`vars'"'
	syntax varlist

	CheckAlreadySorted "`varlist'"
	local sorted = r(sorted)
	if !(`sorted') {
		sort `varlist'
	}

	CheckUniq "`varlist'" "`missok'"
	CheckStrings "`varlist'" "`missok'"
	if "`sort'" != "" {
		if !(`sorted') {
			qui save, replace
			di as txt `"($S_FN now sorted by {bf:`varlist'})"'
		}
		else	di as txt `"($S_FN already sorted by {bf:`varlist'})"'
	}
end


program define CheckAlreadySorted, rclass
	args varlist

	local list : sortedby
	local i 1
	local sorted 1
	foreach name of local varlist {
		local sname : word `i' of `list'
		if "`name'" != "`sname'" {
			local sorted 0
			continue, break
		}
		local i = `i' + 1
	}
	return scalar sorted = `sorted'
end


// check whether uniqueness is due to leading/trailing whitespace in strings
// use -ustrtrim()- to include tab, newline, vert tab, and CR as whitespace
program define CheckStrings
	args varlist missok

	foreach name of local varlist {
		capture confirm string variable `name'
		if _rc > 0 {
			local okvars `okvars' `name'
		}
		else {
			tempvar trimnam
			qui generate `:type `name'' `trimnam' = ustrtrim(`name')
			capture assert `name' == `trimnam'
			if _rc == 0 {
				local okvars `okvars' `name'
			}
			else {
				local spvars `spvars' `name'
				local trvars `trvars' `trimnam'
			}
		}
	}

	if "`spvars'" != "" {
		capture CheckUniq "`okvars' `trvars'" "`missok'"
		if _rc {
			if _rc == 1 { 
				exit 1 
			}
			local n : word count `varlist'
			local var  = cond(`n'==1, "Variable", "Variables")
			local ids = cond(`n'==1, "identifies", "identify")
			local ns : word count `spvars'
			local svar  = cond(`ns'==1, "variable", "variables")
			display as txt "{p 0 6 2}"			    /*
*/ "note: `var' {bf:`varlist'} uniquely `ids' the observations but only "   /*
*/ "because of the presence of leading or trailing blank spaces in string " /*
*/ "`svar' {bf:`spvars'}. To trim leading and trailing blank spaces, use "  /*
*/ `"function {help "ustrtrim()"}.{p_end}"'
		}
	}
end
exit
