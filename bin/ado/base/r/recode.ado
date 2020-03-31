*! version 3.5.3  20jan2015
program define recode
	version 8

// first parse into (1) -vlist- (2) -vrules- (3) if/in (4) options

	#del ;
	syntax  anything(equalok name=vrules id="varlist (rule)..")
	        [if] [in]
	[,
		COPYrest
		DEBUG 		// undocumented
		Generate(str)
		INto(str)       // synonym for generate()
		Label(str)
		PREfix(str)
		Test
	] ;
	#del cr
// spec syntax 1: varname rule [rule]   ...
// spec syntax 2: varlist (rule) (rule) ...
	gettoken tok1 tmp : vrules , parse("(")
	gettoken tok2 : tmp, parse("(")
	if `"`tok1'"' == "(" {
		error 102
	}

	if trim(`"`tok2'"') == "(" {
		// syntax 1: tok1 is varlist, tmp is a list of parenthesized rules
		unab vlist : `tok1'
		local nvlist : word count `vlist'
		local rules `"`tmp'"'
		local parens = 1
	}
	else {
		gettoken vn rules : vrules
		unab vlist  : `vn', max(1)
		local nvlist = 1
		local parens = 0
	}

	capture confirm string var `vlist'
	if _rc==0 {
		Error 108 "recode only allows numeric variables"
	}

	if `"`rules'"' == "" {
		Error 198 "rules expected"
	}

// check the options

	marksample touse, novarlist
	if `"`prefix'"' != "" {
		if `"`generate'`into'"' != "" {
			Error 198 "option prefix() may not be combined with generate() or into()"
		}
		GenerateVar `"`prefix'"' `"`vlist'"'
		local generate `r(pvlist)'
	}
	else {
		if `"`generate'"' != ""  &  `"`into'"' != "" {
			Error 198 "options generate() and into() are synonyms"
		}
		if `"`into'"' != "" {
			local generate `"`into'"'
			local into
		}
		if `"`generate'"' != "" {
			confirm new var `generate'
			local nnew : word count `generate'
			if `nvlist' != `nnew' {
				Error 198 "the number of new and transformed varnames should be the same"
			}
		}
	}

	// labeldisallowed
	//   0  value labels ok
	//   1  not allowed; multiple vars require label()
	//   2  not allowed; input vars overwritten
	//   3  not allowed; impossible to create label() named after variable

	if `"`label'"' != "" {
		if "`generate'" == "" {
			Error 198 "option label() allowed only with generate()"
		}
		confirm name `label'
		local labeldisallowed = 0
	}
	else if "`generate'" != "" {
		if `nvlist' == 1 {
			// does a value label named `generate' already exist
			capture label dir `generate'
			if _rc {
				local label `generate'
				local labeldisallowed = 0
			}
			else {
				local labeldisallowed = 3
			}
		}
		else {
			local labeldisallowed = 1
		}
	}
	else {
		local labeldisallowed = 2
	}

	local Qtest = "`test'" != ""

// Rules are stored in a series of macros
//
//	lhs[i]		from value or from-range
//	rhs[i]		index to to-values
//	rrhs[j]		to-value for j-th rule
//	vlabel[j]	value label associated with j-th to-value

	tokenize `"`rules'"', parse(" ()/=")
	if `parens' {
		mac shift
	}

	local i = 0
	local j = 1
	local nolhs = 1
	local vlabeled = 0

	tempname statcode
	scalar `statcode' = 0

 	while !inlist(`"`1'"', "", "*", "else") & ///
 	  `"`1'"' != bsubstr("missing", 1, max(3,length(`"`1'"'))) & ///
 	  `"`1'"' != bsubstr("nonmissing", 1, max(4,length(`"`1'"'))) {

		if `"`1'"' == "=" {

			// get rrhs = "to-value" [value-label]

			if `nolhs' {
				Error 198 `"transformation rule without "condition" part"'
			}
			mac shift
			GetEl  `"`1'"'  `statcode'
			local rrhs`j' `r(s1)'
			mac shift

			if `parens' {
				if `"`1'"' != ")" & `"`2'"' == ")" {
					LabelOk `labeldisallowed' `"`rrhs`j''"'
					local vlabeled 1
					local vlabel`j' `"`1'"'
					mac shift
				}
				CheckParens `"`1'"' `"`2'"'
				mac shift 2
			}

			local nolhs 1
			local ++j
		}
		else {

			// condition parts of rules

			local ++i
			local rhs`i' `j'
			GetEl  `"`1'"'  `statcode'
			if `"`2'"' == "/" {
				local vlow `r(s1)'
				mac shift 2

				GetEl  `"`1'"'  `statcode'
				local vhigh `r(s1)'

				// notes: - we use delayed substitution of -vn-
				//        - special rules are defined for floats
				local flhs`i' "float(\`vn') >= float(`vlow') & float(\`vn') <= float(`vhigh')"
				local  lhs`i' "\`vn' >= `vlow' & \`vn' <= `vhigh'"
			}
			else {
				local flhs`i' "float(\`vn')==float(`r(s1)')"
				local  lhs`i' "\`vn'==`r(s1)'"
			}
			local nolhs = 0
			mac shift
		}
	}
	if `nolhs' == 0 {
		error 198
	}
	local nlhs = `i'
	local nrhs = `j'- 1

