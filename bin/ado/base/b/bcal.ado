*! version 1.2.2  16sep2019  
program bcal, rclass
	version 14

	gettoken subcmd rest : 0 , parse(" ,")

	local l = strlen(`"`subcmd'"')
	if (`l' == 0) {
		error 198
		/*NOTREACHED*/
	}

	if ("`subcmd'"==bsubstr("check", 1, max(1, `l'))) {
		bcal_check `rest'
	}
	else if ("`subcmd'"==bsubstr("describe", 1, max(1,`l'))) {
		bcal_describe `rest'
	}
	else if ("`subcmd'"=="dir") {
		bcal_dir `rest' 
	}
	else if ("`subcmd'"=="load") {
		bcal_load `rest' 
	}
	else if ("`subcmd'"=="create") {
 	 	bcal_create `rest'
	}
	else {
		di as err "`subcmd' invalid {bf:bcal} subcommand"
		exit 198
		/*NOTREACHED*/
	}
	return add
end

program bcal_check, rclass
	syntax [varlist] [, RC0]
	mata: st_rclear()
	mata: bcal_check("`rc0'"!="")
	return add
end
	
program bcal_dir, rclass
	gettoken pattern 0 : 0, parse(" ,")
	if ("`pattern'"==",") {
		local 0 `", `0'"'
		local pattern
	}
	syntax [, TESTMODE]

	mata: st_rclear()
	if (bsubstr("`pattern'", 1, 1)=="%") {
		capture noi error 198
		di as err "{p 4 4 2}"
		di as err "{bf:%} is not allowed."
		di as err "When using {bf:bcal dir}, you must specify"
		di as err "the business calendar's name, not its format."
		di as err "E.g., specify {bf:nyse} or {bf:ny*}, not"
		di as err "{bf:%tbnyse} or {bf:%tbny*}."
		di as err "{p_end}"
		exit 198
	}
	mata: bcal_dir("`pattern'", "`testmode'")
	return add
end

program bcal_load, rclass
	gettoken toload 0 : 0 , parse(" ,")
	if ("`toload'"==",") {
		local 0 `", `0'"'
		local toload 
	}
	syntax
	calspec_specified load "`toload'"
	_bcalendar load `toload'

	return local fn "`r(fn)'"
	return local purpose "`r(purpose)'"
	return local name "`r(name)'"

	return scalar max_date_tb = r(max_date_tb)
        return scalar min_date_tb = r(min_date_tb)
	return scalar ctr_date_td = r(ctr_date_td)
	return scalar max_date_td = r(max_date_td) 
	return scalar min_date_td = r(min_date_td)

	di as txt
	di as txt "(calendar loaded successfully)"
end

