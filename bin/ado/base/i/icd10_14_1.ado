*! version 1.0.0  10aug2016 
*This is -icd10- for caller versions less than 14.2
program define icd10_14_1
	version 14
	gettoken cmd 0 : 0, parse(" ,")
	local l = length(`"`cmd'"')
	if `"`cmd'"' == "check" {
		Check `0'
	}
	else if `"`cmd'"' == "clean" {
		Clean `0'
	}
	else if `"`cmd'"' == bsubstr("generate",1,max(3,`l')) {
		Gen `0'
	}
	else if `"`cmd'"' == bsubstr("lookup",1,max(4,`l')) {
		Lookup `0'
	}
	else if `"`cmd'"' == bsubstr("query",1,max(1,`l')) {
		Query `0'
	}
	else if `"`cmd'"' == "" | `"`cmd'"' == "," {
		di as err "icd10 subcommand required"
		exit 198
	}
	else {
		di as err "invalid icd10 subcommand"
		exit 198
	}
end

program Check, rclass
	syntax varname [if] [in] [, ANY			///
				    List		///
				    Generate(string)	///
				    year(string)	///
				    SYStem(string)	/// undocumented
				    LONGok		/// undocumented
				 ]

	local typ : type `varlist'
	if bsubstr("`typ'",1,3) != "str" {
		di as err "{p}`varlist' does not contain ICD-10 codes; " ///
			"ICD-10 codes must be stored as a string{p_end}"
		exit 459
	}
	if `"`generate'"' != "" {
		confirm new var `generate'
	}

	ChkYear `"`year'"'
	local year "`s(year)'"

	if "`longok'" != "" {
		if `"`system'"' == "" {
			di as err "{bf:longok} requires {bf:system()}"
			exit 198
		}
	}

	if `"`system'"' == "" {
		tempvar c
	}
	else {
		local c `"`system'"'
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
		gen `typ' `c' = upper(trim(`varlist')) if `touse'
		compress `c'

		tempvar prob l

					// 0.  code may contain "", missing
		gen byte `prob' = cond(`c'=="", 0, .) if `touse'

					// 1.  invalid placement of periods
					// 2.  too many periods
		capture assert strpos(`c', ".") == 0 if `touse'
		if c(rc) {
			gen byte `l' = strpos(`c', ".") if `touse'
			replace `c' = (trim( ///
				bsubstr(`c',1,`l'-1)+bsubstr(`c',`l'+1,.)	///
				)) if `l' & `touse'
			compress `c'
			replace `prob' = 1 if `l'>0 & `l'!=4 & ///
							`prob'==. & `touse'
			replace `prob' = 2 if strpos(`c', ".") & `touse'
			drop `l'
		}

					// 3.  code too short
					// 4.  code too long
		gen byte `l' = length(`c') if `touse'
		replace `prob'=3 if `l'<3 & `prob'==. & `touse'
		if "`longok'" == "" {	// allows 3 and 4 long codes
			replace `prob'=4 if `l'>4 & `prob'==. & `touse'
		}
		else {		// longok also allow 5, 6, and 7 long codes
			replace `prob'=4 if `l'>7 & `prob'==. & `touse'
		}
		drop `l'

					// 5.  1st char A, B, ..., Z
		gen str1 `l' = bsubstr(`c',1,1) if `touse'
		replace `prob'=5 ///
			if indexnot(`l',c(ALPHA)) & `prob'==. & `touse'

					// 6.  2nd char must be 0-9
		replace `l' = bsubstr(`c',2,1) if `touse'
		replace `prob'=6 if (`l'<"0" | `l'>"9") & `prob'==. & `touse'

					// 7.  3rd char must be 0-9
		replace `l' = bsubstr(`c',3,1) if `touse'
		replace `prob'=7 if (`l'<"0" | `l'>"9") & `prob'==. & `touse'

					// 8.  4th char must be 0-9 or ""
		replace `l' = bsubstr(`c',4,1) if `touse'
		replace `prob'=8 if (`l'<"0" | `l'>"9") & `l'!=""	///
							& `prob'==. & `touse'

		// with -longok- we allow 5th, 6th, and even 7th char
		// and we will not check what kind of char it is


		replace `prob' = 0 if `prob'==. & `touse'  // clean up prob
	}

					// Early exit if system() option
	if "`system'" != "" {
		capture assert `prob'==0 if `touse'
		if c(rc)==0 {
			exit
		}
		drop `c'
		di as err "`varlist' contains invalid ICD-10 codes"
		exit 459
	}

					// 99. undefined code
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
			Merge `"`year'"' `xmrg' "`sortby'" `pid' `c'
			replace `prob' = 99 if `xmrg'!=3 & `prob'==0	///
							& `c'!="" & `touse'
			drop `xmrg'
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
			di as text	///
			  "(`varlist' contains defined ICD-10 codes; `msgstub')"
		}
		return scalar e1 = 0
		return scalar e2 = 0
		return scalar e3 = 0
		return scalar e4 = 0
		return scalar e5 = 0
		return scalar e6 = 0
		return scalar e7 = 0
		return scalar e8 = 0

		return scalar e99 = .	// sic
	}
	else {
		local inv_und "undefined"
		qui count if `touse' & inlist(`prob', 1,2,3,4,5,6,7,8)
		if r(N) {
			local inv_und "invalid"
		}
		di as text "(`varlist' contains `msgstub')"
		di // not as err, no extra line if output suppressed
		di as err "`varlist' contains `inv_und' codes:"
		di // not as err, no extra line if output suppressed

		qui count if `prob'==1 & `touse'
		di as text "    1.  Invalid placement of period"	///
			_col(49) as res %11.0gc r(N)
		ret scalar e1 = r(N)

		qui count if `prob'==2 & `touse'
		di as text "    2.  Too many periods"			///
			_col(49) as res %11.0gc r(N)
		ret scalar e2 = r(N)

		qui count if `prob'==3 & `touse'
		di as text "    3.  Code too short"			///
			_col(49) as res %11.0gc r(N)
		ret scalar e3 = r(N)

		qui count if `prob'==4 & `touse'
		di as text "    4.  Code too long"			///
			_col(49) as res %11.0gc r(N)
		ret scalar e4 = r(N)

		qui count if `prob'==5 & `touse'
		di as text "    5.  Invalid 1st char (not A-Z)"		///
			_col(49) as res %11.0gc r(N)
		ret scalar e5 = r(N)

		qui count if `prob'==6 & `touse'
		di as text "    6.  Invalid 2nd char (not 0-9)"		///
			_col(49) as res %11.0gc r(N)
		ret scalar e6 = r(N)

		qui count if `prob'==7 & `touse'
		di as text "    7.  Invalid 3rd char (not 0-9)"		///
			_col(49) as res %11.0gc r(N)
		ret scalar e7 = r(N)

		qui count if `prob'==8 & `touse'
		di as text "    8.  Invalid 4th char (not 0-9)"		///
			_col(49) as res %11.0gc r(N)
		ret scalar e8 = r(N)

		// prob 9 and 10 are only with -longok- (doesn't apply here)

		if "`any'"=="" {
			qui count if `prob'==99 & `touse'
			di as text "   99.  Code not defined"		///
				_col(49) as res %11.0gc r(N)
			ret scalar e99 = r(N)
		}
		else {
			ret scalar e99 = .
		}

		di in smcl as text _col(49) "{hline 11}"
		di as text _col(9) "Total" ///
			_col(49) as res %11.0gc `bad'

		local s = cond(`bad'>1, "s", "")

		if "`list'" != "" {
			quietly {
				gen str27 __prob = "" if `touse'
				replace __prob =			///
					"Invalid placement of period"	///
							if `prob'==1 & `touse'
				replace __prob = "Too many periods"	///
							if `prob'==2 & `touse'
				replace __prob = "Code too short"	///
							if `prob'==3 & `touse'
				replace __prob = "Code too long"	///
							if `prob'==4 & `touse'
				replace __prob = "Invalid 1st char"	///
							if `prob'==5 & `touse'
				replace __prob = "Invalid 2nd char"	///
							if `prob'==6 & `touse'
				replace __prob = "Invalid 3rd char"	///
							if `prob'==7 & `touse'
				replace __prob = "Invalid 4th char"	///
							if `prob'==8 & `touse'
				replace __prob = "Code not defined"	///
							if `prob'==99 & `touse'
			}
			di _n as text "Listing of invalid and undefined codes"
			format __prob %-27s
			list `varlist' __prob if `prob'!=0 & `prob'!=. & `touse'
		}
	}

	if `"`generate'"' != "" {
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

			label define __icd_10				///
				0  "Defined code or missing"		///
				1  "Invalid placement of period"	///
				2  "Too many periods"			///
				3  "Code too short"			///
				4  "Code too long"			///
				5  "Invalid 1st char (not A-Z)"		///
				6  "Invalid 2nd char (not 0-9)"		///
				7  "Invalid 3rd char (not 0-9)"		///
				8  "Invalid 4th char (not 0-9)"		///
				99 "Code not defined"			///
				, replace
			label values `generate' __icd_10

			label var `generate' "result of check for `varlist'"

			restore, not
			sort `sortby' `pid'
		}
	}
