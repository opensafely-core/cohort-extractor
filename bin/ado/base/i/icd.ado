*! version 1.0.14  15mar2018
program icd
	version 14
	local version : di "version " string(_caller()) ":"

	gettoken cmd 0 : 0, parse(" ,")
	local l = length(`"`cmd'"')
	if `"`cmd'"' == "check" {
		`version' icd_check `0'
	}
	else if `"`cmd'"' == "clean" {
		`version' icd_clean `0'
	}
	else if `"`cmd'"' == bsubstr("generate",1,max(3,`l')) {
		`version' icd_generate `0'
	}
	else if `"`cmd'"' == bsubstr("lookup",1,max(4,`l')) {
		`version' icd_lookup `0'
	}
	else if `"`cmd'"' == bsubstr("search",1,max(3,`l')) {
		`version' icd_search `0'
	}
	else if `"`cmd'"' == bsubstr("query",1,max(1,`l')) {
		`version' icd_query `0'
	}
	else if `"`cmd'"' == "" | `"`cmd'"' == "," {
		di as err "icd subcommand required"
		exit 198
	}
	else {
		di as err "invalid icd subcommand"
		exit 198
	}
end

program icd_check, rclass
	syntax varname [if] [in], using(string)				///
		[							///
		GENerate(name) List SUMMary key(name)			///
		dotrule(numlist >0 integer min=1 max=1)			///
		MINlength(numlist >0 integer min=1 max=1)		///
		MAXlength(numlist >0 integer min=1 max=1)		///
		VERsion(numlist >0 integer min=1 max=1)			///
		INTROduced(name) DELeted(name) fmtonly			///
		DEFIned quickcheck					///
		]

	local typ : type `varlist'
	if bsubstr("`typ'",1,3) != "str" {
		di as err ///
			"{p}{bf:`varlist'}: code variable  "		///
			"must be stored as a string{p_end}"
		exit 459
	}

	if `"`generate'"' != "" {
		confirm new var `generate'
	}

	if "`generate'" != "" & "`list'" != "" {
di as err `"may not specify both option {bf:generate()} and option {bf:list}"'
		exit 198
	}

	if "`generate'" != "" & "`summary'" != "" {
di as err "may not specify both option {bf:generate()} and option {bf:summary}"
		exit 198
	}
	if "`list'" != "" & "`summary'" != "" {
di as err `"may not specify both option {bf:summary} and option {bf:list}"'
		exit 198
	}

	icd__findfile `"`using'"'
	local using `"`r(fn)'"'

	icd__check_version_vars `"`using'"' "notnew"			///
		"`version'" "`introduced'" "`deleted'"

	if `"`key'"' != "" {
		capture des `key' using `"`using'"'
		if _rc {
di as error  `"variable {bf:`key'} not found in file {bf:`using'}"'
			exit _rc
		}
		local codevar "`key'"
	}
	else {
		local codevar "__code"
	}

	if `"`minlength'"' == "" {
		local minlength = 3
	}
	if `"`maxlength'"' == "" {
		local maxlength = 7
	}
	if `"`dotrule'"' == "" {
		local dotrule = 3
	}
	local dotrule = `dotrule' + 1

	if `"`defined'"' == "" {
		local not_defined "Code not valid, other reasons"
	}
	else {
		local not_defined "Code not defined"
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
		tempvar code prob l
		local typ : type `varlist'
		gen `typ' `code' = strupper(trim(`varlist')) if `touse'
		compress `code'

		// 0.  code may contain "", missing
		gen byte `prob' = cond(`code'=="", 0, .) if `touse'

		// 1.  invalid placement of periods
		// 2.  too many periods
		capture assert strpos(`code', ".") == 0 if `touse'
		if c(rc) {
			gen byte `l' = strpos(`code', ".") if `touse'
			replace `code' = 				///
				(trim(bsubstr(`code',1,`l'-1)+		///
				bsubstr(`code',`l'+1,.))) if `l' & `touse'
			compress `code'
			replace `prob' = 1 if `l'>0 & `l'!=`dotrule' & ///
							`prob'==. & `touse'
			replace `prob' = 2 if strpos(`code', ".") & `touse'
			drop `l'
		}

		// 3.  code too short
		// 4.  code too long
		gen byte `l' = length(`code') if `touse'
		replace `prob'=3 if `l'<`minlength' & `prob'==. & `touse'
		qui replace `prob'=4 if `l'>`maxlength' & `prob'==. & `touse'
		drop `l'
	}

	// 99. undefined code
	qui count if `code'=="" & `touse'
	local miss = r(N)
	qui count if trim(`code')!="" & `touse'
	return scalar N = r(N)
	// user for generate()
	tempvar pid
	qui gen `c(obs_t)' `pid' = _n
	local sortby : sortedby

	if "`version'" != "" {
		tempfile icd
		icd__create_icd_version_data `"`using'"' "`icd'"	///
			"`codevar'" "`version'" "`introduced'" "`deleted'" 0
		local using `"`icd'"'
	}

	preserve

	if `miss' != `Nuse' & "`fmtonly'" == "" {
		quietly {
			tempvar xmrg
			// make an id var and also keep track of current sort
			keep `sortby' `touse' `pid' `varlist' `prob' `code'
			quietly rename `code' `codevar'
			sort `codevar'
			merge m:1 `codevar' using `"`using'"',		///
				nonotes gen(`xmrg')			///
				keepus(`codevar' `introduced' `deleted') ///
				keep(match master)
			sort `sortby' `pid'
			rename `codevar' `code'
			replace `prob' = 99 if `xmrg'!=3		///
				& `prob'==. & `code'!="" & `touse'
			drop `xmrg' `pid'
		}
		if "`version'" != "" {
			if "`deleted'" != "" {
				qui replace `prob'=77 if		///
					`deleted'<=`version' &		///
					`prob'==. & `touse'
				drop `deleted'
			}
			if `"`introduced'"' != "" {
				qui replace `prob'=88 if		///
					`introduced'>`version' &	///
					`prob'==. & `touse'
				drop `introduced'
			}
		}
	}
	qui replace `prob' = 0 if `prob'==. & `touse'  // clean up prob

	if "`quickcheck'" != "" {
		qui count if `prob'==1 & `touse'
		ret scalar e1 = r(N)
		qui count if `prob'==2 & `touse'
		ret scalar e2 = r(N)
		qui count if `prob'==3 & `touse'
		ret scalar e3 = r(N)
		qui count if `prob'==4 & `touse'
		ret scalar e4 = r(N)
		qui count if `prob'==77 & `touse'
		ret scalar e77 = r(N)
		qui count if `prob'==88 & `touse'
		ret scalar e88 = r(N)
		qui count if `prob'==99 & `touse'
		ret scalar e99 = r(N)
		qui count if `prob' & `touse'
		return scalar esum = r(N)
		return scalar miss = `miss'
	}
	else {
		qui count if `prob' & `touse'
		local bad = r(N)
		return scalar esum = r(N)
		return scalar miss = `miss'

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
				`di as text "(`varlist' contains `msgstub')"
			}
			else {
				di as text				///
				"(`varlist' contains defined codes; `msgstub')"
			}
			return scalar e1 = 0
			return scalar e2 = 0
			return scalar e3 = 0
			return scalar e4 = 0
			if `"`version'"' != "" {
				if "`deleted'" != "" {
					return scalar e77 = 0
				}
				return scalar e88 = 0
			}

			return scalar e99 = 0	// sic
			exit
		}

		local inv_und "undefined"
		qui count if `touse' & inlist(`prob', 1,2,3,4)
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
		di as text "    3.  Code too short	"		///
			_col(49) as res %11.0gc r(N)
		ret scalar e3 = r(N)

		qui count if `prob'==4 & `touse'
		di as text "    4.  Code too long"			///
			_col(49) as res %11.0gc r(N)
		ret scalar e4 = r(N)

		if "`version'" != "" & "`fmtonly'" == "" {
			qui count if `prob'==77 & `touse'
			di as text					///
			"   77.  Valid only for previous versions"	///
				_col(49) as res %11.0gc r(N)
			ret scalar e77 = r(N)

			qui count if `prob'==88 & `touse'
			di as text					///
				"   88.  Valid only for later versions"	///
				_col(49) as res %11.0gc r(N)
			ret scalar e88 = r(N)
		}
		if "`fmtonly'" == "" {
			qui count if `prob'==99 & `touse'
			di as text "   99.  `not_defined'"		///
				_col(49) as res %11.0gc r(N)
			ret scalar e99 = r(N)
		}
		else {
			ret scalar e77 = .
			ret scalar e88 = .
			ret scalar e99 = .
		}

		di in smcl as text _col(49) "{hline 11}"
		di as text _col(9) "Total" _col(49) as res %11.0gc `bad'

		if "`list'" != "" | "`summary'" != ""{
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
						if `prob'!=0 &		///
						`prob'!=. & `touse',	///
						by(`varlist' __prob `prob')
					gsort -count `varlist'
				}
			}
			char __prob[varname] "Problem"
			char count[varname] "Count"
			if "`list'" != "" {
			di _n as text "Listing of invalid and undefined codes"
				list `varlist' __prob if `prob'!=0 &	///
					`prob'!=. & `touse', 		///
					subvarname
			}
			else {
				if "`fmtonly'" == "" {
			di _n as txt "Summary of invalid and undefined codes"
				}
				else {
			di _n as txt "Summary of invalid codes"
				}

				list `varlist' count __prob,		///
					noobs separator(0) subvarname
			}
		}
	}

	if `"`generate'"' != "" {
		quietly {
			if "`code'" != "" {
				replace `prob' = . if `code'=="" & `touse'
			}
			keep `prob'
			rename `prob' `generate'
			tempfile one
			save `"`one'"'
			restore, preserve
			tempvar x
			merge 1:1 _n using `"`one'"',			///
				gen(`x') assert(match) nonotes
			drop `x'

			if "`quickcheck'" == "" {
				label define __icd			///
				0  "Defined code"			///
				1  "Invalid placement of period"	///
				2  "Too many periods"			///
				3  "Code too short"			///
				4  "Code too long"			///
				77 "Valid only for previous versions"	///
				88 "Valid only for later versions"	///
				99 "`not_defined'"			///
				, replace
				label values `generate' __icd

				label var `generate' 			///
					"result of check for `varlist'"
			}
			restore, not
			sort `sortby' `pid'
		}
	}
end

program icd_clean
	syntax varlist [if] [in], 					///
		[GENerate(name)	replace					///
		nodots pad 						///
		dotrule(numlist >0 integer min=1 max=1)			///
		MAXlength(numlist >0 integer min=1 max=1)		///
		]

	local typ : type `varlist'
	if bsubstr("`typ'",1,3) != "str" {
		di as err						///
			"{p}{bf:`varlist'}: code variable  "		///
			"must be stored as a string{p_end}"
		exit 459
	}

	if "`generate'" == "" & "`replace'" == "" {
di as err "you must specify either option {bf:generate()} or option {bf:replace}"
		exit 198
	}

	if "`generate'" != "" & "`replace'" != "" {
di as err `"option {bf:generate()} cannot be combined with option {bf:replace}"'
		exit 198
	}

	if `"`generate'"' != "" {
		confirm new var `generate'
	}
	if `"`maxlength'"' == "" {
		local maxlength = 5
	}
	if `"`dotrule'"' != "" & "`dots'" != "" {
		di as err "option {bf:nodots} cannot be combined "	///
		"with option {bf:dotrule()}"
		exit 198
	}
	if `"`dotrule'"' == "" {
		local dotrule = 3
	}

	local dotrule = `dotrule'

	marksample touse, strok
	tempvar c l

	quietly {
		local typ : type `varlist'
		gen `typ' `c' = strupper(trim(`varlist')) if `touse'
		replace `c' = subinstr(`c', ".", "",1) if `touse'
		compress `c'
		if "`dots'" == "" ! {
			local dot_plus_1 = `dotrule' + 1
			replace `c' = bsubstr(`c',1,`dotrule')		///
				+ "." + bsubstr(`c',`dot_plus_1',.)	///
				if length(`c') > `dotrule' & `touse'
			gen byte `l' = length(`c') if `touse'
			summ `l' if `touse', meanonly
			local max_len = r(max)
			local len = `maxlength'
			local max_len = `max_len'
			if `max_len' > `len' {
				local len = `max_len'	
			}
		}
		else {
			gen byte `l' = length(`c') if `touse'
			summ `l' if `touse', meanonly
			local max_len = r(max)
			if `max_len' > `maxlength' {
				local len = `max_len'	
			}
			else {
				local len = `maxlength'
			}
			replace `c' = subinstr(`c', ".", "", .) if `touse'
		}
		local spaces = uchar(32) * `len'
		if "`pad'" != "" {
			replace `c' = bsubstr(`c' + "`spaces'",1,`len')	///
				if `touse'
			replace `c' = "" if trim(`c')=="" & `touse'
		}
		local len = max(8,					///
			cond(length("`varlist'")>`max_len',		///
				length("`varlist'"), `max_len') + 1)
		count if `varlist' != `c' & `touse'
//		local ch = r(N)
//		local s = cond(`ch'==1, "", "s")
		if "`generate'" != "" {
			noi gen `generate' = `c' if `touse'
			compress `generate'
			format `generate' %-`len's
//			label variable `generate' "cleand code for `c'"
		}
		else {
			noi replace `varlist' = `c' if `touse'
			format `varlist' %-`len's
		}
	}