program bcal_describe, rclass
	gettoken toload 0 : 0 , parse(" ,")
	if ("`toload'"==",") {
		local 0 `", `0'"'
		local toload 
	}
	syntax
	calspec_specified describe "`toload'"

	qui _bcalendar load `toload'
	return local fn "`r(fn)'" 
	return local purpose "`r(purpose)'"
	return local name "`r(name)'"

	local ddays = r(max_date_td) - r(min_date_td) + 1
	local bdays = r(max_date_tb) - r(min_date_tb) + 1

	local omitted = `ddays' - `bdays'
	local included = `bdays'
	local omityear = (`omitted'/`ddays')*365.25
	local inclyear = (`included'/`ddays')*365.25

	local omitted_year  : di %11.1f `omityear'
	local included_year : di %11.1f `inclyear'

	return scalar omitted_year  = `omitted_year'
	return scalar included_year = `included_year' 
	return scalar omitted = `ddays' - `bdays'
        return scalar included = `bdays'
        return scalar max_date_tb = r(max_date_tb)
	return scalar min_date_tb = r(min_date_tb)
        return scalar ctr_date_td = r(ctr_date_td)
	return scalar max_date_td = r(max_date_td)
	return scalar min_date_td = r(min_date_td)

	local bfmt "%tb`return(name)'"

	local intd `"as txt _col(37) "in %td units""'
	local intb `"as txt _col(37) "in `bfmt' units""'

	di as txt
	di as txt "  Business calendar " as res "`return(name)'" ///
	   as txt " (format " as res "`bfmt'" as txt "):"

	di as txt

	di as txt "    purpose:  " ///
	   as res "`return(purpose)'"

	di as txt

	di as txt "      range:  " ///
	   as res %td (`return(min_date_td)') "  " ///
	   as res %td (`return(max_date_td)') 

	di as txt "             " ///
	   as res %9.0f (`return(min_date_td)') "  " ///
	   as res %9.0f (`return(max_date_td)') `intd'

	di as txt "             " ///
	   as res %9.0f (`return(min_date_tb)') "  " ///
	   as res %9.0f (`return(max_date_tb)') `intb'

	di as txt
	di as txt "     center:  " ///
	   as res %td (`return(ctr_date_td)') 

	di as txt "             " ///
	   as res %9.0f (`return(ctr_date_td)') `intd'

	di as txt "             " ///
	   as res %9.0f (0) `intb'

	di as txt
		
	di as txt "    omitted: " ///
	   as res %9.0fc `return(omitted)' as txt _col(37) "days"

	di as txt "             " ///
	   as res %11.1f `omityear' as txt _col(37) "approx. days/year"

	di as txt

	di as txt "   included: " ///
	   as res %9.0fc return(included) as txt _col(37) "days"

	di as txt "             " ///
	   as res %11.1f `inclyear' as txt _col(37) "approx. days/year"
end

program bcal_create, rclass sortpreserve

	// define "constants"
	local STATA_MIN_DATE 	= -676350	// Jan 01, 0100
	local STATA_MAX_DATE 	= 2936549	// Dec 31, 9999
	local GREGORIAN_DAY1	= -137774	// Oct 15, 1582
	local MAXGAP_DEFAULT	= 10
	local MAX_CAL_LENGTH	= 10		// length of calendar name
	local MAX_PUR_LENGTH	= 63		// length of purpose
	local STATA_VERSION 	= c(stata_version)

	// check if dataset in use
	if (c(N) == 0 | c(k) == 0) {
		di as err "no dataset in use"
		exit 3
	}
		
	// parse pathname  
	gettoken initial rest : 0 , parse(",")
	local 0 `"`initial'"'
	gettoken pathname 0 : 0
	
	if (`"`pathname'"' == "," | `"`pathname'"' == "") {
		di as err "name of business calendar file expected"
		exit 198
	}

	// split pathname into path, calname, filename - and validate
	mata: parse_pathname(`"`pathname'"', `MAX_CAL_LENGTH')
	
	if "`pathname_rc'" == "1"  {
		di as err "path {bf:`path'} does not exist"
		exit 601
	}

	if "`pathname_rc'" == "2"  {
	    	di as err "{bf:`calname'} is not a valid calendar name"
		exit 198
	}

	if "`pathname_rc'" == "3"  {
		di as err ///
		   "{bf:`calname'} too long; calendar names are limited to" /* 
		    */ " `MAX_CAL_LENGTH' characters" 
		exit 198
	}

	if "`pathname_rc'" == "4"  {
		di as err /// 
		   "extension {bf:`suffix'} in calendar file not allowed"
		exit 198
	}

	// parse the rest
	local 0 `"`0' `rest'"'

	syntax  [if] [in] , from(string)			///
		[	Generate(string)			///
			PERSONAL				///
			EXCLUDEmissing(string)			///
			REPLACE					///
			PURPOSE(string)				///
			DATEFORMAT(string)			///
			RANGE(string)				///
			CENTERdate(string)			///
			MAXGAP(integer `MAXGAP_DEFAULT')	///
		]

	// parse from option; check if numeric and integer
	parse_from `"`from'"'
	local from_td = 1
	local from_fmt : format `from'

	if "`from_fmt'" != "%td" {
		local from_td = 0
	}

	capture quietly confirm numeric variable `from'
	if _rc {
		di as err "{bf:`from'} has non-numeric values"
		exit 198
	}

	local from_int = 1
	capture quietly assert floor(`from') == `from' 

	if _rc {
		local from_int = 0
	} 

	// parse generate
	if ("`generate'" != "") {
		confirm new variable `generate' 
	}

	// parse personal 
	if ("`personal'" != "") {
		mata: parse_personal(`"`c(sysdir_personal)'"')
		if ("`personal_rc'" == "0") {
			di as err "PERSONAL directory does not exist"
			exit 198
		}
	}

	if ("`personal'" != "" & `"`path'"' != "") {
		di as err "option {bf:personal} not allowed when path" /*
			   */" is specified"
		exit 198
	}  

	// change filename if option personal used
	if ("`personal'" != "") {
		local filename `"`c(sysdir_personal)'`filename'"'
	}

	// if filename does not exist, but calendar exists, issue an error
	capture confirm file `"`filename'"'
	local exists_rc = _rc
	capture bcal describe `"`calname'"'
	local describe_rc = _rc
	if  (`exists_rc' != 0 & `describe_rc' != 601) {
		di as err "{bf:`calname'.stbcal} already exists in a" /*
			  */ " Stata system directory "
		di as err "{p 4 4 2}"
		di as err "choose another calendar name"
		di as err "{p_end}"
		exit 198
	}
	
	// parse options excludemissing, purpose, dateformat
	parse_excludemissing `"`excludemissing'"'
	parse_purpose `"`purpose'"' `MAX_PUR_LENGTH'
	parse_dateformat `"`dateformat'"'
      
	// parse range and centerdate: depends on dateformat
	if (`"`dateformat'"' == "") {
		local dateformat = "ymd"
	}
	else {
		local dateformat = lower(`"`dateformat'"')
	}

	parse_range `"`range'"' `"`dateformat'"'
	parse_centerdate `"`centerdate'"' `"`dateformat'"'

	// parse maxgap
	if (`maxgap' < 1) {
		di as err "{bf:maxgap()} should be at least 1"
		exit 198
	}

	// determine format in which to display dates, based on dateformat
	local displayformat = subinstr(`"`dateformat'"', "d", "DD", 1)
	local displayformat = subinstr(`"`displayformat'"', "m", "mon", 1)
	local displayformat = subinstr(`"`displayformat'"', "y", "CCYY", 1)
	local displayformat = "%td" +  `"`displayformat'"'

	// determine excludelist, the varlist to exclude if missing
	if (`"`excludemissing'"' != "") {
		gettoken excludelist : excludemissing, parse(",")
	}

	// generate tempvar include to indicate observations that are part
	// 	of the calendar based on if, in and excludemissing()
	
	if (`"`if'"' != "") {
		local condition = `"`if'"'
	}
	else		{
		local condition = "if 1"
	}

	if ("`excludelist'" != "" & strpos("`excludemissing'", "any") > 0) {
		local condition `"`condition' & ("' 
		local countVar = 0
		foreach var of varlist `excludelist' {
			if (`countVar' == 0) {
			   local condition `"`condition'!missing(`var')"'
			}
			else {
			    local condition `"`condition' & !missing(`var')"'
			}
			local countVar = `countVar' + 1
		}
		local condition `"`condition')"'
	}

	if ("`excludelist'" != "" & strpos("`excludemissing'", "any") == 0) {
		local condition `"`condition' & ("'
		local countVar = 0
		foreach var of varlist `excludelist' {
			if (`countVar' == 0) {
			   local condition `"`condition'!missing(`var')"'
			}
			else {
			   local condition `"`condition' | !missing(`var')"'
			}
			local countVar = `countVar' + 1
		}
		local condition `"`condition')"'
	}

	tempvar include
	quietly generate byte `include' = 0
	quietly replace `include' = 1 `condition' `in' 
	
	// generate contents of business calendar file, starting from line 1
	//	i.e. comments, version, etc.
	local today  	= c(current_date)
	local comments_line1 ///
		`"* Business calendar "`calname'" created by -bcal create-"'
	local comments_line2 "* Created/replaced on `today'"

	// find range of dates; requires sorting
	gsort -`include' `from'
	quietly count if `include' == 1

	if r(N) == 0 {
		di as err "no observations found for calendar"
		exit 2000
	}
	if (`from'[1] < `STATA_MIN_DATE') {
		di as err "Stata date cannot be before Jan 1, 0100"
		exit 198
	}
	if (`from'[r(N)] > `STATA_MAX_DATE') {
		di as err "Stata date cannot be after Dec 31, 9999"
		exit 198
	} 

	if `"`range'"' != "" {
		local firstdate  = word("`range'", 1)
		local seconddate = word("`range'", 2)

		if ("`firstdate'" == ".") {
			local mindate = `from'[1]
		}
		else {			
		   local mindate = date("`firstdate'", upper("`dateformat'"))
		   if (`mindate' > `from'[1]) {
			di as err "first date in {bf:range()} cannot be" /*
				   */" after first business date in dataset"
			exit 198
		   }
		}

		if ("`seconddate'" == ".") {
			local maxdate = `from'[r(N)]
		}
		else {	
			local maxdate = ///
				date("`seconddate'", upper("`dateformat'"))
			if (`maxdate' < `from'[r(N)]) {
			   di as err "second date in {bf:range()} cannot be"/*
				      */" before last business date in dataset"
			   exit 198
			}
		}

		local mindisp : display `displayformat' `mindate'
		local maxdisp : display `displayformat' `maxdate'
	}
	else {	
		local mindate = `from'[1]
		local maxdate = `from'[r(N)]
     		local mindisp : display `displayformat' `mindate' 
		local maxdisp : display `displayformat' `maxdate' 
	}

	// find centerdate
	if trim("`centerdate'") == "" {
		local cdate  = `mindate'
		local centerdisp : display `displayformat' `cdate'
	}
	else {
		local cdate = date("`centerdate'", upper("`dateformat'"))
		local centerdisp : display `displayformat' `cdate'
	}

	if (`cdate' < `mindate' | `cdate' > `maxdate') {
		di as err "centerdate {bf:`centerdisp'} out of range"
		exit 198
	}

	// find days of week to be omitted
	local omit_list = ""
	forvalues i = 1/6 {
 		quietly count if dow(`from') == `i' & `include' == 1
		if r(N) == 0 {
			if `i' == 1 {
				local omit_list "`omit_list' Mo"
			}
			if `i' == 2 {
				local omit_list "`omit_list' Tu"
			}
			if `i' == 3 {
				local omit_list "`omit_list' We"
			}
			if `i' == 4 {
				local omit_list "`omit_list' Th"
			}
			if `i' == 5 {
				local omit_list "`omit_list' Fr"
			}
			if `i' == 6 {
				local omit_list "`omit_list' Sa"
			}
		}
	}

	// so that Sunday appears last
	quietly count if dow(`from') == 0 & `include' == 1
	if r(N) == 0 {
		local omit_list "`omit_list' Su"
	}
	local omit_list = trim("`omit_list'")

	// find specific days to be omitted by finding differences between
	// 	dates; writebcal() does the actual writing of omit dates
	tempvar diff
	quietly generate `diff' = `from' - `from'[_n-1] 	///
		if _n > 1 & `include' == 1 
	quietly replace `diff' = 0 in 1

	// if calendar file already exists, save it in a tempfile
	local file_exists = 0
	capture confirm file `"`filename'"'
	if _rc == 0 {
		local file_exists = 1
	}	

	if (`file_exists' == 1 & "`replace'" == "") {
		di as err "file {bf:`filename'} already exists;" /*
			  */ " use {bf:replace} to overwrite" 
		exit 602
	}
	if (`file_exists' == 1 & "`replace'" != "") {
		tempfile tmpfile
		cp `"`filename'"' `"`tmpfile'"'
		erase `"`filename'"'
	}

	// write business calendar file
	mata: writebcal(`"`filename'"',		///
			`"`comments_line1'"',	///
			`"`comments_line2'"',	///
			`STATA_VERSION',	///
			`"`from'"',		///
			`"`diff'"',		///
			`"`include'"',		///
			`"`purpose'"',		///
			`"`dateformat'"',	/// 
			`"`displayformat'"',	///
			`"`centerdisp'"',	///
			`"`mindisp'"',		///
			`"`maxdisp'"',		///
			`"`omit_list'"',	///
			`maxgap')

	// confirm if file has been created
	capture confirm file `"`filename'"'
	if _rc {
		di as err "calendar file could not be created"
		exit 198
	}

	// check if maxgap is exceeded 
	if ("`maxgap_code'" == "1") {
		di as err "gap in business calendar too large;" /*
			   */ " {bf:maxgap()} currently set to `maxgap'"
		if `file_exists' == 0 {
			erase `"`filename'"'
		}
		else {
			erase `"`filename'"'
			cp `"`tmpfile'"' `"`filename'"'
			di as err "{p 4 4 2}"
			di as err `"{bf:`filename'} left unchanged"'
			di as err "{p_end}"
		}
		exit 198
	}

	// run -bcal describe-; recover if it fails;
	// 	fileinpath required if file is not in Stata path,
	//	in which case file is temporarily copied in pwd	
	local fileinpath = 1
	capture quietly bcal describe `calname'
	local describe_rc = _rc
	if `describe_rc' == 197 {
		if `file_exists' == 0 { // bcal describe fails
			rm `"`filename'"'
			di as err "{bf:bcal describe} `calname' failed"
		}
		else {
			rm `"`filename'"'
			cp `"`tmpfile'"' `"`filename'"'
			di as err "{bf:bcal describe} `calname' failed;" /*
				*/ " {bf:`filename'} left unchanged"
		}
		exit `describe_rc'
	}

	capture quietly bcal describe `calname'
	local describe_rc = _rc
	if `describe_rc' == 601 {     // file not found i.e. not in Stata path
		local fileinpath = 0
		cp `"`filename'"' `"`calname'.stbcal"'
		capture quietly bcal describe `calname'
		local describe_rc = _rc
		if `describe_rc' {
			capture erase `"`calname'.stbcal"'
			if `file_exists' == 0 {
				capture erase `"`filename'"'
				di as err "{bf:bcal describe} failed"
			}
			else {
				capture erase `"`filename'"'
				capture cp `"`tmpfile'"' `"`filename'"'
				di as err "{bf:bcal describe} failed;" /*
				           */ " {bf:`filename'} left unchanged"
			}
			exit `describe_rc'
		}
	}
	
	// this point means success; so generate new variable (if necessary), 
	// 	display success message, display remarks, clean up, 
	//	and save results
	if ("`generate'" != "") {
		qui gen long `generate' = ///
			bofd("`calname'", `from') if `include' == 1
		format `generate' %tb`calname'
	}

	bcal describe `calname'
	di as txt ""
	di as txt "  Notes:"
	di as txt ""
	di as txt `"    business calendar file {bf:`filename'} saved"'

	if (`fileinpath' == 0) {
		capture erase `"`calname'.stbcal"'
		di as txt
		di as txt "    {bf:`calname'.stbcal} not in a Stata system directory"
	}
	if ("`generate'" != "") {
		di as txt
		di as txt "    variable {bf:`generate'} created;" /*
			   */" it contains business dates in {bf:%tb`calname'} format"
	}
	if ("`mismatch_code'" == "1") {
		di as txt ""
		di as txt "    first date in {bf:range()} occurs" /* 
			   */ " before first business date in dataset"
	}
	if ("`mismatch_code'" == "2") {
		di as txt ""
		di as txt "    second date in {bf:range()} occurs" /*
			   */ " after last business date in dataset"
	}
	if ("`mismatch_code'" == "12") {
		di as txt ""
		di as txt "    first date in {bf:range()} occurs" /*
			   */ " before first business date in dataset"
		di as txt ""
		di as txt "    second date in {bf:range()} occurs" /*
			   */ " after last business date in dataset"
	}
	if (`from_td' == 0) {
		di as txt ""
		di as txt "    {bf:`from'} not in {bf:%td} format"
	}
	if (`from_int' == 0) {
		di as txt ""
		di as txt "    {bf:`from'} contains nonintegers"
	}
	if (`mindate' < `GREGORIAN_DAY1') {
		di as txt ""
		di as txt "{p 4 4 2}"
		di as txt "    some business dates occur before"  /*
			   */ " {bf:Oct 15, 1582}, the first day" /* 
			   */ " of the Gregorian calendar"
		di as txt "{p_end}"
	}

	// return saved results (same as -bcal describe-)
	local ddays    = r(max_date_td) - r(min_date_td) + 1
	local bdays    = r(max_date_tb) - r(min_date_tb) + 1
	local omitted  = `ddays' - `bdays'
	local included = `bdays'

	local omityear = (`omitted'/`ddays')*365.25
        local inclyear = (`included'/`ddays')*365.25

        local omitted_year  : di %11.1f `omityear'
        local included_year : di %11.1f `inclyear'

	return scalar included_year = `included_year'
	return scalar omitted_year  = `omitted_year'
	return scalar included      = `included'	
	return scalar omitted       = `omitted'

	return local fn "`filename'"
	return local purpose "`r(purpose)'"
        return local name "`r(name)'"

        return scalar max_date_tb = r(max_date_tb)
        return scalar min_date_tb = r(min_date_tb)

	return scalar ctr_date_td = r(ctr_date_td)
        return scalar max_date_td = r(max_date_td)
        return scalar min_date_td = r(min_date_td)

end	// of bcal_create

program parse_from
	args input

	local 0 `"`input'"'
	
	syntax varname
end

program parse_dateformat
	args input
  
	if (`"`input'"' == "") {
		exit 
	}

	if !inlist(lower(`"`input'"'), "ymd","ydm","myd","mdy","dym","dmy") {
		di as err "{bf:`input'} found where {it:dateformat} expected"
		di as err "{p 4 4 2}"
		di as err "{it:dateformat} options: {bf:ymd} | {bf:ydm} | " /* 
			   */ "{bf:myd} | {bf:mdy} | {bf:dym} | {bf:dmy}"
		di as err "{p_end}"
		exit 198
	}
end

program parse_purpose
	args input maxlength

	if (`"`input'"' == "") {
		exit
	}

	if "`c(hasicu)'" == "1" {
		if ustrlen(`"`input'"') > `maxlength' {
  			di as err "{bf:purpose()} is limited to `maxlength' characters"
			exit 198
		}	
	}
	else {
		if length(`"`input'"') > `maxlength' {
  			di as err "{bf:purpose()} is limited to `maxlength' characters"
			exit 198
		}
	}
