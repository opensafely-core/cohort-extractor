*! version 1.1.5  24nov2015  
program icd9p
	if _caller() < 14 {
		icd9p_13 `0'
		exit
	}
	version 14
	gettoken cmd 0 : 0, parse(" ,")
	local l = length(`"`cmd'"')
	if `"`cmd'"'=="check" {
		Check `0'
	}
	else if `"`cmd'"'=="clean" {
		Clean `0'
	}
	else if `"`cmd'"' == bsubstr("generate",1,max(3,`l')) {
		Gen `0'
	}
	else if `"`cmd'"' == bsubstr("lookup",1,max(1,`l')) {
				// documenting min abbrev of -look-
		Lookup `0'
	}
	else if `"`cmd'"' == bsubstr("search",1,max(3,`l')) {
		// -icd9p search- keeps same features as before -- drop
		// through to original command
		icd9p_13 `cmd' `0'
	}
	else if `"`cmd'"' == "table" |					///
			`"`cmd'"' == bsubstr("tabulate",1,max(3,`l')) {
		// -icd9p table- and -icd9p tabulate- were not documented (in
		// original STB article or in the official command) -- drop
		// through to original command
		icd9p_13 `cmd' `0'
	}
	else if `"`cmd'"' == bsubstr("query",1,max(1,`l')) {
		Query `0'
	}
	else if `"`cmd'"' == "" | `"`cmd'"' == "," {
		di as err "icd9p subcommand required"
		exit 198
	}
	else {
		di as err "invalid icd9p subcommand"
		exit 198
	}
end

* ---
* icd9p check
program Check, rclass
	syntax varname [if] [in] [, ANY List SYStem(string) Generate(string) ]
		// -system()- is undocumented
	local typ : type `varlist'
	if bsubstr("`typ'",1,3)!="str" {
		di as err ///
			"`varlist' does not contain ICD-9 procedure codes;" ///
			_n "ICD-9 procedure codes must be stored as a string"
		exit 459
	}
	if "`generate'"!="" {
		confirm new var `generate'
	}

	if "`system'"=="" {
		tempvar c
	}
	else {
		local c "`system'"
	}

	marksample touse, strok novarlist   // novarlist allows missings ""

	qui count if `touse'
	if r(N) < 1 {
		error 2000
	}
	else {
		local Nuse `r(N)'
	}

	quietly {
		local typ : type `varlist'
		quietly gen `typ' `c' = upper(trim(`varlist')) if `touse'
		compress `c'

		tempvar prob l

				// 0.  code may contain "", missing
		gen byte `prob' = cond(`c'=="", 0, .) if `touse'


				// 1.  invalid placement of period
				// 2.  too many periods
		capture assert strpos(`c', ".") == 0 if `touse'
		if _rc {
			gen byte `l' = strpos(`c', ".") if `touse'
			replace `c' = (trim( ///
				bsubstr(`c',1,`l'-1) + bsubstr(`c',`l'+1,.) ///
				)) if `l' & `touse'
			compress `c'
			replace `prob' = 1 if `l'>0 & `l'!=3 & `touse'
			replace `prob' = 2 if strpos(`c', ".") & `touse'
			drop `l'
		}

				// 3.  code too short
				// 4.  code too long
		gen byte `l' = length(`c') if `touse'
		replace `prob'=3 if `l'<2 & `prob'==. & `touse'
		replace `prob'=4 if `l'>4 & `prob'==. & `touse'
		drop `l'

				// 5.  1st char must be 0-9
		gen str1 `l' = substr(`c',1,1) if `touse'
		replace `prob' = 5 if (`l'<"0" | `l'>"9") & `prob'==. & `touse'

				// 6.  2nd char must be 0-9
		replace `l' = substr(`c',2,1) if `touse'
		replace `prob' = 6 if (`l'<"0" | `l'>"9") & `prob'==. & `touse'

				// 7.  3rd char must be 0-9 or ""
		replace `l' = substr(`c',3,1) if `touse'
		replace `prob' = 7 if (`l'<"0" | `l'>"9") & `l'!="" ///
						& `prob'==. & `touse'

				// 8.  4th char must be 0-9 or ""
		replace `l' = substr(`c',4,1) if `touse'
		replace `prob' = 8 if (`l'<"0" | `l'>"9") & `l'!="" ///
						& `prob'==. & `touse'

		drop `l'

				// clean up prob
		replace `prob' = 0 if `prob'==. & `touse'
	}

				// Early exit if system() option
	if "`system'"!="" {
		capture assert `prob'==0 if `touse'
		if _rc==0 {
			exit
		}
		drop `c'
		di as err "`varlist' contains invalid ICD-9 procedure codes"
		exit 459
	}

				// 10.  undefined code
	qui count if `c'=="" & `touse'
	local miss = r(N)

	// make an id var and also keep track of current sort
	tempvar pid
	qui gen `c(obs_t)' `pid' = _n
	local sortby : sortedby

	preserve

	if `miss' != `Nuse' & "`any'"=="" {
		quietly {
			keep `sortby' `touse' `pid' `varlist' `prob' `c'
			tempvar xmrg
			Merge `xmrg' "`sortby'" `pid' `c'
			replace `prob' = 10 if `xmrg'!=3 & `prob'==0 ///
							& `c'!="" & `touse'
		}
	}


	qui count if `prob' & `touse'
	local bad = r(N)
	return scalar esum = r(N)

	if `miss'==`Nuse' {
		local msgstub "all missing values"
	}
	else if `miss'==0 {
		local msgstub "no missing values"
	}
	else {
		local s = cond(`miss'==1, "", "s")
		local msgstub "`miss' missing value`s'"
	}

	if `bad'==0 {
		if `miss'==`Nuse' {
			di as text "(`varlist' contains `msgstub')"
		}
		else {
			di as text ///
"(`varlist' contains defined ICD-9-CM procedure codes; `msgstub')"
		}
		ret scalar e1 = 0
		ret scalar e2 = 0
		ret scalar e3 = 0
		ret scalar e4 = 0
		ret scalar e5 = 0
		ret scalar e6 = 0
		ret scalar e7 = 0
		ret scalar e8 = 0
		ret scalar e9 = 0
		ret scalar e10 = .  // sic
	}
	else {
		local inv_und "undefined"
		qui count if `touse' & inlist(`prob', 1,2,3,4,5,6,7,8,9)
		if r(N) {
			local inv_und "invalid"
		}
		di as text "(`varlist' contains `msgstub')"
		di // not as err, no extra line if output suppressed
		di as err "`varlist' contains `inv_und' codes:"
		di // not as err, no extra line if output suppressed

		qui count if `prob'==1 & `touse'
		di as text "    1.  Invalid placement of period" ///
					_col(49) as res %11.0gc r(N)
		ret scalar e1 = r(N)

		qui count if `prob'==2 & `touse'
		di as text "    2.  Too many periods" ///
					_col(49) as res %11.0gc r(N)
		ret scalar e2 = r(N)

		qui count if `prob'==3 & `touse'
		di as text "    3.  Code too short" ///
					_col(49) as res %11.0gc r(N)
		ret scalar e3 = r(N)

		qui count if `prob'==4 & `touse'
		di as text "    4.  Code too long" ///
					_col(49) as res %11.0gc r(N)
		ret scalar e4 = r(N)

		qui count if `prob'==5 & `touse'
		di as text "    5.  Invalid 1st char (not 0-9)" ///
					_col(49) as res %11.0gc r(N)
		ret scalar e5 = r(N)

		qui count if `prob'==6 & `touse'
		di as text "    6.  Invalid 2nd char (not 0-9)" ///
					_col(49) as res %11.0gc r(N)
		ret scalar e6 = r(N)

		qui count if `prob'==7 & `touse'
		di as text "    7.  Invalid 3rd char (not 0-9)" ///
					_col(49) as res %11.0gc r(N)
		ret scalar e7 = r(N)

		qui count if `prob'==8 & `touse'
		di as text "    8.  Invalid 4th char (not 0-9)" ///
					_col(49) as res %11.0gc r(N)
		ret scalar e8 = r(N)

		ret scalar e9 = 0 /* sic */

		if "`any'"=="" {
			qui count if `prob'==10 & `touse'
			di as text "   10.  Code not defined" ///
					_col(49) as res %11.0gc r(N)
			ret scalar e10 = r(N)
		}
		else {
			ret scalar e10 = .
		}

		di in smcl as text _col(49) "{hline 11}"
		di as text _col(9) "Total" _col(49) as res %11.0gc `bad'

		local s = cond(`bad'>1, "s", "")
		if "`list'" != "" {
			quietly {
				gen str27 __prob = "" if `touse'
				replace __prob = ///
					"Invalid placement of period" ///
						if `prob'==1 & `touse'
				replace __prob = "Too many periods" ///
						if `prob'==2 & `touse'
				replace __prob = "Code too short"   ///
						if `prob'==3 & `touse'
				replace __prob = "Code too long"    ///
						if `prob'==4 & `touse'
				replace __prob = "Invalid 1st char" ///
						if `prob'==5 & `touse'
				replace __prob = "Invalid 2nd char" ///
						if `prob'==6 & `touse'
				replace __prob = "Invalid 3rd char" ///
						if `prob'==7 & `touse'
				replace __prob = "Invalid 4th char" ///
						if `prob'==8 & `touse'
						// 9 is not used for icd9p
				replace __prob = "Code not defined" ///
						if `prob'==10 & `touse'
			}
			di _n in gr "Listing of invalid and undefined codes"
			format __prob %-27s
			list `varlist' __prob if `prob'!=0 & `prob'!=. & `touse'
		}
	}
	if "`generate'" != "" {
		quietly {
			keep `prob'
			rename `prob' `generate'
			tempfile one
			save `"`one'"'
			restore, preserve
			tempvar x
			merge 1:1 _n using `"`one'"',	///
					gen(`x') assert(match) nonotes
			drop `x'

			label define __icd_9p				///
				0 "Defined code or missing"		///
				1 "Invalid placement of period"		///
				2 "Too many periods"			///
				3 "Code too short"			///
				4 "Code too long"			///
				5 "Invalid 1st char (not 0-9)" 		///
				6 "Invalid 2nd char (not 0-9)"		///
				7 "Invalid 3rd char (not 0-9)"		///
				8 "Invalid 4th char (not 0-9)"		///
				10 "Code not defined"			///
				, replace
			label values `generate' __icd_9p

			restore, not
			sort `sortby' `pid'
		}
	}
end

program Merge
	args xmrg sortby pid c
	quietly rename `c' __code9
	FindFile
	local fn `"`r(fn)'"'
	quietly {
		sort __code9
		merge m:1 __code9 using `"`fn'"', nonotes gen(`xmrg')	///
				keepusing(__code9) keep(match master)
		sort `sortby' `pid'
		rename __code9 `c'
	}
end

* ---
* icd9p clean
program Clean
	syntax varname [if] [in] [, Dots Pad]
			// documenting min abbrev of -dot-

	marksample touse, strok

	tempvar c l
	Check `varlist' if `touse', system(`c')
	quietly {
		if "`dots'" != "" {
			replace `c' = ///
				substr(`c',1,2) + "." + substr(`c',3,.) ///
				if `c'!="" & `touse'
			gen byte `l' = length(`c') if `touse'
			replace `c' = substr(`c',1,`l'-1) ///
				if bsubstr(`c',`l',1)=="." & `touse'
			drop `l'
			local len 6
		}
		else {
			local len 5
		}
		if "`pad'"!="" {
			replace `c' = substr(`c' + "       ",1,`len') if `touse'
			replace `c' = trim(`c') if trim(`c')=="" & `touse'
		}
		gen byte `l' = length(`c') if `touse'
		summ `l' if `touse', meanonly
		local len = max(8, ///
		    cond(length("`varlist'")>r(max), length("`varlist'"), ///
		    r(max)) + 1)
		count if `varlist' != `c' & `touse'
		local ch = r(N)
		local s = cond(`ch'==1, "", "s")
		replace `varlist' = `c'	if `touse'
		compress `varlist'
		format `varlist' %-`len's
	}
	di as text "(`ch' change`s' made)"
end

* ---
* icd9p generate
program Gen
	gettoken newvar 0 : 0, parse(" =")
	gettoken eqsign 0 : 0, parse(" =")
	if `"`eqsign'"' != "=" {
		error 198
	}
	syntax varname [if] [in] [, ///
		Main CATegory Description Range(string) Long End ]
			// documenting -long- and -end- (not showing abbrev)

	if "`main'" != "" {
		// -main- is undocumented (in Stata 14) synonym for -category-
		local category category
	}

	confirm new var `newvar'

	marksample touse, strok

	local nopt = ("`category'"!="")+("`description'"!="")+(`"`range'"'!="")

	if `nopt'!=1 {
		di as err ///
 "must specify one of options {bf:category}, {bf:description}, or {bf:range()}"
		exit 198
	}

	if "`description'" == "" {
		if "`long'"!="" {
			di as err "option {bf:long} not allowed"
			exit 198
		}
		if "`end'"!="" {
			di as err "option {bf:end} not allowed"
			exit 198
		}
	}


	tempvar new c
	Check `varlist' if `touse', system(`c')
	if "`category'"!="" {
		GenMain `touse' `new' `c' `varlist'
	}
	else if "`description'" != "" {
		GenDesc `touse' `new' `c' `varlist' "`long'" "`end'"
	}
	else {
		GenRange `touse' `new' `c' `varlist' `"`range'"'
	}

	rename `new' `newvar'
	qui compress `newvar'
end

program GenMain
	args touse new c userv

	quietly {
		gen str2 `new' = substr(`c',1,2) if `touse'
		label var `new' "main ICD9/proc. from `userv'"
	}
