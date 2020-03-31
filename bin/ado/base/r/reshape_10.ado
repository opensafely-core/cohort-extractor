*! version 4.2.4  19feb2015
program define reshape_10
	version 5.0, missing

	if "`1'"=="clear" {
		char _dta[ReS_ver]
		char _dta[ReS_i]
		char _dta[ReS_j]
		char _dta[ReS_jv]
		char _dta[ReS_Xij]
		char _dta[Res_Xi]
		char _dta[ReS_atwl]
		char _dta[ReS_str]
		exit
	}

	if "`1'"=="wide" | "`1'"=="long" {
		DoNew `*'
		exit
	}

	local syntax : char _dta[ReS_ver]

	if "`1'"=="" | "`1'"==bsubstr("query",1,length("`1'")) {
		if "`syntax'"=="" | "`syntax'"=="v.2" {
			Query
			exit
		}
		local 1 "query"
	}

	if "`syntax'"=="" {
		IfOld `1'
		if `s(oldflag)' {
			DoOld `*'
			char _dta[ReS_ver] "v.1"
		}
		else {
			DoNew `*'
			char _dta[ReS_ver] "v.2"
		}
		exit
	}

	if "`syntax'"=="v.1" {
		DoOld `*'
	}
	else 	DoNew `*'
end

program define IfOld, sclass
	if "`1'"=="" {
		sret local oldflag 0
		exit
	}
	local l = length("`1'")
	if "`1'"==bsubstr("groups",1,`l') | /*
	*/ "`1'"==bsubstr("vars",1,`l') | /*
	*/ "`1'"==bsubstr("cons",1,`l') | /*
	*/ "`1'"==bsubstr("query",1,`l') {
		sret local oldflag 1
		exit
	}
	sret local oldflag 0
end

program define IfNew, sclass
	if "`1'"=="i" | "`1'"=="j" | "`1'"=="xij" | "`1'"=="xi" | /*
	*/ "`1'"=="error" {
		sret local newflag 1
	}
	else	sret local newflag 0
end

program define DoNew
	local c "`1'"
	mac shift

	if "`c'"=="i" {
		if "`*'" == "" { error 198 }
		unabbrev `*', max(10) min(1)
		char _dta[ReS_i] "`s(varlist)'"
		exit
	}


	if "`c'"=="j" {
		J `*'
		exit
	}

	if "`c'"=="xij" {
		Xij `*'
		exit
	}

	if "`c'"=="xi" {
		sret clear
		if "`*'"!="" {
			unabbrev `*'
		}
		char _dta[Res_Xi] "`s(varlist)'"
		exit
	}

	if "`c'"=="" {				/* reshape 		*/
		Query
		exit
	}

	if "`c'"=="long" {			/* reshape long		*/
		if "`1'" != "" {
			Simple long `*'
		}
		capture noisily Long `*'
		Macdrop
		exit _rc
	}


	if "`c'"=="wide" {			/* reshape wide		*/
		if "`1'" != "" {
			Simple wide `*'
		}
		capture noisily Wide `*'
		Macdrop
		exit _rc
	}

	if "`c'"==bsubstr("error",1,max(3,length("`c'"))) {
		capture noisily Qerror `*'
		Macdrop
		exit
	}

	IfOld `c'
	if `s(oldflag)' {
		di in red "may not mix old and new syntax;"
		di in red "either use new syntax or " /*
		*/ _quote "reshape clear" _quote /*
		*/ " and start over using old syntax."
		exit 198
	}
	error 198
end

program define Macdrop
	mac drop ReS_j ReS_jv ReS_i ReS_Xij rVANS Res_Xi /*
	*/ ReS_atwl ReS_str S_1 S_2
end

program define ReportL /* old_obs old_vars */
	Report1 `1' `2' wide long

	local n : word count $ReS_jv
	di in gr "j variable (`n' values)" _col(43) "->" _col(48) /*
	*/ in ye "$ReS_j"
	di in gr "xij variables:"
	parse "$ReS_Xij", parse(" ")
	while "`1'"!="" {
		RepF "`1'"
		local skip = 39 - length("$S_1")
		di in ye _skip(`skip') "$S_1" _col(43) in gr "->" /*
		*/ in ye _col(48) "$S_2"
		mac shift
	}
	di in smcl in gr "{hline 77}"
end

program define RepF /* element from ReS_Xij */
	local v "`1'"
	if "$ReS_jv2" != "" {
		local n : word count $ReS_jv2
		parse "$ReS_jv2", parse(" ")
	}
	else {
		local n : word count $ReS_jv
		parse "$ReS_jv", parse(" ")
	}
	if `n'>=1 {
		Subname `v' `1'
		local list $S_1
	}
	if `n'>=2 {
		Subname `v' `2'
		local list `list' $S_1
	}
	if `n'==3 {
		Subname `v' ``n''
		local list `list' $S_1
	}
	else if `n'>3 {
		Subname `v' ``n''
		local list `list' ... $S_1
	}
	Subname `v' $ReS_atwl
	global S_2 $S_1
	global S_1 `list'
end


program define Report1 /* <#oobs> <#ovars> {wide|long} {long|wide} */
	local oobs "`1'"
	local ovars "`2'"
	local wide "`3'"
	local long "`4'"

	di in smcl _n in gr /*
	*/ "Data" _col(36) "`wide'" _col(43) "->" _col(48) "`long'" /*
	*/ _n "{hline 77}"

	di in gr "Number of obs." _col(32) in ye %8.0g `oobs' /*
	*/ in gr _col(43) "->" in ye %8.0g _N

	quietly desc, short

	di in gr "Number of variables" _col(32) in ye %8.0g `ovars' /*
	*/ in gr _col(43) "->" in ye %8.0g r(k)
end

program define ReportW /* old_obs old_vars */
	Report1 `1' `2' long wide

	local n : word count $ReS_jv2
	local col = 31+(9-length("$ReS_j"))
	di in gr "j variable (`n' values)" /*
		*/ _col(`col') in ye "$ReS_j" in gr _col(43) "->" /*
		*/ _col(48) "(dropped)"
	di in gr "xij variables:"
	parse "$ReS_Xij", parse(" ")
	while "`1'"!="" {
		RepF "`1'"
		local skip = 39 - length("$S_2")
		di in ye _skip(`skip') "$S_2" _col(43) in gr "->" /*
		*/ in ye _col(48) "$S_1"
		mac shift
	}
	di in smcl in gr "{hline 77}"
end





program define Simple /* {wide|long} <funnylist>, i(varlist)
					[j(varname [values])] */
	local cmd "`1'"
	mac shift
	parse "`*'", parse(" ,")
	while "`1'"!="" & "`1'"!="," {
		local list `list' `1'
		mac shift
	}
	if "`list'"=="" {
		error 198
	}
	if "`1'" != "," {
		di in red "option i() required"
		exit 198
	}
	local options "I(string) J(string) ATwl(string) String"
	parse "`*'"
	if "`i'"=="" {
		di in red "option i() required"
		exit 198
	}
	unabbrev `i'
	local i "`s(varlist)'"

	if "`j'" != "" {
		parse "`j'", parse(" ")
		local jvar "`1'"
		mac shift
		local jvals "`*'"
	}
	else 	local jvar "_j"

	if "`cmd'"=="wide" {
		/* When reshaping wide we can -unab- the variable list */
		capture unab list : `list' /* ignore _rc, error caught later */
		/* When reshaping wide we can -unab- the j variable */
		capture unab jvar : `jvar' /* use -unab- not -ConfVar- here */
/*  old code
		capture ConfVar `jvar'
*/
		if _rc {
			if _rc==111 {
				di in red "`jvar' not found -- " _c
				if "`jvar'"=="_j" {
					di in red "specify j() option"
				}
				else	di in red "data already wide"
				exit 111
			}
			ConfVar `jvar'
			exit 198	/* just in case */
		}
	}
	else {
		capture confirm new var `jvar'
		if _rc {
			if _rc==110 {
				di in red /*
			*/ "`jvar' already defined -- data already long"
				exit 110
			}
			confirm new var `jvar'
			exit 198	/* just in case */
		}
	}

	if "`atwl'"!="" {
		local atwl "atwl(`atwl')"
	}
	if "`string'" != "" {
		local string ", string"
	}

	reshape clear
	reshape i `i'
	reshape j `jvar' `jvals' `string'
	reshape xij `list' `atwl'
end

program define Xij /* <names-maybe-with-@>[, atwl(string) */
	if "`*'"=="" { error 198 }
	parse "`*'", parse(" ,")
	while "`1'" != "" & "`1'"!="," {
		local list "`list' `1'"
		mac shift
	}
	if "`list'"=="" {
		error 198
	}
	local list `list'
	if "`1'"=="," {
		local options "ATwl(string)"
		parse "`*'"
	}
	char _dta[ReS_Xij] "`list'"
	char _dta[ReS_atwl] "`atwl'"
end

program define DoOld
	local c "`1'"
	local l = length("`c'")
	mac shift

	if "`c'"==bsubstr("groups",1,`l') {
		if "`2'" == "" {
			error 198
		}
		DoNew j `*'
		exit
	}
	if "`c'"==bsubstr("vars",1,`l') {
		DoNew xij `*'
		exit
	}
	if "`c'"==bsubstr("cons",1,`l') {
		DoNew i `*'
		exit
	}
	if "`c'"==bsubstr("query",1,`l') {
		local cons   : char _dta[ReS_i]
		local grpvar : char _dta[ReS_j]
		local values : char _dta[ReS_jv]
		local vars   : char _dta[ReS_Xij]
		local car    : char _dta[Res_Xi]
		di "group var:  `grpvar'"
		di "values:     `values'"
		di "cons:       `cons'"
		di "vars:       `vars'"
		exit
	}
	if "`c'"=="wide" {
		DoNew wide `*'
		exit
	}
	if "`c'"=="long" {
		DoNew long `*'
		exit
	}
	IfNew `c'
	if `s(newflag)' {
		di in red "may not mix old and new syntax;"
		di in red "either use old syntax or " /*
		*/ _quote "reshape clear" _quote /*
		*/ " and start over using new syntax."
		exit 198
	}
	error 198
end



program define Query
	if "`*'"!="" {
		error 198
	}
	local cons   : char _dta[ReS_i]
	local grpvar : char _dta[ReS_j]
	local values : char _dta[ReS_jv]
	local vars   : char _dta[ReS_Xij]
	local car    : char _dta[Res_Xi]
	local atwl   : char _dta[ReS_atwl]
	local isstr  : char _dta[ReS_str]

	if "`grpvar'"!="" {
		capture ConfVar `grpvar'
		if _rc {
			di _n in ye " (data is wide)"
		}
		else	di _n in ye " (data is long)"
	}
	else	di

	if "`cons'"=="" {
		local ccons "in gr"
		local cons "<varlist>"
	}

	if "`grpvar'"=="" {
		local cgrpvar "in gr"
		local grpvar "<varname>"
		if "`values'"=="" {
			local values "[<#> - <#>]"
		}
	}
	else if `isstr' {
		local values "`values', string"
	}

	if "`vars'"=="" {
		local cvars "in gr"
		local vars "<varnames-without-#j-suffix>"
	}
	else {
		if "`atwl'" != "" {
			local vars "`vars', atwl(`atwl')"
		}
	}
	if "`car'"=="" {
		local ccar "in gr"
		local car "<varlist>"
	}

	di in smcl in gr "{c TLC}{hline 30}{c TT}{hline 46}{c TRC}" _n /*
	*/ "{c |} Xij" _col(32) "{c |} Command/contents" _col(79) "{c |}" _n /*
	*/ in gr "{c LT}{hline 30}{c +}{hline 46}{c RT}"

	di in smcl in gr /*
	*/ "{c |} Subscript i,j definitions:" _col(32) "{c |}" _col(79) "{c |}"

	di in smcl in gr /*
	*/ "{c |}  group id variable(s)" _col(32) "{c |} reshape i " _c
	Qlist 44 "`ccons'" `cons'

	di in smcl in gr /*
	*/ "{c |}  within-group variable" _col(32) "{c |} reshape j " _c

	Qlist 44 "`cgrpvar'" `grpvar' `values'
	di in smcl in gr /*
	*/ "{c |}   and its range" _col(32) "{c |}" _col(79) "{c |}"

	di in smcl in gr "{c |}" _col(32) "{c |}" _col(79) "{c |}"

	di in smcl in gr /*
	*/ "{c |} Variable X definitions:" _col(32) "{c |}" _col(79) "{c |}"

	di in smcl in gr /*
	*/ "{c |}  varying within group" _col(32) "{c |} reshape xij " _c
	Qlist 46 "`cvars'" `vars'

	di in smcl in gr /*
	*/ "{c |}  constant within group (opt) {c |} reshape xi  " _c
	Qlist 46 "`ccar'" `car'

	di in smcl in gr "{c BLC}{hline 30}{c BT}{hline 46}{c BRC}"

	local cons   : char _dta[ReS_i]
	local grpvar : char _dta[ReS_j]
	local values : char _dta[ReS_jv]
	local vars   : char _dta[ReS_Xij]
	local car    : char _dta[Res_Xi]

	if "`cons'"=="" {
		di in gr "First type " _quote in white /*
		*/ "reshape i" in gr _quote /*
		*/ " to define the i variable."
		exit
	}
	if "`grpvar'"=="" {
		di in gr "Type " _quote in wh /*
		*/ "reshape j" in gr _quote /*
		*/ " to define the j variable and, optionally, values."
		exit
	}
	if "`vars'"=="" {
		di in gr "Type " _quote in wh /*
		*/ "reshape xij" in gr _quote /*
		*/ " to define variables that vary within i."
		exit
	}
	if "`car'"=="" {
		di in gr /*
	*/ "Optionally type " _quote in wh "reshape xi" in gr _quote /*
	*/ " to define variables that are constant within i."
	}
	capture ConfVar `grpvar'
	if _rc {
		di in gr "Type " _quote in wh "reshape long" in gr _quote /*
		*/ " to convert the data to long form."
		exit
	}
	di in gr "Type " _quote in wh "reshape wide" in gr _quote /*
		*/ " to convert the data to wide form."
end

program define Qlist /* col <optcolor> stuff */
	local col `1'
	local clr "`2'"
	mac shift 2
	while "`1'" != "" {
		local l = length("`1'")
		if `col' + `l' + 1 >= 79 {
			local skip = 79 - `col'
			di in smcl in gr _skip(`skip') "{c |}" _n /*
			*/ "{c |}" _col(32) "{c |} " _c
			local col 34
		}
		di in ye `clr' "`1' " _c
		local col = `col' + `l' + 1
		mac shift
	}
	local skip = 79 - `col'
	di in smcl in gr _skip(`skip') "{c |}"
end

program define Qerror
	Macros
	Macros2 preserve
	capture ConfVar $ReS_j
	if _rc==0 {
		QerrorW
	}
	else	QerrorL
end


/* ------------------------------------------------------------------------ */
program define Wide		/* reshape wide */
	local oldobs = _N
	quietly describe, short
	local oldvars = r(k)

	Macros
	capture ConfVar $ReS_j
	if _rc {
		di in blu "(already wide)"
		exit
	}
	ConfVar $ReS_j
	confirm var $ReS_j $rVANS $ReS_i $Res_Xi
	capture ConfVar _merge
	if _rc ==0 {
		di in red "cannot convert data containing variable _merge;"
		di in red "drop or rename _merge"
		exit 110
	}

	preserve
	Macros2
	if $S_1 {
		restore, preserve
	}
	ConfVar $ReS_j
	confirm var $ReS_j $Res_Xi

	Veruniq

/*
	Organization:
		dataset dscons:		(may not exist)
			$ReS_i		(1 obs per $ReS_i)
			$Res_Xi

		dataset dsvars:
			$ReS_i		(many obs per $ReS_i)
			$ReS_j
			$ReS_Xij

		dataset dsnew:
			$ReS_i		(1 obs per $ReS_i)
			<widened $VARS>
			<$Res_Xi>

	Note, ("`dscons'"!="") == ("$ReS_i"!="")
*/

	tempfile dsnew dsvars hold
	if "$Res_Xi" != "" {
		tempfile dscons
	}
	quietly {
		keep $ReS_j $rVANS $ReS_i $Res_Xi
		sort $ReS_i $ReS_j
		if "`dscons'"!="" {
			save "`dscons'", replace    /* temporarily */
			drop $Res_Xi
			save "`dsvars'", replace
			use "`dscons'", clear
		}
		else	save "`dsvars'", replace

		by $ReS_i: keep if _n==1
		if "`dscons'"!="" {
			keep $ReS_i $Res_Xi
			save "`dscons'", replace
		}
		keep $ReS_i
		save "`dsnew'", replace

	/* datasets initialized, now step through each value: */

		globa ReS_jv2
		parse "$ReS_jv", parse(" ")
		while "`1'" != "" {
			use "`dsvars'", clear
			if $ReS_str {
				keep if $ReS_j=="`1'"
			}
			else 	keep if $ReS_j == `1'
			if _N==0 {
				noi di in bl /*
				*/ "(note: no data for $ReS_j == `1')"
				capture use "`dsnew'", replace
			}
			else {
				global ReS_jv2 $ReS_jv2 `1'
				drop $ReS_j
				noisily Widefix `1'
				save "`hold'", replace
				use "`dsnew'", clear
				merge $ReS_i using "`hold'"
				drop _merge
				sort $ReS_i
				save "`dsnew'", replace
			}
			mac shift
		}
		if "`dscons'" != "" {
			merge $ReS_i using "`dscons'"
			drop _merge
		}
	}
	global S_FN
	global S_FNDATE
	if "`syntax'" != "v.1" {
		sort $ReS_i
	}
	restore, not

	local syntax: char _dta[ReS_ver]
	if "`syntax'" != "v.1" {
		ReportW `oldobs' `oldvars'
	}
end

program define Veruniq
	sort $ReS_i $ReS_j
	capture by $ReS_i $ReS_j: assert _N==1
	if _rc {
		di in red "$ReS_j not unique within $ReS_i;"
		di in red /*
		*/ "there are multiple observations at the same $ReS_j" /*
		*/ " within $ReS_i."
		di in red "Type " _quote "reshape error" _quote /*
		*/ " for a listing of the problem observations."
		exit 9
	}
	if "$Res_Xi"=="" {
		exit
	}
	sort $ReS_i $Res_Xi $ReS_j
	tempvar cnt1 cnt2
	quietly by $ReS_i: gen `c(obs_t)' `cnt1' = _N
	quietly by $ReS_i $Res_Xi: gen `c(obs_t)' `cnt2' = _N
	capture assert `cnt1' == `cnt2'
	if _rc==0 {
		exit
	}
	parse "$Res_Xi", parse(" ")
	while "`1'"!=""  {
		capture by $ReS_i: assert `1'==`1'[1]
		if _rc {
			di in red "`1' not constant within $ReS_i"
		}
		mac shift
	}
	di in red "Type " _quote "reshape error" _quote /*
		*/ " for a listing of the problem observations."
	exit 9
end

program define QerrorW
	ConfVar $ReS_j
	confirm var $ReS_j $ReS_Xij $ReS_i $Res_Xi
	sort $ReS_i $ReS_j
	capture by $ReS_i $ReS_j: assert _N==1
	if _rc {
		Msg1
		di in gr /*
	*/ "The data are in the long form;  j should be unique within i." _n
		di in gr /*
		*/ "There are multiple observations on the same " /*
		*/ in ye "$ReS_j" in gr " within " /*
		*/ in ye "$ReS_i" in gr "." _n

		tempvar bad
		quietly by $ReS_i $ReS_j: gen byte `bad' = _N!=1
		quietly count if `bad'
		di in gr /*
		*/ "The following " r(N) /*
		*/ " of " _N /*
		*/ " observations have repeated $ReS_j values:"
		list $ReS_i $ReS_j if `bad'
		di in gr _n "(data now sorted by $ReS_i $ReS_j)"
		exit
	}
	if "$Res_Xi"=="" {
		di in gr "$ReS_j is unique within $ReS_i;"
		di in gr "there is no error with which " /*
		*/ _quote "reshape error" _quote " can help."
		exit
	}
	sort $ReS_i $Res_Xi $ReS_j
	tempvar cnt1 cnt2
	quietly by $ReS_i: gen `c(obs_t)' `cnt1' = _N
	quietly by $ReS_i $Res_Xi: gen `c(obs_t)' `cnt2' = _N
	capture assert `cnt1' == `cnt2'
	if _rc==0 {
		di in gr "$ReS_j is unique within $ReS_i and"
		di in gr "all the " _quote "reshape xi" _quote /*
		*/ " variables are constant within $ReS_j;"
		di in gr "there is no error with which " /*
		*/ _quote "reshape error" _quote " can help."
		exit
	}

	Msg1
	local n : word count $ReS_Xij
	if `n'==1 {
		di in gr "xij variable is " in ye "$ReS_Xij" in gr "."
	}
	else	di in gr "xij variables are " in ye "$ReS_Xij" in gr "."
	di in gr "Thus, the following variable(s) should be constant within i:"
	di in ye _col(7) "$Res_Xi"

	sort $ReS_i $ReS_j
	tempvar bad
	parse "$Res_Xi", parse(" ")
	while "`1'"!=""  {
		capture by $ReS_i: assert `1'==`1'[1]
		if _rc {
			qui by $ReS_i: gen long `bad' = /*
				*/ cond(_n==_N,sum(`1'!=`1'[1]),0)
			qui count if `bad'
			di _n in ye "`1'" in gr " not constant within i (" /*
				*/ in ye "$ReS_i" in gr ") for " /*
				*/ r(N) " value" _c
			if r(N)==1 {
				di in gr " of i:"
			}
			else	di in gr "s of i:"
			qui by $ReS_i: replace `bad' = `bad'[_N]
			list $ReS_i $ReS_j `1' if `bad'
			drop `bad'
		}
		mac shift
	}
	di in gr _n "(data now sorted by $ReS_i $ReS_j)"
end
program define Msg1
	di _n in gr "i (" in ye "$ReS_i" in gr /*
	*/ ") indicates the top-level grouping such as subject id."
	di in gr "j (" in ye "$ReS_j" in gr /*
	*/ ") indicates the subgrouping such as time."
end

/*
	Widefix #

	Assumption when called:  currently in memory are single observations
	per $ReS_i corresponding to $ReS_j==#

	go through $ReS_Xij and rename each ${ReS_Xij}#
*/


program define Widefix /* # */ /* reshape wide utility */
	local val "`1'"
	parse "$ReS_Xij", parse(" ")
	while "`1'" != "" {
		Subname `1' `val'
		local new $S_1
		capture confirm new var `new'
		if _rc {
			capture confirm var `new'
			if _rc {
				di in red "`new' invalid name"
				exit 198
			}
			else {
				di in red "`new' already defined"
				exit 110
			}
		}
		Subname `1' $ReS_atwl
		rename $S_1 `new'
		label var `new' "`val' $S_1"
		mac shift
	}
end
/* ------------------------------------------------------------------------ */



program define Long 		/* reshape long */
	local oldobs = _N
	quietly describe, short
	local oldvars = r(k)

	Macros
	confirm var $ReS_i $Res_Xi
	capture confirm new var $ReS_j
	if _rc {
		di in blu "(already long)"
		exit
	}
	preserve
	Macros2
	if $S_1 {
		restore, preserve
	}
	confirm var $ReS_i $Res_Xi

	tempfile new
	Verluniq
	quietly {
		mkrtmpST
		drop _all
		set obs 1
		if $ReS_str {
			gen str32 $ReS_j = ""
		}
		else	gen float $ReS_j = .
		save "`new'", replace
		parse "$ReS_jv", parse(" ")
		while "`1'"!="" {
			restore, preserve
			noisily Longdo `1'
			append using "`new'"
			save "`new'", replace
			mac shift
		}
		if $ReS_str {
			drop if $ReS_j == ""
		}
		else	drop if $ReS_j >= .
		global rtmpST
		compress $ReS_j
	}
	global S_FN
	global S_FNDATE
	local syntax: char _dta[ReS_ver]
	if "`syntax'" != "v.1" {
		order $ReS_i $ReS_j
		sort $ReS_i $ReS_j
	}
	restore, not

	if "`syntax'" != "v.1" {
		ReportL `oldobs' `oldvars'
	}
end

program define Verluniq
	local id : char _dta[ReS_i]
	sort `id'
	capture by `id': assert _N==1
	if _rc {
		di in red "i=`id' does not uniquely identify the observations;"
		di in red "there are multiple observations " /*
		*/ "with the same value of `id'."
		di in red "Type " _quote "reshape error" _quote /*
		*/ " for a listing of the problem observations."
		exit 9
	}
end

program define QerrorL
	confirm var $ReS_i
	local id "$ReS_i"
	sort `id'
	tempvar bad
	quietly by `id': gen byte `bad' = _N!=1
	capture assert `bad'==0
	if _rc==0 {
		di in gr "`id' is unique; there is no problem on this score"
		exit
	}
	di _n in gr "i (" in ye "`id'" in gr /*
	*/ ") indicates the top-level grouping such as subject id."
	di _n in gr /*
*/ "The data are currently in the wide form; there should be a single" /*
	*/ _n "observation per i."
	quietly count if `bad'
	di _n in gr r(N) " of " _N /*
	*/ " observations have duplicate i values:"
	list `id' if `bad'
	di in gr _n "(data now sorted by `id')"
end

program define mkrtmpST
	global rtmpST
	parse "$ReS_Xij", parse(" ")
	while "`1'" != "" {
		local ct "empty"
		local i 1
		local val : word `i' of $ReS_jv
		while "`val'" != "" {
			Subname `1' `val'
			local van "$S_1"
			capture confirm var `van'
			if _rc==0 {
				local nt : type `van'
				Recast "`ct'" `nt'
				local ct "$S_1"
				if "`ct'"=="" {
noi di in red "`van' type mismatch with other `1' variables"
					exit 198
				}
			}
			else {
				capture confirm new var `van'
				if _rc {
					di in red /*
					*/ "`van' implied name too long"
					exit 198
				}
			}
			local i=`i'+1
			local val : word `i' of $ReS_jv
		}
		if "`ct'"=="empty" {
			local ct "byte"
		}
		global rtmpST "$rtmpST `ct'"
		mac shift
	}