end

program Clean	// rclass (but not declared).  It gets r(N) from -count- below
	syntax varname [if] [in] [, DOTs Pad ]    // does not allow -year()-

	marksample touse, strok

	tempvar c l
	// Not passing year() in the line below.  It will default to latest
	Check `varlist' if `touse', system(`c')
	quietly {
		if "`dots'" != "" {
			replace `c' = bsubstr(`c',1,3)+"."+bsubstr(`c',4,.)  ///
						if length(`c') > 3 & `touse'
			local len 5
		}
		else {
			local len 4
		}
		if "`pad'" != "" {
			replace `c' = bsubstr(`c' + "    ",1,`len') if `touse'
			replace `c' = "" if trim(`c')=="" & `touse'
		}
		gen byte `l' = length(`c') if `touse'
		summ `l' if `touse', meanonly
		local len = max(8,	///
			cond(length("`varlist'")>r(max), ///
				length("`varlist'"), r(max)) ///
			+ 1)
		count if `varlist' != `c' & `touse'
		local ch = r(N)
		local s = cond(`ch'==1, "", "s")
		replace `varlist' = `c' if `touse'
		compress `varlist'
		format `varlist' %-`len's
	}
	di as text "(`ch' change`s' made)"
end

program Gen
	gettoken newvar 0 : 0, parse(" =")
	gettoken eqsign 0 : 0, parse(" =")
	if `"`eqsign'"' != "=" {
		error 198
	}
	syntax varname [if] [in] [, CATegory SHort DOTs	///
		Description LONG END			///
		Range(string)				///
		year(string)				///
		]

	confirm new var `newvar'

	marksample touse, strok

	local nopt=("`category'"!="")+("`short'"!="")+("`description'"!="") ///
			+("`range'"!="")

	if `nopt' != 1 {
		di as err "{p}must specify one of options {bf:category}, " ///
			"{bf:short}, {bf:description} or {bf:range()}{p_end}"
		exit 198
	}

	if "`short'" == "" {	// dots only allowed with short
		if "`dots'" != "" {
			di as err "option {bf:dots} not allowed"
			exit 198
		}
	}

	if "`short'`category'`range'" != "" { // short, category, range() do
		if `"`year'"' != "" {  // not allow year()
			di as err "option {bf:year()} not allowed"
			exit 198
		}
	}

	if "`description'" == "" { // long & end only allowed with description
		if "`long'" != "" {
			di as err "option {bf:long} not allowed"
			exit 198
		}
		if "`end'" != "" {
			di as err "option {bf:end} not allowed"
			exit 198
		}
	}

	tempvar new c

	if "`category'" != "" {
		Check `varlist' if `touse', system(`c')
		GenThree `touse' `new' `c' `varlist'
	}
	else if "`short'" != "" {
		Check `varlist' if `touse', system(`c') longok
		GenShort `touse' `new' `c' `varlist' "`dots'"
	}
	else if "`description'" != "" {
		ChkYear `"`year'"'
		local year "`s(year)'"
		Check `varlist' if `touse', system(`c') year(`year')
		GenDesc `touse' `new' `c' `varlist' "`long'" "`end'" "`year'"
	}
	else if "`range'"  != "" {
		Check `varlist' if `touse', system(`c')
		GenRange `touse' `new' `c' `varlist' `"`range'"'
	}

	rename `new' `newvar'