end

program parse_centerdate
	args centerdate dateformat

	if (`"`centerdate'"' == "") {
		exit
	}

	local date = date("`centerdate'", upper("`dateformat'"))

	if ("`date'" == ".") {
		di as err "{bf:`centerdate'} not in {bf:`dateformat'} format"
		exit 198
	}
end


program parse_range
	args range dateformat

	if (`"`range'"' == "") {
		exit
	}
	if wordcount(`"`range'"') != 2 {
		di as err "two date arguments expected in {bf:range()}" 
		exit 198
	}

	local first  = word(`"`range'"', 1)
	local last   = word(`"`range'"', 2)

	if ("`first'" != ".") {
		local fdate = date("`first'", upper("`dateformat'"))
		if ("`fdate'" == ".") {
          	   di as err "{bf:`first'} not in {bf:`dateformat'} format"
                   exit 198
		}
	}
	if ("`last'" != ".") {
		local ldate = date("`last'", upper("`dateformat'"))
		if ("`ldate'" == ".") {
			di as err "{bf:`last'} not in {bf:`dateformat'} format"
			exit 198
		}
	}
	if ("`first'" != "." & "`last'" != ".") {
		if (`ldate' <= `fdate') {
			di as err "second date should be after" /*
				   */ " first date in {bf:range()}" 
			exit 198
     		}
	}
