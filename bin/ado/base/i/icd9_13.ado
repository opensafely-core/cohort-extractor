*! version 1.1.4  04mar2016
* This is -icd9- for caller versions less than 14
program define icd9_13
	version 9
	gettoken cmd 0 : 0, parse(" ,")
	local l = length("`cmd'")
	if "`cmd'"=="check" { 
		Check `0'
	}
	else if "`cmd'"=="clean" { 
		Clean `0'
	}
	else if "`cmd'" == bsubstr("generate",1,max(3,`l')) {
		Gen `0'
	}
	else if "`cmd'" == bsubstr("lookup",1,max(1,`l')) { 
		Lookup `0'
	}
	else if "`cmd'" == bsubstr("search",1,max(3,`l')) {
		Search `0'
	}
	else if "`cmd'" == bsubstr("tabulate",1,max(3,`l')) { 
		Tabulate `0'
	}
	else if `"`cmd'"' == "table" { 
		Table `0'
	}
	else if `"`cmd'"' == bsubstr("query",1,max(1,`l')) {
		Query `0'
	}
	else {
		di in red "invalid icd9 subcommand"
		exit 198
	}
end

* ---
* icd9 check
program define Check, rclass
	syntax varname [, ANY List SYStem(string) Generate(string) ]
	local typ : type `varlist'
	if bsubstr("`typ'",1,3)!="str" {
		di in red "`varlist' does not contain ICD-9 codes; " /*
		*/ "ICD-9 codes must be stored as a string"
		exit 459
	}
	if "`generate'"!="" {
		confirm new var `generate'
	}

	if "`system'"=="" {
		tempvar c
	}
	else	local c "`system'"

	quietly { 
		local typ : type `varlist'
		quietly gen `typ' `c' = upper(trim(`varlist'))
		compress `c'

		tempvar prob l

				/* 0.  code may contain "", missing */
		gen byte `prob' = cond(`c'=="", 0, .)


				/* 1.  invalid placement of period 	*/
				/* 2.  too many periods 		*/
		capture assert index(`c', ".") == 0
		if _rc { 
			gen byte `l' = index(`c', ".")
			replace `c' = (trim( /*
			*/ substr(`c',1,`l'-1) + substr(`c',`l'+1,.) /* 
			*/ )) if `l'
			compress `c'
			replace `prob' = 1 if bsubstr(`c',1,1)=="E" & /*
							*/ `l'>0 & `l'!=5
			replace `prob' = 1 if bsubstr(`c',1,1)!="E" & /*
							*/ `l'>0 & `l'!=4
			replace `prob' = 2 if index(`c', ".")
			drop `l'
		}

				/* 3.  code too short			*/
				/* 4.  code too long			*/
		gen byte `l' = length(`c')
		replace `prob'=3 if `l'<3 & `prob'==.
		replace `prob'=4 if `l'>5 & `prob'==.
		drop `l'

				/* 5.  1st char must be 0-9, E, or V	*/
		gen str1 `l' = substr(`c',1,1)
		replace `prob'=5 /*
		*/ if (`l'<"0" | `l'>"9") & `l'!="E" & `l'!="V" & `prob'==.

				/* 6.  2nd char must be 0-9	*/
		replace `l' = substr(`c',2,1)
		replace `prob' = 6 if (`l'<"0" | `l'>"9") & `prob'==.
		
				/* 7.  3rd char must be 0-9	*/
		replace `l' = substr(`c',3,1)
		replace `prob' = 7 if (`l'<"0" | `l'>"9") & `prob'==.
		
				/* 8.  4th char must be 0-9 or "" */
		replace `l' = substr(`c',4,1)
		replace `prob' = 8 if (`l'<"0" | `l'>"9") & `l'!="" & `prob'==.

				/* 9.  5th char must be 0-9 or "" */
		replace `l' = substr(`c',5,1)
		replace `prob' = 9 if (`l'<"0" | `l'>"9") & `l'!="" & `prob'==.
		drop `l' 

				/* 3.  code too short			*/
				/*     (if 1st char E, length is 4-5)	*/
		gen byte `l' = length(`c')
		replace `prob' = 3 if bsubstr(`c',1,1)=="E" & `l'<4 & `prob'==.


				/* clean up prob			*/
		replace `prob' = 0 if `prob'==.
	}

				/* Early exit if system() option	*/
	if "`system'"!="" {
		capture assert `prob'==0
		if _rc==0 {
			exit
		}
		drop `c'
		di in red "`varlist' contains invalid ICD-9 codes"
		exit 459
	}

				/* 10.  invalid code			*/
	qui count if `c'==""
	local miss = r(N)
	preserve
	if `miss' != _N & "`any'"=="" { 
		quietly {
			keep `varlist' `prob' `c'
			Merge `c'
			replace `prob' = 10 if _merge!=3 & `prob'==0 & `c'!=""
		}
	}
		

	qui count if `prob'
	local bad = r(N)
	return scalar esum = r(N)
	if `bad'==0 {
		if `miss'==_N { 
			di in gr "(`varlist' contains all missing values)"
		}
		else if `miss'==0 { 
			di in gr "(`varlist' contains valid ICD-9 codes; " /*
			*/ "no missing values)"
		}
		else {
			local s = cond(`miss'==1, "", "s")
			di in gr "(`varlist' contains valid ICD-9 codes; " /*
			*/ "`miss' missing value`s')"
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
		ret scalar e10 = .  /* sic */
	}
	else {

		di /* not in red, no extra line if output suppressed */
		di in red "`varlist' contains invalid codes:"
		di /* not in red, no extra line if output suppressed */

		qui count if `prob'==1
		di in gr "    1.  Invalid placement of period" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e1 = r(N)

		qui count if `prob'==2
		di in gr "    2.  Too many periods" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e2 = r(N)

		qui count if `prob'==3
		di in gr "    3.  Code too short" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e3 = r(N)

		qui count if `prob'==4
		di in gr "    4.  Code too long" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e4 = r(N)

		qui count if `prob'==5
		di in gr "    5.  Invalid 1st char (not 0-9, E, or V)" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e5 = r(N)

		qui count if `prob'==6
		di in gr "    6.  Invalid 2nd char (not 0-9)" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e6 = r(N)

		qui count if `prob'==7
		di in gr "    7.  Invalid 3rd char (not 0-9)" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e7 = r(N)

		qui count if `prob'==8
		di in gr "    8.  Invalid 4th char (not 0-9)" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e8 = r(N)

		qui count if `prob'==9
		di in gr "    9.  Invalid 5th char (not 0-9)" /*
			*/ _col(49) in ye %11.0gc r(N)
		ret scalar e9 = r(N)

		if "`any'"=="" {
			qui count if `prob'==10
			di in gr "   10.  Code not defined" /*
				*/ _col(49) in ye %11.0gc r(N)
			ret scalar e10 = r(N)
		}
		else	ret scalar e10 = .

		di in smcl in gr _col(49) "{hline 11}"
		di in gr _col(9) "Total" /*
			*/ _col(49) in ye %11.0gc `bad'

		local s = cond(`bad'>1, "s", "")
		if "`list'" != "" { 
			quietly { 
				gen str27 __prob = "" 
				replace __prob = /*
					*/ "Invalid placement of period" /* 
					*/ if `prob'==1
				replace __prob = "Too many periods" /*
					*/ if `prob'==2
				replace __prob = "Code too short"   /*
					*/ if `prob'==3
				replace __prob = "Code too long"    /*
					*/ if `prob'==4
				replace __prob = "Invalid 1st char" /*
					*/ if `prob'==5
				replace __prob = "Invalid 2nd char" /*
					*/ if `prob'==6
				replace __prob = "Invalid 3rd char" /*
					*/ if `prob'==7
				replace __prob = "Invalid 4th char" /*
					*/ if `prob'==8
				replace __prob = "Invalid 5th char" /*
					*/ if `prob'==9
				replace __prob = "Code not defined" /*
					*/ if `prob'==10
			}
			di _n in gr "Listing of invalid codes"
			format __prob %-27s
			list `varlist' __prob if `prob'!=0 & `prob'!=.
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
			merge using `"`one'"', _merge(`x') nonotes
			assert `x'==3
			restore, not
		}
	}
end

program define Merge 
	args c
	tempvar n 
	quietly { 
		gen `c(obs_t)' `n' = _n
		rename `c' __code9
	}
	FindFile
	local fn `"`r(fn)'"'
	quietly {
		sort __code9
		merge __code9 using `"`fn'"', nokeep keep(__code9) nonotes
		sort `n'
		rename __code9 `c'
	}
end
		

* ---
* icd9 clean 

program define Clean 
	syntax varname [, Dots Pad]

	tempvar c l
	Check `varlist', system(`c')
	quietly { 
		if "`dots'" != "" { 
			replace `c' = /*
			*/ substr(`c',1,3) + "." + substr(`c',4,.) /*
			*/ if substr(`c',1,1) != "E" & `c'!=""
			replace `c' = /*
			*/ substr(`c',1,4) + "." + substr(`c',5,.) /*
			*/ if bsubstr(`c',1,1) == "E" & `c'!=""
			gen byte `l' = length(`c')
			replace `c' = substr(`c',1,`l'-1) /*
			*/ if bsubstr(`c',`l',1)=="."
			drop `l'
			local len 7
		}
		else	local len 6
		if "`pad'"!="" {
			replace `c' = " " + `c' if bsubstr(`c',1,1)!="E"
			replace `c' = substr(`c' + "       ",1,`len')
			replace `c' = trim(`c') if trim(`c')==""
		}
		gen byte `l' = length(`c')
		summ `l', meanonly 
		local len = max(8, /*
		*/ cond(length("`varlist'")>r(max), length("`varlist'"), /*
		*/ r(max)) + 1)
		count if `varlist' != `c'
		local ch = r(N)
		local s = cond(`ch'==1, "", "s")
		replace `varlist' = `c'
		compress `varlist'
		format `varlist' %-`len's
	}
	di in gr "(`ch' change`s' made)"