end

program GenThree
	args touse new c userv

	quietly {
		gen str3 `new' = substr(`c',1,3) if `c'!="" & `touse'
	}
end

program GenShort
	args touse new c userv dots

	quietly {
		gen str5 `new' = substr(`c',1,4) if `c'!="" & `touse'
		if "`dots'" != "" {
			replace `new' = substr(`new',1,3) + "." +	///
				substr(`new',4,1) if length(`new')==4 & `touse'
		}
		compress `c'
	}
end

program GenDesc
	args touse new c userv long end yr

	if "`end'" != "" {
		local long "long"
	}

	FindFile "`yr'"
	local fn `"`r(fn)'"'

	// make an id var and keep track of current sort
	tempvar pid
	qui gen `c(obs_t)' `pid' = _n
	local sortby : sortedby

	tempname merge
	quietly {
		sort `c'
		rename `c' __code10
		merge m:1 __code10 using `"`fn'"', gen(`merge') nonotes ///
			keepusing(__code10 __desc10) keep(match master)
		sort `sortby' `pid' // restore sort
		rename __code10 `c'
		rename __desc10 `new'
		replace `c' = "" if !`touse'
		replace `new' = "" if !`touse'
		label var `new' "description of `userv'"
		count if `merge'!=3 & `c'!="" & `touse'
		local unlab = r(N)
		drop `merge'

		if "`long'" != "" {
			Clean `c' if `touse', dots
			replace `c' = substr(`c'+"      ",1,5) if `touse'
			if "`end'" == "" {
				replace `new' = `c' + " " + `new' if `touse'
			}
			else {
				replace `new' = `new' + " " + `c' if `touse'
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

program Lookup, rclass
	syntax anything [, year(string) ]

	ChkYear `"`year'"'
	local year "`s(year)'"

	local otok = trim(`"`anything'"')

	if wordcount(`"`otok'"') != 1 | strpos(`"`otok'"',"-") | ///
						strpos(`"`otok'"',"/") {
		Invalid `"`otok'"' "only one ICD-10 code allowed"
	}
	if strpos(`"`otok'"',"*") {
		Invalid `"`otok'"' "* not allowed"
	}

	IsEl `"`otok'"'		// takes care of most of the checks
	local tok `"`s(tok)'"'

	if length(`"`tok'"') < 3 {	// here anything < 3 is not allowed
		Invalid `"`otok'"' "code too short"
	}

	FindFile `"`year'"'
	local fn `"`r(fn)'"'

	preserve
	quietly {
		use `"`fn'"', clear
		keep __code10 __desc10
		keep if __code10 == `"`tok'"'
	}

	if _N == 0 {
		di as text "(no matches found)"
		ret scalar N = 0
		exit
	}
	else if _N > 1 {
		// shouldn't happen
		di as err "contact technical support; {bf:icd10} corrupted"
		exit 9027
	}
	else {	// _N == 1
		ret scalar N = 1
	}

	quietly Clean __code10, dots

	local code = __code10[1]
	if length("`code'") == 3 {
		local pad = "    "
	}
	else {
		local pad = "  "
	}
	di
	di `"{p 4 11 2}{res:`code'}{bind:`pad'}{txt:`=__desc10[1]'}{p_end}"'
end

program Query
	syntax		// no arguments or options allowed

	ChkYear  // no arg here on purpose; returns default/latest in s(year)
	FindFile `s(year)'
	local fn `"`r(fn)'"'
	mata: st_global("r(fn)", "")
	preserve
	quietly use `"`fn'"', clear

	di as text _n `"{p}{bf:`:char _dta[note1]'}{p_end}"'	// title
	local i 2
	local done 0
	while !`done' {
		local qnote `"`:char _dta[note`i']'"'
		if bsubstr(`"`qnote'"',1,6) == "----- " {
			if bsubstr(`"`qnote'"',7,7) == "License" {
				di as text _n "  {bf:License agreement}"
			}
			else if bsubstr(`"`qnote'"',7,4) == "Note" {
				di as text _n "  {bf:Note}"
			}
			else if bsubstr(`"`qnote'"',7,7) == "Edition" {
				local qnote =	///
					trim(subinstr(`"`qnote'"',"-","",.))
				di as text _n `"  {bf:`qnote'}"'
			}
		}
		else if `"`qnote'"' == "" {
			local done 1
		}
		else {
			di as text `"{p 4 8 2}`qnote'{p_end}"'
		}
		local ++i
	}
end

program ChkYear, sclass
	args yr

	local yr = trim(`"`yr'"')
	if `"`yr'"' == "" {
		local yr 2016
	}

	local ok 0
	if inlist(`"`yr'"',"2003","2004","2005","2006","2007","2008","2009") {
		local ok 1
	}
	if inlist(`"`yr'"',"2010","2011","2012","2013","2014","2015","2016") {
		local ok 1
	}

	if !`ok' {
		di as err ///
		   `"year(`yr') invalid; expected year between 2003 and 2016"'
		exit 198
	}

	if `"`yr'"' == "2005" {
		// There were no title changes between 2004 and 2005 (there
		// were other changes, just not title changes), so use 2004
		// when 2005 is requested.
		local yr 2004
	}

	if `"`yr'"' == "2015" {
		// There were no title changes between 2014 and 2015, so use
		// 2014 when 2015 is requested.
		local yr 2014
	}

	sret local year `yr'
end

program FindFile
	args yr
	local bname __i10
	local fname `bname'v`yr'.dta
	capture noi quietly findfile `"`fname'"'
	if c(rc) == 0 {
		exit
	}
	local rc = c(rc)
	di
	di as err "icd10 file not found"
	exit `rc'
end

program Merge
	args yr xmrg sortby pid c
	quietly rename `c' __code10
	FindFile `"`yr'"'
	local fn `"`r(fn)'"'
	quietly {
		sort __code10
		merge m:1 __code10 using `"`fn'"', nonotes gen(`xmrg')	///
				keepusing(__code10) keep(match master)
		sort `sortby' `pid'
		rename __code10 `c'
	}
end

program P_ilist, sclass		// parse/execute an icd10rangelist (ilist)
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
		di as err "<nothing> invalid ICD-10 code"
		exit 198
	}
	if strpos(`"`c'"', ".") {
		local l = strpos(`"`c'"', ".")
		local c = (trim(	///
			substr(`"`c'"',1,`l'-1) + substr(`"`c'"',`l'+1,.)  ///
			))
		if `l'>0 & `l'!=4 {
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
	if indexnot("`l'",c(ALPHA)) {
		Invalid `"`origc'"' "1st character must be A-Z"
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
				replace `newvar' = 1	///
					if `vn'>="`lb'" & `vn'<="`ub'" & `touse'
			}
			else if strpos("`1'", "*") {
				local sub = bsubstr("`1'",1,length("`1'")-1)
				local l = length("`sub'")
				replace `newvar' = 1	///
					if bsubstr(`vn',1,`l')=="`sub'" & `touse'
			}
			else {
				replace `newvar' = 1 if `vn'=="`1'" & `touse'
			}
			mac shift
		}
	}
end