end

program GenDesc
	args touse new c userv long end

	if "`end'" != "" {
		local long "long"
	}

	FindFile
	local fn `"`r(fn)'"'

	// make an id var and keep track of current sort
	tempvar pid
	qui gen `c(obs_t)' `pid' = _n
	local sortby : sortedby

	tempname merge
	quietly {
		sort `c'
		rename `c' __code9
		merge m:1 __code9 using `"`fn'"', gen(`merge') nonotes ///
			keepusing(__code9 __desc9) keep(match master)
		sort `sortby' `pid'	// restore sort order
		rename __code9 `c'
		rename __desc9 `new'
		replace `c' = "" if !`touse'
		replace `new' = "" if !`touse'
		label var `new' "label for `userv'"
		count if `merge'!=3 & `c'!="" & `touse'
		local unlab = r(N)
		drop `merge'

		if "`long'" != "" {
			Clean `c' if `touse', dots pad
			if "`end'"=="" {
				replace `new' = `c' + " " + `new' if `touse'
			}
			else {
				replace `new'= `new'+" "+`c' if `touse'
				local f : format `new'
				if bsubstr(`"`f'"',2,1)=="-" {
					local f = "%" + substr(`"`f'"',3,.)
					format `new' `f'
				}
			}
			replace `new' = "" if trim(`new')=="" & `touse'
		}
	}
	if `unlab' {
		local s = cond(`unlab'==1, "", "s")
		di as text "(`unlab'" ///
		  " nonmissing value`s' undefined and so could not be labeled)"
	}