// parse the "otherwise" rules
//
//	{ * | else } = #
//	[missing = #]  [nonmissing = #]

	while `"`1'"' != "" {
		local key `1'
		if `"`key'"' == "*" {
			local key else
		}
 		else if `"`key'"' == bsubstr("missing",1,max(3,length(`"`key'"'))) {
 			local key missing
 		}
 		else if `"`key'"' == bsubstr("nonmissing",1,max(4,length(`"`key'"'))) {
 			local key nonmissing
 		}
 		if !inlist(`"`key'"', "else", "missing", "nonmissing") {
			Error 198 `"unknown keyword `key'"'
		}
		if `"`rrhs_`key''"' != "" {
			Error 198 `"multiple specification of keyword `key'"'
		}
		if `"`2'"' != "=" {
			Error 198 `"= expected"'
		}

		GetEl `"`3'"'  `statcode'
		local rrhs_`key' `r(s1)'
		mac shift 3

		if `parens' {
			if `"`1'"' != ")" & `"`2'"' == ")" {
				LabelOk `labeldisallowed' `"`rrhs_`key''"'
				local vlabeled 1
				local vlabel_`key' `"`1'"'
				mac shift
			}
			CheckParens `"`1'"' `"`2'"'
			mac shift 2
		}
	}

	if `"`rrhs_else'"' != "" & `"`rrhs_missing'`rrhs_nonmissing'"' != "" {
		Error 198 "keywords else/* and missing/nonmissing may not be combined"
	}

// display rules

	if "`debug'" != "" {
		local vn  varname

		di _n as txt "There are `nlhs' lhs rules:"
		forvalues i = 1 / `nlhs' {
			di as txt "  `lhs`i'' -> RULE `rhs`i''"
		}
		di _n as txt "There are `nrhs' rhs rules:"
		forvalues j = 1 / `nrhs' {
			di as txt "    RULE `j':  `rrhs`j''  `vlabel`j''"
		}

 		di _n as txt `"      else: `rrhs_else'  `vlabel_else'"'
 		di    as txt `"   missing: `rrhs_missing'  `vlabel_missing'"'
 		di    as txt `"nonmissing: `rrhs_nonmissing'  `vlabel_nonmissing'"'
	}

