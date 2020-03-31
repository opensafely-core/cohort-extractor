*! version 1.0.9  06dec2019
program icd10cm
	version 15
	gettoken cmd 0 : 0, parse(" ,")
	local l = length(`"`cmd'"')

	global icd10cm_year = 2020

	if `"`cmd'"' == "check" {
		icd10cm_check `0'
	}
	else if `"`cmd'"' == "clean" {
		icd10cm_clean `0'
	}
	else if `"`cmd'"' == bsubstr("generate", 1, max(3,`l')) {
		icd10cm_generate `0'
	}
	else if `"`cmd'"' == bsubstr("lookup", 1, max(4,`l')) {
		icd10cm_lookup `0'
	}
	else if `"`cmd'"' == bsubstr("search",1,max(3,`l')) {
		icd10cm_search `0'
	}
	else if `"`cmd'"' == bsubstr("query", 1, max(1,`l')) {
		icd10cm_query `0'
	}
	else if `"`cmd'"' == "" | `"`cmd'"' == "," {
		di as err "icd10cm subcommand required"
		exit 198
	}
	else {
		di as err "invalid icd10cm subcommand"
		exit 198
	}
end

// icd10cm check
program icd10cm_check, rclass
	syntax varname [if] [in] [ , any FMTOnly GENerate(string)	///
		list SUMMary VERsion(numlist >0 integer min=1 max=1)	///
		system							///
		]

	if "`version'" != "" {
		icd10cm_check_version "`version'"
		local vn `"intro(__intro) del(__del) version(`version')"'
	}
	else {
		local vn `"intro(__intro) del(__del) version($icd10cm_year)"'
		local version "$icd10cm_year"
	}
	// icd will not catch the below errors because we use the -gen- option
	// with a tempvar
	if "`generate'" != "" {
		confirm new var `generate'
	}

	if "`any'" != "" | "`system'" != "" {
		local fmtonly "fmtonly"
	}

	if "`list'" != "" & "`summary'" != "" {
di as err `"may not specify both option {bf:summary} and option {bf:list}"'
		exit 198
	}

	local mlen 7

	tempvar prob
	noi icd check `varlist' `if' `in', using("__icd10cm")		///
		quickcheck minlength(3) maxlength(`mlen') dotrule(3)	///
		generate("`prob'") `vn' `fmtonly'

	local mye1 = r(e1)
	local mye2 = r(e2)
	local mye3 = r(e3)
	local mye4 = r(e4)
	local mye77 = r(e77)
	local mye88 = r(e88)
	local mye99 = r(e99)
	local mysum = r(esum)
	local mymiss = r(miss)

	return clear
	marksample touse, strok novarlist

	qui count if `touse'
	if r(N) < 1 {
		error 2000
	}
	else {
		local Nuse `r(N)'
	}

	if `mymiss' == `Nuse' {
		 di as text "(`varlist' contains all missing values)"

		ret scalar miss = `mymiss'
		ret scalar N=0
		ret scalar esum =0
		ret scalar e1 = 0
		ret scalar e2 = 0
		ret scalar e3 = 0
		ret scalar e4 = 0
		ret scalar e5 = 0
		ret scalar e6 = 0
		ret scalar e7 = 0
		ret scalar e8 = 0
		ret scalar e9 = 0
		ret scalar e10 = 0
		ret scalar e11 = 0
		if `"`fmtonly '"' == "" {
			if `"`version'"' != "" {
				ret scalar e77 = .
				ret scalar e88 = .
			}
			ret scalar e99 = 0
		}
		else {
			ret scalar e99 = .
		}
	}
	else {
		// additional code checks 5/8
		tempvar l code c

		quietly {
			if `"`fmtonly '"' != "" {
				local 99 = 0
			}
			else {
				local 99 = 99
			}

			local probeq "`prob'==. | `prob'==`99' | `prob'==0"
			gen `code' = upper(trim(`varlist')) if `touse'
			gen byte `l' = strpos(`code', ".") if `touse'
			replace `code' = (trim(				///
				bsubstr(`code',1,`l'-1)+		///
				bsubstr(`code',`l'+1,.))) if `l' & `touse'
			compress `code'
			drop `l'

			gen str1 `c' = bsubstr(`code',1,1) if `touse'

			// 5.  1st char A, B, ..., Z
			replace `prob'= 5 if `c'!="" 			///
				& indexnot(`c',c(ALPHA))		///
				& (`probeq') & `touse'
			count if `prob'==5 & `touse'
			local mye5 = r(N)

			//  6.  2nd char must be 0-9
			replace `c' = bsubstr(`code',2,1) if `touse'
			replace `prob'=6 if `c'!="" 			///
				& (`c'<"0" | `c'>"9")			///
				& ( `probeq') & `touse'
			count if `prob'==6 & `touse'
			local mye6 = r(N)

			// 7.  3rd char must be 0-9 A or B
			replace `c' = bsubstr(`code',3,1) if `touse'
			replace `prob'=7 if `c'!="" 		 	///
			& (`c'<"0" | `c'>"9" & `c' != "A" & `c' != "B")	///
				& (`probeq') & `touse'
			count if `prob'==7 & `touse'
			local mye7 = r(N)

			// 8.  4th char must be 0-9 A-Z or ""
			replace `c' = bsubstr(`code',4,1) if `touse'
			replace `prob'=8 if `c' == " " & `touse'
			replace `prob'=8 if `c'!="" 			///
				& (`c'<"0"|`c'>"9")			///
				& indexnot(`c',c(ALPHA)) 		///
				& (`probeq') & `touse'
			count if `prob'== 8 & `touse'
			local mye8 = r(N)

			// 9.  5th char must be 0-9 A-Z or ""
			replace `c' = bsubstr(`code',5,1) if `touse'
			replace `prob'=9 if `c' == " " & `touse'
			replace `prob'=9 if `c'!="" 			///
				& (`c'<"0"|`c'>"9")			///
				& indexnot(`c',c(ALPHA))	 	///
				& (`probeq') & `touse'
			count if `prob'== 9 & `touse'
			local mye9 = r(N)

			// 10.  6th char must be 0-9 A-Z or ""
			replace `c' = bsubstr(`code',6,1) if `touse'
			replace `prob'=10 if `c' == " " & `touse'
			replace `prob'=10 if `c'!=""			///
				& (`c'<"0"|`c'>"9")			///
				& indexnot(`c',c(ALPHA)) 		///
				& (`probeq') & `touse'
			count if `prob'== 10 & `touse'
			local mye10 = r(N)

			// 11.  7th char must be 0-9 A-Z or ""
			replace `c' = bsubstr(`code',7,1) if `touse'
			replace `prob'=11 if `c'!=""			///
				& (`c'<"0"|`c'>"9")			///
				& indexnot(`c',c(ALPHA)) & `c'!=""	///
				& (`probeq') & `touse'
			count if `prob'== 11 & `touse'
			local mye11 = r(N)

			if "`version'" == "" {
				replace `prob'=99 if `prob'==77 |	///
				`prob'==88 & `touse'
			}
			// fill in rest of values
			replace `prob' = 0 if `prob'==. & `touse'
		}

		qui count if `prob' & `touse'
		local bad_codes = r(N)

		if ("`system'" != "") {
			if (`bad_codes') {
				di as err				///
				"`varlist' contains invalid codes"
		                exit 459
			}
			else {
				exit
			}
		}
		local esum = `r(N)'	
		ret scalar esum = `esum'
		qui count if `code'=="" & `touse'
		ret scalar miss = r(N)
		local mymiss = r(N)
		qui count if trim(`code')!="" & `touse'
		ret scalar N = r(N)

		if `mymiss'==`Nuse' {
			local msgstub "all missing values"
		}
		else if `mymiss'==0 {
			local msgstub "no missing values"
		}
		else {
			local s = cond(`mymiss'==1, "", "s")
			local msgstub "`mymiss' missing value`s'"
		}

		if `bad_codes' == 0 {
			if `mymiss'==`Nuse' {
				di as text "(`varlist' contains `msgstub')"
			}
			else {
				di as text				///
				"(`varlist' contains defined codes; `msgstub')"
			}
			ret scalar miss = `mymiss'
			ret scalar esum =0
			ret scalar e1 = 0
			ret scalar e2 = 0
			ret scalar e3 = 0
			ret scalar e4 = 0
			ret scalar e5 = 0
			ret scalar e6 = 0
			ret scalar e7 = 0
			ret scalar e8 = 0
			ret scalar e9 = 0
			ret scalar e10 = 0
			ret scalar e11 = 0
			if `"`version'"' != "" {
				ret scalar e77 = 0
				ret scalar e88 = 0
			}
			ret scalar e99 = 0
		}
		else {
			local inv_und "undefined"
			qui count if `touse' &				///
				inlist(`prob', 1,2,3,4,5,6,7,8,9,10,11)
			if r(N) {
				local inv_und "invalid"
			}
			di as text "(`varlist' contains `msgstub')"
			di // not as err, no extra line if output suppressed
			di as err "`varlist' contains `inv_und' codes:"
			di // not as err, no extra line if output suppressed

// table output
// Code 1 ---------------------------------------------------------------
			di as text "    1.  Invalid placement of period" ///
				_col(49) as res %11.0gc `mye1'
			ret scalar e1 = `mye1'
// Code 2 ---------------------------------------------------------------
			di as text "    2.  Too many periods"		///
				_col(49) as res %11.0gc `mye2'
			ret scalar e2 = `mye2'
// Code 3 ---------------------------------------------------------------
			di as text "    3.  Code too short"		///
				_col(49) as res %11.0gc `mye3'
			ret scalar e3 = `mye3'
// Code 4 ---------------------------------------------------------------
			di as txt "    4.  Code too long"		///
				_col(49) as res %11.0gc `mye4'
			ret scalar e4 = `mye4'
// Code 5 ---------------------------------------------------------------
			di as txt "    5.  Invalid 1st char (not A-Z)"	///
				_col(49) as res %11.0gc `mye5'
			ret scalar e5 = `mye5'
// Code 6 ---------------------------------------------------------------
			di as txt "    6.  Invalid 2nd char (not 0-9)"	///
				_col(49) as res %11.0gc `mye6'
			ret scalar e6 = `mye6'
// Code7 ---------------------------------------------------------------
			di as txt					///
			"    7.  Invalid 3rd char (not 0-9 A or B)"	///
				_col(49) as res %11.0gc `mye7'
			ret scalar e7 = `mye7'
// Code8 ---------------------------------------------------------------
			di as txt					///
			"    8.  Invalid 4th char (not 0-9 or A-Z)"	///
				_col(49) as res %11.0gc `mye8'
			ret scalar e8 = `mye8'
// Code9 ---------------------------------------------------------------
			di as txt					///
			"    9.  Invalid 5th char (not 0-9 or A-Z)"	///
				_col(49) as res %11.0gc `mye9'
			ret scalar e9 = `mye9'
// Code10 ---------------------------------------------------------------
			di as txt					///
			"   10.  Invalid 6th char (not 0-9 or A-Z)"	///
				_col(49) as res %11.0gc `mye10'
			ret scalar e10 = `mye10'

// Code11 ---------------------------------------------------------------
			di as txt					///
			"   11.  Invalid 7th char (not 0-9 or A-Z)"	///
				_col(49) as res %11.0gc `mye11'
			ret scalar e11 = `mye11'

			if "`version'" != "" & "`fmtonly'" == "" {
// Code 77 ---------------------------------------------------------------
				di as txt				///
				"   77.  Valid only for previous versions" ///
					_col(49) as res %11.0gc `mye77'
				ret scalar e77 = `mye77'
// Code 88 ---------------------------------------------------------------
				di as text				///
				"   88.  Valid only for later versions" ///
					_col(49) as res %11.0gc `mye88'
				ret scalar e88 = `mye88'
// Code 99 ---------------------------------------------------------------
			}
			if "`fmtonly'" == "" {
				qui count if `prob'== 99 & `touse'
				di as text "   99.  Code not defined"	///
					_col(49) as res %11.0gc r(N)
				ret scalar e99 = r(N)
			}
			else {
				ret scalar e99 = .
			}

			di in smcl as text _col(49) "{hline 11}"
			di as text _col(9) "Total" ///
				_col(49) as res %11.0gc `bad_codes'
		}

		if "`list'" != "" | "`summary'" != "" & `bad_codes' > 0 {
			preserve
			quietly {
				gen byte count = 1 if `touse'
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
				replace __prob = "Invalid 5th char"	///
					if `prob'==9 & `touse'
				replace __prob = "Invalid 6th char"	///
					if `prob'==10 & `touse'
				replace __prob = "Invalid 7th char"	///
					if `prob'==11 & `touse'
				replace __prob =			///
				"Valid only for previous versions"	///
					if `prob'==77 & `touse'
				replace __prob =			///
					"Valid only for later versions"	///
					if `prob'==88 & `touse'
				replace __prob = "Code not defined"	///
					if `prob'==99 & `touse'
				format __prob %-27s
				if "`summary'" != "" {
					collapse (count) count		///
						if `prob'!=0		///
						& `prob'!=. & `touse',	///
						by(`varlist' __prob)
						gsort -count `varlist'
				}
			}
			char __prob[varname] "Problem"
			char count[varname] "Count"
			if "`list'" != "" {
			di _n as txt "Listing of invalid and undefined codes"
				list `varlist' __prob if `prob'!=0 &	///
					`prob'!=. & `touse', subvarname
			}
			else {
				if "`fmtonly'" == "" {
			di _n as txt "Summary of invalid and undefined codes"
				}
				else {
			di _n as txt "Summary of invalid codes"
				}
				qui rename __prob problem
				list `varlist' count problem,		///
					noobs separator(0) subvarname
			}
			restore
		}
	}

	if `"`generate'"' != "" {
		if "`code'" != "" {
			qui replace `prob' = . if `code'=="" & `touse'
		}
		qui rename `prob' `generate'

		qui label define __icd10cm				///
			0  "Defined code"				///
			1  "Invalid placement of period"		///
			2  "Too many periods"				///
			3  "Code too short"				///
			4  "Code too long"				///
			5  "Invalid 1st char (not A-Z)"			///
			6  "Invalid 2rd char (not 0-9)"			///
			7  "Invalid 3rd char (not 0-9 A or B)"		///
			8  "Invalid 4th char (not 0-9 or A-Z)"		///
			9  "Invalid 5th char (not 0-9 or A-Z)"		///
			10 "Invalid 6th char (not 0-9 or A-Z)"		///
			11 "Invalid 7th char (not 0-9 or A-Z)"		///
			77 "Valid only for previous versions"		///
			88 "Valid only for later versions"		///
			99 "Code not defined"				///
			, replace
		qui label values `generate' __icd10cm
		qui label var `generate' "result of check for `varlist'"
	}
end

//icd10cm clean
program icd10cm_clean
	syntax varname [if] [in] [, replace GENerate(string)		///
		nodots pad check					///
		]

	if "`check'" != "" {
		icd10cm_check `varlist' `if' `in', system fmtonly
	}

	if "`dots'" != "nodots" {
		local dots "dots dotrule(3)"
	}

	if "`generate'" != "" {
		local gen "generate(`generate')"
	}

	local maxlength "maxlength(7)"
	icd clean `varlist' `if' `in', `maxlength' `replace' `gen' `dots' `pad'
end

// icd10cm generate
program icd10cm_generate, rclass
	gettoken newvar 0 : 0, parse(" =")
	gettoken eqsign 0 : 0, parse(" =")

	if `"`eqsign'"' != "=" {
		error 198
	}

	syntax varname [if] [in] [,					///
		CATegory Description Range(string)			///
		addcode(string) long nodots pad				///
		VERsion(numlist >0 integer min=1 max=1) check		///
		]

	if "`check'" != "" {
		icd10cm_check `varlist' `if' `in', system fmtonly
	}

	if "`version'" != "" {
		icd10cm_check_version "`version'"
		if "`category'" != "" {
di as err "option {bf:version} cannot be combined with option {bf:category}"
			exit 198
		}
		if "`range'" != "" {
di as err "option {bf:version} cannot be combined with option {bf:range()}"
			exit 198
		}
		local version `"intro(__intro) del(__del) version(`version')"'
	}
	else {
		local version `"intro(__intro) del(__del) version($icd10cm_year)"'
	}

	if "`addcode'" != "" {
		local addcode "addcode(`addcode')"
	}

	if "`description'" == "" {
		if "`long'" != "" {
di as err "option {bf:long} only allowed with option {bf:description}"
			exit(198)
		}
		local opts = substr(`"`0'"', strpos(`"`0'"', ","), .)
		local has_dots = strpos(`"`opts'"', " dots")
		if `has_dots' > 0 {
di as err "option {bf:dots} only allowed with option {bf:description}"
			exit 198
		}
	}

	if "`category'" != "" {
		local category "category catrule(3)"
	}
	if "`description'" != "" {
		local description `"description using("__icd10cm") `version'"'
		if "`long'" != "" {
			local long "descrvar(__ldescr)"
		}
		else {
			local long "descrvar(__descr)"
		}
		if "`dots'" == "" {
			local dots "dotrule(3)"
		}
		local rules "maxlength(7)"
	}
	if "`range'" != "" {
		local range "range(`range')"
	}
	icd generate `newvar' = `varlist' `if' `in',			///
		`category' `description' `range'			///
		`addcode' `long' `rules' `dots' `pad'
end

// icd10cm lookup
program icd10cm_lookup, rclass
	syntax anything(everything) [,					///
		version(numlist >0 integer min=1)]

	if "`version'" != "" {
		icd10cm_check_version "`version'"
		local vn `"intro(__intro) del(__del) version(`version')"'
	}
	else {
		local vn `"intro(__intro) del(__del) version($icd10cm_year)"'
	}

	icd lookup `anything', using("__icd10cm") `vn'
	ret scalar N_codes = r(N_codes)
end

// icd10cm search
program icd10cm_search, rclass
	syntax anything(id="search text") [, or MATCHCase		///
		version(numlist >0 integer min=1) year(string)]
	if "`version'" != "" {
		icd10cm_check_version "`version'"
		local vn `"intro(__intro) del(__del) version(`version')"'
	}
	else {
		local vn `"intro(__intro) del(__del) version($icd10cm_year)"'
	}
	icd search `anything', using("__icd10cm") descrvar(__ldescr)	///
		`vn' `or' `matchcase'
	ret scalar N_codes = r(N_codes)
end

// icd10cm query
program icd10cm_query
	syntax

	icd query, using("__icd10cm")
end

// utility commands
program icd10cm_check_version
	args version

	if !inlist(`"`version'"',"2016","2017","2018","2019","2020") {
		di as err "{bf:`version'}: invalid value for {bf:version()}"
		exit 198
	}
end