end

program GenRange
	args touse new c userv range		// userv is unused

	P_ilist `"`range'"' ","
	local list `"`s(list)'"'
	local rest = trim(`"`s(rest)'"')
	if `"`rest'"' != "" {
		error 198
	}

	X_ilist `touse' `new' `c' `"`list'"'
end

* ---
* icd9p lookup
program Lookup, rclass
	P_ilist `"`0'"' ","
	local list `"`s(list)'"'
	local rest = trim(`"`s(rest)'"')
	if `"`rest'"' != "" {
		error 198
	}

	FindFile
	local fn `"`r(fn)'"'
	tempvar use

	preserve
	quietly {
		use `"`fn'"', clear
		tempvar touse
		gen byte `touse' = 1
		X_ilist `touse' `use' __code9 `"`list'"'
		keep if `use'
	}

	if _N == 0 {
		di in gr "(no matches found)"
		return scalar N = 0
		exit
	}
	local es = cond(_N==1, "", "es")
	qui Clean __code9, dots
	return scalar N = _N
	di _n in gr _N " match`es' found:"

	local i 1
	while `i' <= _N {
		local col = cond(bsubstr(__code9[`i'],1,1)=="E",4,5)
		di in ye _col(`col') __code9[`i'] _col(14) in gr __desc9[`i']
		local i = `i' + 1
	}
end

* ---
* utility to parse and execute an icd9rangelist (ilist)
program P_ilist, sclass
	args str term
	sret clear

	gettoken tok : str, parse(" *-/`term'")
	while `"`tok'"'!="" & `"`tok'"' != `"`term'"' {
		gettoken tok str : str, parse(" *-/`term'")
		IsEl `"`tok'"'
		local tok `"`s(tok)'"'
		gettoken nxttok : str, parse(" *-/`term'")
		if `"`nxttok'"' == "*" {
			gettoken nxttok str : str, parse(" *-/`term'")
			local list `"`list' `tok'*"'
		}
		else if `"`nxttok'"'=="-" | `"`nxttok'"'=="/" {
			gettoken nxttok str : str, parse(" *-/`term'")
			gettoken nxttok str : str, parse(" *-/`term'")
			IsEl `"`nxttok'"'
			local list `"`list' `tok'-`s(tok)'"'
		}
		else {
			local list `"`list' `tok'"'
		}
		gettoken tok : str, parse(" *-/`term'")
	}
	sret local list `"`list'"'
	sret local rest `"`str'"'
end

program IsEl, sclass
	args c

	local origc = trim(`"`c'"')
	local c = upper(trim(`"`c'"'))
	if `"`c'"' == "" {
		di as err "<nothing> invalid ICD-9 procedure code"
		exit 198
	}
	if strpos(`"`c'"', ".") {
		local l = strpos(`"`c'"', ".")
		local c = (trim( ///
			bsubstr(`"`c'"',1,`l'-1) + bsubstr(`"`c'"',`l'+1,.) ))
		if `l'>0 & `l'!=3 {
			Invalid `"`origc'"' "invalid placement of period"
		}
		if strpos(`"`c'"', ".") {
			Invalid `"`origc'"' "too many periods"
		}
	}
	if length(`"`c'"') < 1 {
		Invalid `"`origc'"' "code too short"
	}
	if length(`"`c'"') > 4 {
		Invalid `"`origc'"' "code too long"
	}

	local l = substr(`"`c'"', 1, 1)
	if (`"`l'"'<"0" | `"`l'"'>"9") {
		Invalid `"`origc'"' "1st character must be 0-9"
	}

	local l = substr(`"`c'"', 2, 1)
	if (`"`l'"'<"0" | `"`l'"'>"9") & `"`l'"'!="" {
		Invalid `"`origc'"' "2nd character must be 0-9"
	}

	local l = substr(`"`c'"', 3, 1)
	if (`"`l'"'<"0" | `"`l'"'>"9") & `"`l'"'!="" {
		Invalid `"`origc'"' "3rd character must be 0-9"
	}

	local l = substr(`"`c'"', 4, 1)
	if (`"`l'"'<"0" | `"`l'"'>"9") & `"`l'"'!="" {
		Invalid `"`origc'"' "4th character must be 0-9"
	}

	sret local tok `"`c'"'