end

program define Longdo /* reshape long dolist utility */
	local val "`1'"
	parse "$ReS_Xij", parse(" ")
	local i 1
	while "``i''" != "" {
		Subname ``i'' `val'
		local van "$S_1"
		local vlist "`vlist' `van'"
		local typ : word `i' of $rtmpST
		local novar 1
		capture confirm var `van'
		if _rc == 0 {
			capture confirm new var `van'
			if _rc {
				local novar 0
			}
		}
		if `novar' {
			di in bl "(note: `van' not found)"
			if bsubstr("`typ'",1,3)=="str" {
				quietly gen `typ' `van' = ""
			}
			else	quietly gen `typ' `van' = .
		}
		else 	recast `typ' `van'
		local i=`i'+1
	}
	keep $ReS_i $Res_Xi `vlist'
	if $ReS_str {
		qui gen str32 $ReS_j = "`val'"
	}
	else	qui gen float $ReS_j = `val'
	parse "$ReS_Xij", parse(" ")
	while "`1'" != "" {
		Subname `1' `val'
		local van "$S_1"
		Subname `1' $ReS_atwl
		local nvan "$S_1"
		rename `van' `nvan'
		label var `nvan'
		mac shift
	}
end



program define Recast /* recast command to maintain precision */
	if "`1'"=="empty" | "`1'"=="`2'" {
		global S_1 "`2'"
		exit
	}

	local a "`1'"
	local b "`2'"

	local aisstr = bsubstr("`a'",1,3)=="str"
	local bisstr = bsubstr("`b'",1,3)=="str"
	if `aisstr'!=`bisstr' {
		global S_1
		exit
	}

	if "`a'"=="byte" {
		global S_1 "`b'"
		exit
	}

	global S_1 "`a'"
	if "`a'"=="int" {
		if "`b'"!="byte" {
			global S_1 "`b'"
		}
		exit
	}
	if "`a'"=="long" {
		if "`b'"!="byte" & "`b'"!="int" {
			global S_1 "`b'"
		}
		exit
	}

	if "`a'"=="float" {
		if "`b'"=="`double'" {
			global S_1 "`b'"
		}
		exit
	}
	if "`a'"=="double" { exit }

	local l1 = real(bsubstr("`a'",4,.))
	local l2 = real(bsubstr("`b'",4,.))
	if `l2'>`l1' {
		global S_1 "`b'"
	}