end


program parse_excludemissing 
	args input

	if (`"`input'"'=="") {
		exit
	}

	local 0 `"`input'"'
	syntax varlist [, any]

end


program calspec_specified
	args	subcmd calspec

	if (`"`calspec'"' != "") {
		exit
	}

	di as err "syntax error"
	di as err "{p 4 4 2}"
	di as err "Syntax is"
	di as err "{bf:bcal} {bf:`subcmd'}"
	di as err "{it:calname}|{bf:%}{it:tbfmt}.{break}"
	di as err "Nothing was found where a calendar name"
	di as err "or {bf:%}{it:tbfmt} was expected."
	di as err "{p_end}"
	exit 198
end


version 12

local SS	string scalar
local SC	string colvector
local SR	string rowvector
local boolean	real scalar
local RS	real scalar
local RR	real rowvector

mata:

/*
bcal check 

        . bcal check 

        %tblonglong:  [un]defined, used by variables
                      xxx xxx xxx

           %tbxmpl2: [un]defined, used by variables
                     xxx xxx xxx
        
        undefined or defined-with-errors %tb formats
        r(111);

        . bcal check 
        (no variables use %tb formats)

        Returned, 
             r(defined)      list of   defined formats used
             r(undefined)    list of undefined formats used
	     r(error)        list of     error formats used

	     r(varlist_<calname>)
			     list of variables for each calendar in r(defined)
*/