//	di as text "(`ch' change`s' made)"
end

program icd_generate, rclass
	gettoken newvar 0 : 0, parse(" =")
	gettoken eqsign 0 : 0, parse(" =")
	if `"`eqsign'"' != "=" {
		error 198
	}
	syntax varname [if] [in], 					///
		[							///
		using(string)						///
		CATegory SHort DESCRiption range(string)		///
		addcode(string) key(name) descrvar(name)		///
		CATRule(numlist >0 integer min=1 max=1)			///
		VERsion(numlist >0 integer min=1 max=1)			///
		INTROduced(name) DELeted(name) nodots pad 		///
		dotrule(numlist >0 integer min=1 max=1)			///
		MAXlength(numlist >0 integer min=1 max=1)		///
		]

	confirm new var `newvar'

	local nopt=("`category'"!="")+("`short'"!="")+("`description'"!="")+("`range'"!="")

	if `nopt' != 1 {
		di as err "you must specify one of options {bf:category}, " ///
			"{bf:description}, or {bf:range()}"
		exit 198
	}
	if "`category'" == "" {
		if `"`catrule'"' != "" {
di as err "option {bf:catrule()} only allowed with option {bf:category}"
			exit 198
		}
	}
	if "`description'" == "" {
		if `"`using'"' != "" {
di as err "option {bf:using()} only allowed with option {bf:description}"
			exit 198
		}
		if "`version'" != "" {
di as err "option {bf:version()} only allowed with option {bf:description}"
			exit 198
		}
		if "`introduced'" != "" {
di as err "option {bf:introduced()} only allowed with option {bf:description}"
			exit 198
		}
		if "`deleted'" != "" {
di as err "option {bf:deleted()} only allowed with option {bf:description}"
			exit 198
		}
		if "`key'" != "" {
di as err "option {bf:key()} only allowed with option {bf:description}"
			exit 198
		}
		if "`descrvar'" != "" {
di as err "option {bf:descrvar()} only allowed with option {bf:description}"
			exit 198
		}
		if "`dots'" == "nodots" {
di as err "option {bf:nodots} only allowed with option {bf:description}"
			exit 198
		}
		local opts = substr(`"`0'"', strpos(`"`0'"', ","), .)
		local has_dots = strpos(`"`opts'"', " dots")
		if `has_dots' > 0 {
di as err "option {bf:dots} only allowed with option {bf:description}"
			exit 198
		}
		if "`pad'" != "" {
di as err "option {bf:pad} only allowed with option {bf:description}"
			exit 198
		}
		if "`dotrule'" != "" {
di as err "option {bf:dotrule()} only allowed with option {bf:description}"
			exit 198
		}
		if "`maxlength'" != "" {
di as err "option {bf:maxlength()} only allowed with option {bf:description}"
			exit 198
		}
		if "`addcode'" != "" {
di as err "option {bf:addcode()} only allowed with option {bf:description}"
			exit 198
		}
	}
	else {
		if `"`using'"' == "" {
di as err "option {bf:using()} is require for option {bf:description}"
			exit 198
		}
		if ("`addcode'" != "" & ("`addcode'" != "end" &		///
			"`addcode'" != "beg" &				///
			"`addcode'" != "begi" & "`addcode'" != "begin")) {
di as err `"invalid {bf:addcode()} value.  May be {bf:begin} or {bf:end}"'
			exit 198
		}
		if "`addcode'" == ""  & "`dots'" != "" {
di as err `"option {bf:nodots} can only be combined with option {bf:addcode()}"'
			exit 198
		}
		if ("`addcode'"=="" | "`addcode'"!="begin") & "`pad'" != "" {
di as err `"option {bf:pad} can only be combined with option {bf:addcode(begin)}"'
			exit 198
		}
	}

	marksample touse, strok
	tempvar new

	if "`category'" != "" | "`short'" != ""{
		icd_gen__cat_short `touse' `new' `varlist'		///
			"`catrule'" "`short'"
	}
	else if "`description'" != "" {
		icd_gen__descr `"`using'"' `touse' `new' `varlist'	///
			"`key'" "`descrvar'" "`addcode'" "`end'"	///
			"`introduced'" "`deleted'" "`version'"		///
			"`dots'" "`pad'" "`maxlength'"
	}
	else if "`range'"  != "" {
		icd_gen__range `touse' `new' `varlist' `"`range'"'
	}

	rename `new' `newvar'