end

* ---

* icd9 generate
program define Gen
	gettoken newvar 0 : 0, parse(" =")
	gettoken eqsign 0 : 0, parse(" =") 
	if `"`eqsign'"' != "=" { 
		error 198 
	}
	syntax varname [, Main Description Range(string) Long End ]
	confirm new var `newvar'

	local nopt = ("`main'"!="") + ("`description'"!="") + (`"`range'"'!="")

	if `nopt'!=1 { 
		di in red /*
	*/ "must specify one of options -main-, -description-, or -range()-"
		exit 198
	}

	if "`description'" == "" { 
		if "`long'"!="" { 
			di in red "option -long- not allowed"
			exit 198
		}
		if "`end'"!="" { 
			di in red "option -end- not allowed"
			exit 198
		}
	}


	tempvar new c
	Check `varlist', system(`c')
	if "`main'"!="" {
		GenMain `new' `c' `varlist'
	}
	else if "`description'" != "" {
		GenDesc `new' `c' `varlist' "`long'" "`end'"
	}
	else	GenRange `new' `c' `varlist' `"`range'"'

	rename `new' `newvar'
end

program define GenMain
	args new c userv

	quietly {
		gen str4 `new' = substr(`c',1,3) /*
		*/ if `c'!="" & bsubstr(`c',1,1)!="E"
		replace `new' = substr(`c',1,4) /*
		*/ if `c'!="" & bsubstr(`c',1,1)=="E"
		compress `new'
		label var `new' "main ICD9 from `userv'"
	}