void bcal_check(`boolean' rc0)
{
	`RS'		i, j, rc, rc_overall, status
	`RR'		vidx
	`SS'		fmtname, undef, error, def
	`SC'		fmtnames, varnames

	/* ------------------------------------------------------------ */
					/* obtain fmtnames[]		*/
	vidx     = st_varindex(tokens(st_local("varlist")))
	fmtnames = J(0, 1, "")
	for (i=1; i<=length(vidx); i++) {
                fmtname = tbfmtname(st_varformat(vidx[i]))
                if (fmtname != "") fmtnames = fmtnames \ fmtname
	}
	if (length(fmtnames)==0) { 
		display("{txt}(no variables use {bf:%tb} formats)")
		return
	}
	fmtnames = uniqrows(fmtnames)

	/* ------------------------------------------------------------ */
	rc_overall = 0 
	undef = error = def = ""
	for (j=1; j<=length(fmtnames); j++) {

		varnames = J(0, 1, "")
		for (i=1; i<=length(vidx); i++) {
			if (tbfmtname(st_varformat(vidx[i])) == fmtnames[j]) {
				varnames = varnames \ st_varname(i)
			}
		}
		rc = _stata("_bcalendar load " + fmtnames[j], 1)
		st_rclear() 

		if (rc==1) {
			exit(1)
		}
		if (rc==601) { 
			status     = 601
			undef      = undef + (" " + fmtnames[j])
			rc_overall = 459
		}
		else if (rc) {
			status     = 198
			error      = error + (" " + fmtnames[j])
			rc_overall = 459
		}
		else {
			status     = 0
			def        = def + (" " + fmtnames[j])
		}

		printf("{txt}\n")
		printf((23-udstrlen(fmtnames[j]))*" ")
		printf("%s", `"{res}{stata "bcal describe %tb"' + fmtnames[j] + `"":%tb"' + fmtnames[j] + "}:  ")

		if      (status==0)   printf("{txt}defined, ") 
		else if (status==601) printf("{err}undefined, ")
		else                  printf("{txt}defined, {err}has errors, ")

		printf("{txt}used by %s\n", 
			length(varnames)==1 ? "variable" : "variables")

		printf("{p 29 19 2}\n") 
		printf(invtokens(varnames'))
		printf("\n")
		printf("{p_end}\n")
	}

	if (rc_overall) {
		printf(rc0 ? "{txt}\n" : "{err}\n")
		printf("%s\n", 
		       "undefined or defined-with-errors {bf:%tb} formats")
		if (!rc0) exit(rc_overall)
	}

	for (j=length(fmtnames); j>=1; j--) {
		varnames = J(0, 1, "")
		for (i=1; i<=length(vidx); i++) {
                        if (tbfmtname(st_varformat(vidx[i])) == fmtnames[j]) {
                                varnames = varnames \ st_varname(i)
                        }
                }
		fmtname = "r(varlist_"+fmtnames[j]+")"
		st_global(fmtname, invtokens(varnames'))
	}		

	st_global("r(defined)",   strtrim(def))
	st_global("r(undefined)", strtrim(undef))
	st_global("r(error)",     strtrim(error))
}

`SS' tbfmtname(`SS' fmt)
{
	`RS'	i 
	`SS'	name 

	if (bsubstr(fmt, 1, 3)!="%tb") return("")
	i = strpos(name = bsubstr(fmt, 4, .), ":")
	return(i==0 ? name : bsubstr(name, 1, i-1))
}
	
void bcal_dir(`SS' upattern, `SS' utestmode)
{
	`RS'		i
	`SS'		pattern, pathlist
	`SC'		files
	`boolean'	testmode
	`SC'		ffname
	`SS'		returnbcals
	`SS'		calendars
	

	testmode = (utestmode!="")
		

	pattern        = (upattern == "" ? "*" : upattern)
	files          = bcal_dir_files(pattern + ".stbcal") 

	if (testmode) ffname = J(length(files), 1, "")

	if (length(files)==0) { 
		printf("{txt}no calendar files matching {bf:%s} found\n",
					pattern) 
		printf("{p 4 4 2}\n")
		printf("No business calendars matching {bf:%s}\n", pattern)
		printf("were found, which is to say, no files matching\n")
		printf("{bf:%s} were found\n", pattern+".stbcal")
		printf("in any of the directories along the {bf:adopath}.\n")
		printf("{p_end}\n") 
	}
	else {
		printf("{txt}  %g calendar file%s found:\n",
			length(files), 
			length(files)==1 ? "" : "s")


		pathlist = c("adopath")
		returnbcals = ""
		for (i=1; i<=length(files); i++) {
			printf("%20uds:  %s\n", 
				pathrmsuffix(files[i]), 
				findfile(files[i], pathlist))
			returnbcals = returnbcals + pathrmsuffix(files[i]) + ": " +findfile(files[i], pathlist) + " "
			if (testmode) {
				ffname[i] = findfile(files[i], pathlist)
			}
		}
	}

	if (testmode) {
		rmexternal("filelist")
		*(crexternal("filelist")) = ffname
		printf("filelist created (testmode)\n")
	}

	calendars = ""
	for (i=length(files); i>=1; i--) {
		st_global("r(fn_"+pathrmsuffix(files[i])+")", findfile(files[i], pathlist))
		calendars = calendars + pathrmsuffix(files[i]) + " "
	}
	st_global("r(calendars)", strtrim(calendars))
}

`SC' bcal_dir_files(`SS' pattern)
{
	`RS'		i, j, a, z ; 
	`SS'		c, ltr, dir
	`SC'		res 
	`SR'		places_to_look
	`boolean'	wildcard

	res            = J(0, 1, "")
	places_to_look = pathlist()
	c              = usubstr(pattern, 1, 1)
	wildcard       = (c=="*" | c=="?")
	a              = ascii("a")
	z              = ascii("z")


	for (i=1; i<=length(places_to_look); i++) { 
		dir = pathsubsysdir(places_to_look[i])
		res = res \ dir(dir, "files", pattern)
		if (wildcard) {
			for (j=a; j<=z; j++) {
				ltr = char(j)
				res = res \ 
			      	      dir(pathjoin(dir,ltr), "files", pattern)
			}
			res = res \ dir(pathjoin(dir,"_"), "files", pattern)
		}
		else {
			res = res \ dir(pathjoin(dir, c), "files", pattern)
		}
	}
	return(uniqrows(res))
}

void  writebcal(string scalar filename,
		string scalar comments_line1,
		string scalar comments_line2,
		real   scalar stata_version,
		string scalar from,
		string scalar diff,
		string scalar include,
		string scalar purpose,
		string scalar dateformat,
		string scalar displayformat,
		string scalar centerdate,
		string scalar mindate_hrf,
		string scalar maxdate_hrf,
		string scalar omitlist,
		real   scalar maxgap)
{
	real 	scalar		fh
	real 	scalar 		oldbreak
	real 	colvector  	diffs 
	real 	colvector  	dates
	real 	scalar		nrows
	real	scalar 		mindate
	real	scalar 		maxdate
	real 	scalar 		i, j
	real 	scalar		omit_date	
	string 	scalar		omit_str
	string  scalar		maxgap_code
	string  scalar		mismatch_code 

	oldbreak = setbreakintr(0)
	fh = st_fopen(filename, "", "w")
	fput(fh, comments_line1)
	fput(fh, comments_line2)
	fput(fh, "")
	fput(fh, "version " + strofreal(stata_version))
	if (purpose != "") {
		fput(fh, `"purpose ""' + purpose + `"""')
	}
	fput(fh, "dateformat " + dateformat)
	fput(fh, "")
	fput(fh, "range " + mindate_hrf + " " + maxdate_hrf)
	fput(fh, "centerdate " + centerdate)
	fput(fh, "")
	if (omitlist != "") fput(fh, "omit dayofweek (" + omitlist + ")")
	
	diffs = st_data(., diff, include) 
	dates = st_data(., from, include)
	nrows = rows(dates)
	mindate = date(mindate_hrf, strupper(dateformat))
	maxdate = date(maxdate_hrf, strupper(dateformat))

	mismatch_code = ""
	maxgap_code   = ""

	if ((dates[1] > mindate) & (dates[1] - maxdate <= maxgap + 1)) {
		for (j=dates[1]-mindate; j > 1; j--) {
			omit_date = dates[1] - j + 1
			if (omitted_as_day(omit_date, omitlist)==0) {
				omit_str = sprintf(displayformat, omit_date)
				fput(fh, "omit date " + omit_str)
			}
		}
		mismatch_code = mismatch_code + "1"
	}

	if (dates[1] - mindate > maxgap + 1) {
		maxgap_code = "1"
	}

	for (i=1; i<=nrows; i++) {
		if (dates[i] < mindate)	{}
		else if (dates[i] > maxdate)	{}
		else if (diffs[i,1] > 1 & diffs[i,1] <= maxgap + 1) {
	 		for (j=diffs[i,1]; j > 1; j--) {
				omit_date = dates[i] - j + 1
				if (omitted_as_day(omit_date, omitlist)==0) {
				  omit_str = sprintf(displayformat, omit_date) 
				  fput(fh, "omit date " + omit_str) 
				}
			}
		}
		else if (diffs[i,1] > maxgap + 1) {
			maxgap_code = "1"	
		}
	}

	if ((maxdate > dates[nrows]) & (maxdate-dates[nrows] <= maxgap+1)) {
		for (j=maxdate - dates[nrows]; j > 1; j--) {
                        omit_date = maxdate - j + 1 
			if (omitted_as_day(omit_date, omitlist)==0) {
				omit_str = sprintf(displayformat, omit_date)
				fput(fh, "omit date " + omit_str)
			}
		}
		mismatch_code = mismatch_code + "2"
	}

	if (maxdate - dates[nrows] > maxgap + 1) {
		maxgap_code = "1"
	}

	st_local("mismatch_code", mismatch_code)
	st_local("maxgap_code", maxgap_code)
	fclose(fh)
	(void) setbreakintr(oldbreak)
}

real scalar omitted_as_day(real scalar date, string scalar omitlist)
{
	string scalar day

	if (dow(date) == 0) day = "Su"
	if (dow(date) == 1) day = "Mo"
	if (dow(date) == 2) day = "Tu"
	if (dow(date) == 3) day = "We"
	if (dow(date) == 4) day = "Th"
	if (dow(date) == 5) day = "Fr"
	if (dow(date) == 6) day = "Sa"

	if (strpos(omitlist, day) == 0) return(0)
	else return(1)
}

void parse_pathname(string scalar pathname, real scalar maxcallength)
{
	string scalar path
	string scalar calname
	string scalar suffix
	string scalar filename
	string scalar returncode
	real scalar isunicode 

	pragma unset path
	pragma unset calname
	pathsplit(pathname, path, calname)
	suffix = pathsuffix(calname)
	calname = pathrmsuffix(calname)
	filename = pathjoin(path, calname+".stbcal")

	st_local("path", path)
	st_local("calname", calname)
	st_local("suffix", suffix)
	st_local("filename", filename)

	returncode = "0"

	isunicode = st_numscalar("c(hasicu)") 
	if(rows(isunicode)==0) {
		isunicode = 0
	}

	if(isunicode == 1) {
		if (direxists(path) == 0)                       returncode = "1"
		else if (ustrtoname(calname) != calname) 	returncode = "2"
		else if (ustrlen(calname) > maxcallength) 	returncode = "3"
		else if (suffix != "" & suffix != ".stbcal" & suffix != ".")
			returncode = "4"	
	}
	else {
		if (direxists(path) == 0)                       returncode = "1"
		else if (strtoname(calname) != calname)		returncode = "2"
		else if (strlen(calname) > maxcallength) 	returncode = "3"
		else if (suffix != "" & suffix != ".stbcal" & suffix != ".")
			returncode = "4"
	}
	st_local("pathname_rc", returncode)
}

void parse_personal(string scalar path)
{
	string scalar returncode

	if (direxists(path) == 0) {
		returncode = "0"
	}
	else {
		returncode = "1"
	}

	st_local("personal_rc", returncode)
}

end