end

program icd_gen__cat_short
	args touse new userv cat_l short 
	// as of now, -short- only works for icd10

	quietly {
		if "`cat_l'"=="" {
			local cat_l = 3
		}
		if "`short'"!="" {
			// just for icd10
			gen str4 `new'=subinstr(trim(`userv'),".","",1) ///
				if `touse'
			//label variable `new' "4-digit diagnosis code for `new'"
		}
		else {
		gen str`cat_l' `new'=substr(ltrim(`userv'),1,`cat_l')	///
				if `touse'
			//label variable `new' "code category for `new'"
		}
	}
end

program icd_gen__descr
	args using touse new userv key descrvar addcode end		///
		introduced deleted version nodots pad maxlength

	icd__findfile `"`using'"'
	local using `"`r(fn)'"'

	if `"`key'"' != "" {
		local codevar "`key'"
	}
	else {
		local codevar "__code"
	}
	if `"`descrvar'"' != "" {
		local descvar "`descrvar'"
	}
	else {
		local descvar "__descr"
	}
	icd__check_key_desc_vars `"`using'"' "new"			///
		"`codevar'" "`descvar'"
	icd__check_version_vars `"`using'"' "new"			///
		"`version'" "`introduced'" "`deleted'"

	if "`version'" != "" {
		tempfile icd
		icd__create_icd_version_data `"`using'"' "`icd'"	///
			"`codevar'" "`version'" "`introduced'" "`deleted'" 0
		local using `"`icd'"'
	}

	// make an id var and keep track of current sort
	tempvar pid
	qui gen `c(obs_t)' `pid' = _n
	local sortby : sortedby
	tempname merge c
	quietly {
		local typ : type `userv'
		gen `typ' `c' = strupper(trim(`userv')) if `touse'
		replace `c' = subinstr(`c', ".", "", 1) if `touse'
		sort `c'
		rename `c' `codevar'
		merge m:1 `codevar' using `"`using'"', gen(`merge')	///
			keepus(`codevar' `descvar' `introduced' `deleted') ///
			keep(match master) nonotes
		rename `codevar' `c'
		rename `descvar' `new'
		sort `sortby' `pid' // restore sort
		if `"`version'"' != "" {
			if "`deleted'" != "" {
				qui replace `new'= "" if		///
					`deleted'<`version' & `touse'
				drop `deleted'
			}
			if "`introduced'" != "" {
				qui replace `new'= "" if		///
					`introduced'>`version' & `touse'
				drop `introduced'
			}
		}
		replace `c' = "" if !`touse'
		replace `new' = "" if !`touse'
//		label var `new' "description of `userv'"
		count if `merge'!=3 & `c'!="" & `touse'
		local unlab = r(N)
		drop `merge'

		if `"`maxlength'"' == "" {
			local maxlength = 4
		}
		if "`nodots'" == "" {
			if `"`dotrule'"' != "" {
				local dotrule = 3
			}
			local dots "dotrule(`dotrule')"
		}
		else {
			local dots "nodots"
		}
		if (strpos("`addcode'", "beg") >0) {
			icd_clean `c' if `touse',			///
				maxlength(`maxlength')			///
				replace `pad' `dots'
			replace `new' = `c' + " " + `new'		///
				if `touse' & `new' != ""
		}

		if "`addcode'" == "end" {
			icd_clean `c' if `touse',			///
				maxlength(`maxlength')			///
				replace `pad' `dots'
			replace `new' = `new' + " " + `c'		///
				if `touse' & `new' != ""
			replace `new' = "" if trim(`new')==""		///
				& `touse' & `c' != ""
		}
	}
	if `unlab' {
		qui count if `new' == ""
		local newv_miss = `r(N)'
		qui count if `userv' == ""
		local oldv_miss = `r(N)'
		if `newv_miss' > 1 {
			local ss "s"
		}
		local oldv_msg
		if `oldv_miss' > 0 {
			if `oldv_miss' > 1 {
				local s "s"
			}
			local oldv_msg "`oldv_miss' missing value`s' in `userv'"
		}
		else {
			local oldv_msg "no missing values in `userv'"
		}
		di as txt "(`newv_miss' missing value`ss' generated; "	///
			"`oldv_msg')"
	}