end
	
	
program define GenDesc
	args new c userv long end

	if "`end'" != "" {
		local long "long"
	}

	FindFile
	local fn `"`r(fn)'"'

	tempname merge
	quietly {
		sort `c'
		rename `c' __code9
		merge __code9 using `"`fn'"', nokeep _merge(`merge') nonotes
		rename __code9 `c'
		rename __desc9 `new'
		label var `new' "label for `userv'"
		count if `merge'!=3 & `c'!=""
		local unlab = r(N)
		drop `merge'

		if "`long'" != "" {
			icd9_13 clean `c', dots
			replace `c' = " " + `c' if bsubstr(`c',1,1)!="E"
			replace `c' = substr(`c'+"       ",1,7)
			if "`end'"=="" {
				replace `new' = `c' + " " + `new'
			}
			else {
				replace `new'= `new'+" "+`c'
				local f : format `new'
				if bsubstr(`"`f'"',2,1)=="-" {
					local f = "%" + substr(`"`f'"',3,.)
					format `new' `f'
				}
			}
			replace `new' = "" if trim(`new')==""
		}
	}
	if `unlab' { 
		local s = cond(`unlab'==1, "", "s")
		di in gr "(`unlab'" /*
		*/ " nonmissing values invalid and so could not be labeled)"
	}
