*! version 1.1.10  15mar2018
program icd10
	local version : di "version " string(_caller()) ":"
	if _caller() < 14.2 {
		icd10_14_1 `0'
		exit
	}
	version 15
	gettoken cmd 0 : 0, parse(" ,")
	local l = length(`"`cmd'"')

	if `"`cmd'"' == "check" {
		`version' icd10_check `0'
	}
	else if `"`cmd'"' == "clean" {
		`version' icd10_clean `0'
	}
	else if `"`cmd'"' == bsubstr("generate", 1, max(3,`l')) {
		`version' icd10_generate `0'
	}
	else if `"`cmd'"' == bsubstr("lookup", 1, max(4,`l')) {
		`version' icd10_lookup `0'
	}
	else if `"`cmd'"' == bsubstr("search",1,max(3,`l')) {
		`version' icd10_search `0'
	}
	else if `"`cmd'"' == bsubstr("query", 1, max(1,`l')) {
		`version' icd10_query `0'
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

// icd10 check
program icd10_check, rclass
	syntax varname [if] [in] [ , any FMTOnly GENerate(string)	///
		list SUMMary VERsion(numlist >0 integer min=1 max=1)	///
		year(string)						///
		system(string)						///
		]

	if "`year'" != "" {
		local version "`year'"
	}
	if "`version'" != "" {
		icd10_check_version "`version'"
		local vn `"intro(__intro) del(__del) version(`version')"'
	}
	else {
		local vn `"intro(__intro) del(__del) version(2016)"'
		local version "2016"
	}
	// icd will not catch the below errors because we use the -gen- option
	// with a tempvar
	if "`generate'" != "" {
		confirm new var `generate'
	}

	if "`any'" != "" {
		local fmtonly "fmtonly"
	}

	if "`list'" != "" & "`summary'" != "" {
di as err `"may not specify both option {bf:summary} and option {bf:list}"'
		exit 198
	}

	if ("`system'" != "") {
		local fmtonly "fmtonly"
	}

	local mlen 4

	tempvar prob
	noi icd check `varlist' `if' `in', using("__icd10")		///
		quickcheck minlength(3) maxlength(`mlen') dotrule(3)	///
		generate("`prob'") `vn' `fmtonly'

	local mye1 = r(e1)
	local mye2 = r(e2)
	local mye3 = r(e3)
	local mye4 = r(e4)
	local mye77 = r(e77)
	local mye88 = r(e88)
	local mye99 = r(e99)
	local mymiss = r(miss)
	local mysum = r(esum)

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

		ret scalar esum =0
		ret scalar miss = `mymiss'
		ret scalar e1 = 0
		ret scalar e2 = 0
		ret scalar e3 = 0
		ret scalar e4 = 0
		ret scalar e5 = 0
		ret scalar e6 = 0
		ret scalar e7 = 0
		ret scalar e8 = 0
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
			replace `prob'= 5 if `c'!=""			///
				& indexnot(`c',c(ALPHA))		///
				& (`probeq') & `touse'
			count if `prob'==5 & `touse'
			local mye5 = r(N)

			//  6.  2nd char must be 0-9
			replace `c' = bsubstr(`code',2,1) if `touse'
			replace `prob'=6 if `c'!=""			///
				& (`c'<"0" | `c'>"9")			///
				& ( `probeq') & `touse'
			count if `prob'==6 & `touse'
			local mye6 = r(N)

			// 7.  3rd char must be 0-9
			replace `c' = bsubstr(`code',3,1) if `touse'
			replace `prob'=7 if `c'!="" 		 	///
				& (`c'<"0" | `c'>"9")	///
				& (`probeq') & `touse'
			count if `prob'==7 & `touse'
			local mye7 = r(N)

			// 8.  4th char must be 0-9 or ""
			replace `c' = bsubstr(`code',4,1) if `touse'
			replace `prob'=8 if `c' == " " & `touse'
			replace `prob'=8 if `c'!="" 			///
				& (`c'<"0"|`c'>"9")			///
				& (`probeq') & `touse'
			count if `prob'== 8 & `touse'
			local mye8 = r(N)

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
				"`varlist' contains invalid `system' codes"
		                exit 459
			}
			else {
				exit
			}
		}

		ret scalar esum = r(N)
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
			ret scalar esum =0
			ret scalar miss = `mymiss'
			ret scalar e1 = 0
			ret scalar e2 = 0
			ret scalar e3 = 0
			ret scalar e4 = 0
			ret scalar e5 = 0
			ret scalar e6 = 0
			ret scalar e7 = 0
			ret scalar e8 = 0
			if `"`version'"' != "" {
				ret scalar e77 = 0
				ret scalar e88 = 0
			}
			ret scalar e99 = 0
		}
		else {
			local inv_und "undefined"
			qui count if `touse' &				///
				inlist(`prob', 1,2,3,4,5,6,7,8)
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
			"    7.  Invalid 3rd char (not 0-9)"	///
				_col(49) as res %11.0gc `mye7'
			ret scalar e7 = `mye7'
// Code8 ---------------------------------------------------------------
			di as txt					///
			"    8.  Invalid 4th char (not 0-9)"	///
				_col(49) as res %11.0gc `mye8'
			ret scalar e8 = `mye8'

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
				replace __prob =			///
				"Valid only for previous versions"	///
					if `prob'==77 & `touse'
				replace __prob =			///
					"Valid only for later versions"	///
					if `prob'==88 & `touse'
				replace __prob = "Code not defined"	///
					if `prob'==99 & `touse'
				format __prob %-27s
				if "`summary'"!= "" {
					collapse (count) count		///
						if `prob'!=0		///
						& `prob'!=. & `touse',	///
						by(`varlist' __prob)
					if _caller() > 14.2 {
						gsort -count `varlist'
					}
				}
			}
			char __prob[varname] "Problem"
			char count[varname] "Count"
			if "`list'" != "" {
			di _n as text "Listing of invalid and undefined codes"
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
		if _caller() < 15 {
			local lab0 "Defined code or missing"
		}
		else {
			if "`code'" != "" {
				qui replace `prob' = . if `code'=="" & `touse'
			}
			local lab0 "Defined code"
		}
		qui rename `prob' `generate'

		qui label define __icd10who			///
			0  "`lab0'"				///
			1  "Invalid placement of period"	///
			2  "Too many periods"			///
			3  "Code too short"			///
			4  "Code too long"			///
			5  "Invalid 1st char (not A-Z)"		///
			6  "Invalid 2rd char (not 0-9)"		///
			7  "Invalid 3rd char (not 0-9)"		///
			8  "Invalid 4th char (not 0-9)"		///
			77 "Valid only for previous versions"	///
			88 "Valid only for later versions"	///
			99 "Code not defined"			///
			, replace
		qui label values `generate' __icd10who
		qui label var `generate' "result of check for `varlist'"
	}
end

//icd10 clean
program icd10_clean
	if _caller() < 15 {
		syntax varname [if] [in] [, replace GENerate(string)	///
			dots pad check					///
			]
	}
	else {
		syntax varname [if] [in] [, replace GENerate(string)	///
			nodots pad check				///
			]
	}

	if "`check'" != "" {
		icd10_check `varlist' `if' `in', system("ICD10") fmtonly
	}
	if _caller() < 15 {
		if "`dots'" != "" {
			local dots "dots dotrule(3)"
		}
		else {
			local dots "nodots"
		}
	}
	else {
		if "`dots'" == "nodots" {
			local dots "nodots"
		}
		else {
			local dots "dots dotrule(3)"
		}
	}

	if "`generate'" != "" {
		local gen "generate(`generate')"
	}

	local maxlength "maxlength(4)"

	icd clean `varlist' `if' `in', `maxlength' `replace' `gen' `dots' `pad'
end

// icd10 generate
program icd10_generate, rclass
	gettoken newvar 0 : 0, parse(" =")
	gettoken eqsign 0 : 0, parse(" =")

	if `"`eqsign'"' != "=" {
		error 198
	}

	syntax varname [if] [in] [,					///
		CATegory SHort Description Range(string)		///
		addcode(string) long end nodots pad			///
		VERsion(numlist >0 integer min=1 max=1) check		///
		year(string)						///
		]

	if "`year'" != "" {
		local version "`year'"
	}
	if "`check'" != "" {
		icd10_check `varlist' `if' `in', system("ICD10") fmtonly
	}

	//Add check for short
	local nopt=("`category'"!="")+("`short'"!="")+			///
		("`description'"!="")+("`range'"!="")
	if `nopt' != 1 {
		di as err "you must specify one of options "		///
			"{bf:category}, {bf:description}, {bf:range()} " ///
			"or {bf:short}"
		exit 198
	}

	if "`version'" != "" {
		icd10_check_version "`version'"
		if "`category'" != "" {
di as err "option {bf:version} cannot be combined with option {bf:category}"
			exit 198
		}
		if "`range'" != "" {
di as err "option {bf:version} cannot be combined with option {bf:range()}"
			exit 198
		}
		if "`short'" != "" {
di as err "option {bf:version} cannot be combined with option {bf:short}"
			exit 198
		}
		local version `"intro(__intro) del(__del) version(`version')"'
	}
	else {
		local version `"intro(__intro) del(__del) version(2016)"'
	}

	if "`addcode'" != "" {
		local addcode "addcode(`addcode')"
	}
	if "`long'" != "" {
		local addcode "`addcode' addcode(begin)"
	}

	if "`end'" != "" {
		local addcode "`addcode' addcode(end)"
	}

	if "`description'" == "" & "`full'" != "" {
		if "`full'" != "" {
di as err "option {bf:full} only allowed with option {bf:description}"
			exit(198)
		}
		local opts = substr("`0'", strpos("`0'", ","), .)
		local has_dots = strpos("`opts'", " dots")
		if `has_dots' > 0 {
di as err "option {bf:dots} only allowed with option {bf:description}"
			exit 198
		}
	}

	if "`category'" != "" {
		local category "category catrule(3)"
	}
	if "`description'" != "" {
		local description `"description using("__icd10") `version'"'
		if "`full'" != "" {
			local full "descrvar(__ldescr)"
		}
		else {
			local full "descrvar(__descr)"
		}
		if "`dots'" == "" {
			local dots "dotrule(3)"
		}
		local rules "maxlength(4)"
	}

	if "`range'" != "" {
		local range "range(`range')"
	}
	icd generate `newvar' = `varlist' `if' `in',			///
		`category' `description' `range'			///
		`addcode' `full' `rules' `dots' `pad' `short'
end

// icd10 lookup
program icd10_lookup, rclass
	syntax anything(everything) [,					///
		version(numlist >0 integer min=1) year(string)]

	if "`year'" != "" {
		local version "`year'"
	}
	if "`version'" != "" {
		icd10_check_version "`version'"
		local vn `"intro(__intro) del(__del) version(`version')"'
	}
	else {
		local vn `"intro(__intro) del(__del) version(2016)"'
	}

	icd lookup `anything', using("__icd10") `vn'

	if _caller() < 15 {
		ret scalar N=r(N_codes)
	}
	else {
		ret scalar N_codes =r(N_codes)
	}
end

// icd10 search
program icd10_search, rclass
	syntax anything(id="search text") [, or MATCHCase 		///
		version(numlist >0 integer min=1) year(string)]

	if _caller() < 15 {
		local matchcase "matchcase"
	}

	if "`version'" != "" {
		icd10_check_version "`version'"
		local vn `"intro(__intro) del(__del) version(`version')"'
	}
	else {
		local vn `"intro(__intro) del(__del) version(2016)"'
	}
	icd search `anything', using("__icd10") `or' `vn' `matchcase'

	if _caller() < 15 {
		ret scalar N=r(N_codes)
	}
	else {
		ret scalar N_codes=r(N_codes)
	}
end

// icd10 query
program icd10_query
	syntax

	icd query, using("__icd10")
end

// utility commands
program icd10_check_version
	args version

	local ok 0
	if inlist(`"`version'"',"2003","2004","2005","2006","2007","2008") {
		local ok 1
	}
	if inlist(`"`version'"',"2009","2010","2011","2012","2013","2014") {
		local ok 1
	}
	if inlist(`"`version'"',"2015","2016") {
		local ok 1
	}

	if !`ok' {
		di as err "{bf:`version'}: invalid value for {bf:version()}"
		exit 198
	}
end