end


program define J /* reshape j [ #[-#] [...] | <str> <str> ...] [, string] */
	if "`*'"=="" {
		error 198
	}
	parse "`*'", parse(" -,")
	local grpvar "`1'"
	mac shift

	local isstr 0
	while "`1'"!="" & "`1'"!="," {
		if "`2'" == "-" {
			local i1 `1'
			local i2 `3'
			confirm integer number `i1'
			confirm integer number `i2'
			if `i1' >= `i2' {
				di in red "`i1'-`i2':  invalid range"
				exit 198
			}
			while `i1' <= `i2' {
				local values `values' `i1'
				local i1 = `i1' + 1
			}
			mac shift 3
		}
		else {
			capture confirm integer number `1'
			local isstr = `isstr' | _rc
			local values `values' `1'
			mac shift
		}
	}

	if "`1'"=="," {
		local options "String"
		parse "`*'"
		if `isstr' & "`string'"=="" {
			di in red /*
*/ "must also specify string option if string values are to be specified"
			exit 198
		}
		if "`string'"!="" {
			local isstr 1
		}
	}
	Chkj `grpvar' `isstr'
	char _dta[ReS_j] "`grpvar'"
	char _dta[ReS_jv] "`values'"
	char _dta[ReS_str] `isstr'
end

program define Chkj /* j whether-string */
	local grpvar "`1'"
	local isstr `2'

	capture ConfVar `grpvar'
	if _rc { exit }

	capture confirm string var `grpvar'
	if _rc==0 {
		if !`isstr' {
			di in red "`grpvar' is string; specify string option"
			exit 109
		}
	}
	else {
		if `isstr' {
			di in red "`grpvar' is numeric"
			exit 109
		}
	}