end

program Invalid
	args code msg
	di as err `""`code'" invalid: `msg'"'
	exit 198
end

program X_ilist
	args touse newvar vn list
	quietly {
		gen byte `newvar' = 0 if `touse'
		tokenize `"`list'"'
		while "`1'" != "" {
			if strpos("`1'", "-") {
				local l = strpos("`1'", "-")
				local lb = bsubstr("`1'",1,`l'-1)
				local ub = bsubstr("`1'",`l'+1,.)
				replace `newvar' = 1 ///
				    if `vn'>="`lb'" & `vn'<="`ub'" & `touse'
			}
			else if strpos("`1'", "*") {
				local sub = substr("`1'",1,length("`1'")-1)
				local l = length("`sub'")
				replace `newvar' = 1 ///
				    if substr(`vn',1,`l')=="`sub'" & `touse'
			}
			else {
				replace `newvar' = 1 if `vn' == "`1'" & `touse'
			}
			mac shift
		}
	}
end

program FindFile
	capture noi quietly findfile icd9_cop.dta
	if _rc==0 {
		exit
	}
	local rc = _rc
	di
	di as err "data file not found;"
	di as err "Stata has not been installed or updated correctly"
	exit `rc'
end

program Query
	syntax
	FindFile
	local fn `"`r(fn)'"'
	preserve
	quietly use `"`fn'"', clear

	di as text _n "{p}" `"{bf:`:char _dta[note1]'}"' "{p_end}"
	local i 2
	local done 0
	while !`done' {
		local qnote `"`:char _dta[note`i']'"'
		if bsubstr(`"`qnote'"',1,15) == "{dup 5:{c -}} V" {
			di as text _n "  {bf:" substr(`"`qnote'"',15,3) "}"
		}
		else if bsubstr(`"`qnote'"',1,7) == "----- V" {
			di as text _n "  {bf:" substr(`"`qnote'"',7,3) "}"
		}
		else if bsubstr(`"`qnote'"',1,11) == "----- Note " {
			di as text _n "  {bf:Note}"
		}
		else if `"`qnote'"' == "" {
			local done 1
		}
		else {
			di as text "{p 4 8 2}" `"`qnote'"' "{p_end}"
		}
		local ++i
	}
end