end

program icd_gen__range
	args touse new userv range

	P_ilist `"`range'"' ","
	local list `"`s(list)'"'
	local rest = trim(`"`s(rest)'"')
	if `"`rest'"' != "" {
		error 198
	}
	tempvar c
	local typ : type `userv'
	qui gen `typ' `c' = strupper(trim(`userv')) if `touse'
	qui replace `c' = subinstr(`c', ".", "",1) if `touse'
	qui compress `c'
	X_ilist `touse' `new' `c' `"`list'"'
	//label variable `new' "indicator of `userv' in range"
end

program P_ilist, sclass		// parse/execute an icd10rangelist (ilist)
	args str term
	sret clear

	gettoken tok : str, parse(" *-/`term'")
	while `"`tok'"'!="" & `"`tok'"' != `"`term'"' {
		gettoken tok str : str, parse(" *-/`term'")
		gettoken nxttok : str, parse(" *-/`term'")
		if `"`nxttok'"' == "*" {
			gettoken nxttok str : str, parse(" *-/`term'")
			local range = substr(`"`str'"',1,1)
			if `"`range'"'=="-" | `"`range'"' == "/" {
				di as err `"invalid range specification"'
				exit 198
			}
			local list `"`list' `tok'*"'
		}
		else if `"`nxttok'"'=="-" | `"`nxttok'"'=="/" {
			if strpos(`"`tok'"', "*") > 0 {
				di as err `"invalid range specification"'
				exit 198
			}
			gettoken nxttok str : str, parse(" *-/`term'")
			gettoken nxttok str : str, parse(" -/`term'")
			if strpos(`"`nxttok'"', "*") > 0 {
				di as err `"invalid range specification"'
				exit 198
			}
			local list `"`list' `tok'-`nxttok'"'
		}
		else {
			local list `"`list' `tok'"'
		}
		gettoken tok : str, parse(" *-/`term'")
	}
	sret local list `"`list'"'
	sret local rest `"`str'"'
end

program X_ilist
	args touse newvar vn list
	quietly {
		gen byte `newvar' = 0 if `touse'
		local list  = strtrim(`"`list'"')
		tokenize `"`list'"'
		while "`1'" != "" {
			local 1 = strupper("`1'")
			local 1 = subinstr("`1'", ".", "", .)
			if strpos("`1'", "-") {
				local l = strpos("`1'", "-")
				local lb = bsubstr("`1'",1,`l'-1)
				local ub = bsubstr("`1'",`l'+1,.)
				replace `newvar' = 1			///
					if `vn'>="`lb'" & `vn'<="`ub'" & `touse'
			}
			else if strpos("`1'", "*") {
				local sub = bsubstr("`1'",1,length("`1'")-1)
				local l = length("`sub'")
				replace `newvar' = 1			///
					if bsubstr(`vn',1,`l')=="`sub'" &`touse'
			}
			else {
				replace `newvar' = 1 if `vn'=="`1'" & `touse'
			}
			mac shift
		}
	}
end

program icd_lookup, rclass
	syntax anything, using(string)					///
		[							///
		key(name) descrvar(name)				///
		dotrule(numlist >0 integer min=1 max=1)			///
		VERsion(numlist >0 integer min=1 max=1)			///
		INTROduced(name) DELeted(name) 				///
		]

	icd__findfile `"`using'"'
	local using `"`r(fn)'"'

	if `"`key'"' != "" {
		local codevar "`key'"
	}
	else {
		local codevar "__code"
	}
	if `"`descrvar'"' != "" {
		local descvar "`descrvar'"
	}
	else {
		local descvar "__descr"
	}

	icd__check_key_desc_vars `"`using'"' "notnew"			///
		"`codevar'" "`descvar'"
	icd__check_version_vars `"`using'"' "notnew"			///
		"`version'" "`introduced'" "`deleted'"

	if `"`dotrule'"' == "" {
		local dotrule = 3
	}

	if "`version'" != "" {
		tempfile icd
		icd__create_icd_version_data `"`using'"' "`icd'"	///
			"`codevar'" "`version'" "`introduced'" "`deleted'" 1
		local using `"`icd'"'
	}


	preserve
	quietly {
		tempvar c l
		use `"`using'"', clear
		capture qui keep `codevar' `descvar' `introduced'
		icd gen `c' = `codevar', range("`anything'")
		keep if `c'
		drop `c'
		local dot_plus_1 = `dotrule' + 1
		replace `codevar' = bsubstr(`codevar',1,`dotrule')	///
			+ "." + bsubstr(`codevar',`dot_plus_1',.)	///
				if length(`codevar') > `dotrule'
		gen byte `l' = length(`codevar')
		sum `l'
		local mpad = r(max)
	}
	if _N == 0 {
		di as text "(no matches found)"
		ret scalar N_codes = 0
		exit
	}
	ret scalar N_codes = _N
/*
	if "`introduced'" != "" {
		di
//		di as result " Version Code Description"
		di as result "   Code Description"
	}
*/
	di
	forvalue i = 1/`=_N' {
		local code = `codevar'[`i']
		local des = `descvar'[`i']
/*
		if "`introduced'" != "" {
			local intro = `introduced'[`i']
			local intro "`intro' "
		}
		else {
			local intro ""
		}
*/
		local len = `l'[`i']
		if `len' != `mpad' {
			local pad = `mpad' - `len' + 1
		}
		else {
			local pad = 1
		}
		local pad = uchar(32) * `pad'
//di `"{p 4 11 2}{txt:`intro'}{res:`code'}{bind:`pad'}{txt:`des'}{p_end}"'
di `"{p 4 11 2}{res:`code'}{bind:`pad'}{txt:`des'}{p_end}"'
	}
end

program icd_search, rclass
	syntax anything(id="search text"), using(string)		///
		[							///
		or MATCHCase key(name) descrvar(name)			///
		dotrule(numlist >0 integer min=1 max=1)			///
		VERsion(numlist >0 integer min=1 max=1)			///
		INTROduced(name) DELeted(name) 				///
		]

	icd__findfile `"`using'"'
	local using `"`r(fn)'"'

	if `"`key'"' != "" {
		local codevar "`key'"
	}
	else {
		local codevar "__code"
	}
	if `"`descrvar'"' != "" {
		local descvar "`descrvar'"
	}
	else {
		local descvar "__descr"
	}

	icd__check_key_desc_vars `"`using'"' "notnew"			///
		"`codevar'" "`descvar'"
	icd__check_version_vars `"`using'"' "notnew"			///
		"`version'" "`introduced'" "`deleted'"

	if `"`dotrule'"' == "" {
		local dotrule = 3
	}

	if "`version'" != "" {
		tempfile icd
		icd__create_icd_version_data `"`using'"' "`icd'"	///
			"`codevar'" "`version'" "`introduced'" "`deleted'" 1
		local using `"`icd'"'
	}

	preserve
	quietly  {
		use `"`using'"', clear
		keep `codevar' `descvar' `introduced'

		tempvar search l
		gen byte `search' = .
		tempvar d
		clonevar `d' = `descvar'
		if "`matchcase'" == "" {
			local anything = strlower(`"`anything'"')
			replace `d' = strlower(`descvar')
		}

		if "`or'" != "" {
			local stype "|"
		}
		else {
			local stype "&"
		}

		local i = 1
		gettoken tok rest : anything, parse(" ")
		while `"`tok'"'!=""  {
			if `i' == 1 {
local myif `"`myif' strpos(`d',`"`tok'"')"'
			}
			else {
local myif`"`myif' `stype' strpos(`d',`"`tok'"')"'
			}
			gettoken tok rest : rest, parse(" ")
			local ++i
		}

		replace `search' = 1 if `myif'
		keep if `search' == 1
		drop `d'
	}
	if _N == 0 {
		di as text "(no matches found)"
		ret scalar N_codes = 0
		exit
	}

	local dot_plus_1 = `dotrule' + 1
	qui replace `codevar' = bsubstr(`codevar',1,`dotrule')	///
		+ "." + bsubstr(`codevar',`dot_plus_1',.)	///
			if length(`codevar') > `dotrule'
	qui gen byte `l' = length(`codevar')
	qui sum `l'
	local mpad = r(max)
	local smclpad = 4 + `mpad' + 2

	di
	forvalue i = 1/`=_N' {
		local code = `codevar'[`i']
		local des = `descvar'[`i']
		local len = `l'[`i']
		if `len' != `mpad' {
			local pad = `mpad' - `len' + 2
		}
		else {
			local pad = 2
		}
		local pad = uchar(32) * `pad'
	di `"{p 4 `smclpad' 2}{res:`code'}{bind:`pad'}{txt:`des'}{p_end}"'
	}
	ret scalar N_codes = _N
end

program icd_query
	syntax, using(string)

	icd__findfile `"`using'"'
	local using `"`r(fn)'"'
	mata: st_global("r(fn)", "")
	preserve
	quietly use `"`using'"', clear

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
				local qnote =				///
					trim(subinstr(`"`qnote'"',"-","",.))
				di as text _n `"  {bf:`qnote'}"'
			}
			else if bsubstr(`"`qnote'"',7,3) == "FY " {
				local qnote =				///
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

program icd__findfile
	args using

	if (!(substr(strreverse(`"`using'"'), 1, 4)=="atd.")) {
		local using `"`using'.dta"'
	}
	capture quietly findfile `"`using'"'
	if _rc {
		di as err `"{bf:`using'}: icd file not found"'
		exit _rc
	}
end

program icd__check_key_desc_vars
	args using new codevar descvar

	capture des `codevar' using `"`using'"'
	if _rc {
di as error  `"variable {bf:`codevar'} not found in file {bf:`using'}"'
		exit _rc
	}
	if "`new'" == "new" {
		capture confirm new var `codevar'
		if _rc {
di as error  `"variable {bf:`codevar'} can not exist in both icd data and in the data in memory"'
			exit 198
		}
	}

	capture des `descvar' using `"`using'"'
	if _rc {
di as error  `"variable {bf:`descvar'} not found in file {bf:`using'}"'
		exit _rc
	}
	if "`new'" == "new" {
		capture confirm new var `descvar'
		if _rc {
di as error  `"variable {bf:`descvar'} can not exist in both icd data and in the data in memory"'
			exit 198
		}
	}