end



program define Macros	/* reshape macro check utility */
	global ReS_j : char _dta[ReS_j]
	global ReS_jv : char _dta[ReS_jv]
	global ReS_jv2
	global ReS_i   : char _dta[ReS_i]
	global ReS_Xij   : char _dta[ReS_Xij]
	global Res_Xi    : char _dta[Res_Xi]
	global ReS_atwl   : char _dta[ReS_atwl]
	global ReS_str  : char _dta[ReS_str]
	local syntax   : char _dta[ReS_ver]

	if "$ReS_j"=="" {
		if "`syntax'"=="v.1" {
			NotDefd "reshape groups"
		}
		else	NotDefd "reshape j"
	}

	capture ConfVar $ReS_j
	if _rc==0 {
		Chkj $ReS_j $ReS_str
		if $ReS_str==0 {
			capture assert $ReS_j<.
			if _rc {
				di in red "$ReS_j contains missing values"
				exit 498
			}
		}
		else {
			capture assert trim($ReS_j)!=""
			if _rc {
				di in red "$ReS_j contains missing values"
				exit 498
			}
			capture assert $ReS_j==trim($ReS_j)
			if _rc {
				di in red /*
				*/ "$ReS_j has leading or trailing blanks"
				exit 498
			}
		}
	}

	if "$ReS_jv"=="" {
		if "`syntax'"=="v.1" {
			NotDefd "reshape groups"
		}
	}
	if "$ReS_i"=="" {
		if "`syntax'"=="v.1" {
			NotDefd "reshape cons"
		}
		else	NotDefd "reshape i"
	}
	if "$ReS_Xij"=="" {
		if "`syntax'"=="v.1" {
			NotDefd "reshape vars"
		}
		else	NotDefd "reshape xij"
	}

	global rVANS
	parse "$ReS_Xij", parse(" ")
	local i 1
	while "``i''"!="" {
		Subname ``i'' $ReS_atwl
		global rVANS "$rVANS $S_1"
		local i = `i' + 1
	}
	global S_1
end

program define Macros2 /* [preserve] */ /* returns S_1 */
	local preserv "`1'"
				/* determine whether anything to do	*/
	capture ConfVar $ReS_j
	local islong = (_rc==0)
	local dovalW 0
	local dovalL 0
	local docar 0
	if "$ReS_jv"=="" {
		if `islong' {
			local dovalL 1
		}
		else	local dovalW 1
	}
	if "$Res_Xi"=="" {
		local syntax : char _dta[ReS_ver]
		if "`syntax'"=="v.2" {
			local docar 1
		}
	}

	if `dovalL' {
		FillvalL
	}

				/* nothing to do 			*/
	if `dovalW'==0 & `docar'==0 {
		global S_1 0 	/* S_1==0 -> data in memory unchanged 	*/
		exit
	}

				/* convert data to names		*/
	`preserv'
	local varlist "req ex"
	parse "_all"
	quietly {
		drop _all
		local n : word count `varlist'
		set obs `n'
		gen str32 name = ""
		parse "`varlist'", parse(" ")
		local i 1
		while `i' <= `n' {
			replace name = "``i''" in `i'
			local i = `i' + 1
		}
	}

				/* call Fillval and FillXi as required	*/
	if `dovalW' & `docar' {
		tempfile dsname
		quietly save "`dsname'"
		FillvalW
		quietly use "`dsname'", clear
		FillXi `islong'
	}
	else if `dovalW' {
		FillvalW
	}
	else 	FillXi `islong'

	global S_1 1
end



program define NotDefd /* <message> */
	di in red _quote "`*'" _quote " not defined"
	exit 111