end

program define GenRange
	args new c userv range

	P_ilist `"`range'"' ","
	local list `"`s(list)'"'
	local rest = trim(`"`s(rest)'"')
	if `"`rest'"' != "" { 
		error 198 
	}

	X_ilist `new' `c' `"`list'"'
end

* ---
* icd9 lookup
program define Lookup
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
		X_ilist `use' __code9 `"`list'"'
		keep if `use'
	}

	if _N == 0 {
		di in gr "(no matches found)"
		exit
	}
	local es = cond(_N==1, "", "es")
	qui icd9_13 clean __code9, dots
	di _n in gr _N " match`es' found:"

	local i 1 
	while `i' <= _N { 
		local col = cond(bsubstr(__code9[`i'],1,1)=="E",4,5)
		di in ye _col(`col') __code9[`i'] _col(14) in gr __desc9[`i']
		local i = `i' + 1
	}
end

* ---
* icd9 search

program define Search
	local i 1
	gettoken s1 0 : 0, parse(" ,")
	while `"`s`i''"' != "" & `"`s`i''"' != "," {
		local i = `i' + 1
		gettoken s`i' 0 : 0, parse(" ,")
	}
	local n = `i' - 1
	if `n'==0 {
		error 198
	}

	local 0 `", `0'"'
	syntax [, OR ]

	FindFile
	local fn `"`r(fn)'"'

	tempvar use
	preserve 
	quietly { 
		use `"`fn'"', clear 
		gen byte `use' = 0 
		local i 1
		while `i' <= `n' { 
			replace `use' = `use' + 1 /*
			*/ if index(lower(__desc9), lower(`"`s`i''"'))
			local i = `i' + 1
		}
	}
	if "`or'" == "" { 
		qui replace `use' = 0 if `use' != `n' 
	}
	qui keep if `use'
	if _N == 0 {
		di in gr "(no matches found)"
		exit
	}
	local es = cond(_N==1, "", "es")
	qui icd9_13 clean __code9, dots
	di _n in gr _N " match`es' found:"

	local i 1 
	while `i' <= _N { 
		local col = cond(bsubstr(__code9[`i'],1,1)=="E",4,5)
		di in ye _col(`col') __code9[`i'] _col(14) in gr __desc9[`i']
		local i = `i' + 1
	}

end


* ---
* icd9 tabulate

program define Tabulate
	syntax varlist(min=1 max=2) [fw aw iw] [if] [in] [, /*
		*/ Generate(string) SUBPOP(string) * ]
	if `"`subpop'"' != "" { 
		di in red "option subpop() not allowed with icd9 tabulate"
		exit 198
	}
	if `"`generate'"' != "" {
		di in red "option generate() not allowed with icd9 tabulate"
		exit 198
	}

	tokenize `varlist'
	tempvar c desc
	Check `1', system(`c')
	preserve 
	quietly {
		if `"`if'"'!="" | "`in'"!="" {
			keep `if' `in'
		}
		if "`weight'" != "" {
			tempname wgtv
			gen double wgtv = `exp'
			compress wgtv
			local w "[`weight'=`wgtv']"
		}
		local lbl : var label `1'
		if `"`lbl'"' == "" {
			local lbl "`1'"
		}
		keep `2' `wgtv' `c'
		icd9_13 gen `desc' = `c', desc long end
		label var `desc' `"`lbl'"'
	}
	tabulate `desc' `2' `w', `options'
end

* ---
* icd9 table

program define Table
	syntax varlist(min=1 max=3) [fw pw aw iw] [if] [in] [, /*
		*/ Contents(string) BY(varlist) * ] 

	tokenize `varlist'
	tempvar c desc
	Check `1', system(`c')

	if "`contents'" != "" {
		ConList `contents'
		local list `s(list)'
		local contopt contents(`contents')
	}
	if "`by'"!="" {
		local byopt by(`byopt')
	}

	preserve 
	quietly {
		if `"`if'"'!="" | "`in'"!="" {
			keep `if' `in'
		}
		if "`weight'" != "" {
			tempname wgtv
			gen double wgtv = `exp'
			compress wgtv
			local w "[`weight'=`wgtv']"
		}
		local lbl : var label `1'
		if `"`lbl'"' == "" {
			local lbl "`1'"
		}
		keep `2' `wgtv' `c' `list' `by'
		icd9_13 gen `desc' = `c', desc long end
		label var `desc' `"`lbl'"'
	}
	table `desc' `2' `3' `w', `contopt' `byopt' `options'
end

program define ConList, sclass
	sret clear
	while "`1'" != "" { 
		if "`1'" != "freq" { 
			mac shift 
			sret local list `list' `1'
		}
		mac shift
	}