// apply the transformation rules

	quietly {
		tempvar OTHERWISE

		local iv = 0
		local overwrite

		foreach vn of local vlist {
			local ++iv

			tempvar NEW`iv'
			gen double `NEW`iv'' = `vn' if `touse'

			capt drop `OTHERWISE'
			gen byte `OTHERWISE' = cond(`touse'==1,1,.)

			local vntype`iv' : type `vn'

			// determine if the -floatrules- should be used
			local float
			if !inlist("`vntype`iv''", "double", "long") {
				local float f
			}

			if `statcode' == 1 {
				// the rules reference r(min), r(max), r(mean)
				summ `vn' if `touse', meanonly
				if "`r(max)'" == "" {
					local nchanges`iv' = 0
					replace `NEW`iv'' = `vn' if `touse'==0
					continue	
				}
			}
			else if `statcode' == 2 {
				// the rules reference r(Var), r(sd)
				summ `vn' if `touse'
			}
			else if `statcode' == 3 {
				// the rules reference r(skewness), r(median) etc
				summ `vn' if `touse', detail
			}

			// beware: ensure that r() is not overwritten
			// before end of transformation

			forvalues i = 1 / `nlhs' {
				replace `NEW`iv'' = `rrhs`rhs`i''' ///
					if `OTHERWISE'==1 & ``float'lhs`i''

				if `Qtest' {
					// Qcount replaces -count-: does not destroy r()
					// do rules overlap?
					Qcount N : `"`OTHERWISE'==0 & ``float'lhs`i''"'
					if `N' > 0 {
						local overwrite = 1
						local used`i'   = 1
					}
					else {
						// does rule ever apply?
						Qcount N : `"`OTHERWISE'==1 & ``float'lhs`i''"'
						if `N' > 0 {
							local used`i' = 1
						}
					}

				}
				replace `OTHERWISE' = 0 if `OTHERWISE'==1 & ``float'lhs`i''
			}

			// we do not verify whether OTHERWISE rules trigger
			// unused OTHERWISE rules not produce warning
			if "`rrhs_else'" != "" {
				replace `NEW`iv'' = `rrhs_else'  if `OTHERWISE'==1
			}
			if "`rrhs_missing'" != "" {
				replace `NEW`iv'' = `rrhs_missing' ///
					if `OTHERWISE'==1 & missing(`vn')
			}
			if "`rrhs_nonmissing'" != "" {
				replace `NEW`iv'' = `rrhs_nonmissing' ///
					if `OTHERWISE'==1 & !missing(`vn')
			}
			// -- transformation complete

			if "`float'" != "" {
				count if `touse' & (float(`vn') != float(`NEW`iv''))
			}
			else {
				count if `touse' & ((`vn') != (`NEW`iv''))
			}
			local nchanges`iv' = r(N)

			if "`copyrest'" != "" | "`generate'" == "" {
				replace `NEW`iv'' = `vn' if `touse'==0
			}
		}
	} /* quietly */


// report on transformations

	local iv = 0
	foreach vn of local vlist {
		local ++iv
		if `"`generate'"' == "" {
			di as txt "(`vn': `nchanges`iv'' changes made)"
		}
		else {
			local gv : word `iv' of `generate'
			di as txt "(`nchanges`iv'' differences between `vn' and `gv')"
		}
	}

	if `Qtest' {
		if "`overwrite'" != "" {
			di as txt `"(transformation rules "overlapped")"'
		}
		forvalues i = 1/`nlhs' {
			if "`used`i''" == "" {
				di as txt "(one or more transformation rules did not match any values)"
				continue, break
			}
		}
	}

// now make changes final

	nobreak quietly {
		if `vlabeled' {
			forvalues j = 1/ `nrhs' {
				if `"`vlabel`j''"' != "" {
					label def `label' `rrhs`j'' `"`vlabel`j''"', modify
				}
			}
			foreach key in else missing nonmissing {
				if `"`vlabel_`key''"' != "" {
					label def `label' `rrhs_`key'' `"`vlabel_`key''"', modify
				}
			}
		}

		if "`generate'" != "" {
			local iv = 0
			foreach vn of local vlist {
				local ++iv
				local g : word `iv' of `generate'
				gen `g' = `NEW`iv''
				recast `vntype`iv'' `g'

				// set varlabel (truncation if too long is automatic)
				local vlab : variable label `vn'
				if `"`vlab'"' != "" {
					local vlab `" (`vlab')"'
				}
				label var `g' `"RECODE of `vn'`vlab'"'

				if `vlabeled' {
					label value `g' `label'
				}
			}
		}
		else {
			local iv 0
			foreach vn of local vlist {
				local ++iv
				replace `vn' = `NEW`iv''
				// should varlabel be changed ?
			}
		}
	}
end


/* GetEl value statcode

   returns in r(s1)
     -statname-      if value is the name of a supported statistic
     value           if value is a valid missing value code
     value           if it is a valid number
   otherwise
     displays an error message

   GetEl increases statcode to the highest "level of summarize"
   needed to obtain all requested statistics.
     statcode = 0    none
     statcode = 1    summ, meanonly
*/
program define GetEl, rclass
	args v statcode

	capt confirm number `v'
	if !_rc {
		return local s1 `v'
		exit
	}
	else if `"`v'"' == "." {
		return local s1 "."
	}
	else if length(`"`v'"')==2  &  `"`v'"' >= ".a" & `"`v'"' <= ".z"{
		return local s1 `v'
	}
	else if inlist(`"`v'"', "max", "min") {
		return local s1 "r(`v')"
		scalar `statcode' = max(`statcode',1)
	}
	else {
		di as err `"unknown el `v' in rule"'
		exit 198
	}
end


/* Error nr txt
   displays error message txt and exit with nr
*/
program define Error
	args nr txt

	dis as err `"{p}`txt'{p_end}"'
	exit `nr'
end


program define LabelOk
	args labeldisallowed value

	if `labeldisallowed' == 1 {
		local msg Rules defining value labels not allowed{break}with ///
		          labeled recode of multiple vars, option label() required
		Error 198 `"`msg'"'
	}
	if `labeldisallowed' == 2 {
		Error 198 "Rules defining value labels not allowed when overwriting a variable"
	}
	if `labeldisallowed' == 3 {
		Error 198 "impossible to create label() named after variable"
	}
	if `value' == . {
		Error 198 "Value label not allowed for missing value code ."
	}
	if `value' != int(`value') {
		Error 198 "Value label not allowed for noninteger `value'"
	}
end


/* CheckParens tok1 tok2
   checks that tok1=")"   and   tok2="(" or ""
*/
program define CheckParens
	args tok1 tok2

	if `"`tok1'"' != ")" {
		Error 198 `") expected, "`tok1'" found"'
	}
	if !inlist(`"`tok2'"', "", "(") {
		Error 198 `"( expected, "`tok2'" found"'
	}
end


/* GenerateVar prefix vlist

   Checks whether prefixing the string -prefix- to the names in vlist
   yields valid new variable names.  The new var names are returned
   in the macro r(pvlist).
*/
program define GenerateVar, rclass
	args prefix vlist

	foreach v of local vlist {
		capt confirm name `prefix'`v'
		if _rc {
			Error 198 `"`prefix'`v' invalid variable name"'
		}
		capt confirm new var `prefix'`v'
		if _rc {
			Error 110 "variable `prefix'`v' already exists"
		}
		local pvlist `pvlist' `prefix'`v'
	}
	return local pvlist `pvlist'
end


/* Qcount N : `"exp"'
   Replacement of -count- that does not destroy r()
*/
program define Qcount
	args N colon exp

	tempvar x
	gen `x' = sum(`exp')
	local n = `x'[_N]

	c_local `N' `n'
end
exit