end

program define FillXi /* {1|0} */ /* 1 if islong currently */
	local islong `1'
	quietly {
		if `islong' {
			Dropout name $ReS_j $ReS_i
			parse "$ReS_Xij", parse(" ")
			local i 1
			while "``i''" != "" {
				Subname ``i'' $ReS_atwl
				drop if name=="$S_1"
				local i = `i' + 1
			}
		}
		else { 					/* wide */
			Dropout name $ReS_j $ReS_i
			parse "$ReS_Xij", parse(" ")
			local i 1
			while "``i''" != "" {
				local j 1
				local jval : word `j' of $ReS_jv
				while "`jval'"!="" {
					Subname ``i'' `jval'
					drop if name=="$S_1"
					local j = `j' + 1
					local jval : word `j' of $ReS_jv
				}
				local i = `i' + 1
			}
		}
		local i 1
		while `i' <= _N {
			local nam = name[`i']
			global Res_Xi $Res_Xi `nam'
			local i = `i' + 1
		}
	}
end

program define Dropout /* varname varnames */
	local name "`1'"
	local i 2
	while "``i''"!="" {
		drop if `name'=="``i''"
		local i = `i' + 1
	}
end


program define FillvalL
	Tab $ReS_j
end


program define Tab /* varname */
	local v "`1'"
	global ReS_jv
	capture confirm string variable `v'
	if _rc {
		tempname rows
		capture tabulate `v', matrow(`rows')
		if _rc {
			if _rc==1 { 
				exit 1 
			}
			local bad 1
		}
		else {
			capture mat list `rows'
			local bad = _rc
		}
		if `bad' {
			if _rc==134 {
				di in red "$ReS_j takes on too many values"
				exit 134
			}
			else {
				/* theoretically cannot happen */
				di in red "$ReS_j contains all missing values"
				exit 498
			}
		}
		local n = rowsof(`rows')
		local i 1
		while `i' <= `n' {
			local el = `rows'[`i',1]
			global ReS_jv $ReS_jv `el'
			local i = `i' + 1
		}
	}
	else {				/* string ReS_j	*/
		quietly {
			sort `v'
			tempvar one
			by `v': gen byte `one' = _n>1
			sort `one' `v'
			local i 1
			while `one'[`i']==0 {
				local el = `v'[`i']
				global ReS_jv $ReS_jv `el'
				local i = `i' + 1
			}
		}
	}
	di in gr "(note: j = $ReS_jv)"