end

* ---
* utility to parse and execute an icd9rangelist (ilist)

program define P_ilist, sclass
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
		else	local list `"`list' `tok'"'
		gettoken tok : str, parse(" *-/`term'")
	}
	sret local list `"`list'"'
	sret local rest `"`str'"'
end

program define IsEl, sclass
	args c

	local origc = trim(`"`c'"')
	local c = upper(trim(`"`c'"'))
	if `"`c'"' == "" { 
		di in red "<nothing> invalid ICD-9 code"
		exit 198
	}
	if index(`"`c'"', ".") { 
		local l = index(`"`c'"', ".")
		local c = (trim( /*
			*/ substr(`"`c'"',1,`l'-1) + substr(`"`c'"',`l'+1,.) /*
			*/ ))
		if lower(bsubstr(`"`c'"',1,1)) == "e" {
			local lchk 5
		}
		else {
			local lchk 4
		}
		if `l'>0 & `l'!=`lchk' {
			Invalid `"`origc'"' "invalid placement of period"
		}
		if index(`"`c'"', ".") {
			Invalid `"`origc'"' "too many periods"
		}
	}
	if length(`"`c'"') < 1 {
		Invalid `"`origc'"' "code too short"
	}
	if length(`"`c'"') > 5 {
		Invalid `"`origc'"' "code too long"
	}

	local l = substr(`"`c'"', 1, 1)
	if (`"`l'"'<"0" | `"`l'"'>"9") & `"`l'"'!="E" & `"`l'"'!="V" { 
		Invalid `"`origc'"' "1st character must be 0-9, E, or V"
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

	local l = substr(`"`c'"', 5, 1)
	if (`"`l'"'<"0" | `"`l'"'>"9") & `"`l'"'!="" { 
		Invalid `"`origc'"' "5th character must be 0-9"
	}

	sret local tok `"`c'"'
end

program define Invalid 
	args code msg 
	di in red `""`code'" invalid: `msg'"'
	exit 198
end

program define X_ilist
	args newvar vn list
	quietly { 
		gen byte `newvar' = 0 
		tokenize `"`list'"'
		while "`1'" != "" { 
			if index("`1'", "-") { 
				local l = index("`1'", "-")
				local lb = substr("`1'",1,`l'-1)
				local ub = substr("`1'",`l'+1,.)
				replace `newvar' = 1 /*
				*/ if `vn'>="`lb'" & `vn'<="`ub'"
			}
			else if index("`1'", "*") { 
				local sub = substr("`1'",1,length("`1'")-1)
				local l = length("`sub'")
				replace `newvar' = 1 /*
				*/ if substr(`vn',1,`l')=="`sub'"
			}
			else 	replace `newvar' = 1 if `vn' == "`1'"
			mac shift 
		}
	}
end

	
	
program define FindFile
	capture noi quietly findfile icd9_cod.dta
	if _rc==0 {
		exit
	}
	local rc = _rc 
	di
	di in gr "icd9 needs a dataset that records the valid ICD-9 codes."
	di in gr "That dataset is stored with the icd9 program."
	di in gr `"Type "help icd9" and see the installation instructions."'
	exit `rc'
end

program define Query
	syntax
	FindFile
	local fn `"`r(fn)'"'
	preserve 
	quietly use `"`fn'"', clear
	notes
end
	

exit