end

program icd__check_version_vars
	args using new ver intro del

	if "`ver'" != "" & ("`intro'" == "" | "`del'" == "")  {
di as err `"option {bf:version()} requires options {bf:introduced()} and {bf:deleted()}"'
		exit 198
	}

	if "`ver'" == "" & "`intro'" != ""  {
di as err `"option {bf:introduced()} requires options {bf:version()} and {bf:deleted()}"'
		exit 198
	}

	if "`ver'" == "" & "`del'" != ""  {
di as err `"option {bf:deleted()} requires options {bf:version()} and {bf:introduced()}"'
		exit 198
	}

	if ("`intro'" == "`del'" & "`ver'" != "") {
di as err `"different variables are need for options {bf:introduced()} and {bf:deleted()}"'
		exit 198
	}

	if "`intro'" != "" {
		capture des `intro' using `"`using'"'
		if _rc {
di as error  `"variable {bf:`intro'} not found in file {bf:`using'}"'
			exit _rc
		}
		if "`new'" == "new" {
			capture confirm new var `intro'
			if _rc {
di as error  `"variable {bf:`intro'} can not exist in both icd data and in the data in memory"'
				exit 198
			}
		}
	}

	if "`del'" != "" {
		capture des `del' using `"`using'"'
		if _rc {
di as error  `"variable {bf:`del'} not found in file {bf:`using'}"'
			exit _rc
		}
		if "`new'" == "new" {
			capture confirm new var `del'
			if _rc {
di as error  `"variable {bf:`del'} can not exist in both icd data and in the data in memory"'
				exit 198
			}
		}
	}
end

program icd__create_icd_version_data
	args using tempdata codevar ver intro del keepversion
	qui {
		tempvar dup dup2
		preserve
		drop _all
		use `"`using'"'
		if `keepversion' {
			drop if `intro' > `ver'
			drop if `del' <= `ver'
		}
		else {
			bysort `codevar' : gen byte `dup' = cond(_N==1, 0, _N)
			drop if `del' <= `ver' & `dup' != 0
			drop if `intro' > `ver' & `dup' != 0
		}
		save "`tempdata'"
		restore
	}
end