end

program define FillvalW
	parse "$ReS_Xij", parse(" ")
	tempvar u res
	quietly {
		local i 1
		gen str32 `res' = ""
		while "``i''" != "" {
			local l = index("``i''","@")
			local l = cond(`l'==0, length("``i''")+1,`l')
			local lft = bsubstr("``i''",1,`l'-1)
			local rgt = bsubstr("``i''",`l'+1,.)
			local rgtl = length("`rgt'")
			local minl = length("`lft'") + `rgtl'
			gen byte `u' = length(name)>`minl' & /*
				*/ bsubstr(name,1,`l'-1)=="`lft'" & /*
				*/ bsubstr(name,-`rgtl',.) == "`rgt'"
/*
capture assert `res'=="" if `u'
if _rc {
	di in red "logic error"
noi list
	exit 9998
}
*/
			replace `res' = bsubstr(name,`l',.) if `u'
			replace `res' = bsubstr(`res',1,length(`res')-`rgtl') /*
				*/ if `u'
			capture assert `res'!="" if `u'
			if _rc {
				di in red "variable `lft'`rgt' already defined"
				exit 110
			}
			drop `u'
			local i = `i' + 1
		}
		capture assert `res'==""
		if _rc==0 {
			di in red "no xij variables found"
			exit 111
		}
	}
	if !$ReS_str {
		tempvar num
		qui gen float `num' = real(`res') if `res'!=""
		Tab `num'
	}
	else	Tab `res'
end


program define Subname /* <name-maybe-with-@> <tosub> */
	local name "`1'"
	local sub "`2'"
	local l = index("`name'","@")
	local l = cond(`l'==0, length("`name'")+1,`l')
	local a = bsubstr("`name'",1,`l'-1)
	local c = bsubstr("`name'",`l'+1,.)
	global S_1 "`a'`sub'`c'"
end

program define ConfVar /* varname */
	version 6, missing
	capture syntax varname
	if _rc == 0 {
		gettoken lhs : 0
		if `"`lhs'"' == "`varlist'" {
			exit 0
		}
	}
	di in red `"`0' not found"'
	exit 111
end

exit
